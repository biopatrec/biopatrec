=== Pattern Recognition Training Data
Recording files are named according to the following format: 
[SubjectID]_[# of channels]ch[# of movements]mov_[associated test].mat

The layout of the included structures is documented at the following websites:
https://github.com/biopatrec/biopatrec/wiki/recSession.md
https://github.com/biopatrec/biopatrec/wiki/PatRec.md

A file named "01_4ch6mov_artifacts.mat" indicates it is a recording session (recSession) from subject 01 using 4 channels to record 6 movements for the artifact reduction tests.

=== Motion Test Data
Motion test files are named according to the following format:
[SubjectID]_[test]_[signal treatment].mat

The layout of the included structures is documented at the following website:
https://github.com/biopatrec/biopatrec/wiki/motionTestStruct.md

A file named "02_imputed_leadoff.mat" indicates it is a motion test (motionTest) from subject 02 with the results for the lead-off test with data imputing enabled.

Note that the Motion Test data do not include raw EMG recordings, only the predicted movement classifications, as all processing and pattern recognition was performed on the microcontroller.