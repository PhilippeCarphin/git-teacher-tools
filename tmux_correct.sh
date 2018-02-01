################################################################################
# Ce script crée une fenêtre tmux (comme un onglet dans les autres programmes)
# pour chaque sous-dossier du fichier du dossier courant.
# tmux doit déjà être lancé.
################################################################################
for d in $(ls .); do
	if [ -d $d ] ; then
		echo ./$d;
		tmux new-window -c $PWD/$d
	fi
done
