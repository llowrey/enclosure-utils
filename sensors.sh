#!/usr/bin/bash

SCRIPT_DIR=$(dirname "$0")

. "$SCRIPT_DIR/enclosure.sh"

enc_init

if [ "$1" == "smart" ]; then
	INCLUDE_SMART=1
else
	INCLUDE_SMART=0
fi

echo '{'

for ENC in $ENC_A $ENC_B; do
	if [ "$ENC" == "$ENC_A" ]; then
		echo '  "enclosureA": {'
	else
		echo '  "enclosureB": {'
	fi
	
	echo '    "slots": ['
	if [ "$ENC" == "$ENC_A" ]; then
		PREFIX="A"
	else
		PREFIX="B"
	fi
	for IDX in {0..23}; do
		SLOT="$PREFIX$IDX"
		find_slot "$SLOT"
		
		echo '      {'
		echo '        "slot": "'$SLOT'",'
		if led_is_on; then
			echo '        "ledIsOn": true,'
		else
			echo '        "ledIsOn": false,'
		fi
		if [ -n "$DEV" ]; then
			echo -n '        "occupied": true'
			if [ "$INCLUDE_SMART" -eq 1 ]; then
				SMART=$(smartctl -j -i -H "$DEV")
				if [ -n "$SMART" ]; then
					echo ,
					echo '        "family": '$(jq .model_family <<< "$SMART"),
					echo '        "model": '$(jq .model_name <<< "$SMART"),
					echo '        "serial": '$(jq .serial_number <<< "$SMART"),
					echo '        "capacity": '$(jq .user_capacity.bytes <<< "$SMART"),
					echo '        "healthy": '$(jq .smart_status.passed <<< "$SMART"),
					TEMP=$(jq .temperature.current <<< "$SMART")
					if [ "$TEMP" != "null" ]; then
						echo '        "temperature": '$TEMP
					else
						TEMP=$(hddtemp -n "$DEV")
						if [ $? -eq 0 ]; then
							echo '        "temperature": '$TEMP
						fi
					fi
				else
					echo
				fi
			else
				echo
			fi			
		else
			echo '        "occupied": false,'
		fi
		if [ $IDX -lt 23 ]; then
			echo '      },'
		else
			echo '      }'
		fi		
	done
	echo '    ],'
	
	echo '    "temps": ['
	for IDX in {0..3}; do
		readarray -t TEMP < <(sg_ses --index ts,$IDX $ENC)
		echo '      {'
		[[ "${TEMP[6]}" =~ Predicted\ failure=(.*),\ Disabled=(.*),\ Swap=(.*),\ status:\ (.*)$ ]]
		echo '        "predictedFailure": '${BASH_REMATCH[1]},
		echo '        "disabled": '${BASH_REMATCH[2]},
		echo '        "swap": '${BASH_REMATCH[3]},
		echo '        "status": "'${BASH_REMATCH[4]}'",'
		[[ "${TEMP[7]}" =~ Ident=(.*),\ Fail=(.*),\ OT\ failure=(.*),\ OT\ warning=(.*),\ UT\ failure=(.*)$ ]]
		echo '        "ident": '${BASH_REMATCH[1]},
		echo '        "fail": '${BASH_REMATCH[2]},
		echo '        "otFailure": '${BASH_REMATCH[3]},
		echo '        "otWarning": '${BASH_REMATCH[4]},
		echo '        "utFailure": '${BASH_REMATCH[5]},
		[[ "${TEMP[8]}" =~ UT\ warning=(.*)$ ]]
		echo '        "utWarning": '${BASH_REMATCH[1]},
		[[ "${TEMP[9]}" =~ Temperature=([0-9]*)\ (.*)$ ]]
		echo '        "temperature": '${BASH_REMATCH[1]},
		echo '        "temperatureUnits": "'${BASH_REMATCH[2]}'"'

		echo -n '      }'
		if [ "$ENC" == "$ENC_A" ] && [ $IDX -eq 3 ]; then
			echo
		elif [ "$ENC" == "$ENC_B" ] && [ $IDX -eq 2 ]; then
			echo
			break
		else
			echo ,
		fi
	done
	echo '    ],'
	
	echo '    "fans": ['
	for IDX in {0..3}; do
		readarray -t FAN < <(sg_ses --index coo,$IDX $ENC)
		echo '      {'
		[[ "${FAN[6]}" =~ Predicted\ failure=(.*),\ Disabled=(.*),\ Swap=(.*),\ status:\ (.*)$ ]]
		echo '        "predictedFailure": '${BASH_REMATCH[1]},
		echo '        "disabled": '${BASH_REMATCH[2]},
		echo '        "swap": '${BASH_REMATCH[3]},
		echo '        "status": "'${BASH_REMATCH[4]}'",'
		[[ "${FAN[7]}" =~ Ident=(.*),\ Do\ not\ remove=(.*),\ Hot\ swap=(.*),\ Fail=(.*),\ Requested\ on=(.*)$ ]]
		echo '        "ident": '${BASH_REMATCH[1]},
		echo '        "doNotRemove": '${BASH_REMATCH[2]},
		echo '        "hotSwap": '${BASH_REMATCH[3]},
		echo '        "fail": '${BASH_REMATCH[4]},
		echo '        "requestedOn": '${BASH_REMATCH[5]},
		[[ "${FAN[8]}" =~ Off=(.*),\ Actual\ speed=([0-9]*)\ rpm,\ (.*)$ ]]
		echo '        "off": '${BASH_REMATCH[1]},
		echo '        "actualSpeed": '${BASH_REMATCH[2]},
		echo '        "speedDescription": "'${BASH_REMATCH[3]}'"'

		echo -n '      }'
		if [ $IDX -ne 3 ]; then
			echo ','
		else
			echo
		fi
	done
	echo '    ],'
	
	echo '    "voltage": ['
	for IDX in {0..3}; do
		readarray -t VOLT < <(sg_ses --index vs,$IDX $ENC)
		echo '      {'
		[[ "${VOLT[6]}" =~ Predicted\ failure=(.*),\ Disabled=(.*),\ Swap=(.*),\ status:\ (.*)$ ]]
		echo '        "predictedFailure": '${BASH_REMATCH[1]},
		echo '        "disabled": '${BASH_REMATCH[2]},
		echo '        "swap": '${BASH_REMATCH[3]},
		echo '        "status": "'${BASH_REMATCH[4]}'",'
		[[ "${VOLT[7]}" =~ Ident=(.*),\ Fail=(.*),\ \ Warn\ Over=(.*),\ Warn\ Under=(.*),\ Crit\ Over=(.*)$ ]]
		echo '        "ident": '${BASH_REMATCH[1]},
		echo '        "fail": '${BASH_REMATCH[2]},
		echo '        "warnOverVolt": '${BASH_REMATCH[3]},
		echo '        "warnUnderVolt": '${BASH_REMATCH[4]},
		echo '        "criticalOverVolt": '${BASH_REMATCH[5]},
		[[ "${VOLT[8]}" =~ Crit\ Under=(.*)$ ]]
		echo '        "criticalUnderVolt": '${BASH_REMATCH[1]},
		[[ "${VOLT[9]}" =~ Voltage:\ (.*)\ volts$ ]]
		echo '        "voltage": '${BASH_REMATCH[1]}

		echo -n '      }'
		if [ $IDX -ne 3 ]; then
			echo ','
		else
			echo
		fi
	done
	echo '    ],'

	echo '    "powerSupply": {'
	readarray -t POWER < <(sg_ses --index ps,0 $ENC)
	[[ "${POWER[6]}" =~ Predicted\ failure=(.*),\ Disabled=(.*),\ Swap=(.*),\ status:\ (.*)$ ]]
	echo '      "predictedFailure": '${BASH_REMATCH[1]},
	echo '      "disabled": '${BASH_REMATCH[2]},
	echo '      "swap": '${BASH_REMATCH[3]},
	echo '      "status": "'${BASH_REMATCH[4]}'",'
	[[ "${POWER[7]}" =~ Ident=(.*),\ Do\ not\ remove=(.*),\ DC\ overvoltage=(.*),\ DC\ undervoltage=(.*)$ ]]
	echo '      "ident": '${BASH_REMATCH[1]},
	echo '      "doNotRemove": '${BASH_REMATCH[2]},
	echo '      "dcOverVoltage": '${BASH_REMATCH[3]},
	echo '      "dcUnderVoltage": '${BASH_REMATCH[4]},
	[[ "${POWER[8]}" =~ DC\ overcurrent=(.*),\ Hot\ swap=(.*),\ Fail=(.*),\ Requested\ on=(.*),\ Off=(.*)$ ]]
	echo '      "dcOverCurrent": '${BASH_REMATCH[1]},
	echo '      "hotSwap": '${BASH_REMATCH[2]},
	echo '      "fail": '${BASH_REMATCH[3]},
	echo '      "requestedOn": '${BASH_REMATCH[4]},
	echo '      "off": '${BASH_REMATCH[5]},
	[[ "${POWER[9]}" =~ Overtmp\ fail=(.*),\ Temperature\ warn=(.*),\ AC\ fail=(.*),\ DC\ fail=(.*)$ ]]
	echo '      "overTemperatureFail": '${BASH_REMATCH[1]},
	echo '      "temperatureWarn": '${BASH_REMATCH[2]},
	echo '      "acFail": '${BASH_REMATCH[3]},
	echo '      "dcFail": '${BASH_REMATCH[4]}

	if [ "$ENC" == "$ENC_A" ]; then
		echo '    },'
		
		echo '    "alarm": {'
		readarray -t ALARM < <(sg_ses --index aa,0 $ENC)
		[[ "${ALARM[6]}" =~ Predicted\ failure=(.*),\ Disabled=(.*),\ Swap=(.*),\ status:\ (.*)$ ]]
		echo '      "predictedFailure": '${BASH_REMATCH[1]},
		echo '      "disabled": '${BASH_REMATCH[2]},
		echo '      "swap": '${BASH_REMATCH[3]},
		echo '      "status": "'${BASH_REMATCH[4]}'",'
		[[ "${ALARM[7]}" =~ Ident=(.*),\ Fail=(.*),\ Request\ mute=(.*),\ Mute=(.*),\ Remind=(.*)$ ]]
		echo '      "ident": '${BASH_REMATCH[1]},
		echo '      "fail": '${BASH_REMATCH[2]},
		echo '      "requestMute": '${BASH_REMATCH[3]},
		echo '      "mute": '${BASH_REMATCH[4]},
		echo '      "remind": '${BASH_REMATCH[5]},
		[[ "${ALARM[8]}" =~ Tone\ indicator:\ Info=(.*),\ Non-crit=(.*),\ Crit=(.*),\ Unrecov=(.*)$ ]]
		echo '      "toneIndicatorInfo": '${BASH_REMATCH[1]},
		echo '      "toneIndicatorNonCritical": '${BASH_REMATCH[2]},
		echo '      "toneIndicatorCritical": '${BASH_REMATCH[3]},
		echo '      "toneIndicatorUnrecoverable": '${BASH_REMATCH[4]}

		echo '    }'
		
		echo '  },'
	else
		echo '    }'
		echo '  }'
	fi
done
echo '}'
