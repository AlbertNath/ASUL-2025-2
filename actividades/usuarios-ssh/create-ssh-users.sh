#!/bin/bash

# NOTA: este archivo debe correr con el resultado de aplicar
# el siguiente preprocesamiento para el archivo .csv original:
#
# python3 csv-parser.py > preproc0.txt
# ./process-keys.sh preproc0 > processed.txt
#
# ./create-ssh-users.sh processed.txt

if [[ -z "$1" ]]; then
  echo "Se requiere archivo de usuarios"
  exit 1
fi

INPUT_FILE=$1

HOST_NAMES=$(awk 'BEGIN {RS="--------------------BEGIN HOST--------------------"; FS="\n"} {print $4}' "$INPUT_FILE")
USER_NAMES_PER_HOST=$(awk '
  BEGIN {RS="--------------------BEGIN HOST--------------------"; FS="\n"} 
  NR > 1 {
    out = ""
    out = out $4 ":" $5 ":"
    for (i=7; i <= NF; i++) {
      if ($i ~ /^ssh-/){
        break
      }

      if(index($i, ",")){
        out = out $i 
        break
      }
      
      line = $i
      gsub(/^[ \t]+|[ \t]+$/, "", line)
      gsub(/^[0-9]+[.] ?/, "", line)
      if (out ~ /:$/) {
        out = out line
      } else {
      out = out "," line 
      }
      # printf "%s\n", $i
    }
    print out
  }

' "$INPUT_FILE")

# echo "$HOST_NAMES"
# echo
# echo "$USER_NAMES_PER_HOST"

echo -e "Creando tabla de hosts..."

HOST_TABLE=$(awk -F ':' '{printf "%s\t%s\n", $1, $2}' <<<"$USER_NAMES_PER_HOST")
echo "$HOST_TABLE"
