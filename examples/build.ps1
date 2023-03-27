#!/usr/bin/env pwsh

$bibtexFilterPath = if (Get-Command pandoc-filter-bibtex -ErrorAction SilentlyContinue) {
    "pandoc-filter-bibtex"
} elseif ($IsWindows) {
    "../pandoc/pandoc-filter-bibtex/run.bat"
} else {
    "../pandoc/pandoc-filter-bibtex/run.sh"
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
    pandoc --to=beamer beamer.md -o "${out}/beamer-${mode}.tex" --template="${copperflame}/pandoc/copperflame-${mode}.tex" --highlight-style="${copperflame}/pandoc/copperflame-${mode}.theme" --filter "$bibtexFilterPath"
    pandoc --to=beamer beamer.md -o "${out}/beamer-professional-${mode}.tex" --metadata=professional:true --template="${copperflame}/pandoc/copperflame-${mode}.tex" --highlight-style="${copperflame}/pandoc/copperflame-${mode}.theme" --filter "$bibtexFilterPath"
}

pushd $out
Get-ChildItem *.tex | % {
    if (Get-Command tectonic -ErrorAction SilentlyContinue) {
        tectonic $_.Name
    } else {
        $latex = "xelatex -interaction=nonstopmode $( $_.Name )"
        @(
            $latex,
            "bibtex $_.BaseName",
            $latex,
            $latex
        ) | % {
            Invoke-Expression $_
            if ($LastExitCode -ne 0) {
                exit $LastExitCode
            }
        }
    }
}
popd

popd
