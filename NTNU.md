NOTE: This is an ongoing development and therefore the documentation is not yet finalized.

# Introduction #

These pages will contain a documentation of the contributions from **Norwegian University of Science and Technology** (NTNU). Since this still is a ongoing work, it will be separated from the main hierarchy at this moment.

At this instance, the purpose of this work, is to implement the functionality already in place at the lab at the Institute of Cybernetics at NTNU, over to the BioPatRec system.

The main area of development the last years, have been simultaneous proportional myoelectric control <sup>[1]</sup>.


# Details #

Currently, the model being developed, is split into four parts:
  * [Preprocessing](NTNU_Preprocessing.md)
  * [Intent interpretation](NTNU_Intent_interpretation.md)
  * [Output](NTNU_Output.md)
  * System training
    * [Screen guided training (SGT)](NTNU_Screen_guided_training.md)
    * [Prosthesis guided training (PGT)](NTNU_Prosthesis_guided_training.md)

Each of the three first parts, are representing the steps in the model from the work of Fougner <sup>[1]</sup>, and beside the model is a scenario of simultaneous proportional control, see figure under this paragraph. The last part, system training, is containing information about the training of the system, thereof [SGT](NTNU_Screen_guided_training.md) and [PGT](NTNU_Prosthesis_guided_training.md). In the figure being shown, the system training is fed into part 4 during the offline-training of the algorithms.

![https://biopatrec.googlecode.com/svn/wiki/img/Prosthesis_Control_Model_and_SimProp2D.jpg](https://biopatrec.googlecode.com/svn/wiki/img/Prosthesis_Control_Model_and_SimProp2D.jpg)

# Source code #

  * [BioPatRec ETT NTNU](https://drive.google.com/file/d/0B7walwEpPjq3MnFxem5WaWxFSTQ/edit?usp=sharing)
# References #
  1. Fougner, Anders. Robust, Coordinated and Proportional Myoelectric Control of Upper-Limb Prostheses. Diss. Norwegian University of Science and Technology, 2013.