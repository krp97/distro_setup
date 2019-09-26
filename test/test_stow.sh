#!/bin/bash

if [[ -t 1 ]]; then
    ncolors=$(tput colors)
    if test -n "$ncolors" && test $ncolors -ge 8; then
        bold="$(tput bold)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

pass() {
    msg=$1
    echo "${bold}${green} Pass ---> ${normal}$msg"
}

fail() {
    msg=$1
    echo "${bold}${red} Fail ---# ${normal}$msg"
}

exit_code=0

if [[ -L ~/.vimrc ]]; then
    pass ".vimrc present"
else
    exit_code=1
    fail ".vimrc file doesn't exist"
fi

if [[ -L ~/.dmenurc ]]; then
    pass ".dmenurc present"
else
    exit_code=1
    fail ".dmenurc file doesn't exist"
fi

if [[ -L ~/.Xresources ]]; then
    pass ".Xresources present"
else
    exit_code=1
    fail ".Xresources file doesn't exist"
fi

exit $exit_code
