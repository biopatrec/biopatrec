# Introduction #

The GUI\_SSPresentation is an auxiliary GUI that can be used to visualize  trajectories and targets that have been recorded during the [TAC\_Test](TAC_Test.md).

The GUI was initially designed for a different purpose and is thus not optimal for viewing results from the [TAC\_Test](TAC_Test.md), yet very useful.

# Usage #

To open the GUI, write

_GUI\_SSPresentation_

in the command line. Load a tacTest file by clicking the folder located in the toolbar.

The different repetitions are currently available in the Movement-listbox, not in the Repetition-listbox as one might think. Select the desired repetition and view the trajectory.

The target is currently only visualized in the 2D-viewports (as a green circle).

In the _Path Lengths_ panel one can read the [pathEfficiency](pathEfficiency.md), _Current_ gives the [pathEfficiency](pathEfficiency.md) for current repetition and _Setup_ gives the average [pathEfficiency](pathEfficiency.md) for the entire tacTest.