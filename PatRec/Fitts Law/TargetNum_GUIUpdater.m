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
% 
% When distance type is set to "per DOF" in Fitts Law Test GUI, the
% "repetitions" parameter is automatically set to the appropriate number of
% targets which has been determined by the selection of "target DOF" and
% the degrees of freedom of movement allowed by the movement selectors on 
% the rightmost panel of the Fitts Law GUI. This function updates this
% "repetitions" value upon relevant selections changes in the GUI.
% 
% When distance type is set to "Euclidean", the target DOF is disabled and
% automatically matched to the movement DOF.
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2016-12-13 / Jake Gusman        / Creation                             
% 
% 

function TargetNum_GUIUpdater(handlesX)

handles = handlesX;

handles.patRecHandles = guidata(handles.mainGUI);
patRec = handles.patRecHandles.patRec;



    expand = get(handles.pm_expand,'Value');
    shrink = get(handles.pm_shrink,'Value');
    right = get(handles.pm_right,'Value');
    left = get(handles.pm_left,'Value');
    up = get(handles.pm_up,'Value');
    down = get(handles.pm_down,'Value');

    moves = [expand, shrink, right, left, up, down];
    for m = 1:length(moves)
        if moves(m) == patRec.nM
            moves(m) = 0;
        else
            moves(m) = 1;
        end
    end
    dof = floor(sum(moves)/2);

if get(handles.pm_distance,'Value') == 2
    targetNum = 2.^dof;
    if targetNum == 1
        targetNum = 'N/A';
    end
    
    % back fix for different target DOFs
    targetDOF = get(handles.pm_targetDOF,'Value');
    if dof == 3
        if targetDOF == 1
            targetNum = 6;
        end
        if targetDOF == 2
            targetNum = 12;
        end
    end
    if targetDOF > dof     % the requested target DOF exceeds the allowable movement dofs
            targetNum = 'N/A';
    end
    
    set(handles.et_nR,'String', num2str(targetNum));
    set(handles.et_nR,'Enable', 'off');
    set(handles.pm_targetDOF,'Enable','on');
elseif get(handles.pm_distance,'Value') == 3
    set(handles.pm_targetDOF,'Value',dof);
    set(handles.pm_targetDOF,'Enable','off');
    set(handles.et_nR,'Enable', 'on');
else
    set(handles.et_nR,'Enable', 'on');
    set(handles.pm_targetDOF,'Enable','on');
end

end

