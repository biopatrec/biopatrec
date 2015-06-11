SigRecordings -> SigTreatment -> SigFeatures -> PatRec

# Recordings #

BioPatRec allows the recording of bio-electric signals through different devices which are already configured (e.g. NI-USB6009), or can be added in [Comm](Comm.md).

Recordings can be done as a single time-defined event for fast signal quality evaluation; as a recording session for further processing and PatRec; and as continues recordings for real-time control. There are specific GUIs for each of them. See [BioPatRec\_StartupGuide](BioPatRec_StartupGuide.md) for quick user instructions and [BioPatRec\_Roadmap](BioPatRec_Roadmap.md) for an overview of the functions involved.

A recording session will generate a [recSession](recSession.md) structure, which can be later used for signal treatment (SigTreatment).

For tips on how to record surface EMG see [sEMG](sEMG.md)

# Recording Session #

The recording session is facilitated by a GUI showing the user which motions need to be executed. In "BioPatRec ETT", this is done by displaying images and a progress bar that decreases according to the time left for either contraction or relaxation. In "BioPatRec Två", since simultaneous motions were also included, a virtual limb can also be selected to display the requested motions. In "BioPatRec TRE", a new recording GUI is available and it has been added the possibility to do ramp recording sessions.

The following illustration is an example of the recording session GUI in the [BioPatRec paper](http://www.scfbm.org/content/8/1/11) experiment.

![https://biopatrec.googlecode.com/svn/wiki/img/BioPatRec_TRE/Biopatrec_TRE_recordingsession.png](https://biopatrec.googlecode.com/svn/wiki/img/BioPatRec_TRE/Biopatrec_TRE_recordingsession.png)
> _[Fig. 6 from BioPatRec paper](http://www.scfbm.org/content/8/1/11)_

## Ramp Recording Session ##
This is similar to the standard recording session but using an increasing muscular effort. During the recording session the subject is guided by a visual indicator to gradually increase the contraction effort over time (ramp-like).

![https://biopatrec.googlecode.com/svn/wiki/img/BioPatRec_TRE/Biopatrec_TRE_ramptracking.png](https://biopatrec.googlecode.com/svn/wiki/img/BioPatRec_TRE/Biopatrec_TRE_ramptracking.png)

The system instantaneously calculates the level of effort of the user and displays it on the ramp, giving a feedback to the user by which is possible to manage the correct variation of effort during the recording. In order to calculate the "amount of effort" and to be able to represent it on the guide ramp, the system needs two more recording sessions that must be made necessarily before the main recording. At first, user is asked to remain in a relaxed position, so acquiring the minimum voluntary contraction. After that, the user is asked to do a quick recording session performing all selected movements with maximum effort possible (maximum voluntary contraction). With these data, the system will be able to calculate an instantaneous average effort and represent it by putting it in proportion between the minimum and the maximum effort previously recorded.

The result after a dynamic recording session should be, more or less, like the image below.

![https://biopatrec.googlecode.com/svn/wiki/img/BioPatRec_TRE/Biopatrec_TRE_rampexample.png](https://biopatrec.googlecode.com/svn/wiki/img/BioPatRec_TRE/Biopatrec_TRE_rampexample.png)

# Recording GUI #

Regardless to the type of recording you are doing, single or complete session, you will see your acquired signals in the same GUI. The GUI\_Recording has been optimized and included into BioPatRec TRE release. It allows the user to see more then 4 input channels in the same time. The new GUI has been done with special regard to the efficiency, trying to reduce the plotting latency, and so, the Matlab interference with the acquisition process. The signals plot is divided into two windows, one dedicated to the time and one dedicated to the frequency. The different channels are shifted along the vertical axe and indicated by the channel index on the left side of the windows. When the recording is complete you can see the previous acquisition set displayed in the two figures. Only at this point the GUI let the user access the process tools available on the right side of the plots. Using the channel plot tool the user can select only one channel and see it with more detail, or he can choose to come back to the previous "all togheter plot" by pressing on "Plot All". It is possible to apply filters or features extraction using the respective tools, and it is always possible to restore the signals by pressing "Plot All" button. With the button "Load" the user can check a previous recording or a recording session, in the second case the "Show Recording Session" GUI will help the user to select which movement to plot, giving also all the details about the selected recording session. All these tools are briefly summarized in the following figure.

![https://biopatrec.googlecode.com/svn/wiki/img/BioPatRec_TRE/BioPatRec_TRE_RecordingGUI.png](https://biopatrec.googlecode.com/svn/wiki/img/BioPatRec_TRE/BioPatRec_TRE_RecordingGUI.png)