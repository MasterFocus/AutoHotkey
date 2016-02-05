# FloatToFraction [![](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://tldrlegal.com/license/gnu-affero-general-public-license-v3-(agpl-3.0)) <img src="https://img.shields.io/badge/AHK-1.0.*-brightgreen.svg" title="Ok" alt="AHK 1.0.* : Ok"/> <img src="https://img.shields.io/badge/AHK-1.1.*-brightgreen.svg" title="Ok" alt="AHK 1.1.* : Ok"/> <img src="https://img.shields.io/badge/AHK-2.0--a*-lightgray.svg" title="Untested" alt="AHK 2.0-a* : Untested"/>

## Usage
```p_Input [, p_MinRep, p_MinPatLen, p_MaxPatLen]```

#### Required Parameters
| Name | Description |
| :--- | :--- |
| p_Input | A positive integer or floating-point number |

#### Optional Parameters
| Name | Description | Default | Explanation (default value) |
| :--- | :--- | :--- | :--- |
| p_MinRep | Minimum times a pattern should appear<br>to be considered a repetition | 2 | "0.6533" will be considered "0.6533333...",<br>but "0.653" will not |
| p_MinPatLen | Minimum length of a pattern | 1 | The repeating pattern can be a single digit,<br>like "0.42[5][5]..." |
| p_MaxPatLen | Maximum length of a pattern | 15 | The pattern matching will match<br>"0.[123456789012345][123456789012345]..." |

-----------------------

## Changelog

##### 2012-11-20
* General fixes and improvements (I actually can't remember what changed :sweat_smile:)

##### 2012-10-29
* Initial release
