# dotfiles

Personal dotfiles for macOS and Omarchy (Arch Linux).

## Structure

```
dotfiles/
├── install.sh          # Top-level installer — detects platform and delegates
├── _gitignore          # Global gitignore (all platforms)
├── shared/
│   ├── _zshrc          # Shared shell config: history, GPG, Go, aliases
│   └── _gnupg/         # GPG agent configuration (all platforms)
├── macos/
│   ├── install.sh      # macOS bootstrap script
│   ├── _zshrc          # macOS shell config (Homebrew, powerline-go, fzf)
│   ├── _gitconfig      # macOS git config (vim editor)
│   ├── _vimrc          # Vim configuration
│   ├── kitty.conf      # Kitty terminal config
│   └── vscode_settings.json
└── omarchy/
    ├── install.sh      # Omarchy/Arch bootstrap script
    ├── _zshrc          # Omarchy shell config (starship, fzf)
    ├── _gitconfig      # Omarchy git config (nvim editor)
    └── _hypr-input.conf # Hyprland input overrides (caps lock -> ctrl, touchpad)
```

## Installation

Run the top-level install script — it detects the platform, installs
prerequisites, clones this repo to `~/.dotfiles`, and delegates to the right
platform installer automatically:

```bash
curl -fsSL https://raw.githubusercontent.com/ianlofs/dotfiles/main/install.sh | bash
```

**macOS note:** If Xcode Command Line Tools are not installed, the script will
trigger the installation dialog and exit. Once the dialog completes, re-run the
curl command above to continue.

If the repo is already cloned, you can run a platform installer directly:

```bash
~/.dotfiles/macos/install.sh
~/.dotfiles/omarchy/install.sh
```

## How it works

### Shell config

The `_zshrc` files use a layered approach:

- `shared/_zshrc` — sourced by both platforms. Contains history settings, GPG
  agent setup, Go path, common PATH entries, and shared aliases.
- `macos/_zshrc` — sources shared, then adds Homebrew paths, compiler flags,
  fzf (via Homebrew), powerline-go prompt, and zsh-autosuggestions.
- `omarchy/_zshrc` — sources shared, then adds fzf (via pacman) and initializes
  the starship prompt.

### Hyprland overrides (Omarchy only)

`omarchy/_hypr-input.conf` contains only the delta from Omarchy's defaults.
It is sourced after Omarchy's default `input.conf` in `hyprland.conf`, so
Omarchy updates flow through freely for anything not explicitly overridden.

### Python

Both platforms use [uv](https://github.com/astral-sh/uv) for Python version
and package management.
