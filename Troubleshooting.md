Here you can find instructions on how to solve the most common problems

# General #

It doesn't come as a surprise that sometime Windows and Matlab become unstable and crash without any apparent reason. So, the first things you should try if something is not working properly (and you are sure is not your fault) is:

  1. Have you followed the instructions at [startup guide](BioPatRec_StartupGuide.md)?, if so then,
  1. Close BioPatRec and open it again, if that doesn't work then,
  1. Close Matlab and open it again, if that doesn't work then,
  1. Restart Windows

If the latter doesn't work and you double checked is not your fault, then take a look at the following issues

# Communications and Data Acquisition #

The Matlab/NI drivers are not as stable as you would expect. If you have experience during data acquisition try the function `TestSBI_NI_USB6009`. Although is named after the NI-USB6009, it works for several NI devices (see [Comm](Comm.md)). If this routine doesn't work, then it's not a BioPatRec issue, so check the following known problems/solutions.

  * **Problem:** The MATLAB R2011a with data acquisition toolbox 2.18 doesn't support USB devices from NI, only compacDAQ. ([problem](http://www.mathworks.se/matlabcentral/answers/11333-ni-daq-usb-6351-problem-on-win64-platform)). This MATLAB version uses the [Session-based Interfaces](http://www.mathworks.se/help/toolbox/daq/bskx95j.html) which doesn't support USB cards, and [legacy](http://www.mathworks.se/help/toolbox/daq/ref/analoginput.html) cannot be used in a 64-bit Matlab.
    * **Solution:** Either use a later Matlab version with SBI, or an earlier version with legacy. You will need to ask us for the legacy routines though.

  * **Problem:** Error for USB6009:
> ''Onboard device memory overflow. Because of system and/or bus-bandwidth limitations, the driver could not read data from the device fast enough to keep up with the device throughput.''
    * **Solution:** This error can appear when doing foreground acquisition, see [USB-6008/6009 Error -200361: Buffer Overflow Error](http://digital.ni.com/public.nsf/allkb/611475F9BE62881E86256FDC0062B1BB). It can be solved by unstalling de device from the windows manager device, then disconnect it, wait some minutes and connect it again. It will be automatically installed.
> Note: A [report](http://www.mathworks.se/matlabcentral/answers/27596-onboard-device-memory-overflow-because-of-system-and-or-bus-bandwidth-limitations-the-driver-could) has been done to MATLAB about this issue. They recomend to follow a bug patch that can be found in the report. It makes things better since after the patch, unistalling the drivers is not necessary anymore. However, de/conection of the USB cable is still necessary.

  * **Problem:** The DAQ with the USB6009 is not calling the callback function.
    * **Solutions:** This has been solved using the same procedure than the error before.

  * **Problem:** Error: 'Attempted to access data(:,1); index out of bounds because size(data)=[0,0].'
    * **Solutions:** This has been solved using the same procedure than the error before.

  * **Problem:** Error: 'A class definition must be in an "@" directory.'
    * **Solutions:** The reason for the problem may be use of character '@' in the path of BioPatRec. In fact, OOP in Matlab also uses folders starting with the character '@'. Once you have a '@' in your path, Matlab confuses this character with its procedure for defining a class. The solution is not to use '@' in folder or file names.

# Myoelectric signals recording #

  * **Problem:** My signals are too noisy
    * **Solutions:** see [sEMG](sEMG.md)

# Pattern recognition #

  * **Problem:** Error using classify (line 228). The pooled covariance matrix of TRAINING must be positive definite.
    * **Solutions:** LDA can has not enough useful information. Try increasing the number of training sets or using different features.

  * **Problem:** The training of the classifiers seems stuck and there are no signs of convergence.
    * **Solutions:** This is normally due to the amount and/or quality of the provided feature vectors. Try the algorithm with one of the data sets in the repository, and select the top 2 or 3 features, if this doesn't work is probably an issue with your classifier. If this works, then is an issue with your recording session. Additionally, try different signal features.