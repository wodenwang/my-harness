param(
  [switch]$Check
)

$ErrorActionPreference = "Stop"

$PluginName = "my-harness"
$RepoSlug = "wodenwang/my-harness"

function Fail($Message) {
  Write-Error "upgrade failed: $Message"
  exit 1
}

function EnvOrDefault($Name, $Default) {
  $Value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($Value)) {
    return $Default
  }
  return $Value
}

function TomlEscape($Value) {
  return $Value.Replace("\", "\\").Replace('"', '\"')
}

function ManifestVersion($ManifestPath) {
  return (Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json).version
}

function ChangelogExcerpt($ChangelogPath, $Version) {
  if (-not (Test-Path $ChangelogPath)) {
    return
  }
  $Text = Get-Content -LiteralPath $ChangelogPath -Raw
  $Pattern = "(?ms)^##\s+$([regex]::Escape($Version))\b.*?(?=^##\s+|\z)"
  $Match = [regex]::Match($Text, $Pattern)
  if (-not $Match.Success) {
    return
  }
  $Lines = $Match.Value.Trim() -split "`r?`n"
  $Lines | Select-Object -First 14
}

function Resolve-LatestRef {
  try {
    $Release = Invoke-RestMethod -Uri "https://api.github.com/repos/$RepoSlug/releases/latest" -UseBasicParsing
    if ($Release.tag_name) {
      return $Release.tag_name
    }
  } catch {
  }

  $Tags = Invoke-RestMethod -Uri "https://api.github.com/repos/$RepoSlug/tags?per_page=1" -UseBasicParsing
  if (-not $Tags -or -not $Tags[0].name) {
    Fail "no releases or tags found"
  }
  return $Tags[0].name
}

function Copy-PluginTree($Source, $Destination) {
  if (Test-Path $Destination) {
    Remove-Item -LiteralPath $Destination -Recurse -Force
  }
  New-Item -ItemType Directory -Force -Path $Destination | Out-Null

  Get-ChildItem -LiteralPath $Source -Force | Where-Object {
    $_.Name -notin @(".git", "__pycache__", ".DS_Store")
  } | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $Destination -Recurse -Force
  }

  Get-ChildItem -LiteralPath $Destination -Recurse -Force -Directory -Filter "__pycache__" -ErrorAction SilentlyContinue |
    Remove-Item -Recurse -Force
  Get-ChildItem -LiteralPath $Destination -Recurse -Force -File -Filter "*.pyc" -ErrorAction SilentlyContinue |
    Remove-Item -Force
}

function Write-Marketplace($MarketplaceFile) {
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $MarketplaceFile) | Out-Null
  @'
{
  "name": "my-harness",
  "interface": {
    "displayName": "My Harness"
  },
  "plugins": [
    {
      "name": "my-harness",
      "source": {
        "source": "local",
        "path": "./plugins/my-harness"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Coding"
    }
  ]
}
'@ | Set-Content -LiteralPath $MarketplaceFile -Encoding UTF8
}

function Set-SkillEntry($SkillDir, $Target, $Stamp) {
  if (Test-Path $Target) {
    $Item = Get-Item -LiteralPath $Target -Force
    if (($Item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0 -or -not $Item.PSIsContainer) {
      Remove-Item -LiteralPath $Target -Recurse -Force
    } else {
      Move-Item -LiteralPath $Target -Destination "$Target.backup.$Stamp"
    }
  }

  try {
    New-Item -ItemType Junction -Path $Target -Target $SkillDir | Out-Null
  } catch {
    try {
      New-Item -ItemType SymbolicLink -Path $Target -Target $SkillDir | Out-Null
    } catch {
      Copy-Item -LiteralPath $SkillDir -Destination $Target -Recurse -Force
    }
  }
}

function Ensure-Config($ConfigFile, $MarketplaceRoot) {
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $ConfigFile) | Out-Null
  if (-not (Test-Path $ConfigFile)) {
    New-Item -ItemType File -Path $ConfigFile | Out-Null
  }

  $ConfigText = Get-Content -LiteralPath $ConfigFile -Raw
  if ($ConfigText -notmatch '\[plugins\."my-harness@my-harness"\]') {
    Add-Content -LiteralPath $ConfigFile -Value @'

# My Harness plugin configuration - managed by scripts/upgrade.ps1
[plugins."my-harness@my-harness"]
enabled = true
'@
  }

  $MarketplaceRootToml = TomlEscape $MarketplaceRoot
  $ConfigText = Get-Content -LiteralPath $ConfigFile -Raw
  if ($ConfigText -notmatch '\[marketplaces\.my-harness\]') {
    Add-Content -LiteralPath $ConfigFile -Value @"

[marketplaces.my-harness]
source_type = "local"
source = "$MarketplaceRootToml"
"@
  }
}

$CodexHome = EnvOrDefault "CODEX_HOME" (Join-Path $HOME ".codex")
$MarketplaceRoot = Join-Path (Join-Path (Join-Path $CodexHome "plugins") "local") $PluginName
$PluginRoot = Join-Path (Join-Path $MarketplaceRoot "plugins") $PluginName
$MarketplaceFile = Join-Path (Join-Path (Join-Path $MarketplaceRoot ".agents") "plugins") "marketplace.json"
$ConfigFile = Join-Path $CodexHome "config.toml"

if (-not (Test-Path $PluginRoot)) {
  Fail "$PluginRoot does not exist. Install $PluginName before upgrading."
}
$InstalledManifest = Join-Path $PluginRoot ".codex-plugin/plugin.json"
if (-not (Test-Path $InstalledManifest)) {
  Fail "installed plugin is missing .codex-plugin/plugin.json"
}

$TmpDir = Join-Path ([IO.Path]::GetTempPath()) ("my-harness-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null

try {
  $CurrentVersion = ManifestVersion $InstalledManifest
  $TargetRef = [Environment]::GetEnvironmentVariable("MY_HARNESS_REF")
  $TargetRefSource = "MY_HARNESS_REF"
  if ([string]::IsNullOrWhiteSpace($TargetRef)) {
    $TargetRef = Resolve-LatestRef
    $TargetRefSource = "latest GitHub Release/tag"
  }

  $ArchiveUrl = EnvOrDefault "MY_HARNESS_ARCHIVE_URL" "https://codeload.github.com/$RepoSlug/tar.gz/$TargetRef"

  Write-Host "My Harness upgrade plan"
  Write-Host "  installed plugin: $PluginRoot"
  Write-Host "  current version:  $CurrentVersion"
  Write-Host "  target ref:       $TargetRef ($TargetRefSource)"

  $ArchivePath = Join-Path $TmpDir "source.tar.gz"
  Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ArchivePath -UseBasicParsing
  & tar -xzf $ArchivePath -C $TmpDir
  if ($LASTEXITCODE -ne 0) {
    Fail "tar extraction failed"
  }

  $SourceDir = Get-ChildItem -LiteralPath $TmpDir -Directory | Select-Object -First 1
  if (-not $SourceDir) {
    Fail "could not find extracted source directory"
  }
  if (-not (Test-Path (Join-Path $SourceDir.FullName ".codex-plugin/plugin.json"))) {
    Fail "downloaded source is missing .codex-plugin/plugin.json"
  }
  if (-not (Test-Path (Join-Path $SourceDir.FullName "skills"))) {
    Fail "downloaded source is missing skills/"
  }

  $TargetVersion = ManifestVersion (Join-Path $SourceDir.FullName ".codex-plugin/plugin.json")
  Write-Host "  target version:   $TargetVersion"
  if ($CurrentVersion -eq $TargetVersion) {
    Write-Host "  version change:   no version number change"
  } else {
    Write-Host "  version change:   $CurrentVersion -> $TargetVersion"
  }

  $TargetChangelog = Join-Path $SourceDir.FullName "CHANGELOG.md"
  if (Test-Path $TargetChangelog) {
    Write-Host ""
    Write-Host "Target changelog:"
    ChangelogExcerpt $TargetChangelog $TargetVersion | ForEach-Object { Write-Host $_ }
  }

  $VerifyScript = Join-Path $SourceDir.FullName "scripts/verify.sh"
  if (-not (Test-Path $VerifyScript)) {
    Fail "downloaded source is missing scripts/verify.sh"
  }
  $Bash = Get-Command bash -ErrorAction SilentlyContinue
  if ($Bash) {
    Push-Location $SourceDir.FullName
    try {
      & $Bash.Source "./scripts/verify.sh" | Out-Null
    } finally {
      Pop-Location
    }
  }

  if ($Check) {
    Write-Host ""
    Write-Host "Check only. No files changed."
    exit 0
  }

  $Stamp = Get-Date -Format "yyyyMMddHHmmss"
  $BackupDir = Join-Path (Join-Path $MarketplaceRoot "backups") "$PluginName-$CurrentVersion-$Stamp"
  New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
  Get-ChildItem -LiteralPath $PluginRoot -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $BackupDir -Recurse -Force
  }

  Copy-PluginTree $SourceDir.FullName $PluginRoot
  Write-Marketplace $MarketplaceFile
  Ensure-Config $ConfigFile $MarketplaceRoot

  Get-ChildItem -LiteralPath (Join-Path $PluginRoot "skills") -Directory | ForEach-Object {
    $Target = Join-Path (Join-Path $CodexHome "skills") $_.Name
    Set-SkillEntry $_.FullName $Target $Stamp
  }

  $InstalledVersion = ManifestVersion (Join-Path $PluginRoot ".codex-plugin/plugin.json")

  Write-Host ""
  Write-Host "Upgraded $PluginName"
  Write-Host "  previous version: $CurrentVersion"
  Write-Host "  installed version: $InstalledVersion"
  Write-Host "  target ref:        $TargetRef"
  Write-Host "  backup:            $BackupDir"
  Write-Host "  plugin:            $PluginRoot"
  Write-Host "  marketplace:       $MarketplaceFile"
  Write-Host "  skills:            $(Join-Path $CodexHome 'skills/my-harness*')"
  Write-Host ""
  Write-Host "Restart Codex or refresh skill discovery if the updated skills are not visible yet."
} finally {
  Remove-Item -LiteralPath $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
}
