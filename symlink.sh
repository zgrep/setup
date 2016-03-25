#!/usr/bin/env bash

# Get all files.
f=`ls -ap | grep -vE '\.md$|/$|^symlink\.sh$|^\.gitignore$'`;

# For each file:
for a in $f; do
	# Get first line, get all text after the first space, replace ~ with $HOME
	b=`sed '1q' "$a"`; b="${b#* }"; b="${b//\~/$HOME}";
	# Get full path to it.
	a=`pwd`/"$a";
	# Hey, I wanna see what it's doing! :P
	echo "$b -> $a";
	# Remove if it exists.
	if [[ -e "$b" ]]; then rm "$b"; fi;
	# Create symlink. If you want it to copy, modify this line.
	# Goes from $a, the local file, to $b, where we want it to go.
	ln -s "$a" "$b";
done;