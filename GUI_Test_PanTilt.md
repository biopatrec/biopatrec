## GUI\_Test\_Pan\_Tilt ##

The GUI GUI\_Test\_Pan\_Tilt was created to test the motors of the Pan, Tilt and manually change the pulse width modulation (PWM) for a given time for Pronation, Supination, Flex and Extend movements.

The GUI consists of 2 main parts:

## Initialize the serial connection ##
> There are 3 buttons (''Connect, Disconnect, Test connection'') which handles the communication
  * Connect: Calls "Connect\_ALC" which returns the communication object saved in the  handles as "com". The "com" object is necessary for all future   communication.
  * Test Connection: Calls "TestConnectionALC" which writes a 'C' and expects a 1 in return if the communication is successful.
  * Disconnect:  Close the 'com' object.


## Control ##

  * Pronate & Supinate: This is facilitated by the duty cycle of the PWM and the movement of the motor is proportional to the duty cycle from minimum to maximum.

  * Flex & Extend: This is facilitated by the duty cycle of the PWM and the movement of the motor is proportional to the duty cycle from minimum to maximum from other servo motor.

  * Step: Decides the angular displacement of the motor(in terms of duty cycle)

  * Center: Gets the servo motor position to the center of its maximum allowed angular displacement.