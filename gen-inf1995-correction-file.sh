#!/bin/bash
################################################################################
# Script for automatic generation of correction file with the right values
# inserted in place of predefined markers in the file.
#
# The script outputs to stdout for clients to decide to redirect output to the
# file of their choice
################################################################################

text="Polytechnique Montréal

Département de génie informatique et génie logiciel

INF1995: Projet initial en ingénierie informatique
         et travail en équipe

Grille de correction des programmes:

Identification:
  Travail Pratique # : __TRAVAIL_PRATIQUE__
  Section #  : __SECTION__
  Équipe #   : __TEAM_NUMBER__
  Correcteur : __CORRECTEUR__


Lisibilité:(/5)
  En-têtes en début de programme et de fonctions   (1 point) :
  Identificateurs significatifs (variables, etc.)  (1 point) :
  Commentaires aux endroits stratégiques           (1 point) :
  Indentation et facilité de lecture               (1 point) :
  Broches, ressources matérielles bien identifiées (1 point) :

Modularité et comprehension: (/5)
  Les fonctions sont assez courtes, bien
        établies et avec de bons paramètres        (1 point) :
  Le code reflète une bonne compréhension
        des concepts de base                       (2 points):
  Le code montre que la solution proposée
        permet de bien résoudre le problème        (2 points):

Fonctionnalité:(/10)
  Soumission réussie sous GIT (bon endroit,
        sans fichiers inutiles)                    (3 points):
  Compilation sans \"warnings\" et sans erreurs      (2 point) :
  Fonctionnement correct (évalué en \"boite noire\") (5 points):


Total:


Commentaires du correcteur:


"

text_tp8="Polytechnique Montréal

Département de génie informatique et génie logiciel

INF1995: Projet initial en ingénierie informatique
         et travail en équipe

Grille de correction des programmes:

Identification:
  Travail Pratique # : __TRAVAIL_PRATIQUE__
  Section #  : __SECTION__
  Équipe #   : __TEAM_NUMBER__
  Correcteur : __CORRECTEUR__

Code
– La qualités et le choix de vos portions de code choisies
                                               ( 5 points sur 20 )
– La qualités de vos modifications aux Makefiles
                                               ( 5 points sur 20 )

Le rapport ( 7 points sur 20 )
– Explications cohérentes par rapport au code retenu pour former la librairie
                                                        (2 points)

– Explications cohérentes par rapport aux Makefiles modifiés
                                                        (2 points)
– Explications claires avec un bon niveau de détails
                                                        (2 points)
– Bon français                                           (1 point)

– Bonne soumission de l'ensemble du code (compilation sans
  erreurs, …) et du rapport selon le format demandé
                                               ( 3 points sur 20 )

Total:


COmmentaires du correcteur:

"

################################################################################
# Option parsing with error checking
################################################################################
tp=-1
team=-1
correcter=Nemo
section=-1
while [[ $# -gt 0 ]]
do
    option="$1"
	optarg="$2"
    case $option in
        --tp)
			tp="$optarg"
			shift
			;;
        --team)
			team="$optarg"
			shift
			;;
        --correcter)
			correcter="$optarg"
			shift
			;;
        --section)
			section="$optarg"
			shift
			;;
        *)
            echo "$0 : ERROR : unknown option: $option" >& 2
            exit 1
			;;
    esac
shift
done

if [[ $tp == -1 ]] ; then
	echo "$0 : ERROR : Tp number must be specified" >& 2
	exit 1
fi
if [[ $team == -1 ]] ; then
	echo "$0 : ERROR : Team number must be specified" >& 2
	exit 1
fi
if [[ "$correcter" == Nemo ]] ; then
	echo "$0 : ERROR : Correcter name must be specified" >& 2
	exit 1
fi
if [[ $section == -1 ]] ; then
	echo "$0 : ERROR : section number must be specified" >& 2
	exit 1
fi

################################################################################
# Use sed to replace pre-defined markers with the values given to the script and
# output to stdout
################################################################################
echo "$text_tp8" |
	sed "s/__TEAM_NUMBER__/$team/g" |
	sed "s/__SECTION__/$section/g" |
	sed "s/__TRAVAIL_PRATIQUE__/$tp/g" |
	sed "s/__CORRECTEUR__/$correcter/g"
