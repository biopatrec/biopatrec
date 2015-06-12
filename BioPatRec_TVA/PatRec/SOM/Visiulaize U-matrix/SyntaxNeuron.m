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
%  Function to define the spot vertices.
%
% Note: This function implemented in the same way of SOM toolbox Team[1]
%
% [1]-Juha Vesanto, Johan Himberg, Esa Alhoniemi, and Parhankangs
%     SOM Toolbox Team ,Helsinki University of Technology.
%     http://www.cis.hut.fi/somtoolbox/package/papers/techrep.pdf
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function neuron=SyntaxNeuron(shape)


switch shape
    case 'rect'
        neuron=[[-.5 -.5]; ...
            [-.5 .5];...
            [.5 .5];...
            [.5 -.5]];
    case 'hexa'
        neuron=[[0 0.6667];...
            [0.5 0.3333];...
            [0.5 -0.3333];...
            [0 -0.6667];...
            [-0.5 -0.3333];...
            [-0.5 0.3333]];
end