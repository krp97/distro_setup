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

p_error() {
    echo -e "${bold}${red}---> [Error]${white} $1${normal}"
}

p_info_msg() {
    echo -e "${bold}${green}--->${white} $1${normal}"
}

p_warning() {
    echo -e "${bold}${yellow}--->${white} $1${normal}"
}

p_found_msg() {
    echo -e "$2${bold}${blue}--->${white} $1${normal}"
}

p_not_found_msg() {
    echo -e "$2${yellow}${bold}---# ${white}$1${normal}"
}

usage() {
    printf "Usage:\n"
    printf "\t%2s \t%s\n" "${bold}${white}-n${normal}" "No confirmation will be asked from user during script execution."
    printf "\t%2s \t%s\n" " " "Do note that pacman will need root permissions,"
    printf "\t%2s \t%s\n\n" " " "so you have to run the script with elevated privileges."

    printf "\t%2s \t%s\n" "${bold}${white}-e${normal}" "Do not make any changes (echo only run)."
    printf "\t%2s \t%s\n" "${bold}${white}-u${normal}" "Enable installation of user packages."
}

dry_run=false
install_user_packages=false

while getopts ":nsud:efh" opt; do
    case ${opt} in
    n) pacman_args="--noconfirm" ;;
    d) path=$OPTARG ;;
    e)
        dry_run=true
        stow_params=$stow_params"--simulate"
        ;;
    f) stow_params=$stow_params"--override=." ;;
    u) install_user_packages=true ;;
    h)
        usage
        exit 0
        ;;
    *)
        p_error "[Error] Invalid argument $OPTARG"
        usage
        exit 1
        ;;
    esac
done

p_info_msg "Installing base packages"

base_install() {
    superuser=$1
    params=$2
    declare -a base_p
    IFS=$'\n' read -d '' -r -a base_p <./base_packages

    if $dry_run; then
        p_warning "Dry run mode --- skipping install"
    else
        $superuser pacman -S --needed $params ${base_p[@]}
    fi

    if [[ $(echo $?) -ne 0 ]]; then
        p_error "Some packages in base_packages could not be installed."
        exit 1
    fi
}

if [ "$EUID" -ne 0 ]; then
    base_install "sudo" $pacman_args
else
    base_install "" $pacman_args
fi

! $install_user_packages && exit 0

echo "${bold}${yellow}--------------* Danger zone *--------------"
p_info_msg "Checking for pacman wrappers"

pacman_wrapper=''

verify_wrappers() {
    commands=(pacaur pakku pikaur yay)
    for element in ${commands[@]}; do
        command -v $element >/dev/null
        if [[ $(echo $?) -ne 0 ]]; then
            p_not_found_msg "$element not found" "\t"
        else
            p_found_msg "${white}$element found" "\t"
            pacman_wrapper=$element
            break
        fi
    done
}

verify_wrappers
if [[ $pacman_wrapper == "" ]]; then
    p_error "No pacman wrappers found."
    exit 1
fi

p_info_msg "Verifying packages from user_packages file"

verify_packages() {
    for package in ${user_p[@]}; do
        $pacman_wrapper -Qi $package &>/dev/null
        if [[ $(echo $?) -ne 0 ]]; then
            p_not_found_msg "$package not found -- removing from list" "\t"
            user_p=("${user_p[@]/$package/}")
        else
            p_found_msg "${white}$package found" "\t"
        fi
    done
}

declare -a user_p
IFS=$'\n' read -d '' -r -a user_p <./user_packages

verify_packages
p_info_msg "Installing user packages with $pacman_wrapper"

if $dry_run; then
    p_warning "Dry run mode --- skipping install"
else
    $pacman_wrapper -S ${user_p[@]} --needed $pacman_args

    if [[ $(echo $?) -ne 0 ]]; then
        p_error "Some packages could not be installed."
        exit 1
    fi
fi
