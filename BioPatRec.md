# Introduction #

BioPatRec is a modular platform for testing and development of algorithms to be applied in prosthetic control.

  * See [Highlights](BioPatRec_Highlights.md) for features, demos, etc…
  * See [Startup Guide](BioPatRec_StartupGuide.md) for quick instructions ("How To's")
  * See [Requirements](BioPatRec_Requirements.md) for (yes, exactly!) the system requirements.

Reference article:
[Ortiz-Catalan, M., Brånemark, R., and Håkansson, B., “BioPatRec: A modular research platform for the control of artiﬁcial limbs based on pattern recognition algorithms”, Source Code for Biology and Medicine, 2013, 8:11](http://www.scfbm.org/content/8/1/11)

# For Developers/Researchers #

If you are interested on developing further using this platform, or simple understand the nuts and bolts of BioPatRec, the following links are for you.

BioPatRec is structured in different modules, and their related routines can be found inside the folders named after each module.

  * [Comm](Comm.md)
  * SigRecordings
  * SigTreatment
  * SigFeatures
  * PatRec
  * [Control](Control.md)

See [BioPatRec\_Roadmap](BioPatRec_Roadmap.md) for quick overview of the relevant functions in each module.

![https://biopatrec.googlecode.com/svn/wiki/img/Biopatrec_flow.png](https://biopatrec.googlecode.com/svn/wiki/img/Biopatrec_flow.png)

BioPatRec has a modular design based in data structures. This means that as long as you use the same data structures, you can use different modules independently if you wish.

  * Data Structures
    * [recSession](recSession.md)
    * [sigTreated](sigTreated.md)
    * [sigFeatures](sigFeatures.md)
    * [patRec](patRec.md)

If you are planning to contribute or develop further using this platform, you might want to consider the following

  * [Coding Standard](Coding_Standard.md) (simple, easy and useful!)
  * [Updating the source code and wiki](Updating.md)
  * [File header and copyright notice](Copyright_Notice.md) (keep the connection and play fair)

If you wish to commit changes or upgrades to BioPatRec, the easiest way is to submit a _patch_ using Tortoise. See this [Tortoise SVN Tutorial](http://www.igorexchange.com/node/87#branches) for more information.

When comparing different algorithms, remember that small variations in signal processing and training settings can make a difference on the final results.

Join the google group if you are interested on receiving updates
http://groups.google.com/group/biopatrec

# Troubleshooting #

See the [Troubleshooting](Troubleshooting.md) page