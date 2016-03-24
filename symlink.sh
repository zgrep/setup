#!/usr/bin/env bash

# Get all files.
f=`ls -ap | grep -vE '\.md|/$|^symlink\.sh$|^\.gitignore$'`;

for a in $f; do
	b=`sed '1q' "$a"`; b="${b#* }"; b="${b//\~/$HOME}";
	a=`pwd`/"$a";
	echo "$b -> $a";
	if [[ -e "$b" ]]; then rm "$b"; fi;
	ln -s "$a" "$b";
done;