#!/bin/bash

#Condicional per a que no pugui afegir un número diferent a 1 directoris
if [ $# -ne 1 ]; then
	echo "Has de afegir 1 directori">&2
	exit
fi

#Demanem el directori on volem copiar els arxius de recent.log
dir2=$1
#Crearem la carpeta per si no existeix
#Contador de quantes linies te recents.log
num=$(wc -l recents.log | cut -d" " -f1)

#Bucle per a que vaig copiant de linia en linia el recents.log
for (( i=1; i<=$num; i++ ))
do
	dir1=$(cat recents.log | head -n $i | tail -n 1)
	#Comanda per copiar arxiu amb data de modificació
	rsync -rv --times $dir1 $dir2
done
