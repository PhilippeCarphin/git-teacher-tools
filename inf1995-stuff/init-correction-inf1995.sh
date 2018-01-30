#!/bin/bash
################################################################################
# SETUP VARIABLES :
################################################################################
# tp_date : Used for working with deadlines with git.  The script will checkout
# the last commit made before this date.  Leave blank to work with origin/HEAD
# Example format : tp_date="2017-10-31 13:15"
tp_date=""

# tp_name : Used to name certain things like the correction file, and the branch
# that will be created (if any)
tp="code_final"

# bad_extensions : The list of extension
bad_extensions=".o .a .d .hex .out .out.map"

# Correction file elements
# Note team will be determined automatically
correcter="Philippe Carphin"
section=01
tp_name="Code final"

################################################################################
# Calculated variables
################################################################################
correction_file=Correction_$tp.txt
correction_branch=correction_$tp

################################################################################
# Faire un checkout du dernier commit avant $tp_date et créer une branche
################################################################################
# Référence https://stackoverflow.com/questions/6990484/git-checkout-by-date
if [[ "$tp_date" != "" ]] ; then
	rev=$(git rev-list -n 1 --before="$tp_date" master)
	if [[ "$rev" == "" ]] ; then
		git checkout -b __NO_COMMIT_FOUND__
	else
		git branch $correction_branch $rev
		git checkout $correction_branch
	fi
fi

################################################################################
# Création du fichier de correction :
# 1) Générer le fichier de correction avec les infos du correcteur, TP, section
#    et numéro d'équipe
# 2) Ajouter une recherche de gitignore
# 3) Ajouter une liste de fichiers indésirables (si ceci est fait tout de suite
#    après avoir clôné, cette liste ne contiendra que les fichiers indésirables
#    suivis par git.
################################################################################

# 1) Création du fichier de correction #########################################
team=$(basename $PWD | sed 's/.*inf1995-\([0-9]*\)$/\1/')
gen-inf1995-correction-file.sh \
	--correcter "Philippe Carphin" \
	--team $team \
	--section $section \
	--tp "$tp" \
> $correction_file

# 2) Ajout d'info sur les gitignores ###########################################
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
			echo "    │ $l"
		done <$f
		echo "    └─────"
	done
fi >> $correction_file

# 3) Ajout de l'info sur les fichiers indésirables #############################

search_string=""
tree_string=""
for ext in $bad_extensions ; do
	search_string="-name '*${ext}'${search_string:+ -o ${search_string}}"
	tree_string="*${ext}${tree_string:+|${tree_string}}"
done
eval find . $search_string | tee fichiers_indesirables.lst
# tree -P "${tree_string}" --prune | tee fichiers_indesirables.lst

echo "
====================== Fichiers Indésirables ===================================
" >> $correction_file
cat fichiers_indesirables.lst  >> $correction_file

