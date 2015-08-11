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
% 2012-06-01 / Nichlas Sander/ Loading movements into parameters of new patRec
% 2012-10-11 / Joel Falk-Dahlin/ Changed so the GUI now selects output
%                                movements same as trained movement if it
%                                exists
% 2012-10-12 / Joel Falk-Dahlin/ Moved loading of movList and speeds
%                                from GUI_TestPatRec_Mov2Mov here, now
%                                these lists are updated as they are
%                                changed in the GUI compared to before
%                                where these had to be loaded in
%                                TacTest and RealTimePatRec

function Load_patRec(patRec, newGUI, loadMovements)

    % To make sure old patRecs still can be used, initialize max / current
    % speeds
    if ~isfield(patRec,'control')
        patRec.control.maxDegPerMov = ones(1,patRec.nOuts);
    elseif isfield(patRec,'control')
        if ~isfield(patRec.control,'maxDegPerMov')
            patRec.control.maxDegPerMov(1:patRec.nOuts) = 1;
        end
    end

    % Open Fig and load information                
    nG = eval([newGUI,'(patRec)']);
    newHandles = guidata(nG);
	    
    % Fill the GUI
    set(newHandles.lb_features,'Value',1:length(patRec.selFeatures));
    set(newHandles.lb_features,'String',patRec.selFeatures);
    set(newHandles.lb_movements,'String',patRec.mov(patRec.indMovIdx));
    set(newHandles.pm_SelectAlgorithm,'String',patRec.patRecTrained(1).algorithm);
    set(newHandles.pm_SelectTraining,'String',patRec.patRecTrained(1).training);
    set(newHandles.pm_normSets,'String',patRec.normSets.type);

    if exist('loadMovements','var')
        if(loadMovements)
            
        % Fill List of Movements
            % Setup variables
            newHandles.motors = InitMotors;
            mov = InitMovements;
            newHandles.mov = mov;
            movements = [];
            patRecMovements = [];
            
            % Save Valid movements, that can be used with VRE/ARE and
            % motors
            i = 1;
            while(size(movements,2) < size(mov,2))
                movements = [movements,mov(i).name];
                i = i+1;
            end

            % Read movements trained in patRec structure
            i = 1;
            while length( patRec.movOutIdx{i} ) == 1 && i < size( patRec.movOutIdx,2 )
                patMov = patRec.mov{i};
                patMov = strrep(patMov,'Extend', 'Ext');
                patMov = strrep(patMov,'Pointer', 'Point');
                patRecMovements = [patRecMovements; {patMov}];
                i = i+1;
            end
            
            % Set selectable options to valid movements for pop-menus in
            % GUI_TestPatRec_Mov2Mov
            for i=1:20
                s = sprintf('pm_m%d',i);
                if isfield(newHandles,s)
                   set(newHandles.(s),'String',movements);
                   % If patRec has trained movement
                   if i <= length(patRecMovements)
                       % Find menu-value that correspond to trained
                       % movement
                       for j = 1:size(movements,2)
                          if strcmp(patRecMovements{i},movements{j})
                            % Set menu to trained movement
                            set(newHandles.(s),'Value',j);
                            break;
                          end
                       end
                   end
                   
    %                if(size(get(newHandles.(s),'String'),1) > i)
    %                     set(newHandles.(s),'Value',i);
    %                else
    %                     set(newHandles.(s),'Value',1);
    %                end
    
                end
            end
        end
        
        % If we load the GUI_TestPatRec_Mov2Mov, then store movList and
        % speeds to the handles by reading from the pop-menus and et-boxes
        if strcmp(newGUI,'GUI_TestPatRec_Mov2Mov')
            clear movements;
            i = 1;
            dropdown = sprintf('pm_m%d',i);  
            movementSpeed = sprintf('et_speed%d',i);
            while(isfield(newHandles,dropdown) && isfield(newHandles,movementSpeed))
               movIndex = get(newHandles.(dropdown),'Value');
               movements(i) = newHandles.mov(movIndex);
               speeds(i) = str2double(get(newHandles.(movementSpeed),'String'));
               i = i+1;
               dropdown = sprintf('pm_m%d',i);
               movementSpeed = sprintf('et_speed%d',i);
            end
            %Save all values of speeds in the handles
            newHandles.movList = movements;
            %newHandles.maxDegPerMov = speeds;
        end
        
    end
    
    
    % Save the patRec in the handles
    newHandles.patRec = patRec;
    guidata(nG,newHandles);
    
   