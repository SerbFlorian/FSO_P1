#!/usr/bin/env python3
import os
import filecmp
import subprocess
import sys
from subprocess import Popen, PIPE
import pathlib

tot = 0
total = 0

#ESTO FUNCIONA CON FICHEROS
#subprocess.Popen("./mesactual.py prova1 prova2", shell=True)

arx1= input("Introdueix el primer directori: ")
arx2= input("Introdueix el segon directori: ")

#NUMERO DE DIRECTORIOS
numdir1 = 0
numdir2 = 0

dir1 = arx1
dir2 = arx2
#NUMERO DE DIRECTORIOS
for path in os.listdir(dir1):
   if os.path.isdir(os.path.join(dir1,path)):
      numdir1 += 1
print("Numero del primer directori:",numdir1)

for path in os.listdir(dir2):
   if os.path.isdir(os.path.join(dir2,path)):
      numdir2 += 1
print("Numero del segon directori:",numdir2)

numarx1 = 0
numarx2 = 0
#NUMERO DE FITXERS EN EL PRIMER DIRECTORI
for path in os.listdir(dir1):
   if os.path.isfile(os.path.join(dir1,path)):
      numarx1 += 1
print("Numero total dels arxius del primer dir:",numarx1)
contador=0
#NUMERO DE FITXERS EN EL SEGON DIRECTORI
for path in os.listdir(dir2):
   if os.path.isfile(os.path.join(dir2,path)):
      numarx2 += 1
print("Numero total dels arxius del segon dir:", numarx2)

numarxtot1 = 0
numarxtot2 = 0
#NUMERO TOTAL DE FITXERS, CONTAN ELS SUBARXIUS
for path, subdirs, files in os.walk(dir1):
   for name in files:
      numarxtot1 += 1
print("Numero total de fitxers de TOT el 1r directori:",numarxtot1)
for path, subdirs, files in os.walk(dir2):
   for name in files:
      numarxtot2 += 1
print("Numero total de fitxer de TOT el 2n directori:",numarxtot2)

if numdir1 == 0 and numdir2 == 0:
   final = subprocess.run(["./compdir.sh {x} {y}".format(x=arx1, y=arx2)],capture_output=True, text=True,shell=True)
   print("NO FUNCIONA")
else:
   if numdir1 == 0:
      if numarxtot2 <= numarxtot1:
         final = subprocess.run(["./compdir.sh {x} {y}".format(x=arx1, y=arx2)],capture_output=True, text=True,shell=True)
         print("MES GRAN QUEL DIR2: ")
      #FINAL IF
      else:
         tot = subprocess.run(["./compdir.sh {x} {y}".format(x=arx1, y=arx2)],capture_output=True, text=True,shell=True)
         fin = tot.stdout
         fin=fin.strip('\n')
         percen=float(fin)
         print("PERCENTATJE CALCULAT(dir1 dir2): ",percen)
         def multiplicar(per,num1): #DEF PER A MULTIPLICAR
            return per*num1
         total = multiplicar(percen,numarx1)
         total = percen * numarx1
         print("CALCUL TOTAL(perc*numarx1):  ",total)
         def dividir(num,div):
            return num/div
         try: #TRY ES PER A DIVIDIR
            final = dividir(total, numarxtot2)
            print("CALCUL FINAL(total/numarxtot2): ",final)
         except ZeroDivisionError:
            print("PERRO NO POTS DIVIDIR PER 0")
      #FINAL ELSE
      i = 2
      #COMPAREM DATES DELS ARXIUS DEL SUBDIRECTORI
      numdir2 = numdir2+1
      while i <= numdir2:
      #for i in range(2, numdir2):
         print("ENTRO AL FORRRRR")
         #me llista tots los subfitxers i fitxers
         def busc_fit(dir2):
            for fitx2 in os.listdir(dir2):
               full_path = os.path.join(dir2,fitx2)
               if os.path.isdir(full_path):
                  busc_fit(full_path)
               else:
#-----------------M'HE QUEDAT EN AQUEST APARTAT --------------------------------------
                  if os.path.isfile(full_path):
                     print("FICHEROS: ",os.path.join(dir,full_path))
                     #filecmp.cmpfiles(os.path.getmtime(full_path))
         busc_fit(dir2)
         #totdir2 = os.path.isfile(dir2)
         #print(totdir2)
         #subdir2 = os.path.getmtime(dir2)
         #numsubarx2 = os.path.getmtime(subdir2)
         #subarx2 = os.path.getmtime(subdir2)
         #data2 = os.path.realpath(subarx2)
         #
         #contingut = os.listdir(dir2)
         #totdir2= os.listdir(dir2)
         #print(totdir2)
         i = i + 1
         j = 2
         while j <= numsubarx2:
         #for j in range(2, numsubarx2):
            subarx2 = os.path.getmtime(subdir2)
            data2 = subprocess.Popen("./mesactual.sh prova1 prova2", shell=True)
            j = j + 1
         print("FITXER MODIFICAT RECENMENT: ",data2)>>recents.log
      #FINAL DEL FOR
   #SI ELS SEGON DIRECTORI NO TE CAP SUBDIRECTORI I EL PRIMER SI
   elif numdir2 == 0:
      if numarxtot1 <=  numarx2:
         #final = subprocess.run(["./compdir.sh {x} {y}".format(x=arx1, y=arx2)],capture_output=True, text=True,shell=True)
         print("hola")
      else:
         #percen = subprocess.run(["./compdir.sh {x} {y}".format(x=arx1, y=arx2)],capture_output=True, text=True,shell=True)
         print("h")
      i = 2
      for i in range(2, numdir1+1):
         subdir1 = os.walk(dir1)
         numsubarx1 = os.walk(subdir1)
         subarx1 = os.walk(subdir1)
         data1 = subarx1
         j = 2
         for j in range(2, numsubarx1):
            subarx1 = os.walk(subdir1)
            #data1 = subprocess.Popen("./mesactual.py prova1 prova2", shell=True)
         #print(data1)>>recents.log
      #FI FOR
   #FI ELIF
   else:
         print("ARRIBO?")
print("HASTA AQUI")



