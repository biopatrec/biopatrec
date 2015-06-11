# Introduction #
The idea behind the protocol is to have an easy system that can be easily implemented onto any existing system, not only the [VRE](VRE.md), like for this case.

To limit the amount of data being sent each transfer, each DoF is set up within the [VRE](VRE.md) and is handled separately. So to perform a movement only one transfer is needed.

## Protocol ##
The protocol consists of four bytes being transferred each time. The different setups are shown, and explained, in the table below:

|`[Byte]` - Operation|Value #1|Value #2|Value #3|
|:-------------------|:-------|:-------|:-------|
|`[1]` - Movement of hand|Indicating which DoF|Indicating which direction to move|Indicating distance to move in given direction|
|`[2]` - Movement of TAC|Indicating which DoF|Indicating which direction to move|Indicating distance to move in given direction|
|`[c]` - Configuration|See below|for more|information.|
|`[r]` - Reset position|If set to `[t]`, resets position of TAC. Otherwise the normal hand.|Not specified.|Not specified.|

An example of the protocol is given:
```
'1215' - The normal hands 2nd DoF is extended 5 steps.
'2303' - The TAC hands 3rd DoF is flexed 3 steps.
'rt00' - The position of the TAC hand is reset.
```

## Configurations ##

If anything needs to be configured in the Virtual Reality Environment, a configuration parameter can be sent in order to change vital parameters without editing the code.

Below are all the codes with a short explanation of how to use it.

In order to edit any information you must first send c as the Operation Byte. (see above) Once that is set the three possible values can be used, as shown in the table below, to edit the values of the VRE.

|Value #1|Value #2|Value #3|Description|
|:-------|:-------|:-------|:----------|
|1       |relativeDistance|(not used)|Changing this will change the distance each movement step will move.|
|2       |Perform TAC|1/0     |Set the value #3 to 1/0 depending on if you want to perform the TAC test.|
|3       |Allowance|(not used)|Set the allowed distance that the user can be from the TAC test in order for it to still be classified as completed.|
|4       |Camera  |(not used)|Set which camera to look through.|

## DoF Map ##

Information regarding which DoF corresponds to which movements can be found in the table below.

|DoF|Movement|
|:--|:-------|
|1  |Pinky - Pitch|
|2  |Ring - Pitch|
|3  |Long - Pitch|
|4  |Index - Pitch|
|5  |Thumb - Pitch|
|6  |Thumb - Yaw|
|7  |Palm - Pitch|
|8  |Palm - Roll|
|9  |Open/Close Hand|