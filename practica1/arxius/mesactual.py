#!/usr/bin/env python3

import os
import time
#demano els fitxers a l'usuari
arx1= input("Introdueix el primer arxiu: ")
arx2= input("Introdueix el segon arxiu: ")
#miro el temps de la ultima modificacio
actual1 = os.path.getmtime(arx1)
actual2 = os.path.getmtime(arx2)
#comparo quin sa modificat anteriorment + mostro el path absolut
if actual1 > actual2:
   print(os.path.abspath(arx1))
else:
   print(os.path.abspath(arx2))
