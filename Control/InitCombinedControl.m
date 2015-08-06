function patRec = InitCombinedControl(patRec)

    controlOne = patRec.control.controlAlg.parameters.controlOne;
    controlTwo = patRec.control.controlAlg.parameters.controlTwo;

    % Initialize first controller
    patRecOne = patRec;
    patRecOne = InitControl_new(patRecOne,controlOne);
    
    % Initialize second controller
    patRecTwo = patRec;
    patRecTwo = InitControl_new(patRecTwo,controlTwo);
    
    % Set parameters from patRec to patRecOne and Two if they exist
    allParameters = fieldnames( patRec.control.controlAlg.parameters );
    for iParam = 1:size(allParameters,1)
        name = allParameters{iParam};
        value = patRec.control.controlAlg.parameters.(allParameters{iParam});
        
        if isfield( patRecOne.control.controlAlg.parameters, name )
            patRecOne.control.controlAlg.parameters.(name) = value;
        end
        
        if isfield( patRecTwo.control.controlAlg.parameters, name )
            patRecTwo.control.controlAlg.parameters.(name) = value;
        end
        
    end
    
    % Read parameters from patRecOne and patRecTwo and store in patRec
    tmp = [{'One'},{'Two'}];
    for iPatRec = 1:2
        currentPatRec = eval(['patRec',tmp{iPatRec}]);
        allParameters = fieldnames( currentPatRec.control.controlAlg.parameters );
        if ~isempty(allParameters)
            for iParam = 1:size( allParameters, 1 )
                currentParameter = allParameters(iParam);
                patRec.control.controlAlg.parameters.(currentParameter{1}) = currentPatRec.control.controlAlg.parameters.(currentParameter{1});
            end
        end
    end
    
    patRecOne = UpdateControl(patRecOne);
    patRecTwo = UpdateControl(patRecTwo);
    
    % Store patRecs in control properties
    patRec.control.controlAlg.prop.patRecOne = patRecOne;
    patRec.control.controlAlg.prop.patRecTwo = patRecTwo;
    
end