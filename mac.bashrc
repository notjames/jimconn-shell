export GOOD_BASHRC=yes

[[ -e $HOME/bin/skopos ]] && \
  {
    source ~/bin/skopos
    setup_cluster_env
  }

[[ -e $HOME/.bash/my_functions.sh ]] && . $HOME/.bash/my_functions.sh

source ~/.bash_aliases
source ~/.git-prompt.sh

