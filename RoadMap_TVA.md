# Introduction #

This is a quick and general overview of the most relevant functions used in BioPatRec. These are functions or GUIs names.

# Recordings (SigRecordings) #

## GUI\_Recordings ##

  * [pb\_StartRecording](pb_StartRecording.md) (Start Recording)
    * [DAQShow\_SBI](DAQShow_SBI.md)
      * [InitSBI\_NI](InitSBI_NI.md)

  * [pb\_ApplyButter](pb_ApplyButter.md) (Apply Butter)
    * [ApplyButterFilter](ApplyButterFilter.md)

  * Menus
    * File
      * Load
        * DataShow or,
        * GUI\_RecordingSessionShow
        * Compatibility\_recSession (if necessary)
    * Recordings
      * One-shot
        * pb\_StartRecording
      * Recording Session
        * GUI\_RecordingSession
    * Filters
      * ...
      * ...

## GUI\_Recording Session ##

  * pb\_Record
    * calls GUI\_Recordings
    * calls GUI\_AFEselection
      * pb\_record (GUI\_AFEselection)
        * RecordingSession
          * for SBI - NI
            * InitSBI\_NI
            * DataShow

## GUI\_RecordingSessionShow ##

  * pb\_Load
    * DataShow

# Signal Treatment (SigTreatment) #

  * pb\_preProcessing (in GUI\_SigTreatment, and uses [recSession](recSession.md))
    * PreProcessing
      * Split\_recSession\_Mov
      * Split\_recSession\_Ch
      * RemoveTransient\_cTp (returns [sigTreated](sigTreated.md))
      * AddRestAsMovement (uses [recSession](recSession.md) and complements [sigTreated](sigTreated.md))

  * pb\_treat (in GUI\_SigTreatment, and uses [sigTreated](sigTreated.md))
    * TreatData
      * ApplyFilters
        * [Filters](Filters.md)
      * GetData (returns sets of raw signal trData, vData and tData)
        * Time window cutting (Non-overlapped, Overlapped cons, etc..)

  * Signal features extraction proceeds (see below)

  * pb\_treatFolder
    * Same than pb\_treat but for a set of files located in a specific folder. The files must be named: 1, 2, 3,...

# Signal Features (SigFeatures) #

  * GetAllSigFeatures (uses [xData](xData.md) and returns [sigFeatures](sigFeatures.md))
    * GetSigFeatures
      * Calls every feature computation routines `GetSigFeatures_xxx`

# Pattern Recognition (PatRec) #

  * Main GUI: [GUI\_PatRec](GUI_PatRec.md)

  * OfflinePatRec
    * Rand\_sigFeatures
    * Get the [xSets](xSets.md)
      * GetSets\_Stack, or
      * GetSets\_Stack\_IndvMov, or
      * GetSets\_Stack\_MixedOut
    * Normalize\_TrV
    * Creates ([PatRec\_Topologies](PatRec_Topologies.md))
    * OfflinePatRecTraining (returns [patRec](patRec.md))
      * xTraining routines (MLP, LDA, etc...)
    * [Accuracy\_patRec](Accuracy_patRec.md) (uses [patRec](patRec.md))
      * NormalizeSet
      * OneShotPatRecClassifier
        * Calls ([PatRec\_Topologies](PatRec_Topologies.md))
          * OneShotPatRec
            * xTest routines

  * RealtimePatRec (uses [patRec](patRec.md))
    * InitSBI\_NI
    * [SignalProcessing\_RealtimePatRec](SignalProcessing_RealtimePatRec.md)
      * ApplyFilters
      * GetSigFeatures
      * NormalizeSet
    * OneShotPatRecClassifier
      * Calls ([PatRec\_Topologies](PatRec_Topologies.md))
        * OneShotPatRec
          * xTest routines

# Control Algorithms #

see [Control](Control.md)

  * InitControl
  * ApplyControl

> Used inside of:
    * RealtimePatRec
    * MotionTest
    * TACTest

# Device Control #

see [Motors\_Protocol](Motors_Protocol.md)

### Object-oriented (OOP) ###
  * Move buttons at GUI\_TestPatRec\_Mov2Mov
    * MoveMotor (GUI)
      * Update2PWMusingSCI (DC motors)
      * UpdatePWMusingSCI\_PanTilt (Servo motors)
  * RealtimePatRec
    * MotorsOn / MotorsOff (real-time)
      * Update2PWMusingSCI (DC motors)
      * UpdatePWMusingSCI\_PanTilt (Servo motors)

  * Using Standard Prosthetic Components (SPC) and wifi
    * Move buttons at GUI\_TestPatRec\_Mov2Mov
      * MoveMotorWifi
        * ActivateSP\_FixedTime
    * RealtimePatRec
      * MotorsOn\_SPCwifi
      * MotorsOff\_SPCwifi

### Non-OOP ###
  * ActivateMotors
    * Update2PWMusingSCI (DC motors)
    * Not working for servo motors