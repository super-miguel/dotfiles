# dotfiles

Ghostty + zsh + Starship, with tools installed via Homebrew.

## Quick start

1) Install Homebrew (macOS):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2) Install CLI tools and apps:

```bash
# Core tools
brew install \
  git \
  starship \
  neovim \
  bat \
  lsd \
  thefuck \
  mcfly \
  direnv \
  uv \
  mise \
  fzf \
  kubectl \
  git-flow \
  tmux \
  stow \
  zsh-autosuggestions \
  zsh-syntax-highlighting

# Apps
brew install --cask ghostty
```

3) Enable fzf keybindings and completions for zsh:

```bash
"$(brew --prefix)"/opt/fzf/install --all --no-bash --no-fish | cat
```

4) Reload your shell:

```bash
source ~/.zshrc
```

## Tmux

This repo includes a `.tmux.conf` that bootstraps TPM and loads the Catppuccin theme (flavour: mocha).

Usage:

```bash
# Start tmux, then install plugins (TPM):
tmux
# Verify prefix works: press Ctrl-b then ? to open tmux help
# Install plugins: press Ctrl-b then I (capital i)
```

If TPM is missing, it will auto-install on first start.

To change Catppuccin flavour, edit `~/.tmux.conf` and set one of: latte, frappe, macchiato, mocha.

## Manage dotfiles with GNU Stow (stew)

Symlink files from this repo into your home directory using GNU Stow:

```bash
# From the repository root
cd ~/dotfiles

# Example: stow the zsh and tmux configs
stow -v -t ~ .

# Or stow specific groups if you organize into subfolders, e.g.:
# stow -v -t ~ zsh
# stow -v -t ~ tmux
```