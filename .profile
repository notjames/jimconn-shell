# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/var/tmp/google-cloud-sdk/path.bash.inc' ]
then
  source '/var/tmp/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
  if [ -f '/var/tmp/google-cloud-sdk/completion.bash.inc' ]
  then 
    source '/var/tmp/google-cloud-sdk/completion.bash.inc'
  fi
fi

[[ -z "$GOPATH" ]] && GOPATH=$HOME/go 
PATH=$PATH:$GOPATH/bin

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

[[ -x /usr/bin/vim ]] && export EDITOR=/usr/bin/vim


export GITAWAREPROMPT="$HOME/.bash/git-aware-prompt" PATH GOPATH
source "${GITAWAREPROMPT}/main.sh"

# Begin Kraken env functions
# install_skopos
if [[ -e $HOME/bin/skopos ]]
then
  echo "Setting up kraken environment"
  source $HOME/bin/skopos
  alias sk="skopos"
  setup_cluster_env
fi

