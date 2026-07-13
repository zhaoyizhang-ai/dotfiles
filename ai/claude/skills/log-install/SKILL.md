---
name: log-install
description: After any package/model/file download or installation on the baidu server, write a structured log entry recording the source, method, result, and traceability info. Call this after every scp, pip install, wget, curl, or model download on the server.
argument-hint: "[item_name] [destination_path]"
allowed-tools: Read, Write, Edit, Bash(ssh *), Bash(scp *), Bash(date *), Bash(ls *)
metadata:
  category: infra
  tags: [logging, install, download, server, baidu, traceability]
  triggers:
    - 下载到服务器
    - 安装依赖
    - pip install
    - scp to server
    - download model
    - 记录安装
---

# Log Install

Write a structured install/download log on the baidu server whenever a package, model, file, or dataset is downloaded or installed.

## When to use

Call this skill **after every download or installation operation on the baidu server**, including:
- `pip install` (packages, git repos)
- `scp` / `rsync` file transfers to the server
- `wget` / `curl` downloads on the server
- Model weights pulled via `huggingface_hub` or similar
- Conda environment changes

## Input

- `$ARGS` — item name and/or destination path, e.g. `diffusers-dev /mnt/pfs/users/zhaoyi/scratch/cosmos_test`

## Process

### Step 1 — Collect facts from conversation context

Gather all of the following:

1. **时间**: `ssh baidu "date '+%Y-%m-%d %H:%M:%S'"` 
2. **安装项目**: package name, version, or file name
3. **来源**: exact source URL, git repo, PyPI name, local path, or HuggingFace repo ID
4. **安装方式**: the exact command used (pip, scp, curl, wget, git clone, etc.)
5. **目标路径**: full server path where item was installed/placed
6. **安装结果**: success / failure / version confirmed
7. **环境**: conda env name, Python version if relevant
8. **备注**: why this was needed, any workarounds used (e.g. proxy, mirror, local transfer)

### Step 2 — Write log locally, then upload

**Do NOT use heredoc over SSH.** Write locally first, then SCP.

```bash
# 1. Write to local temp file using Write tool
Write tool -> /tmp/install_<item_name>_<date>.md

# 2. Append to the server's install log (one file per project)
scp -P 4997 -i __HOME__/Desktop/SSH-WM/baidu_machine/id_ed25519 \
    /tmp/install_<item_name>_<date>.md \
    zhaoyi@114.111.19.170:/mnt/pfs/users/zhaoyi/logs/install_log.md.tmp

ssh baidu "cat /mnt/pfs/users/zhaoyi/logs/install_log.md.tmp >> \
    /mnt/pfs/users/zhaoyi/logs/install_log.md && \
    rm /mnt/pfs/users/zhaoyi/logs/install_log.md.tmp"
```

**Also keep a local copy** appended to `logs/install_log.md` under the project root.

### Step 3 — Verify

```bash
ssh baidu "tail -20 /mnt/pfs/users/zhaoyi/logs/install_log.md"
```

Confirm the entry appears in the log.

## Log entry template

Each entry is appended (not overwritten) to `install_log.md`:

```markdown
---

## [<YYYY-MM-DD HH:MM>] <item_name>

**安装项目：** <package name, version, or file description>
**来源：** <exact URL / git repo / PyPI name / HuggingFace ID / local path>
**安装方式：** 
\`\`\`bash
<exact command(s) used>
\`\`\`
**目标路径：** `<full server path>`
**环境：** <conda env name, Python version>
**结果：** <✅ 成功 / ❌ 失败 — include version confirmed or error message>
**备注：** <why needed; any workarounds e.g. proxy tunnel, local transfer, mirror>
```

## Example entry

```markdown
---

## [2026-06-02 16:00] diffusers-dev (0.39.0.dev0)

**安装项目：** diffusers 开发版（含 Cosmos3OmniPipeline）
**来源：** https://github.com/huggingface/diffusers.git （main branch）
**安装方式：**
\`\`\`bash
# GitHub 无法直连，通过本地反向代理安装
export https_proxy=http://127.0.0.1:7897
export http_proxy=http://127.0.0.1:7897
pip install 'git+https://github.com/huggingface/diffusers.git' --no-deps
\`\`\`
**目标路径：** `/mnt/pfs/users/zhaoyi/miniconda3/envs/ctrl-world/lib/python3.11/site-packages/diffusers`
**环境：** ctrl-world, Python 3.11
**结果：** ✅ 成功，版本 0.39.0.dev0，`Cosmos3OmniPipeline` import 正常
**备注：** PyPI 最新版 0.38.0 不含 Cosmos 3 支持；服务器无法直连 GitHub（OpenSSL SSL_read 错误），通过本地 7897 端口反向 SSH 隧道代理解决
```
