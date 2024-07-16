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
	tot=0
	#Numero de directoris total
	numdir1=$(ls -F $dir1 | grep / | wc -l)
	numdir2=$(ls -F $dir2 | grep / | wc -l)
	#Numero total de arxius nomes en el directori actual
	numarx1=$(find $dir1 -maxdepth 1 -type f | wc -l)
	numarx2=$(find $dir2 -maxdepth 1 -type f | wc -l)
	#Numero total de arxius, contant tambe els subarxius
	numarxtot1=$(find $dir1 -type f | wc -l)
	numarxtot2=$(find $dir2 -type f | wc -l)
	#Condicional per si els dos directoris no tenen subdirectoris
	if [ $numdir1 -eq 0 ] && [ $numdir2 -eq 0 ]; then
		final=$(./compdir.sh $dir1 $dir2 2>>error.txt)
	#Si no es compleix significa que minim 1 dels 2 directoris te subdirectoris
	else
		#Si els primer directori no te cap subdirectori
		if [ $numdir1 -eq 0 ]; then
			#Si el numero de arxius total (tenin en compte tambe els subdirectoris) es mes petit o igual que el numero d'arxius del primer directori
			if [ $numarxtot2 -le $numarx1 ]; then
				final=$(./compdir.sh $dir1 $dir2 2>>error.txt)
			#Si el numero d'arxius del directori 1 es mes petit que que el total de arxius del segon
			else
				percen=$(./compdir.sh $dir1 $dir2 2>>error.txt)
				total=$(echo "scale = 2; $percen*$numarx1" | bc)
				final=$(echo "$total/$numarxtot2" | bc)
			fi
			#Bucle per a comparar les dates dels arxius del subdirectori
			for (( i=2; i<=$numdir2+1; i++ ))
			do
				subdir2=$(find $dir2 -maxdepth 1 -type d | sort | head -n $i | tail -n 1)
				numsubarx2=$(find $subdir2 -maxdepth 1 -type f | wc -l)
				subarx2=$(find $subdir2 -maxdepth 1 -type f | sort | head -n 1 | tail -n 1)
	                        data2=$(readlink -e $subarx2)
				for (( j=2; j<=$numsubarx2; j++ ))
				do
					subarx2=$(find $subdir2 -maxdepth 1 -type f | sort | head -n $j | tail -n 1)
					data2=$(./mesactual.sh $subarx2 $data2 2>>error.txt)
				done
				echo "$data2" >> recents.log
			done
		#Si els segon directori no te cap subdirectori i el primer si
		elif [ $numdir2 -eq 0 ]; then
			#Si el numero de arxius total del directori 1 es mes petit que el directori 1
			if [ $numarxtot1 -le $numarx2 ]; then
	                        final=$(./compdir.sh $dir1 $dir2 2>>error.txt)
			#Si el numero de arxius del directori 1 es mes petit que el total de arxius del directori 2
	                else
	                        percen=$(./compdir.sh $dir1 $dir2 2>>error.txt)
				total=$(echo "scale = 2; $percen*$numarx2" | bc)
	                        final=$(echo "$total/$numarxtot1" | bc)
	                fi
			#Bucle per a comparar les dates dels arxius del subdirectori
			for (( i=2; i<=$numdir1+1; i++ ))
	                do
	                        subdir1=$(find $dir1 -maxdepth 1 -type d | sort | head -n $i | tail -n 1)
	                        numsubarx1=$(find $subdir1 -maxdepth 1 -type f | wc -l)
	                        subarx1=$(find $subdir1 -maxdepth 1 -type f | sort | head -n 1 | tail -n 1)
	                        data1=$(readlink -e $subarx1)
	                        for (( j=2; j<=$numsubarx1; j++ ))
	                        do
	                                subarx1=$(find $subdir1 -maxdepth 1 -type f | sort | head -n $j | tail -n 1)
	                                data1=$(./mesactual.sh $subarx1 $data1 2>>error.txt)
	                        done
	                        echo "$data1" >> recents.log
			done
		#Si els dos directoris tenen com a minim 1 sudirectori
		else
			#Primer comparem unicament els arxius del directori pare
			if [ $numarx1 -le $numarx2 ]; then
				percen1=$(./compdir.sh $dir1 $dir2 2>>error.txt)
				total1=$(echo "scale = 2; $percen1*$numarx2" | bc)
			else
				percen1=$(./compdir.sh $dir1 $dir2 2>>error.txt)
	                        total1=$(echo "scale = 2; $percen1*$numarx1" | bc)
			fi
			#Comencem a analitzar els subdirectoris
			subdir1=$(find $dir1 -maxdepth 1 -type d | sort | head -n 2 | tail -n 1)
			subdir2=$(find $dir2 -maxdepth 1 -type d | sort | head -n 2 | tail -n 1)
			numsubarx1=$(find $subdir1 -maxdepth 1 -type f | wc -l)
			numsubarx2=$(find $subdir2 -maxdepth 1 -type f | wc -l)
			#Comparem els subarxius
			if [ $numsubarx1 -le $numsubarx2 ]; then
	                	percen2=$(./compdir.sh $subdir1 $subdir2 2>>error.txt)
	                	total2=$(echo "scale = 2; $percen2*$numsubarx2" | bc)
	                else
	                	percen2=$(./compdir.sh $subdir1 $subdir2 2>>error.txt)
	                	total2=$(echo "scale = 2; $percen2*$numsubarx1" | bc)
	                fi
			totalfinal=$(echo "$total1+$total2" | bc)
        		#El total que tenim el dividim per el total maxim de arxius contan els del subdirectori
			#El directori que tingui mes, llavors utilitzarem el seu valor per a la divisio
        	        if [ $numarxtot1 -le $numarxtot2 ]; then
        	        	final1=$(echo "scale = 2; $totalfinal/$numarxtot2" | bc)
		        else
        	        	final1=$(echo "scale = 2; $totalfinal/$numarxtot1" | bc)
	      	        fi
        	        tot=$(echo "$tot+$final1" | bc)
			#Aquesta condicio seria per si tenim un numero de subdirectoris diferent
			if [ $numdir1 -le $numdir2 ]; then
				for (( i=3; i<=$numdir1+1; i++ ))
				do
					subdir1=$(find $dir1 -maxdepth 1 -type d | sort | head -n $i | tail -n 1)
					subdir2=$(find $dir2 -maxdepth 1 -type d | sort | head -n $i | tail -n 1)
					numsubarx1=$(find $subdir1 -maxdepth 1 -type f | wc -l)
					numsubarx2=$(find $subdir2 -maxdepth 1 -type f | wc -l)
					if [ $numsubarx1 -le $numsubarx2 ]; then
						percen2=$(./compdir.sh $subdir1 $subdir2 2>>error.txt)
                        			total2=$(echo "scale = 2; $percen2*$numsubarx2" | bc)
					else
						percen2=$(./compdir.sh $subdir1 $subdir2 2>>error.txt)
	                    			total2=$(echo "scale = 2; $percen2*$numsubarx1" | bc)
					fi
					totalfinal=$(echo "$total1+$total2" | bc)
					if [ $numarxtot1 -le $numarxtot2 ]; then
						final1=$(echo "scale = 2; $totalfinal/$numarxtot2" | bc)
					else
						final1=$(echo "scale = 2; $totalfinal/$numarxtot1" | bc)
					fi
					tot=$(echo "$tot+$final1" | bc)
				done
				final=$(echo "scale=2; $tot/$numdir2" | bc)
				#Bucle per a comparar les dates del subarxiu no comparat
				for (( i=$numdir1+1; i<=$numdir2+1; i++ ))
				do
					subdir2=$(find $dir2 -maxdepth 1 -type d | sort | head -n $i | tail -n 1)
					numsubarx2=$(find $subdir2 -maxdepth 1 -type f | wc -l)
					subarx2=$(find $subdir2 -maxdepth 1 -type f | sort | head -n 1 | tail -n 1)
					data2=$(readlink -e $subarx2)
					for (( j=2; j<=$numsubarx2; j++ ))
					do
						subarx2=$(find $subdir2 -maxdepth 1 -type f | sort | head -n $j | tail -n 1)
                	        		data2=$(./mesactual.sh $subarx2 $data2 2>>error.txt)
					done
					echo "$data2" >> recents.log
				done
			else
				for (( i=3; i<=$numdir2+1; i++ ))
                	        do
                	                subdir1=$(find $dir1 -maxdepth 1 -type d | sort | head -n $i | tail -n 1)
                	                subdir2=$(find $dir2 -maxdepth 1 -type d | sort | head -n $i | tail -n 1)
                	                numsubarx1=$(find $subdir1 -maxdepth 1 -type f | wc -l)
                	                numsubarx2=$(find $subdir2 -maxdepth 1 -type f | wc -l)
                	                if [ $numsubarx1 -le $numsubarx2 ]; then
                	                        percen2=$(./compdir.sh $subdir1 $subdir2 2>>error.txt)
                	                        total2=$(echo "scale = 2; $percen2*$numsubarx2" | bc)
                                	else
                                        	percen2=$(./compdir.sh $subdir1 $subdir2 2>>error.txt)
                                   		total2=$(echo "scale = 2; $percen2*$numsubarx1" | bc)
	                                fi
	                                totalfinal=$(echo "$total1+$total2" | bc)
					if [ $numarxtot1 -le $numarxtot2 ]; then
	                                        final1=$(echo "scale = 2; $totalfinal/$numarxtot2" | bc)
	                                else
	                                        final1=$(echo "scale = 2; $totalfinal/$numarxtot1" | bc)
	                                fi
					tot=$(echo "$tot+$final1" | bc)
	                        done
				final=$(echo "scale=2; $tot/$numdir1" | bc)
				for (( i=$numdir2+1; i<=$numdir1+1; i++ ))
	                        do
	                                subdir1=$(find $dir1 -maxdepth 1 -type d | sort | head -n $i | tail -n 1)
	                                numsubarx1=$(find $subdir1 -maxdepth 1 -type f | wc -l)
	                                subarx1=$(find $subdir1 -maxdepth 1 -type f | sort | head -n 1 | tail -n)
	                                data1=$(readlink -e $subarx1)
	                                for (( j=2; j<=$numsubarx1; j++ ))
	                                do
	                                        subarx1=$(find $subdir1 -maxdepth 1 -type f | sort | head -n $j | t)
	                                        data1=$(./mesactual.sh $subarx1 $data1 2>>error.txt)
	                                done
	                                echo "$data1" >> recents.log
	                        done
			fi
		fi
	fi
	echo "$final"
else
	echo "Han de ser 2 directoris. No pot ser cap tipus diferent o el directori ha de existir">&2
        exit
fi
