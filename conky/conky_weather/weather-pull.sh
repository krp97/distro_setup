#/bin/bash
function weather-pull {
	# Don't ask
	echo -e "\n" > /tmp/weather.tmp
	# Pulls in weather info in a fancy format.
	curl "http://wttr.in/wroclaw?T&1&Q&F&lang=en" >> /tmp/weather.tmp
	sleep 1
}
weather-pull
