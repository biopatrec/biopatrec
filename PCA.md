NOTE: This is an ongoing development and therefore the documentation is not yet ready.

# Introduction #
> Principal Component Analysis (PCA) is a widely used "dimensionality reduction" technique. In Pattern Recognition, dimensionality reduction can be categorized as feature selection or feature projection. PCA is an unsupervised feature reduction or feature projection technique which does not require any information about the class labels. The central idea of PCA is to reduce the dimensionality of large data sets in to a low dimensional space while preserving as much as possible variation present in the data.

> PCA is a linear transformation also called as karhunenloeve tranform (KLT). It transforms number of correlated variables into small number    of uncorrelated variables called as Principal Components (PCs). The first PCs account for most of the variability in the data.


# Algorithm #
PCA Algorithm is summarized as follows


  * **Step-1**: [Normalization](Normalization.md)

  * **Step-2**: Compute sample Covariance matrix.

  * **Step-3**: Compute Eigen vectors and Eigen values.

  * **Step-4**: Sort Eigen values in descending order.

  * **Step-7**: Arrange the Eigen vectors with their corresponding  eigen values in descending order.

  * **Step-8**: Choose first k largest eigen vectors.

  * **Step-9**: Project the data on to k eigen vectors.

### How to Chose k ###
> To choose k following criterion is used.
> Consider Eigenvalue is Lamda.
> ∑ <sup>𝛌</sup>i / ∑<sup>𝛌</sup>j > Thershold(eg.0.9999) where i = 1,2,....k and j = 1,2,....N


## Implementation ##
> The implementation of PCA in patRec is as follows

> PCA requires normalization for the data. Data is normalized according to the [PatRec](PatRec.md) [normalization methods](Normalization.md).

  * . Compute PCA on [Training Set](xSets.md) and save Eigen Vector of [Training Set](xSets.md) in [patRec](patRec.md).

  * . For [Validation and Testing Sets](xSets.md), project the Eigen vectors of the Training Set on to the Testing and Validation Sets.

# Adding PCA in [BioPatRec](BioPatRec.md) #

  * [GUI\_PatRec](GUI_PatRec.md)
    * Create a popup menu and name it 'pm\_FeatureReduction'.
    * pm\_FeatureReduction callback function is modified such that, If 'PCA' has selected in popup menu then, instead of considering top 4, top 3 or top 2 Features, all features are automatically selected.

  * [OfflinePatRec](OfflinePatRec.md)
    * A new variable called 'featReducAlg' is added as input for OfflinePatRec routine and a new structure called 'featureReduction' which contains the Eigen vectors and algorithm named as 'PCA' are saved in patRec.


# Function roadmap #

  * **Training**
    * FeatureReduction
      * PCAFeatureReduction
      * PCATest

  * **Testing**
    * ApplyFeatureRedction
      * PCATest

# Created and documented by: #