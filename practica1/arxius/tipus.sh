#!/bin/bash

if [ $# -ne 1 ]; then
        echo "Has de afegir 1 fitxer">&2
	exit
fi


fit=$1

if [ -f $fit ]; then
	exit 1
elif [ -d $fit ]; then
	exit 2
else
	exit 3
fi
