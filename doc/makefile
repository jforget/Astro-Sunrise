-*- encoding: utf-8 -*-

OBJETGR := tmp-02.png tmp-03.png tmp-04.png tmp-05.png tmp-06.png tmp-07.png tmp-08.png tmp-09.png tmp-10.png tmp-11.png tmp-12.png tmp-13.png
OBJETPL := tmp-14.png tmp-15.png tmp-16.png tmp-17.png tmp-18.png tmp-19.png tmp-20.png tmp-21.png tmp-22.png tmp-23.png tmp-24.png tmp-25.png

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
	pdftoppm -png -f 2 -l 13 -x 250 -y 220 -W 600 -H 500 pseudo-analemma.pdf tmp
	convert -delay 100 -dispose background $(OBJETGR) pseudo-analemma.gif

visu2: ps-an-pol.gif
	display ps-an-pol.gif

ps-an-pol.gif: pseudo-analemma.pdf
	pdftoppm -png -f 14 -l 25 -x 250 -y 220 -W 600 -H 500 pseudo-analemma.pdf tmp
	convert -delay 100 -dispose background $(OBJETPL) ps-an-pol.gif

pseudo-analemma.pdf: pseudo-analemma.lua pseudo-analemma.tex
	lualatex pseudo-analemma.tex

visu3: sunset-slope.png
	display sunset-slope.png

sunset-slope.png: sunset-slope.pdf
	pdftoppm -png -f 1 -l 1 -x 240 -y 225 -W 500 -H 160 sunset-slope.pdf sunset-slope
	mv sunset-slope-1.png sunset-slope.png

sunset-slope.pdf: sunset-slope.tex
	lualatex sunset-slope.tex

