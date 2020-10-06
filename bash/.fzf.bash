# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/share/doc/fzf/examples/completion.bash" 2> /dev/null

# Key bindings
# ------------
if [[ -d "/usr/share/doc/fzf/examples" ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi
