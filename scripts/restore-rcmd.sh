#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_PLIST="$REPO_DIR/macos/rcmd/preferences.plist"
DOMAIN="com.lowtechguys.rcmd"
RCMD_APP="/Applications/rcmd.app"
BACKUP_DIR="$HOME/.dotfiles-restore-backup/$(date +%Y%m%d-%H%M%S)/rcmd"
TEMP_DIR="$(mktemp -d -t rcmd-restore)"
CURRENT_PLIST="$TEMP_DIR/current.plist"
MERGED_PLIST="$TEMP_DIR/merged.plist"
trap 'rm -rf "$TEMP_DIR"' EXIT

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "rcmd restore supports macOS only." >&2
  exit 1
fi

if [[ ! -f "$SOURCE_PLIST" ]]; then
  echo "Missing rcmd backup: $SOURCE_PLIST" >&2
  exit 1
fi

if [[ ! -d "$RCMD_APP" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Install Homebrew first: https://brew.sh/" >&2
    exit 1
  fi
  brew install --cask rcmd
fi

if defaults export "$DOMAIN" "$CURRENT_PLIST" 2>/dev/null; then
  mkdir -p "$BACKUP_DIR"
  cp -p "$CURRENT_PLIST" "$BACKUP_DIR/preferences.plist"
  echo "Existing rcmd preferences backed up to: $BACKUP_DIR"
else
  python3 -c 'import plistlib,sys; plistlib.dump({}, open(sys.argv[1], "wb"))' "$CURRENT_PLIST"
fi

python3 "$REPO_DIR/scripts/merge-rcmd-prefs.py" \
  --source "$SOURCE_PLIST" \
  --current "$CURRENT_PLIST" \
  --output "$MERGED_PLIST" \
  --home "$HOME"

killall rcmd 2>/dev/null || true
defaults import "$DOMAIN" "$MERGED_PLIST"
open -a rcmd

echo "rcmd shortcuts, switcher behavior and appearance restored successfully."
