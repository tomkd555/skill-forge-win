"""Check that skill body paths convert to the right Windows path per platform.

The replacements in convert_skill.BODY_REPLACEMENTS are regular expressions whose
replacement strings escape every backslash. A missing or extra backslash there is
invisible until someone reads a converted skill, so pin the behaviour here.

Usage: python tests\\test_convert_paths.py
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "skills" / "skill-forge" / "scripts"))

from convert_skill import adapt_body_content  # noqa: E402

WINDOWS_BODY = r"Global skills live in %USERPROFILE%\.claude\skills\ and CLAUDE.md sits at the root."
POSIX_BODY = "Global skills live in ~/.claude/skills/ and CLAUDE.md sits at the root."

EXPECTED = {
    "codex": (r"%USERPROFILE%\.agents\skills" + chr(92), "AGENTS.md"),
    "gemini": (r"%USERPROFILE%\.gemini\skills" + chr(92), "GEMINI.md"),
    "antigravity": (r"%USERPROFILE%\.gemini\antigravity\skills" + chr(92), "GEMINI.md"),
    "cursor": (r"%USERPROFILE%\.cursor\skills" + chr(92), r".cursor\rules" + chr(92)),
}


def check(body: str, label: str) -> None:
    for platform, (expected_path, expected_file) in EXPECTED.items():
        adapted, _ = adapt_body_content(body, platform)
        assert expected_path in adapted, f"{label}/{platform}: missing {expected_path!r} in {adapted!r}"
        assert expected_file in adapted, f"{label}/{platform}: missing {expected_file!r} in {adapted!r}"
        assert chr(92) * 2 not in adapted, f"{label}/{platform}: doubled backslash in {adapted!r}"
        assert ".claude" not in adapted, f"{label}/{platform}: .claude survived in {adapted!r}"
        print(f"  {label}/{platform}: OK")


def check_project_level_path() -> None:
    """A project-level path carries no home prefix and must still convert."""
    body = r"Project skills live in .claude\skills\my-skill."
    adapted, _ = adapt_body_content(body, "codex")
    expected = r".agents\skills" + chr(92)
    assert expected in adapted, f"project-level: missing {expected!r} in {adapted!r}"
    assert "%USERPROFILE%" not in adapted, f"project-level: home prefix invented in {adapted!r}"
    print("  project-level/codex: OK")


if __name__ == "__main__":
    check(WINDOWS_BODY, "windows-source")
    check(POSIX_BODY, "posix-source")
    check_project_level_path()
    print("all path conversions OK")
