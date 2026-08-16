---
name: skill-forge-publish
description: >
  Package and distribute Claude Code skills for sharing via GitHub, Claude.ai
  uploads, or team deployment. Creates install scripts, documentation, and
  .skill packages. Use when user says "publish skill", "share skill",
  "package skill", "distribute skill", or "release skill".
---

# Skill Publishing & Distribution

## Process

### Step 1: Pre-Publish Validation

Run the full review before publishing:
1. Execute `/skill-forge review <path>` and ensure score >= 80/100
2. Fix any critical or high-priority issues
3. Test with at least 5 trigger queries
4. Verify all cross-references resolve

### Step 2: Create the Plugin Manifests

The marketplace is the primary distribution route on Windows. It needs two files
at the repository root, and a layout where every skill sits under `skills\`.

`.claude-plugin\plugin.json` describes the plugin itself:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-plugin-manifest.json",
  "name": "skill-name",
  "displayName": "Skill Name",
  "version": "1.0.0",
  "description": "[what it does, when it triggers]",
  "author": { "name": "[you]", "url": "https://github.com/[user]" },
  "homepage": "https://github.com/[user]/[repo]",
  "repository": "https://github.com/[user]/[repo]",
  "license": "MIT",
  "keywords": ["[domain]", "[capability]"]
}
```

`.claude-plugin\marketplace.json` publishes it as a one-plugin catalogue:

```json
{
  "name": "[marketplace-name]",
  "owner": { "name": "[you]", "url": "https://github.com/[user]" },
  "description": "[what this catalogue offers]",
  "plugins": [
    {
      "name": "skill-name",
      "source": "./",
      "description": "[same description as plugin.json]",
      "category": "development",
      "tags": ["[domain]", "[capability]"]
    }
  ]
}
```

`source: "./"` means the repository root is the plugin. Claude Code then scans
`skills\` and `agents\` automatically, so declare no `skills` field unless one
shared `skills\` folder serves more than one plugin.

Validate both manifests before pushing:

```powershell
claude plugin validate .
```

### Step 2b: Create the PowerShell Install Script

Ship `install.ps1` as the manual fallback for users who don't want a plugin:

```powershell
#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Install [skill-name] into %USERPROFILE%\.claude\.
.PARAMETER Uninstall
    Remove everything this script installs.
#>
param([switch]$Uninstall)

$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$SkillDir = Join-Path $env:USERPROFILE ".claude\skills"
$AgentDir = Join-Path $env:USERPROFILE ".claude\agents"

if ($Uninstall) {
    Get-ChildItem -Path $SkillDir -Directory -Filter "skill-name*" -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force
    Get-ChildItem -Path $AgentDir -File -Filter "skill-name-*.md" -ErrorAction SilentlyContinue |
        Remove-Item -Force
    Write-Host "Uninstalled. Restart Claude Code to complete removal."
    return
}

New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
New-Item -ItemType Directory -Force -Path $AgentDir | Out-Null

foreach ($skill in Get-ChildItem -Path (Join-Path $ScriptDir "skills") -Directory) {
    $target = Join-Path $SkillDir $skill.Name
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Copy-Item -Path $skill.FullName -Destination $target -Recurse -Force
    Write-Host "  Installed skill: $($skill.Name)"
}

$agentSource = Join-Path $ScriptDir "agents"
if (Test-Path $agentSource) {
    Copy-Item -Path (Join-Path $agentSource "*.md") -Destination $AgentDir -Force
    Write-Host "  Installed agents"
}

Write-Host ""
Write-Host "Installation complete. Test with: /skill-name"
```

Delete the target directory before copying. `Copy-Item -Recurse` nests a second
copy inside an existing directory of the same name instead of replacing it.

### Step 3: Create README.md (repo-level, NOT inside skill folder)

```markdown
# [Skill Name]

[1-2 sentence description focusing on outcomes, not features]

## What it does

[Bullet list of key capabilities]

## Installation

### Claude Code plugin (recommended)
```
/plugin marketplace add [user]/[repo]
/plugin install skill-name@[marketplace-name]
```

### Manual (PowerShell)
```powershell
git clone https://github.com/[user]/[repo]
cd [repo]
powershell -ExecutionPolicy Bypass -File install.ps1
```

### Claude.ai
1. Download the latest release (.zip)
2. Go to Settings > Capabilities > Skills
3. Click "Upload skill"
4. Select the downloaded .zip file

## Commands

| Command | Description |
|---------|-------------|
| `/skill-name` | [description] |
| `/skill-name cmd` | [description] |

## Examples

### [Example 1 title]
```
User: "[example input]"
```
[Description of what happens and expected output]

## Architecture

```
[file tree diagram]
```

## License

[License type]
```

### Step 4: Package for Distribution

**For Claude.ai upload:**
Run `python scripts\package_skill.py <path> <output-dir>` to create a `.skill` zip file.

**For GitHub:**
1. Create repository with README.md at root
2. Every skill folder under `skills\`, every agent under `agents\`
3. `.claude-plugin\plugin.json` and `.claude-plugin\marketplace.json` at root
4. `install.ps1` at root as the manual fallback
5. Add LICENSE file
6. Add .gitignore (exclude .tmp/, __pycache__/, *.pyc)

**For team deployment (Claude.ai admin):**
- Skills can be deployed workspace-wide by admins
- Package as .skill zip and upload through admin console

### Step 5: Create .gitignore

```
__pycache__/
*.pyc
*.pyo
.tmp/
*.egg-info/
dist/
build/
.env
*.skill
```

### Step 6: Release Checklist

- [ ] All files validated (score >= 80)
- [ ] `claude plugin validate .` passes
- [ ] install.ps1 tested on a clean Windows profile
- [ ] README.md covers installation, usage, and examples
- [ ] LICENSE file included
- [ ] .gitignore configured
- [ ] No secrets or API keys in any file
- [ ] Test queries documented
- [ ] Version tagged (if using git)

### Step 7: Post-Publish

After publishing:
1. Test installation from scratch on a clean environment
2. Run all trigger test queries
3. Collect initial user feedback
4. Plan first iteration based on feedback
5. Set up issue templates for bug reports

## Distribution Channels

| Channel | Best For | Format |
|---------|----------|--------|
| Claude Code plugin marketplace | Wide distribution, automatic updates | `.claude-plugin\marketplace.json` in a GitHub repo |
| GitHub clone | Users who want the source | Repository + install.ps1 |
| Claude.ai upload | Personal use | .skill zip |
| Team admin | Organization-wide | .skill zip via admin console |
