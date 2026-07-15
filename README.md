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
- `macos/keyboard/`：Caps→F18→HyperKey→rcmd 的持久化方案，关闭大小写/输入法功能并固定切 App。
- `macos/preferences/`：白名单化的键盘、Dock、Finder、截图、DockDoor、QuickRecorder 与系统快捷键偏好。
- `apps/kando/`：Kando 的菜单、手势和外观配置，不含 Electron 会话与 Cookie。
- `RESTORE_FOR_AI.md`：给下一个 AI 的安全恢复顺序、禁止项和验收标准。
- `CONFIG_INVENTORY.md`：本机配置盘点、已备份范围与明确排除项。

## 永远不备份

仓库是公开的。以下内容会被同步脚本和 `.gitignore` 排除：

- API key、token、Cookie、密码、私钥和 GitHub 登录凭据；
- Codex/Claude 的 `auth.json`、`.env`、会话、历史、记忆、项目记录和粘贴缓存；
- SQLite 状态库、日志、遥测、浏览器状态、虚拟环境、依赖缓存和安装 ID；
- GitHub CLI 的 `hosts.yml` 和 SSH 私钥。
- Rime 的安装 ID、用户词频数据库、同步目录和编译产物。
- rcmd 的 Paddle 授权、Sentry ID、窗口历史、应用扫描清单和权限状态。
- Safari 历史/书签/Cookie、备忘录正文、Deck/Typeless 内容库、Bartender 许可证和任何 App 会话数据。

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

rcmd 可运行 `./scripts/restore-rcmd.sh` 单独恢复。完整的 Caps 快速切 App 方案运行 `./scripts/restore-caps-hyper-rcmd.sh`；脚本恢复 Caps→F18、HyperKey、rcmd YAML、登录持久化和正确启动顺序。macOS 辅助功能/输入监控权限仍需手动授予。

恢复软件与 VS Code 扩展：

```bash
brew bundle --file software/Brewfile
xargs -L 1 code --install-extension < software/vscode-extensions.txt
```

Homebrew 清单会显式补入当前 Caps 映射依赖的 Chrome、Zotero、Obsidian、VS Code、ChatGPT，以及已备份偏好的 DockDoor；Safari 和备忘录由 macOS 自带。

## 更新备份

```bash
./scripts/sync-from-home.py
./scripts/scan-secrets.py
git diff --stat
```

`sync-from-home.py` 使用白名单复制，并对 Home 路径、Git 身份、常见凭据赋值和 iTerm 动态状态做脱敏。扫描未通过时不要提交。
