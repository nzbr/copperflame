if (-not ($colors -and $mode)) {
    Write-Error "This script should not be executed directly. Please run generator.ps1 instead."
    exit 1
}

[ordered]@{
    "text-color" = $colors["foreground"]
    "background-color" = $colors["background"]
    "line-number-color" = $colors["color7"]
    "line-number-background-color" = $colors["color8"]
} | ConvertTo-Json | Set-Content -Path "./pandoc/${themeName}-${mode}.theme"
