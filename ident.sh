#!/usr/bin/bash

SCRIPT_DIR=$(dirname "$0")

. "$SCRIPT_DIR/enclosure.sh"

enc_init

function draw()
{
	EXP=$1
	ENC=$2
	if [ $EXP == "A" ]; then OFF=24; else OFF=0; fi
	for PHY in {7..0}; do
		let L=16+$PHY
		let C=8+$PHY
		let R=$PHY	
		let Li=$OFF+$L
		let Ci=$OFF+$C
		let Ri=$OFF+$R	

		printf "+------+-%-30.30s-+------+-%-30.30s-+------+-%-30.30s-+\n" $DASHES $DASHES $DASHES
		if [ "${LEDS[$Li]}" -ne 0 ]; then
			printf "|\033[41m %s%02d  \033[0m" $EXP $L
		else
			printf "| %s%02d  " $EXP $L
		fi
		printf "| %-30.30s " "${MODELS[$Li]}"
		
		if [ "${LEDS[$Ci]}" -ne 0 ]; then
			printf "|\033[41m %s%02d  \033[0m" $EXP $C
		else
			printf "| %s%02d  " $EXP $C
		fi
		printf "| %-30.30s " "${MODELS[$Ci]}"
		
		if [ "${LEDS[$Ri]}" -ne 0 ]; then
			printf "|\033[41m %s%02d  \033[0m" $EXP $R
		else
			printf "| %s%02d  " $EXP $R
		fi
		printf "| %-30.30s |" "${MODELS[$Ri]}"
		echo

		if [ "${LEDS[$Li]}" -ne 0 ]; then
			printf "|\033[41m %-4s \033[0m" "${DEVICES[$Li]}"
		else
			printf "| %-4s " "${DEVICES[$Li]}"
		fi
		printf "| %-30.30s " "${SERIALS[$Li]}"

		if [ "${LEDS[$Ci]}" -ne 0 ]; then
			printf "|\033[41m %-4s \033[0m" "${DEVICES[$Ci]}"
		else
			printf "| %-4s " "${DEVICES[$Ci]}"
		fi
		printf "| %-30.30s " "${SERIALS[$Ci]}"

		if [ "${LEDS[$Ri]}" -ne 0 ]; then
			printf "|\033[41m %-4s \033[0m" "${DEVICES[$Ri]}"
		else
			printf "| %-4s " "${DEVICES[$Ri]}"
		fi
		printf "| %-30.30s |" "${SERIALS[$Ri]}"
		echo
	done
	printf "+------+-%-30.30s-+------+-%-30.30s-+------+-%-30.30s-+\n" $DASHES $DASHES $DASHES
}

DEVICES=()
MODELS=()
SERIALS=()
let I=0
for EXPANDER in B A; do
	for PHY in {00..23}; do
		find_slot "$EXPANDER$PHY"
		if [ -e "$DEV" ]; then
			[[ "$DEV" =~ ^/dev/(sd[a-z]+)$ ]]
			DEV_NAME="${BASH_REMATCH[1]}"
			SYS_DEV="/sys/block/$DEV_NAME"
			VENDOR=$(< $SYS_DEV/device/vendor)
			MODEL=$(< $SYS_DEV/device/model)
			SERIAL=$(smartctl -i "$DEV" | grep -Po "^Serial [Nn]umber:\s+\K(\w+)$")
			DEVICES[$I]="$DEV_NAME"
			MODELS[$I]="$MODEL"
			SERIALS[$I]="$SERIAL"
		else
			DEVICES[$I]=""
			MODELS[$I]=""
			SERIALS[$I]=""
		fi
		LEDS[$I]=$(led_status)
		let I=I+1;
	done
done

DASHES="-------------------------------------------------"
EQUALS="================================================="

draw B $ENC_B
draw A $ENC_A
