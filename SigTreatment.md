NOTE: we are currently on the documentation process

# Signal Treatment #

The signal treatment module contains routines to:

  * Remove movements and channels which are of no interest (for any reason)
  * Remove transient periods of the contraction (if required). This is done by selecting a contraction time percentage (cTp) between 0 and 1. A cTp of 0.7 is recommended as it includes part of the transient period. The following picture illustrates its effect:

![https://biopatrec.googlecode.com/svn/wiki/img/Biopatrec_paper/cTp.jpg](https://biopatrec.googlecode.com/svn/wiki/img/Biopatrec_paper/cTp.jpg)
> _[Fig. 2 from BioPatRec paper](http://www.scfbm.org/content/8/1/11)_


  * Add the _no movement_ or _rest_ condition as a movement automatically from the recorded session.
  * Apply filters
    * Frequency
      * Power line harmonics
      * Band-pass 20-1k Hz
      * Band-pass 70-1k Hz
    * Spatial (requires specific electrode placement)
      * Single differential (SDF)
      * Double differential (DDF)
      * Absolute double differential (DDF Abs)
  * Window segmentation settings
    * overlap or non-overlap
    * time window length
    * overlap (if required)
    * Number of time windows per set (training, validation and testing)

![https://biopatrec.googlecode.com/svn/wiki/img/Biopatrec_paper/Biopatrec_siganlprocessing_timewindow.png](https://biopatrec.googlecode.com/svn/wiki/img/Biopatrec_paper/Biopatrec_siganlprocessing_timewindow.png)
> _[Fig. 3 from BioPatRec paper](http://www.scfbm.org/content/8/1/11)_

These functions are easily accessible from the [GUI\_SigTreatment](GUI_SigTreatment.md) which is loaded by the [Load\_patRec](Load_patRec.md) function requiring [recSession](recSession.md). Once the signal segmentation is accomplished, feature extraction continues [SigFeatures](SigFeatures.md). Additionally, filters can also be called in the GUI\_Recordings for one-shot recordings.

See [BioPatRec\_StartupGuide](BioPatRec_StartupGuide.md) for quick user instructions and [BioPatRec\_Roadmap](BioPatRec_Roadmap.md) for an overview of the functions involved.

Currently, signal treatment and feature extraction are embedded in the same GUI ([GUI\_SigTreatment](GUI_SigTreatment.md)). However, since an intermediate structure ([sigTreated](sigTreated.md)) is created before proceeding with [SigFeatures](SigFeatures.md), these two process can be easily split into different GUIs (if required). We haven't seen the need for that though.

A summary of features can be find in [BioPatRec\_Highlights](BioPatRec_Highlights.md).

The following illustration shows how the myoelectric signals were treated in the [BioPatRec paper](http://www.scfbm.org/content/8/1/11) experiment.

![https://biopatrec.googlecode.com/svn/wiki/img/Biopatrec_paper/Biopatrec_signaltreatment.png](https://biopatrec.googlecode.com/svn/wiki/img/Biopatrec_paper/Biopatrec_signaltreatment.png)
> _[Fig. 7 from BioPatRec paper](http://www.scfbm.org/content/8/1/11)_

# More signal treatment? #

Since all the raw data and setting of its acquisition are available in the structure [recSession](recSession.md), additional signal processing can be easily implemented.

## Adding a new filter ##

This can be easily done by following these steps:

  * Add the filter name/ID in [GUI\_SigTreatment](GUI_SigTreatment.md), either
    * pm\_frequencyFilters, or
    * pm\_spatialFilters
> This is done by using the instruction "guide" from the MATLAB command window. Then open the figure [GUI\_SigTreatment](GUI_SigTreatment.md), double click on the desired pop menu, and modify the property "string" to add the name/ID of your filter.
  * Add the call to your filtering function in ApplyFilters.

Take a look to ApplyFilters to see how the current filters are called. All information you require are provided in [sigTreated](sigTreated.md).