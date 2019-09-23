#!/bin/bash

# Switches:
#   --noconfirm -> headless install
#   --reinstall -> force reinstall of existing packages
#   --dotfiles  -> specify folder for dotfiles symlinks (Default home)
#   --dry       -> echo only run

# Add a possibility to easily exclude packages(files with lists or smth)
# Add a possibility to pass params to pacman

# Main repo packages list:
# stow - must have -> creates symlinks for all dotfiles in the home dir
# git, git-lfs, python, python-pip, cmake, cppcheck, clang, texlive-most,
# firefox, vim,

# User repo packages list:
# vscode, fzf, polybar, spotify

# Ripped straight from SO
if test -t 1; then

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

echo "${bold}${green} Updating pacman mirrors & packages${normal}"
pacman -Syu --noconfirm
echo "${bold}${green} Installing stow${normal}"
pacman -S --noconfirm stow

echo "${bold}${green} Creating symlinks in home to ~/.dotfiles/${normal}"
mkdir -p ~/.dotfiles
cp -r ./dotfiles/ ~/.dotfiles
cd ~/.dotfiles
stow .
ls -a ~/
