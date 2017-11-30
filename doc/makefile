-*- encoding: utf-8 -*-

OBJET := tmp-1.png tmp-2.png tmp-3.png tmp-4.png tmp-5.png tmp-6.png tmp-7.png tmp-8.png tmp-9.png tmp-10.png tmp-11.png tmp-12.png

visu: equ-time.png
	display equ-time.png

equ-time.png: equ-time.pdf
	convert -crop '700x300+100+100' -background white -alpha deactivate equ-time.pdf equ-time.png

equ-time.pdf: equ-time.tex
	lualatex equ-time.tex

equ-time.tex: equ-time.pl
	perl equ-time.pl -plot

visu1: pseudo-analemma.gif
	display pseudo-analemma.gif

pseudo-analemma.gif: pseudo-analemma.pdf
	convert -crop '500x300+100+100' -background white -alpha deactivate pseudo-analemma.pdf tmp.png
	convert -delay 100 -dispose background $(OBJET) pseudo-analemma.gif

pseudo-analemma.pdf: pseudo-analemma.lua pseudo-analemma.tex
	lualatex pseudo-analemma.tex
