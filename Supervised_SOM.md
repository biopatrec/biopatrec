# Introduction #

Supervised Self-Organizing Map (SSOM) is a supervised artificial neural network, this network  has the same model as in [SOM](SOM.md). The learning in this model is based on  supervised learning i.e. the input-output transformation adjusted by the system parameters.


# Algorithm #
> There are two training methods:
  * Stochastic Training.
  * Batch Training.

> ## Stochastic Training. ##
> The algorithm is summarized as follows:

  1. Add the label last columns to the input data.
  1. **Initialization:** Randomly choosing the initial weight vectors  _W<sub>j</sub>_ (with same dimension of input data).The only restriction is that _W<sub>j</sub>_ to be different for _j=1,2,...,n_ where _n_ is the number of neurons in the lattice.
  1. **Sampling:** Draw randomly the input vector _x_ from the input data sets.
  1. **Similarity matching:** Find the best-matching(winning) neuron _i(x)_ at time-step _t_ by using the minimum-distance criterion where
> > _i(x)=arg min || x(t) - W<sub>j</sub> | , j=1,2,...,n_
  1. **Updating:** Adjust the synaptic-weight vector of all excited neurons by using the update formula **_W<sub>j</sub>(t+1)=W<sub>j</sub>(t) + eta(t) h<sub>cj</sub>(t) ( x(t) - W<sub>j</sub>(t) )    ,   j=1,2,...,n_**  where _eta(t)_ is a learning rate parameter and _h<sub>cj</sub>(t)_ is the neighborhood function centered around the winning neuron _i(x)_; both _eta(t)_ and _h<sub>cj</sub>(t)_are varied dynamically during learning.
  1. **Continuation:** Continue with step 3 to 5 for some iterations.



> ## Batch Training. ##
> In the Batch Training the weight vectors for all input data vectors are simultaneously update.

> The algorithm is summarized as follows:
    1. Add the label last columns to the input data.
    1. Randomly choosing the initial weight vectors  _W<sub>j</sub>_ (with same dimension of input data).The only restriction is that _W<sub>j</sub>_ to be different for _j=1,2,...,n_ where _n_ is the number of neurons in the lattice.
    1. Find the best-matching (winning) neuron according to 4 in Stochastic Training for all input data sets.
    1. Calculate the sum of vectors in each Voronoi set by:
> > > _S<sub>j</sub>_=sum(_x<sub>j</sub>_)   ,_j=1,2.....,nv<sub>i</sub>_. where _nv<sub>i</sub>_ is Voronoi set of unit _i_.
    1. Calculate the number of sample in each Voronoi (_nv<sub>i</sub>_) set _i_.
    1. W<sub>i</sub>(t+1)=sum( _h<sub>ij</sub>(t)_ _S<sub>j</sub>(t)_ ) / sum( _nv<sub>j</sub>_ _h<sub>ij</sub>(t)_ )  ,_j=1,2.....,m_. where _m,_ is number of neurons , _h<sub>ij</sub>(t)_ is a neighborhood function centered around the neuron _i_ at time _t_ and _nv<sub>j</sub>_ is  number of samples in the Voronoi set _j_.
    1. Continue with step 3 to 6 for some iterations.


> ## Classification ##

  1. Take out the added columns from the weight matrix that represents the neuron output.
  1. Find the best-matching(winning) neuron according to 4 in Stochastic Training for each test pattern.
  1. The output of test pattern is the associated neuron output.


# Functions Roadmap #

## GUIDE ##

  * `GUI_SOM`

## Training ##


  * `SSOM_Mapping`
    * `EvaluateSSOM`
      * `InitSSOM`
        * `unitCoords`
        * `RandomWeights`
        * `unitDists`
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
      * `GetNeurLab`
      * `FastTestSSOM`
        * `FindClosest`
      * `FullTestSSOM`
        * `FindClosest`



## Testing ##


  * `SSOMTest`
    * `FindClosest`