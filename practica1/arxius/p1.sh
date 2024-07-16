#!/bin/bash

#Condicional per a que no pugui afegir un número diferent a 3 fitxers.
if [ $# -ne 3 ]; then
        echo "Has de afegir 3 fitxers">&2
        exit
fi

fit1=$1
fit2=$2
dir=$3
#Condicional per a que el els dos primer fitxers siguin arxius i l'ultim un directori
if [ -f $fit1 ] && [ -f $fit2 ] && [ -d $dir ]; then
	./compfitxer.sh $fit1 $fit2 2>>error.txt
	./mesactual.sh $fit1 $fit2 >>recents.log 2>>error.txt
	./creanou.sh $dir 2>>error.txt
#Condicional per a que tres siguin directoris
elif [ -d $fit1 ] && [ -d $fit2 ] && [ -d $dir ]; then
	./comptot.sh $fit1 $fit2 2>>error.txt
	./creanou.sh $dir 2>>error.txt
#Condicional en cas de no cumplir qualsevol dels anteriors
else
	echo "Han de ser 3 directoris o 2 arxius i 1 directori. No pot ser cap tipus diferent o el directoris/arxius han de existir">&2
        exit
fi
