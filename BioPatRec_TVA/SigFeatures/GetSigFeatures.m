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
% Funtion to Breakdown the time and frecuency features
% Input : data  Matrix of MxN where the rows are the channels
%       : sF    Sampling Frequency
%       : fID   features ID, if not fID given, it compute the hard-coded
%               ones
% Output: features    Signal features is an struct
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-27 / Max Ortiz  / Creation from the old analyze_signal fuction in
%                           EMG_AQ in 2009
% 2012-07-19 / Max Ortyiz / Add LoadFeaturesID funtion instead of
%                           hard-coded IDs
% 2012-11-23 / Max Ortyiz / Vectorized implementation of tzc and tslpch2
%                           for speed improvement
%                           
% 20xx-xx-xx / Author     / Comment on update

function xFeatures = GetSigFeatures(data,sF,fID)

    % If not features ID were receved, then compute the following ones:
    if ~exist('fID','var')
        fID = LoadFeaturesIDs;            
    end

    % General information required to calculate different signal features
    % other processing is added by specific futures in their functions
    procFeatures.ch      = length(data(1,:));
    procFeatures.sp      = length(data(:,1));
    procFeatures.sF      = sF;
    procFeatures.data    = data;
    procFeatures.absdata = abs(data);
    procFeatures.f       = {};
    
    % Add data of the fast fourier transform if a frequency feature is
    % required
    % This verification needs to be optimized
    for i = 1 : size(fID,1)
        temp = fID{i};
        if temp(1) == 'f'
            procFeatures = GetFFT(procFeatures);
            break;
        end
    end
    
    % Calculate signal features
    for i = 1 : size(fID,1)
        fName = ['GetSigFeatures_' fID{i}];
        procFeatures = feval(fName, procFeatures); 
    end

    xFeatures = procFeatures.f;

end

% -----------------------------------------------
function pF = GetSigFeatures_tmn(pF)
% 2011-07-27 Max Ortiz / Creation
    pF.f.tmn = mean(pF.data);
end

% -----------------------------------------------

function pF = GetSigFeatures_tmabs(pF)
% 2011-07-27 Max Ortiz / Creation
    pF.f.tmabs = mean(pF.absdata);  
end

% -----------------------------------------------

function pF = GetSigFeatures_tmd(pF)
% 2011-07-27 Max Ortiz / Creation
    pF.f.tmd = median(pF.data);
end

% -----------------------------------------------

function pF = GetSigFeatures_tstd(pF)
% 2011-07-27 Max Ortiz / Creation
    pF.f.tstd = std(pF.data);
end

% -----------------------------------------------

function pF = GetSigFeatures_tvar(pF)
% 2011-07-27 Max Ortiz / Creation
    pF.f.tvar = var(pF.data);
end

% -----------------------------------------------

function pF = GetSigFeatures_twl(pF)
% Waveform Length (acumulative changes in the length)
% 2011-07-27 Max Ortiz / Creation
    mdata = [zeros(1,pF.ch) ; pF.data(1:pF.sp-1,:)];
    pF.f.twl = sum(abs(pF.data - mdata));
end

% -----------------------------------------------

function pF = GetSigFeatures_trms(pF)
% 2011-07-27 Max Ortiz / Creation
    pF.f.trms = sqrt(sum(pF.absdata .^ 2)/pF.sp);
end

% -----------------------------------------------

function pF = GetSigFeatures_tzc(pF)
% 2011-07-27 Max Ortiz / Creation
    %check if tmabs is available
    if ~isfield(pF.f,'tmabs')
        pF = GetSigFeatures_tmabs(pF);
    end
    
    tmp = repmat(pF.f.tmabs,[size(pF.data,1),1] );
    zc = ( pF.data >= tmp ) - (pF.data < tmp );
    pF.f.tzc = sum( ( zc(1:pF.sp-1,:) - zc(2:pF.sp,:) ) ~= 0);
    
%     % Zero Crossing / using the abs mean as threshold
%     for i = 1 : pF.ch
%         zc = (pF.data(:,i) >= pF.f.tmabs(i)) - (pF.data(:,i) < pF.f.tmabs(i));
%         pF.f.tzc(i) = sum((zc(1:pF.sp-1) - zc(2:pF.sp)) ~= 0);
%     end
    
end

% -----------------------------------------------

function pF = GetSigFeatures_tpks(pF)
% 2011-07-27 Max Ortiz / Creation
    % Peaks using rms value

    if ~isfield(pF.f,'trms')
        pF = GetSigFeatures_trms(pF);
    end
    if ~isfield(pF,'pks')        
        for i = 1 : pF.ch
            [pks, locs] = findpeaks(pF.absdata(:,i),'minpeakheight',pF.f.trms(i));
            pF.pks{i} = pks;
            pF.locs{i} = locs;
        end
    end        

    for i = 1 : pF.ch
        pF.f.tpks(i) = size(pF.pks{i},2);        
    end
end

% -----------------------------------------------

function pF = GetSigFeatures_tmpks(pF)
% 2011-07-27 Max Ortiz / Creation
    % Mean of peaks using rms value

    if ~isfield(pF.f,'trms')
        pF = GetSigFeatures_trms(pF);
    end
    if ~isfield(pF,'pks')        
        for i = 1 : pF.ch
            [pks, locs] = findpeaks(pF.absdata(:,i),'minpeakheight',pF.f.trms(i));
            pF.pks{i} = pks;
            pF.locs{i} = locs;
        end
    end        

    for i = 1 : pF.ch
        pF.f.tmpks(i) = mean(pF.pks{i});        
    end
end

% -----------------------------------------------

function pF = GetSigFeatures_tmvel(pF)
% 2011-07-27 Max Ortiz / Creation
    % Mean firing velocity using the peaks

    if ~isfield(pF.f,'trms')
        pF = GetSigFeatures_trms(pF);
    end
    if ~isfield(pF,'pks')        
        for i = 1 : pF.ch
            [pks, locs] = findpeaks(pF.absdata(:,i),'minpeakheight',pF.f.trms(i));
            pF.pks{i} = pks;
            pF.locs{i} = locs;
        end
    end        
    if ~isfield(pF,'pksData')
        for i = 1 : pF.ch
            pF.pksData{i} = pF.data(pF.locs{1}, i);          % Only data from the peaks
            pF.diffPksData{i} = diff(pF.pksData{i});           % Get the diff of the peaks or velocity of the peaks
        end
    end    

    for i = 1 : pF.ch
        if isempty(pF.diffPksData{i})
            pF.f.tmvel(i) = 0;
        else
            pF.f.tmvel(i) = mean(abs(pF.diffPksData{i})); % Get mean of the firing velocity
        end
    end
end

% -----------------------------------------------

function pF = GetSigFeatures_tslpch1(pF)
% 2011-07-27 Max Ortiz / Creation
    % Slope Changes using the rms pks
    % needs to be reviewed

    if ~isfield(pF.f,'trms')
        pF = GetSigFeatures_trms(pF);
    end
    if ~isfield(pF.f,'tmvel')
        pF = GetSigFeatures_tmvel(pF);
    end
    if ~isfield(pF,'pks')        
        for i = 1 : pF.ch
            [pks, locs] = findpeaks(pF.absdata(:,i),'minpeakheight',pF.f.trms(i));
            pF.pks{i} = pks;
            pF.locs{i} = locs;
        end
    end        
    if ~isfield(pF,'pksData')
        for i = 1 : pF.ch
            pF.pksData{i} = pF.data(pF.locs{1}, i);          % Only data from the peaks
            pF.diffPksData{i} = diff(pF.pksData{i});           % Get the diff of the peaks or velocity of the peaks
        end
    end    

    for i = 1 : pF.ch
        if isempty(pF.diffPksData{i})
            pF.f.tslpch1(i) = 0;
        else
            tmax = max(pF.diffPksData{i});
            if tmax > pF.f.tmvel(i)
                pF.f.tslpch1(i) = length(findpeaks(pF.diffPksData{i},'minpeakheight',pF.f.tmvel(i)));
            else
                pF.f.tslpch1(i) = 0;        
            end                        
        end
    end
end

% -----------------------------------------------

function pF = GetSigFeatures_tslpch2(pF)
% 2011-07-27 Max Ortiz / Creation
    % Slope Changes using the diff of the raw signal and the computing
    % zero crossing

    if ~isfield(pF,'diffData')
        pF.diffData = diff(pF.data);           % Get the diff
    end    
    
    zc = (pF.diffData > 0 ) - (pF.diffData < 0);
    pF.f.tslpch2 = sum( abs( zc(1:end-1,:) - zc(2:end,:) ) > 1 );
    
%     for i = 1 : pF.ch
%         zc = (pF.diffData(:,i) > 0) - (pF.diffData(:,i) < 0); 
%         pF.f.tslpch2(i) = sum(abs(zc(1:end-1) - zc(2:end)) > 1);
%     end
    
end

% -----------------------------------------------

function pF = GetSigFeatures_tpwr(pF)
% 2011-07-27 Max Ortiz / Creation
    pF.f.tpwr = sum(pF.absdata.^2)/pF.sp;
end

% -----------------------------------------------

function pF = GetSigFeatures_tcr(pF)
% 2011-07-27 Max Ortiz / Creation
    % Correlation
    % Close to 1 means mutual increment
    % Close to -1 means mutual decrement
    % Close to 0 is no correlation or no-linear correlation
    mcr = corrcoef(pF.data);
    k=1;
    for i = 1: pF.ch
        for j = i+1 : pF.ch
            pF.f.tcr(k) = mcr(i,j);
            k=k+1;
        end
    end
end

% -----------------------------------------------

function pF = GetSigFeatures_tcv(pF)
% 2011-07-27 Max Ortiz / Creation
    % Covariance
    % Note: It is possible that the covariance is not required because corr is
    % computer already
    mcr = cov(pF.data);
    k=1;
    for i = 1: pF.ch
        for j = i+1 : pF.ch
            pF.f.tcv(k) = mcr(i,j);
            k=k+1;
        end
    end
end

% ######################### Frequency Features ###################

function pF = GetSigFeatures_fwl(pF)
% 2011-07-27 Max Ortiz / Creation
    % Waveform Length (acumulative changes in the length)
    tempdataf = [zeros(1,pF.ch) ; pF.fftData(1:end-1,:)];    
    pF.f.fwl = sum(abs(pF.fftData - tempdataf));
end

% -----------------------------------------------

function pF = GetSigFeatures_fmn(pF)
% 2011-07-27 Max Ortiz / Creation
    % Mean Frequency
    for ch = 1 : pF.ch
        fmn = 0;
        for i = 1 : length(pF.fftData(:,1))
            if fmn <= pF.fftDataT(ch)/2
                fmn = fmn + pF.fftData(i,ch);
            else
                break;
            end
        end
        pF.f.fmn(ch) = pF.fV(i-1);
    end                
end
% -----------------------------------------------

function pF = GetSigFeatures_fmd(pF)
% 2011-07-27 Max Ortiz / Creation
        % Median Frequency
    if ~isfield(pF.f,'fwl')
        pF = GetSigFeatures_fwl(pF);
    end
    tempdataf = [zeros(1,pF.ch) ; pF.fftData(1:end-1,:)];  
    for ch = 1 : pF.ch
        fmd = 0;
        for i = 1 : length(pF.fftData(:,1))
            if fmd <= pF.f.fwl(ch)/2
                fmd = fmd + abs(pF.fftData(i,ch) - tempdataf(i,ch));
            else
                break;
            end
        end
        pF.f.fmd(ch) = pF.fV(i-1);
    end                
end

% -----------------------------------------------

function pF = GetSigFeatures_fpmn(pF)
% 2011-07-27 Max Ortiz / Creation
    % Find the highest frequency peaks and gets its mean
    if ~isfield(pF,'fPks')        
        nP = 5;    % Number of peaks to be used
        for i = 1 : pF.ch
            [pks, locs] = findpeaks(pF.fftData(:,i),'SORTSTR','descend');
            pF.fPks(:,i)  = pks(1:nP);
            pF.fLocs(:,i) = locs(1:nP);
        end
    end 
    
    for ch = 1 : pF.ch
        pF.f.fpmn(ch) =  mean(pF.fV(pF.fLocs(:,ch)));
    end
end

% -----------------------------------------------

function pF = GetSigFeatures_fpmd(pF)
% 2011-07-27 Max Ortiz / Creation
    % Find the highest frequency peaks and gets its mean
    if ~isfield(pF,'fPks')        
        nP = 5;    % Number of peaks to be used
        for i = 1 : pF.ch
            [pks, locs] = findpeaks(pF.fftData(:,i),'SORTSTR','descend');
            pF.fPks(:,i)  = pks(1:nP);
            pF.fLocs(:,i) = locs(1:nP);
        end
    end 
    
    for ch = 1 : pF.ch
        pF.f.fpmd(ch) =  median(pF.fV(pF.fLocs(:,ch)));
    end
end
% -----------------------------------------------

function pF = GetSigFeatures_fpstd(pF)
% 2011-07-27 Max Ortiz / Creation
    % Find the highest frequency peaks and gets its mean
    if ~isfield(pF,'fPks')        
        nP = 5;    % Number of peaks to be used
        for i = 1 : pF.ch
            [pks, locs] = findpeaks(pF.fftData(:,i),'SORTSTR','descend');
            pF.fPks(:,i)  = pks(1:nP);
            pF.fLocs(:,i) = locs(1:nP);
        end
    end 
    
    for ch = 1 : pF.ch
        pF.f.fpstd(ch) =  std(pF.fV(pF.fLocs(:,ch)));
    end
end

% -----------------------------------------------

function pF = GetSigFeatures_tdam(pF)
% 2012-05-22 Max Ortiz / Creation, found in FP10

    temp = zeros(size(pF.data));
    temp(1:end-1,:) = pF.data(2:end,:); % Compute k+1
    diffAmp = abs(temp - pF.data);      % compute the absulute difference
    pF.f.tdam = sum(diffAmp(1:end-1,:)) ./ (pF.sp-1); 

end

function pF = GetSigFeatures_tfd(pF)
% 2012-06-06 Max Ortiz / Creation, found in GS97

    mdata = [zeros(1,pF.ch) ; pF.data(1:pF.sp-1,:)];
    absDiff = abs(pF.data - mdata); 
    L = sum(absDiff);    
    n = pF.sp;  %Data points or samples
    % This is not calculated properly, max of absDiff is only the max
    % distance between adjacent points and not all the points in the set
    d = max(absDiff); % Max distance between two points.
    
    pF.f.tfd = log(n) ./ (log(n) + (d./L));
    
end

function pF = GetSigFeatures_tmfl(pF)
% 2012-06-06 Max Ortiz / Creation, found in AK10
% Maximum Fractal Length

    N = pF.sp;  %Total samples
    m = 1;      %Initial time
    
    for k = 1 : 9 : 10;
        limTop = floor((N-m)/k);
        for i = 1 : limTop
            a = m+(i*k);
            b = m+((i-1)*k);
            tempL(i,:) = abs(pF.data(a,:) - pF.data(b,:));
        end
        L(k,:) = sum(tempL) .* ((N-1)/(limTop*k)) ./ k; 
        clear tempL;
    end

    pF.f.tmfl = L(1,:);
    
    pF.L = L;

end

function pF = GetSigFeatures_tfdh(pF)
% 2012-06-06 Max Ortiz / Creation, found in AK10
% Fractal dimension using Higuchi algorithm

    if ~isfield(pF.f,'tmfl')
        pF = GetSigFeatures_tmfl(pF);
    end
    
    dX = log(pF.L(1,:))-log(pF.L(10,:));
    dY = log(10)-log(1);
    pF.f.tfdh = dX./dY;
    
end

