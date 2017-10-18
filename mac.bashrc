export GOOD_BASHRC=yes

source $HOME/.profile

[[ -e $HOME/bin/skopos ]] && \
  {
    source ~/bin/skopos
    setup_cluster_env
  }

alias ls='ls -G'

[ -x /usr/bin/vim ] && alias vi="/usr/bin/vim"
[ -x /usr/local/bin/vimcat ] && alias cat='/usr/local/bin/vimcat -n --colors=256'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -x /usr/local/bin/ggrep ] && alias grep='/usr/local/bin/ggrep'
[ -f ~/.acd_func.sh ] && source ~/.acd_func.sh

alias grep='ggrep --color=auto'
alias vi='vi -p'

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
  git branch | grep -P '^\*' | grep -Po '\w+'
}

function sm
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
