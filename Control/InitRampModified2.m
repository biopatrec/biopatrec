function patRec = InitRampModified2(patRec)

patRec.control.controlAlg.prop.timesPredicted = zeros(1,patRec.nOuts);
patRec.control.controlAlg.prop.timesNotPredicted = zeros(1,patRec.nOuts);