# Skill Forge for Windows — Claude Code Skill Creator

## Project Overview

This repository contains **Skill Forge for Windows**, a Tier 4 Claude Code skill for
creating, reviewing, evolving, and publishing other Claude Code skills. It follows the
Agent Skills open standard and the 3-layer architecture (directive, orchestration,
execution).

It is a Windows-native fork of [AgriciDaniel/skill-forge](https://github.com/AgriciDaniel/skill-forge).
The repository doubles as its own plugin marketplace, so it installs through
`/plugin marketplace add tomkd555/skill-forge-win`.

## Architecture

```
skill-forge-win/                     # Repository root and plugin root
  CLAUDE.md                          # Project instructions
  install.ps1                        # Manual installer (-Uninstall removes)
  .claude-plugin/
    plugin.json                      # Plugin manifest
    marketplace.json                 # One-plugin catalogue, source "./"
  skills/
    skill-forge/                     # Main orchestrator skill (Tier 4)
      SKILL.md                       # Entry point, routing table, core rules
      references/                    # On-demand knowledge files (10 files)
        anatomy.md                   # Skill file structure, naming, agent format
        patterns.md                  # Proven workflow patterns
        frontmatter-spec.md          # YAML frontmatter specification
        description-guide.md         # Writing effective descriptions
        testing-guide.md             # Testing methodology
        pro-agent.md                 # 3-layer architecture deep dive
        tools-reference.md           # Tool names, permission patterns, MCP
        hooks-reference.md           # Hook events, types, quality gates
        skills-activation.md         # Skill discovery, activation, features
        platforms.md                 # Multi-platform conversion rules
      scripts/                       # Deterministic execution scripts
        init_skill.py                # Scaffold new skills
        validate_skill.py            # Validate skill structure
        package_skill.py             # Package for distribution
        convert_skill.py             # Convert skills to other platforms
        generate_eval_set.py         # Generate trigger eval sets from SKILL.md
        aggregate_benchmark.py       # Aggregate eval results into benchmarks
        optimize_description.py      # Optimize descriptions with train/test split
        skill_utils.py               # Shared utilities (frontmatter parser)
      assets/templates/              # Skill templates by tier
        minimal.md                   # Tier 1: single SKILL.md
        workflow.md                  # Tier 2: SKILL.md + scripts
        multi-skill.md               # Tier 3: orchestrator + sub-skills
        ecosystem.md                 # Tier 4: full ecosystem
    skill-forge-plan/SKILL.md        # Architecture and design planning
    skill-forge-build/SKILL.md       # Scaffold and generate skills
    skill-forge-review/SKILL.md      # Audit and validate skills
    skill-forge-evolve/SKILL.md      # Improve skills from feedback
    skill-forge-eval/SKILL.md        # Run eval pipeline with assertions
    skill-forge-benchmark/SKILL.md   # Benchmark performance tracking
    skill-forge-publish/SKILL.md     # Package and distribute skills
    skill-forge-convert/SKILL.md     # Convert skills to other platforms
  agents/                            # Subagent definitions
    skill-forge-architect.md         # Architecture design agent
    skill-forge-writer.md            # SKILL.md content writer agent
    skill-forge-validator.md         # Validation agent
    skill-forge-converter.md         # Platform conversion agent
    skill-forge-executor.md          # Eval execution agent
    skill-forge-grader.md            # Eval grading agent
    skill-forge-analyzer.md          # Benchmark analysis agent
    skill-forge-comparator.md        # Blind A/B comparison agent
```

Claude Code scans `skills\` and `agents\` automatically, so `plugin.json` declares
no component paths. Moving a skill out of `skills\` breaks the plugin install.

## Key Principles

1. **Progressive Disclosure**: Metadata always loaded, instructions on activation, resources on demand
2. **Description is King**: The YAML description field determines when skills activate
3. **3-Layer Architecture**: Directives (SKILL.md) + Orchestration (Claude) + Execution (scripts)
4. **Self-Annealing**: Learn from failures, update skills with discoveries
5. **Simplicity First**: Start with Tier 1, evolve to higher tiers only when needed

## Development Rules

- Test with `python skills\skill-forge\scripts\validate_skill.py <path>` after changes
- Run `claude plugin validate .` after touching either manifest
- Keep SKILL.md files under 500 lines / 5000 tokens
- Reference files should be focused and under 200 lines
- Scripts must have docstrings, CLI interface, JSON output
- Follow kebab-case naming for all skill directories
- Never put README.md inside skill folders

## Windows Rules

- Every file read and write passes `encoding="utf-8"`. Without it, Python falls back
  to the locale encoding, which is cp932 on a Japanese Windows, and UTF-8 content
  fails to decode.
- ZIP entry names use `Path.as_posix()`. The ZIP format requires forward slashes,
  and `str(path)` produces backslashes on Windows.
- Shell examples in skills and references are PowerShell. Hook commands take the
  form `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/name.ps1`, with
  forward slashes, so JSON and YAML need no escaping.
- User-level paths are written `%USERPROFILE%\.claude\...`.

## Commands

| Command | Purpose |
|---------|---------|
| `/skill-forge` | Interactive skill creation wizard |
| `/skill-forge plan` | Design skill architecture |
| `/skill-forge build` | Scaffold and generate skill files |
| `/skill-forge review` | Audit existing skill quality |
| `/skill-forge evolve` | Improve skill from feedback |
| `/skill-forge eval` | Run eval pipeline to test skill quality |
| `/skill-forge benchmark` | Benchmark skill performance |
| `/skill-forge publish` | Package for distribution |
| `/skill-forge convert` | Convert skills to other platforms |
