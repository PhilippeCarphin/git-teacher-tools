#!/bin/sh
bad_extensions=".o .a .d .hex .out .out.map"

search_string=""
tree_string=""
for ext in $bad_extensions ; do
	search_string="-name '*${ext}'${search_string:+ -o ${search_string}}"
	tree_string="*${ext}${tree_string:+|${tree_string}}"
done

if false ; then
	echo "find_string=$find_string"
	echo "tree_string=$tree_string"
fi

if [[ "$1" == tree ]] ; then
	tree -P "${tree_string}" --prune | tee fichiers_indesirables.lst
else
	eval find . $search_string | tee fichiers_indesirables.lst
fi

