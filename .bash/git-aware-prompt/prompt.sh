find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="($branch)"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

find_k8s_things()
{
  k8sctx=''

  k8sctx=$(/usr/local/bin/kubectx | cat -A - | grep -P '33m' | perl -lne '/33m([\w-]+)\^\[/; print $1' | sed -re 's/_.*//')

  if [[ -z $k8sctx ]]
  then
    k8sctx="(Not set)"
  else
    k8sctx="($k8sctx$txtrst)"
  fi

  #k8sns=$(kubens | cat -A - | grep -P '33m' | perl -lne '/\[\[33m(\w+)\^\[/;print $1')
  #K8SNS="${K8SNS:-not set}"
}

PROMPT_COMMAND="find_k8s_things; find_git_branch; find_git_dirty; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
export PS1="\$k8sctx\[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\n\[$bldgrn\]\u@\h\[$txtrst\]:\[$bldblu\]\w\[$txtrst\] \$ "

# Default Git enabled root prompt (for use with "sudo -s")
export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
