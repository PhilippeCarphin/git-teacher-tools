#!/bin/bash

team_re='[0-9]*'
prefix_re='[^0-9]*'
postfix_re=$prefix_re

teams=$(grep -v "[\t ]*#.*" | sed "s/$prefix_re\($team_re\)$postfix_re/\1/" | sort | uniq)

for t in $teams ; do
	echo "https://githost.gi.polymtl.ca/git/inf1995-$t $t"
done

