# .zshrc
# No-op for Cursor IDE shell integration (avoids "command not found: dump_zsh_state")
dump_zsh_state() { :; }

# History: big, shared across sessions, no dupes, with timestamps
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY          # save timestamp and duration
setopt INC_APPEND_HISTORY        # write to history file immediately
setopt SHARE_HISTORY             # share history across sessions
setopt HIST_IGNORE_ALL_DUPS      # drop older duplicate entries
setopt HIST_IGNORE_SPACE         # ignore commands starting with space
setopt HIST_REDUCE_BLANKS        # trim extra blanks

eval "$(starship init zsh)"

# Auto-start tmux in normal terminals, but NOT in Cursor/VS Code integrated terminals
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
  case "$TERM_PROGRAM" in
    vscode|Cursor) ;;
    *)
      if tmux has-session 2>/dev/null; then
        exec tmux attach-session
      else
        exec tmux new-session
      fi
      ;;
  esac
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

# Better history: `hist` = fzf search & run, `hist -n` = numbered list (for !123)
hist() {
  if [[ "$1" == -n ]]; then
    fc -l 1
  else
    local chosen
    chosen=$(fc -l 1 | fzf --tac --no-sort -q "${*:-}" | sed 's/ *[0-9]* *//')
    [[ -n "$chosen" ]] && print -z "$chosen"
  fi
}

# direnv 
eval "$(direnv hook zsh)"
eval "$(uv generate-shell-completion zsh)"
eval "$(mise activate zsh)"

# Homebrew zsh plugins
# zsh-autosuggestions should be sourced after completion is set up
if [ -f "$(brew --prefix)"/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source "$(brew --prefix)"/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Type a prefix, then Up/Down to cycle through matching history only
if [ -f "$(brew --prefix)"/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
  source "$(brew --prefix)"/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

# zsh-syntax-highlighting must be last
if [ -f "$(brew --prefix)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source "$(brew --prefix)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi