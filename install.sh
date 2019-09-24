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

usage() {
    printf "Usage:\n"
    printf "\t%2s \t%s\n" "${bold}${white}-n${normal}" "No confirmation will be asked from user during script execution."
    printf "\t%2s \t%s\n" " " "Do note that pacman also won't ask for sudo password,"
    printf "\t%2s \t%s\n\n" " " "so you have to run the script with elevated privileges."

    printf "\t%2s \t%s\n" "${bold}${white}-e${normal}" "Do not make any changes (echo only run)."
}

while getopts ":nsd:efh" opt; do
    case ${opt} in
    n) pacman_args="--noconfirm" ;;
    d) path=$OPTARG ;;
    e)
        dry_run=true
        stow_params=$stow_params"--simulate"
        ;;
    f) stow_params=$stow_params"--override=." ;;
    h)
        usage
        exit 0
        ;;
    *)
        echo "${bold}${red} ---> [Error] Invalid argument $OPTARG"
        usage
        exit 1
        ;;
    esac
done

printf "${bold}${green}---> Installing base packages\n${normal}"

if [ "$EUID" -ne 0 ]; then
    base_install "sudo" $pacman_args
else
    base_install "" $pacman_args
fi

base_install() {
    superuser=$1
    params=$2
    $superuser pacman -S --needed $params $(cat base_packages)
}

printf "${bold}${green}---> Installing base packages --- done\n${normal}"
