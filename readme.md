# Enclosure utilities for Chenbro RM43348 and IBM Slicestor 3448

This project provides a few utilities to make managing the drive slots a bit easier.

NOTE: These must be run as root

## Prerequisites
- `sg_ses` from sg3_utils
- `smartctl` from smartmontools
- `jq` from jq
- `hddtemp` from hddtemp

## Scripts
- `leds.sh` set or get the status of drive slot identification LED
- `ident.sh` identify the drive occupying each slot in a chassis layout view
- `sensors.sh` output a JSON document containing enclosure/expander sensor data
- `enclosure.sh` a common script not to be used directly



## `leds.sh`

Turn on, off and query drive slot identification LEDs

### Examples

```
### turn on led at B03 and for drive /dev/sdx
# ./leds.sh on b03 /dev/sdx
b03 is ON
/dev/sdx is ON

### turn off led at B03
# ./leds.sh off B3
B3 is OFF

### get the ststus of B03 and /dev/sdx
# ./leds.sh get b03 /dev/sdx
b03 is OFF
/dev/sdx is ON
```

## `ident.sh`

Display a chassis layout view of slot occupants. If the identification LED for a slot is on the box identifying the slot will have a red background.

### Example
```
# ./ident.sh
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| B23  | MZILS1T9HCHP/0NW               | B15  |                                | B07  | MZILS1T9HCHP/0NW               |
| sdp  | S32CNCAH30####                 |      |                                | sdf  | S32CNCAH30####                 |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| B22  | Hitachi HDS72404               | B14  | HUH728080AL4200                | B06  | ST4000DM000-1F21               |
| sdu  | PK2331PAGH####                 | sdk  | 2EGZ####                       | sdv  | Z301####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| B21  | HUH728080AL4200                | B13  | ST4000DM000-1F21               | B05  | HUH728080AL4200                |
| sdq  | 2EK8####                       | sdw  | Z301####                       | sde  | 2EKR####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| B20  | Hitachi HDS72404               | B12  | HUH728080AL4200                | B04  | ST4000DM000-1F21               |
| sds  | PK2331PAGA####                 | sdj  | 2EKR####                       | sdt  | Z301####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| B19  | HUH728080AL4200                | B11  | ST4000DM000-1F21               | B03  | HUH728080AL4200                |
| sdo  | 2EKS####                       | sdr  | Z300####                       | sdd  | 2EKR####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| B18  | HGST HDS724040AL               | B10  | HUH728080AL4200                | B02  | ST4000DM000-1F21               |
| sdn  | PK1300PAG0####                 | sdi  | 2EKK####                       | sdc  | Z300####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| B17  | HUH728080AL4200                | B09  | ST4000DM000-1F21               | B01  | HUH728080AL4200                |
| sdm  | 2EG2####                       | sdh  | Z307####                       | sda  | 2EKR####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| B16  | ST4000DM000-1F21               | B08  | HUH728080AL4200                | B00  | ST4000DM000-1F21               |
| sdax | Z303####                       | sday | 2EKR####                       | sdb  | Z303####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| A23  | MZILS1T9HCHP/0NW               | A15  | MZILS1T9HCHP/0NW               | A07  | HUH728080AL4200                |
| sdap | S32CNCAH30####                 | sdaj | S32CNCAH30####                 | sdaf | 2EKR####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| A22  | Hitachi HDS72404               | A14  |                                | A06  | ST4000DM000-1F21               |
| sdaq | PK2331PAGE####                 |      |                                | sdac | Z301####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| A21  | HUH72808CLAR8000               | A13  | ST4000DM000-1F21               | A05  | HUH728080AL4200                |
| sdao | VJGS####                       | sdah | Z303####                       | sdab | 2EKR####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| A20  | ST4000DM000-1F21               | A12  | HUH728080AL4200                | A04  | ST4000DM005-2DP1               |
| sdan | Z303####                       | sdag | 2EKN####                       | sdaa | ZDH1####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| A19  | HUH728080AL4200                | A11  | ST4000DM005-2DP1               | A03  | HUH728080AL4200                |
| sdam | 2EGY####                       | sdau | ZDH0####                       | sdz  | 2EG2####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| A18  | ST4000DM000-1F21               | A10  | HUH728080AL4200                | A02  | ST4000DM005-2DP1               |
| sdat | Z307####                       | sdae | 2EKJ####                       | sdas | ZDH1####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| A17  | HUH728080AL4200                | A09  | ST4000DM005-2DP1               | A01  | HUH728080AL4200                |
| sdal | 2EH5####                       | sdar | ZDH0####                       | sdy  | 2EKK####                       |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
| A16  | MZILS1T9HCHP/0NW               | A08  | MZILS1T9HCHP/0NW               | A00  | MZILS1T9HCHP/0NW               |
| sdak | S32CNCAH30####                 | sdad | S32CNCAH30####                 | sdx  | S32CNCAH30####                 |
+------+--------------------------------+------+--------------------------------+------+--------------------------------+
```
## `sensors.sh`

Output enclosure/expander sensor data in JSON format. Each drive slot is enumerated but the default omits drive identification since the SMART calls are fairly slow. You can pass the `smart` argument to enable the drive identification info.

### Examples
```
### without drive identifcation
# ./sensors.sh
{
  "enclosureA": {
    "slots": [
      {
        "slot": "A0",
        "ledIsOn": true,
        "occupied": true
      },
      {
        "slot": "A1",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A2",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A3",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A4",
        "ledIsOn": true,
        "occupied": true
      },
      {
        "slot": "A5",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A6",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A7",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A8",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A9",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A10",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A11",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A12",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A13",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A14",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A15",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A16",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A17",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A18",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A19",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A20",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A21",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A22",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "A23",
        "ledIsOn": false,
        "occupied": true
      }
    ],
    "temps": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 69,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 36,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 39,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 26,
        "temperatureUnits": "C"
      }
    ],
    "fans": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 5400,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 5400,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 4620,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 4680,
        "speedDescription": "Fan at third lowest speed"
      }
    ],
    "voltage": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 12.07
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 5.02
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 1.76
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 0.88
      }
    ],
    "powerSupply": {
      "predictedFailure": 0,
      "disabled": 0,
      "swap": 0,
      "status": "OK",
      "ident": 1,
      "doNotRemove": 0,
      "dcOverVoltage": 0,
      "dcUnderVoltage": 0,
      "dcOverCurrent": 0,
      "hotSwap": 0,
      "fail": 0,
      "requestedOn": 1,
      "off": 0,
      "overTemperatureFail": 0,
      "temperatureWarn": 0,
      "acFail": 0,
      "dcFail": 0
    },
    "alarm": {
      "predictedFailure": 0,
      "disabled": 0,
      "swap": 0,
      "status": "OK",
      "ident": 0,
      "fail": 0,
      "requestMute": 0,
      "mute": 0,
      "remind": 0,
      "toneIndicatorInfo": 0,
      "toneIndicatorNonCritical": 0,
      "toneIndicatorCritical": 0,
      "toneIndicatorUnrecoverable": 0
    }
  },
  "enclosureB": {
    "slots": [
      {
        "slot": "B0",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B1",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B2",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B3",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B4",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B5",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B6",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B7",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B8",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B9",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B10",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B11",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B12",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B13",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B14",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B15",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B16",
        "ledIsOn": true,
        "occupied": true
      },
      {
        "slot": "B17",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B18",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B19",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B20",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B21",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B22",
        "ledIsOn": false,
        "occupied": true
      },
      {
        "slot": "B23",
        "ledIsOn": false,
        "occupied": true
      }
    ],
    "temps": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 68,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 40,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 37,
        "temperatureUnits": "C"
      }
    ],
    "fans": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 5370,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 5310,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 4710,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 4680,
        "speedDescription": "Fan at third lowest speed"
      }
    ],
    "voltage": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 12.14
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 5.00
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 1.77
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 0.87
      }
    ],
    "powerSupply": {
      "predictedFailure": 0,
      "disabled": 0,
      "swap": 0,
      "status": "OK",
      "ident": 1,
      "doNotRemove": 0,
      "dcOverVoltage": 0,
      "dcUnderVoltage": 0,
      "dcOverCurrent": 0,
      "hotSwap": 0,
      "fail": 0,
      "requestedOn": 1,
      "off": 0,
      "overTemperatureFail": 0,
      "temperatureWarn": 0,
      "acFail": 0,
      "dcFail": 0
    }
  }
}

### with drive identifcation
# ./sensors.sh smart
{
  "enclosureA": {
    "slots": [
      {
        "slot": "A0",
        "ledIsOn": true,
        "occupied": true,
        "family": null,
        "model": "SAMSUNG MZILS1T9HCHP/0NW",
        "serial": "S32CNCAH30####",
        "capacity": 1920383410176,
        "healthy": true,
        "temperature": 33
      },
      {
        "slot": "A1",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKK####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 31
      },
      {
        "slot": "A2",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate BarraCuda 3.5 (SMR)",
        "model": "ST4000DM005-2DP166",
        "serial": "ZDH1####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 27
      },
      {
        "slot": "A3",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EG2####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 32
      },
      {
        "slot": "A4",
        "ledIsOn": true,
        "occupied": true,
        "family": "Seagate BarraCuda 3.5 (SMR)",
        "model": "ST4000DM005-2DP166",
        "serial": "ZDH1####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 28
      },
      {
        "slot": "A5",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKRP####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 32
      },
      {
        "slot": "A6",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z301####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 29
      },
      {
        "slot": "A7",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKR####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 32
      },
      {
        "slot": "A8",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "SAMSUNG MZILS1T9HCHP/0NW",
        "serial": "S32CNCAH30####",
        "capacity": 1920383410176,
        "healthy": true,
        "temperature": 34
      },
      {
        "slot": "A9",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate BarraCuda 3.5 (SMR)",
        "model": "ST4000DM005-2DP166",
        "serial": "ZDH0####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 30
      },
      {
        "slot": "A10",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKJ####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 38
      },
      {
        "slot": "A11",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate BarraCuda 3.5 (SMR)",
        "model": "ST4000DM005-2DP166",
        "serial": "ZDH0####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 36
      },
      {
        "slot": "A12",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKN####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 40
      },
      {
        "slot": "A13",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z303####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 37
      },
      {
        "slot": "A14",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKR####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 39
      },
      {
        "slot": "A15",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "SAMSUNG MZILS1T9HCHP/0NW",
        "serial": "S32CNCAH30####",
        "capacity": 1920383410176,
        "healthy": true,
        "temperature": 41
      },
      {
        "slot": "A16",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "SAMSUNG MZILS1T9HCHP/0NW",
        "serial": "S32CNCAH30####",
        "capacity": 1920383410176,
        "healthy": true,
        "temperature": 37
      },
      {
        "slot": "A17",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EH5####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 36
      },
      {
        "slot": "A18",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z307####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 33
      },
      {
        "slot": "A19",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EGY####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 38
      },
      {
        "slot": "A20",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z303####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 36
      },
      {
        "slot": "A21",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HITACHI HUH72808CLAR8000",
        "serial": "VJGS####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 41
      },
      {
        "slot": "A22",
        "ledIsOn": false,
        "occupied": true,
        "family": "Hitachi/HGST Deskstar 7K4000",
        "model": "Hitachi HDS724040ALE640",
        "serial": "PK2331PAGE####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 39
      },
      {
        "slot": "A23",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "SAMSUNG MZILS1T9HCHP/0NW",
        "serial": "S32CNCAH30####",
        "capacity": 1920383410176,
        "healthy": true,
        "temperature": 42
      }
    ],
    "temps": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 68,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 36,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 39,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 26,
        "temperatureUnits": "C"
      }
    ],
    "fans": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 5400,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 5400,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 4620,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 4680,
        "speedDescription": "Fan at third lowest speed"
      }
    ],
    "voltage": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 12.07
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 5.02
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 1.76
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 0.88
      }
    ],
    "powerSupply": {
      "predictedFailure": 0,
      "disabled": 0,
      "swap": 0,
      "status": "OK",
      "ident": 1,
      "doNotRemove": 0,
      "dcOverVoltage": 0,
      "dcUnderVoltage": 0,
      "dcOverCurrent": 0,
      "hotSwap": 0,
      "fail": 0,
      "requestedOn": 1,
      "off": 0,
      "overTemperatureFail": 0,
      "temperatureWarn": 0,
      "acFail": 0,
      "dcFail": 0
    },
    "alarm": {
      "predictedFailure": 0,
      "disabled": 0,
      "swap": 0,
      "status": "OK",
      "ident": 0,
      "fail": 0,
      "requestMute": 0,
      "mute": 0,
      "remind": 0,
      "toneIndicatorInfo": 0,
      "toneIndicatorNonCritical": 0,
      "toneIndicatorCritical": 0,
      "toneIndicatorUnrecoverable": 0
    }
  },
  "enclosureB": {
    "slots": [
      {
        "slot": "B0",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z303####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 28
      },
      {
        "slot": "B1",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKR####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 32
      },
      {
        "slot": "B2",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z300####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 29
      },
      {
        "slot": "B3",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKR####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 32
      },
      {
        "slot": "B4",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z301####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 29
      },
      {
        "slot": "B5",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKR####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 32
      },
      {
        "slot": "B6",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z301####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 29
      },
      {
        "slot": "B7",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "SAMSUNG MZILS1T9HCHP/0NW",
        "serial": "S32CNCAH30####",
        "capacity": 1920383410176,
        "healthy": true,
        "temperature": 33
      },
      {
        "slot": "B8",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKR####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 38
      },
      {
        "slot": "B9",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z307####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 37
      },
      {
        "slot": "B10",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKK####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 41
      },
      {
        "slot": "B11",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z300####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 38
      },
      {
        "slot": "B12",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKR####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 40
      },
      {
        "slot": "B13",
        "ledIsOn": false,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z301####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 36
      },
      {
        "slot": "B14",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EGZ####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 34
      },
      {
        "slot": "B15",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "SAMSUNG MZILS1T9HCHP/0NW",
        "serial": "S32CNCAH30####",
        "capacity": 1920383410176,
        "healthy": true,
        "temperature": 37
      },
      {
        "slot": "B16",
        "ledIsOn": true,
        "occupied": true,
        "family": "Seagate Desktop HDD.15",
        "model": "ST4000DM000-1F2168",
        "serial": "Z303####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 37
      },
      {
        "slot": "B17",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EG2####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 42
      },
      {
        "slot": "B18",
        "ledIsOn": false,
        "occupied": true,
        "family": "Hitachi/HGST Deskstar 7K4000",
        "model": "HGST HDS724040ALE640",
        "serial": "PK1300PAG0####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 42
      },
      {
        "slot": "B19",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EKS####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 42
      },
      {
        "slot": "B20",
        "ledIsOn": false,
        "occupied": true,
        "family": "Hitachi/HGST Deskstar 7K4000",
        "model": "Hitachi HDS724040ALE640",
        "serial": "PK2331PAGA####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 42
      },
      {
        "slot": "B21",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "HGST HUH728080AL4200",
        "serial": "2EK8####",
        "capacity": 8001563222016,
        "healthy": true,
        "temperature": 38
      },
      {
        "slot": "B22",
        "ledIsOn": false,
        "occupied": true,
        "family": "Hitachi/HGST Deskstar 7K4000",
        "model": "Hitachi HDS724040ALE640",
        "serial": "PK2331PAGH####",
        "capacity": 4000787030016,
        "healthy": true,
        "temperature": 36
      },
      {
        "slot": "B23",
        "ledIsOn": false,
        "occupied": true,
        "family": null,
        "model": "SAMSUNG MZILS1T9HCHP/0NW",
        "serial": "S32CNCAH30####",
        "capacity": 1920383410176,
        "healthy": true,
        "temperature": 40
      }
    ],
    "temps": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 68,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 40,
        "temperatureUnits": "C"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "otFailure": 0,
        "otWarning": 0,
        "utFailure": 0,
        "utWarning": 0,
        "temperature": 37,
        "temperatureUnits": "C"
      }
    ],
    "fans": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 5370,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 5340,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 4710,
        "speedDescription": "Fan at third lowest speed"
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "doNotRemove": 0,
        "hotSwap": 0,
        "fail": 0,
        "requestedOn": 1,
        "off": 0,
        "actualSpeed": 4680,
        "speedDescription": "Fan at third lowest speed"
      }
    ],
    "voltage": [
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 12.14
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 5.00
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 1.77
      },
      {
        "predictedFailure": 0,
        "disabled": 0,
        "swap": 0,
        "status": "OK",
        "ident": 0,
        "fail": 0,
        "warnOverVolt": 0,
        "warnUnderVolt": 0,
        "criticalOverVolt": 0,
        "criticalUnderVolt": 0,
        "voltage": 0.87
      }
    ],
    "powerSupply": {
      "predictedFailure": 0,
      "disabled": 0,
      "swap": 0,
      "status": "OK",
      "ident": 1,
      "doNotRemove": 0,
      "dcOverVoltage": 0,
      "dcUnderVoltage": 0,
      "dcOverCurrent": 0,
      "hotSwap": 0,
      "fail": 0,
      "requestedOn": 1,
      "off": 0,
      "overTemperatureFail": 0,
      "temperatureWarn": 0,
      "acFail": 0,
      "dcFail": 0
    }
  }
}

```