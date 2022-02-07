#!/usr/bin/bash

SCRIPT_DIR=$(dirname "$0")

. "$SCRIPT_DIR/enclosure.sh"

enc_init

function usage()
{
	echo $(basename "$0") 'on|off|get device0 [...device_n]'
	echo
	echo device is either /dev/sd[a-z]+, A00..A23 or B00..B23
}

if [ $# -lt 2 ]; then
	usage
	exit -2
fi

COMMAND="${1,,}"

if [ "$COMMAND" != "on" ] && [ "$COMMAND" != "off" ] && [ "$COMMAND" != "get" ]; then
	usage
	exit -3
fi

shift
	
DEVICES="$@"

for DEVICE in $DEVICES; do
	if ! find_slot "$DEVICE"; then
		continue
	fi
	
	case "$COMMAND" in
		on)
			led_on
			;;
		off)
			led_off
			;;
	esac
	
	STATUS=$(led_status)
	echo -n $DEVICE is ''
	case "$STATUS" in
		1)
			echo ON
			;;
		0)
			echo OFF
			;;
		*)
			echo UNK\($STATUS\)
			;;
	esac
done
