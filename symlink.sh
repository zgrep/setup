#!/usr/bin/env bash

f=`ls -a | grep -vE '^(symlink\.sh|\.|\.\.|\.gitignore|\.git|.*\.md)$'`

for a in $f; do
	b=`sed '1q' "$a"`; b="${b#* }"; b="${b//\~/$HOME}"
	a=`pwd`/"$a"
	echo "$b -> $a"
	rm "$b"; ln -s "$a" "$b"
done