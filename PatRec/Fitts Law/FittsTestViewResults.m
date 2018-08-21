

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
% Function to display results of Fitts' Law Test.
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-10-10 / Jake Gusman / Creation
% 20xx-xx-xx / Author    / Comment on update


function FittsTestViewResults(fittsTest)

Metric = {'Throughput';'Efficiency';'Overshoot';'Stopping Distance'; 'Completion Rate'};
Mean = [fittsTest.throughPut; fittsTest.efficiency; fittsTest.overshoot; fittsTest.stopDist; fittsTest.compRate];
StdDeviation = [fittsTest.throughPutStd; fittsTest.efficiencyStd; fittsTest.overshootStd; fittsTest.stopDistStd; fittsTest.compRateStd];

metricsTable = table(Metric,Mean,StdDeviation)

figure
errorbar(fittsTest.indDiff, fittsTest.compTime,fittsTest.compTimeStd, 'Marker', 'o');
xlabel('Index of Difficulty (bits)');ylabel('Completion Time (sec)');


