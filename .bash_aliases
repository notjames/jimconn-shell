#!/bin/bash

cnct_clone()
{
  local ghub repo repo_name client_repo upstream_repo

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
    youtube-dl --video-format mp4 --add-metadata -ct "$*"
    fix_fsp && (cd - || true)
  else
    echo >&2 "unable to chdir $d"
    return 5
  fi
}

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

    alias grep='grep -n --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

[ -x "$(which git)" ] && alias g='git'

alias tmux='tmux -2'

gcloud config set compute/region us-central1 && gcloud config set compute/zone us-central1-f
#alias gcloud='gcloud project=jimtest-170020'
alias gcloud='gcloud --project=k8s-work'

alias vi='vi -p'
alias hd='helm del --purge'
alias grm='g co master && g fetch --all && g reset --hard upstream/master && g rebase upstream/master && g push'

[[ -n "$KRAKEN" ]] && alias k2env="printenv | grep -P 'KRAKEN|K2|KUBE|HELM'"

# Load rbenv automatically by appending
# the following to ~/.bashrc:

#eval "$(rbenv init -)"

alias supclusterupd='cluster_sshconfig_upd --region us-east-1 --cluster-name superior --id-file $HOME/.ssh/cyklops-superior --ssh-config $HOME/.kraken-superior/cyklops-superior/ssh_config'
alias onclusterupd='cluster_sshconfig_upd --region us-east-1 --cluster-name onondaga --id-file $HOME/.ssh/onondaga --ssh-config $HOME/.kraken-onondaga/onondaga/ssh_config'
alias jujuclusterupd='cluster_sshconfig_upd --region us-west-2 --cluster-name cmc-poc --id-file ~/.ssh/juju_id_rsa --cluster-type juju --ssh-config $KRAKEN/juju/ssh_config'
alias hd='helm del --purge'
# remove comments in front of these if skopos is ever decomissioned.
#alias k='kubectl'
#alias k2='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig'
#alias k2env='printenv | grep -P '\''KRAKEN|K2|KUBE|HELM'\'''
#alias k2g='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig get -o wide'
#alias k2ga='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig get -o wide --all-namespaces'
#alias kg='kubectl get -o wide'
#alias kssh='ssh -F /home/jimconn/.kraken/cyklops-superior/ssh_config '
#alias k2exec='kubectl -n ${NAMESPACE:?"Please set NAMESPACE"} exec -it ${PODNAME:?"Please set PODNAME"} env COLUMNS=$COLUMNS LINES=$LINES TERM=$TERM bash'
alias kl="docker run -it --rm -v $HOME/projects/src/tahoe.cluster.cnct.io:/tahoe quay.io/samsung_cnct/kraken-lib /bin/bash"


alias preview="fzf --preview 'bat --color \"always\" {}'"
alias du='ncdu --color dark -rr -x --exclude .git --exclude node_modules'
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"
