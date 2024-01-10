#!/bin/bash

export MANNAGGIAPATH="/root/bin/mannaggiatore/"
export LIMITE=$(wc -l $MANNAGGIAPATH/lista_santi | awk '{print $1}')
export RIGA=$((1 + RANDOM % $LIMITE))
export SANTO=$(head -$RIGA $MANNAGGIAPATH/lista_santi | tail -1)
clear
printf "######################################\n\nMannaggia a San $SANTO \n\n######################################\n\n"
