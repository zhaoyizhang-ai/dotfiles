#!/usr/bin/env python3
"""Sync a safe, restorable subset of local dotfiles into this repository."""

from __future__ import annotations

import json
import os
import plistlib
import re
import shutil
import subprocess
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
HOME = Path.home()

SECRET_KEY = re.compile(
    r"(?:api[_-]?key|access[_-]?token|auth[_-]?token|client[_-]?secret|"
    r"password|passwd|private[_-]?key|cookie|authorization|credentials?)",
    re.IGNORECASE,
)
SECRET_ASSIGNMENT = re.compile(
    r"^(?P<indent>\s*)(?P<prefix>(?:export\s+)?)(?P<key>[A-Za-z_][A-Za-z0-9_.-]*)"
    r"(?P<sep>\s*[:=]\s*)(?P<value>.+)$"
)
TOKEN_PATTERNS = (
    re.compile(r"gh[opusr]_[A-Za-z0-9_]{20,}"),
    re.compile(r"sk-(?:ant-)?[A-Za-z0-9_-]{20,}"),
    re.compile(r"AIza[0-9A-Za-z_-]{30,}"),
    re.compile(r"AKIA[0-9A-Z]{16}"),
    re.compile(r"xox[baprs]-[A-Za-z0-9-]{10,}"),
)

IGNORE_NAMES = {
    ".DS_Store",
    ".git",
    "__pycache__",
    "node_modules",
    ".pytest_cache",
    ".mypy_cache",
    ".ruff_cache",
    ".venv",
    "venv",
    "dist",
    "build",
}


def ignored(_directory: str, names: list[str]) -> set[str]:
    return {name for name in names if name in IGNORE_NAMES or name.endswith(".pyc")}


def reset_dir(path: Path) -> None:
    if path.exists():
        shutil.rmtree(path)
    path.mkdir(parents=True, exist_ok=True)


def copy_file(source: Path, target: Path) -> None:
    if not source.is_file():
        return
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, target)


def copy_dir(source: Path, target: Path) -> None:
    if not source.is_dir():
        return
    shutil.copytree(source, target, dirs_exist_ok=True, ignore=ignored)


def sanitize_json(path: Path) -> None:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, UnicodeDecodeError):
        return

    def clean(value):
        if isinstance(value, dict):
            return {
                key: clean(item)
                for key, item in value.items()
                if not SECRET_KEY.search(str(key))
            }
        if isinstance(value, list):
            return [clean(item) for item in value]
        if isinstance(value, str):
            return value.replace(str(HOME), "__HOME__")
        return value

    path.write_text(
        json.dumps(clean(data), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def sanitize_toml(path: Path) -> None:
    lines = path.read_text(encoding="utf-8").splitlines()
    output: list[str] = []
    dropping_section = False
    volatile_keys = {
        "microphoneInputDeviceId",
    }
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("["):
            dropping_section = stripped.startswith("[projects.") or stripped.startswith(
                "[marketplaces."
            )
        if dropping_section:
            continue
        if stripped.startswith("last_updated"):
            continue
        key = stripped.split("=", 1)[0].strip() if "=" in stripped else ""
        if key in volatile_keys:
            continue
        line = line.replace(str(HOME), "__HOME__")
        line = re.sub(
            r'(?i)([A-Za-z0-9_.-]*(?:api[_-]?key|access[_-]?token|auth[_-]?token|'
            r'client[_-]?secret|password|passwd|private[_-]?key|cookie|authorization|'
            r'credentials?)\s*=\s*)"[^"]*"',
            r'\1"__SET_LOCALLY__"',
            line,
        )
        output.append(line)
    path.write_text("\n".join(output).rstrip() + "\n", encoding="utf-8")


def sanitize_gitconfig(path: Path) -> None:
    lines = path.read_text(encoding="utf-8").splitlines()
    section = ""
    output: list[str] = []
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("[") and stripped.endswith("]"):
            section = stripped.lower()
        if section == "[user]" and re.match(r"\s*name\s*=", line, re.IGNORECASE):
            output.append("\tname = __GIT_NAME__")
        elif section == "[user]" and re.match(r"\s*email\s*=", line, re.IGNORECASE):
            output.append("\temail = __GIT_EMAIL__")
        else:
            output.append(line.replace(str(HOME), "__HOME__").rstrip())
    path.write_text("\n".join(output).rstrip() + "\n", encoding="utf-8")


def sanitize_iterm(path: Path) -> None:
    data = plistlib.loads(path.read_bytes())
    runtime_prefixes = (
        "NoSync",
        "NSWindow Frame",
        "NSSplitView",
        "NSToolbar",
    )
    ai_keys = {
        key
        for key in data
        if key.startswith(("AI", "Ai", "Aiterm"))
    }
    runtime_keys = {
        "NSOSPLastRootDirectory",
        "NSNavPanelExpandedSizeForOpenMode",
        "SULastCheckTime",
    }
    for key in list(data):
        if key.startswith(runtime_prefixes) or key in runtime_keys or key in ai_keys:
            data.pop(key, None)

    def clean(value):
        if isinstance(value, dict):
            return {
                key: clean(item)
                for key, item in value.items()
                if key not in {"Bound Hosts"}
            }
        if isinstance(value, list):
            return [clean(item) for item in value]
        if isinstance(value, str):
            return value.replace(str(HOME), "__HOME__")
        return value

    with path.open("wb") as stream:
        plistlib.dump(clean(data), stream, fmt=plistlib.FMT_XML, sort_keys=False)


def export_rcmd_preferences(path: Path) -> None:
    result = subprocess.run(
        ["defaults", "export", "com.lowtechguys.rcmd", "-"],
        check=True,
        capture_output=True,
    )
    data = plistlib.loads(result.stdout)
    exact_keys = {
        "activationMode",
        "alwaysHideOthers",
        "appKeyAssignments",
        "appSort",
        "appSortReverse",
        "assignKeyTriggerKeys",
        "createMissingSpaces",
        "exposeKey",
        "fuzzySearch",
        "ignoredApps",
        "ignoredKeys",
        "minimizeKey",
        "minimizeOnlyFocusedWindowOnMinus",
        "osdCurrentSpaceOnly",
        "osdLook",
        "overrideUserDefaults",
        "pauseApps",
        "searchMatchMode",
        "searchOptionalPrefixes",
        "searchQueryPins",
        "spaceMode",
        "specialKey",
        "triggerKeys",
        "whenAlreadyFocusedAction",
    }
    prefixes = (
        "appSwitcher",
        "enable",
        "focus",
        "hide",
        "hijack",
        "show",
        "stage",
        "sticky",
        "switcher",
        "tabCycle",
        "window",
    )
    runtime_keys = {
        "dynamicAppKeyAssignments",
        "focusedAppKeyAssignment",
    }
    safe = {
        key: value
        for key, value in data.items()
        if key not in runtime_keys and (key in exact_keys or key.startswith(prefixes))
    }

    def clean(value):
        if isinstance(value, dict):
            return {key: clean(item) for key, item in value.items()}
        if isinstance(value, list):
            return [clean(item) for item in value]
        if isinstance(value, str):
            return value.replace(str(HOME), "__HOME__")
        return value

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("wb") as stream:
        plistlib.dump(clean(safe), stream, fmt=plistlib.FMT_XML, sort_keys=True)


def sanitize_text(path: Path) -> None:
    try:
        raw = path.read_bytes()
        if b"\0" in raw:
            return
        text = raw.decode("utf-8")
    except (OSError, UnicodeDecodeError):
        return

    text = text.replace(str(HOME), "__HOME__")
    output: list[str] = []
    for line in text.splitlines():
        match = SECRET_ASSIGNMENT.match(line)
        if match and SECRET_KEY.search(match.group("key")):
            value = match.group("value").strip()
            if not (
                value.startswith("${")
                or value.startswith("$ENV{")
                or "__SET_LOCALLY__" in value
                or value in {"null", "None", "true", "false"}
            ):
                line = (
                    f'{match.group("indent")}{match.group("prefix")}'
                    f'{match.group("key")}{match.group("sep")}"__SET_LOCALLY__"'
                )
        line = re.sub(
            r"(?i)((?:api[_-]?key|access[_-]?token|auth[_-]?token|client[_-]?secret|"
            r"password|passwd|private[_-]?key|cookie|authorization|credentials?)"
            r"\s*[:=]\s*)[\"'][^\"'$]{8,}[\"']",
            r'\1"__SET_LOCALLY__"',
            line,
        )
        for pattern in TOKEN_PATTERNS:
            line = pattern.sub("__REDACTED_TOKEN__", line)
        line = re.sub(r"(https?://[^\s/:]+:)[^\s/@]+(@)", r"\1__REDACTED__\2", line)
        output.append(line)
    path.write_text("\n".join(output) + ("\n" if text.endswith("\n") else ""), encoding="utf-8")


def write_inventory() -> None:
    software = REPO / "software"
    reset_dir(software)

    if shutil.which("brew"):
        subprocess.run(
            ["brew", "bundle", "dump", "--file", str(software / "Brewfile"), "--force"],
            check=True,
        )
        brewfile = software / "Brewfile"
        # HyperKey is installed by restore-caps-hyper-rcmd.sh from a pinned,
        # checksummed release because the third-party Homebrew cask can lag the
        # release asset checksum.
        content = brewfile.read_text(encoding="utf-8")
        content = "\n".join(
            line
            for line in content.splitlines()
            if line not in {'tap "n0an/tap"', 'cask "n0an/tap/hyperkey-app"'}
        )
        brewfile.write_text(content.rstrip() + "\n", encoding="utf-8")
        squirrel_app = Path("/Library/Input Methods/Squirrel.app")
        if squirrel_app.exists():
            content = brewfile.read_text(encoding="utf-8")
            if 'cask "squirrel-app"' not in content:
                brewfile.write_text(content.rstrip() + '\ncask "squirrel-app"\n', encoding="utf-8")
        rcmd_app = Path("/Applications/rcmd.app")
        if rcmd_app.exists():
            content = brewfile.read_text(encoding="utf-8")
            if 'cask "rcmd"' not in content:
                brewfile.write_text(content.rstrip() + '\ncask "rcmd"\n', encoding="utf-8")

    commands = {
        "vscode-extensions.txt": ["code", "--list-extensions"],
        "cursor-extensions.txt": ["cursor", "--list-extensions"],
    }
    for filename, command in commands.items():
        if not shutil.which(command[0]):
            continue
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        (software / filename).write_text(result.stdout, encoding="utf-8")


def main() -> None:
    # Root-level terminal and developer configuration.
    for filename in (
        ".zshrc",
        ".zprofile",
        ".bash_profile",
        ".gitconfig",
        ".tmux.conf",
        ".condarc",
        ".proxy.sh",
    ):
        copy_file(HOME / filename, REPO / filename)

    # AI tools: copy only durable configuration, never runtime state or auth files.
    reset_dir(REPO / "ai")
    codex = REPO / "ai" / "codex"
    for filename in ("AGENTS.md", "SKILL_PROVENANCE.md", "keybindings.json", "hooks.json"):
        copy_file(HOME / ".codex" / filename, codex / filename)
    copy_file(HOME / ".codex" / "config.toml", codex / "config.toml")
    copy_dir(HOME / ".codex" / "rules", codex / "rules")
    copy_dir(HOME / ".codex" / "bin", codex / "bin")
    copy_dir(HOME / ".codex" / "cc-notify-hooks", codex / "cc-notify-hooks")
    copy_dir(HOME / ".codex" / "skills", codex / "skills")
    shutil.rmtree(codex / "skills" / ".system", ignore_errors=True)

    agents = REPO / "ai" / "agents"
    copy_dir(HOME / ".agents" / "skills", agents / "skills")
    copy_file(HOME / ".agents" / ".skill-lock.json", agents / ".skill-lock.json")

    claude = REPO / "ai" / "claude"
    copy_file(HOME / ".claude" / "settings.json", claude / "settings.json")
    for dirname in ("commands", "skills", "hooks", "mcp"):
        copy_dir(HOME / ".claude" / dirname, claude / dirname)
    shutil.rmtree(claude / "hooks" / "state", ignore_errors=True)

    cursor_user = HOME / "Library" / "Application Support" / "Cursor" / "User"
    vscode_user = HOME / "Library" / "Application Support" / "Code" / "User"
    for name, source in (("cursor", cursor_user), ("vscode", vscode_user)):
        target = REPO / "editors" / name
        reset_dir(target)
        for filename in ("settings.json", "keybindings.json"):
            copy_file(source / filename, target / filename)
        copy_dir(source / "snippets", target / "snippets")

    gh_config = REPO / "developer" / "gh" / "config.yml"
    copy_file(HOME / ".config" / "gh" / "config.yml", gh_config)

    if Path("/Applications/rcmd.app").exists():
        export_rcmd_preferences(REPO / "macos" / "rcmd" / "preferences.plist")
        copy_file(
            HOME / ".config" / "rcmd" / "config.yaml",
            REPO / "macos" / "rcmd" / "config.yaml",
        )

    # Rime/Squirrel: keep portable configuration, not learned phrases or runtime state.
    rime_source = HOME / "Library" / "Rime"
    rime_target = REPO / "input-method" / "rime"
    reset_dir(rime_target)
    rime_excluded = {"installation.yaml", "user.yaml"}
    if rime_source.is_dir():
        for source in rime_source.iterdir():
            if source.name in rime_excluded:
                continue
            if source.is_file() and (
                source.suffix in {".yaml", ".lua", ".md"}
                or source.name in {"LICENSE", "custom_phrase.txt"}
            ):
                copy_file(source, rime_target / source.name)
        for dirname in ("lua", "others", "cn_dicts", "en_dicts", "opencc"):
            copy_dir(rime_source / dirname, rime_target / dirname)

    # Refresh iTerm preferences as XML so home paths can be parameterized.
    iterm_source = HOME / "Library" / "Preferences" / "com.googlecode.iterm2.plist"
    if iterm_source.is_file():
        copy_file(iterm_source, REPO / "iterm2.plist")
        subprocess.run(
            ["plutil", "-convert", "xml1", str(REPO / "iterm2.plist")], check=True
        )
        sanitize_iterm(REPO / "iterm2.plist")

    # Structured formats get schema-aware filtering before the general text pass.
    sanitize_toml(codex / "config.toml")
    for json_path in (
        claude / "settings.json",
        REPO / "editors" / "cursor" / "settings.json",
        REPO / "editors" / "vscode" / "settings.json",
    ):
        if json_path.is_file():
            sanitize_json(json_path)
    if (REPO / ".gitconfig").is_file():
        sanitize_gitconfig(REPO / ".gitconfig")

    for path in REPO.rglob("*"):
        if path.is_file() and ".git" not in path.parts:
            sanitize_text(path)

    write_inventory()
    print("Synced safe dotfiles into", REPO)


if __name__ == "__main__":
    main()
