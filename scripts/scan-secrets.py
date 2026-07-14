#!/usr/bin/env python3
"""Fail safely when tracked files look like they contain credentials."""

from __future__ import annotations

import re
import subprocess
import plistlib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
FORBIDDEN_NAMES = {
    ".env",
    "auth.json",
    "hosts.yml",
    "credentials.json",
    "id_rsa",
    "id_ed25519",
    "history.jsonl",
    "session_index.jsonl",
}
RULES = {
    "private-key": re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    "github-token": re.compile(r"gh[opusr]_[A-Za-z0-9_]{20,}"),
    "openai-or-anthropic-key": re.compile(r"sk-(?:ant-)?[A-Za-z0-9_-]{20,}"),
    "google-api-key": re.compile(r"AIza[0-9A-Za-z_-]{30,}"),
    "aws-access-key": re.compile(r"AKIA[0-9A-Z]{16}"),
    "slack-token": re.compile(r"xox[baprs]-[A-Za-z0-9-]{10,}"),
    "credentialed-url": re.compile(r"https?://[^\s/:]+:[^\s/@]+@"),
    "quoted-literal-secret-assignment": re.compile(
        r"(?i)(?:api[_-]?key|access[_-]?token|auth[_-]?token|client[_-]?secret|"
        r"password|passwd|private[_-]?key|cookie|authorization|credentials?)"
        r"\s*[:=]\s*[\"'](?!__SET_LOCALLY__|\$\{|\$ENV\{|null|None|true|false)"
        r"[^\"'$]{8,}[\"']"
    ),
}

RIME_PHRASE_RULES = {
    "email": re.compile(r"(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b"),
    "phone": re.compile(r"(?<!\d)1[3-9]\d{9}(?!\d)"),
    "id-card": re.compile(r"(?<!\d)\d{17}[0-9Xx](?!\d)"),
    "bank-like-number": re.compile(r"(?<!\d)\d{16,19}(?!\d)"),
    "sensitive-label": re.compile(
        r"密码|口令|身份证|银行卡|住址|家庭地址|手机号|电话号码|API.?KEY|TOKEN|SECRET",
        re.IGNORECASE,
    ),
}


def tracked_files() -> list[Path]:
    result = subprocess.run(
        ["git", "ls-files", "-co", "--exclude-standard", "-z"],
        cwd=REPO,
        check=True,
        capture_output=True,
    )
    return [REPO / item.decode() for item in result.stdout.split(b"\0") if item]


def main() -> int:
    findings: list[tuple[str, int, str]] = []
    for path in tracked_files():
        relative = path.relative_to(REPO)
        if relative.as_posix() == "macos/rcmd/preferences.plist":
            try:
                preferences = plistlib.loads(path.read_bytes())
            except Exception:
                findings.append((str(relative), 0, "invalid-rcmd-plist"))
                continue
            forbidden_keys = {
                key
                for key in preferences
                if key.startswith(("Paddle-", "SU", "NSWindow Frame"))
                or key
                in {
                    "sentryUserID",
                    "recentlyClosedWindows",
                    "launchableApps",
                    "launchCount",
                    "searchQueryAppSelections",
                    "accessibilityPermissionsGranted",
                    "accessibilityPermissionsNotified",
                }
            }
            for key in sorted(forbidden_keys):
                findings.append((str(relative), 0, f"forbidden-rcmd-key:{key}"))
        rime_path = relative.as_posix().startswith("input-method/rime/")
        if rime_path and path.name in {"installation.yaml", "user.yaml"}:
            findings.append((str(relative), 0, "forbidden-rime-private-data"))
            continue
        if rime_path and (
            any(part in {"build", "sync"} or part.endswith(".userdb") for part in relative.parts)
        ):
            findings.append((str(relative), 0, "forbidden-rime-runtime-data"))
            continue
        if "hooks/state" in relative.as_posix():
            findings.append((str(relative), 0, "forbidden-runtime-state"))
            continue
        if path.name in FORBIDDEN_NAMES:
            findings.append((str(relative), 0, "forbidden-sensitive-file"))
            continue
        try:
            raw = path.read_bytes()
            if b"\0" in raw:
                continue
            text = raw.decode("utf-8")
        except (OSError, UnicodeDecodeError):
            continue
        for line_number, line in enumerate(text.splitlines(), start=1):
            if rime_path and path.name == "custom_phrase.txt":
                for rule, pattern in RIME_PHRASE_RULES.items():
                    if pattern.search(line):
                        findings.append((str(relative), line_number, f"rime-phrase-{rule}"))
            for rule, pattern in RULES.items():
                if pattern.search(line):
                    findings.append((str(relative), line_number, rule))

    if findings:
        print("Potential secrets found (values intentionally hidden):")
        for filename, line, rule in findings:
            location = f"{filename}:{line}" if line else filename
            print(f"- {location} [{rule}]")
        return 1
    print("Secret scan passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
