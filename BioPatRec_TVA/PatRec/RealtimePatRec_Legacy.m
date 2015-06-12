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
% Function to execute real-time patrec using the offline trained algorithm
% which information is stored in patRec
%
% --------------------------Updates--------------------------
% 2011-07-27 / Max Ortiz  / Creation
% 2011-08-03 / Max Ortiz  / Separation of "SignalProcessing_RealtimePatRec"
% 2011-11-17 / Max Ortiz  / Added the motors coupling
% 2011-12-07 / Nichlas Sander / Added VRE Coupling and VRE commands.

function RealtimePatRec(patRec, handles)

% Get sampling time
sT = str2double(get(handles.et_testingT,'String'));

%% Is there an option for coupling with the motors?
if isfield(handles,'cb_motorCoupling') %&& ~isfield(handles,'com')
    motorCoupling = get(handles.cb_motorCoupling,'Value');    
else
    motorCoupling = 0;
end

if isfield(handles,'cb_VRE') %&& ~isfield(handles,'com')
    vreCoupling = get(handles.cb_VRE,'Value');    
else
    vreCoupling = 0;
end

%Is the motor coupling selected?
if motorCoupling

    %Initialize
    motorIdx = zeros(1,10);
    pwmAs = zeros(1,10);
    pwmBs = zeros(1,10);
    movSpeeds = zeros(1,10);
    
    % Get the links to the motors
    for i = 1 : size(motorIdx,2)
        pmID = ['handles.pm_m' num2str(i)];
        motorIdx(i) = get(eval(pmID),'Value'); 
        speedID = ['handles.et_speed' num2str(i)];
        movSpeeds(i) = str2double(get(eval(speedID),'String')); 
    end
    
    % Init variables for control
    pwmIDs = ['A';'A';'B';'B';'C';'C';'D';'D';'E';'E'];
    for i = 1 : 2 : size(pwmIDs)
        pwmAs(i)   = movSpeeds(i);
        pwmBs(i)   = 0;
        pwmAs(i+1) = 0;
        pwmBs(i+1) = movSpeeds(i+1);
    end;
    
    % Arrenge according to selection
    pwmIDs = pwmIDs(motorIdx);
    pwmAs = pwmAs(motorIdx);
    pwmBs = pwmBs(motorIdx);
    
end    

%% Initialize DAQ card
% Note: A function for DAQ selection will be required when more cards are
% added
if strcmp(patRec.dev,'ADH')
    
else % at this poin everything else is the NI - USB6009
    chAI = zeros(1,8);
    chAI(patRec.nCh) = 1; 
    %ai = InitNI(patRec.sF,sT,chAI);
    s = InitSBI(patRec.sF,sT,chAI);
    lh = s.addlistener('DataAvailable', @plotData);

    % Change the peek time
    s.NotifyWhenDataAvailableExceeds = patRec.sF*patRec.tW;
end

%% Testing
% Note: Probabily this way of testing only works for the NI
% Specific funtions per card might be required.

start(ai);  % Start the daya acquisition
nTW = 1;    % Number of time windows

% Wait until the first samples are aquired
while ai.SamplesAcquired < patRec.sF*patRec.tW
end
% start DAQ
while ai.SamplesAcquired < patRec.sF*sT
    
    % Processing time start
    procTimeS = tic;

    %Data Peek
    data = peekdata(ai,patRec.sF*patRec.tW); 

    %Signal processing
    tSet = SignalProcessing_RealtimePatRec(data, patRec);
    
    % One shoot PatRec
    [outMov outVector] = OneShotPatRecClassifier(patRec, tSet);    
    % [outMov outVector] = OneShotPatRec(patRec.patRecTrained, tSet);

    % Quick patch for simultaneous rec using neural nets
%     if strcmp(patRec.patRecTrained.algorithm,'ANN')
%         outMov = find(round(outVector));
%         if isempty(outMov)
%             outMov = size(outVector,1);
%         end
%     end
    
%     if strcmp(patRec.algorithm,'ANN');
%         
%     elseif strcmp(patRec.algorithm,'DA')
%         outMov = DiscriminantTest(patRec.coeff, tSet, patRec.training);
%     end    
    
    % Compute time
    procT(nTW) = toc(procTimeS);

    % Show results
    set(handles.lb_movements,'Value',outMov);
    drawnow;
        
    % Send vector to the motors
    if motorCoupling
        ActivateMotors(handles.com, pwmIDs, pwmAs, pwmBs, outMov);
    end
    if vreCoupling
        dof = round(outMov/2);
        dir = mod(outMov,2);
        VREActivation(handles.vre_Com, 10, 0.1, dof, dir) 
    end
    % Next cycle
    nTW = nTW + 1;
    
end
%% Finish session
%Stop motors
if motorCoupling
    ActivateMotors(handles.com, pwmIDs, pwmAs, pwmBs, 0);
end
%Stop acquisition        
stop(ai);
delete(ai);

set(handles.et_avgProcTime,'String',num2str(mean(procT(2:end))));

%Plot processing time
figure();
hist(procT(2:end));
