#!/bin/bash

SUNSET_SCRIPT=$HOME/.config/hypr/cache/SUNSET.sh

source $SUNSET_SCRIPT

case $SUNSET in 
	
	"false")
		killall hyprsunset
		hyprsunset -t 4000 &
		printf "#!bin/bash\nexport SUNSET='true'" > $SUNSET_SCRIPT
		;;
	"true")
		killall hyprsunset
		hyprsunset -t 6000 &
		printf "#!bin/bash\nexport SUNSET='false'" > $SUNSET_SCRIPT
		;;
	*)
		killall hyprsunset
		hyprsunset -t 5000 &
		printf "#!bin/bash\nexport SUNSET='false'" > $SUNSET_SCRIPT
		;;
esac
