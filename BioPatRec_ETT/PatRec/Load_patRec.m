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
% ------------------- Function Description ------------------
% Funtion to load "patRec" into a selected GUI 
%
% --------------------------Updates--------------------------
% 2011-11-16 / Max Ortiz  / Creation
% 2012-06-01 / Nichlas Sander/ Loading movements into parameters of new
% patRec
function Load_patRec(patRec, newGUI, loadMovements)

    % Open Fig and load information                
    nG = eval(newGUI);
    newHandles = guidata(nG);

    % Fill the GUI
    set(newHandles.lb_features,'Value',1:length(patRec.selFeatures));
    set(newHandles.lb_features,'String',patRec.selFeatures);
    set(newHandles.lb_movements,'String',patRec.mov);
    set(newHandles.pm_SelectAlgorithm,'String',patRec.patRecTrained(1).algorithm);
    set(newHandles.pm_SelectTraining,'String',patRec.patRecTrained(1).training);
    set(newHandles.pm_normSets,'String',patRec.normSets.type);
    
    if(loadMovements)
        % Fill List of Movements
        newHandles.motors = InitMotors;
        mov = InitMovements;
        newHandles.mov = mov;
        movements = [];
        i = 1;
        while(size(movements,2) < size(mov,2))
            movements = [movements,mov(i).name];
            i = i+1;
        end

        for i=1:20
            s = sprintf('pm_m%d',i);
            if isfield(newHandles,s)
               set(newHandles.(s),'String',movements);
%                if(size(get(newHandles.(s),'String'),1) > i)
%                     set(newHandles.(s),'Value',i);
%                else
%                     set(newHandles.(s),'Value',1);
%                end
            end
        end
    end
    % Save the patRec in the handles
    newHandles.patRec = patRec;
    guidata(nG,newHandles);
    
   