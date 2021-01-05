pandoc -s "rapport d'avancement.md" \
		-f gfm \
		--mathjax \
		--standalone \
		--toc \
		--pdf-engine=xelatex \
		--from markdown \
		--template eisvogel.tex \
		--listings \
		--number-sections \
		-o rapport.pdf

pdftk garde.pdf rapport.pdf cat output rapport_complet.pdf