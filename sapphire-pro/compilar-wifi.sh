#!/bin/bash
# Compila so o firmware com Wi-Fi. So gera arquivos dentro desta pasta:
# nao grava nada na impressora nem no cartao SD.
R="$HOME/Projects/sapphire-pro-firmware"
export PATH="$HOME/.local/bin:$HOME/.platformio/penv/bin:$PATH"
export PLATFORMIO_DISABLE_PROGRESSBAR=true
echo "Compilando Marlin-wifi..."
cd "$R/Marlin-wifi" && pio run -e mks_robin_nano_v1v2 > "$R/build-wifi.log" 2>&1
echo "Marlin-wifi: codigo de saida $?"
grep -E "^(RAM|Flash):|overflowed" "$R/build-wifi.log"
