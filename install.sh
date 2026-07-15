#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles-restore-backup/$(date +%Y%m%d-%H%M%S)"

restore_file() {
  local source="$1"
  local target="$2"
  [[ -f "$source" ]] || return 0
  mkdir -p "$(dirname "$target")" "$BACKUP_DIR/$(dirname "${target#$HOME/}")"
  if [[ -e "$target" ]]; then
    cp -p "$target" "$BACKUP_DIR/${target#$HOME/}"
  fi
  sed "s#__HOME__#${HOME//\#/\\#}#g" "$source" > "$target"
}

restore_tree() {
  local source="$1"
  local target="$2"
  [[ -d "$source" ]] || return 0
  if [[ -e "$target" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${target#$HOME/}")"
    cp -R "$target" "$BACKUP_DIR/${target#$HOME/}"
  fi
  mkdir -p "$target"
  cp -R "$source"/. "$target"/
  while IFS= read -r -d '' file; do
    if file "$file" | grep -q text; then
      sed -i '' "s#__HOME__#${HOME//\#/\\#}#g" "$file"
    fi
  done < <(find "$target" -type f -print0)
}

for name in .zshrc .zprofile .bash_profile .tmux.conf .condarc .proxy.sh; do
  restore_file "$REPO_DIR/$name" "$HOME/$name"
done

if grep -q '__GIT_' "$REPO_DIR/.gitconfig"; then
  echo "Skipped .gitconfig: replace __GIT_NAME__ and __GIT_EMAIL__ first."
else
  restore_file "$REPO_DIR/.gitconfig" "$HOME/.gitconfig"
fi

restore_file "$REPO_DIR/ai/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
restore_file "$REPO_DIR/ai/codex/SKILL_PROVENANCE.md" "$HOME/.codex/SKILL_PROVENANCE.md"
restore_file "$REPO_DIR/ai/codex/config.toml" "$HOME/.codex/config.toml"
restore_file "$REPO_DIR/ai/codex/keybindings.json" "$HOME/.codex/keybindings.json"
restore_file "$REPO_DIR/ai/codex/hooks.json" "$HOME/.codex/hooks.json"
restore_tree "$REPO_DIR/ai/codex/rules" "$HOME/.codex/rules"
restore_tree "$REPO_DIR/ai/codex/bin" "$HOME/.codex/bin"
restore_tree "$REPO_DIR/ai/codex/cc-notify-hooks" "$HOME/.codex/cc-notify-hooks"
restore_tree "$REPO_DIR/ai/codex/skills" "$HOME/.codex/skills"
restore_tree "$REPO_DIR/ai/agents/skills" "$HOME/.agents/skills"

restore_file "$REPO_DIR/ai/claude/settings.json" "$HOME/.claude/settings.json"
restore_tree "$REPO_DIR/ai/claude/commands" "$HOME/.claude/commands"
restore_tree "$REPO_DIR/ai/claude/skills" "$HOME/.claude/skills"
restore_tree "$REPO_DIR/ai/claude/hooks" "$HOME/.claude/hooks"
restore_tree "$REPO_DIR/ai/claude/mcp" "$HOME/.claude/mcp"

restore_file "$REPO_DIR/editors/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
restore_file "$REPO_DIR/editors/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
restore_tree "$REPO_DIR/editors/vscode/snippets" "$HOME/Library/Application Support/Code/User/snippets"
restore_file "$REPO_DIR/editors/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
restore_file "$REPO_DIR/editors/cursor/keybindings.json" "$HOME/Library/Application Support/Cursor/User/keybindings.json"
restore_tree "$REPO_DIR/editors/cursor/snippets" "$HOME/Library/Application Support/Cursor/User/snippets"

restore_file "$REPO_DIR/developer/gh/config.yml" "$HOME/.config/gh/config.yml"
restore_file "$REPO_DIR/iterm2.plist" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
restore_tree "$REPO_DIR/input-method/rime" "$HOME/Library/Rime"
restore_file "$REPO_DIR/apps/kando/config.json" "$HOME/Library/Application Support/kando/config.json"
restore_file "$REPO_DIR/apps/kando/menus.json" "$HOME/Library/Application Support/kando/menus.json"

SQUIRREL_BIN="/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel"
if [[ -x "$SQUIRREL_BIN" ]]; then
  "$SQUIRREL_BIN" --reload
else
  echo "Squirrel is not installed; run ./scripts/restore-rime.sh to install and deploy it."
fi

if [[ -x "$REPO_DIR/scripts/restore-caps-hyper-rcmd.sh" ]]; then
  "$REPO_DIR/scripts/restore-caps-hyper-rcmd.sh"
fi

if [[ -x "$REPO_DIR/macos/preferences/restore.sh" ]]; then
  "$REPO_DIR/macos/preferences/restore.sh"
fi

echo "Configuration restored. Previous files were saved under: $BACKUP_DIR"
echo "Secrets and login state were intentionally not restored; sign in and set API keys locally."
echo "Rime configuration is included and was redeployed when Squirrel was available."
echo "Caps/Hyper/rcmd was restored; macOS privacy permissions still require manual approval."
echo "Kando and selected macOS/Finder/Dock/app preferences were restored."
