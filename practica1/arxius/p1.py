#!/usr/bin/env python3
import os
import subprocess
import sys
from subprocess import Popen, PIPE
import pathlib


#UN PERCENTATGE DE SIMILITUD PER LA SORTIDA ESTANDARD
arx1= input("Introdueix el primer directori: ")
arx2= input("Introdueix el segon directori: ")

tot=subprocess.run(["./compdir.sh {x} {y}".format(x=arx1, y=arx2)],capture_output=True, text=True,shell=True)

percen=tot.stdout

percen=percen.strip('\n')

fin=float(percen)

print(fin)

#LA RUTA ABSOLUTA DELS FITXERS AMB DADA DE MODIFICACIO MES NOVA PER UN FITXER.log
tot=subprocess.run(["./mesactual.sh {x} {y}".format(x=arx1,y=arx2)],capture_output=True, text=True, shell=True)

percen=tot.stdout

percen=percen.strip('\n')

import contextlib

with open("fitxer.log","w") as o:
   o.write(percen)
