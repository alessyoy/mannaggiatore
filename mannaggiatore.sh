#!/bin/bash

# Versione 1.0 13/02/2023


usage() { echo "Bestemmia con stile, un santo diverso ogni volta!" 1>&2 ; exit 1; }

while getopts "hs" o; do
    case "${o}" in
	h) usage
	   exit 0
	   ;;
	s) echo "shutdown in corso..."
	   exit 0
	   ;;
	\?) printf "Illegal option: -%s\n" "$OPTARG" >&2
	   echo "Try -h" >&2
	   exit 1
	   ;;
    esac
done

LISTA_SANTI=$(curl -v --silent https://www.santodelgiorno.it/ 2>&1 | grep -o "\/san[a-z\/-]*" | sed -e 's/\///g' -e 's/-/ /g' -e 's/novena//g' -e "s/sant /sant\'/g" -e 's/\b\(.\)/\u\1/g' -e 's/ E / e /g' | egrep -vi "^santo$" | egrep -vi "^santod[a-zA-Z].{1,8}" | egrep -vi "^santuario$" | sort --unique)

OUTFILE=/tmp/filesanto

for i in $LISTA_SANTI
do
    echo -n $i "" | sed -e 's/San/\nSan/g' -e "s/Dell /Dell\'/g" -e 's/Gesu/Gesù/g' >> $OUTFILE
done

OUTPUT=$(shuf -n 1 $OUTFILE)
echo ""
echo "Mannaggia a" $OUTPUT
echo ""
> $OUTFILE
