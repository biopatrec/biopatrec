# Introduction #

The Motion Test was originally introduced by Kuiken _et al._ (2009) as one of the first real-time evaluation tools of myoelectric pattern recognition. For a comprehensive explanation and rationale of this test, see:

> [Kuiken TA, Lock BA, Lipschutz RDR, Miller LA, Stubbleﬁeld KAK, Englehart KBK, Li G: Targeted muscle reinnervation for real-time myoelectric control of multifunction artiﬁcial arms. JAMA: the journal of the American Medical Association 2009, 301(6):619–628.](http://jama.jamanetwork.com/article.aspx?articleid=183371)

A real-time evaluation for controlability would by the [TAC test](TAC_Test.md).

# Implementation in BioPatRec #

Although the implementation of this test in BioPatRec is based in the latter publication. It has some modifications.

  * **Selection time.** Time to the first correct prediction.
    * It starts with the first prediction different to “rest” or “no movement”. In the BioPatRec implementation, it is also includes the time window required for extracting the signal features, as well as the computation time required for signal processing and classification.

  * **Completion time.** Requires the prediction of 20 correct movements
    * Keep in mind that the prediction speed depends on the processing hardware.

  * **Completion rate.**
    * Number of motions that achieved a completion time within the time deadline.

Additional:

  * **Real-time accuracy.** Classifier accuracy during the completion time
    * The real-time accuracy is only assigned to completed motions.

## Requirements ##

  * [patRec](patRec.md) - a trained classifier is required, see PatRec.
  * Data acquisition is required, see [Comm](Comm.md)

# NOTES: #

  * The motion test assumes that there is always a _rest_ or _no movement_ class.