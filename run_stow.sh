#!/bin/bash

# Installs stow and places symlinks to all dotfiles in home directory.

# Colorful output in terminals that support colors.
# Ripped straight from SO.

no_confirm=false
skip_pacman_update=false
home_path='~/'
dry_run=false
force_overwrite=false
install_scripts=false

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

    printf "\t%2s \t%s\n" "${bold}${white}-d${normal}" "Specify the path to symlinks directory (Default: home)."
    printf "\t%2s \t%s\n" "${bold}${white}-e${normal}" "Do not make any changes (echo only run)."
    printf "\t%2s \t%s\n" "${bold}${white}-f${normal}" "Force overwriting symlinks in the destination path."
    printf "\t%2s \t%s\n" "${bold}${white}-c${normal}" "Install custom scripts. (pipfi, time_keeper)"
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

    pacman -Qi stow >/dev/null
    if [[ $(echo $?) -eq 0 ]]; then
        echo "${bold}${yellow} ---# ${white}Skipping stow install (package already present)${normal}"
    else
        echo "${bold}${green} ---> ${white}Installing stow${normal}"
        $superuser pacman -Sy $args
        $superuser pacman -S $args stow --needed
        exit_on_error "${bold}${red} ---> [Error]${white} Pacman failed to install stow.${normal}"
    fi
}

while getopts ":nsd:efh" opt; do
    case ${opt} in
    n) pacman_args="--noconfirm" ;;
    d) path=$OPTARG ;;
    e)
        dry_run=true
        stow_params=$stow_params"--simulate"
        ;;
    f) force_overwrite=true ;;
    c) install_scripts=true ;;
    h)
        usage
        exit 0
        ;;
    *)
        echo "${bold}${red} ---> ${white}[Error] Invalid argument $OPTARG ${normal}"
        usage
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

if [ "$EUID" -ne 0 ]; then
    stow_install "sudo" $pacman_args
else
    stow_install "" $pacman_args
fi

current_dir=$(realpath $(dirname $0))

echo "${bold}${green} ---> ${white}Creating symlinks in home to $current_dir ${normal}"
if $force_overwrite; then
    echo "${bold}${green} ---> ${white}Checking for conflicts with stow${normal}"
    stow dotfiles -t $home_path \
        $stow_params -n --dotfiles 2> >(grep -E ":\s(\.?[a-zA-Z.]+$)" -o) | cut -c 3- |
        while read file_to_rm; do
            if $dry_run; then
                echo "${bold}${yellow} ---> ${white}Dry run --- Overwriting $home_path/$file_to_rm ${normal}"
            else
                echo "${bold}${yellow} ---> ${white}Overwriting $file_to_rm ${normal}"
                mkdir -p backup
                mv $home_path/$file_to_rm $current_dir/backup/
            fi
        done
fi

if [[ -d $current_dir/backup ]]; then
    echo "${bold}${yellow} ---> ${white} All overwritten files backed up to $current_dir/backup.${normal}"
fi

if ! $dry_run && [[ $(echo $?) -eq 0 ]]; then
    stow dotfiles -t $home_path $stow_params --dotfiles
fi

if $install_scripts; then
    ln -s "$current_dir/myscripts" "$home_path/myscripts"
fi

echo "${bold}${green} ---> ${white}All done ${normal}"
