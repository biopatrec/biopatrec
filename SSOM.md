NOTE: This is an ongoing development and therefore the documentation is not yet ready.
# Introduction #

Supervised Self-Organizing Map (SSOM) is the supervised version of [SOM](SOM.md). It is generally known as the supervised learning that takes the class-identity into account in the learning phase. The idea behind SSOM is summarized as that, throughout the learning phase, each output neuron _i_ makes its own prediction _Y(i,M)_  of M movements which represents the percentage of the learning that was gained.


# Algorithm  <sup>[1]</sup> #
> Generally, SSOM algorithm has the same network architecture as in [SOM](SOM.md) even the training methods . In order to make SSOM ,the training set (_X_) and weights matrix (_W_) were formed as:
> > _**X<sub>n,d+M</sub> = [X<sub>n,d</sub> , O<sub>n,M</sub>]**_.
> > > _**W<sub>i,d,M</sub>=[W<sub>i,d</sub> , Y<sub>i,M</sub>]**_.


> Where  _X<sub>n,d</sub>_  denotes the input training patterns, having _d_ to represent the features per pattern _n_. _O<sub>n,M</sub>_ is the label vector (class-identity) which is associated with pattern _n_, consisting of _M_ movements that can take values at 1 or 0 assigned to either one or two movements. The _W<sub>i,d</sub>_ is weights vector per neuron _i_ initialized randomly, and _Y<sub>i,M</sub>_ is the prediction of neuron _i_ per M movements which is also initialized randomly.

There are two training methods:
  * Stochastic Training.
  * Batch Training (default).
see training methods of [SOM](SOM.md)


# Implementation #

**Grid Shape
  * Rectangular Grid (default).
  * Hexagonal Grid.**

**Neighbor Function
  * Bubble.
  * Gaussian (default).
  * Cutgaussian.
  * Triangular.
  * Butter worth 2nd order.**

**Visualize U-matrix
  * yes.
  * No (default).**


# Functions Roadmap #

## GUIDE ##


  * `GUI_SOM`

## Training ##


  * `SSOM_Mapping`
    * `EvaluateSSOM`
      * `InitSSOM`
        * `NeuronCoordinates`
        * `RandomWeights`
        * `NeuronDistances`
          * `VectorDistance`
      * `SSOMStochasticTraining`
        * `Sigma`
        * `Eta`
        * `FindClosest`
        * `UpdateWeights`
          * `StochasticNeighborFunction`
      * `SSOMBatchTrainig`
        * `VectorDistance`
        * `BatchNeighborFunction`
      * `FastTestSSOM`
        * `FindClosest`
      * `FullTestSSOM`
        * `FindClosest`
      * `GetNeuronLabel`
        * `FindClosest`
      * `ShowUDMatrix`
        * `CreateUDMat`
        * `UDMatCoords`
        * `PlotUDMatrix`
          * `SyntaxNeuron`
        * `GetColor`




## Testing ##


  * `SSOMTest`
    * `FindClosest`


> ## References ##

---

  1. Teuvo Kohonen ,''Self-Organizing Maps  (3rd ed.)'',Springer, pp.(215-216),ISBN13:978-3540679219.