# Motors communication protocol #

There are two ways to control the output to the motors.

  * Using the objects for movements and motors ([GUI\_TestPatRec\_Mov2Mov](GUI_TestPatRec_Mov2Mov.md)), see [Movements\_Protocol](Movements_Protocol.md).
    * The [GUI\_TestPatRec\_Mov2Mov](GUI_TestPatRec_Mov2Mov.md) will be loaded using the Load\_patRec function including "1" as the last parameter.

  * Hard-coded relationships ([GUI\_TestPatRec\_Mov2MotDir](GUI_TestPatRec_Mov2MotDir.md))
    * It uses the selected values of the pop-lists to make the protocol correlations.

The activation of the motors in either way, is performed inside the RealTimePatRec routine. In order to reduced the data transfer and allow real-time control, the activation or deactivation of the motors is only performed when the related movements is turned on or off.

## Protocol ##

| ID Character | Controller PWM | Values | Notes |
|:-------------|:---------------|:-------|:------|
| A            | PWM1A          | 1 to 100 |Configured in MCU for DC motors |
| B            | PWM1B          | 1 to 100 |Configured in MCU for DC motors |
| C            | PWM2A          | 1 to 100 |Configured in MCU for DC motors |
| D            | PWM2B          | 1 to 100 |Configured in MCU for DC motors |
| E            | PWM3A          | 1 to 100 |Configured in MCU for DC motors |
| F            | PWM3B          | 1 to 100 |Configured in MCU for DC motors |
| G            | PWM4A          | 1 to 100 |Configured in MCU for DC motors |
| H            | PWM4B          | 1 to 100 |Configured in MCU for DC motors |
| I            | PWM5A          | 1 to 100 |Configured in MCU for DC motors |
| J            | PWM5B          | 1 to 100 |Configured in MCU for DC motors |
| K            | PWM6A          | 1 to 100 |Configured in MCU for Servo motors|
| L            | PWM6B          | 1 to 100 |Configured in MCU for Servo motors|


### DC motors ###

1) Send 'D'

2) Send PWM ID character

3) Send Duty cycle PWM1

4) Send Duty cycle PWM2

5) Read '1' as the acknowledgement for the successful communication.

Note: The motor driver used for the DC motors requires two PWMs, therefore two duty cycles are send when activation/deactivation of the DC motors is require. If you were to change the motor driver, and the new one only requires one PWM, then you can send "S" instead of "D", see below.

### Servo motors ###

1) Send  'S'

2) Send PWM ID,

3) Send Duty cycle

4) Read '1' as the acknowledgement for the successful communication.


NOTE: When sending 'S' any PWM could be updated using the PWM ID, not only the 'K' and 'L' reserved for the servo motors.

# Functions Roadmap #

### Object-oriented ###
  * MotorsOn / MotorsOff
    * Update2PWMusingSCI (DC motors)
    * UpdatePWMusingSCI\_PanTilt (Servo motors)

### Hard-coded ###
  * ActivateMotors
    * Update2PWMusingSCI (DC motors)
    * Not working for servo motors

# Testing GUIs #
  * [GUI\_TestPWMs](GUI_TestPWMs.md)
  * [GUI\_Test\_Hand](GUI_Test_Hand.md)
  * [GUI\_Test\_PanTilt](GUI_Test_PanTilt.md)