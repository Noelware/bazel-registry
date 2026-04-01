$ErrorActionPreference = 'Stop'

$module = $args[0]
$version = $args[1]

if (-not $module -or -not $version) {
    Write-Error "Usage: .ci/check-module.ps1 <MODULE> <VERSION>"
}

if (-not (Get-Command "bazel" -ErrorAction SilentlyContinue)) {
    Write-Error "fatal: cannot find 'bazel' binary"
    exit 1
}

$directory = if ($env:GITHUB_WORKSPACE) {
    $env:GITHUB_WORKSPACE
} else {
    Get-Location
}

$scratchdir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $scratchdir | Out-Null
Set-Location $scratchdir

$modulebzl = @"
module(name = "module_test")
bazel_dep(name = "$module", version = "$version")
"@

$modulebzl | Out-File -FilePath "MODULE.bazel" -Encoding utf8

$normalizedPath = $wd.ToString().Replace('\', '/')
$registryUrl = "file:///$normalizedPath"

# Prevent MSYS path mangling if running inside Git Bash on Windows
$env:MSYS2_ARG_CONV_EXCL = "file://"

Write-Host "===> trigger: 'bazel fetch'"
bazel fetch --registry="https://bcr.bazel.build" --registry="$registryUrl" | Out-Null

Write-Host "===> trigger: 'bazel mod graph'"
bazel mod graph --registry="https://bcr.bazel.build" --registry="$registryUrl" --extension_info=all | Out-Null
