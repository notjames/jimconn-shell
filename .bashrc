# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Begin Kraken env functions

kraken_env()
{
  KRAKEN=${HOME}/.kraken       # This is the default output directory for Kraken
  SSH_ROOT=${HOME}/.ssh
  AWS_ROOT=${HOME}/.aws
  AWS_CONFIG=${AWS_ROOT}/config  # Use these files when using the aws provider
  AWS_CREDENTIALS=${AWS_ROOT}/credentials
  SSH_KEY=${SSH_ROOT}/id_rsa   # This is the default rsa key configured
  SSH_PUB=${SSH_ROOT}/id_rsa.pub
  K2OPTS="-v ${KRAKEN}:${KRAKEN}
	  -v ${SSH_ROOT}:${SSH_ROOT}
	  -v ${AWS_ROOT}:${AWS_ROOT}
	  -e HOME=${HOME}
	  --rm=true
	  -it"

  export KRAKEN SSH_ROOT AWS_ROOT AWS_CONFIG AWS_CREDENTIALS SSH_KEY SSH_PUB K2OPTS
}

cluster_path()
{
  if [[ -d "$KRAKEN" || -s "$KRAKEN" ]]
  then
    export CLUSTER_NAME=$(basename $(find $KRAKEN/ -maxdepth 1 -type d -not \( -path $KRAKEN/ \)) 2>/dev/null)
  else
    echo >&2 'Sorry. There does not seem to be a proper .kraken environment IE ~/.kraken'
    return 50
  fi
}

setup_cluster_env()
{
  kraken_env

  if [[ $? == 0 ]]
  then
    cluster_path && \
    KUBECONFIG=$KRAKEN/$CLUSTER_NAME/admin.kubeconfig && \
    HELM_HOME=$KRAKEN/$CLUSTER_NAME/.helm && \
    export CLUSTER_NAME KUBECONFIG HELM_HOME 

    alias k='kubectl'
    alias kg='kubectl get -o wide'
    alias k2="kubectl --kubeconfig=$KUBECONFIG"
    alias k2g="k2 get -o wide"
    alias kssh="ssh -F $KRAKEN/$CLUSTER_NAME/ssh_config " 

    [[ -z $INITIAL_CLUSTER_SETUP ]] && \
      echo "Cluster path found: $CLUSTER_NAME. Exports set. Alias for kssh created."
  else
    [[ -z $INITIAL_CLUSTER_SETUP ]] && \
      echo >&2 "No kraken clusters found. Skipping env setup. Run 'skopos' when one is up"
  fi

  [[ -z $INITIAL_CLUSTER_SETUP ]] && export INITIAL_CLUSTER_SETUP=1
}

function skopos_switch
{
  [[ -n "$1" ]] && local new_cfg_loc="$1" || \
    {
      echo "switch requires valid environment name"
      return 70
    }

  new_base=$(dirname $KRAKEN)/.kraken-$new_cfg_loc

  if [[ -d "$new_base" ]]
  then
    if ln -vnsf "$new_base" "$KRAKEN"
    then
      unset INITIAL_CLUSTER_SETUP
      setup_cluster_env
    else
      xc=$?
      echo >&2 "Unable to switch config to '$1': ln exit code: $xc"
      return $xc
    fi
  else
    echo >&2 "the environment '$new_cfg_loc' does not exist"
    return 9
  fi
}

function skopos_init
{
   [[ -n "$1" ]] && local new_cfg_loc="$1" || \
    {
      echo "'init' requires valid new environment name"
      return 70
    }

    if mv $KRAKEN $KRAKEN-$new_cfg_loc >/dev/null
    then
      skopos_switch $new_cfg_loc
    fi
}

function skopos_list
{
  if [[ ! -L $KRAKEN ]]
  then
    echo >&2 "Skopos doesn't seem to be set up. Please run 'skopos init'"
    return 10
  fi

  echo -e "\nThe following kraken environment(s) exist..."

  for d in "$KRAKEN-"* 
  do
    d=${d#*-*}

    if  [[ $(realpath "$KRAKEN") == *$d ]]
    then
      echo -n ' *  '
      echo $d
    else
      echo -n '    '
      echo $d
    fi
  done
  echo
}

function skopos_usage
{
  echo """
  Usage: skopos [init <name>] [list] [switch <name>] [help]

  init     : Initialize new skropos env.
  list     : List all kraken environments available.
  switch   : Switch to kraken environment.
  help     : This message.

  """
}

# http://www.biblestudytools.com/lexicons/greek/nas/skopos.html
## This is the main function
function skopos
{
  setup_cluster_env

  if [[ -n "$KRAKEN" ]]
  then
    [[ -z "$1" ]] && skopos_usage && return 0

    while [[ $1 ]]
    do
      case $1 in
        list) 
          shift
          set -- "$@"
          skopos_list $@
        ;;
        switch)
          shift
          set -- "$@"
          skopos_switch $@
          break
        ;;
        help|-h|--help)
          shift
          skopos_usage
          break
        ;;
	init)
	  shift
          set -- "$@"
	  skopos_init $@
          break
	;;
        *)
          echo >&2 "Invalid option: '$1'"
          shift
          skopos_usage
          return 5
        ;;
      esac
    done
  else
    echo >&2 "Unable to continue. \$KRAKEN is not set."
    return 100
  fi
}

# end Kraken env stuff

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
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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
#force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
if [[ $TERMINIX_ID ]]; then source /etc/profile.d/vte.sh; fi # Ubuntu Budgie END


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/var/tmp/google-cloud-sdk/path.bash.inc' ]; then source '/var/tmp/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/var/tmp/google-cloud-sdk/completion.bash.inc' ]; then source '/var/tmp/google-cloud-sdk/completion.bash.inc'; fi

setup_cluster_env

