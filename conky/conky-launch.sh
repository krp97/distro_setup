#!/bin/env sh

killall -9 conky

# Start computer monitoring widget (based on Mainte conky script)
# conky -c $HOME/.conky/conky_computer_monitor/conkyrc-computer-metrics &
# sleep 0.8
# conky -c $HOME/.conky/conky_computer_monitor/conkyrc-exploded-view &

# start weather widget
#sleep 0.8
#echo "xd1"
conky -c $HOME/.conky/conky_weather/conkyrc-weather -q &
conky -c $HOME/.conky/conky_calendar/conkyrc-calendar -q &
