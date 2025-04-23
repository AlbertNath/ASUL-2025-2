#!/bin/bash

awk '
  BEGIN { RS="ROW START"; FS="\n" }
  NF > 0 {
    printf "\n--------------------BEGIN HOST--------------------\n";
    concatenando_llave = 0;
    llave_completa = "";

    for (i = 1; i <= NF; i++) {
      linea = $i;

      if (length(linea) > 0) {
        # Detecta inicio de llave
        if (linea ~ /^ssh-(rsa|ed25519)/) {
          concatenando_llave = 1;
          llave_completa = linea;

          # ¿Termina en user@host?
          if (linea ~ /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$/) {
            printf "%s\n", llave_completa;
            concatenando_llave = 0;
            llave_completa = "";
          }

        } else if (concatenando_llave == 1) {
          # Continúa parte de la llave
          llave_completa = llave_completa linea;

          # ¿Termina en user@host?
          if (linea ~ /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$/) {
            printf "%s\n", llave_completa;
            concatenando_llave = 0;
            llave_completa = "";
          }

        } else {
          printf "%s\n", linea;
        }
      }
    }
    printf "\n--------------------END HOST--------------------\n" 
  }
' "$1"

# Explicación:
# Lo primero que se ejecuta es la asección indicada por BEGIN:
#    BEGIN { RS="ROW START"; FS="\n" }
#
# RS (Record Separator) hace que awk considere cada bloque de texto separado
# por 'ROW START' como un registro, en lugar de hacerlo línea por línea.
# FS  (Field Separator) indica que cada campo de un resgistro está separado por
# un salto de línea, permitiendo hacer referencia acda campo mediante $1, $2, ...
#
# NF (Number of fields) en este caso lo usamos para revisar solo aquellos
# registros con al menos un campo. 
#
# Luego usamos printf para imprimir una línea que indica el inicio de
# los datos de un host.
#
# El ciclo for itera sobre cada uno de los campos del registro actual y tenemos
# dos casos:
#     * Si el campo es una llave, verificamos si está completa revisando que
#       termine con una estructura <usuario>@<host> si sí la imprimimos pero si
#       no lo que hacemos es concatenar campos hasta completarla.
#     * Si no es una llave solo imprimimos
#
# Finalmente usamos printf para imprimir una línea que indica el fin de
# los datos de un host.
