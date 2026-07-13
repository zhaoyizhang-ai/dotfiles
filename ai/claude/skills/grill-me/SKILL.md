---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
allowed-tools: Read, Bash(grep *), Bash(find *), Bash(ls *)
metadata:
  category: utility
  tags: [interview, plan-review, design-stress-test, questioning]
  triggers:
    - grill me
    - stress test
    - interview
    - 盘问我
    - 压力测试
    - 设计审查
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.
