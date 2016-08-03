#!/usr/bin/env bash

# Get all files.
f=`ls -ap | grep -vE '\.md$|/$|^copy\.sh$|^\.gitignore$'`;

# For each file:
for a in $f; do
	# Get first or second line
	b=`sed '1q' "$a"`;
	if [[ "$b" == '#!'* ]]; then
		b=`sed '2q;d' "$a"`;
	fi;
	# Get all text after the first space, replace ~ with $HOME
	b="${b#* }"; b="${b//\~/$HOME}";
	# Get full path to it.
	a=`pwd`/"$a";
	# Remove if it exists.
	if [[ -e "$b" ]]; then rm "$b"; fi;
	# See what we're doing.
	echo "cp $a $b";
	# Do it.
	cp "$a" "$b";
done;
