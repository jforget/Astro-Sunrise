-*- encoding: utf-8 -*-

visu: equ-time.png
	display equ-time.png

equ-time.png: equ-time.pdf
	convert -crop '700x300+100+100' -background white -alpha deactivate equ-time.pdf equ-time.png

equ-time.pdf: equ-time.tex
	lualatex equ-time.tex

equ-time.tex: equ-time.pl
	perl equ-time.pl -plot
