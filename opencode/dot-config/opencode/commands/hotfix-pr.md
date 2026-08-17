---
description: Create a hotfix PR by replaying one or more merged PRs onto an RC branch
agent: build
subtask: true
---

Create and open a hotfix pull request from merged PR changes.

User arguments: `$ARGUMENTS`

## Argument format

Accept these forms:

- `/hotfix-pr 23085 --base rc-20260728`
- `/hotfix-pr 23047,23080 --base rc-20260728`
- `/hotfix-pr 23085 --env prod`
- `/hotfix-pr 23085 --env stage`
- `/hotfix-pr 23085 --env qa`

PR numbers may be comma-separated or repeated. `--base` is the exact target RC
branch and takes precedence over `--env`. If neither is supplied, inspect the
repository and ask the user to choose rather than guessing.

## Required workflow

1. Parse the PR numbers and optional `--base` or `--env` from the user arguments.
2. Verify the repository, current worktree, GitHub remote, and source PR metadata.
   Source PRs must be merged. Record each PR title, base branch, head branch, and
   ordered commit SHAs.
3. Resolve the target branch:
   - For `--base`, verify `origin/<base>` exists and use it.
   - For `--env`, inspect remote branches and deployment/release metadata to find
     the RC branch currently tracked by that environment. Prefer an exact,
     current mapping from GitHub or repository tooling. Do not infer from an old
     date or silently fall back to `develop`.
   - If the mapping is ambiguous, stop and ask which RC branch to use.
4. Require a clean worktree before changing branches. If it is dirty, report the
   paths and ask the user whether to stop; never discard or stash user changes
   automatically.
5. Create a new branch from `origin/<base>` using a concise `hotfix/` name based
   on the primary issue or PR, for example
   `hotfix/sho-481-rc-20260728`.
6. Fetch each source PR head and replay its commits in dependency order. Preserve
   the commit order within each PR. If one source PR depends on another, replay
   the dependency first. Use individual commits rather than cherry-picking a
   merge commit.
7. Resolve conflicts deliberately:
   - Inspect both sides and the source PR diff before choosing a version.
   - For binary or Git LFS baselines, preserve the source PR's final regenerated
     artifact unless the later source PR supplies a newer combined baseline.
   - For modify/delete conflicts, retain files required by later source commits
     and verify imports and tests afterward.
    - Never use `git reset --hard`, `git checkout --`, or `git clean` to discard
      unrelated work. A file-scoped checkout is acceptable only when resolving
      an active cherry-pick conflict and only after inspecting both versions.
8. Verify the result with `git status`, `git diff --check`, the diff stat against
   `origin/<base>`, and a list of changed files. Confirm that the diff is limited
   to the requested PR changes and intentional conflict resolutions.
9. Run focused tests for every changed behavior. Use the repository's documented
   test command, normally `yarn higharc test base <changed-test-or-pattern>`.
   Run typecheck when practical. If typecheck fails in unrelated generated
   Prisma/database code, report the exact error count and affected area; do not
   reset a database or modify unrelated files to force it green.
10. Push the branch with upstream tracking and open a PR using `gh pr create`:
    - Base: the resolved RC branch
    - Head: the new hotfix branch
    - Title: concise issue-based hotfix title
    - Body sections: `# Description`, `## Test plan`, and `## PR comment commands`
    - Reference every source PR and relevant issue
    - Do not add a `/hotfix` comment or trigger deployment unless the user
      explicitly requests it.
11. Verify the created PR has the expected base and head, is open, and has a
    clean local worktree. Report the PR URL, branch, replayed commits, conflict
    resolutions, tests, and any verification limitations.

Do not commit, push, or create the PR until the source PRs, target branch, and
worktree state have been verified. If the user explicitly asked to execute the
command, proceed without asking for confirmation after those checks; only stop
for ambiguity, conflicts that require product judgment, or destructive actions.
