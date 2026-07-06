#!/usr/bin/env bash
#
# KIOKU macOS installer
#
# Downloads the latest release, installs KIOKU.app, and strips the
# quarantine attribute so the unsigned app launches without Gatekeeper
# blocking it. (Files fetched with curl are generally not quarantined in
# the first place; the xattr call below is a belt-and-braces measure.)
#
#   curl -fsSL https://raw.githubusercontent.com/ItsAshn/Kioku/main/scripts/install-macos.sh | bash
#
set -euo pipefail

REPO="ItsAshn/Kioku"
APP_NAME="KIOKU"

echo "==> Installing $APP_NAME for macOS"

# --- Pick the asset matching this machine's architecture ----------------
case "$(uname -m)" in
  arm64) WANT_ARM64=1 ;;   # Apple Silicon
  *)     WANT_ARM64=0 ;;   # Intel (x86_64)
esac

echo "==> Fetching latest release metadata"
api="https://api.github.com/repos/${REPO}/releases/latest"
urls="$(curl -fsSL "$api" \
  | grep -o '"browser_download_url": *"[^"]*"' \
  | sed 's/.*"browser_download_url": *"\([^"]*\)".*/\1/')"

# We install from the .zip (contains KIOKU.app) — easier to script than a .dmg.
zips="$(printf '%s\n' "$urls" | grep -iE '\.zip$' || true)"
if [ "$WANT_ARM64" = "1" ]; then
  url="$(printf '%s\n' "$zips" | grep -i 'arm64' | head -n1 || true)"
else
  url="$(printf '%s\n' "$zips" | grep -iv 'arm64' | head -n1 || true)"
fi

if [ -z "${url:-}" ]; then
  echo "!! Could not find a macOS .zip asset in the latest release." >&2
  echo "   Download manually from https://github.com/${REPO}/releases" >&2
  exit 1
fi
echo "==> Found: $url"

# --- Choose an install directory we can write to -----------------------
if [ -w "/Applications" ]; then
  INSTALL_DIR="/Applications"
else
  INSTALL_DIR="$HOME/Applications"
  mkdir -p "$INSTALL_DIR"
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "==> Downloading"
curl -fL# "$url" -o "$tmp/kioku.zip"

echo "==> Installing to $INSTALL_DIR"
rm -rf "$INSTALL_DIR/$APP_NAME.app"
unzip -q "$tmp/kioku.zip" -d "$INSTALL_DIR"

# --- Bypass Gatekeeper for the unsigned build --------------------------
echo "==> Removing quarantine attribute (Gatekeeper bypass)"
xattr -dr com.apple.quarantine "$INSTALL_DIR/$APP_NAME.app" 2>/dev/null || true

echo ""
echo "✓ $APP_NAME installed to $INSTALL_DIR/$APP_NAME.app"
echo ""
echo "  Launch it now with:  open \"$INSTALL_DIR/$APP_NAME.app\""
echo ""
echo "  On first run, grant Screen Recording permission when prompted"
echo "  (System Settings → Privacy & Security → Screen Recording) so KIOKU"
echo "  can read active window titles, then restart the app."
