# dotfiles

My personal macOS terminal configuration.

## Files

- `.zshrc` — Zsh config (Oh My Zsh, plugins, aliases)
- `.zprofile` — PATH and environment setup
- `iterm2.plist` — iTerm2 preferences backup

## Restore iTerm2

```bash
cp iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
```
Then restart iTerm2.

## Restore zsh

```bash
cp .zshrc ~/.zshrc && source ~/.zshrc
```
