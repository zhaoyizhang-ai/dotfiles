# 这台 Mac 的公开配置盘点

本文给下一个 AI 说明哪些设置可从本仓库恢复，哪些内容只能由用户在本机登录或同步。仓库是公开的，恢复完整工作流比复制全部运行数据更重要。

## 已自动备份并可恢复

| 范围 | 位置 | 恢复内容 |
| --- | --- | --- |
| 终端 | 根目录、`iterm2.plist` | Zsh、Bash、Tmux、Conda、Git 模板、代理函数、iTerm2 稳定偏好与配色 |
| 开发工具 | `editors/`、`developer/`、`software/` | VS Code/Cursor 设置与扩展、GitHub CLI 非认证设置、Homebrew 软件清单 |
| AI 工具 | `ai/` | Codex、Claude Code、共享 Skills、Hooks、Rules 与来源登记，不含登录/会话 |
| 输入法 | `input-method/rime/` | Rime/Squirrel 方案、Lua、词库和用户维护的短语，不含用户词频数据库 |
| App 切换 | `macos/keyboard/`、`macos/rcmd/` | Caps→F18→HyperKey→rcmd 整条链及固定 App 映射 |
| 系统习惯 | `macos/preferences/` | 明确白名单中的 Dock、Finder、键盘、截图、系统快捷键、DockDoor、QuickRecorder 设置 |
| Kando | `apps/kando/` | 菜单、手势、主题与快捷键，不含 Electron Session/Cookie/缓存 |

`software/Brewfile` 还会显式安装当前映射依赖的 Chrome、Zotero、Obsidian、VS Code、ChatGPT 和 DockDoor；Safari、备忘录由 macOS 自带。

## 当前 Caps App 映射

| 按键 | App |
| --- | --- |
| Caps+F | Google Chrome |
| Caps+D | Zotero |
| Caps+S | ChatGPT / Codex |
| Caps+G | Obsidian |
| Caps+V | Visual Studio Code |
| Caps+E | Safari |
| Caps+B | 备忘录 |

`Caps+R` 已取消，预览也不再占用 `Caps+E`。

## 明确不上传

- Safari、Chrome 等浏览器的历史、Cookie、密码、Profile 和缓存；书签应使用浏览器/iCloud 自己的同步。
- 备忘录正文、通讯录、日历、邮件、照片和 iCloud 数据；在目标机登录 Apple 账户恢复。
- Keychain、SSH 私钥、API key、token、Cookie、账号凭据和 GitHub `hosts.yml`。
- Typeless 的音频/转写内容，Deck 的数据库/剪贴板/Token，Obsidian 笔记库，Zotero 文献库。
- Bartender 的许可证、试用状态、运行记录；当前未导出其复杂 Profile，避免夹带许可证或脚本。
- App 日志、遥测、数据库、浏览器/Electron Session、窗口历史、设备 ID、TCC 权限数据库。

## 下一个 AI 的处理原则

1. 先读 `RESTORE_FOR_AI.md` 和本文件，再运行秘密扫描。
2. 使用 `scripts/sync-from-home.py` 的白名单扩充配置，禁止镜像复制 `~/Library` 或整个 Home。
3. 新增 App 前先判断“设置”和“用户内容”的边界；只提交可公开、可复现的稳定设置。
4. macOS 辅助功能、输入监控、Apple 登录、软件许可证和秘密值都在本机重新授权。
