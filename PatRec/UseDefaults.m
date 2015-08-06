%BioPatRec Data Treatment Process:
function UseDefaults(button, simultaneous)
[file, path] = uigetfile({'*.mat';'*.csv'});
load([path,file]);
set(button, 'String', 'Wait');
progress = waitbar(0,'PreProcessing');
drawnow;
handles = NaN;

    if isfield(recSession,'trdata')
        recSession = rmfield(recSession,'trdata');         
    end
    if isfield(recSession,'cTp')
        recSession = rmfield(recSession,'cTp');         
    end
    
    if isfield(recSession,'nCh')
        nCh = recSession.nCh;
        if length(recSession.nCh) == 1
            recSession.nCh = 1:recSession.nCh;
            nCh = recSession.nCh;
        end    
    else
        nCh = 1:length(recSession.tdata(1,:,1));
        recSession.nCh = nCh;
    end

%Signal Treatment
sigTreated = RemoveTransient_cTp(recSession, 0.7);
sigTreated = AddRestAsMovement(sigTreated, recSession);
waitbar(0.2,progress);
nw = fix(sigTreated.cT * sigTreated.cTp * sigTreated.nR / 0.2);
trP = 0.4;
vP = 0.2;
tP = 0.4;

sigTreated.eCt      = sigTreated.cT*sigTreated.cTp;
overlap = 0.05;
tT = sigTreated.cT * sigTreated.cTp * sigTreated.nR;
tw = 0.2;
offset = ceil(tw/overlap);
nw = fix(tT / overlap) - offset;
trN = fix(trP * nw);
vN = fix( vP* nw);
tN = fix(tP * nw);
        while trN+vN+tN < nw
            tN = tN + 1;
        end
%Treat
sigTreated.trSets = trN;
sigTreated.vSets = vN;
sigTreated.tSets = tN;
sigTreated.nW = nw;
sigTreated.tW = tw;
sigTreated.wOverlap = overlap;
sigTreated.fFilter = 'None';
sigTreated.sFilter = 'None';

sigTreated.twSegMethod = 'Overlapped Cons';
waitbar(0.4,progress,'Treating');

%% Split the data into the time windows
[trData, vData, tData] = GetData(sigTreated);    
%Remove raw trated data
sigTreated = rmfield(sigTreated,'trData');                 
% add the new sets of tw for tr, v and t
sigTreated.trData = trData;
sigTreated.vData = vData;
sigTreated.tData = tData;

%sigFeatures = GetAllSigFeatures(handles, sigTreated);
sigFeatures.sF      = sigTreated.sF;
sigFeatures.tW      = sigTreated.tW;
sigFeatures.nCh     = sigTreated.nCh;
sigFeatures.mov     = sigTreated.mov;

% temporal conditional to keep compatibility with olrder rec session
if isfield(sigTreated,'dev')
    sigFeatures.dev     = sigTreated.dev;
else
    sigFeatures.dev     = 'Unknow';
end 

if isfield(sigTreated,'comm')
    sigFeatures.comm    = sigTreated.comm;
    if strcmp(sigFeatures.comm, 'COM')
        if isfield(sigTreated,'comn')
            sigFeatures.comn    = sigTreated.comn;
        end
    end
else
    sigFeatures.comm     = 'N/A';
end   

sigFeatures.fFilter = sigTreated.fFilter;
sigFeatures.sFilter = sigTreated.sFilter;
sigFeatures.trSets  = sigTreated.trSets;
sigFeatures.vSets   = sigTreated.vSets;
sigFeatures.tSets   = sigTreated.tSets;
waitbar(0.5,progress,'Treating');
nM = sigTreated.nM;          % Number of exercises

for m = 1: nM
    for i = 1 : sigTreated.trSets
        trFeatures(i,m) = GetSigFeatures(sigTreated.trData(:,:,m,i),sigTreated.sF);
    end
end
waitbar(0.6,progress,'Treating');
for m = 1: nM
    for i = 1 : sigTreated.vSets
        vFeatures(i,m) = GetSigFeatures(sigTreated.vData(:,:,m,i),sigTreated.sF);
    end
end
waitbar(0.7,progress,'Treating');
for m = 1: nM
    for i = 1 : sigTreated.tSets
        %tFeatures(i,m) = analyze_signal(sigTreated.tData(:,:,m,i),sigTreated.sF);
        tFeatures(i,m) = GetSigFeatures(sigTreated.tData(:,:,m,i),sigTreated.sF);
    end
end
waitbar(0.75,progress,'Treating');
sigFeatures.trFeatures = trFeatures;    
sigFeatures.vFeatures  = vFeatures;    
sigFeatures.tFeatures  = tFeatures;
%Offline PatRec (Top4+tcard, LDA, OvsO)
%%sigFeatures = get(handles.t_sigFeatures,'UserData');
sigFeatures.eTrSets = trN;
sigFeatures.eVSets = vN;
sigFeatures.eTSets = tN; 
%?No-norm set?
%?No-feature reduction?
waitbar(0.85,progress,'Training');
if (strcmp(simultaneous,'false'))
movMix = 'Individual Mov';
randFeatures = true;
confMatFlag = false; 
alg = 'Discriminant A.';
tType = 'linear';
topology = 'One-vs-One';
selFeatures = {'tmabs';'twl';'tzc';'tslpch2';'tcard'};
normSets = 'Select Normalization';
algConf = [];
featReducAlg = 'Select Reduc./Selec.';
patRec = OfflinePatRec(sigFeatures, selFeatures, randFeatures, normSets, alg, tType, algConf, movMix, topology, confMatFlag, featReducAlg);
handles.patRec = patRec;
Load_patRec(handles.patRec, 'GUI_TestPatRec_Mov2Mov',1);
set(button, 'String', 'Train Individual Mov)');
waitbar(1,progress,'Training');
close(progress);
else
movMix = 'Mixed Output';
randFeatures = true;
confMatFlag = false; 
alg = 'MLP';
tType = 'Backpropagation';
topology = 'Ago-antagonistAndMixed';
selFeatures = {'tmabs';'twl';'tzc';'tslpch2';'tcard'};
normSets = 'Midrange0Range2';
algConf = [];
featReducAlg = 'Select Reduc./Selec.';
patRec = OfflinePatRec(sigFeatures, selFeatures, randFeatures, normSets, alg, tType, algConf, movMix, topology, confMatFlag, featReducAlg);
handles.patRec = patRec;
Load_patRec(handles.patRec, 'GUI_TestPatRec_Mov2Mov',1);
set(button, 'String', 'Train Simultaneous Mov'); 
waitbar(1,progress,'Training');
close(progress);
end
end