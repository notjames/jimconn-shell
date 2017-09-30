# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/jimconn/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/jimconn/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/jimconn/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/jimconn/.fzf/shell/key-bindings.bash"

