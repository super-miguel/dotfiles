# .zshrc
# Skip loading the rest when Cursor Agent is running (avoids tmux, starship, etc. in agent shell)
if [[ "$PAGER" == "head -n 10000 | cat" || "$COMPOSER_NO_INTERACTION" == "1" ]]; then
  return
fi

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
alias ls="lsd"
alias vim="nvim"
alias f="fuck"
alias cat="bat"

# Kubectl aliases (k = kubectl; kg* = get, kd = describe, kdel = delete, kaf = apply -f)
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgd="kubectl get deploy"
alias kgn="kubectl get nodes"
alias kga="kubectl get all"
alias kgpw="kubectl get pods -w"
alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kdel="kubectl delete"
alias kaf="kubectl apply -f"
alias kdf="kubectl delete -f"
alias kctx="kubectl config use-context"
alias kns="kubectl config set-context --current --namespace"
alias klog="kubectl logs"
alias kexec="kubectl exec -it"
alias k9="k9s"

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

# Kubectl + fzf: switch context or namespace by picking from list
kctxf() {
  local ctx
  ctx=$(kubectl config get-contexts -o name | fzf -q "$*")
  [[ -n "$ctx" ]] && kubectl config use-context "$ctx"
}
knsf() {
  local ns
  ns=$(kubectl get namespaces -o name | sed 's|namespace/||' | fzf -q "$*")
  [[ -n "$ns" ]] && kubectl config set-context --current --namespace "$ns"
}

eval $(thefuck --alias)
eval "$(mcfly init zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Completions (compinit -C = fast load; run "rm ~/.zcompdump && compinit" to rebuild)
autoload -Uz compinit
[[ -f ~/.zcompdump ]] && [[ ~/.zshrc -nt ~/.zcompdump ]] && rm -f ~/.zcompdump
compinit -C
source <(kubectl completion zsh)
command -v helm &>/dev/null && source <(helm completion zsh)

# FZF keybindings and completion (from Homebrew; no need to run fzf/install)
_fzf_prefix=$(brew --prefix 2>/dev/null)
if [ -n "$_fzf_prefix" ] && [ -f "${_fzf_prefix}/opt/fzf/shell/key-bindings.zsh" ]; then
  source "${_fzf_prefix}/opt/fzf/shell/key-bindings.zsh"
fi
if [ -n "$_fzf_prefix" ] && [ -f "${_fzf_prefix}/opt/fzf/shell/completion.zsh" ]; then
  source "${_fzf_prefix}/opt/fzf/shell/completion.zsh"
fi
unset _fzf_prefix

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