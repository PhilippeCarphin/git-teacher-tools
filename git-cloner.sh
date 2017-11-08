#!/bin/bash

function usage(){
    echo "GIT CLONER

USAGE :

  $0 [--repo-file repos.txt] [--command cmd] [<other-options>]

DESCRIPTION:

        Clones a list of repos from a file with lines of the form

            <repo-url> <target_dir> ...

        repo-url : the URL of a repo

        target_dir : Optionnal, the target directory that will be used for cloning
                   the repo
        Lines beginning with '#' will be ignored.

        If no repo-file is specified, the program looks for repo-file.txt in
        current working directory

        Repofile may contain, as the first line, a line of the form

            # prefix prefix_value

        to specify the sub-directory for cloning.  The option --prefix on the
        command line overrides this.

OPTIONS:

        --repo-file : the file containing a list of repos to clone

        --command : we can run a command inside each repository that we clone

        --skip-if-existing true/false : if true, cmd will not be run on repos
                      were already present.  Default value is true

        --just-print : for experimenting with modifications of this script, print
                   instead of run certain commands
        --prefix : Subdirectory where the repos are to be cloned. Implicitely
                   defaults to pwd.
                " >&2
}


################################################################################
# This function suggests to the user that they use a credential helper with git
# so that they don't have to enter their credentials for every repo in their
# list.
################################################################################
function suggest_credential_helper(){
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
            echo "directory $prefix does not exist, do you want to create it? [y/n] : " >&2
        done
    fi
}

################################################################################
# Makes the path of a command absolute.  This is because the command may be the
# path to a script that is not in PATH.  Since we change directories during this
# script, such a relative path must be converted to an absolute path.
################################################################################
absolutize_cmd(){
    cmd="$(which $1 2>/dev/null)"
    if [[ "$cmd" == "" ]] ; then
        echo ""
        return
    fi
    echo -n "$cmd"
    shift
    if [[ $# -gt 0 ]] ; then
        echo -n " $@"
    fi
}

################################################################################
# Parse options:
################################################################################
skip_if_existing=true
while [[ $# -gt 0 ]]
do
    option="$1"
    optarg="$2"
    case $option in
        --skip-if-existing)
            skip_if_existing="$optarg"
            shift
            ;;
        --repo-file)
            repo_file="$optarg"
            shift
            ;;
        --command)
            command="$optarg"
            shift
            ;;
        --just-print)
            just_print=true
            ;;
        --prefix)
            prefix="$optarg"
            shift
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

if [[ "$command" != "" ]] ; then
    absolute_command=$(absolutize_cmd $command)
    if [[ "$absolute_command" == "" ]] ; then
        echo "$0 ERROR : no command $(echo $command | cut -d ' ' -f 1) in path" >&2
        usage >&2
        exit 1
    fi
fi

creds=$(git config credential.helper)
if [[ $creds == "" ]] ; then
    suggest_credential_helper
fi

if [[ "$prefix" == "" ]] ; then
    read a b c <$repo_file
    if [[ "$a" == '#' ]] ; then
        if [[ "$b" == prefix ]] ; then
            prefix=$c
        fi
    fi
else
    prefix=./repos
fi
check_prefix $prefix
################################################################################
# For each line do our thing
################################################################################
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
    if [ -e $target_dir ] ; then
        echo "$(tput setab 4)$target_dir already exists for $repo$(tput sgr 0)" >&2
        if [[ "$skip_if_existing" == true ]] ; then
            continue
        fi
    else
        # Do the cloning ##########################################################
        echo "$(tput setab 2)Cloning ${repo} into ${target_dir}$(tput sgr 0)" >&2
        cmd="git clone ${repo} ${target_dir}"
        if [[ "$just_print" == true ]] ; then
            echo "$cmd"
        else
            $cmd
        fi
    fi

    # Run command inside repo ##################################################
    if [[ "$absolute_command" != "" ]] ; then
        echo "$(tput setab 3)Entering directory $target_dir to do $absolute_command$(tput sgr 0)" >&2
        if [[ "$just_print" == true ]] ; then
            echo "pushd $target_dir"
            echo "$absolute_command"
            echo "popd"
        else
            if pushd $target_dir >/dev/null 2>&1 ; then
                $absolute_command
                popd 1>/dev/null
                echo "$(tput setab 3)Leaving directory $target_dir$(tput sgr 0)" >&2
            else
                echo "Could not enter directory $target_dir" >&2
            fi
        fi
    fi
    echo "" >&2
done < $repo_file
