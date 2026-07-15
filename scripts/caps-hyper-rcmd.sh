#!/bin/zsh
set -euo pipefail

# Keep macOS from treating the physical Caps Lock key as Caps Lock. HyperKey
# reads the raw HID usage before this user mapping and still emits Hyper.
/usr/bin/hidutil property --set \
  '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}' \
  >/dev/null

# rcmd must install its event tap first. HyperKey starts second so its
# head-insert tap suppresses the original Caps event before rcmd sees it.
/usr/bin/killall HyperKey 2>/dev/null || true
/usr/bin/killall rcmd 2>/dev/null || true
/usr/bin/open -a rcmd
/bin/sleep 2
/usr/bin/open -a HyperKey
