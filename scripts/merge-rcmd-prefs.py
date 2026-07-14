#!/usr/bin/env python3
"""Merge public rcmd configuration into a target plist without deleting runtime state."""

from __future__ import annotations

import argparse
import plistlib
from pathlib import Path


def expand_home(value, home: str):
    if isinstance(value, dict):
        return {key: expand_home(item, home) for key, item in value.items()}
    if isinstance(value, list):
        return [expand_home(item, home) for item in value]
    if isinstance(value, str):
        return value.replace("__HOME__", home)
    return value


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True, type=Path)
    parser.add_argument("--current", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--home", required=True)
    args = parser.parse_args()

    source = plistlib.loads(args.source.read_bytes())
    current = plistlib.loads(args.current.read_bytes()) if args.current.exists() else {}
    current.update(expand_home(source, args.home))
    with args.output.open("wb") as stream:
        plistlib.dump(current, stream, fmt=plistlib.FMT_XML, sort_keys=True)


if __name__ == "__main__":
    main()
