#!/bin/bash

# 1. Carrega variáveis sensíveis do sistema local
if [ -f .env ]; then
    source .env
else
    echo "FALHA: Arquivo .env não encontrado. Crie com base no .env.example."
    exit 1
fi

# 2. Entra na pasta do Terraform
cd terraform || exit
terraform init

# 3. Loop de provisionamento
while true; do
    echo "Tentando provisionar infraestrutura..."
    OUTPUT=$(terraform apply -auto-approve 2>&1)
    
    if echo "$OUTPUT" | grep -q "Apply complete!"; then
        echo "SUCESSO: Infraestrutura criada!"
        curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
            -d chat_id="${TELEGRAM_CHAT_ID}" \
            -d text="SUCESSO: Seu cluster K3s na Oracle foi provisionado!"
        break
        
    elif echo "$OUTPUT" | grep -q "Out of host capacity"; then
        echo "Sem capacidade na Oracle. Nova tentativa em 10 minutos..."
        sleep 600
    else
        echo "FALHA CRÍTICA no Terraform:"
        echo "$OUTPUT"
        exit 1
    fi
done