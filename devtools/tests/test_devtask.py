import importlib.machinery
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch


SCRIPT = Path(__file__).resolve().parents[1] / "dot-local/bin/devtask"
loader = importlib.machinery.SourceFileLoader("devtask", str(SCRIPT))
spec = importlib.util.spec_from_loader(loader.name, loader)
dt = importlib.util.module_from_spec(spec)
loader.exec_module(dt)


class FakeHerdr:
    """Protocol fixture; Git and Worktrunk operations still use real binaries."""

    def __init__(self):
        self.workspaces = {}
        self.panes = {}
        self.agents = {}
        self.calls = []
        self.prompts = []
        self.fail_prompt = False
        self.width = 160

    def pane(self, workspace, cwd):
        identity = f"{workspace}:p{len(self.panes) + 1}"
        self.panes[identity] = {"pane_id": identity, "workspace_id": workspace, "cwd": cwd}
        return self.panes[identity]

    def __call__(self, *args, missing=False):
        self.calls.append(args)
        group, action, *rest = args
        if (group, action) == ("agent", "get"):
            agent = self.agents.get(rest[0])
            if agent is None and missing:
                return None
            return {"agent": agent}
        if (group, action) == ("workspace", "get"):
            item = self.workspaces.get(rest[0])
            return {"workspace": item} if item else None
        if (group, action) == ("workspace", "list"):
            return {"workspaces": list(self.workspaces.values())}
        if (group, action) == ("workspace", "create"):
            identity = f"w{len(self.workspaces) + 1}"
            item = {"workspace_id": identity, "label": rest[rest.index("--label") + 1]}
            self.workspaces[identity] = item
            return {"workspace": item, "root_pane": self.pane(identity, rest[rest.index("--cwd") + 1])}
        if (group, action) == ("pane", "list"):
            return {"panes": [p for p in self.panes.values() if p["workspace_id"] == rest[1]]}
        if (group, action) == ("pane", "get"):
            return {"pane": self.panes[rest[0]]}
        if (group, action) == ("pane", "layout"):
            return {"layout": {"panes": [{"pane_id": rest[1], "rect": {"width": self.width, "height": 40}}]}}
        if (group, action) == ("pane", "split"):
            return {"pane": self.pane(self.panes[rest[0]]["workspace_id"], rest[rest.index("--cwd") + 1])}
        if (group, action) == ("pane", "process-info"):
            return {"process_info": {"shell_pid": 100, "foreground_processes": [{"pid": 100}]}}
        if (group, action) == ("agent", "start"):
            pane = self.panes[rest[rest.index("--pane") + 1]]
            pane["agent"] = "opencode"
            self.agents[rest[0]] = {**pane, "foreground_cwd": pane["cwd"],
                                   "agent_session": {"kind": "id", "value": "ses_test"}}
            return {}
        if (group, action) == ("agent", "prompt"):
            self.prompts.append(rest[1])
            if self.fail_prompt:
                raise dt.TaskError("Prompt acknowledgment lost")
            return {}
        if (group, action) in {("pane", "rename"), ("pane", "run"), ("agent", "focus"), ("workspace", "focus")}:
            return {}
        raise AssertionError(args)


class TaskTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="devtask-")
        self.root = (Path(self.temp.name) / "Projects with space 'quote").resolve()
        self.root.mkdir()
        self.registry = self.root / "registry.toml"
        for name in ("one", "two"):
            repo = self.root / "repos" / name
            repo.mkdir(parents=True)
            dt.run(["git", "init", "--initial-branch=main", str(repo)])
            (repo / "README.md").write_text(f"# {name}\n")
            (repo / "AGENTS.md").write_text(f"Repository {name} instructions\n")
            dt.git(repo, "add", "README.md", "AGENTS.md")
            dt.git(repo, "-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid",
                   "-c", "core.hooksPath=/dev/null", "commit", "-m", "fixture")
        (self.root / "contexts" / "both").mkdir(parents=True)
        self.registry.write_text(
            'version = 1\nroot = ' + json.dumps(str(self.root)) + '\n'
            '[repositories.one]\npath = "repos/one"\nbase = "main"\ndelivery = "local"\n'
            '[repositories.two]\npath = "repos/two"\nbase = "main"\ndelivery = "pr"\n'
            '[contexts.both]\npath = "contexts/both"\nrepositories = ["one", "two"]\n'
            '[tasks]\npath = "tasks"\n'
        )
        self.config, _ = dt.load_registry(self.registry)

    def tearDown(self):
        self.temp.cleanup()

    def args(self, *args):
        return dt.parser().parse_args(["--config", str(self.registry), *args])

    def create(self, *args):
        return dt.create_task(self.config, self.root, self.args("new", *args, "--no-open"))

    def test_single_repository_real_worktrunk_and_clean_worktree(self):
        result = self.create("one", "auth", "--prompt", "Implement auth")
        directory = Path(result["path"])
        self.assertEqual(dt.git(directory / "one", "branch", "--show-current"), "task/one/auth")
        self.assertEqual(dt.git(directory / "one", "status", "--porcelain"), "")
        self.assertEqual(dt.git(self.root / "repos/one", "branch", "--show-current"), "main")
        dt.verify_worktrees(directory, result)
        config = json.loads((directory / "opencode.jsonc").read_text())
        self.assertEqual(config["instructions"], [str(directory / "AGENTS.md")])
        self.assertEqual((directory / "HANDOFF.md").read_text(), "Implement auth\n")

    def test_subset_and_reference_only_context(self):
        result = self.create("both", "ingress", "--repos", "one", "--references", "two")
        directory = Path(result["path"])
        self.assertTrue((directory / "one/.git").is_file())
        self.assertFalse((directory / "two").exists())
        config = json.loads((directory / "opencode.jsonc").read_text())
        self.assertEqual(Path(config["references"]["two"]["path"]), self.root / "repos/two")
        self.assertEqual(result["agent_cwd"], str(directory / "one"))

    def test_multi_repo_per_repo_overrides_and_feature_target(self):
        dt.git(self.root / "repos/one", "branch", "feature/auth")
        result = self.create("both", "auth", "--repos", "one,two", "--base", "one=feature/auth",
                             "--target", "one=feature/auth", "--branch", "two=custom-auth", "--delivery", "two=local")
        self.assertEqual(result["agent_cwd"], result["path"])
        self.assertEqual(result["repositories"]["one"]["target"], "feature/auth")
        self.assertEqual(result["repositories"]["two"]["branch"], "custom-auth")
        self.assertEqual(result["repositories"]["two"]["delivery"], "local")

    def test_all_repositories_preflight_before_mutation(self):
        with self.assertRaises(dt.TaskError):
            self.create("both", "fail", "--repos", "one,two", "--base", "two=does-not-exist")
        self.assertFalse((self.root / "tasks/both/fail").exists())
        refs = dt.git(self.root / "repos/one", "for-each-ref", "--format=%(refname)", "refs/heads/")
        self.assertEqual(refs, "refs/heads/main")

    def test_context_selection_duplicate_and_escape_rejected(self):
        for args in [("both", "empty"), ("both", "dup", "--repos", "one,one"),
                     ("both", "outside", "--repos", "unknown"), ("one", "../escape")]:
            with self.assertRaises(dt.TaskError):
                self.create(*args)

    def test_duplicate_task_and_existing_branch_preserve_work(self):
        result = self.create("one", "auth")
        sentinel = Path(result["path"]) / "one/user-work.txt"
        sentinel.write_text("keep")
        with self.assertRaises(dt.TaskError):
            self.create("one", "auth")
        with self.assertRaises(dt.TaskError):
            self.create("one", "other", "--branch", "task/one/auth")
        self.assertEqual(sentinel.read_text(), "keep")

    def test_ticket_branch_constraint(self):
        self.config["repositories"]["two"]["branch_pattern"] = r"(?i)(^|[/-])labsrd-[0-9]+([/-]|$)"
        with self.assertRaises(dt.TaskError):
            self.create("two", "ticket")
        result = self.create("two", "ticket", "--branch", "labsrd-42-change")
        self.assertEqual(result["repositories"]["two"]["branch"], "labsrd-42-change")

    def test_partial_failure_retains_completed_worktrees(self):
        real_run = dt.run

        def fail_second(argv, **kwargs):
            if argv[0] == "wt" and argv[2] == str(self.root / "repos/two"):
                raise dt.TaskError("fixture failure")
            return real_run(argv, **kwargs)

        with patch.object(dt, "run", side_effect=fail_second), self.assertRaises(dt.TaskError):
            self.create("both", "partial", "--repos", "one,two")
        directory = self.root / "tasks/both/partial"
        self.assertTrue((directory / "one/.git").is_file())
        self.assertEqual(json.loads((directory / ".devtask.json").read_text())["status"], "incomplete")

    def test_outside_herdr_fails_before_creation(self):
        with patch.dict(os.environ, {"HERDR_ENV": "0"}):
            with self.assertRaises(dt.TaskError):
                dt.create_task(self.config, self.root, self.args("new", "one", "outside"))
        self.assertFalse((self.root / "tasks/one/outside").exists())

    def test_reopen_reuses_space_preserves_focus_and_sends_brief_once(self):
        result = self.create("one", "auth", "--prompt", "Do the task", "--model", "provider/model")
        directory = Path(result["path"])
        fake = FakeHerdr()
        args = self.args("open", "one", "auth")
        with patch.dict(os.environ, {"HERDR_ENV": "1"}), patch.object(dt, "herdr", fake), patch.object(dt, "startup_options", return_value=(["--agent", "build"], {})):
            first = dt.open_task(directory, args)
            second = dt.open_task(directory, args)
        self.assertEqual(first["workspace_id"], second["workspace_id"])
        self.assertEqual(len(fake.workspaces), 1)
        self.assertEqual(len(fake.panes), 2)
        self.assertEqual(len(fake.prompts), 1)
        self.assertFalse(any(call[1] == "focus" for call in fake.calls))
        self.assertIn("--no-focus", next(c for c in fake.calls if c[:2] == ("workspace", "create")))

    def test_narrow_layout_and_session_resume(self):
        result = self.create("one", "auth", "--prompt", "Do the task", "--agent", "plan")
        directory = Path(result["path"])
        fake = FakeHerdr()
        fake.width = 80
        with patch.dict(os.environ, {"HERDR_ENV": "1"}), patch.object(dt, "herdr", fake), patch.object(dt, "startup_options", return_value=(["--agent", "plan"], {})):
            dt.open_task(directory, self.args("open", "one", "auth"))
            self.assertIn("down", next(c for c in fake.calls if c[:2] == ("pane", "split")))
            fake.agents.clear()
            for pane in fake.panes.values():
                pane.pop("agent", None)
            dt.open_task(directory, self.args("open", "one", "auth", "--focus"))
        starts = [c for c in fake.calls if c[:2] == ("agent", "start")]
        self.assertIn("--session", starts[-1])
        self.assertIn("ses_test", starts[-1])
        self.assertIn("plan", starts[-1])
        self.assertEqual(len(fake.prompts), 1)
        self.assertTrue(any(c[:2] == ("agent", "focus") for c in fake.calls))

    def test_uncertain_prompt_is_not_automatically_replayed(self):
        result = self.create("one", "auth", "--prompt", "Do the task")
        directory = Path(result["path"])
        fake = FakeHerdr()
        fake.fail_prompt = True
        with patch.dict(os.environ, {"HERDR_ENV": "1"}), patch.object(dt, "herdr", fake), patch.object(dt, "startup_options", return_value=(["--agent", "build"], {})):
            with self.assertRaises(dt.TaskError):
                dt.open_task(directory, self.args("open", "one", "auth"))
            fake.fail_prompt = False
            dt.open_task(directory, self.args("open", "one", "auth"))
            self.assertEqual(len(fake.prompts), 1)
            dt.open_task(directory, self.args("open", "one", "auth"), "Explicit retry")
            self.assertEqual(len(fake.prompts), 2)

    def test_changed_branch_refuses_reopen(self):
        result = self.create("one", "auth")
        directory = Path(result["path"])
        dt.git(directory / "one", "checkout", "-b", "different")
        with self.assertRaises(dt.TaskError):
            dt.read_manifest(directory)

    def test_empty_herdr_acknowledgment(self):
        result = subprocess.CompletedProcess([], 0, stdout="", stderr="")
        with patch.object(dt.subprocess, "run", return_value=result):
            self.assertEqual(dt.herdr("pane", "run", "w1:p1", "export X=y"), {})

    def test_opencode_v1_and_v2_startup_options(self):
        manifest = {"opencode_agent": "plan", "model": "provider/model"}
        args = self.args("open", "one", "auth")
        with patch.object(dt, "run", return_value="--agent --model"):
            native, overrides = dt.startup_options(manifest, args)
            self.assertEqual(native, ["--agent", "plan", "--model", "provider/model"])
        with patch.object(dt, "run", return_value="--standalone --session"):
            native, overrides = dt.startup_options(manifest, args)
            self.assertEqual(native, ["--standalone"])
            self.assertEqual(overrides, {"default_agent": "plan", "model": "provider/model"})


if __name__ == "__main__":
    unittest.main()
