#!/bin/bash
# Compila o firmware de volta atras (Marlin 2.0.x) com o eixo Z corrigido.
# So gera arquivos: nao grava nada na impressora nem no cartao.
R="$HOME/Projects/sapphire-pro-firmware"
OUT="$HOME/Projects/MKS Robin Nano V1.2/firmware-compilado/voltar-ao-atual"
export PATH="$HOME/.local/bin:$HOME/.platformio/penv/bin:$PATH"
export PLATFORMIO_DISABLE_PROGRESSBAR=true
echo "Compilando Marlin-atual, ramo $(git -C "$R/Marlin-atual" branch --show-current)..."
cd "$R/Marlin-atual" || exit 1
if ! pio run -e mks_robin_nano35 > "$R/build-atual.log" 2>&1; then
  echo "A COMPILACAO FALHOU. Nada foi copiado."
  grep -E "error|overflowed" "$R/build-atual.log" | cut -c1-160 | head -10
  exit 1
fi
grep -E "^(RAM|Flash):" "$R/build-atual.log"
cp .pio/build/mks_robin_nano35/Robin_nano35.bin "$OUT/" && echo "PRONTO: $OUT/Robin_nano35.bin"
