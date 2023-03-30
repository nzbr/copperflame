#!/usr/bin/env pwsh

$filterPath = if (Get-Command pandoc-filter-copperflame-latex -ErrorAction SilentlyContinue) {
    "pandoc-filter-copperflame-latex"
} elseif ($IsWindows) {
    "../pandoc/pandoc-filter-copperflame-latex/run.bat"
} else {
    "../pandoc/pandoc-filter-copperflame-latex/run.sh"
}

$out = "$PsScriptRoot/../out"
if (Test-Path env:out) {
    $out = $env:out
}
if (!(Test-Path $out)) {
    New-Item -ItemType Directory -Path $out | Out-Null
}

$copperflame = "$PsScriptRoot/.."
if (Test-Path env:copperflame) {
    $copperflame = $env:copperflame
}

pushd $PsScriptRoot

Get-ChildItem *.bib | % { Copy-Item $_.FullName $out }

foreach ($mode in (@("dark", "light")))
{
    pandoc --to=beamer beamer.md -o "${out}/beamer-${mode}.tex" --template="${copperflame}/pandoc/copperflame-${mode}.tex" --highlight-style="${copperflame}/pandoc/copperflame-${mode}.theme" --biblatex --filter "$filterPath"
    pandoc --to=beamer beamer.md -o "${out}/beamer-professional-${mode}.tex" --metadata=professional:true --template="${copperflame}/pandoc/copperflame-${mode}.tex" --highlight-style="${copperflame}/pandoc/copperflame-${mode}.theme" --biblatex --filter "$filterPath"
}

pushd $out
    if (Get-Command tectonic -ErrorAction SilentlyContinue) {
        Get-ChildItem *.tex | % {
            tectonic $_.Name
            if ($LastExitCode -ne 0) {
                exit $LastExitCode
            }
        }
    } else {
        latexmk -xelatex @(Get-ChildItem *.tex | % { $_.Name })
        if ($LastExitCode -ne 0) {
            exit $LastExitCode
        }
    }
popd

popd
