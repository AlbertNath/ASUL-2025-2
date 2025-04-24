ARCHIVO_LLAVES="processed.txt"

# Procesar el archivo y guardar las llaves en authorized_keys
awk -v RS='--------------------BEGIN HOST--------------------|--------------------END HOST--------------------' '
    $0 ~ /ssh-(rsa|ed25519)/ {
        # Extraer el user@host del final de la línea
        if (match($0, /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$/)) {
            user_host = substr($0, RSTART, RLENGTH);
            split(user_host, arr, "@");
            usuario = arr[1];
            llave_ssh = substr($0, 1, RSTART - 1);

            # Ruta del archivo authorized_keys del usuario
            home_dir = "/home/" usuario;
            auth_file = home_dir "/.ssh/authorized_keys";

            # Crear directorio .ssh si no existe
            system("mkdir -p " home_dir "/.ssh && chmod 700 " home_dir "/.ssh");

            # Agregar la llave al archivo
            print llave_ssh " " user_host >> auth_file;

            # Asegurar permisos correctos
            system("chmod 600 " auth_file);
            system("chown " usuario ":" usuario " " auth_file);
        }
    }
' "$ARCHIVO_LLAVES"

echo "Llaves guardadas en los archivos authorized_keys de cada usuario."