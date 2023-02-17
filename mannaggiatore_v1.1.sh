#!/bin/bash

# Versione 1.1 17/02/2023 --- versione: Pop_OS

usage() { echo -e "\nBestemmia con stile, un santo diverso ogni volta!\nLancia senza argomenti per mannaggiare un santo a caso\nLancia con -h per stampare a video questo aiuto\nLancia con -s per lanciare una bestemmia e poi spegnere il pc\n" 1>&2 ; }


mannaggia() {
    LISTA_SANTI=$(curl -v --silent "https://www.santodelgiorno.it/" 2>&1 | grep -o '/san[a-z/-]*' | sed -e 's/\///g' -e 's/-/ /g' -e 's/novena//g' -e "s/sant /sant\'/g" -e 's/\b\(.\)/\u\1/g' -e 's/ E / e /g' | grep -Evi '^santo$' | grep -Evi '^santod[a-zA-Z].{1,8}' | grep -Evi '^santuario$' | sort --unique)
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
}
while getopts ":hsb" option; do #i : servono a silenziare errori che occupano la variabile OPTARG, altrimenti arriva al printf vuota
    case $option in
	h)
	    #h di help
	    usage
	    exit 0
	    ;;
	s)
	    #s di shutdown
	    mannaggia
	    echo -e "Shutdown in corso...\n"
	    #systemctl poweroff
	    exit 0
	    ;;
	b)
	    #b di bestemmia
	    mannaggia
	    ;;
	\?)
	    printf "Illegal option: -%s\n" ${OPTARG} >&2
	    echo "Try -h" >&2
	    exit 1
	    ;;
	:)
	    echo ${OPTARG}
	    if [ -z ${OPTARG} ]
	    then
		mannaggia
		exit 666
	    fi
	    ;;
    esac
done
shift $((OPTIND-1))

#echo ${OPTARG}

#if [ -z ${OPTARG} ]
#then
#    mannaggia
#    exit 666
#fi
