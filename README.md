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

This repo includes a comprehensive `.tmux.conf` with the Catppuccin theme, optimized keybinds, and session management.


### Keybinds

#### Basic Navigation
- `Ctrl-a r` - Reload tmux config
- `Ctrl-a |` - Split window horizontally
- `Ctrl-a -` - Split window vertically
- `Ctrl-a x` - Kill current pane
- `Ctrl-a Space` - Toggle to last window

#### Pane Navigation
- `Ctrl-a + h/j/k/l` - Vim-style pane navigation (h=left, j=down, k=up, l=right)
- `Ctrl-a + H/J/K/L` - Vim-style pane resizing (H=left, J=down, K=up, L=right)

#### Window Management
- `Alt + 1-9` - Switch to window 1-9
- `Alt + 0` - Switch to window 10
- `Alt + n` - Create new window

### Aliases & Functions

```bash
# Basic tmux commands
t          # tmux
ta         # tmux attach
tat <name> # attach to specific session
tnew       # new session
tls        # list sessions
tkill      # kill session
tkillall   # kill all sessions

# Session helpers
tdev       # Create/attach to "dev" session
twork      # Create/attach to "work" session
```

### Usage

```bash
# Start tmux and install plugins (TPM):
tmux
# Install plugins: press Ctrl-a then I (capital i)

# Or use helper functions:
tdev       # Start development session
twork      # Start work session
```

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

