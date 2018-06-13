# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jimconn/.fzf/bin* ]]; then
  export PATH="$PATH:/home/jimconn/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jimconn/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/jimconn/.fzf/shell/key-bindings.bash"

