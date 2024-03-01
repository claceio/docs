#!/usr/bin/env pwsh

# Copyright (c) ClaceIO, LLC
# SPDX-License-Identifier: Apache-2.0

$ErrorActionPreference = 'Stop'

$Version = if ($v) {
  $v
} elseif ($args.Length -eq 1) {
  $args.Get(0)
} else {
  "latest"
}

$ClaceInstall = $env:CL_HOME
if (!$ClaceInstall) {
  $ClaceInstall = "$Home\clhome"
}

$BinDir = "$ClaceInstall\bin"
$ClaceZip = "$BinDir\clace.zip"
$ClaceExe = "$BinDir\clace.exe"
$ClaceConfig = "$ClaceInstall\clace.toml"
$ClaceUri = "https://github.com/claceio/clace/releases/download/$Version/clace-$Version-windows-amd64.zip"

# GitHub require TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if ( $Version -eq "latest") {
  try {
    $Response = Invoke-WebRequest "https://api.github.com/repos/claceio/clace/releases/$Version"
    $jsonResponse = $Response.Content | ConvertFrom-Json
    $Version = $jsonResponse.tag_name
    $ClaceUri = "https://github.com/claceio/clace/releases/download/$Version/clace-$Version-windows-amd64.zip"
  }
  catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
    if ($StatusCode -eq 404) {
      Write-Error "Unable to find a clace release on GitHub for version:$Version - see github.com/claceio/clace/releases for all versions"
    } else {
      $Request = $_.Exception
      Write-Error "Error while fetching releases: $Request"
    }
    Exit 1
  }
}

if (!(Test-Path $BinDir)) {
  New-Item $BinDir -ItemType Directory | Out-Null
}

$prevProgressPreference = $ProgressPreference
try {
  # Avoid perf issues with progress bar
  if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Output "Downloading clace..."
    $ProgressPreference = "SilentlyContinue"
  }

  Invoke-WebRequest $ClaceUri -OutFile $ClaceZip -UseBasicParsing
} finally {
  $ProgressPreference = $prevProgressPreference
}

if (Get-Command Expand-Archive -ErrorAction SilentlyContinue) {
  Expand-Archive $ClaceZip -Destination $ClaceInstall -Force
} else {
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [IO.Compression.ZipFile]::ExtractToDirectory($ClaceZip, $ClaceInstall)
}

try {
  Move-Item -Path "$ClaceInstall\clace-$Version-windows-amd64\clace.exe" -Destination "$ClaceExe" -Force
} catch {
  Write-Output "Error - File move to $ClaceExe failed: $_"
  Write-Output "Stop clace server if it is running"
  Exit 1
}
Remove-Item $ClaceZip

$User = [EnvironmentVariableTarget]::User
$Path = [Environment]::GetEnvironmentVariable('Path', $User)
if (!(";$Path;".ToLower() -like "*;$BinDir;*".ToLower())) {
  [Environment]::SetEnvironmentVariable('Path', "$Path;$BinDir", $User)
  $Env:Path += ";$BinDir"
}

[Environment]::SetEnvironmentVariable('CL_CONFIG_FILE', "$ClaceConfig", $User)
$Env:CL_CONFIG_FILE = "$ClaceConfig"

[Environment]::SetEnvironmentVariable('CL_HOME', "$ClaceInstall", $User)
$Env:CL_HOME = "$ClaceInstall"

# Create the password config file entry if not already present
if (Test-Path -Path $ClaceConfig -PathType Leaf) {
  Write-Output "Config file $ClaceConfig already exists, not generating password"
} else {
  & "$ClaceExe" "password" | Out-File -FilePath "$ClaceConfig" -Encoding utf8
  Write-Output ""
  Write-Output "Password config has been setup, save the above password, username:admin"
}


Write-Output "clace $Version was installed successfully to $ClaceExe."
Write-Output "Open new command shell and run 'clace' to get started."
Write-Output "See https://clace.io/docs/quickstart/ for quick start docs."

