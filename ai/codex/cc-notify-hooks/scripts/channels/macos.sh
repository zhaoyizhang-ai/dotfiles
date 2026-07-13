#!/usr/bin/env bash
# macOS 系统原生通知（osascript）

send_macos() {
    local title="$1" body="$2" config="$3"
    local sound
    sound=$(echo "$config" | jq -r '.sound // "Glass"')

    # 转义特殊字符防止 osascript 注入
    local safe_body safe_title
    safe_body=$(printf '%s' "$body" | sed 's/\\/\\\\/g;s/"/\\"/g')
    safe_title=$(printf '%s' "$title" | sed 's/\\/\\\\/g;s/"/\\"/g')

    if [ -x "${HOME}/.codex/bin/codex_notify.sh" ]; then
        "${HOME}/.codex/bin/codex_notify.sh" "$body" "$title" "Codex" 2>/dev/null || true
    else
        osascript -e "display notification \"$safe_body\" with title \"$safe_title\" sound name \"$sound\"" 2>/dev/null || true
    fi
}
