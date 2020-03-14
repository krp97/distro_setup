#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar edp1 -c ~/.config/polybar/config.ini &
polybar dp1 -c ~/.config/polybar/config.ini &
polybar dp2 -c ~/.config/polybar/config.ini &
