#!/usr/bin/env pwsh

function build($template, $destination) {
    Write-Host "Generating $destination"
    npx base16-builder -s copperflame.yaml -t $template > $destination
}

pushd $PsScriptRoot

foreach ($mode in (@("dark", "light")))
{
    build skylighting/${mode}.theme.ejs ../pandoc/copperflame-${mode}.theme
    build latex/${mode}.tex.ejs ../pandoc/copperflame-colors-${mode}.tex
}

build logo/icon.svg.ejs ../assets/icon.svg
build logo/logo.svg.ejs ../assets/logo.svg

popd
