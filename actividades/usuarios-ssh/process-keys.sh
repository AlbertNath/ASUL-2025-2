#!/bin/bash

awk '
  BEGIN { RS="ROW START"; FS="\n" }
  NF > 0 {
    printf "\n--------------------BEGIN HOST--------------------\n" 
    for (i=1; i<=NF; i++) {
      if (length($i) > 0){
       printf  "%s\n", $i
      }
    }
    printf "\n--------------------END HOST--------------------\n" 
  }
' "$1"
