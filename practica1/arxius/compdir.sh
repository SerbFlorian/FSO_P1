#!/bin/bash

#Condicional per a que no pugui afegir un número diferent a 2 directoris.
if [ $# -ne 2 ]; then
        echo "Has de afegir 2 directoris">&2
	exit
fi

dir1=$1
dir2=$2
#Condicional per a comprovar que són 2 directoris i no un tipus diferent.
if [ -d $dir1 ] && [ -d $dir2 ]; then
	total=0

	#Total de arxius dins d'un directori.
	num1=$(find $dir1 -maxdepth 1 -type f | wc -l)
	num2=$(find $dir2 -maxdepth 1 -type f | wc -l)
	#Ruta del primer arxiu.
	arx1=$(find $dir1 -maxdepth 1 -type f | sort | head -n 1 | tail -n 1)
	arx2=$(find $dir2 -maxdepth 1 -type f | sort | head -n 1 | tail -n 1)
	#Guardem la ruta absoluta del primer arxiu.
	data1=$(readlink -e $arx1)
	data2=$(readlink -e $arx2)
	#Comparem els dos primers arxius.
	percen=$(./compfitxer.sh $arx1 $arx2 2>>error.txt)
	#Anem guardant tots els percentatges dels arxius dins de total.
	total=$(echo "$total+$percen" | bc)

	# Condicional per a veure si els dos directoris tenen 0 arxius.
	if [ $num1 -eq 0 ] && [ $num2 -eq 0 ]; then
		#En el cas de no tenir cap arxiu, els directoris son exactament iguals.
		final=100
	else
		#Condicional per a veure si el primer directori te menys arxius que el segon
		if [ $num1 -le $num2 ]; then

			#Bucle per a anar comparant arxiu per arxiu.
			#Sols tindrem en compte el número de arxius del directori amb menys arxius.
			for (( i=2; i<=$num1; i++ ))
			do
				#Anem agafant arxius
				arx1=$(find $dir1 -maxdepth 1 -type f | sort | head -n $i | tail -n 1)
				arx2=$(find $dir2 -maxdepth 1 -type f | sort | head -n $i | tail -n 1)
				data1=$(./mesactual.sh $arx1 $data1 2>>error.txt)
				percen=$(./compfitxer.sh $arx1 $arx2 2>>error.txt)
				total=$(echo "$total+$percen" | bc)
			done
			#El percentatge de similitud hem de tenir en compte el directori amb més arxius.
			final=$(echo "scale=2; $total/$num2" | bc)
			#Tenim en compte les dates de modificació dels arxius que no s'han analitzat
			arx2=$(find $dir2 -maxdepth 1 -type f | sort | head -n 1 | tail -n 1)
			data2=$arx2
			#Bucle per a veure les dates dels arxius no comparats.
			for (( i=2; i<=$num2; i++ ))
			do
				arx2=$(find $dir2 -maxdepth 1 -type f | sort | head -n $i | tail -n 1)
				data2=$(./mesactual.sh $arx2 $data2 2>>error.txt)
			done
			#Guardem les dates al fitxer recents.log
			echo "$data1" >> recents.log
	                echo "$data2" >> recents.log
		#Si el segon directori te menys arxius que el primer
		else
			#Bucle per a anar comparant arxiu per arxiu
			for (( i=2; i<=$num2; i++ ))
	                do
	                        arx1=$(find $dir1 -maxdepth 1 -type f | sort | head -n $i | tail -n 1)
	                        arx2=$(find $dir2 -maxdepth 1 -type f | sort | head -n $i | tail -n 1)
	                        data1=$(./mesactual.sh $arx1 $data1 2>>error.txt)
	                        percen=$(./compfitxer.sh $arx1 $arx2 2>>error.txt)
	                        total=$(echo "$total+$percen" | bc)
	                done

			#Per a saber el percentatge s'ha de dividir pel numero maxim de arxius entre els dos directoris
			final=$(echo "scale=2; $total/$num1" | bc)
			#Tenim en compte les dates de modificacions dels arxius no analitzats
			arx1=$(find $dir1 -maxdepth 1 -type f | sort | head -n 1 | tail -n 1)
	                data1=$arx1
			#Bucle per a anar veent els arxius que no hem analitzat.
	                for (( i=2; i<=$num1; i++ ))
	                do
	                        arx1=$(find $dir1 -maxdepth 1 -type f | sort | head -n $i | tail -n 1)
	                        data1=$(./mesactual.sh $arx1 $data1 2>> error.txt)
	                done
			#Guardem les rutes absolutes a recents.log.
			echo "$data1" >> recents.log
	                echo "$data2" >> recents.log
		fi
	fi
	#Mostrem el resultat final per sortida estàndard.
	echo "$final"
else
	echo "Han de ser 2 directoris. No pot ser cap tipus diferent o el directori ha de existir">&2
        exit
fi
