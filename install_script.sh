#!/bin/bash

# Colorful output in terminals that support colors.
# Ripped straight from SO.

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

# Switches:
#   --noconfirm  -> headless install
#   --skipupdate -> skip pacman -Syu
#   --dotfiles   -> specify folder for dotfiles symlinks (Default home)
#   --dry        -> echo only run
#   --force      -> force stow to overwrite existing symlinks

stow_install() {
    superuser=$1
    skip_update=$2

    echo "${bold}${green} ---> Updating pacman mirrors & packages${normal}"

    if ! $skip_update; then
        $superuser pacman -Syu --noconfirm
    fi

    if [[ $(echo $?) -ne 0 ]]; then
        echo "${bold}${red} ---> [Error]${normal} Pacman failed to update."
        exit 1
    fi

    echo "${bold}${green} ---> Installing stow${normal}"

    $superuser pacman -S --noconfirm stow
    if [[ $(echo $?) -ne 0 ]]; then
        echo "${bold}${red} ---> [Error]${normal} Pacman failed to install stow."
        exit 1
    fi
}

if [ "$EUID" -ne 0 ]; then
    stow_install "sudo"
else
    stow_install
fi

echo "${bold}${green} ---> Creating symlinks in home to ~/.dotfiles/${normal}"
mkdir -p ~/.dotfiles
cp -r ./dotfiles/ ~/.dotfiles
cd ~/.dotfiles
stow .
