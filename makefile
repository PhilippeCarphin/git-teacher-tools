test-cloner:
	./git-cloner --repo-file inf1995-stuff/inf1995_repo_4.txt --prefix TP8 --command ./inf1995-stuff/init-correction-inf1995.sh

test-filter:
	./inf1995-stuff/inf1995-team-filter.sh < ./inf1995-stuff/equipes_4.txt


