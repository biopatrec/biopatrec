% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for 
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and 
% Chalmers University of Technology. All authors’ contributions must be kept
% acknowledged below in the section "Updates % Contributors". 
%
% Would you like to contribute to science and sum efforts to improve 
% amputees’ quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file 
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
%
% -------------------------- Function Description -------------------------
% Function to execute the Offline traning once selected from the GUI in
% Matlab
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-11-06 / Max Ortiz / Creation - Made an independent routine out of
%                          RealtimePatRec
% 2012-11-23 / Joel Falk-Dahlin / Removed handles in from control
%                                 functions, speeds are now in patRec
% 20xx-xx-xx / Author    / Comment on update

function [outMov, outVector, patRec, handles] = OneShotRealtimePatRec(tData, patRec, handles, thresholdGUIData)

    %% Signal processing
    tSet = SignalProcessing_RealtimePatRec(tData, patRec);

    %% Floor noise
    % Only predict when signal is over floor noise?
    if(isfield(patRec,'floorNoise'));
        meanFeature1 = mean(tSet(1:size(patRec.nCh,2)));
        fnoiseDiv = 1;
        if meanFeature1 < (patRec.floorNoise(1)/fnoiseDiv)
            outMov = patRec.nOuts;
            outVector = zeros(patRec.nOuts,1);
            outVector(end) = 1;
        else
            % One shoot PatRec
            [outMov, outVector] = OneShotPatRecClassifier(patRec, tSet);
        end
    else
        % One shoot PatRec
        [outMov, outVector] = OneShotPatRecClassifier(patRec, tSet);        
    end
    
    % Safety check so the classifier cannot predict rest + a movement
    % This condition assumes that rest is always the last movement
    if strcmp(patRec.mov(end),'Rest')
        if ismember(patRec.nOuts, outMov) | outMov == 0
            outMov = patRec.nOuts;
        end
    end
        
    %% Threshold GUI update
    if(isfield(patRec.patRecTrained,'thOut'));
    %set(handles.(sprintf('thPatch%d',outMov-1)), 'FaceColor', [0 1 0]);
        for i=0:patRec.nOuts-1
            s0 = sprintf('thPatch%d',i);
            s1 = sprintf('movementSelector%d',i);
            s2 = sprintf('value%d',i);
            s3 = sprintf('overrideButton%d',i);
            set(handles.(s0), 'YData', [0 outVector(get(thresholdGUIData.(s1),'Value')) outVector(get(thresholdGUIData.(s1),'Value')) 0]);
            % Change face colour
            if find(get(thresholdGUIData.(s1),'Value') == outMov);
                set(handles.(s0), 'FaceColor', [0 1 0]);
            else
                set(handles.(s0), 'FaceColor', [0 0 1]);
            end
            % Update threshold value
            if(get(thresholdGUIData.(s3), 'Value') == 1);
                patRec.patRecTrained.thOut(get(thresholdGUIData.(s1),'Value')) = str2num(get(thresholdGUIData.(s2),'String'));
            else
                set(thresholdGUIData.(s2), 'String', patRec.patRecTrained.thOut(get(thresholdGUIData.(s1),'Value')));
            end
        end
    end

    %% Apply Proportional control
    patRec = ApplyProportionalControl(tSet, patRec);

    %% Control algorithm
    [patRec, outMov] = ApplyControl(patRec, outMov, outVector);
    
    %% Update result on the GUI
    set(handles.lb_movements,'Value',outMov);
    drawnow;
    
end