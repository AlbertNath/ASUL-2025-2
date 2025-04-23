#!/bin/bash

# nombre="Alberto Natanael Medel Piña"
cleaned_names=$(uniq $1 | tr " " "\n" | tr -d "," | tail -n +2)

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
                  # p1=$(echo "$normalized" | awk '{print substr($1, 1, 1)}')
                  # p2=$(echo "$normalized" | awk '{print substr($2, 1, 1)}')
                  # p3=$(echo "$normalized" | awk '{print $(NF-1)}')
                  # p4=$(echo "$normalized" | awk '{print substr($NF, 1, 1)}')
                  # printf "%s%s%s%s\n" "$p1" "$p2" "$p3" "$p4"
                  echo "$normalized"
}

function create_passwd {
                  mkpasswd.pl -l 10 -c 3 -C 3 -s2 -n2
                  # /usr/bin/mkpasswd-expect -l 10 -c 3 -C 3 -s 2
}

echo "Creating Debian group"
sudo addgroup debian

for name in $cleaned_names; do
                  echo "$name"
                  username=$(build_username "$name")
                  password=$(create_passwd)

                  useradd -m "$username" -G debian

                  echo "$username:$password" | sudo chpasswd

                  echo "User $username created with password: $password"
done
