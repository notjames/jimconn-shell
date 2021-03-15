# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
HISTTIMEFORMAT="%c: "

[[ -d /opt/terraform ]] && PATH=$PATH:/opt/terraform
[[ -d /usr/local/kubebuilder/bin ]] && PATH=$PATH:/usr/local/kubebuilder/bin

GOROOT=/usr/lib/go
GOPATH=$HOME/go
#GOPATH=$HOME/go:$HOME/projects
PATH=$PATH:$HOME/go/bin:$HOME/.local/bin:/usr/local/go/bin:/usr/local/bin

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

[[ -x /usr/bin/vim ]] && EDITOR=/usr/bin/vim

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=30;47:st=30;46:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
PERL5LIB="$HOME/.local/lib/perl/site"

# initialize keychain
# requires ssh-agent and keychain be installed.
eval "$(keychain --systemd --eval "$HOME"/.ssh/*.pem "$HOME"/.ssh/*-id_rsa)"

export LS_COLORS PERL5LIB EDITOR GOPATH GOROOT

# OPAM configuration
source /home/jimconn/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

export PATH="$HOME/.cargo/bin:$PATH"

[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env
export $("$HOME"/bin/set-aws --profile gen3-dev --in us-west-2 --override)

# enable completions in ~/.bash_profile
. <(flux completion bash)

CURL_HOME=$HOME/.config/curl
COOKIES=$CURL_HOME/cookies
mkdir -p "$CURL_HOME"
export CURL_HOME COOKIES

# temporary
#export SOPS_KMS_ARN=arn:aws:kms:us-west-2:429863676324:key/4b2c5901-43aa-4e1c-b14d-bb797a476939

show_cluster()
{
  AWS_PROD_USER=xxxxxxxxxxxxxxx
  AWS_PPROD_USER=xxxxxxxxxxxxxxx
  cluster="$(\kubectl config current-context)"
  if [[ "$cluster" =~ aws ]]; then
    shortened_cluster="$(echo "$cluster" | cut -d : -f 6)"
  fi
  figlet -w200 -f pagga "$shortened_cluster"

  if [[ "$cluster" =~ $AWS_PROD_USER ]]; then
    echo ' PRODUCTION! ' | toilet --filter border:metal -w200 -t --metal --font mono9
  fi

  if [[ "$cluster" =~ $AWS_PPROD_USER ]]; then
    echo ' PRE-PROD!!! ' | toilet --filter border:metal -w200 -t --gay --font mono9
  fi
}

# and force you to set the context per session
show_cluster
