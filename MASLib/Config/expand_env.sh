#!/bin/bash
tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
echo 'cat <<END_OF_TEXT' >  "$tmpfile"
cat "$1"                 >> "$tmpfile"
echo 'END_OF_TEXT'       >> "$tmpfile"
bash "$tmpfile"          > "$2"
cat "$2"
touch "$2"
rm "$tmpfile"
