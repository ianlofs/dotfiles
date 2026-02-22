# Claude Context for dotfiles

## Repo Structure

```
dotfiles/
├── install.sh          # Top-level: detects platform, installs prereqs, clones repo, delegates
├── _gitignore          # Global gitignore (all platforms)
├── shared/
│   ├── _zshrc          # Shared shell config: history, GPG, Go, PATH, aliases
│   └── _gnupg/         # GPG config (all platforms)
├── macos/
│   ├── install.sh      # Homebrew packages, casks, VSCode extensions, symlinks
│   ├── _zshrc          # Sources shared/_zshrc; adds Homebrew, fzf, powerline-go, autosuggestions
│   ├── _gitconfig      # editor = /opt/homebrew/bin/vim
│   ├── _vimrc
│   ├── kitty.conf
│   └── vscode_settings.json
└── omarchy/
    ├── install.sh      # pacman packages, symlinks
    ├── _zshrc          # Sources shared/_zshrc; adds fzf, starship
    ├── _gitconfig      # editor = /usr/bin/nvim
    └── _hypr-input.conf # Hyprland input overrides (delta only)
```

## Install Flow

- Top-level `install.sh` handles: Xcode CLT + Homebrew (macOS) or git (Arch), clones repo to `~/.dotfiles`, then calls the platform script
- Platform scripts assume the repo is already at `~/.dotfiles` — do not curl them directly
- macOS note: if Xcode CLT is not installed, the script exits after triggering the dialog; user must re-run
- Dotfiles dir is hardcoded as `$HOME/.dotfiles` in all scripts

## Shell Config Layering

- `shared/_zshrc` is sourced by both platforms via `${${(%):-%x}:A:h}/../shared/_zshrc`
- Shared contains: history, GPG agent, Go path, `$HOME/.bin`/`.local/bin` PATH, common aliases
- Each platform adds its own: PATH, `ls` alias, fzf source, prompt init, completions

## Omarchy-Specific Notes

- fzf via pacman; source `/usr/share/fzf/key-bindings.zsh` and `/usr/share/fzf/completion.zsh`
- Starship prompt (not powerline-go)
- Alacritty and starship.toml are managed by Omarchy — do NOT track in dotfiles
- Hyprland: Omarchy sources its defaults first, then `~/.config/hypr/*.conf` as overrides
- Always save only deltas from Omarchy defaults (e.g. `_hypr-input.conf` has kb_options, repeat_rate, touchpad settings — not the full file)
- Symlinks work fine with Hyprland auto-reload

## Preferences

- No asdf anywhere — use uv for Python
- No poetry — use uv
- Do not manage alacritty or starship configs — Omarchy owns those
- Hyprland overrides: delta files only, never full copies of Omarchy defaults
- Caps lock → Ctrl set in `omarchy/_hypr-input.conf` via `kb_options = ctrl:nocaps`
