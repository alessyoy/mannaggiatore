#!/bin/bash

# Versione 1.1.1 20/02/2023

#######################################################

# Dichiarazione variabili

LINGUA=""
VOICE=""           #Italian+Mario
bold=$(tput bold)
normal=$(tput sgr0)

#######################################################

#Definizione funzioni

usage() { echo -e "${bold}MANNAGGIATORE${normal}\n\n${bold}NAME${normal}\n\tmannaggiatore - manda a cagare i santi per una bestemmia facile\n\n${bold}SYNOPSIS${normal}\n\tmannaggiatore.sh [options] \"some text\"\n\n${bold}DESCRIPTION${normal}\n\tPrende e formatta una lista di santi, ne sceglie uno e ci aggiunge un \"Mannaggia\" davanti\n\n${bold}OPTIONS${normal}\n\t${bold}-h, --help${normal}\n\t\tStampa la pagina di aiuto\n\n\t${bold}-a, --audio${normal}\n\t\tUsa il comando ${bold}spd-say${normal} per leggere la bestemmia con la voce di sistema\n\n\t${bold}-l, --lingua${normal}\n\t\tImposta la lingua (ISO code) usata per leggere la bestemmia\n\n\t${bold}-v, --voce${normal}\n\t\tVoce usata per leggere: si può scegliere tra ${bold}uomo, donna, nonno, nonna e Sandro${normal}\n\n\t${bold}-s, --spegni${normal}\n\t\tLancia un mannaggia e poi spegne il sistema\n" 1>&2 ; exit 1; }

mannaggia() {
    LISTA_SANTI=$(curl -v --silent "https://www.santodelgiorno.it/" 2>&1 | grep -o '/san[a-z/-]*' | sed -e 's/\///g' -e 's/-/ /g' -e 's/novena//g' -e "s/sant /sant\'/g" -e 's/\b\(.\)/\u\1/g' -e 's/ E / e /g' | grep -Evi '^santo$' | grep -Evi '^santod[a-zA-Z].{1,8}' | grep -Evi '^santuario$' | sort --unique)
    OUTFILE=/tmp/filesanto

    for i in $LISTA_SANTI
    do
	echo -n $i "" | sed -e 's/San/\nSan/g' -e "s/Dell /Dell\'/g" -e 's/Gesu/Gesù/g' >> $OUTFILE
    done
    
    OUTPUT=$(shuf -n 1 $OUTFILE)
    while [[ -z ${OUTPUT} ]]
    do
	OUTPUT=$(shuf -n 1 $OUTFILE)
    done
    
    echo ""
    echo "Mannaggia a" $OUTPUT
    echo ""
    > $OUTFILE
}

#######################################################

# Lettura parametri

while getopts ":hsal:v:-:" option; do #i : iniziali servono a silenziare errori che occupano la variabile OPTARG, altrimenti arriva al printf vuota
    if [ "$option" =  "-" ];
    then
	option="${OPTARG%%=*}"
	OPTARG="${OPTARG#$option}"
	OPTARG="${OPTARG#=}"
    fi
    
    case $option in
	h | help )
	    #h di help
	    usage
	    exit 0
	    ;;
	l | lingua)
	    #l di language
	    LINGUA=${OPTARG}
	    ;;
	v | voce)
	    #v di voce
	    case ${OPTARG} in
		uomo)
		    VOICE=Italian+Mario
		    ;;
		Sandro)
		    VOICE=Italian+sandro
		    ;;
		donna)
		    VOICE=Italian+anika
		    ;;
		nonna)
		    VOICE=Italian+grandma
		    ;;
		nonno)
		    VOICE=Italian+grandpa
		    ;;
		*)
		    echo "Le voci disponibili sono: uomo, donna, nonno e nonna"
		    exit 2
		    ;;
	    esac
	    ;;
	s | spegni)
	    #s di shutdown
	    mannaggia
	    echo -e "Shutdown in corso...\n"
	    sleep 1
	    echo -n "Spegnimento tra 3... "
	    sleep 1
	    echo -n "2... "
	    sleep 1
	    echo -n "1... "
	    sleep 1
	    echo -e "Buona giornata!\n"
	    sleep 2
	    systemctl poweroff
	    exit 0
	    ;;
	a | audio)
	    #a di audio
	    mannaggia
	    spd-say "Mannaggia a ${OUTPUT}" --language $LINGUA --synthesis-voice $VOICE
	    exit 0
	    ;;
	*)
	    printf "Illegal option: -%s\n" ${OPTARG} >&2
	    echo "Try -h" >&2
	    exit 1
	    ;;
    esac    
done

mannaggia

shift $((OPTIND-1))

#######################################################

# Condizione finale senza parametri

#if [[ -z ${OPTARG} ]]
#then
#    mannaggia
#    exit 666
#fi
