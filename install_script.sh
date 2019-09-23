#!/bin/bash

# Switches:
#   --noconfirm -> headless install
#   --reinstall -> force reinstall of existing packages
#   --dotfiles  -> specify folder for dotfiles symlinks (Default home)
#   --dry-run   -> echo only run

# Add a possibility to easily exclude packages(files with lists or smth)
# Add a possibility to pass params to pacman

# Main repo packages list:
# stow - must have -> creates symlinks for all dotfiles in the home dir
# git, git-lfs, python, python-pip, cmake, cppcheck, clang, texlive-most,
# firefox, vim,

# User repo packages list:
# vscode, fzf, polybar, spotify
pacman -Syu --noconfirm
pacman -S --noconfirm stow
stow ./dotfiles
ls ~/
