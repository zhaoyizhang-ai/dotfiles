#!/bin/zsh
set -euo pipefail

open_app_with_retry() {
  local app="$1"
  local attempt=1
  while [ "$attempt" -le 5 ]; do
    if /usr/bin/open -a "$app"; then
      return 0
    fi
    /bin/sleep 2
    attempt=$((attempt + 1))
  done
  echo "[caps-hyper-rcmd] failed to open $app after 5 attempts" >&2
  return 1
}

# Keep macOS from treating the physical Caps Lock key as Caps Lock. HyperKey
# reads the raw HID usage before this user mapping and still emits Hyper.
/usr/bin/hidutil property --set \
  '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}' \
  >/dev/null

# Start rcmd first, then let HyperKey add the four modifier flags after its
# event tap is ready. This is the original working order for this setup.
/usr/bin/killall HyperKey 2>/dev/null || true
/usr/bin/killall rcmd 2>/dev/null || true
open_app_with_retry "/Applications/rcmd.app"
/bin/sleep 2
open_app_with_retry "/Applications/HyperKey.app"
