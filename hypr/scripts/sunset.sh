#!/bin/bash

# SUNSET_SCRIPT=$HOME/.config/hypr/cache/SUNSET.sh
SUNSET_SCRIPT=$HOME/.cache/SUNSET.sh

if [ -f "$SUNSET_SCRIPT" ]; then
	source $SUNSET_SCRIPT
else
	printf "export SUNSET=true\n" > $SUNSET_SCRIPT
fi

echo "$SUNSET"
cat "$SUNSET_SCRIPT"
case "$SUNSET" in 
	
	false)
		echo "false"
		hyprctl hyprsunset temperature 4000
		printf "export SUNSET=true\n" > $SUNSET_SCRIPT
		;;
	true)
		echo "true"
		hyprctl hyprsunset temperature 6000	
		printf "export SUNSET=false\n" > $SUNSET_SCRIPT
		;;
	*)
		echo "default"
		hyprctl hyprsunset temperature 6000
		printf "export SUNSET=false\n" > $SUNSET_SCRIPT
		;;
esac
