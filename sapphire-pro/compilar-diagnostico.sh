#!/bin/bash
# Compila a versao de diagnostico do Wi-Fi. Gera arquivos nesta pasta e, se o cartao
# estiver no computador, copia o firmware para ele e desmonta o cartao.
# A gravacao so acontece depois, ao ligar a impressora com o cartao.
R="$HOME/Projects/sapphire-pro-firmware"
OUT="$HOME/Projects/MKS Robin Nano V1.2/firmware-compilado/diagnostico"
export PATH="$HOME/.local/bin:$HOME/.platformio/penv/bin:$PATH"
export PLATFORMIO_DISABLE_PROGRESSBAR=true
echo "Compilando o ramo $(git -C "$R/Marlin-wifi" branch --show-current)..."
cd "$R/Marlin-wifi" || exit 1
if ! pio run -e mks_robin_nano_v1v2 > "$R/build-diag.log" 2>&1; then
  echo "A COMPILACAO FALHOU. Nada foi copiado."
  grep -E "error|overflowed" "$R/build-diag.log" | cut -c1-160 | head -10
  exit 1
fi
grep -E "^(RAM|Flash):" "$R/build-diag.log"
mkdir -p "$OUT" && cp .pio/build/mks_robin_nano_v1v2/Robin_nano35.bin "$OUT/" || exit 1
# Procura o cartao: um unico volume FAT montado em /run/media, vindo de um leitor USB.
achar_cartao() {
  local src tgt pk tran
  while read -r src tgt; do
    case "$tgt" in /run/media/"$USER"/*) ;; *) continue ;; esac
    pk=$(lsblk -no PKNAME "$src" 2>/dev/null | head -1)
    tran=$(lsblk -dno TRAN "/dev/${pk:-${src#/dev/}}" 2>/dev/null)
    [ "$tran" = "usb" ] && printf '%s\t%b\n' "$src" "$tgt"
  done < <(findmnt -rn -t vfat -o SOURCE,TARGET)
}
mapfile -t CARTOES < <(achar_cartao)
if [ "${#CARTOES[@]}" -eq 1 ]; then
  DEV="${CARTOES[0]%%$'\t'*}"; SD="${CARTOES[0]#*$'\t'}"
  echo "Cartao em $SD. Conteudo antes da copia:"; ls -1 "$SD"
  cp "$OUT/Robin_nano35.bin" "$SD/" && sync && udisksctl unmount -b "$DEV" && echo "CARTAO PRONTO: pode retirar."
else
  echo "CARTAO NAO ENCONTRADO (${#CARTOES[@]} volumes FAT em leitor USB). O firmware ficou em: $OUT"
fi
