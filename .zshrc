# Created by newuser for 5.9
eval "$(starship init zsh)"

plugins=(git wd docker git-flow brew history zsh-autosuggestions zsh-syntax-highlighting web-search kubectl fzf-tab)


alias k="kubectl"
alias ls="lsd"
alias vim="nvim"
alias f="fuck"
alias cat="bat"

eval $(thefuck --alias)
eval "$(mcfly init zsh)"

#kubectl autocompletion
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