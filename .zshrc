# .zshrc
eval "$(starship init zsh)"

# Auto-start tmux in normal terminals, but NOT in Cursor (TERM_PROGRAM=vscode)
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
  if tmux has-session 2>/dev/null; then
    exec tmux attach-session
  else
    exec tmux new-session
  fi
fi

# General aliases
alias k="kubectl"
alias ls="lsd"
alias vim="nvim"
alias f="fuck"
alias cat="bat"

# Tmux aliases
alias t="tmux"
alias ta="tmux attach"
alias tat="tmux attach -t"
alias tnew="tmux new-session"
alias tls="tmux list-sessions"
alias tkill="tmux kill-session"
alias tkillall="tmux kill-server"

# Tmux helper functions
tdev() {
    # Create or attach to a development session
    if tmux has-session -t dev 2>/dev/null; then
        tmux attach -t dev
    else
        tmux new-session -s dev
    fi
}

twork() {
    # Create or attach to a work session
    if tmux has-session -t work 2>/dev/null; then
        tmux attach -t work
    else
        tmux new-session -s work
    fi
}

eval $(thefuck --alias)
eval "$(mcfly init zsh)"

# kubectl autocompletion
autoload -Uz compinit
compinit
source <(kubectl completion zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# direnv 
eval "$(direnv hook zsh)"
eval "$(uv generate-shell-completion zsh)"
eval "$(mise activate zsh)"

# Homebrew zsh plugins
# zsh-autosuggestions should be sourced after completion is set up
if [ -f "$(brew --prefix)"/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source "$(brew --prefix)"/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting must be last
if [ -f "$(brew --prefix)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source "$(brew --prefix)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi