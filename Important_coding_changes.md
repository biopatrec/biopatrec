# From ETT to TVÅ #

## Additional variable for OfflinePatRec: algConf ##
Since [SOM](SOM.md) and [SSOM](SSOM.md) needed special configurations, the struct variable _algConf_ is now available for transiting configuration parameters. The calling of the following routines was modified to include the _algConf_ variable inmediatly after _tType_.

  * `OfflinePatRec`
  * `OfflinePatRecTraining`

In order to use the struct _algConf_, just save it in the [GUI\_PatRec](GUI_PatRec.md) handles. The it will be sent to `OfflinePatRec` by `pb_RunOfflineTraining_Callback`. This variable is saved inside patRec.patRecTrained.

## Control algorithms ##

The way the control algorithms are added changed. See: [Control](Control.md) for details


# From TVÅ to TRE #

## Additional variables for recSession: RampParameters ##
In order to implement the ramp recording session was necessary to add several variables to the recSession structure. For further detail check out the new data structure at [recSession](recSession.md).

## Functions for other custom acquisition devices ##
In BioPatRec\_TRE are available a new set of functions useful to implement your own custom acquisition device and use it during your PatRec sessions. Check out into the [COMM](COMM.md) section.

## new recording GUI ##
A new GUI is now available for your recording session. To do that, it has been necessary to make several little changes in functions such as DataShow, RecordingSession etc..