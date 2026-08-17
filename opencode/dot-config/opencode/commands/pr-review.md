---
description: Fetch, checkout, and run Enforcer PR review
agent: enforcer
subtask: true
---

Preparing review workspace for PR #$1

PR metadata:
!`gh pr view $1 --json number,title,url,headRefName,baseRefName,author,headRepositoryOwner,isCrossRepository`

Checkout status:
!`git fetch origin --prune && gh pr checkout $1 && git branch --show-current && git rev-parse --abbrev-ref --symbolic-full-name @{u} && git status --short --branch`

Now run a full Enforcer review for PR #$1.

In your response, include:
1) The standard Enforcer report.
2) A concise "What to focus on in human review" guide with 4-6 prioritized bullets, each with why it matters and exactly what to verify.

DO NOT AUTOMATICALLY POST COMMENTS TO THE PR. Only present findings locally
