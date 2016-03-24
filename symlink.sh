#!/usr/bin/env bash

f=`ls -a | grep -vE '^(symlink\.sh|\.|\.\.|\.gitignore|.*\.md)$'`

for a in $f; do
	b=`sed '1q' "$a"`; b="${b#* }"; b="${b//\~/$HOME}"
	a=`pwd`/"$a"
	rm "$b"; ln -s "$a" "$b"
done