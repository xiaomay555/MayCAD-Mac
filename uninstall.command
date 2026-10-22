#!/usr/bin/env bash
set -euo pipefail
MAYCAD_USER_ROOT="${MAYCAD_USER_ROOT:-$HOME}"
MAYCAD_TARGET="$MAYCAD_USER_ROOT/Library/Application Support/MayCAD"
[ -d "$MAYCAD_TARGET" ] || { echo 'MayCAD is not installed.'; exit 0; }
MAYCAD_STAMP="$(date +%Y%m%d-%H%M%S)-$$"
MAYCAD_WORK="$(mktemp -d "${TMPDIR:-$MAYCAD_USER_ROOT/Library/Caches}/maycad-uninstall.XXXXXX")"
trap 'rm -rf "$MAYCAD_WORK"' EXIT
if [ -f "$MAYCAD_TARGET/installed-startups.txt" ]; then
  while IFS= read -r MAYCAD_DOC; do
    [ -f "$MAYCAD_DOC" ] || continue
    awk '/^; MAYCAD-MANAGED-STARTUP-BEGIN$/{p=1} p{print} /^; MAYCAD-MANAGED-STARTUP-END$/{p=0}' "$MAYCAD_DOC" > "$MAYCAD_WORK/block"
    if cmp -s "$MAYCAD_WORK/block" "$MAYCAD_TARGET/startup-snippet.lsp"; then
      cp "$MAYCAD_DOC" "$MAYCAD_DOC.before-maycad-uninstall-$MAYCAD_STAMP"
      awk '/^; MAYCAD-MANAGED-STARTUP-BEGIN$/{p=1;next} /^; MAYCAD-MANAGED-STARTUP-END$/{p=0;next} !p{print}' "$MAYCAD_DOC" > "$MAYCAD_WORK/startup"
      cat "$MAYCAD_WORK/startup" > "$MAYCAD_DOC"
    else
      echo 'A modified or missing startup block was preserved. Remove it manually if needed.'
    fi
  done < "$MAYCAD_TARGET/installed-startups.txt"
fi
mv "$MAYCAD_TARGET" "$MAYCAD_TARGET.uninstalled-$MAYCAD_STAMP"
echo 'Plugin disabled and moved to a recoverable backup. Restart AutoCAD.'
echo 'User mappings, personal standards, drawings and cache were preserved.'
