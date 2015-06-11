For quick instructions for use see [BioPatRec\_StartupGuide](BioPatRec_StartupGuide.md).

# Getting the data #

You first need to load data through the "Get Sig Features" botton. Doing this, there will be a window, which allows you to select the `*.mat` file of your interest. You can either load a previous recording session ([recSession](recSession.md)) or saved signal features ([sigFeatures](sigFeatures.md)). If you load some other kind of data the message _That was not a valid training matrix_ will be displayed.

  * Load a recording session
> If you load data of a recording session, the program will identify that through the variable [recSession](recSession.md) or _ss_ (the ss structure was used in [EMG\_AQ](EMG_AQ.md)). In case of _ss_ it will transform it into [recSession](recSession.md) in order to keep compatibility.
> The subfunction [Load\_recSession](Load_recSession.md) will be executed.

  * Load signal features
> In case you load signal features data, the program will recognize that through the variable [sigFeatures](sigFeatures.md) and will execute [Load\_sigFeatures](Load_sigFeatures.md).

NOTE: To do any real-time testing you must have configured your DAQ card, see [BioPatRec\_StartupGuide](BioPatRec_StartupGuide.md).