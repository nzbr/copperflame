if (-not ($colors -and $mode)) {
    Write-Error "This script should not be executed directly. Please run generator.ps1 instead."
    exit 1
}

$colors.GetEnumerator() | % {
    "\definecolor{$($_.Key)}{HTML}{$($_.Value.Substring(1))}"
} | Set-Content -Path "./pandoc/${themeName}-colors-${mode}.tex"
