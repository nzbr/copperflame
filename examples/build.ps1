#!/usr/bin/env pwsh

function bibtex-filter-path() {
    if ($IsWindows) {
        "../pandoc/pandoc-filter-bibtex/run.bat"
    } else {
        "../pandoc/pandoc-filter-bibtex/run.sh"
    }
}

pushd $PsScriptRoot

pandoc --to=beamer beamer.md -o ../out/beamer.tex --template=../pandoc/copperflame.tex --highlight-style=../pandoc/copperflame-dark.theme --filter "$(bibtex-filter-path)"
pandoc --to=beamer beamer.md -o ../out/beamer.pdf --template=../pandoc/copperflame.tex --highlight-style=../pandoc/copperflame-dark.theme --filter "$(bibtex-filter-path)" --pdf-engine tectonic

popd
