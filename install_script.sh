#!/bin/bash

# Installs stow and places symlinks to all dotfiles in home directory.

# Colorful output in terminals that support colors.
# Ripped straight from SO.

no_confirm=false
skip_pacman_update=false
dotfile_path='~/'
dry_run=false
force_overwrite=false

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

    printf "\t%2s \t%s\n" "${bold}${white}-s${normal}" "Skips pacman -Syu."
    printf "\t%2s \t%s\n" "${bold}${white}-d${normal}" "Specify the path to symlinks directory (Default: home)."
    printf "\t%2s \t%s\n" "${bold}${white}-e${normal}" "Do not make any changes (echo only run)."
    printf "\t%2s \t%s\n" "${bold}${white}-f${normal}" "Force overwriting symlinks in the destination path."
}

exit_on_error() {
    error_str=$1
    if [[ $(echo $?) -ne 0 ]]; then
        echo $error_str
        exit 1
    fi
}

stow_install() {
    superuser=$1
    args=$2

    if $skip_pacman_update; then
        echo "${bold}${yellow} ---# Skipping pacman update${normal}"
    else
        echo "${bold}${green} ---> Updating pacman mirrors & packages${normal}"
        $superuser pacman -Syu $args --needed
        exit_on_error "${bold}${red} ---> [Error]${normal} Pacman failed to update."
    fi

    pacman -Qi stow >/dev/null
    if [[ $(echo $?) -eq 0 ]]; then
        echo "${bold}${yellow} ---# Skipping stow install (package already present)${normal}"
    else
        echo "${bold}${green} ---> Installing stow${normal}"
        $superuser pacman -S $args stow --needed
        exit_on_error "${bold}${red} ---> [Error]${normal} Pacman failed to install stow."
    fi
}

while getopts ":nsd:efh" opt; do
    case ${opt} in
    n) no_confirm=true ;;
    s)
        skip_pacman_update=true
        pacman_skip="--noconfirm"
        ;;
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
shift $((OPTIND - 1))

if [ "$EUID" -ne 0 ]; then
    stow_install "sudo" $pacman_skip
else
    stow_install $pacman_skip
fi

echo "${bold}${green} ---> Creating symlinks in home to ~/.dotfiles/${normal}"
mkdir -p ~/.dotfiles
cp -a ./dotfiles/. ~/.dotfiles/
cd ~/.dotfiles

stow . -t ~/ $stow_params
