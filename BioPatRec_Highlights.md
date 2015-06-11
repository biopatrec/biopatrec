# BioPatRec Highlights #

BioPatRec is a modular platform implemented in MATLAB that allows a seamless integration of a variety of algorithms in the fields of

  1. Signal processing
  1. Feature selection and extraction
  1. Pattern recognition
  1. Real-time control

All these in the context of prosthetic control.

BioPatRec itself includes all the necessary routines for prosthetic control based in pattern recognition; from data acquisition to real-time evaluations, including a virtual reality environment and pattern recognition algorithms (see below for all features).

We demonstrate BioPatRec with the real-time control of a virtual hand and multifunctional prosthetic devices (see the videos below).

## General features ##
  * **Modular.** As long as the data structures for information transfer are respected, any module could be substituted.
  * **Customizable.** As a result of the modular design, BioPatRec can be adapted to different experimental settings.
  * **User friendly.** The use of graphical user interfaces (GUIs) facilitates BioPatRec utilization. Moreover, a considerable amount of documentation is available in this wiki for its operation.

## Features per release and module ##

### BioPatRec ETT ###
Available online in the "Downloads" tab.

  * **Recordings**
    * Dedicated GUI for customization of the recording sessions:
      * Recording device, channels and sampling frequency
      * Number and type of movements
      * Contraction time (cT) and resting time (rT)
    * Recording sessions with visual cues (images and progress bars)
    * Dedicated GUI to load and display recording sessions
    * Signals displayed in time and frequency domains.
    * Graphical navigation tools available (time and frequency range selection, zoom, pan, etc..)
    * Frequency and spatial filters available

  * **Signal treatment and feature extraction**
    * Dedicated GUI for signal processing
    * Movements and channels selection
    * Addition of “rest” as the state of no movements
    * Frequency and spatial filters
    * Signal Segmentation
      * Non-overlapped with selectable _Time Window_
      * Constant overlap with selectable _Time Window_ and _overlap_
    * Customizable construction of the training, validation and testing sets
    * Over 21 time and frequency signal features available
    * Signal treatment and features extraction per single recording sessions, or a group.

  * **Pattern Recognition**
    * Easy selection of signal features
    * Customization of the training, validation and testing sets
    * Pattern recognition and training algorithms (see PatRec)
      * Discriminant Analysis
        * Linear and diagonal linear
        * Quadratic and diagonal quadratic
        * Mahalanobis
      * Artificial Neural Networks - Multilayer Perceptron (MLP) trained by:
        * Back-propagation (BP)
        * Particle Swarm Optimization (PSO)
      * Regulation Feedback Networks (RFN) trained by:
        * Mean
        * Mean + PSO
        * Exclusive mean
    * Different normalization methods
      * Mean 0, Variance 1
      * 0 to 1
      * -1 to 1
    * Optional randomization of data sets
    * Display of accuracy per movement and confusion matrix
    * Automatic computation of pattern recognition statistics (see [PatRec\_Statistics](PatRec_Statistics.md))
    * Real-time testing
      * Motion Test
      * Target Control Achievement

  * **Control**
    * Control algorithms:
      * Major voting
      * Buffer output

  * **Virtual Reality Environment** ([VRE](VRE.md))
    * A virtual lower arm with 7 degrees of freedom

### BioPatRec TVA ###

Pre-release available upon request.

The TVÅ version contains all features of BioPatRec ETT, plus:

  * **Recordings**
    * A virtual limb can now display the requested motion to facilitate the user instructions (Screen-Guided Training, SGT).

  * **Signal Treatment**
    * Automatic computation of the "exact" number of time windows available (GUI\_SigTreatment). Before, it was likely that you had to complete the total amount manually.

  * **Pattern Recognition**
    * Simultaneous pattern recognition / Pattern recognition of mixed classes
    * Different methods to construct the [xSets](xSets.md) (see PatRec), especially useful for simultaneous movements.
    * Different classifier topologies (see [PatRec\_Topologies](PatRec_Topologies.md))
    * New algorithms
      * [MLP\_th](MLP_th.md)
      * [SOM](SOM.md)
      * [SSOM](SSOM.md)

  * **Control**
    * New control algorithms:
      * Velocity Ramp

  * **Virtual Reality Environment** ([VRE](VRE.md))
    * The communication now handles fractions
    * Virtual arm
    * Left/Right arms

  * **Real-time tests
    * The Motion Test is now facilitated by using the VRE**

  * **Game Control**

See the [Important\_coding\_changes](Important_coding_changes.md)

### BioPatRec TRE (coming soon) ###

  * **Recordings**
    * Ramp
    * New recording GUI for an unlimited amount of channels

  * **Signal Treatment**
    * Downsampling option
    * Scaling option (to ADC resolution 2^[n-1])

  * **Pattern Recognition**
    * New algorithms
      * [PCA](PCA.md)
      * [ICA](ICA.md)
    * Computation of sensitivity, precision, specificity, NPV, F1

See the [Important\_coding\_changes](Important_coding_changes.md)

### BioPatRec FRA (coming later) ###

  * **Recordings**
    * Proportional

  * **Signal Treatment**
    * Noise addition

  * **Pattern Recognition**
    * New algorithms
      * [KNN](KNN.md)
      * [SVM](SVM.md)

See the [Important\_coding\_changes](Important_coding_changes.md)

# Demonstrations #
Note: If the following videos are not displayed, be sure that you are allowing your browser to run scripts. You will find a little "shield" icon on the top-right of your browser if you are using Chrome. Click it, and allow the scripts.

## Used for the treatment of PLP ##

<a href='http://www.youtube.com/watch?feature=player_embedded&v=0wp-SigTeLs' target='_blank'><img src='http://img.youtube.com/vi/0wp-SigTeLs/0.jpg' width='425' height=344 /></a>

[Link to the scientific article](http://journal.frontiersin.org/Journal/10.3389/fnins.2014.00024/abstract)

## Initial testing of simultaneous control ##

<a href='http://www.youtube.com/watch?feature=player_embedded&v=6W5plVzXe1k' target='_blank'><img src='http://img.youtube.com/vi/6W5plVzXe1k/0.jpg' width='425' height=344 /></a>

## Evaluation of simultaneous control ##

<a href='http://www.youtube.com/watch?feature=player_embedded&v=SQ5CYrjAUP0' target='_blank'><img src='http://img.youtube.com/vi/SQ5CYrjAUP0/0.jpg' width='425' height=344 /></a>

## Initial testing of a multifunctional prosthesis ##

<a href='http://www.youtube.com/watch?feature=player_embedded&v=nxPToKzuXF4' target='_blank'><img src='http://img.youtube.com/vi/nxPToKzuXF4/0.jpg' width='425' height=344 /></a>

## Initial testing of the Virtual Reality Enviroment ##

<a href='http://www.youtube.com/watch?feature=player_embedded&v=nBixj_vEOQo' target='_blank'><img src='http://img.youtube.com/vi/nBixj_vEOQo/0.jpg' width='425' height=344 /></a>

## Demonstration of Game Control ##
<a href='http://www.youtube.com/watch?feature=player_embedded&v=PHK8slnn2Us' target='_blank'><img src='http://img.youtube.com/vi/PHK8slnn2Us/0.jpg' width='425' height=344 /></a>