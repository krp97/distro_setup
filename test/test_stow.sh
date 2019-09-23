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

[[ -L ~/.vimrc ]] && echo "${bold}${green} Pass --- .vimrc present"
[[ -L ~/.dmenurc ]] && echo "${bold}${green} Pass --- .dmenurc present"
[[ -L ~/.Xresources ]] && echo "${bold}${green} Pass --- .Xresources present"
