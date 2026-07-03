#!/bin/bash
# Compila o Notas Rápidas e empacota como um app nativo do macOS (.app).
# Requer as Xcode Command Line Tools (xcode-select --install).
set -euo pipefail

APP_NAME="NotasRapidas"
DISPLAY_NAME="Notas Rápidas"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_BUNDLE="$DIST_DIR/$DISPLAY_NAME.app"

echo "==> Compilando em modo release..."
swift build -c release --package-path "$ROOT_DIR"

BINARY_PATH="$ROOT_DIR/.build/release/$APP_NAME"
if [ ! -f "$BINARY_PATH" ]; then
    echo "Erro: binário não encontrado em $BINARY_PATH" >&2
    exit 1
fi

echo "==> Montando o pacote .app..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$BINARY_PATH" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
cp "$ROOT_DIR/Resources/Info.plist" "$APP_BUNDLE/Contents/Info.plist"

if [ -f "$ROOT_DIR/Resources/AppIcon.icns" ]; then
    cp "$ROOT_DIR/Resources/AppIcon.icns" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
    echo "==> Ícone personalizado incluído."
fi

echo "==> Assinando (ad-hoc)..."
codesign --force --deep --sign - "$APP_BUNDLE"

echo "==> Pronto! App gerado em: $APP_BUNDLE"
echo "    Para instalar, arraste-o para /Applications:"
echo "    mv \"$APP_BUNDLE\" /Applications/"
