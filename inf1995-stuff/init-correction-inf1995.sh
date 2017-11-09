#!/bin/bash
correction_file=Correction_TP8.txt
script_pwd=$(dirname $0)
tp_date="2017-10-31 13:15"

# Do a find command to note all *.o *.hex etc files
names="-name '*.o' \
-o -name '*.a' \
-o -name '*.d' \
-o -name '*.hex' \
-o -name '*.out' \
-o -name '*.out.map'"
# Note: the eval here is important, it doesn't work without it.
eval find . $names | tee fichiers_indesirables.lst

# Maybe checout the last commit made before the due date
# Look atgit checkout $(git rev-list -n 1 --before="2009-07-27 13:37" master)
# From Stack overflow https://stackoverflow.com/questions/6990484/git-checkout-by-date
rev=$(git rev-list -n 1 --before="$tp_date" master)
if [[ "$rev" == "" ]] ; then
	git checkout -b TP8_NOT_FOUND
else
	git branch correction_tp8 $rev
	git checkout correction_tp8
fi

# Drop a correction file in the right place
team=$(basename $PWD | sed 's/.*inf1995-\([0-9]*\)$/\1/')
$script_pwd/gen-inf1995-correction-file.sh --correcter "Philippe Carphin" --team \
	$team --section 01 --tp "TP8 Organisation de projet" > $correction_file

echo "
======================= Présence de gitignore(s) ===============================
" >> $correction_file
gitignores=$( find . -name .gitignore )
if [[ $gitignores == "" ]] ; then
	echo "Aucun gitignore trouvé :("
else
	for f in $gitignores
	do
		echo "$f"
		while read l ; do
			echo -n "   │"
			echo "$l"
		done <$f
	done
fi >> $correction_file

echo "
====================== Fichiers Indésirables ===================================
" >> $correction_file 
cat fichiers_indesirables.lst  >> $correction_file

