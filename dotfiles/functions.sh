# Custom functions

function cd() {
    new_directory="$*"
    if [ $# -eq 0 ]; then
        new_directory=${HOME}
    fi
    builtin cd "${new_directory}" && ls --color
}

function git_branch () {
    SOME_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/');
    if [[ $SOME_BRANCH != "" ]]; then
        echo -e "\u2387 $SOME_BRANCH "
    fi
}


