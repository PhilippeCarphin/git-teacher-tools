#!/bin/bash
script_pwd=$(dirname $0)

# Do a find command to note all *.o *.hex etc files
find . -name '*.o' -o -name '*.a' -o -name '*.d' -o -name '*.hex' -o -name '*.out' -o -name '*.out.map' | tee fichiers_indesirables.lst

# Maybe checout the last commit made before the due date

# Create a branch,
git checkout -b correction_tp8

# Drop a correction file in the right place
team=$(basename $PWD | sed 's/.*inf1995-\([0-9]*\)$/\1/')
$script_pwd/gen-inf1995-correction-file --correcter "Philippe Carphin" --team \
	$team --section 01 --tp "TP8 Organisation de projet" > "Correction_TP8.txt"

