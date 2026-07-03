#!/bin/bash
# Gera Resources/AppIcon.icns a partir de uma imagem quadrada (PNG, JPG, etc).
# Uso:
#   ./Resources/make_icon.sh /caminho/para/imagem.png
set -euo pipefail

SRC="${1:?Uso: ./Resources/make_icon.sh /caminho/para/imagem.png}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ICONSET="$ROOT_DIR/Resources/AppIcon.iconset"
OUT="$ROOT_DIR/Resources/AppIcon.icns"

if [ ! -f "$SRC" ]; then
    echo "Erro: arquivo não encontrado: $SRC" >&2
    exit 1
fi

echo "==> Gerando os tamanhos de ícone a partir de: $SRC"
rm -rf "$ICONSET"
mkdir -p "$ICONSET"

for size in 16 32 128 256 512; do
    sips -z "$size" "$size" "$SRC" --out "$ICONSET/icon_${size}x${size}.png" >/dev/null
    double=$((size * 2))
    sips -z "$double" "$double" "$SRC" --out "$ICONSET/icon_${size}x${size}@2x.png" >/dev/null
done

echo "==> Empacotando em .icns..."
iconutil -c icns "$ICONSET" -o "$OUT"
rm -rf "$ICONSET"

echo "==> Pronto! Ícone gerado em: $OUT"
echo "    Agora rode ./build.sh de novo para gerar o app com o novo ícone."
