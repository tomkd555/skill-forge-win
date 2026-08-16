#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Install Skill Forge for Windows -- the Claude Code skill creator.

.DESCRIPTION
    Copies every skill under skills\ to %USERPROFILE%\.claude\skills\ and every
    agent definition under agents\ to %USERPROFILE%\.claude\agents\.

    This is the manual route. The supported route is the plugin marketplace:

        /plugin marketplace add tomkd555/skill-forge-win
        /plugin install skill-forge-win@skill-forge-win

    Re-running the script replaces any previously installed copy.

.PARAMETER Uninstall
    Remove every skill and agent this script installs, then exit.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File install.ps1

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
#>
param([switch]$Uninstall)

$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$SkillDir = Join-Path $ClaudeDir "skills"
$AgentDir = Join-Path $ClaudeDir "agents"

function Write-Banner {
    param([string]$Title)
    Write-Host "========================================="
    Write-Host "  $Title"
    Write-Host "========================================="
    Write-Host ""
}

function Invoke-Uninstall {
    Write-Banner "Skill Forge Uninstaller"

    $script:removed = 0

    Get-ChildItem -Path $SkillDir -Directory -Filter "skill-forge*" -ErrorAction SilentlyContinue |
        ForEach-Object {
            Remove-Item -Recurse -Force $_.FullName
            Write-Host "  [OK] Removed skill: $($_.Name)" -ForegroundColor Green
            $script:removed++
        }

    Get-ChildItem -Path $AgentDir -File -Filter "skill-forge-*.md" -ErrorAction SilentlyContinue |
        ForEach-Object {
            Remove-Item -Force $_.FullName
            Write-Host "  [OK] Removed agent: $($_.Name)" -ForegroundColor Green
            $script:removed++
        }

    Write-Host ""
    Write-Host "  Removed $script:removed items."
    Write-Host "  Restart Claude Code to complete removal." -ForegroundColor Yellow
    Write-Host ""
}

function Invoke-Install {
    Write-Banner "Skill Forge Installer (Windows)"

    $sourceSkills = Join-Path $ScriptDir "skills"
    if (-not (Test-Path $sourceSkills)) {
        Write-Error "skills\ directory not found next to install.ps1. Run the script from the repository root."
    }

    New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
    New-Item -ItemType Directory -Force -Path $AgentDir | Out-Null

    $installedSkills = 0
    foreach ($skill in Get-ChildItem -Path $sourceSkills -Directory) {
        $target = Join-Path $SkillDir $skill.Name
        if (Test-Path $target) {
            Remove-Item -Recurse -Force $target
        }
        Copy-Item -Path $skill.FullName -Destination $target -Recurse -Force
        Write-Host "  [OK] Installed skill: $($skill.Name)" -ForegroundColor Green
        $installedSkills++
    }

    $installedAgents = 0
    $sourceAgents = Join-Path $ScriptDir "agents"
    if (Test-Path $sourceAgents) {
        foreach ($agent in Get-ChildItem -Path $sourceAgents -File -Filter "skill-forge-*.md") {
            Copy-Item -Path $agent.FullName -Destination $AgentDir -Force
            Write-Host "  [OK] Installed agent: $($agent.Name)" -ForegroundColor Green
            $installedAgents++
        }
    }

    # Python bytecode caches travel with the copy; drop them from the install.
    Get-ChildItem -Path $SkillDir -Directory -Filter "__pycache__" -Recurse -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host ""
    Write-Banner "Installation Complete"
    Write-Host "  Skills:  $installedSkills"
    Write-Host "  Agents:  $installedAgents"
    Write-Host ""
    Write-Host "  Get started:"
    Write-Host "    /skill-forge            Interactive wizard"
    Write-Host "    /skill-forge plan       Design a new skill"
    Write-Host "    /skill-forge build      Scaffold a skill"
    Write-Host "    /skill-forge review     Audit a skill"
    Write-Host "    /skill-forge eval       Run eval pipeline"
    Write-Host "    /skill-forge benchmark  Benchmark performance"
    Write-Host "    /skill-forge convert    Convert to other platforms"
    Write-Host ""
    Write-Host "  Uninstall:"
    Write-Host "    powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall"
    Write-Host ""
}

if ($Uninstall) {
    Invoke-Uninstall
} else {
    Invoke-Install
}
