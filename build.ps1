#!/usr/bin/env pwsh

# ensure powershell core
if ($PSVersionTable.PSEdition -ne 'Core') {
    Write-Error "This script requires PowerShell Core"
    exit 1
}

if (!(Test-Path -Path "./node_modules")) {
    if (!(Get-Command pnpm -ErrorAction SilentlyContinue)) {
        Write-Error "pnpm is not installed. Please install it from https://pnpm.io/installation"
        exit 1
    }
    pnpm install

}

pwsh ./base16/build.ps1
pwsh ./examples/build.ps1
