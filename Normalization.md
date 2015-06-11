# Normalization #

The choice of the normalization method depends strongly on the implementation of a given algorithm, and it can greatly affects the classifier performance.

Normalization is usually required to avoid that features with large magnitudes eclipse the contribution of the rest.

## Normalization methods ##
  * Statistical normalization (Mean 0, Variance 1)
  * Unitary range (0 to 1), preferred in:
    * [RFN](RFN.md)
  * Mid-range 0, Range 2 (-1 to 1), preferred in:
    * [MLP](MLP.md)
  * Norm-Log (x>=0), preferred in:
    * [SOM](SOM.md), [KNN](KNN.md) and [SSOM](SSOM.md).

We haven't observed the need to use any normalization when using LDA as implemented by the statistics toolbox in Matlab.

# How to add a normalization method? #

  * Add the processing function in [NormalizeSets\_TrV](NormalizeSets_TrV.md). The parameters required to normalize future data sets must be included in the struct _normSets_. This function must normalize the training and validation sets independently. See the other normalization function as example.

  * Add the normalization fuction to _NormalizeSet_. This function must normalize a single vector using the provided parameters.