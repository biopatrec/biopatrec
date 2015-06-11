# Statistic for PatRec #

BioPatRec allows you automatically generate statistics on the accuracy of the offline prediction using:

  * Current data. This mean the loaded [sigFeatures](sigFeatures.md)
  * Group. It will load each `*.mat` file containing [sigFeatures](sigFeatures.md) from the selected folder. However, the files must be name: 1t.mat, 2t.mat, and so on.

These routines will run OfflinePatRec with the selected settings in the GUI.