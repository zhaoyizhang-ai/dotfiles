# macOS + AI dotfiles

这套配置用于恢复 macOS 终端、开发工具、Rime 输入法和个人 AI 工具工作流，重点覆盖 Codex、Claude Code、共享 Agents Skills、VS Code/Cursor、Homebrew、iTerm2 与 Squirrel/Rime。

## 已备份内容

- 根目录：Zsh、Bash、Git 模板、Tmux、Conda、代理脚本和 iTerm2 配色/偏好。
- `ai/codex/`：全局 `AGENTS.md`、脱敏后的 `config.toml`、规则、通知脚本、个人 Skills 和 Skill 来源登记表。
- `ai/claude/`：脱敏后的设置、commands、hooks、MCP 源码和 Skills。
- `ai/agents/`：Codex/Claude 共用的个人 Skills。
- `editors/`：VS Code 与 Cursor 的设置、快捷键和 snippets。
- `software/`：Homebrew Bundle 与编辑器扩展清单。
- `developer/gh/config.yml`：GitHub CLI 的非认证设置。
- `input-method/rime/`：当前完整可部署的 Rime/Squirrel 方案、皮肤、Lua、主词库和个人短语。
- `macos/rcmd/`：rcmd 的窗口/App 快捷键、切换行为、搜索规则和 OSD 外观。

## 永远不备份

仓库是公开的。以下内容会被同步脚本和 `.gitignore` 排除：

- API key、token、Cookie、密码、私钥和 GitHub 登录凭据；
- Codex/Claude 的 `auth.json`、`.env`、会话、历史、记忆、项目记录和粘贴缓存；
- SQLite 状态库、日志、遥测、浏览器状态、虚拟环境、依赖缓存和安装 ID；
- GitHub CLI 的 `hosts.yml` 和 SSH 私钥。
- Rime 的安装 ID、用户词频数据库、同步目录和编译产物。
- rcmd 的 Paddle 授权、Sentry ID、窗口历史、应用扫描清单和权限状态。

配置里的 `__HOME__` 会在恢复时自动替换；`__SET_LOCALLY__`、`__GIT_NAME__`、`__GIT_EMAIL__` 必须在本机填写，不能提交真实值。

## 恢复

先查看将要恢复的内容，然后运行：

```bash
git clone https://github.com/zhaoyizhang-ai/dotfiles.git
cd dotfiles
./scripts/scan-secrets.py
./install.sh
```

恢复脚本会先把被覆盖的文件保存到 `~/.dotfiles-restore-backup/<时间戳>/`。它不会恢复认证状态；完成后需要重新登录 Codex、Claude Code 和 GitHub CLI，并在本机补充秘密值。iTerm2 设置恢复后需重启 iTerm2。

Rime 的当前主词库与个人配置已经完整包含。新 Mac 可直接运行 `./scripts/restore-rime.sh`：脚本会安装 Squirrel、备份目标机已有 Rime 数据、恢复配置并重新部署。

rcmd 可运行 `./scripts/restore-rcmd.sh` 单独恢复；脚本会保留目标机授权状态，只合并快捷键和窗口切换配置。macOS 辅助功能权限仍需在系统设置中手动授予。

恢复软件与 VS Code 扩展：

```bash
brew bundle --file software/Brewfile
xargs -L 1 code --install-extension < software/vscode-extensions.txt
```

## 更新备份

```bash
./scripts/sync-from-home.py
./scripts/scan-secrets.py
git diff --stat
```

`sync-from-home.py` 使用白名单复制，并对 Home 路径、Git 身份、常见凭据赋值和 iTerm 动态状态做脱敏。扫描未通过时不要提交。
