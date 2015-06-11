# Introduction #

This is the standard statistical method for pattern recognition (PatRec), where Linear Discriminant Analysis ([LDA](http://en.wikipedia.org/wiki/Linear_discriminant_analysis)) is probably the most popular and well-known.

# Implementation #

The implementation is based on MATLAB _classify_ function. See [Discriminant Analysis in Matlab](http://www.mathworks.se/help/toolbox/stats/classify.html) for details.

All discriminant analysis types available in Matlab can also be selected from the [GUI\_PatRec](GUI_PatRec.md).

  * linear
  * diaglinear
  * quadratic
  * diagquadratic
  * mahalanobis

Really, check out [Discriminant Analysis](http://www.mathworks.se/help/toolbox/stats/classify.html) for details.

Note: It requires the Matlab's Statistics Toolbox.

# Functions Roadmap #
## Training ##

  * DiscriminantAnalysis
    * GetSetsLables\_Stack
    * classify

## Testing ##

  * DiscriminantTest