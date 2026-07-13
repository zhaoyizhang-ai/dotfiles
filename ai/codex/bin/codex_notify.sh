#!/bin/zsh
set -euo pipefail

message="${1:-Codex 通知}"
subtitle="${2:-任务完成}"
title="${3:-Codex}"

frontmost_bundle_id="$(/usr/bin/osascript -e 'id of application (path to frontmost application as text)' 2>/dev/null || true)"

if [ "${CODEX_NOTIFY_ONLY_WHEN_FRONTMOST:-1}" = "1" ] && [ "$frontmost_bundle_id" != "com.openai.codex" ]; then
  exit 0
fi

if [ -x /opt/homebrew/bin/terminal-notifier ]; then
  /opt/homebrew/bin/terminal-notifier \
    -title "$title" \
    -subtitle "$subtitle" \
    -message "$message" \
    -sound Glass \
    -activate com.openai.codex \
    -ignoreDnD >/dev/null 2>&1 || true
  exit 0
fi

/usr/bin/osascript - "$message" "$subtitle" "$title" <<'APPLESCRIPT'
on run argv
  set msgText to item 1 of argv
  set subtitleText to item 2 of argv
  set titleText to item 3 of argv
  display notification msgText with title titleText subtitle subtitleText sound name "Glass"
end run
APPLESCRIPT
