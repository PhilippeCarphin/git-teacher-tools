test-cloner:
	./git-cloner --repo-file inf1995_repo_4.txt --prefix TP8 --command ./init-correction-inf1995.sh

test-filter:
	./inf1995-team-filter.sh < equipes_4.txt


