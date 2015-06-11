# Introduction #

In order to test the VRE you can use the GUI\_Test\_VRE. This interface is a very simple program that simply sends the values in the five textboxes over the socket communication that is established using the connect-button.

### Starting up ###
Starting the GUI, you can choose to start the program (the VRE) and then click connect to connect to it. The reason these are not done as one step is that it is possible to connect a system that has already been started.

### Using the GUI ###
When wanting to use the GUI you can send any values to the VRE. This includes all configurations, TAC-tests etc. This means that it is an ideal environment to test and make sure that the VRE works as intended.

### Using for Debugging ###
The test GUI is especially good for when debugging the connection between MATLAB and the VRE. This since it once the system (VRE) has started, it needs a socket communication to run. If MATLAB crashes before it has started up the connection, the VRE will look for a connection that will not be made. In this case the test GUI can be used to only connect to the system.


---


# The Code #
The code of the GUI is extremely simple. When sending values the strings from the five textboxes are retrieved and converted, only if needed, to characted values. These values are then sent on to the connected VRE.



---


# Known Errors #
There are a few known errors of the program. These are not high priority since the GUI is to be used for debugging purposes only.

### Connecting ###
If you press connect and you do not have any other software to connect on the given port, MATLAB may crash.

### Sending Values ###
If you have not connected to any system and you click the "Send Values", the following error will be generated in MATLAB;
**Reference to non-existent field 'com'.**
