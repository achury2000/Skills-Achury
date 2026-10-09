<#
.SYNOPSIS
    Skills-Achury installer for Claude Code and OpenCode (Windows).
.DESCRIPTION
    Installs curated agent skills, agents, commands, and rules into
    ~/.claude and/or ~/.opencode.
.EXAMPLE
    .\install.ps1
    .\install.ps1 -Profile full -Target both
    .\install.ps1 -DryRun
    .\install.ps1 -Uninstall
    .\install.ps1 -List
#>
[CmdletBinding()]
param(
    [ValidateSet('minimal','standard','full')]
    [string]$Profile = 'standard',

    [ValidateSet('claude','opencode','both','auto')]
    [string]$Target = 'auto',

    [switch]$DryRun,
    [switch]$Uninstall,
    [switch]$List
)

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Version = '1.0.0'
$ManifestDir = Join-Path $env:USERPROFILE '.skills-achury'
$ManifestFile = Join-Path $ManifestDir 'install.json'

function Write-Log  { param($Msg) Write-Host "[skills-achury] $Msg" -ForegroundColor Cyan }
function Write-Ok   { param($Msg) Write-Host "[ok] $Msg" -ForegroundColor Green }
function Write-Warn { param($Msg) Write-Host "[warn] $Msg" -ForegroundColor Yellow }
function Write-Err  { param($Msg) Write-Host "[error] $Msg" -ForegroundColor Red }

# List mode
if ($List) {
    $skills = Get-ChildItem (Join-Path $ScriptDir 'skills') -Directory -ErrorAction SilentlyContinue
    $agents = Get-ChildItem (Join-Path $ScriptDir 'agents') -File -Filter '*.md' -ErrorAction SilentlyContinue
    $commands = Get-ChildItem (Join-Path $ScriptDir 'commands') -File -Filter '*.md' -ErrorAction SilentlyContinue
    Write-Host "Skills ($($skills.Count)):"; $skills | ForEach-Object { Write-Host "  $($_.Name)" }
    Write-Host "`nAgents ($($agents.Count)):"; $agents | ForEach-Object { Write-Host "  $($_.BaseName)" }
    Write-Host "`nCommands ($($commands.Count)):"; $commands | ForEach-Object { Write-Host "  $($_.BaseName)" }
    exit 0
}

# Uninstall mode
if ($Uninstall) {
    if (-not (Test-Path $ManifestFile)) {
        Write-Err "No install manifest found at $ManifestFile. Nothing to uninstall."
        exit 1
    }
    Write-Log 'Uninstalling from manifest...'
    $filesTxt = Join-Path $ManifestDir 'files.txt'
    if (Test-Path $filesTxt) {
        Get-Content $filesTxt | ForEach-Object {
            if ($DryRun) { Write-Host "  would remove: $_" }
            elseif (Test-Path $_) {
                Remove-Item $_ -Force -ErrorAction SilentlyContinue
                Write-Host "  removed: $_"
            }
        }
        Write-Ok 'Uninstall complete'
    } else {
        Write-Warn "files.txt not found. See $ManifestFile"
    }
    exit 0
}

# Detect harnesses
$targets = @()
if ($Target -eq 'auto') {
    if (Test-Path (Join-Path $env:USERPROFILE '.claude'))  { $targets += 'claude' }
    if (Test-Path (Join-Path $env:USERPROFILE '.opencode')) { $targets += 'opencode' }
    if ($targets.Count -eq 0) { $targets = @('claude','opencode') }
} else {
    $targets = @($Target)
}

Write-Log "Profile: $Profile"
Write-Log "Targets: $($targets -join ', ')"
if ($DryRun) { Write-Log 'Mode: DRY RUN (no files will be written)' }

$installedFiles = New-Object System.Collections.Generic.List[string]

function Copy-SkillDir {
    param([string]$Src, [string]$Dest)
    if ($DryRun) { Write-Host "  would copy dir: $Src -> $Dest"; return }
    New-Item -ItemType Directory -Force -Path $Dest | Out-Null
    Copy-Item "$Src\*" -Destination $Dest -Recurse -Force
    Get-ChildItem $Dest -Recurse -File | ForEach-Object { $installedFiles.Add($_.FullName) }
}

function Copy-SingleFile {
    param([string]$Src, [string]$Dest)
    if ($DryRun) { Write-Host "  would copy: $Src -> $Dest"; return }
    New-Item -ItemType Directory -Force -Path (Split-Path $Dest -Parent) | Out-Null
    Copy-Item $Src -Destination $Dest -Force
    $installedFiles.Add($Dest)
}

$MinimalSkills = @(
    'security-audit','shadcn','migrate-radix-to-base',
    'tdd-workflow','code-review','security-review','coding-standards',
    'error-handling','api-design','frontend-patterns','backend-patterns',
    'react-patterns','python-patterns','golang-patterns','rust-patterns',
    'e2e-testing','search-first','git-workflow',
    'code-simplifier','performance-optimizer','silent-failure-hunter',
    'documentation-lookup','prompt-optimizer','context-budget',
    'repo-scan','codebase-onboarding','code-tour',
    'architecture-decision-records','delivery-gate'
)

function Test-ShouldInstallSkill {
    param([string]$Name)
    if ($Profile -eq 'minimal') { return ($MinimalSkills -contains $Name) }
    return $true
}

foreach ($t in $targets) {
    switch ($t) {
        'claude' {
            $claudeDir = Join-Path $env:USERPROFILE '.claude'
            Write-Log "Installing for Claude Code -> $claudeDir"
            # Skills
            Get-ChildItem (Join-Path $ScriptDir 'skills') -Directory | ForEach-Object {
                if (Test-ShouldInstallSkill $_.Name) {
                    Copy-SkillDir $_.FullName (Join-Path $claudeDir "skills\$($_.Name)")
                }
            }
            # Agents + commands + rules
            if ($Profile -ne 'minimal') {
                Get-ChildItem (Join-Path $ScriptDir 'agents') -File -Filter '*.md' -ErrorAction SilentlyContinue | ForEach-Object {
                    Copy-SingleFile $_.FullName (Join-Path $claudeDir "agents\$($_.Name)")
                }
                Get-ChildItem (Join-Path $ScriptDir 'commands') -File -Filter '*.md' -ErrorAction SilentlyContinue | ForEach-Object {
                    Copy-SingleFile $_.FullName (Join-Path $claudeDir "commands\$($_.Name)")
                }
                if (Test-Path (Join-Path $ScriptDir 'rules')) {
                    Copy-SkillDir (Join-Path $ScriptDir 'rules') (Join-Path $claudeDir 'rules\skills-achury')
                }
            }
            
            Write-Ok 'Claude Code install done'
        }
        'opencode' {
            $opencodeDir = Join-Path $env:USERPROFILE '.opencode'
            Write-Log "Installing for OpenCode -> $opencodeDir"
            Get-ChildItem (Join-Path $ScriptDir 'skills') -Directory | ForEach-Object {
                if (Test-ShouldInstallSkill $_.Name) {
                    Copy-SkillDir $_.FullName (Join-Path $opencodeDir "skills\$($_.Name)")
                }
            }
            Write-Ok 'OpenCode install done (skills only)'
        }
        default {
            Write-Err "Unknown target: $t"
            exit 1
        }
    }
}

# Save manifest
if (-not $DryRun -and $installedFiles.Count -gt 0) {
    New-Item -ItemType Directory -Force -Path $ManifestDir | Out-Null
    $installedFiles | Set-Content -Path (Join-Path $ManifestDir 'files.txt') -Encoding UTF8
    $manifest = @{
        version      = $Version
        profile      = $Profile
        targets      = $targets
        installed_at = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        file_count   = $installedFiles.Count
    } | ConvertTo-Json -Depth 3
    Set-Content -Path $ManifestFile -Value $manifest -Encoding UTF8
    Write-Ok "Install manifest saved to $ManifestFile"
}

Write-Host ''
Write-Ok "Skills-Achury v$Version installed successfully!"
Write-Log 'Restart your agent session to pick up new skills.'
