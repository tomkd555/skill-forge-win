# Skill Forge for Windows — Claude Code Skill Creator

![Skill Forge](skill-forge-header.jpeg)

Design, scaffold, build, review, evolve, and publish production-grade Claude Code
skills following the [Agent Skills open standard](https://agentskills.io).

This is a Windows-native fork of [AgriciDaniel/skill-forge](https://github.com/AgriciDaniel/skill-forge).
See [Differences from upstream](#differences-from-upstream) for what changed.

## Features

- **Plan** — Analyze use cases, select complexity tier (1-4), design architecture with sub-skill decomposition
- **Build** — Scaffold complete skill file trees with SKILL.md, sub-skills, scripts, references, and agents
- **Review** — Audit any skill with a 0-100 health score across 6 quality categories
- **Evolve** — Fix triggering issues, improve instructions, refine architecture based on feedback
- **Publish** — Package as `.skill` files, generate plugin manifests, prepare for GitHub distribution
- **Convert** — Port skills to OpenAI Codex, Google Gemini CLI, Google Antigravity, and Cursor
- **Eval** — Run evaluation pipelines with assertions, grading, and multi-agent execution
- **Benchmark** — Measure performance with variance analysis, multiple trials, and threshold gating

## Installation

### Plugin marketplace (recommended)

In Claude Code:

```
/plugin marketplace add tomkd555/skill-forge-win
/plugin install skill-forge-win@skill-forge-win
```

Update later with `/plugin marketplace update skill-forge-win`.

### Manual (PowerShell)

```powershell
git clone https://github.com/tomkd555/skill-forge-win.git
cd skill-forge-win
powershell -ExecutionPolicy Bypass -File install.ps1
```

The script copies every skill to `%USERPROFILE%\.claude\skills\` and every agent
to `%USERPROFILE%\.claude\agents\`. Re-running it replaces the previous copy.

### Uninstall

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
```

Remove a plugin install with `/plugin uninstall skill-forge-win` instead.

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `/skill-forge` | Interactive skill creation wizard |
| `/skill-forge plan <domain>` | Architecture and design planning |
| `/skill-forge build <name>` | Scaffold and build a skill |
| `/skill-forge review <path>` | Audit an existing skill (0-100 score) |
| `/skill-forge evolve <path>` | Improve a skill from feedback |
| `/skill-forge publish <path>` | Package for distribution |
| `/skill-forge eval <path>` | Run eval pipeline to test skill quality |
| `/skill-forge benchmark <path>` | Benchmark skill with variance analysis |
| `/skill-forge convert <path>` | Convert to Codex, Gemini, Antigravity, or Cursor |

### Examples

Create a simple skill:

```
/skill-forge build my-tool
```

Design a complex skill ecosystem:

```
/skill-forge plan "DevOps toolkit for Docker and Kubernetes management"
```

Review an existing skill:

```
/skill-forge review %USERPROFILE%\.claude\skills\my-skill
```

Convert a skill for other platforms:

```
/skill-forge convert %USERPROFILE%\.claude\skills\my-skill
```

Quick scaffold with the CLI script:

```powershell
python skills\skill-forge\scripts\init_skill.py devops-toolkit --tier 3 --sub docker,k8s,monitor
```

## Differences from upstream

| Area | Upstream | This fork |
|------|----------|-----------|
| Installer | `install.sh` (bash) | `install.ps1` (PowerShell 5.1 or 7) |
| Script file I/O | Locale default encoding | Explicit `encoding="utf-8"`, so UTF-8 content survives a cp932 locale |
| ZIP entry names | `str(path)` | `Path.as_posix()`, since the ZIP format requires forward slashes |
| Shell examples | bash | PowerShell, with `%USERPROFILE%\.claude\...` paths |
| Distribution | Manual copy | Plugin marketplace, plus `install.ps1` for a manual copy |

Everything else — the skill tiers, the file layout, the 3-layer architecture, the
routing between sub-skills — follows upstream. Read the
[upstream README](https://github.com/AgriciDaniel/skill-forge) for that design,
and `skills/skill-forge/references/` in this repository for the full reference set.

## Dependencies

- **Windows 10 or 11** — PowerShell 5.1 or PowerShell 7 both run the installer
- **Python 3.10+** — Required for scaffolding, validation, packaging, conversion, eval, and benchmarking scripts
- **Claude Code** — The command-line tool these skills are built for
- No external Python packages required (stdlib only)

## Built With

- [Agent Skills Standard](https://agentskills.io) — Open standard for AI agent skills
- [3-Layer Architecture](skills/skill-forge/references/pro-agent.md) — Directive + Orchestration + Execution

## Support

- **Issues**: [GitHub Issues](https://github.com/tomkd555/skill-forge-win/issues)
- **Discussions**: [GitHub Discussions](https://github.com/tomkd555/skill-forge-win/discussions)

## License

[MIT](LICENSE) — copyright held by the original author, Daniel Agrici, and by
tomkd555 for the changes in this fork.
