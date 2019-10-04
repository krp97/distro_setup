#!/bin/bash

# Runs all scripts in a headless mode (--noconfirm on pacman) 
# and forces overwriting on all dotfiles. Use with care.

project_dir="`realpath $(dirname $0)`"

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

echo "${blue}${bold}#####--------------- Full setup run ---------------#####${normal}"

chmod +x $project_dir/install.sh
$project_dir/install.sh -nu

if [[ $(echo $?) -eq 0 ]]; then
    chmod +x $project_dir/run_stow.sh
    $project_dir/run_stow -f
    exit $(echo $?)
fi
