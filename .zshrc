# .zshrc
# Cursor Agent: proper command detection (run once: curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh)
if [[ -n $CURSOR_TRACE_ID ]]; then
  PROMPT_EOL_MARK=""
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  precmd() { print -Pn "\e]133;D;%?\a" }
  preexec() { print -Pn "\e]133;C;\a" }
fi

# Simpler theme in Cursor (ZSH_THEME only applies if you use oh-my-zsh; this repo uses Starship below)
if [[ -n $CURSOR_TRACE_ID ]]; then
  ZSH_THEME="robbyrussell"
else
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# p10k: only load when not in Cursor
if [[ ! -n $CURSOR_TRACE_ID ]]; then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
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
setopt NO_BEEP                   # turn off terminal beep

eval "$(starship init zsh)"

# Auto-start tmux in normal terminals only (never inside Cursor/VS Code — avoids "Unable to resolve your shell environment")
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [[ "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Cursor" && -z $CURSOR_TRACE_ID ]]; then
  if tmux has-session 2>/dev/null; then
    exec tmux attach-session
  else
    exec tmux new-session
  fi
fi

# General aliases
alias ls="lsd"
alias vim="nvim"
alias f="fuck"
alias cat="bat"

# Git (optional short aliases)
alias g="git"
alias gst="git status"
alias gco="git checkout"
alias gd="git diff"
alias gl="git pull"
alias gp="git push"
alias gb="git branch"
alias glog="git log --oneline -20"

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
if [ -f "$(brew --prefix 2>/dev/null)"/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source "$(brew --prefix 2>/dev/null)"/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Type a prefix, then Up/Down to cycle through matching history only
if [ -f "$(brew --prefix 2>/dev/null)"/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
  source "$(brew --prefix 2>/dev/null)"/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

# zsh-syntax-highlighting must be last
if [ -f "$(brew --prefix 2>/dev/null)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source "$(brew --prefix 2>/dev/null)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Ensure sourced .zshrc exits 0 (fixes Cursor "Unable to resolve your shell environment" when brew etc. not in PATH)
true