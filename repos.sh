#!/bin/bash

function usage(){
    echo "REPOS

USAGE :

  $0 <command> <options>

DESCRIPTION:

	Utility for managing a list of repositories.  The repos are in a file
	like

		# prefix <my_prefix>
		https://githost.gi.polymtl.ca/git/inf1995-1041 1041
		https://githost.gi.polymtl.ca/git/inf1995-1225 1225

	where the first line specifies a directory to put the repos into.

	Then the first word of each line is a repo URL and the second word is a
	target directory.

	The repos clone command will do, for each repo in the file

		git clone \$URL \$prefix/\$target_dir

	The repos do command will cd into each of the \$prefix/\$target_dir and
	execute the command that it receives as an argument.

OPTIONS:

	--repo-file : the file containing a list of repos to clone.  If this option
		is not specified, $0 will look for a file named repo-file.txt

	--command : we can run a command inside each repository as we clone.  This
		is only valid if doing

				$0 clone

		command otherwise, to run multiple commands, put them into a script and do

				$0 do ./my_script.sh

	--skip-if-existing true/false : Skip doing the command for repos that had
		already been cloned.  This option is only for repos clone.

	--just-print : for experimenting with modifications of this script, print
		instead of run certain commands

NOTE:

	The script will add the PWD that it is called from so that your custom
	scripts will be findable despite PWD changing during execution.

	Therefore, custom scripts that will be called should be in your PWD when you
	call repos, or they should be somewhere else in your PATH.
		" >&2
}


################################################################################
# This function suggests to the user that they use a credential helper with git
# so that they don't have to enter their credentials for every repo in their
# list.
################################################################################
function suggest_credential_helper(){
	creds=$(git config credential.helper)
	if [[ $creds == "" ]] ; then
    echo -n "hint : Running a line like $(tput setaf 3)this$(tput sgr 0)

    $(tput setab 8)git config credential.helper 'cache --timeout=3600'$(tput sgr 0)

will keep you from having to enter your $(tput setaf 5)password$(tput sgr 0) all the time.
" >&2
    echo -n "Do it ? [y/n] " >&2
    read answer
    if [[ "$answer" != n ]] ; then
        git config credential.helper 'cache --timeout=3600'
        if [[ $? == 0 ]] ; then
            echo "success setting git credential helper" >&2
        else
            echo "error while doing git config credential.helper 'cache --timeout=3600" >&2
        fi
    fi
	fi
}

################################################################################
# If the prefix directory does not exist, ask the user if they want to create it
# or not.  Exit if they say no.
################################################################################
function check_prefix() {
    local prefix=$1
    if [ ! -e $prefix ] ; then
        echo -n "directory $prefix does not exist, do you want to create it?  [y/n] : " >&2
        while read ans ; do
            if [[ $ans == y ]] ; then
                cmd="mkdir -p $prefix"
                if [[ "$just_print" == true ]] ; then
                    echo $cmd
                else
                    $cmd
                fi
                break
            elif [[ $ans == n ]] ; then
                exit 0
                break
            fi
            echo -n "directory $prefix does not exist, do you want to create it? [y/n] : " >&2
        done
    fi
}

################################################################################
# Parse options:
################################################################################
sub_command=$1
shift
case $sub_command in
	clone)
		echo "Clone option parsing" >&2
		;;
	do)
		command="$1"
		shift
		;;
	help|--help)
		usage
		exit 0
		;;
	*)
		echo "$0 ERROR : Unknown repo subcommand $sub_command" >&2
		exit 1
		;;
esac

while [[ $# -gt 0 ]]
do
    option="$1"
    optarg="$2"
    case $option in
        --repo-file)
            repo_file="$optarg"
            shift
            ;;
        --command) # Make this only for cloning, so that maybe a command can be
		           # done while cloning : repos clone --command 'do somethin'
				   # This would not make sense for repos do
			if [[ $sub_command == do ]] ; then
				echo "$0 ERROR : --command option only valid for repos clone" >&2
				exit 1
			fi
            command="$optarg"
            shift
            ;;
		--submodule)
			if [[ $sub_command != clone ]] ; then
				echo "ERROR"
				exit 1
			fi
			submodule=true
			;;
        --just-print) # Both
            just_print=true
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "unknown option: $option"
            usage
            exit 1
            ;;
    esac
shift
done

################################################################################
# Check some of the options
################################################################################
if [[ "$repo_file" == "" ]] ; then
    if [[ -e repo-file.txt ]] ; then
        repo_file=./repo-file.txt
    else
        echo "$0 ERROR : no repo-file specified and no default repo-file.txt found."
        usage
        exit 1
    fi
elif [ ! -e "$repo_file" ] ; then
    echo "$0 ERROR : File $repo_file doesn't exit" >&2
    usage
    exit 1
fi

if [[ "$command" == "" ]] && [[ "$sub_command" == do ]] ; then
	echo "$0 ERROR : A command must be specified with sub_command do"
	exit 1
fi

suggest_credential_helper

read a b c <$repo_file
if [[ "$a" == '#' ]] && [[ "$b" == prefix ]] ; then
	prefix=$c
else
	echo "$0 : ERROR : repo-file $repo_file must contain '# prefix <directory>' as the first line" >&2
	exit 1
fi

check_prefix $prefix

if [[ "$submodule" == true ]] ; then
	pushd $prefix 2>/dev/null
	git init
	popd 2>/dev/null
fi
################################################################################
# For each line do our thing
################################################################################
popd 2>/dev/null
while read repo target_dir extra; do # < $repo_file
    # Ignore lines starting with '#'
    if [[ "$repo" = \#* ]] || [[ "$repo" == "" ]] ; then
        continue
    fi

    # Parse target dir ########################################################
    if [[ "$target_dir" == "" ]] ; then
        target_dir=$(basename $repo)
    fi
    if [[ "$prefix" != "" ]] ; then
        target_dir="${prefix}/${target_dir}"
    fi

	case $sub_command in
		clone)
			# Do the cloning ##########################################################
			if [[ "$submodule" == true ]] ; then
				echo "$(tput setab 2)Adding ${repo} as submodule$(tput sgr 0)" >&2
				git submodule add ${repo} ${target_dir}
			else
				echo "$(tput setab 2)Cloning ${repo} into ${target_dir}$(tput sgr 0)" >&2
				cmd="git clone ${repo} ${target_dir}"
				if [[ "$just_print" == true ]] ; then
					echo "$cmd"
				else
					$cmd
				fi
			fi
			;;
		do)
			# Run command inside repo ##################################################
			if [[ "$command" != "" ]] ; then
				echo "$(tput setab 3)Entering directory $target_dir to do $absolute_command$(tput sgr 0)" >&2
				if [[ "$just_print" == true ]] ; then
					echo "pushd $target_dir"
					echo "$command"
					echo "popd"
				else
					if pushd $target_dir >/dev/null 2>&1 ; then
						eval $command
						popd 1>/dev/null
						echo "$(tput setab 3)Leaving directory $target_dir$(tput sgr 0)" >&2
					else
						echo "Could not enter directory $target_dir" >&2
					fi
				fi
			fi
			echo "" >&2
			;;
	esac
done < $repo_file
