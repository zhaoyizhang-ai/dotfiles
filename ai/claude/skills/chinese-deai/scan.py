#!/usr/bin/env python3
"""中文学术文本 AI 痕迹扫描器"""

import re
import sys
from collections import Counter

# === 模式库 ===
HIGH_RISK = {
    "模板开头": [
        r'近年来[，,].*?(?:发展|以来)',
        r'在.*?背景下[，,]',
        r'随着.*?(?:飞速|快速|不断|日益|持续)',
        r'进入\d+世纪以来',
    ],
    "绝对断言": [
        r'显而易见[，,地]?',
        r'毋庸置疑[，,地]?',
        r'必然[会能]?[导致使]',
        r'这充分[说证表]明',
        r'充分体[现示]',
    ],
    "空洞修饰": [
        r'显著[提增](?:升|高|强|加)',
        r'大幅[提增](?:升|高|强|加)',
        r'具有重要的.*?意义',
        r'做出了.*?贡献',
        r'(?:理论|实践|现实)意义.*?(?:深远|重大)',
    ],
    "堆叠引用": [
        r'\[\d+\][-–—]\[\d+\]',
    ],
}

MEDIUM_RISK = {
    "成套序数": [
        r'首先.*?其次.*?再次',
        r'第一[,，].*?第二[,，].*?第三',
    ],
    "模糊量词": [
        r'大量[研学调]',
        r'许多[学者研]',
        r'不少[研学]',
        r'诸多[研学方]',
    ],
    "填充连接": [
        r'值得注意的是[,，]?',
        r'不可否认的是[,，]?',
        r'总而言之[,，]?',
        r'综上所述[,，]?',
    ],
    "段尾空话": [
        r'从而[推促].*?进一[步层].*?(?:发展|提升|完善)',
        r'为.*?奠定了.*?基础',
    ],
}

LOW_RISK = {
    "连接词密度": None,  # computed separately
    "引号冒号分号": [r'[""」『]', r'：', r'；'],
}

def scan_file(filepath):
    with open(filepath) as f:
        text = f.read()

    # Skip refs and headers for body analysis
    parts = text.split('## 参考文献')
    body = parts[0]
    # Remove headers
    body = re.sub(r'^#.*$', '', body, flags=re.MULTILINE)
    # Remove citation numbers
    body_clean = re.sub(r'\[\d+\]', '', body)

    lines = body.split('\n')
    findings = {"高危": [], "中危": [], "低危": []}

    # Scan high risk
    for category, patterns in HIGH_RISK.items():
        for pattern in patterns:
            for i, line in enumerate(lines, 1):
                if re.search(pattern, line):
                    findings["高危"].append((i, category, line.strip()[:60]))

    # Scan medium risk
    for category, patterns in MEDIUM_RISK.items():
        if category == "成套序数":
            # Check across adjacent lines
            full = '\n'.join(lines)
            for m in re.finditer(patterns[0], full):
                line_no = full[:m.start()].count('\n') + 1
                findings["中危"].append((line_no, category, m.group()[:60]))
        else:
            for pattern in patterns:
                for i, line in enumerate(lines, 1):
                    if re.search(pattern, line):
                        findings["中危"].append((i, category, line.strip()[:60]))

    # Scan low risk
    for category, patterns in LOW_RISK.items():
        if patterns is None:
            continue
        for pattern in patterns:
            for i, line in enumerate(lines, 1):
                if not line.strip().startswith('[') and re.search(pattern, line):
                    findings["低危"].append((i, category, line.strip()[:60]))

    # Compute metrics
    chinese_chars = len(re.findall(r'[一-鿿]', body_clean))
    total_lines = len([l for l in lines if l.strip()])

    # Connection word density
    connectors = re.findall(r'(因此|所以|然而|此外|与此相对|在此基础上|与此同时|另一方面|进而|从而)', body_clean)
    connector_density = len(connectors) / max(chinese_chars / 100, 1)  # per 100 chars
    if connector_density > 0.33:  # roughly 1 per 300 chars
        findings["低危"].append((0, f"连接词密度过高({len(connectors)}个/百字{connector_density:.2f})", ""))

    # 的 density
    de_count = body_clean.count('的')
    de_ratio = de_count / max(chinese_chars, 1)
    if de_ratio > 0.06:
        findings["低危"].append((0, f"'的'字密度过高({de_ratio*100:.1f}%)", ""))

    # Output
    high = len(findings["高危"])
    med = len(findings["中危"])
    low = len(findings["低危"])

    total_issues = high * 3 + med * 2 + low
    if total_issues > 20:
        density = "高 (>70%)"
    elif total_issues > 12:
        density = "较高 (50-70%)"
    elif total_issues > 6:
        density = "中等 (30-50%)"
    else:
        density = "低 (<30%)"

    print(f"文件: {filepath}")
    print(f"中文字数: {chinese_chars}")
    print(f"估计AI密度: {density}")
    print(f"总扣分: {total_issues} (高危×3 + 中危×2 + 低危×1)")
    print()

    for level in ["高危", "中危", "低危"]:
        items = findings[level]
        if items:
            print(f"{level} ({len(items)}):")
            for line_no, category, context in items[:10]:  # limit output
                print(f"  L{line_no} [{category}] {context[:80]}")
            if len(items) > 10:
                print(f"  ... 还有 {len(items)-10} 条")
            print()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python scan.py <文件路径>")
        sys.exit(1)
    scan_file(sys.argv[1])
