all: ../out/beamer.tex ../out/beamer.pdf

clean:
	rm -rf ../out

../out:
	mkdir ../out

../out/beamer.pdf: beamer.md ../pandoc/copperflame.tex ../pandoc/copperflame.theme ../out
	pandoc --to=beamer beamer.md  -o ../out/beamer.pdf --template ../pandoc/copperflame.tex --highlight-style ../pandoc/copperflame.theme --pdf-engine tectonic --filter pandoc-filter-bibtex

../out/beamer.tex: beamer.md ../pandoc/copperflame.tex ../pandoc/copperflame.theme ../out
	pandoc --to=beamer beamer.md  -o ../out/beamer.tex --template ../pandoc/copperflame.tex --highlight-style ../pandoc/copperflame.theme --pdf-engine tectonic --filter pandoc-filter-bibtex
