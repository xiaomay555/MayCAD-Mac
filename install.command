#!/usr/bin/env bash
set -euo pipefail
MAYCAD_USER_ROOT="${MAYCAD_USER_ROOT:-$HOME}"
MAYCAD_SOURCE="$(cd "$(dirname "$0")" && pwd)"
MAYCAD_PARENT="$MAYCAD_USER_ROOT/Library/Application Support"
MAYCAD_TARGET="$MAYCAD_PARENT/MayCAD"
MAYCAD_STAMP="$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$MAYCAD_PARENT"
MAYCAD_STAGE="$(mktemp -d "$MAYCAD_PARENT/.MayCAD-install.XXXXXX")"
trap 'if [ -d "$MAYCAD_STAGE" ]; then rm -rf "$MAYCAD_STAGE"; fi' EXIT
while IFS= read -r MAYCAD_FILE; do
  [ -z "$MAYCAD_FILE" ] && continue
  case "$MAYCAD_FILE" in /*|*..*) echo 'Invalid package entry.' >&2; exit 1;; esac
  [ -f "$MAYCAD_SOURCE/$MAYCAD_FILE" ] || { echo "Missing: $MAYCAD_FILE" >&2; exit 1; }
  mkdir -p "$(dirname "$MAYCAD_STAGE/$MAYCAD_FILE")"
  cp "$MAYCAD_SOURCE/$MAYCAD_FILE" "$MAYCAD_STAGE/$MAYCAD_FILE"
done < "$MAYCAD_SOURCE/FILES.txt"
chmod +x "$MAYCAD_STAGE/install.command" "$MAYCAD_STAGE/uninstall.command"
if [ "${MAYCAD_SKIP_BUILD:-0}" != 1 ] && command -v xcrun >/dev/null 2>&1 && xcrun --find swiftc >/dev/null 2>&1; then
  mkdir -p "$MAYCAD_STAGE/QP-Render.app/Contents/MacOS"
  if xcrun swiftc -O "$MAYCAD_SOURCE/qp-render.swift" -o "$MAYCAD_STAGE/QP-Render.app/Contents/MacOS/QP-Render"; then
    cp "$MAYCAD_SOURCE/helper-info.plist" "$MAYCAD_STAGE/QP-Render.app/Contents/Info.plist"
    echo 'JPG helper built locally.'
  else
    rm -rf "$MAYCAD_STAGE/QP-Render.app"
    echo 'JPG helper could not be built. PDF commands remain available.'
  fi
else
  echo 'Swift compiler unavailable or build skipped: PDF works; JPG needs a later helper build.'
fi
if [ -d "$MAYCAD_TARGET" ]; then
  mv "$MAYCAD_TARGET" "$MAYCAD_TARGET.backup-$MAYCAD_STAMP"
  echo 'Previous plugin version backed up. User layer preferences are stored separately.'
fi
mv "$MAYCAD_STAGE" "$MAYCAD_TARGET"
MAYCAD_STARTUPS="$MAYCAD_TARGET/installed-startups.txt"
: > "$MAYCAD_STARTUPS"
MAYCAD_LINKED=0
for MAYCAD_SUPPORT in "$MAYCAD_USER_ROOT"/Library/Application\ Support/Autodesk/AutoCAD\ 2026/R*/roaming/*/Support; do
  [ -d "$MAYCAD_SUPPORT" ] || continue
  MAYCAD_DOC="$MAYCAD_SUPPORT/acaddoc.lsp"
  if [ -f "$MAYCAD_DOC" ] && file "$MAYCAD_DOC" | grep -qi 'UTF-16'; then
    echo 'An existing UTF-16 startup file was left unchanged; use APPLOAD for that profile.'
    continue
  fi
  if [ -f "$MAYCAD_DOC" ] && grep -Fq '; MAYCAD-MANAGED-STARTUP-BEGIN' "$MAYCAD_DOC"; then
    printf '%s\n' "$MAYCAD_DOC" >> "$MAYCAD_STARTUPS"
    MAYCAD_LINKED=$((MAYCAD_LINKED+1))
    continue
  fi
  if [ -f "$MAYCAD_DOC" ]; then cp "$MAYCAD_DOC" "$MAYCAD_DOC.before-maycad-$MAYCAD_STAMP"; fi
  printf '\n' >> "$MAYCAD_DOC"
  cat "$MAYCAD_TARGET/startup-snippet.lsp" >> "$MAYCAD_DOC"
  printf '%s\n' "$MAYCAD_DOC" >> "$MAYCAD_STARTUPS"
  MAYCAD_LINKED=$((MAYCAD_LINKED+1))
done
printf 'MayCAD installed. Startup profiles linked: %s\n' "$MAYCAD_LINKED"
echo 'Restart AutoCAD, open a blank drawing, then type MAYINFO.'
echo 'If another acaddoc.lsp takes precedence, use APPLOAD to load the installed maycad.lsp.'
echo 'No drawing, PGP alias, personal template, font or CTB was overwritten.'
