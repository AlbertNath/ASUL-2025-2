#!/bin/bash

# Version modificada para esta actividad
# - ANMP

cleaned_names=$(uniq <<<"$1")

function normalize {
                  echo "$1" | awk '{$0 = tolower($0);
                    gsub(/[áàâãäå]/, "a");
                    gsub(/[éèêë]/, "e");
                    gsub(/[íìîï]/, "i");
                    gsub(/[óòôõö]/, "o");
                    gsub(/[úùûü]/, "u");
                    gsub(/[ç]/, "c");
                    gsub(/[ñ]/, "n");
                    print $0}'
}

function build_username {
                  normalized=$(normalize "$1")
                  echo "$normalized"
}

function create_passwd {
                  mkpasswd.pl -l 10 -c 3 -C 3 -s2 -n2
                  # /usr/bin/mkpasswd-expect -l 10 -c 3 -C 3 -s 2
}

for name in $cleaned_names; do
                  echo "$name"
                  username=$(build_username "$name")
                  password=$(create_passwd)

                  useradd -m "$username"

                  echo "$username:$password" | sudo chpasswd

                  echo "User $username created with password: $password"
done
