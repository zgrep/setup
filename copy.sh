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
	# Prepares the copy command. For symlinks, replace 'cp' with 'ln -s'.
	# For linux... uh... try flip-flopping the order? Stuff's weird.
	c = "cp '$a' '$b'";
	# Hey, I wanna see what it's doing! And then I wanna do it!
	echo "$c"; $c;
done;
