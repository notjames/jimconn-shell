#!/bin/bash

# export EXT=h264 && rename 's/(.*[a-zA-Z0-9])'"$EXT"'/$1.'"$EXT"'/' *$EXT; unset EXT

function cwb
{
  git branch | ggrep -P '^\*' | ggrep -Po '\w+'
}

sm()
{
  CWB=$(cwb)

  if [[ -n "$CWB" ]]
  then
    git checkout master && \
    git fetch upstream && \
    git reset --hard upstream/master && \
    git checkout "$CWB"
    git push

    if [ "$CWB" != "master" ]; then git merge master;fi
  else
    echo "No working branch here."
  fi
}

# git rebase -i upstream/master
# http://blog.steveklabnik.com/posts/2012-11-08-how-to-squash-commits-in-a-github-pull-request

Lapps()
{
  (nohup ssh -YX vmlinux "(tilix &) && (quassel &) && (gitg &)" >/dev/null 2>&1 &)
}

fix_fsp()
{
  while read -r f
  do
    f=${f#./*}
#   basename=${f%.*}
#   suffix=${f#*.}
    new_f=$(echo "$f" | tr ' ' '_' | \
            gsed -r \
                 -e "s/[,']|[()]|[[]]//g"       \
                 -e "s/\&\#([a-zA-Z0-9]+;|-)//g" \
                 -e 's/[^a-zA-Z0-9]//'          \
                 -e 's/-+|([_\.]?-_)/-/g')

    mv "$f" "$new_f"
  done < <(find . -maxdepth 1 -type f -name '[&a-zA-Z0-9]*.*')
}

yts()
{
  local d
  d=$HOME/Music

  if [[ ! -d "$d" ]]
  then
    mkdir "$d" || \
      {
        echo >&2 "Unable to mkdir $d"
        return $?
      }
  fi

  if cd "$d"
  then
    youtube-dl -x --add-metadata --audio-format m4a -c -o "%(title)s-%(id)s.%(ext)s" "$@"
    fix_fsp && cd - || return
  else
    echo >&2 "unable to chdir $d"
    return 5
  fi
}

yt()
{
  local d
  d=$HOME/videos

  if [[ ! -d "$d" ]]
  then
    mkdir "$d" || \
      {
        echo >&2 "Unable to mkdir $d"
        return $?
      }
  fi

  if cd "$d"
  then
    youtube-dl -f mp4 --add-metadata -ct "$@"
    fix_fsp && cd - || return
  else
    echo >&2 "unable to chdir $d"
    return 5
  fi
}

check_vbox_if()
{
  local hosts_addr

  hosts_addr=$(perl -lne '/(^192.*?)\s+vmlinux/ && print $1' /etc/hosts)
  if [[ "$hosts_addr" != "$VB_ADDR" ]]; then
    fix_vbox_if
  fi
}

fix_vbox_if()
{
  local hosts date ext

  hosts=/etc/hosts

  [[ -f /private/etc/hosts ]] && hosts=/private/etc/hosts

  date=$(date +%Y%m%d-%H%M%S)
  ext=".bak-$date"
  sudo perl -pi"$ext" -e 's/^(Noval.*?\!|(\d{1,3}\.)+\d{1,3})\s+(  vmlinux.*)/'"$VB_ADDR"' $3/' "$hosts"
}

get_vbaddr()
{
# vboxmanage guestproperty enumerate "$VMNAME"  | \
#         ggrep -Po 'V4/IP, value: (\d{1,3}\.)+\d{1,3}' | \
#         ggrep -P '192.*7' | cut -d : -f 2 | tr -d ' '
  vboxmanage guestproperty get "$VMNAME" \
    /VirtualBox/GuestInfo/Net/0/V4/IP | cut -d : -f 2 | \
    tr -d ' '
}


each_cluster()
{
  local amz_cmd
  amz_cmd=$"$*"

  \cat <<E
  awsctx | \
    grep -P '^gen3-' | \
    while read -r acct; do
      unset clusters
      regions=(us-east-1 us-east-2 us-west-1 us-west-2)
      for r in "\${regions[@]}"; do
        ac "\$acct" "\$r"
        $amz_cmd
      done
    done
E
}

amz_lookup_acct_by_amz_id()
{
  id="$1"
  "$HOME"/bin/get-aws-acct-by-id "$id"
}

update_cluster_kubeconfigs()
{
  local dts changed kconfig

  dts="$(date -Iseconds)"
  changed=0
  kconfig=${KUBECONFIG:=$HOME/.kube/config}
  SAVE_AWS_PROFILE="$AWS_PROFILE"
  SAVE_AWS_REGION="$AWS_REGION"
  SAVE_CONTEXT="$(\kubectl config current-context)"

  # prune non-existent clusters from config
  while read -r cluster; do
    IFS=':' read -r _ _ _ region amz_id cluster_name <<< "$cluster"
    acct=$(amz_lookup_acct_by_amz_id "$amz_id")
    cluster_name=${cluster_name/cluster\//}
    ac "$acct" "$region"
    if ! aws eks describe-cluster --name "$cluster_name" --query "cluster.name" --output text >/dev/null 2>&1; then
      if [[ $changed == 0 ]]; then
        if ! cp "$kconfig" "$kconfig.$dts"; then
          echo >&2 'Unable to make backup copy of k8s config, so stopping'
          return 1
        fi
        ((changed++))
      fi
      echo "$cluster no longer exists, so pruning..."
      \kubectl config delete-cluster "$cluster"
      \kubectl config delete-context "$cluster"
    fi
  done <<< "$(\kubectl config get-clusters | ggrep -Pv NAME)"

  awsctx | \
    ggrep -P '^gen3-' | \
    while read -r acct; do
      regions=(us-east-1 us-east-2 us-west-1 us-west-2)
      for r in "${regions[@]}"; do
        echo "Checking for new clusters in: $acct $r"
        ac "$acct" "$r"
        clusters="$(aws eks list-clusters --query "not_null(clusters[])" --output text)"
        if [[ -n "$clusters" ]]; then
          if [[ $changed == 0 ]]; then
            if ! cp "$kconfig" "$kconfig.$dts"; then
              echo >&2 'Unable to make backup copy of k8s config, so stopping'
              return 1
            fi
            ((changed++))
          fi

          for cluster in $clusters; do
            aws eks update-kubeconfig --name "$cluster"
          done
        fi
      done
    done
    # shellcheck disable=SC2046
    export $(awsctx "$SAVE_AWS_PROFILE" "$SAVE_AWS_REGION")
    kubectx "$SAVE_CONTEXT"
}


## blsc env
ac()
{
  # shellcheck disable=SC2046
  export $(awsctx --profile "$1" --region "$2")
}

# remove comments in front of these if skopos is ever decomissioned.
k-check()
{
  # function to alias kubectl
  cmd="$*"
  current_context=$(kubectl config current-context)

  if echo "$current_context" | ggrep -q "$AWS_PROD_USER" && \
     echo "$cmd" | ggrep -Pq '\s*(apply|delete|edit|patch|replace|drain|cordon|rollout|scale|expose|uncordon|taint|drain) '; then
    echo -n "$(tput setaf 7)$(tput setab 1)WARNING: THIS IS PROD!! Press ctrl+c to abort! $(tput sgr0)"
    read -r _
  fi

  # shellcheck disable=SC2086
  \kubectl $cmd
}

k-warning()
{
  echo -n "$(tput setaf 7)$(tput setab 1)YOU ARE TRYING TO USE THE REAL KUBECTL!!! Use \\kubectl!$(tput sgr0)"
}

mkcdir()
{
  if ! mkdir -p "$1"; then
    echo >&2 "exit code: $?"
  fi
  cd "$1"
}

proj()
{
  cd "$HOME"/projects/src/"$*" || return
}

kctx ()
{
    if test -z "$1"; then
        kubectx;
        return 0;
    fi;
    if [[ "$1" != "-" ]] && test -n "$2"; then
        kubectx "$(kubectx | grep "$1")";
        kubens "$2";
        return 0;
    fi;
    if [[ "$1" == - ]] && test -z "$2"; then
        kubectx "$1";
        return 0;
    fi;
    kubectx "$(kubectx | grep "$1")";
    [[ -n "$2" ]] && kubens "$2"
}


# real prod
AWS_PROD_USER=308171672556
# test prod
#AWS_PROD_USER=184966437322

VMNAME="Ubuntu"
VB_ADDR=$(get_vbaddr)

alias ls='ls -G'

[ -x "$(which vim)" ] && alias vi='vim -p'
[ -x "$(which nvim)" ] && alias vi="nvim -p"
#[ -x /usr/local/bin/vimcat ] && alias cat='/usr/local/bin/vimcat -n --colors=256'
[ -x /usr/local/bin/bat ] && alias cat='/usr/local/bin/bat --style full --color=auto --theme=TwoDark'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -x /usr/local/bin/ggrep ] && alias grep='/usr/local/bin/ggrep --color=auto'
[ -f ~/.acd_func.sh ] && source ~/.acd_func.sh

alias grep='ggrep --color=auto'
alias g="/usr/bin/git"

#alias terminix='(nohup ssh -YX vmlinux terminix >/dev/null 2>&1 &)'
alias ls='ls -G'
alias tilix='(nohup ssh -o IdentitiesOnly=yes -i ~/.ssh/id_rsa -YX jimconn@vmlinux tilix >/dev/null 2>&1 &)'
alias tb='(nohup ssh -o IdentitiesOnly=yes -i ~/.ssh/id_rsa -YX jimconn@vmlinux tilix --geometry 230x192+2180+200 >/dev/null 2>&1 &)'
alias dv7='(nohup ssh -o IdentitiesOnly=yes -i ~/.ssh/id_rsa -YX jimconn@dv7 tilix --geometry 230x192+2180+200 >/dev/null 2>&1 &)'
alias k='k-check'
alias kg='\kubectl get -o wide'
alias kga='\kubectl get -o wide --all-namespaces'
alias kgj='\kubectl get -o json'
alias kgd='\kubectl describe'
alias kubectl='k-warning'
alias kgdesc='kubectl describe'
alias rebmas='git fetch --all && git rebase upstream/master'

## go places
alias bu1='cd /Volumes/backup-1'
alias bu2='cd /Volumes/backup-2'

alias ssh="ssh -o IdentitiesOnly=yes"

[[ -x /usr/local/bin/exa ]] && alias nls='/usr/local/bin/exa --reverse --sort=size'
[[ -x /usr/local/bin/gsed ]] && alias sed='/usr/local/bin/gsed'
[[ -x /usr/local/bin/gdate ]] && alias date='gdate'


export VMNAME VB_ADDR
echo 'export VB_ADDR=$(get_vbaddr) && fix_vbox_if'

