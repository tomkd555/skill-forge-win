# Changelog

## v1.2.0 — Windows Edition & Plugin Marketplace

Fork of [AgriciDaniel/skill-forge](https://github.com/AgriciDaniel/skill-forge),
rebuilt for Windows and for installation through the Claude Code plugin marketplace.

### Marketplace

- `.claude-plugin/marketplace.json` publishes the repository as a one-plugin catalogue with `source: "./"`
- `.claude-plugin/plugin.json` carries the full manifest (displayName, author, repository, keywords)
- Main skill moved from `skill-forge/` to `skills/skill-forge/`, so all 9 skills and 8 agents land in the directories Claude Code scans automatically

### Windows

- `install.ps1` replaces `install.sh` and `uninstall.sh`, with `-Uninstall` folding both jobs into one script
- Every `read_text()` / `write_text()` call passes `encoding="utf-8"`, so scripts no longer fail on a cp932 locale
- `package_skill.py` writes ZIP entry names with forward slashes, which the ZIP format requires
- `convert_skill.py` generates `install-multiplatform.ps1` instead of a Bash installer, and no longer calls `os.chmod`
- Hook examples, storage paths, and command samples across the skills and references use PowerShell and `%USERPROFILE%`

## v1.1.0 — Eval Pipeline & Benchmarking

### Features

- **Eval** — Run evaluation pipelines on skills with assertions, grading, and multi-agent execution (executor, grader, comparator, analyzer agents)
- **Benchmark** — Measure skill performance with variance analysis, multiple trials, threshold gating, and iteration comparison
- **Description Optimization** — Automated train/test split scoring to optimize skill descriptions for trigger accuracy
- **Eval Set Generation** — Auto-generate trigger eval sets from SKILL.md descriptions
- **Blind A/B Comparison** — Unbiased comparison between skill versions via comparator agent
- **Enhanced Review** — Review sub-skill now generates trigger eval sets and runs description optimization
- **Enhanced Evolve** — Evolve sub-skill now includes iteration workspace protocol and description optimization loop
- 4 new agents: `skill-forge-executor`, `skill-forge-grader`, `skill-forge-analyzer`, `skill-forge-comparator`
- 3 new scripts: `generate_eval_set.py`, `aggregate_benchmark.py`, `optimize_description.py`
- 2 new sub-skills: `skill-forge-eval`, `skill-forge-benchmark`

## v1.0.0 — Initial Release

### Features

- **Skill Forge orchestrator** — Tier 4 skill with routing table, 6 sub-skills, 4 agents, 4 scripts
- **Plan** — Architecture design with complexity tier detection (1-4), sub-skill decomposition, and file structure planning
- **Build** — Full skill scaffolding with SKILL.md generation, frontmatter writing, sub-skills, scripts, references, and agents
- **Review** — Quality auditing with 0-100 health score across 6 categories (structure, frontmatter, description, body, scripts, agents)
- **Evolve** — Skill improvement based on feedback, triggering issues, and testing results
- **Publish** — Packaging as `.skill` ZIP files with install script generation
- **Convert** — Multi-platform conversion to OpenAI Codex, Google Gemini CLI, Google Antigravity, and Cursor
- **10 reference files** — Comprehensive knowledge base covering anatomy, patterns, frontmatter spec, description guide, testing, 3-layer architecture, tools, hooks, activation, and platform specs
- **4 execution scripts** — `init_skill.py` (scaffold), `validate_skill.py` (validate), `package_skill.py` (package), `convert_skill.py` (convert)
- **4 agent definitions** — Architect, Writer, Validator, and Converter subagents for parallel delegation
- **4 skill templates** — Tier 1 (minimal), Tier 2 (workflow), Tier 3 (multi-skill), Tier 4 (ecosystem)
- **Progressive disclosure** — 3-level loading (frontmatter always, instructions on activation, references on demand)
- **Agent Skills standard** — Full compliance with the open standard at agentskills.io
