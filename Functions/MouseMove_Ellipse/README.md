# MouseMove_Ellipse [![](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://tldrlegal.com/license/gnu-affero-general-public-license-v3-(agpl-3.0)) <img src="https://img.shields.io/badge/AHK-1.0.*-brightgreen.svg" title="Ok" alt="AHK 1.0.* : Ok"/> <img src="https://img.shields.io/badge/AHK-1.1.*-brightgreen.svg" title="Ok" alt="AHK 1.1.* : Ok"/> <img src="https://img.shields.io/badge/AHK-2.0--a*-lightgray.svg" title="Untested" alt="AHK 2.0-a* : Untested"/>

## Usage
```pos_X1, pos_Y1 [, param_Options]```

#### Required Parameters
| Name | Description |
| :--- | :--- |
| pos_X1, pos_Y1 | Destination coordinates |

#### Optional Parameters
| Name | Description | Default |
| :--- | :--- | :--- |
| param_Options | String of options (see below) | blank |

The *param_Options* string may contain multiple options:

| Option | Description | Behaviour when not present in *param_Options* |
| :--- | :--- | :--- |
| "B" | Block mouse input while it's moving | Doesn't block by default |
| "i<b>0</b>" or "i<b>1</b>" | Clockwise "i<b>0</b>" or counterclockwise ("i<b>1</b>") movement | Random by default |
| "R" | Indicates that the destination coordinates should be relative | Not relative by default |
| "S<b>{number}</b>" | Movement speed (from 0 exclusive to 1 inclusive) | Defaults to 1 |
| "OX<b>{number}</b>" | Origin X coordinate | Defaults to the current mouse X coordinate |
| "OY<b>{number}</b>" | Origin Y coordinate | Defaults to the current mouse Y coordinate |

-----------------------

## Changelog

##### 2013-03-06
* Fixed case sensitive RegEx needles

##### 2010-09-20
* Corrected a mistake when using *loc_MultY* inside the if statement
* Converted most parameters into a string of options

##### 2010-09-12
* Renamed all variables for easier readability
* Added a parameter for blocking mouse input
* Added support to relative movements

##### 2010-08-16
* Initial release
