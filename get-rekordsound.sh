#!/usr/bin/env bash
# One-line install for macOS. The person pastes this into Terminal:
#
#   curl -fsSL https://raw.githubusercontent.com/Mladen2802/rekordsound_todownload/main/get-rekordsound.sh | bash
#
# curl downloads are not flagged by macOS, so there is no "damaged" / "unidentified developer" warning. The script downloads the
# zip, unpacks it into ~/rekordsound, then installs what is missing and starts the app. Running it again updates the program files
# and keeps the library data (data/) and the installed packages (.venv).
#
# Host get-rekordsound.sh and rekordsound.zip together (a GitHub release, your own server, any file link that downloads directly),
# then set ZIP_URL below to the zip's link, or pass REKORDSOUND_ZIP_URL=... when running.
ZIP_URL="${REKORDSOUND_ZIP_URL:-https://github.com/Mladen2802/rekordsound_todownload/raw/refs/heads/main/rekordsound.zip}"
DEST="${REKORDSOUND_DIR:-$HOME/rekordsound}"

set -e
case "$ZIP_URL" in *REPLACE-WITH*) echo "This installer has no download link yet: set ZIP_URL at the top of get-rekordsound.sh."; exit 1;; esac
[ "$(uname)" = "Darwin" ] || { echo "This installer is for macOS."; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
echo "Downloading rekordsound ..."
curl -fL --progress-bar -o "$tmp/rekordsound.zip" "$ZIP_URL"
mkdir -p "$DEST"
unzip -q -o "$tmp/rekordsound.zip" -d "$DEST"
echo "Unpacked into $DEST"
cd "$DEST"
[ -n "$REKORDSOUND_NO_RUN" ] && { echo "(not starting: REKORDSOUND_NO_RUN is set)"; exit 0; }
exec bash "./Install and Start.command" </dev/tty
