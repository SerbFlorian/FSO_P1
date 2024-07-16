#!/bin/bash

#Condicional per a que no pugui afegir un número diferent a 2 arxius.
if [ $# -ne 2 ]; then
	echo "Has de afegir 2 arxius">&2
	exit
fi

arx1=$1
arx2=$2
#Condicional per a comprovar que són 2 arxius i no un tipus diferent
if [ -f $arx1 ] && [ -f $arx2 ]; then

	#Contador de línies totals dels arxius.
	lintot1=$(wc -l $arx1 | cut -d" " -f1)
	lintot2=$(wc -l $arx2 | cut -d" " -f1)
	#-l: Sols mostra les línies del fitxer.

	#Conta quantes línies tenen errors el primer fitxer.
	lindifer=$(diff $arx1 $arx2 | grep "<" | wc -l)

	#Calculem les línies que tenen iguals o bé.
	#En el cas de que els documents estan en blanc, significa que els document són 100% iguals.
	#Com després realitzem la multiplicació per 100, llavors percen = 1.
	if [ $lintot1 -eq 0 ] && [ $lintot2 -eq 0 ]; then
		percen=1
	else
		if [ $lintot1 -le $lintot2 ]; then
			let linbe=$lintot2-$lindifer
			percen=$(echo "scale=4; $linbe/$lintot2" | bc)
		else
			let linbe=$lintot1-$lindifer
			percen=$(echo "scale=4; $linbe/$lintot1" | bc)
		fi
	fi
	final=$(echo "$percen*100" | bc)
	echo "$final"

	#mostra les línies diferents i les pasa a error.txt.
	error=$(diff -y -B -E -b -i --suppress-common-lines $arx1 $arx2 | cat -n)
	echo "$error">&2
	#-i: Diferencia entre maysuculas i minusculas de lo ficheros.
	#-E: ignora tabuladores.
	#-B: Ignora la linies en blanco.
	#-b: comparacion omitiendo los espacios en blanco.
	#-y mostrar dos columnas para comparar graficamente.
else
	echo "Han de ser 2 arxius. No pot ser cap tipus diferent o no existeix aquest arxiu">&2
        exit
fi
