# 代理开关 — 在 .zshrc 里 source 这个文件即可
# 用法: proxy on / proxy off / proxy status

PROXY_ADDR="127.0.0.1:7897"

# 检测 7897 代理能否连通 GitHub
chkproxy() {
  local code=$(curl -x "socks5h://${PROXY_ADDR}" -s -o /dev/null -w "%{http_code}" --connect-timeout 5 https://github.com 2>/dev/null)
  if [[ "$code" == "200" ]]; then
    echo "✅ 7897 → GitHub 正常 (HTTP $code)"
  else
    echo "❌ 7897 → GitHub 不通 (HTTP $code)"
  fi
}

proxy() {
  case "$1" in
    on)
      # 先检测端口是否通
      if ! nc -z -w 2 127.0.0.1 7897 2>/dev/null; then
        echo "❌ 7897 端口没开，检查 Clash Verge 是否运行"
        return 1
      fi
      export http_proxy="http://${PROXY_ADDR}"
      export https_proxy="http://${PROXY_ADDR}"
      export ALL_PROXY="socks5://${PROXY_ADDR}"
      echo "✅ 代理已开启 → ${PROXY_ADDR}"
      ;;
    off)
      unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY
      echo "✅ 代理已关闭"
      ;;
    status)
      if [[ -n "$http_proxy" ]]; then
        echo "🟢 代理开启中 → $http_proxy"
      else
        echo "⚪ 代理未开启"
      fi
      ;;
    *)
      echo "用法: proxy on | off | status"
      ;;
  esac
}
