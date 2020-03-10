rofi_command="rofi -theme themes/main.rasi"

# Links
apps=""
quicklinks=""
time=""
power="⏻"
volume=""
network=""
screenshot=""

# Variable passed to rofi
options="$apps\n$quicklinks\n$screenshot\n$power"

chosen="$(echo -e "$options" | $rofi_command -p "System menu" -dmenu -selected-row 0)"
case $chosen in
    $apps)
        /home/desktop/.config/rofi/scripts/apps.sh &
        ;;
    $quicklinks)
        /home/desktop/.config/rofi/scripts/quicklinks.sh &
        ;;
    $time)
        /home/desktop/.config/rofi/scripts/time.sh &
        ;;
    $power)
        /home/desktop/.config/rofi/scripts/powermenu.sh &
        ;;
    $screenshot)
        /home/desktop/.config/rofi/scripts/screenshot.sh &
        ;;
esac