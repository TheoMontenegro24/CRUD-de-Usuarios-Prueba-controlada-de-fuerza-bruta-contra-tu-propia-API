#!/bin/bash

API="http://localhost:8000"
echo "=== Probando seguridad del login ==="

# Lista de contraseñas para probar
passwords=(
    "Admin123" "Elianna123" "Ar1ana" "Luis2006" "Sebas_Cal"
    "123456" "password" "admin" "test" "1234"
)

# Correos de la base de datos
emails=("theo@gmail.com" "eliannna@gmail.com" "ariana@gmail.com" "sebas@gmail.com")

echo "Probando ${#emails[@]} usuarios con ${#passwords[@]} contraseñas..."
echo ""

for email in "${emails[@]}"; do
    echo "Atacando: $email"
    
    for pass in "${passwords[@]}"; do
        # Hacer la petición al login
        respuesta=$(curl -s -X POST "$API/login" \
            -H "Content-Type: application/json" \
            -d "{\"correo\":\"$email\", \"password\":\"$pass\"}")
        
        # Verificar si fue exitoso
        if echo "$respuesta" | grep -q "exitoso"; then
            echo "✅ ENCONTRADO: $email - $pass"
        else
            echo "❌ Fallo: $pass"
        fi
    done
    echo "---"
done

echo "=== Prueba terminada ==="
