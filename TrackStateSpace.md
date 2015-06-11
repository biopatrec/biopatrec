# Introduction #

TrackStateSpace is a function that uses persistent variables to track the posture of the virtual limb during the [TAC\_Test](TAC_Test.md). This is done by using a three dimension representation of the posture, (_x,y,z_), where

  * _x_ : represents degrees (+-) from the initial position in the first DoF

  * _y_ : represents degrees (+-) from the initial position in the second DoF

  * _z_ : represents degrees (+-) from the initial position in the third DoF

Each time the [PatRec](PatRec.md) predicts new movements, the posture in the tracker is updated using the desired movements and speeds (the number of degrees to move the limb)

# Usage of TrackStateSpace #

The TrackStateSpace function is used in several steps during the course of the [TAC\_Test](TAC_Test.md), the different moments and their functions are described below.

First the tracker is initialized, then it tracks the posture during each repetition (target). All recorded trajectories are read from the tracker when the test is finished, and if the user wants they can be visualized with the [GUI\_SSPresentation](GUI_SSPresentation.md) GUI.

**Beginning of the TAC\_Test**
  * Initialize the tracker

**Loop during the TAC\_Test**
  * Set a target posture
  * Move the internal tracker
  * Read the path efficiency

**After the TAC\_Test**
  * Read the recorded trajectories
  * Visualize the recorded trajectories

## Initialize the tracker ##

The tracker is initialized in the beginning of the [TAC\_Test](TAC_Test.md) to set up the variables and generate the movement matrix [movMatrix](movMatrix.md).

This is done by calling:

_TrackStateSpace('initialize',patRec,allowance)_

where _patRec_ is the [PatRec](PatRec.md) structure used, and _allowance_ is the allowance used in the [TAC\_Test](TAC_Test.md).

### Set a target posture ###

Each repetition in the [TAC\_Test](TAC_Test.md) the subject is presented with a target posture, this is used as a cue to tell the tracker that a new repetition has started. This tells the tracker to create a new trajectory that starts from the initial position (0,0,0).

This is done by calling:

_TrackStateSpace('target',index, distance)_

where _index_ is a (1xN) vector containing the movement indices of the target and _distance_ the number of the degrees to the target.

### Move the internal tracker ###

Every time the [PatRec](PatRec.md) struct predicts new desired movements, the tracker needs to be aware of this. When the movements are presented to the tracker, the tracker updates the current posture using the movement matrix ([movMat](movMat.md)) and the speeds of the movements. The new posture is appended to the current trajectory.

To update the posture store in the tracker:

_TrackStateSpace('move',outMov, patRec.control.currentDegPerMov)_

where _outMov_ is provided by the [PatRec](PatRec.md) and _patRec.control.currentDegPerMov_ is the number of degrees to move (speeds).

### Read the path efficiency ###

One of the performance metrics that are provided by the [TAC\_Test](TAC_Test.md) is the [pathEfficiency](pathEfficiency.md). This measurement is based on the TrackStateSpace and is read at the end of each repetition.

To read the path efficiency from current repetition, use:

_pathEfficiency = TrackStateSpace('single')_

This will return a number even if the target never was reached, so be careful as the metric only is valid for completed repetitions.

## Read the recorded trajectories ##

The recorded trajectories ( one for each target ) can be read at any time and is done so at the end of a [TAC\_Test](TAC_Test.md). When the trajectories are read, they will be a part of a structure that contains various variables that makes it possible to visualize them.

To read the trajectories, use:

_tacTest.ssTracker = TrackStateSpace('read')_

The structure needs to be named ssTracker for the [GUI\_SSPresentation](GUI_SSPresentation.md) to function.

## Visualize the recorded trajectories ##

To visualize the trajectories stored during a tacTest one can use the [GUI\_SSPresentation](GUI_SSPresentation.md).

To open this GUI, simply type:

_GUI\_SSPresentation_

in the command window. The tacTest files are loaded from the GUI. Make sure that the file that is loaded includes a tacTest structure, which in turn is appended with a ssTracker structure.

The GUI was originally designed to visualize simulation results which explains the additional text fields, but it can never the less be used to visualize the results of the [TAC\_Test](TAC_Test.md).

# Warning #

The movement matrix [movMat](movMat.md) does currently only handle the movements

  * Open
  * Close
  * Flex
  * Extend
  * Pronate
  * Supinate

if any other movements are used in the [TAC\_Test](TAC_Test.md), or movements are altered using pop-menus in [GUI\_TestPatRec\_Mov2Mov](GUI_TestPatRec_Mov2Mov.md), the tracker will not work correctly.

TrackStateSpace use movements stored in the [patRec](patRec.md) to track the limb, while VRE uses the pop-menus in GUI\_TestPatRec\_Mov2Mov. If movements are changed in those pop-menus, the tracking will be completely different from what the VRE is showing.