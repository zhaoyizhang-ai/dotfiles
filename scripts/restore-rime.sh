#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_DIR/input-method/rime"
TARGET_DIR="$HOME/Library/Rime"
SQUIRREL_BIN="${SQUIRREL_BIN:-/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel}"
BACKUP_DIR="$HOME/.dotfiles-restore-backup/$(date +%Y%m%d-%H%M%S)/Library/Rime"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Rime restore currently supports macOS/Squirrel only." >&2
  exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Missing backup directory: $SOURCE_DIR" >&2
  exit 1
fi

if [[ ! -x "$SQUIRREL_BIN" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Install Homebrew first: https://brew.sh/" >&2
    exit 1
  fi
  brew install --cask squirrel-app
fi

if [[ -d "$TARGET_DIR" ]]; then
  mkdir -p "$BACKUP_DIR"
  cp -R "$TARGET_DIR"/. "$BACKUP_DIR"/
  echo "Existing Rime data backed up to: $BACKUP_DIR"
fi

mkdir -p "$TARGET_DIR"
rsync -a --delete \
  --exclude installation.yaml \
  --exclude user.yaml \
  --exclude build/ \
  --exclude sync/ \
  --exclude '*.userdb/' \
  "$SOURCE_DIR"/ "$TARGET_DIR"/

"$SQUIRREL_BIN" --reload

if ! grep -q 'color_scheme: mojave_dark' "$TARGET_DIR/build/squirrel.yaml"; then
  echo "Rime restored, but the expected mojave_dark theme was not found after deploy." >&2
  exit 1
fi

echo "Rime/Squirrel restored and deployed successfully."
