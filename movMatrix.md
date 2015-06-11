# Introduction #

The movMatrix is a matrix used by TrackStateSpace to update the internal posture tracker during the [TAC\_Test](TAC_Test.md). This matrix is created when the [TrackStateSpace](TrackStateSpace.md) function is initialized, and represents the different movements that has been stored in the [PatRec](PatRec.md) structure.

# Details #

movMatrix is created with

_movMatrix = CreateMovMatrix(patRec)_

The movMatrix is a (Nx3)-matrix where N is the number of outputs from the [patRec](patRec.md)-struct that was used to create it.

The rows contains 1 or -1 depending on which direction that the virtual limb is moved in respective DoF.


# Warning #

The movement matrix [movMat](movMat.md) does currently only handle the movements

  * Open
  * Close
  * Flex
  * Extend
  * Pronate
  * Supinate

if any other movements are used in the [TAC\_Test](TAC_Test.md), or movements are altered using pop-menus in [GUI\_TestPatRec\_Mov2Mov](GUI_TestPatRec_Mov2Mov.md), the movMatrix will not be created correctly and the tracking will fail.