# 给下一个 AI：安全恢复这台 Mac 的个人配置

这份仓库是公开、可恢复的配置快照。恢复目标是复现用户当前工作流，不修改主题、外观或快捷键设计，也不导入任何认证和运行状态。

## 必须遵守

1. 先运行 `./scripts/scan-secrets.py`；失败时停止，不要上传或恢复可疑内容。
2. 只使用仓库已有的白名单脚本。不要复制整个 `~/.codex`、`~/.claude`、`~/.agents`、`~/Library` 或 Keychain。
3. 不恢复 API key、token、Cookie、密码、SSH 私钥、GitHub `hosts.yml`、Codex/Claude 登录和会话数据。
4. 恢复脚本会备份目标机原文件；不要跳过备份，也不要覆盖目标机授权/许可证状态。
5. 保持当前视觉外观和用户行为，不主动“优化”主题或快捷键。

## 推荐恢复顺序

```bash
git clone https://github.com/zhaoyizhang-ai/dotfiles.git
cd dotfiles
./scripts/scan-secrets.py
brew bundle --file software/Brewfile
./install.sh
```

`install.sh` 恢复：

- Zsh、Bash、Tmux、Conda、Git 模板和代理脚本；
- iTerm2 的稳定偏好与配色；
- VS Code/Cursor 设置、快捷键和 snippets；
- Codex、Claude Code、共享 Agents Skills；
- Rime/Squirrel 输入方案；
- Caps→HyperKey→rcmd 固定 App 切换。
- Kando 菜单，以及白名单化的 macOS、Finder、Dock、DockDoor 和 QuickRecorder 偏好。

恢复后由用户在本机重新登录 Codex、Claude、GitHub CLI，并设置秘密值。不要要求用户把秘密提交到本仓库。

## Caps/Hyper/rcmd 的成功标准

先阅读 `macos/keyboard/README.md`。配置链不能简化成单独 rcmd 或单独 HyperKey：

```text
物理 Caps -> hidutil 映射为 F18 -> HyperKey 生成左 Hyper -> rcmd 切 App
```

必须保持：

- rcmd 配置：`triggerKeys: [lcmd, lalt, lctrl, lshift]`；
- 启动顺序：rcmd 先，HyperKey 后；
- 登录时重新应用 Caps→F18；
- 辅助功能授权 HyperKey、rcmd；输入监控授权 HyperKey。

最终让用户实际按键验证：

- 单按 Caps：无灯、无大小写、无输入法切换；
- Caps+F：Chrome；Caps+D：Zotero；
- Caps+E：Safari；Caps+R：Finder；Caps+B：备忘录；
- 其他绑定以 `macos/rcmd/config.yaml` 为准。

## 更新备份

```bash
./scripts/sync-from-home.py
./scripts/scan-secrets.py
git diff --stat
```

审查 diff 后只提交稳定配置。尤其检查：Home 绝对路径、电子邮箱、token、设备 ID、许可证、窗口历史、Rime 用户词频、日志、缓存和数据库。
