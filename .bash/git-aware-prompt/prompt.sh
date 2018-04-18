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

K8SCTX=$(kubectx | sed 's/_.*//')
K8SCTX="${K8SCTX:-not set}"
export K8SCTX

PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
export PS1="($K8SCTX)\[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\n\[$bldgrn\]\u@\h\[$txtrst\] \w \$ "

# Default Git enabled root prompt (for use with "sudo -s")
export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
