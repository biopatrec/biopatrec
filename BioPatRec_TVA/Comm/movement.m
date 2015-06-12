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
% This is a class to keep track of the movements which are performed. It
% holds the id and direction needed to move the VRE, and the ids of the
% motors which need to be activated.
% --------------------------Updates--------------------------
% 2012-05-25 / Nichlas Sander  / Creation
% 20xx-xx-xx / Author  / Comment on update

classdef movement
    properties
        id
        name
        idVRE
        vreDir
        motor
    end
    
    methods
        function obj = movement(id,name,idVRE,direction,motor)
           obj.id = id;
           obj.name = name;
           obj.idVRE = idVRE;
           obj.vreDir = direction;
           obj.motor = motor;
        end
        
        function [Movements, Motors] = Activate(obj, VRE, Motor, Distance, Movements, Motors)
           if(VRE)
                %Activate VRE with correct Direction and Distance 
                disp('vre');
           end
           if(Motor)
                %Activate Motor with correct Direction and Distance
                disp('motor');
           end
        end
    end
end