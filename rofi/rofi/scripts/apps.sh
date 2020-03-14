#!/bin/bash

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## browser : @adi1090x
## music : @adi1090x

rofi_command="rofi -theme themes/apps.rasi"

# Links
terminal=""
files="ﱮ"
editor=""
browser=""
music=""
settings="漣"

# Variable passed to rofi
options="$browser\n$editor\n$music\n$terminal\n$files"

chosen="$(echo -e "$options" | $rofi_command -p "Most Used" -dmenu -selected-row 0)"
case $chosen in
    $terminal)
        alacritty &
        ;;
    $files)
        thunar &
        ;;
    $editor)
        code &
        ;;
    $browser)
        chromium &
        ;;
    $music)
        spotify &
        ;;
esac
