#!__HOME__/.claude/mcp/.venv/bin/python
import io
import os
import time
import uuid
import zipfile
from pathlib import Path
from typing import Any

import requests
from mcp.server.fastmcp import FastMCP


API_BASE = os.environ.get("MINERU_API_BASE", "https://mineru.net/api/v4").rstrip("/")
API_TOKEN = os.environ.get("MINERU_API_TOKEN", "")
DEFAULT_MODEL_VERSION = os.environ.get("MINERU_MODEL_VERSION", "vlm")
MAX_INLINE_CHARS = int(os.environ.get("MINERU_MAX_INLINE_CHARS", "120000"))
LOG_PATH = Path.home() / ".claude" / "cache" / "mineru" / "mcp-server.log"

mcp = FastMCP(
    "mineru",
    instructions=(
        "Use these tools proactively for PDFs, screenshots, scans, photographed pages, "
        "and other document-like images before reasoning with DeepSeek. This server adds "
        "OCR and layout extraction, not native general-image understanding."
    ),
)


def _log(message: str) -> None:
    try:
        LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
        with LOG_PATH.open("a", encoding="utf-8") as handle:
            handle.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} {message}\n")
    except Exception:
        pass


def _auth_headers() -> dict[str, str]:
    if not API_TOKEN:
        raise RuntimeError(
            "MINERU_API_TOKEN is not set. Start Claude Code via the ds alias or export the token manually."
        )
    return {
        "Authorization": f"Bearer {API_TOKEN}",
        "Content-Type": "application/json",
    }


def _default_save_dir() -> Path:
    return Path.home() / ".claude" / "cache" / "mineru"


def _ensure_input_path(path_str: str) -> Path:
    path = Path(path_str).expanduser().resolve()
    if not path.exists():
        raise FileNotFoundError(f"Input path does not exist: {path}")
    if not path.is_file():
        raise RuntimeError(f"Input path is not a file: {path}")
    return path


def _request_upload_urls(paths: list[Path], model_version: str) -> tuple[str, list[str]]:
    files_json = [
        {"name": path.name, "data_id": f"{path.stem[:20]}-{index}"}
        for index, path in enumerate(paths)
    ]
    response = requests.post(
        f"{API_BASE}/file-urls/batch",
        headers=_auth_headers(),
        json={"files": files_json, "model_version": model_version},
        timeout=60,
    )
    response.raise_for_status()
    payload = response.json()
    if payload.get("code") != 0:
        raise RuntimeError(f"MinerU file-urls/batch failed: {payload}")
    data = payload["data"]
    return data["batch_id"], data["file_urls"]


def _upload_files(paths: list[Path], upload_urls: list[str]) -> None:
    for path, url in zip(paths, upload_urls):
        with path.open("rb") as handle:
            response = requests.put(url, data=handle, timeout=300)
        if response.status_code != 200:
            raise RuntimeError(f"Upload failed for {path}: HTTP {response.status_code}")


def _poll_results(batch_id: str, file_count: int) -> list[dict[str, Any]]:
    results: dict[str, dict[str, Any]] = {}
    for _ in range(120):
        time.sleep(2)
        response = requests.get(
            f"{API_BASE}/extract-results/batch/{batch_id}",
            headers={"Authorization": f"Bearer {API_TOKEN}"},
            timeout=60,
        )
        response.raise_for_status()
        payload = response.json()
        extract_results = payload.get("data", {}).get("extract_result", [])

        for item in extract_results:
            file_name = item.get("file_name")
            if not file_name:
                continue
            state = item.get("state")
            if state in {"done", "failed"}:
                results[file_name] = item

        if len(results) >= file_count:
            return list(results.values())

    raise TimeoutError(f"Timed out waiting for MinerU batch {batch_id}")


def _download_result_zip(url: str) -> bytes:
    response = requests.get(url, timeout=300)
    response.raise_for_status()
    return response.content


def _read_full_md(zip_bytes: bytes) -> str:
    with zipfile.ZipFile(io.BytesIO(zip_bytes)) as zf:
        return zf.read("full.md").decode("utf-8", errors="ignore")


def _save_outputs(input_path: Path, markdown: str, zip_bytes: bytes, save_dir: Path) -> tuple[Path, Path]:
    save_dir.mkdir(parents=True, exist_ok=True)
    suffix = uuid.uuid4().hex[:8]
    markdown_path = save_dir / f"{input_path.stem}-{suffix}.md"
    zip_path = save_dir / f"{input_path.stem}-{suffix}.zip"
    markdown_path.write_text(markdown, encoding="utf-8")
    zip_path.write_bytes(zip_bytes)
    return markdown_path, zip_path


def _truncate_text(text: str) -> tuple[str, bool]:
    if len(text) <= MAX_INLINE_CHARS:
        return text, False
    return text[:MAX_INLINE_CHARS], True


def _extract_paths(paths: list[str], model_version: str | None, save_dir: str | None) -> dict[str, Any]:
    input_paths = [_ensure_input_path(path) for path in paths]
    effective_model = model_version or DEFAULT_MODEL_VERSION
    effective_save_dir = Path(save_dir).expanduser().resolve() if save_dir else _default_save_dir()

    _log(f"extract start count={len(input_paths)} model={effective_model}")
    batch_id, upload_urls = _request_upload_urls(input_paths, effective_model)
    _upload_files(input_paths, upload_urls)
    result_items = _poll_results(batch_id, len(input_paths))
    item_by_name = {item["file_name"]: item for item in result_items}

    outputs = []
    for input_path in input_paths:
        item = item_by_name.get(input_path.name)
        if item is None:
            raise RuntimeError(f"MinerU returned no result for {input_path.name}")
        if item.get("state") == "failed":
            raise RuntimeError(f"MinerU failed for {input_path.name}: {item.get('err_msg', '')}")

        zip_bytes = _download_result_zip(item["full_zip_url"])
        markdown = _read_full_md(zip_bytes)
        markdown_path, zip_path = _save_outputs(input_path, markdown, zip_bytes, effective_save_dir)
        inline_markdown, truncated = _truncate_text(markdown)
        outputs.append(
            {
                "input_path": str(input_path),
                "markdown_path": str(markdown_path),
                "zip_path": str(zip_path),
                "markdown": inline_markdown,
                "truncated": truncated,
                "chars": len(markdown),
            }
        )

    _log(f"extract done batch={batch_id}")
    return {
        "batch_id": batch_id,
        "model_version": effective_model,
        "save_dir": str(effective_save_dir),
        "results": outputs,
    }


@mcp.tool()
def extract_document(path: str, model_version: str = DEFAULT_MODEL_VERSION, save_dir: str | None = None) -> dict[str, Any]:
    """Use MinerU to extract Markdown text from a local PDF or image."""
    return _extract_paths([path], model_version, save_dir)


@mcp.tool()
def extract_documents(paths: list[str], model_version: str = DEFAULT_MODEL_VERSION, save_dir: str | None = None) -> dict[str, Any]:
    """Batch MinerU extraction for multiple local PDFs or images."""
    return _extract_paths(paths, model_version, save_dir)


if __name__ == "__main__":
    _log("server start")
    mcp.run()
