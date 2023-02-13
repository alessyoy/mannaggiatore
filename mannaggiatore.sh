#!/bin/bash

LISTA_SANTI=$(curl -v --silent https://www.santodelgiorno.it/ 2>&1 | grep -o "\/san[a-z\/-]*" | sed -e 's/\///g' -e 's/-/ /g' -e 's/novena//g' -e "s/sant /sant\'/g" -e 's/\b\(.\)/\u\1/g' -e 's/ E / e /g' | egrep -vi "^santo$" | egrep -vi "^santod[a-zA-Z].{1,8}" | egrep -vi "^santuario$" | sort --unique)

OUTFILE=/tmp/filesanto

for i in $LISTA_SANTI
do
    echo -n $i "" | sed -e 's/San/\nSan/g' -e "s/Dell /Dell\'/g" -e 's/Gesu/Gesù/g' >> $OUTFILE
done

OUTPUT=$(shuf -n 1 $OUTFILE)
echo "Mannaggia a" $OUTPUT
> $OUTFILE
