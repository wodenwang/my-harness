param()

$ErrorActionPreference = "Stop"

$PluginName = "my-harness"
$DefaultRef = "v1.0.4"
$RepoSlug = "wodenwang/my-harness"

function Fail($Message) {
  Write-Error "install failed: $Message"
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
  $Changed = $false

  if ($ConfigText -notmatch '\[plugins\."my-harness@my-harness"\]') {
    Add-Content -LiteralPath $ConfigFile -Value @'

# My Harness plugin configuration - managed by scripts/install.ps1
[plugins."my-harness@my-harness"]
enabled = true
'@
    $Changed = $true
  }

  $MarketplaceRootToml = TomlEscape $MarketplaceRoot
  $ConfigText = Get-Content -LiteralPath $ConfigFile -Raw
  if ($ConfigText -notmatch '\[marketplaces\.my-harness\]') {
    Add-Content -LiteralPath $ConfigFile -Value @"

[marketplaces.my-harness]
source_type = "local"
source = "$MarketplaceRootToml"
"@
    $Changed = $true
  }

  return $Changed
}

$Ref = EnvOrDefault "MY_HARNESS_REF" $DefaultRef
$CodexHome = EnvOrDefault "CODEX_HOME" (Join-Path $HOME ".codex")
$MarketplaceRoot = Join-Path (Join-Path (Join-Path $CodexHome "plugins") "local") $PluginName
$PluginRoot = Join-Path (Join-Path $MarketplaceRoot "plugins") $PluginName
$MarketplaceFile = Join-Path (Join-Path (Join-Path $MarketplaceRoot ".agents") "plugins") "marketplace.json"
$ConfigFile = Join-Path $CodexHome "config.toml"
$ArchiveUrl = EnvOrDefault "MY_HARNESS_ARCHIVE_URL" "https://codeload.github.com/$RepoSlug/tar.gz/$Ref"

$TmpDir = Join-Path ([IO.Path]::GetTempPath()) ("my-harness-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null

try {
  $ArchivePath = Join-Path $TmpDir "source.tar.gz"
  Write-Host "Installing $PluginName from $RepoSlug@$Ref"
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

  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $PluginRoot) | Out-Null
  New-Item -ItemType Directory -Force -Path (Join-Path $CodexHome "skills") | Out-Null

  Copy-PluginTree $SourceDir.FullName $PluginRoot
  Write-Marketplace $MarketplaceFile

  $Stamp = Get-Date -Format "yyyyMMddHHmmss"
  Get-ChildItem -LiteralPath (Join-Path $PluginRoot "skills") -Directory | ForEach-Object {
    $Target = Join-Path (Join-Path $CodexHome "skills") $_.Name
    Set-SkillEntry $_.FullName $Target $Stamp
  }

  $ConfigChanged = Ensure-Config $ConfigFile $MarketplaceRoot

  $VerifyScript = Join-Path $PluginRoot "scripts/verify.sh"
  if (Test-Path $VerifyScript) {
    $Bash = Get-Command bash -ErrorAction SilentlyContinue
    if ($Bash) {
      Push-Location $PluginRoot
      try {
        & $Bash.Source "./scripts/verify.sh" | Out-Null
      } finally {
        Pop-Location
      }
    }
  }

  Write-Host ""
  Write-Host "Installed $PluginName"
  Write-Host "  plugin:      $PluginRoot"
  Write-Host "  marketplace: $MarketplaceFile"
  Write-Host "  skills:      $(Join-Path $CodexHome 'skills/my-harness*')"
  Write-Host "  config:      $ConfigFile"
  Write-Host ""
  if ($ConfigChanged) {
    Write-Host "Updated Codex config. Restart Codex or refresh skill discovery if the plugin is not visible yet."
  } else {
    Write-Host "Codex config already had my-harness entries. Restart Codex or refresh skill discovery if needed."
  }
} finally {
  Remove-Item -LiteralPath $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
}
