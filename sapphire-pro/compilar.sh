#!/bin/bash
# Compila os dois firmwares da Sapphire Pro. So gera arquivos dentro desta pasta:
# nao grava nada na impressora nem no cartao SD.
R="$HOME/Projects/sapphire-pro-firmware"
export PATH="$HOME/.local/bin:$HOME/.platformio/penv/bin:$PATH"
export PLATFORMIO_DISABLE_PROGRESSBAR=true
echo "Compilando Marlin-wifi (pode levar varios minutos na primeira vez)..."
cd "$R/Marlin-wifi" && pio run -e mks_robin_nano_v1v2 > "$R/build-wifi.log" 2>&1
echo "Marlin-wifi: codigo de saida $?"
echo "Compilando Marlin-atual..."
cd "$R/Marlin-atual" && pio run -e mks_robin_nano35 > "$R/build-atual.log" 2>&1
echo "Marlin-atual: codigo de saida $?"
