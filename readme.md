README

git-cloner
==========

Utilitaire simple pour cloner une liste d'etrepôts git et exécuter une commande dans chaque entrepôt.

Ex : la commande

	./git-cloner --repo-file <repo_file> [--command <cmd>]

Clone tous les entrepôts listés dans le fichier <repo_file>.  Faire ./git-cloner --help pour plus d'options.

Exemple d'utilisation pour le cours INF1995:
============================================

init-correction-inf1995
-----------------------

Exemple de script qui peut être comme commande à git-cloner:
- faire un checkout du dernier commit avant une date
- sauver une liste de tous les fichiers indésirables présents dans l'entrepôt fraîchement clôné (*.o *.a etc).
- créer et faire un checkout d'une branche
- générer un fichier avec une grille de correction

utiliser l'option --command ./inf1995-stuff/init-correction-inf1995.sh avec  git-cloner pour définir cette commande comme la commande à exécuter dans chaque entrepôt.

Noter que si la commande est un path relatif comme ici, git-cloner va transformer le premier mot de la commande en path absolu pour éviter que le changement de PWD lorsque le script entre dans les dossiers clônés ne cause problème.

Autres gogosses pour INF1995
============================

get-inf1995-correction-file
---------------------------

Output un fichier de correction paramétré sur stdout:

    get-inf1995-correction-file --correcter phil 
	                            --team team 
	                            --section section 
	                            --tp tp

inf1995-team-filter.sh
----------------------

Si tu copy paste la page sur le site du cours dans un fichier texte,
ceci va te permettre de générer automatiquement un "repo-file" pour git-cloner.

	inf1995-team-filter.sh < equipes_4.txt > repo_file.txt

Transforme

	ESlkouch	   LSilz	1041
	Gnzgz	   xogbédz GSorgSs	1041
	JutSzu	   GodSfroy	1041
	Phzn	   Mzrcus	1041
	LzrochS	   GSnSviSvS	1225
	M'hirsi	   MSriSm	1225
	Siczud	   JzcquSs	1225
	Stimphzt	   EmmznuSllz	1225

en
	
	https://githost.gi.polymtl.ca/git/inf1995-1041 1041
	https://githost.gi.polymtl.ca/git/inf1995-1225 1225