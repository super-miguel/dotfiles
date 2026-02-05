# dotfiles

Ghostty + zsh + Starship, with tools installed via Homebrew.

## Quick start

1) Install Homebrew (macOS):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2) Install and configure (from Brewfile):

```bash
cd ~/dotfiles
brew bundle --file=Brewfile

# Link config into home
stow -v -t ~ .

# Git/delta and identity: run the manual commands below (per machine)
```

3) Reload your shell:

```bash
source ~/.zshrc
```

4) (Optional) Keep everything updated — run periodically (e.g. weekly):

```bash
brew update && brew upgrade && brew upgrade --cask --greedy && brew autoremove && brew cleanup
```

- **update** — refresh Homebrew and formulae list  
- **upgrade** — upgrade all CLI tools  
- **upgrade --cask --greedy** — upgrade all apps (including those that auto-update)  
- **autoremove** — remove orphaned dependencies  
- **cleanup** — remove old versions and prune cache

To update the Brewfile from your current system (e.g. after installing something new): `brew bundle dump --file=~/dotfiles/Brewfile --force`

**Manual Git/delta setup** — run these on each machine to enable delta and set your identity:

```bash
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.dark true
git config --global merge.conflictStyle zdiff3
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

`.zshrc` includes a guard at the top so Cursor Agent shells skip the rest of the config (no tmux, starship, etc.) when `PAGER` or `COMPOSER_NO_INTERACTION` is set.

## Core tools reference


| Tool            | What it does                            | How to use                                                                         |
| --------------- | --------------------------------------- | ---------------------------------------------------------------------------------- |
| **bat**         | Cat with syntax highlight and paging    | `bat file.py`, `kubectl get pods | bat`                                            |
| **btop**        | Process/CPU/memory viewer (modern htop) | `btop`                                                                             |
| **delta**       | Better git diff (syntax, side-by-side, `n`/`N` navigate, merge conflicts) | See *Manual Git/delta setup* below. |
| **fd**          | Fast find; simpler than `find`          | `fd '*.py'`, `fd -e yaml`, `fd config`                                             |
| **fzf**         | Fuzzy finder (files, history, etc.)     | **Ctrl-T** file, **Ctrl-R** history (or mcfly), **Alt-C** cd; `hist` in this setup |
| **helm**        | K8s package manager (charts)            | `helm list`, `helm install myapp ./chart`, `helm upgrade myapp ./chart`            |
| **gum**         | Prompts/confirm/tables for scripts      | `gum confirm`, `gum input`, `echo "a\nb" | gum choose`                             |
| **jq**          | JSON query and format                   | `kubectl get pods -o json | jq '.items[].metadata.name'`, `cat config.json | jq .` |
| **just**        | Task runner (simpler than make)         | `just` (runs default), `just build`, `just test`                                   |
| **k9s**         | TUI for Kubernetes                      | `k9` or `k9s`; then `/` to filter, `:pods`, `l` logs                               |
| **kubeconform** | Validate K8s manifests                  | `kubeconform my-deploy.yaml`, `kubeconform -summary *.yaml`                        |
| **kubectl**     | Kubernetes CLI                          | `k get pods`, `k apply -f deploy.yaml`; see Kubectl section for aliases            |
| **lazygit**     | TUI for git (stage, commit, branches)   | `lazygit`                                                                          |
| **lsd**         | Modern ls with icons and colors         | `ls` (aliased), `lsd -la`                                                          |
| **mcfly**       | Smarter Ctrl-R (fuzzy history)          | **Ctrl-R** in shell                                                                |
| **ripgrep**     | Fast grep                               | `rg 'pattern'`, `rg -l 'error' .`, `rg -t py 'import'`                             |
| **shellcheck**  | Lint shell scripts                      | `shellcheck script.sh`, `shellcheck .zshrc`                                        |
| **thefuck**     | Fix last command                        | `fuck` or `f` (aliased)                                                            |
| **tldr**        | Short man pages with examples           | `tldr kubectl`, `tldr jq`, `tldr tar`                                              |
| **trivy**       | Security scanner (containers, K8s, IaC) | `trivy image myimg`, `trivy fs .`, `trivy k8s cluster`                             |
| **uv**          | Fast Python package/venv manager        | `uv run script.py`, `uv pip install -r requirements.txt`                           |
| **yq**          | YAML/JSON (like jq for YAML)            | `yq '.spec.replicas' deploy.yaml`, `yq -i '.count = 2' file.yaml`                  |
| **zoxide**      | Smarter cd; learns frequent dirs        | `z foo` (jump to path containing foo), `z proj`                                    |


*Other core tools: **direnv** (auto env per dir), **mise** (runtime versions), **starship** (prompt), **tmux** (sessions). See sections below.*

## Zsh

### Prompt (Starship)

Shows directory, git branch/status, **Python** (venv + version when in a project), AWS profile, GCP project, and Kubernetes context/namespace. Theme: Catppuccin Mocha.

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

### Kubectl

- **`k`** — `kubectl`. **kgp** get pods, **kgs** get svc, **kgd** deploy, **kgn** nodes, **kga** get all.
- **kgpw** — get pods -w (watch). **kd** / **kdp** describe. **kdel** delete. **kaf** / **kdf** apply/delete -f.
- **kctx** / **kns** — switch context / namespace. **klog** logs. **kexec** exec -it. **k9** — k9s TUI.
- **`kctxf`** / **`knsf`** — fzf pick context or namespace and switch (no typing names).

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

## Ghostty

Theme: Catppuccin Mocha. **10MB scrollback** (`scrollback-limit`) for long `kubectl logs` / `tail -f` sessions.

## Direnv and .envrc.example

**direnv** runs a script (`.envrc`) when you `cd` into a directory, so you get the right Node/Python version, env vars, or API keys **per project** without touching your global shell.

- The **real `.envrc`** often has secrets or machine-specific paths, so it’s in `.gitignore` and not committed.
- **`.envrc.example`** is a **committed template** that shows what the project expects (e.g. `use node`, `use python`, `export API_KEY=...`). Anyone cloning the repo can copy it to `.envrc`, fill in values, run `direnv allow`, and get the same environment.

This repo includes an `.envrc.example` you can copy into **other** projects (apps, services) as a starting point. In a project:

```bash
cp ~/dotfiles/.envrc.example .envrc
# Edit .envrc (uncomment use node/python, set env vars)
direnv allow
```

## Manage dotfiles with GNU Stow

Stow links `.zshrc`, `.tmux.conf`, `.config/`, etc. into `~`. There is no `.gitconfig` in the repo; use the manual Git/delta commands above on each machine (and set `user.name` / `user.email` per system).

```bash
cd ~/dotfiles
stow -v -t ~ .
```

