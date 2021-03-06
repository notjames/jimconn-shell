# shellcheck disable=SC2148
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=99999999
#HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# fix stupid sporadic backslash escaping of tab-completion
# https://askubuntu.com/questions/70750/how-to-get-bash-to-stop-escaping-during-tab-completion
set -o direxpand 2>/dev/null || shopt -s direxpand

[ -x /usr/bin/kubectx ] && K8SCTX=$(kubectx | sed 's/_.*//')
[ -x /usr/bin/vim ] && alias vi="/usr/bin/vim -p"
[ -x /usr/local/bin/vimcat ] && alias cat='/usr/local/bin/vimcat -n --colors=256'
[ -f $HOME/.bash/fzf/fzf.bash ] && source $HOME/.bash/fzf/fzf.bash
[ -x /usr/local/bin/ggrep ] && alias grep='/usr/local/bin/ggrep'
[ -f $HOME/.bash/acd/acd_func.sh ] && source $HOME/.bash/acd/acd_func.sh

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

### installed_skopos
#BASH_SCRIPTS="$HOME"/.bash
#export BASH_SCRIPTS
#
#if [[ -e "$BASH_SCRIPTS"/skopos/init_skopos ]]; then
#  source "$BASH_SCRIPTS"/skopos/init_skopos
#
#  if [[ $(echo "$PATH" | grep -c "$HOME"/bin) == 0 ]]
#  then
#    PATH="${PATH:+$PATH:}$HOME/bin:$HOME/.local/bin"
#    export PATH
#  fi
#else
#  echo >&2 "No skopos for you... :("
#fi
### end installed_skopos

#export GITAWAREPROMPT="$HOME/.bash/git-aware-prompt" PATH GOPATH HISTTIMEFORMAT EDITOR
export PATH GOPATH HISTTIMEFORMAT EDITOR
#source "${GITAWAREPROMPT}/main.sh"

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

[ -f $HOME/.fzf.bash ] && source $HOME/.fzf.bash

#source $HOME/.oh-my-git/prompt.sh
source $HOME/.fonts/*.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(starship init bash)"
