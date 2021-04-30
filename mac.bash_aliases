#!/bin/bash

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
  sudo perl -n -e -i"$ext" 's/^(\d{1,3}\.)+\d{1,3}(\s+vmlinux.*)/'"$VB_ADDR"' $2/; print' "$hosts"
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

kctx()
{
  if test -z "$1"; then
    kubectx
    return 0
  fi
  kubectx "$(kubectx | grep $1)"
}

VMNAME="Ubuntu"
VB_ADDR=$(vboxmanage guestproperty enumerate "$VMNAME"  | \
          ggrep -Po 'V4/IP, value: (\d{1,3}\.)+\d{1,3}' | \
          ggrep -P '192.*99' | cut -d : -f 2 | tr -d ' ')

alias ls='ls -G'

[ -x "$(which vim)" ] && alias vi='vim -p'
[ -x "$(which nvim)" ] && alias vi="nvim -p"
#[ -x /usr/local/bin/vimcat ] && alias cat='/usr/local/bin/vimcat -n --colors=256'
[ -x /usr/local/bin/bat ] && alias cat='/usr/local/bin/bat --style full --color=auto --theme=TwoDark'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -x /usr/local/bin/ggrep ] && alias grep='/usr/local/bin/ggrep'
[ -f ~/.acd_func.sh ] && source ~/.acd_func.sh

alias grep='ggrep --color=auto'
alias g="/usr/bin/git"

#alias terminix='(nohup ssh -YX vmlinux terminix >/dev/null 2>&1 &)'
alias tilix='(nohup ssh -YX vmlinux tilix >/dev/null 2>&1 &)'
alias k='kubectl'
alias kg='kubectl get -o wide'
alias kga='kubectl get -o wide --all-namespaces'
alias kgj='kubectl get -o json'
alias kgdesc='kubectl describe'
alias rebmas='git fetch --all && git rebase upstream/master'

[[ -x /usr/local/bin/exa ]] && alias nls='/usr/local/bin/exa --reverse --sort=size'
[[ -x /usr/local/bin/gsed ]] && alias sed='/usr/local/bin/gsed'


## go places
alias bu1='cd /Volumes/backup-1'
alias bu2='cd /Volumes/backup-2'

export VMNAME VB_ADDR
