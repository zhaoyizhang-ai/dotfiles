# dotfiles

My personal macOS terminal configuration.

## Files

- `.zshrc` — Zsh config (Oh My Zsh, plugins, aliases, Codex/proxy helpers)
- `.zprofile` — PATH and environment setup
- `.tmux.conf` — Tmux config (C-a prefix)
- `.proxy.sh` — Proxy toggle (proxy on/off/status)
- `.condarc` — Conda mirror config (Tsinghua)
- `iterm2.plist` — iTerm2 preferences backup
- `Catppuccin-Mocha.itermcolors` — iTerm2 color scheme
- `Solarized-Dark.itermcolors` — iTerm2 color scheme

## Restore

```bash
cp .zshrc ~/.zshrc && source ~/.zshrc
cp .tmux.conf ~/.tmux.conf
cp .proxy.sh ~/.proxy.sh
cp .condarc ~/.condarc
cp iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
```

Then restart iTerm2.
