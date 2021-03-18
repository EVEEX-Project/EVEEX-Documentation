#!/bin/bash

pandoc -s rapport\ d\'avancement.md \
		--mathjax \
		--standalone \
		--toc \
		--pdf-engine=xelatex \
		--template ./eisvogel.tex \
		--listings \
		--number-sections \
    -o rapport.pdf
