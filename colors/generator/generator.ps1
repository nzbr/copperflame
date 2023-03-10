#!/usr/bin/env pwsh

if ($PSVersionTable.PSEdition -ne 'Core') {
    Write-Error "This script requires PowerShell Core. Please run this script with PowerShell Core and try again."
    exit 1
}

if (! (Test-Path -Path "./flake.nix" -PathType Leaf)) {
    Write-Error "This script must be run in the project's root directory. Please change your current directory and try again."
    exit 1
}

#### CONSTS ####

$themeName = "copperflame"

#### FUNCTIONS ####

function Get-XresourcesColors($XresourcesPath) {
    $colors = @{}
    $Xresources = Get-Content $XresourcesPath
    foreach ($line in $Xresources) {
        if ($line -match '^\*.(.+?):\s+(#[0-9a-f]+)$') {
            $colors[$matches[1]] = $matches[2]
        }
    }
    return $colors
}

#### MAIN ####

foreach ($mode in @("dark", "light")) {
    # Read colors from .Xresources file
    $colors = Get-XresourcesColors "./colors/${mode}.Xresources"

    $generators = Get-ChildItem -Path $PSScriptRoot/generators -Filter "*.ps1"
    foreach ($generator in $generators) {
        Write-Host "Generating $mode colors for $($generator.Name.Replace('.ps1', ''))..."
        try {
            . $generator.FullName
       } catch {
            Write-Error "Failed to generate $mode colors for $($generator.Name.Replace('.ps1', ''))!"
            Write-Error $_
            exit 1
        }
    }
}
