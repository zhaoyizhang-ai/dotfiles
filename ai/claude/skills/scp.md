# SCP from Baidu Server

Download files or directories from the baidu server to local.

## When to use

When the user wants to pull experiment outputs, videos, logs, or any files from the baidu server to their local machine.

## Input

- `$ARGS` — server path(s) to download, e.g. `/mnt/pfs/users/zhaoyi/outputs/irasim_droid_v2_quick`
  - If no path given, ask the user which run/file they want

## Process

### Step 1 — Resolve the server path

- If `$ARGS` contains a full server path (starts with `/`), use it directly.
- If `$ARGS` is just a run name (e.g. `irasim_droid_v2_quick`), check if it exists at `/mnt/pfs/users/zhaoyi/outputs/<name>` via `ssh baidu "ls /mnt/pfs/users/zhaoyi/outputs/<name>"`.
- If the path cannot be resolved, ask the user for the exact server path before proceeding.

### Step 2 — Determine local destination

Default local base: `__HOME__/Desktop/SSH-WM/success_failure_wm_eval/outputs/`

Mirror the server folder structure under this base:
- `/mnt/pfs/users/zhaoyi/outputs/irasim_droid_v2_quick/` → `outputs/irasim_droid_v2_quick/`
- `/mnt/pfs/users/zhaoyi/outputs/ctrl_world_droid_run5/` → `outputs/ctrl_world_droid_run5/`

If the user specifies a different local destination, use that instead.

### Step 3 — Check what's inside before downloading

```bash
ssh baidu "find <server_path> -type f | head -30 && du -sh <server_path>"
```

Report to the user:
- Total size
- File types present (videos, logs, json, etc.)
- Number of files

If the directory is very large (>1GB), warn the user and ask if they want to download selectively (e.g. only `run_log.md` and `results.json`, skip raw videos).

### Step 4 — Download

```bash
mkdir -p <local_dest>
scp -r -P 4997 -i __HOME__/Desktop/SSH-WM/baidu_machine/id_ed25519 \
    "zhaoyi@114.111.19.170:<server_path>/" <local_dest>
```

For single files (not directories), omit `-r`.

### Step 5 — Verify and report

```bash
ls -lh <local_dest>
```

Report what was downloaded and the local path so the user can open it directly.

## File organization rules

When downloading, preserve the server's folder structure. The local `outputs/` directory mirrors the server:

```
outputs/
  irasim_droid_v2_quick/
    run_log.md
    results.json
    videos/
      episode_001.mp4
      ...
  ctrl_world_droid_run5/
    run_log.md
    videos/
      ...
```

Do NOT flatten files into a single directory. Keep subdirectories intact.

## SCP command reference

```bash
# Full directory
scp -r -P 4997 -i __HOME__/Desktop/SSH-WM/baidu_machine/id_ed25519 \
    zhaoyi@114.111.19.170:<remote_path> <local_path>

# Single file
scp -P 4997 -i __HOME__/Desktop/SSH-WM/baidu_machine/id_ed25519 \
    zhaoyi@114.111.19.170:<remote_file> <local_file>
```
