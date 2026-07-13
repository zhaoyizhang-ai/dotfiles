---
name: zoom-out
description: Tell the agent to zoom out and give broader context or a higher-level perspective. Use when you're unfamiliar with a section of code or need to understand how it fits into the bigger picture.
disable-model-invocation: true
allowed-tools: Read, Bash(grep *), Bash(find *), Bash(ls *)
metadata:
  category: utility
  tags: [context, overview, architecture, codebase-map]
  triggers:
    - zoom out
    - broader context
    - bigger picture
    - 全局视角
    - 宏观视角
    - 代码结构
    - 架构概览
---

I don't know this area of code well. Go up a layer of abstraction. Give me a map of all the relevant modules and callers, using the project's domain glossary vocabulary.
