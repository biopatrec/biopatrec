NOTE: This is an ongoing development and therefore the documentation is not yet finalised.

# Linear mapping #

Given a system on the form of equation 1 <sup>[Eq. 1]</sup>, and that there is linear mapping, there are estimators designed to create the relation between the input and the output of the system <sup>[1]</sup> <sup>(norwegian source)</sup>. Some equations are wrong in the first paper <sup>[1]</sup>, but corrected in the paper of Bertnum <sup>[2]</sup>.

> F = Ax **[Eq. 1]**

In the formula, x is the input feature vector, A is the matrix mapping x to F, and F is the output vector containing the output intent estimate for the prosthesis control.

Two steps are necessary for the estimators in linear mapping. Firstly, the algorithm must go through the offline-training in BioPatRec. During the offline-training, the F and x is known from the system training, being in the [xSets](xSets.md) data structure. Thus A can be calculated and used for further estimation. Lastly, the algorithm is ready to be run, and can do so in accordance to the estimator chosen. Both of these steps have a choice of estimators:
  * Normal linear estimator
  * Decoupled linear estimator

The offline-training is implemented within the _OfflineProportionalControl_ function, and the online-training is implemented within the _LinearMapping_ function. Both are inside the proportional control folder.

## Normal linear estimator ##
This estimator uses linear regression for its calculation of the matrix A. Which in Matlab can be interpreted as in equation 2 <sup>[Eq. 2]</sup>.
> A = F/x **[Eq. 2]**
Here it's important to notice, that the Matlab-operator "/", is interpreted according to the format of the input. See documentation within Matlab for details ("doc /" or "doc mrdivide").

After estimating the A matrix, the algorithm is ready for realtime-calculation. This calculation is done through equation 1 <sup>[Eq. 1]</sup>.

## Decoupled linear estimator ##
In this estimation the F vector is decomposed to three feature vectors: mean <sup>[Eq. 3]</sup>, standard deviation <sup>[Eq. 4]</sup> and form <sup>[Eq. 5]</sup>.

> F<sub>mean</sub> = _mean_(F) **[Eq. 3]**

> F<sub>std</sub>  = _std_(F)  **[Eq. 4]**

> F<sub>form</sub> = (F-F<sub>mean</sub>)/F<sub>std</sub> **[Eq. 5]**

For the estimation of the A matrix in decoupled linear estimation, equation 6 <sup>[Eq. 6]</sup>, 7 <sup>[Eq. 7]</sup> and 8 <sup>[Eq. 8]</sup> are used.

> A<sub>mean</sub> = F<sub>mean</sub>/x **[Eq. 6]**

> A<sub>std</sub> = F<sub>std</sub>/x **[Eq. 7]**

> A<sub>form</sub> = F<sub>form</sub>/x **[Eq. 8]**

After the offline-calculation, the A matrix can be run through equation 9 <sup>[Eq. 9]</sup> with the realtime-feed of EMG-data.

> F = (A<sub>form</sub> x).`*`(A<sub>std</sub> x) + A<sub>mean</sub> x **[Eq. 9]**

# References #
  1. Linnerud, Ådne Solhaug. Lab-oppsett for proteseforskning. Diss. Norwegian University of Science and Technology, 2012.
  1. Bertnum, Alf Bjørnar. BioPatRec som forskningsplattform med fokus på intensjonsestimering og systemtrening. Diss. Norwegian University of Science and Technology, 2012.