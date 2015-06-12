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
% A class used to keep track of which motor, pwmID/motorID, is what type of
% motor. This to differentiate between the ones in the hand and the ones
% for the pan/tilt. It also keeps track of the current position of the
% movement.
% --------------------------Updates--------------------------
% 2012-05-25 / Nichlas Sander  / Creation
% 20xx-xx-xx / Author  / Comment on update

classdef motor
   properties
        id
        type
        pct
   end
   methods
       function obj = motor(motorId,motorType,position)
            obj.id = motorId;
            obj.type = motorType;
            obj.pct = position;
       end
   end
end