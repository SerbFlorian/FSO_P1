#!/bin/bash

#Condicional per a que no pugui afegir un número diferent a 2 arxius.
if [ $# -ne 2 ]; then
        echo "Has de afegir 2 arxius">&2
	exit
fi

arx1=$1
arx2=$2
#Condicional per a que els fitxers que no siguin arxius, doni error.
if [ -f $arx1 ] && [ -f $arx2 ]; then
	#Obtenim la data de modificació actual.
	datamodi1=$(stat -c %Y $arx1)
	datamodi2=$(stat -c %Y $arx2)
	#Realitzem les comparacions.
	if [ $datamodi1 -gt $datamodi2 ]; then
		echo "$(readlink -e $arx1)"
	elif [ $datamodi1 -lt $datamodi2 ]; then
		echo "$(readlink -e $arx2)"
	else
		echo "$Data de modificació igual"
	fi
else
	echo "Han de ser 2 arxius. No pot ser cap tipus diferent o no existeix aquest arxiu">&2
        exit
fi
