#!/usr/bin/env bash
#
# KIOKU Linux installer
#
# Downloads the latest AppImage, installs it to ~/.local/bin, and adds a
# desktop entry so it shows up in your application menu.
#
#   curl -fsSL https://raw.githubusercontent.com/ItsAshn/Kioku/main/scripts/install-linux.sh | bash
#
set -euo pipefail

REPO="ItsAshn/Kioku"
APP_NAME="KIOKU"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
DEST="$BIN_DIR/${APP_NAME}.AppImage"

echo "==> Installing $APP_NAME for Linux"

echo "==> Fetching latest release metadata"
api="https://api.github.com/repos/${REPO}/releases/latest"
urls="$(curl -fsSL "$api" \
  | grep -o '"browser_download_url": *"[^"]*"' \
  | sed 's/.*"browser_download_url": *"\([^"]*\)".*/\1/')"

url="$(printf '%s\n' "$urls" | grep -iE '\.AppImage$' | head -n1 || true)"
if [ -z "${url:-}" ]; then
  echo "!! Could not find an .AppImage asset in the latest release." >&2
  echo "   Download manually from https://github.com/${REPO}/releases" >&2
  exit 1
fi
echo "==> Found: $url"

mkdir -p "$BIN_DIR" "$DESKTOP_DIR"

echo "==> Downloading to $DEST"
curl -fL# "$url" -o "$DEST"
chmod +x "$DEST"

echo "==> Creating desktop entry"
cat > "$DESKTOP_DIR/kioku.desktop" <<EOF
[Desktop Entry]
Name=$APP_NAME
Comment=Application time tracker — know where your hours go
Exec=$DEST
Terminal=false
Type=Application
Categories=Utility;Office;
StartupWMClass=$APP_NAME
EOF

echo ""
echo "✓ $APP_NAME installed to $DEST"
echo ""
echo "  Launch it from your application menu, or run:  $DEST"
echo ""
case ":$PATH:" in
  *":$BIN_DIR:"*) : ;;
  *) echo "  Note: $BIN_DIR is not on your PATH — add it to run 'KIOKU.AppImage' directly." ;;
esac
echo "  AppImages require FUSE. If it fails to start, install 'libfuse2'"
echo "  (Debian/Ubuntu: sudo apt install libfuse2), or run with --appimage-extract-and-run."
