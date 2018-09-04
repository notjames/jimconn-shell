vmrun()
{
  rcmd=$1

  [[ -z $rcmd ]] && \
    {
      echo >&2 "What command is that again?"
      return 1
    }

  (nohup ssh -X vmlinux "$rcmd" >/dev/null 2>&1 &)
}

seausb()
{
  for cmd in usbdetach usbattach
  do
    echo "${cmd}ing"
    
    for id in $(vboxmanage list usbhost | grep -P 'UUID:|Product:|Manufact' | grep -B 1 -A 1 -i Seagate | grep UUID | awk -F ':' '{print $2}' | tr -d ' ')
    do
      echo "id: $id"
      vboxmanage controlvm Ubuntu $cmd $id
    done

    read -p "Press any key to re-attach drives..."
  done
}

# https://help.github.com/articles/configuring-a-remote-for-a-fork/
# https://help.github.com/articles/syncing-a-fork/
function k2sync()
{
  # stash uncommitted changes
  git stash >/dev/null 2>/dev/null

  # sync
  if $(pwd | grep -P '^k2')
  then
    # hacky. create an upstream pointed to the parent repo
    git remote add upstream https://github.com/samsung-cnct/$(basename $(pwd)).git 2>/dev/null && \

    # fetch it on top of local forked copy
    git fetch upstream && \

    # checkout master branch on local repo
    git checkout master && \

    # merge upstream with local master
    git merge upstream/master && \

    # push synced code to forked remote
    git push
  fi

  # replay stash on top of HEAD
  if $(git stash list | grep stash > /dev/null); then
    git stash pop
  fi

  echo "done..."
}

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
    git checkout $CWB
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
  (nohup ssh -YX vmlinux "(tilix &) && (hexchat &) && (gitg &)" >/dev/null 2>&1 &)
}

fix_fsp()                                                                                                                                                                                     
{                                                                                                                                                                                                      
  while read f
  do
    f=${f#./*}
    basename=${f%.*}
    suffix=${f#*.}
    new_f=$(echo "$f" | tr ' ' '_' | \
            sed -r \
                 -e "s/[,']|[()]|[[]]//g"       \
                 -e "s/\&#([a-zA-Z0-9]+;|-)//g" \
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
    youtube-dl -kx --add-metadata --audio-format m4a -c -o "%(title)s-%(id)s.%(ext)s" $*
    fix_fsp && cd -
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
    youtube-dl --video-format mp4 --add-metadata -ct $*
    fix_fsp && cd -
  else
    echo >&2 "unable to chdir $d"
    return 5
  fi
}

alias ls='ls -G'

[ -x /usr/bin/vim ] && alias vi="/usr/bin/vim"
[ -x /usr/local/bin/vimcat ] && alias cat='/usr/local/bin/vimcat -n --colors=256'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -x /usr/local/bin/ggrep ] && alias grep='/usr/local/bin/ggrep'
[ -f ~/.acd_func.sh ] && source ~/.acd_func.sh

alias grep='ggrep --color=auto'
alias vi='vi -p'
alias g="/usr/bin/git"

alias terminix='(nohup ssh -YX vmlinux terminix >/dev/null 2>&1 &)'
alias tilix='(nohup ssh -YX vmlinux tilix >/dev/null 2>&1 &)'
