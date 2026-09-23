"""Exercise the launcher without downloading images or touching real Tart VMs."""

import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


LAUNCHER = Path(__file__).resolve().parents[1] / "demos/01-project-creation/macos-demo.sh"
BASE = "nextapp-project-creation-base"
DEMO = "nextapp-project-creation-demo"
IMAGE = "ghcr.io/cirruslabs/macos-tahoe-vanilla:latest"

FAKE_COMMAND = r'''
import json
import os
from pathlib import Path
import sys

command = Path(sys.argv[0]).name
args = sys.argv[1:]
if command == "uname":
    print(os.environ.get("FAKE_OS", "Darwin") if args == ["-s"]
          else os.environ.get("FAKE_ARCH", "arm64"))
    sys.exit(0)
if command == "plutil":
    print(json.load(sys.stdin)["State"])
    sys.exit(0)

state_path = Path(os.environ["FAKE_STATE"])
state = json.loads(state_path.read_text())
with open(os.environ["FAKE_LOG"], "a") as log:
    log.write(json.dumps(args) + "\n")
if state.get("fail") == args[0]:
    sys.exit(7)
vms = state["vms"]
if args[0] == "list":
    assert args[1:] == ["--source", "local", "--quiet"]
    print("\n".join(vms))
elif args[0] == "get":
    assert args[2:] == ["--format", "json"]
    if state.get("bad_json"):
        print("unreadable configuration")
    else:
        print(json.dumps({"State": vms[args[1]]}))
elif args[0] == "clone":
    assert args[2] not in vms
    assert args[1].startswith("ghcr.io/") or vms[args[1]] == "stopped"
    vms[args[2]] = "stopped"
elif args[0] == "delete":
    assert vms[args[1]] == "stopped"
    del vms[args[1]]
elif args[0] == "run":
    assert len(args) == 2  # The normal GUI run, without headless flags.
    assert args[1] in vms
elif args[0] == "set":
    assert args[1] in vms
else:
    raise AssertionError(args)
state_path.write_text(json.dumps(state))
'''


class MacOSDemoTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        for command in ("uname", "tart", "plutil"):
            path = self.bin / command
            path.write_text(f"#!{sys.executable}\n" + FAKE_COMMAND)
            path.chmod(0o755)
        self.state = self.root / "state.json"
        self.log = self.root / "calls.jsonl"
        self.env = {
            **os.environ,
            "PATH": f"{self.bin}:/usr/bin:/bin",
            "FAKE_STATE": str(self.state),
            "FAKE_LOG": str(self.log),
        }
        for name in ("MACOS_IMAGE", "FAKE_OS", "FAKE_ARCH"):
            self.env.pop(name, None)
        self.seed({})

    def seed(self, vms, **options):
        self.state.write_text(json.dumps({"vms": vms, **options}))
        self.log.write_text("")

    def run_launcher(self, *args, success=True, **env):
        result = subprocess.run(
            ["/bin/bash", str(LAUNCHER), *args],
            env={**self.env, **env}, capture_output=True, text=True,
        )
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        return result

    def mutations(self):
        return [args for line in self.log.read_text().splitlines()
                if (args := json.loads(line))[0] in ("clone", "set", "run", "delete")]

    def test_prepare_preserves_existing_base(self):
        self.run_launcher("prepare")
        self.assertEqual(self.mutations()[0], ["clone", IMAGE, BASE])
        self.assertEqual(self.mutations()[1][0:2], ["set", BASE])
        before = self.mutations()
        self.run_launcher("prepare")
        self.assertEqual(self.mutations(), before)

    def test_run_clones_once_and_opens_gui(self):
        self.seed({BASE: "stopped"})
        self.run_launcher()  # Default action is run.
        self.run_launcher("run")
        self.assertEqual(self.mutations(), [
            ["clone", BASE, DEMO], ["run", DEMO], ["run", DEMO],
        ])

    def test_reset_only_replaces_disposable_vm(self):
        self.seed({BASE: "stopped", DEMO: "stopped", "unrelated": "running"})
        self.run_launcher("reset")
        self.assertEqual(self.mutations(), [["delete", DEMO], ["clone", BASE, DEMO]])
        self.assertEqual(json.loads(self.state.read_text())["vms"], {
            BASE: "stopped", DEMO: "stopped", "unrelated": "running",
        })

    def test_reset_with_no_demo_just_clones(self):
        self.seed({BASE: "stopped"})
        self.run_launcher("reset")
        self.assertEqual(self.mutations(), [["clone", BASE, DEMO]])

    def test_reset_refuses_missing_or_active_base(self):
        for state in (None, "running", "suspended"):
            with self.subTest(state=state):
                vms = {DEMO: "stopped"}
                if state:
                    vms[BASE] = state
                self.seed(vms)
                self.run_launcher("reset", success=False)
                self.assertEqual(self.mutations(), [])

    def test_reset_refuses_active_demo(self):
        for state in ("running", "suspended"):
            with self.subTest(state=state):
                self.seed({BASE: "stopped", DEMO: state})
                self.run_launcher("reset", success=False)
                self.assertEqual(self.mutations(), [])

    def test_reset_fails_closed_on_unreadable_state(self):
        for options in ({"fail": "list"}, {"fail": "get"}, {"bad_json": True}):
            with self.subTest(options=options):
                self.seed({BASE: "stopped", DEMO: "stopped"}, **options)
                self.run_launcher("reset", success=False)
                self.assertEqual(self.mutations(), [])

    def test_local_source_must_be_stopped(self):
        self.seed({"custom-base": "stopped"})
        self.run_launcher("prepare", MACOS_IMAGE="custom-base")
        self.assertEqual(self.mutations()[0], ["clone", "custom-base", BASE])
        for state in ("running", "suspended"):
            with self.subTest(state=state):
                self.seed({"custom-base": state})
                self.run_launcher("prepare", success=False, MACOS_IMAGE="custom-base")
                self.assertEqual(self.mutations(), [])

    def test_unsupported_host_does_not_touch_vms(self):
        for env in ({"FAKE_OS": "Linux"}, {"FAKE_ARCH": "x86_64"}):
            with self.subTest(env=env):
                self.run_launcher("reset", success=False, **env)
                self.assertEqual(self.mutations(), [])

    def test_help_and_missing_tart(self):
        (self.bin / "tart").unlink()
        self.run_launcher("--help")
        result = self.run_launcher("prepare", success=False)
        self.assertIn("brew install", result.stderr)

    def test_invalid_arguments_do_not_touch_vms(self):
        for args in (("unknown",), ("reset", "extra")):
            with self.subTest(args=args):
                self.run_launcher(*args, success=False)
                self.assertEqual(self.mutations(), [])


if __name__ == "__main__":
    unittest.main()
