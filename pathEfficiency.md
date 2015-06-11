# Introduction #

During each repetition of the [TAC\_Test](TAC_Test.md) the position of the virtual limb is tracked in Matlab using the [TrackStateSpace](TrackStateSpace.md) function. The positions stored during the repetition ( one target ) is then used to calculate how efficiently the user reached the target.

The calculation is based on the fact that the posture of a 3 DoF virtual limb can be represented by a three dimensional vector (_x,y,z_), where

  * _x_ : represents degrees (+-) from the initial position in the first DoF

  * _y_ : represents degrees (+-) from the initial position in the second DoF

  * _z_ : represents degrees (+-) from the initial position in the third DoF


1 and 2 DoF limbs are also fine as they will count as stationary in the additional DoFs. However, this calculation does currently not support limbs that can move in more than 3 DoFs.

# Calculation #

The path efficiency is calculated as

**if repetition was completed**

> pathEfficiency = _round( (perfectPath / userPath) x 1000 ) / 1000_;

**else if repetition failed**

> pathEfficiency = NaN


This calculation makes sure that the efficiency becomes 1 if the traveled path is the same as the perfect path. All deviations from the perfect path will result in a lower efficiency. Rounding is due to problems that made it possible for the score to be larger than one in some circumstances.

**perfectPath**: Length of a perfect path from starting to the target posture. Calculated with [CalculatePathLength](CalculatePathLength.md) by inserting the starting posture (0,0,0) _(currently hard-coded)_ and the target posture (X,Y,Z).

**userPath**: Length of the recorded path during the repetition. Calculated with [CalculatePathLength](CalculatePathLength.md) by inserting the matrix that contains all coordinates visited during the last repetition.


# Warnings #

  * The _perfect path_ is calculated with a hard coded value of the initial position of the virtual limb (0,0,0). If the [TAC\_Test](TAC_Test.md) is modified to start a repetition at another posture this calculation will generate the wrong path efficiency.

  * The [TAC\_Test](TAC_Test.md) currently sends the movements predicted by [PatRec](PatRec.md) to both the virtual reality environment ([VRE](VRE.md)) and the [TrackStateSpace](TrackStateSpace.md) function. This means that these two instances currently track the posture independently of each other. It can happen that these postures do not coincide, typically the virtual reality environment can update too slow, causing the visual representation of the posture not being the same as the tracked. This can cause some problems if one tries to alter the time increment, the frequency at which the [PatRec](PatRec.md) makes predictions.

  * The [TrackStateSpace](TrackStateSpace.md) function uses the [movMatrix](movMatrix.md) to track movements of the virtual limb. This matrix can currently only handle the movements
    * Open
    * Close
    * Flex
    * Extend
    * Pronate
    * Supinate
> If any other movements are used in the [TAC\_Test](TAC_Test.md) the metric will fail.

  * The [movMatrix](movMatrix.md) moves the [TrackStateSpace](TrackStateSpace.md) intenaltracker based on the trained movements in the [PatRec](PatRec.md) structure, while the virtual reality environment moves the limb according to the pop\_menus in [GUI\_TestPatRec\_Mov2Mov](GUI_TestPatRec_Mov2Mov.md). This means that if any pop\_menus are altered, tracking is not done properly and this metric may fail.