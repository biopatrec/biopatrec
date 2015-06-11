NOTE: This is an ongoing development and therefore the documentation is not yet ready.

# Introduction #

Self-Organizing Map (SOM) is an unsupervised Artificial Neural Networks (ANN) that was introduced and developed by Teuvo Kohonen (1982). The basic model of SOM consists of an input layer fully connected as a forward connection to an output layer (computational layer). This output layer contains a fixed number of output neurons arranged in a two dimensional grid of R rows and C columns in a regular spacing hexagonal or rectangular grid shape. Each output neuron is represented by d-dimensional weights vector W=[w<sub>1</sub>,w<sub>2</sub>,...,w<sub>d</sub>] , which is basically the input-output connections. Intuitively, the weight vector (W) is required to be as same dimension as the input layer.

The fundamental goal of the SOM is to transform the high-dimensional input space into two-dimensional output space. However, during the 'training' process, the weights vector (W) is updated to preserve geometric relationships (topologies) in such a way that the identical input patterns are mapped into closely located output neurons and, vice-versa. Having done the training process, the training set were mapped into 2-dimensional grid and  used as references for making a prediction. The prediction of SOM is made based on the geometric relationship between the references and the output neuron of any testing pattern, which makes SOM one of the most popular classifiers.

# Training algorithms #
There are two training methods to create the geometric relationship:
  * Stochastic<sup>[1]</sup> Training (default).
  * Batch<sup>[2]</sup> Training.

> ## Stochastic Training<sup>[1]</sup>. ##
> The algorithm can be summarized by the following steps:

> For each iteration _t_:
  1. **Sampling:** Randomly choose 70% of the input patterns from the training patterns set _X_.
  1. **Similarity matching:** For each of the selected pattern _k_, the Best-Matching Neuron (BMN) is selected competitively by using the Euclidean Distance as a criterion for measuring the similarity between _x(k,d)_ and _W(i,d)_:
> > _**c= min<sub>i</sub> || x<sub>k,d</sub>(t) - W<sub>i</sub>(t) | | , ∀ i**_
  1. **Updating:** The weights of the neurons are updated cooperatively, in such a way that the winner _W(c,d)_ and neighbor neurons - that centered around the winner on the grid - are updated to be more similar to _X(k,d)_:
> > _**W<sub>i,d</sub>(t+1)=W<sub>i,d</sub>,(t) + eta(t) h<sub>ci</sub>(t) ( x<sub>k,d</sub>(t) - W<sub>i,d</sub>(t) ) ,   ∀ i**_


> where _eta(t)_ ∈ (0,1) is learning rate at training step _t_, and  _h<sub>ci</sub>(t)_ ∈ [0,1] is the value of the neighborhood function at neuron _i_ when neighborhood function is centered on the winner _c_ at training step _t_.
4. Repeat step 2 and 3 for each pattern _k_.

5. Repeat previous steps unit _t_=50.


> ## Batch Training<sup>[2]</sup>. ##

> The algorithm can be summarized by the following steps:

> For each iteration _t_:
    1. For each training pattern _x(j,d)  ,∀ j_, the BMN is selected competitively by using the Euclidean Distance as a criterion for measuring the similarity between _x(j,d)_ and _W(i,d)_:
> > > _**c<sub>j</sub>= min<sub>i</sub> || x<sub>j</sub>(t) - W<sub>i</sub> | | , ∀ i,j**_
    1. The indexes _c_ are partitioned into _G_ different groups of Voronoi cell, considering that same _c_  can associate to one or _m_ different training patterns as Voronoi cell.
    1. The neurons weights  are updated according to :
> > > _**W<sub>i</sub>(t+1)=(∑<sub>g=1</sub> m<sub>g</sub>  h<sub>ci</sub>(t)  ̅X<sub>g</sub>) / (∑<sub>g=1</sub> m<sub>g</sub>  h<sub>ci</sub>(t))  if  (∑<sub>g=1</sub> m<sub>g</sub>  h<sub>ci</sub>(t)) ≠ 0, ∀ i**_
> > > otherwise _**W<sub>i</sub>(t+1)=W<sub>i</sub>(t)**_

> Where _m<sub>g</sub>_ ≥ 1 is the number of BMN in Voronoi cell _g_,  _̅X<sub>g</sub>_ is the mean of the associated training patterns to the Voronoi cell _g_, and _h<sub>ci</sub>_ ∈ [0,1] is the value of the neighborhood function at neuron _i_ when neighborhood function is centered on Voronoi cell g.

> 4.Repeat previous steps unit _t_=50.
# Implementation #

> When SOM is selected as PatRec algorithm in the [GUI\_PatRec](GUI_PatRec.md), an additional GUI for configuration of SOM (GUI\_SOM) will automatically appear. This GUI allows the selection of different Grid Shape, Neighbor Functions and Visualization of the Map.

**Grid Shape
  * Rectangular Grid.
  * Hexagonal Grid (default).**

**Neighbor Function
  * Bubble.
  * Gaussian.
  * Cutgaussian.
  * Triangular.
  * Butter worth 2nd order (default).**

**Visualize U-matrix
  * yes.
  * No (default).**

These parameters are saved in a struct variable (_algConf_) and then added to the [GUI\_\_PatRec](GUI__PatRec.md) handles to later be retrieved for OfflinePatRec. See [Important\_coding\_changes](Important_coding_changes.md) for more details.

## U-matrix ##

> Unified distance matrix (U-matrix) is one methods to visualize high-dimensional space on a 2-D a gray-scale image . Where, it represented by the distance between each two neighbors neuron in the map which in turn represent the intermediate spot between those two neighbors. Some of these routines are borrowed from the SOM Toolbox<sup>[2]</sup> and adapted to BioPatRec.


## Adding SOM into [BioPatRec](BioPatRec.md) ##

  * **Adding SOM rutines into [BioPatRec](BioPatRec.md).**
    * In the OfflinePatRecTraining routine, call SOM\_Maping routine if the selected algorithm is SOM.
    * In OneShotPatRec routine, call SOMTest routine if the selected algorithm is SOM.

# Functions Roadmap #

## GUI ##

  * `GUI_SOM`

## Training ##

  * `SOM_Maping`
    * `EvaluateSOM`
      * `InitSOM`
        * `NeuronCoordinates`
        * `RandomWeights`
        * `NeuronDistances`
          * `VectorDistance`
      * `StochasticTraining`
        * `Sigma`
        * `Eta`
        * `FindClosest`
        * `UpdateWeights`
          * `StochasticNeighborFunction`
      * `BatchTrainig`
        * `VectorDistance`
        * `BatchNeighborFunction`
      * `GetNeuronLabel`
        * `FindClosest`
      * `FastTestSOM`
        * `FindClosest`
      * `FullTestSOM`
        * `FindClosest`
      * `ShowUDMatrix`
        * `CreateUDMat`
        * `UDMatCoords`
        * `PlotUDMatrix`
          * `SyntaxNeuron`
        * `GetColor`

## Testing ##

  * `SOMTest`
    * `FindClosest`

# Credits #

Implemented and documented by Ali Fouad. This implementation is partially based on [The SOM toolbox](http://www.cis.hut.fi/somtoolbox/download/) <sup>[2]</sup>

# References #

---

  1. Simon O. Haykin ,''Neural Networks and Learning Machines (3rd ed.)'',PEARSON, pp.(464-465),ISBN13:978-0-13-129376-2.
  1. Juha Vesanto, Johan Himberg, Esa Alhoniemi and Parhankangs,''SOM Toolbox'',Helsinki University of Technology,pp.(9-11),ISBN 951-22-4951-0.