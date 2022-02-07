#!/usr/bin/bash

function enc_init() {
	if [ ! -c "$ENC_A" ] || [ ! -c "$ENC_B" ]; then
		for E in /sys/class/enclosure/*; do
			if [ ! -d "$E" ]; then
				continue
			fi
	
			DEV=/dev/$(basename "$E/device/scsi_generic/sg"*)
			ID=$(< "$E/id")
			SCSI=$(basename "$E/device/scsi_device/"*)
	
			if sg_ses --index aa "$DEV" > /dev/null 2>&1; then
				ENC_A="$DEV"
				ENC_A_ID="$ID"
				ENC_A_SCSI="$SCSI"
			else
				ENC_B="$DEV"
				ENC_B_ID="$ID"
				ENC_B_SCSI="$SCSI"
			fi
		done
	fi
	
	if [ -z "$ENC_A" ] || [ -z "$ENC_B" ]; then
		>&2 echo "Enclosures not found"
		exit -1
	fi
}

function find_slot() {
	DEVICE="$1"
	
	enc_init
	
	if [ -z "$DEVICE" ]; then
		if [ -z "$ENC" ] || [ -z "$ENC_ID" ] || [ -z "$ENC_SCSI" ] || [ -z "$INDEX" ]; then
			>&2 echo No device specified
			return -1
		fi
		
		return
	fi
	
	if [[ "$DEVICE" =~ ^([aAbB])([0-9]$|[01][0-9]$|2[0-3]$) ]]; then
		if [ "${BASH_REMATCH[1]^^}" == "A" ]; then
			ENC="$ENC_A"
			ENC_ID="$ENC_A_ID"
			ENC_SCSI="$ENC_A_SCSI"
		else
			ENC="$ENC_B"
			ENC_ID="$ENC_B_ID"
			ENC_SCSI="$ENC_B_SCSI"
		fi
		INDEX="${BASH_REMATCH[2]}"
		if [ "${#INDEX}" -eq 1 ]; then
			INDEX="0$INDEX"
		fi
		for SYS_PATH in /sys/block/sd*/device/enclosure_device:ArrayDevice${INDEX}; do
			if [ -e "$SYS_PATH" ]; then
				FULL_PATH=$(realpath "$SYS_PATH")
				if [[ "$FULL_PATH" =~ enclosure/$ENC_SCSI/ArrayDevice ]]; then
					[[ "$SYS_PATH" =~ block/(sd[a-z]+)/device ]]
					DEV="/dev/${BASH_REMATCH[1]}"
					break
				fi
			fi
		done
	elif [[ "$DEVICE" =~ ^/dev/(sd[a-z]+)$ ]] && [ -b "$DEVICE" ]; then
		ENCLOSURE_DEVICE=$(realpath /sys/block/${BASH_REMATCH[1]}/device/enclosure_device*)
		
		if [ ! -d "$ENCLOSURE_DEVICE" ]; then
			>&2 echo Not an enclosure device \"$DEVICE\"
			return -2
		fi
		[[ "$ENCLOSURE_DEVICE" =~ enclosure/([0-9]+:[0-9]+:[0-9]+:[0-9]+)/ArrayDevice([0-9]+)$ ]]
		SCSI="${BASH_REMATCH[1]}"
		INDEX="${BASH_REMATCH[2]}"
		DEV="$DEVICE"
		
		if [ "${BASH_REMATCH[1]}" == "$ENC_A_SCSI" ]; then
			ENC="$ENC_A"
			ENC_ID="$ENC_A_ID"
			ENC_SCSI="$ENC_A_SCSI"
		elif [ "${BASH_REMATCH[1]}" == "$ENC_B_SCSI" ]; then
			ENC="$ENC_B"
			ENC_ID="$ENC_B_ID"
			ENC_SCSI="$ENC_B_SCSI"
		else
			>&2 echo Device in unknown enclosure \"$DEVICE\"
			return -3
		fi
	else
		>&2 echo Invalid device \"$DEVICE\"
		return -4
	fi
}

function led_status() {
	local DEVICE="$1"
	
	find_slot "$DEVICE" || return

	sg_ses --index "$INDEX" --get ident "$ENC"
}

function led_on() {
	local DEVICE="$1"
	
	find_slot "$DEVICE" || return

	sg_ses --index "$INDEX" --set ident "$ENC"
}

function led_off() {
	local DEVICE="$1"
	
	find_slot "$DEVICE" || return

	sg_ses --index "$INDEX" --clear ident "$ENC"
}

function led_is_on() {
	local DEVICE="$1"

	STATUS=$(led_status "$DEVICE") || return
	[ "$STATUS" == "1" ]
}
