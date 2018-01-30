README

repos.sh
========

Utilitaire simple pour cloner une liste d'etrepôts git et exécuter une commande dans chaque entrepôt.

Ex : la commande

	./repos.sh [clone | do <command>]

clone : Clone tous les entrepôts listés dans le fichier repo-file.txt

do : Rentre dans chaque entrepot et exécute la commande <command>.  La commande
doit être un seul argument pour la commande repos.sh, donc pour empêcher le
shell de briser notre commande en plusieurs mots, il faut faire:

	$ ./repos.sh do 'git push origin correction_tp8'

faire

	$ ./repos.sh --help

pour la liste complète des options.

repo-file
---------

un fichier dont chaque ligne est le URL d'un entrepôt git et optionnellement un nom à donner à l'entrepôt clôné (séparé par un espace).

Ex :

	# prefix sous-dossier
	https://githost.gi.polymtl.ca/git/inf1995-1041 1041
	https://githost.gi.polymtl.ca/git/inf1995-1225 1225

Faire

	$ ./repos.sh clone

fera l'équivalent de

	$ git clone https://githost.gi.polymtl.ca/git/inf1995-1041 sous-dossier/1041

Exemple d'utilisation pour le cours INF1995:
============================================

init-correction-inf1995
-----------------------

Exemple de script qui peut être comme commande à git-cloner.sh:
- faire un checkout du dernier commit avant une date
- sauver une liste de tous les fichiers indésirables présents dans l'entrepôt fraîchement clôné (*.o *.a etc).
- créer et faire un checkout d'une branche
- générer un fichier avec une grille de correction

NOTE: Si on veut exécuter un script personnel, puisque repos.sh change de
dossier (PWD) pendant son exécution, faire 

	$ repos.sh do ./mon-script.sh

ne fonctionnera pas.

Pour cette raison, le script repos.sh ajoute automatiquement le PWD au PATH
durant son exécution. Ainsi, il faut faire

	$ repos.sh do mon-script.sh

et si mon-script.sh prend des options, il faut les grouper avec la commande en
utilisant des guillements.

	$ repos.sh do 'mon-script.sh --opt_mon_script abc'

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

Si on copy paste la page sur le site du cours dans un fichier texte,
ceci va permettre de générer automatiquement un "repo-file" pour repos.sh.

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
