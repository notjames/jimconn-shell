#!/bin/bash

which=$(command -v which)

# real prod
AWS_PROD_USER=
# test prod user
#AWS_PROD_USER=
#gcloud config set compute/region us-central1 && gcloud config set compute/zone us-central1-f
#alias gcloud='gcloud project=jimtest-170020'
#alias gcloud='gcloud --project=k8s-work'

get_git_branch()
{
  git rev-parse --abbrev-ref HEAD | grep -v HEAD || \
  git describe --exact-match HEAD 2>/dev/null    || \
  git rev-parse HEAD
}

repo_clone()
{
  local ghub repo_name client_repo upstream_repo account
  account="$1"

  ghub="https://github.com/"
  repo_name="${1:?Must provide repo name}"
  client_repo="${ghub}notjames/$repo_name"
  upstream_repo="${ghub}$account/$repo_name"

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

mkcdir()
{
  if ! mkdir -p "$1"; then
    echo >&2 "exit code: $?"
  fi
  cd "$1"
}

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

kctx()
{
  if test -z "$1"; then
    kubectx
    return 0
  fi
  kubectx "$(kubectx | grep $1)"
}

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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias tmux='tmux -2'

alias vi='vi -p'
alias hd='helm del --purge'
alias grm='g co master && g fetch --all && g reset --hard upstream/master && g rebase upstream/master && g push'

alias k='k-check'
alias kg='\kubectl get -o wide'
alias kga='\kubectl get -o wide --all-namespaces'
alias kgj='\kubectl get -o json'
alias kgd='\kubectl describe'
alias kgns='\kubectl config view --minify -o "jsonpath={..namespace}"'
alias kubectl='k-warning'
alias kve='\kubectl get secret vault-unseal-keys -n vault -o jsonpath="{.data.vault-root}"| base64 -d'

alias gb='get_git_branch'

alias whatsmyip='curl -sL http://api.myip.com | jq -Mr .ip'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias du='ncdu --color dark -rr -x --exclude .git --exclude node_modules'

# bat - cat with wings
#alias less='$HOME/bin/dbat'
#alias cat='$HOME/bin/dbat'
if which bat >/dev/null 2>&1; then
  bat_opts='--color=auto --theme=TwoDark'
  alias less="$(which bat) $bat_opts"
  alias cat="$(which bat) $bat_opts"
fi

[[ -n "$COOKIES" ]] && alias curl='curl -b $COOKIES -c $COOKIES'
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"
