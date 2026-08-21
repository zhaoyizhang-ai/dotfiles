#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HYPERKEY_VERSION="1.0.0"
HYPERKEY_SHA256="5ef3e724cd7d6ea6d06d65112634cafd6a16f717bfe799efcadcaaeb25981582"
HYPERKEY_URL="https://github.com/n0an/hyperkey/releases/download/v${HYPERKEY_VERSION}/HyperKey.dmg"
HYPERKEY_APP="/Applications/HyperKey.app"
HELPER_TARGET="$HOME/.local/bin/caps-hyper-rcmd"
RESTART_TARGET="$HOME/.local/bin/rcmd-restart"
LAUNCH_AGENT="$HOME/Library/LaunchAgents/com.az.caps-hyper-rcmd.plist"
TEMP_DIR="$(mktemp -d -t caps-hyper-restore)"
MOUNT_DIR="$TEMP_DIR/mount"

cleanup() {
  hdiutil detach "$MOUNT_DIR" -quiet 2>/dev/null || true
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Caps/Hyper/rcmd restore supports macOS only." >&2
  exit 1
fi

if [[ ! -d /Applications/rcmd.app ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Install Homebrew first: https://brew.sh/" >&2
    exit 1
  fi
  brew install --cask rcmd
fi

hyperkey_is_expected_build() {
  local metadata
  [[ -d "$HYPERKEY_APP" ]] || return 1
  metadata="$(codesign -dv --verbose=2 "$HYPERKEY_APP" 2>&1)" || return 1
  grep -q 'TeamIdentifier=358V8FBM3U' <<<"$metadata" || return 1
  spctl -a "$HYPERKEY_APP" >/dev/null 2>&1
}

if ! hyperkey_is_expected_build; then
  DMG="$TEMP_DIR/HyperKey.dmg"
  mkdir -p "$MOUNT_DIR"
  curl -fL "$HYPERKEY_URL" -o "$DMG"
  ACTUAL_SHA256="$(shasum -a 256 "$DMG" | awk '{print $1}')"
  if [[ "$ACTUAL_SHA256" != "$HYPERKEY_SHA256" ]]; then
    echo "HyperKey checksum mismatch; refusing to install." >&2
    exit 1
  fi
  hdiutil attach "$DMG" -nobrowse -readonly -mountpoint "$MOUNT_DIR" -quiet
  spctl -a -vv "$MOUNT_DIR/HyperKey.app"
  rm -rf "$HYPERKEY_APP"
  ditto "$MOUNT_DIR/HyperKey.app" "$HYPERKEY_APP"
fi

"$REPO_DIR/scripts/restore-rcmd.sh"

mkdir -p "$(dirname "$HELPER_TARGET")" "$(dirname "$RESTART_TARGET")" "$(dirname "$LAUNCH_AGENT")"
install -m 0755 "$REPO_DIR/scripts/caps-hyper-rcmd.sh" "$HELPER_TARGET"
install -m 0755 "$REPO_DIR/scripts/rcmd-restart.sh" "$RESTART_TARGET"
install -m 0644 \
  "$REPO_DIR/macos/keyboard/com.az.caps-hyper-rcmd.plist" \
  "$LAUNCH_AGENT"
plutil -lint "$LAUNCH_AGENT"

launchctl bootout "gui/$UID/com.az.caps-hyper-rcmd" 2>/dev/null || true
launchctl bootstrap "gui/$UID" "$LAUNCH_AGENT"

echo "Caps -> F18 -> HyperKey -> rcmd restore installed."
echo "Manual permissions still required:"
echo "  Accessibility: enable HyperKey and rcmd"
echo "  Input Monitoring: enable HyperKey"
echo "After granting permissions, run: $HELPER_TARGET"
echo "Quick restart command: $RESTART_TARGET"
