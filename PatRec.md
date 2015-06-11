# Pattern Recognition #

The pattern recognition module is organized in:

  * **Offline**: Training, validation and testing can be done using pre-recorded data.

  * **Realtime**: Needs the trained algorithm from the offline step in order to test it with real-time recordings.

For quick user instructions see [BioPatRec\_StartupGuide](BioPatRec_StartupGuide.md), or more detailed information in [GUI\_PatRec](GUI_PatRec.md). For a general overview of the functions involved see [BioPatRec\_Roadmap](BioPatRec_Roadmap.md).

## Algorithms ##
  * Signal Processing
    * [ICA](ICA.md) Independent Component Analysis

  * Feature selection
    * [PCA](PCA.md) Principal Component Analysis

  * Pattern Recognition
    * [DA](Discriminant_Analysis.md) Discriminant Analysis
    * [KNN](KNN.md) k-Nearest Neighbor Semi
    * [MLP](MLP.md) Multi-layers Perceptron
    * [RFN](RFN.md) Regulatory Feedback Networks
    * [SOM](SOM.md) Self-Organizing Map
    * [SSOM](SSOM.md) Supervised Self-Organizing Map

  * [Netlab](Netlab.md)
    * [GLM\_NL](GLM_NL.md) General Linear Model
    * [MLP\_NL](MLP_NL.md) Multi-layers Perceptron

## Offline PatRec ##

Most of the training phase is taking care by the function _OfflinePatRec_, which requires the variable [sigFeatures](sigFeatures.md).

  * **Creation of a matrix of feature vectors.** The first step is to extract the training and validation sets (see [xSets](xSets.md)). This directly affects the information to be used during the training and testing of the classifier. The [xSets](xSets.md) can be formed in different ways according to the _"Select Movements Mix"_ pop menu.
    * _All Mov_. This means that all the movements recorded will be used as independent movements, regardless if they are individual or mixed movements.
      * # Outputs = # Movements.
    * _Individual Mov_. This option will only consider the individual movements during the training phase. All movements will be considered in the testing phase.
      * # Outputs = # Individual movements.
    * _Mixed Out_. This means that the mixed classes (or simultaneous movements) will also be used during the training phase.
      * # Outputs = # Individual movements.
> > NOTE: Only _"All Mov"_ is available in [BioPatRec ETT](BioPatRec_Highlights#BioPatRec_ETT.md). The other options relate to simultaneous control which is available from [BioPatRec TVÅ](BioPatRec_Highlights#BioPatRec_TVA.md).

  * **[Normalization](Normalization.md)**. The training and validation sets are normalized according to the selected option.

  * **Creation of the classifier topology.** The same classifier can be constructed in different topologies, such as One-Vs-All, One-Vs-One, etc... see [PatRec\_Topologies](PatRec_Topologies.md) for details.

> NOTE: Only the _single classifier_ topology is available in [BioPatRec ETT](BioPatRec_Highlights#BioPatRec_ETT.md). The other options relate to simultaneous control which is available from [BioPatRec TVÅ](BioPatRec_Highlights#BioPatRec_TVA.md).

  * **Training of the classifier.** The OfflinePatRec function calls OfflinePatRecTraining to proceed with the classifier(s) training. The function OfflinePatRec returns the [patRec](patRec.md) structure containing all information required for further utilization of the classifier(s).

  * **Testing of the classifier.** A common function to all classifiers is used to evaluate the accuracy of the selected pattern recognition strategy (Accuracy\_patRec). These function uses the testing sets with unseen feature vectors for the classifier(s). Therefore it requires independent functions for
    * Normalization of a single an unseen feature vector (NormalizeSet) with the parameters created during the normalization of the training set.
    * Classification of a single feature vector with the classifier previously trained. This function is the classifier test routine and is called from OneShotPatRec, see below for the implementation of a new classifier.

> This framework allows the computation of the offline accuracy with the same routines later used for the Real-time classification. Therefore, if the implementation of a given classifier works offline, it will be work in real-time!

Automatic statistics can be generated using the menu _Statistics_, see [PatRec\_Statistics](PatRec_Statistics.md) for details.

## Real-time PatRec ##

The Real-time pattern recognition requires a trained classifier in the structure [patRec](patRec.md). The classifier will be tested with continuously recorded data.

  * Real-time PatRec (button)
    * Calls RealtimePatRec
    * Uses [patRec](patRec.md) and the GUI handles.
    * Returns the predicted movements to the GUI and the average processing time.

The real-time predictions can be couple with a prosthetic device or the virtual reality environment. see [GUI\_TestPatRec](GUI_TestPatRec.md) for operation.

The following tests of prediction and control performance can be used:

  * [Motion test](Motion_Test.md)
    * Calls MotionTest
    * Uses [patRec](patRec.md) and the GUI handles.
    * Returns ...

  * [Target Achievement Control (TAC) Test](TAC_Test.md)

NOTE: To do any real-time testing you must have configured your DAQ card, see [BioPatRec\_StartupGuide](BioPatRec_StartupGuide.md).

# Simultaneous Pattern Recognition #
or prediction of mixed-labels | mixed-labels | mixed-motions.

In order to evaluate the prediction of simultaneous movements you have to record such movements. Be sure that you used that option in the Recording Session GUI (SigRecordings).

NOTE: The feature of simultaneous control is available from version TVÅ.

# Adding a New PatRec Algorithm #

Create all the related functions (files) inside a new folder with a clear name for your new algorithm. This folder must be inside PatRec folder.

You will normally need at least 2 functions

  * One for **training** your algorithm
    * Your training function must take as input the [xSets](xSets.md) and returns the required information for further evaluation.
    * See OfflinePatRecTraining for examples of how other PatRec algorithms are called.

  * One for **testing** your trained algorithm
    * This function must receive a single feature vector and returns the predicted class or movement in _outMov_, and a vector with the probability of prediction for each class in _outVector_.
    * See OneShotPatRec for examples of how other PatRec algorithms are called.

You will have to modify the following routines:

  * `GUI_PatRec` (To add you algorithm in the GUI)
    * pm\_SelectAlgorithm (in `GUI_PatRec.fig`)
    * pm\_SelectTraining (in `GUI_PatRec.m`)
  * OfflinePatRecTraining (for training)
  * OneShotPatRec (for testing)

Take a look at OfflinePatRec to deeply understand how data is processed before reaching the PatRec algorithms in the OfflinePatRecTraining function. See [BioPatRec\_Roadmap](BioPatRec_Roadmap.md) for a general overview.