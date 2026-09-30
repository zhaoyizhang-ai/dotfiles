#!/bin/zsh

# Restart the complete Caps Lock -> HyperKey -> rcmd chain.
# This delegates to the LaunchAgent so HID mapping, startup order, and retry
# behavior stay identical to the login/wake path.

set -u

label="com.az.caps-hyper-rcmd"
uid=$(/usr/bin/id -u)
domain="gui/$uid/$label"
config="$HOME/.config/rcmd/config.yaml"

if ! /bin/launchctl print "$domain" >/dev/null 2>&1; then
  echo "❌ 找不到 $label；没有执行重启。"
  exit 1
fi

echo "正在重启 Caps+字母切换链路…"
if ! /bin/launchctl kickstart -k "$domain"; then
  echo "❌ launchctl 重启失败。"
  exit 1
fi

typeset -i attempt=1
while [ "$attempt" -le 15 ]; do
  agent_ok=0
  rcmd_ok=0
  hyperkey_ok=0
  mapping_ok=0
  config_ok=0

  if /usr/bin/pgrep -f 'caps-hyper-rcmd-wake-watcher' >/dev/null 2>&1 || \
     /bin/launchctl print "$domain" >/dev/null 2>&1; then
    agent_ok=1
  fi
  /usr/bin/pgrep -x rcmd >/dev/null 2>&1 && rcmd_ok=1
  /usr/bin/pgrep -x HyperKey >/dev/null 2>&1 && hyperkey_ok=1

  mapping=$(/usr/bin/hidutil property --get UserKeyMapping 2>/dev/null || true)
  if /usr/bin/grep -q '30064771129' <<< "$mapping" && \
     /usr/bin/grep -q '30064771181' <<< "$mapping"; then
    mapping_ok=1
  fi

  if /usr/bin/grep -Eq '^  t: \{app: /Applications/iTerm\.app,' "$config" && \
     ! /usr/bin/grep -Eq '^- t$' "$config" && \
     /usr/bin/grep -Eq '^  p: \{app: /Applications/Microsoft PowerPoint\.app,' "$config" && \
     ! /usr/bin/grep -Eq '^- p$' "$config"; then
    config_ok=1
  fi

  if [ "$agent_ok" -eq 1 ] && [ "$rcmd_ok" -eq 1 ] && \
     [ "$hyperkey_ok" -eq 1 ] && [ "$mapping_ok" -eq 1 ] && \
     [ "$config_ok" -eq 1 ]; then
    echo "✅ rcmd 快速重启完成：Caps+F/D/P/T 等固定切换已恢复。"
    exit 0
  fi

  /bin/sleep 1
  attempt=$((attempt + 1))
done

echo "⚠️ 已发出重启命令，但状态尚未完全恢复。"
echo "请把这段输出发给我："
echo "  launchctl print $domain"
echo "当前进程："
ps -axo pid,command | /usr/bin/grep -E 'HyperKey|/rcmd\.app|caps-hyper-rcmd-wake-watcher' | /usr/bin/grep -v grep || true
exit 1
