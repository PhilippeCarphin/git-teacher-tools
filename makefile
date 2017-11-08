test-cloner:
	./git-cloner --repo-file inf1995_repo_4.txt --prefix TP8 --command 'echo "$(date)" > clone_date.txt'

test-filter:
	./inf1995-team-filter.sh < equipes_4.txt


