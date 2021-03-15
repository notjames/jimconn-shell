#!/bin/bash

which=$(command -v which)
# real prod
AWS_PROD_USER=xxxxxxxxxxxx
# test prod
#AWS_PROD_USER=xxxxxxxxxxxx

get_git_branch()
{
  git rev-parse --abbrev-ref HEAD | grep -v HEAD || \
  git describe --exact-match HEAD 2>/dev/null    || \
  git rev-parse HEAD
}

cnct_clone()
{
  local ghub repo_name client_repo upstream_repo

  ghub="https://github.com/"
  repo_name="${1:?Must provide repo name}"
  client_repo="${ghub}notjames/$repo_name"
  upstream_repo="${ghub}samsung-cnct/$repo_name"

  git clone "$client_repo" && cd "$repo_name" && git remote add upstream "$upstream_repo"
}

fix_fsp()
{
  while read -r f
  do
#   local basename f suffix new_f
    local f new_f

    f="${f#./*}"
#   basename="${f%.*}"
#   suffix="${f#*.}"
    new_f="$(echo "$f" | tr ' ' '_' | \
             sed -r    \
                  -e "s/[,']|[()]|[[]]//g"      \
                  -e "s/\&#([a-zA-Z0-9]+;|-)//g"\
                  -e 's/[^a-zA-Z0-9]//'         \
                  -e 's/-+|([_\.]?-_)/-/g')"

    mv "$f" "$new_f"
  done < <(find . -maxdepth 1 -type f -name '[&a-zA-Z0-9]*.*')
}

yts()
{
  local d
  d=$HOME/Music

  if [[ ! -d "$d" ]]
  then
    mkdir "$d" ||       {
        echo >&2 "Unable to mkdir $d"
        return $?
      }
  fi

  if cd "$d"
  then
    youtube-dl -kx --add-metadata --audio-format m4a -c -o "%(title)s-%(id)s.%(ext)s" "$*"
    fix_fsp && (cd - || true)
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
    mkdir "$d" ||       {
        echo >&2 "Unable to mkdir $d"
        return $?
      }
  fi

  if cd "$d"
  then
    youtube-dl -f mp4 --add-metadata -c "$*"
    fix_fsp && (cd - || true)
  else
    echo >&2 "unable to chdir $d"
    return 5
  fi
}

maas_machine_id()
{
  local id
  id=$1
  [[ -z "$PROFILE" ]] && \
    {
      echo >&2 '$PROFILE must be defined.'
      return 1
    }

  [[ -z "$id" ]] && \
    {
      echo >&2 "Please provide a machine name to seek."
      return 1
    }

  maas "$PROFILE" machines read | \
    jq -Mr --arg name "$id" '
      .[] |
        select(.hostname == $name) |
          .boot_interface.system_id'
}

cwb()
{
  git branch | grep -P '^\*' | awk -F '*' '{print $2}' | tr -d ' '
}

sm()
{
  CWB="$(cwb)"

  git checkout master && \
  git fetch upstream && \
  git reset --hard upstream/master && \
  git pull && git push --force-with-lease

  [[ "$CWB" != "master" ]] && \
    {
      git checkout "$CWB" && \
      git pull --rebase upstream master && \
      git push --force-with-lease
    }
}

maas-all-custom-images()
{
  maas jimconn boot-resources read | jq -Mr '[.[] | select(.id > 300) | .name | select(contains("/") | not) | .]'
}

when()
{
  local the_test
  the_test=$1

  shift
  cmd=$*

  while true; do
    if test ! "$the_test"; then
      $cmd
      return 0
    fi
    sleep 1
  done
}

## blsc env
ac()
{
  # shellcheck disable=SC2046
  export $(awsctx --profile "$1" --region "$2")
}

show_clusters()
{
  awsctx | \
    grep -P '^gen3-' | \
    while read -r acct; do
      unset clusters
      regions=(us-east-1 us-east-2 us-west-1 us-west-2)
      for r in "${regions[@]}"; do
        ac "$acct" "$r"
        clusters="$(aws eks list-clusters --query "not_null(clusters[])" --output text)"
        if [[ -n "$clusters" ]]; then
          echo "$acct: $r"
          echo -e "\t$clusters"
        fi
      done
    done
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
  done <<< "$(\kubectl config get-clusters | grep -Pv NAME)"

  awsctx | \
    grep -P '^gen3-' | \
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
    $HOME/bin/update-cluster-context-starship-toml
    # shellcheck disable=SC2046
    export $(awsctx "$SAVE_AWS_PROFILE" "$SAVE_AWS_REGION")
    kubectx "$SAVE_CONTEXT"
}

alias mmid=maas_machine_id
alias mmai=maas-all-custom-images

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
   (test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)") || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

[ -x "$($which git)" ] && alias g='git'

alias tmux='tmux -2'

#gcloud config set compute/region us-central1 && gcloud config set compute/zone us-central1-f
#alias gcloud='gcloud project=jimtest-170020'
#alias gcloud='gcloud --project=k8s-work'

alias vi='vi -p'
alias hd='helm del --purge'
alias grm='g co master && g fetch --all && g reset --hard upstream/master && g rebase upstream/master && g push'

[[ -n "$KRAKEN" ]] && alias k2env="printenv | grep -P 'KRAKEN|K2|KUBE|HELM'"

# Load rbenv automatically by appending
# the following to ~/.bashrc:

#eval "$(rbenv init -)"

#alias supclusterupd='cluster_sshconfig_upd --region us-east-1 --cluster-name superior --id-file $HOME/.ssh/cyklops-superior --ssh-config $HOME/.kraken-superior/cyklops-superior/ssh_config'
#alias onclusterupd='cluster_sshconfig_upd --region us-east-1 --cluster-name onondaga --id-file $HOME/.ssh/onondaga --ssh-config $HOME/.kraken-onondaga/onondaga/ssh_config'
#alias jujuclusterupd='cluster_sshconfig_upd --region us-west-2 --cluster-name cmc-poc --id-file ~/.ssh/juju_id_rsa --cluster-type juju --ssh-config $KRAKEN/juju/ssh_config'
alias hd='helm del --purge'

# remove comments in front of these if skopos is ever decomissioned.
k-check()
{
  # function to alias kubectl
  cmd="$*"
  current_context=$(\kubectl config current-context)

  if echo "$current_context" | grep -q "$AWS_PROD_USER" && \
     echo "$cmd" | grep -Pq '\s*(apply|delete|edit|patch|replace|drain|cordon|rollout|scale|expose|uncordon|taint|drain) '; then
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

# get pod events
kgpe()
{
  \kubectl get events -o wide --field-selector involvedObject.name="$1"
}

# get pod by phase
kgps()
{
  \kubectl get pods -o wide --field-selector status.phase="$1"
}

kgpc()
{
  \kubectl get -o wide po "$1" -o jsonpath='{.status.conditions[*].message}'
}

proj()
{
  cd "$HOME"/projects/src/"$*" || return
}

alias k='k-check'
alias kg='\kubectl get -o wide'
alias kga='\kubectl get -o wide --all-namespaces'
alias kgj='\kubectl get -o json'
alias kgd='\kubectl describe'
alias kgns='\kubectl config view --minify -o "jsonpath={..namespace}"'
alias kubectl='k-warning'

alias gb='get_git_branch'

#alias k2='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig'
#alias k2env='printenv | grep -P '\''KRAKEN|K2|KUBE|HELM'\'''
#alias k2g='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig get -o wide'
#alias k2ga='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig get -o wide --all-namespaces'
#alias kg='kubectl get -o wide'
#alias kssh='ssh -F /home/jimconn/.kraken/cyklops-superior/ssh_config '
#alias k2exec='kubectl -n ${NAMESPACE:?"Please set NAMESPACE"} exec -it ${PODNAME:?"Please set PODNAME"} env COLUMNS=$COLUMNS LINES=$LINES TERM=$TERM bash'
#alias kl="docker run -it --rm -v $HOME/projects/src/tahoe.cluster.cnct.io:/tahoe quay.io/samsung_cnct/kraken-lib /bin/bash"

alias whatsmyip='curl -sL http://api.myip.com | jq -Mr .ip'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias du='ncdu --color dark -rr -x --exclude .git --exclude node_modules'

# bat - cat with wings
#alias less='$HOME/bin/dbat'
#alias cat='$HOME/bin/dbat'

[[ -n "$COOKIES" ]] && alias curl='curl -b $COOKIES -c $COOKIES'
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"


