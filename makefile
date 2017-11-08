file=$(1995_dir)/inf1995_repo_4.txt
prefix=$(1995_dir)/repos
command=$(1995_dir)/init-correction-inf1995.sh
1995_dir=./inf1995-stuff
bad_command=afwerwert bonjour allo
GC=./git-cloner.sh

all:
	@echo "this makefile is only used for executing test commands"
	@exit 1
test: test-prefix-in-repo-file

test-cloner:
	$(GC) --repo-file $(file) --prefix $(prefix) --command $(command)

test-prefix-in-repo-file:
	$(GC) --repo-file $(1995_dir)/inf1995_teams.txt --command $(command)
test-filter:
	./inf1995-stuff/inf1995-team-filter.sh < ./inf1995-stuff/equipes_4.txt

test-suggest-cred:
	git config credential.helper ""
	$(GC) --repo-file $(file) --prefix $(prefix)

test-bad-command:
	# MAKE: Should fail ...
	$(GC) --repo-file $(file) --prefix $(prefix) --command "$(bad_command)"

clean:
	# Hard coding to avoid mistakes
	rm -rf ./$(1995_dir)/repos


