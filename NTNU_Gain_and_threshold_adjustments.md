NOTE: This is an ongoing development and therefore the documentation is not yet finalised.

# Gain and threshold adjustments #
The purpose of the gain and threshold adjustments are to define a domain for each motion class <sup>[1]</sup>. Thus, it will be possible to set specific actuations to the output-part. In addition, it applies the offset and gain values, set in the GUI, to the acutation estimate. The offset and gain values happens first, then the threshold adjustments are applied and a new actuation estimate is calculated.

## Details ##

### 2D scenario ###
The working spaces defined, can be observed in part five of the proportional control [figure](NTNU.md) on the front page.

The first steps in this function, are to apply the offset and gain adjustments. Then the threshold adjustments are applied, which calculates the new actuation estimate.

Principle of the threshold adjustments (code implementation is more optimised):
```
actuationEstimate = [x; y];


if (actuationEstimate(1) and actuationEstimate(2)) are within red inner circle
 actuationEstimate(:) == 0;

elseif actuationEstimate[x;y] is within x-axis area (blue)
 actuationEstimate(2) = 0;

elseif actuationEstimate[x;y] is within y-axis area (green)
 actuationEstimate(1) = 0;

elseif actuationEstimate[x;y] is within simultaneous area (white)
 actuationEstimate is decomposed to the the middle axis
 actuationEstimate(:) = midlleAxisValue;

end
```

# References #
  1. Fougner, Anders, et al. "Control of Upper Limb Prostheses: Terminology and Proportional Myoelectric Control-A Review." (2012): 1-1.
  1. Fougner, Anders. Robust, Coordinated and Proportional Myoelectric Control of Upper-Limb Prostheses. Diss. Norwegian University of Science and Technology, 2013.