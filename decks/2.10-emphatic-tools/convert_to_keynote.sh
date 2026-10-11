#!/bin/bash
# Convert the programmatic build into the native Keynote deck + Keynote PDF.
# Run on a Mac with Apple Keynote installed:
#     ./convert_to_keynote.sh
# Produces out/Chapter-2.10-Emphatic-Tools.key and
#          out/Chapter-2.10-Emphatic-Tools.pdf (exported by Keynote).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/out/Chapter-2.10-Emphatic-Tools.pptx"
KEY="$HERE/out/Chapter-2.10-Emphatic-Tools.key"
PDF="$HERE/out/Chapter-2.10-Emphatic-Tools.pdf"

if [ ! -f "$SRC" ]; then
  echo "Building $SRC first…"
  (cd "$HERE" && python3 build_ch2_10.py)
fi

osascript <<OSA
set srcFile to POSIX file "$SRC"
set keyFile to POSIX file "$KEY"
set pdfFile to POSIX file "$PDF"
tell application "Keynote"
    activate
    set theDoc to open srcFile
    delay 3
    save theDoc in keyFile
    export theDoc to pdfFile as PDF with properties {PDF image quality:Best, all stages:false, skipped slides:false}
    close theDoc saving no
end tell
OSA
echo "Saved: $KEY"
echo "Saved: $PDF"
