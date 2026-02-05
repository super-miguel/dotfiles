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
  tpm \
  stow \
  zsh-autosuggestions \
  zsh-history-substring-search \
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

## Zsh

### History

- **50k entries**, shared across sessions, no duplicates. Commands starting with a space are not saved.
- **`hist`** — FZF over history; pick a line and it’s pasted for you to run or edit. Type to filter.
- **`hist -n`** — Numbered history (for `!123`).
- **Ctrl-R** — mcfly (fuzzy reverse search, smart ordering).
- **Up/Down** — With text on the line, zsh-history-substring-search cycles only matching history lines.

### Plugins (Homebrew)

- **zsh-autosuggestions** — Gray suggestion from history; → to accept.
- **zsh-history-substring-search** — Type a prefix, then Up/Down to cycle matching history.
- **zsh-syntax-highlighting** — Must be last; colors the command line.

## Tmux

This repo includes a comprehensive `.tmux.conf` with the Catppuccin theme, optimized keybinds, and session management.

### Installation

TPM (Tmux Plugin Manager) is installed via Homebrew and will automatically install plugins defined in `.tmux.conf`.


### Keybinds

#### Basic Navigation
- `Ctrl-a r` - Reload tmux config
- `Ctrl-a ;` - Split window horizontally
- `Ctrl-a -` - Split window vertically
- `Ctrl-a x` - Kill current pane
- `Ctrl-a Space` - Toggle to last window

#### Pane Navigation
- `Ctrl-a + h/j/k/l` - Vim-style pane navigation (h=left, j=down, k=up, l=right)
- `Ctrl-a + H/J/K/L` - Vim-style pane resizing (H=left, J=down, K=up, L=right)

#### Window Management
- `Option + 1-9` - Switch to window 1-9
- `Option + 0` - Switch to window 10
- `Option + n` - Create new window

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

### Auto-start

Tmux auto-starts when you open a **normal** terminal (Terminal.app, iTerm, etc.): it attaches to an existing session or creates one. It does **not** auto-start in Cursor or VS Code integrated terminals.

### Usage

```bash
# In a normal terminal, tmux starts automatically. Or run manually:
tmux

# Or use helper functions:
tdev       # Start development session
twork      # Start work session
```

**Note:** If you need to manually install/update plugins, press `Ctrl-a` then `I` (capital i) while in tmux.

### Cursor + tmux troubleshooting

- **Launch Cursor outside tmux** — Open Cursor from the Dock/Spotlight or from a terminal *before* attaching to tmux. Don’t run the Cursor GUI from inside a tmux pane; the integrated terminal inside Cursor is fine (tmux doesn’t auto-start there).
- **TERM** — `.tmux.conf` sets `default-terminal "tmux-256color"`. If Cursor or other apps misbehave when launched from *inside* tmux (cursor shape, escape sequences), try `set -g default-terminal "xterm-256color"` in `.tmux.conf` instead.
- **Escape sequences** — If you see cursor/shape issues, ensure your terminal (e.g. Ghostty, iTerm2) is passing escape sequences through tmux correctly (no restricted mode).

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