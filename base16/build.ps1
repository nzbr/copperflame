#!/usr/bin/env pwsh

function build($template, $destination) {
    Write-Host "Generating $destination"
    npx base16-builder -s copperflame.yaml -t $template > $destination
}

pushd $PsScriptRoot

foreach ($mode in (@("dark", "light")))
{
    build skylighting/${mode}.theme.ejs ../pandoc/copperflame-${mode}.theme
    build latex/${mode}.tex.ejs ../pandoc/partials/copperflame-colors-${mode}.tex
}

build logo/icon.svg.ejs ../assets/icon.svg
build logo/logo.svg.ejs ../assets/logo.svg

Write-Host "Converting ../assets/logo.svg to png"
inkscape --export-type=png --export-filename=../assets/logo.png -w 400 -h 72 ../assets/logo.svg

popd
