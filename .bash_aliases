#!/bin/bash

cnct_clone()
{
  set -e
  repo="{$1:?Must provide repo name}"

  git clone https://github.com/$USER/$repo && cd $repo && git remote add upstream https://github.com/samsung-cnct/$repo
  set +e
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

alias supclusterupd='cluster_sshconfig_upd superior $HOME/.ssh/cyklops-superior $HOME/.kraken-superior/cyklops-superior/ssh_config'
alias onclusterupd='cluster_sshconfig_upd onondaga $HOME/.ssh/onondaga $HOME/.kraken-onondaga/onondaga/ssh_config'
alias hd='helm del --purge'
# remove comments in front of these if skopos is ever decomissioned.
#alias k='kubectl'
#alias k2='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig'
#alias k2env='printenv | grep -P '\''KRAKEN|K2|KUBE|HELM'\'''
#alias k2g='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig get -o wide'
#alias k2ga='kubectl --kubeconfig=/home/jimconn/.kraken/cyklops-superior/admin.kubeconfig get -o wide --all-namespaces'
#alias kg='kubectl get -o wide'
#alias kssh='ssh -F /home/jimconn/.kraken/cyklops-superior/ssh_config '
