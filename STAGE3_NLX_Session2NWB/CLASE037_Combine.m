function [] = CLASE037_Combine()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[miFname , miLoc] = uigetfile('*.csv');
microLoc = fullfile(miLoc , miFname);
microTable = readtable(microLoc);

app.channelID.micro = microTable;


[maFname , maLoc] = uigetfile('*.csv');
macroLoc = fullfile(maLoc , maFname);
macroTable = readtable(macroLoc);

app.channelID.macro = macroTable;


eventFILE1 =  

eventFILE2 = 

ephys1 = 

ephys2 = 




end









function [foundCSC , timeDIF] = findCSCid(eventLOC , timeSTAMP)

% Go to Event Directory
cd(eventLOC)
% Locate unique CSC extension files (i.e, CSC1__001, __002)
cscRepoT = dir('*.ncs');
cscRepo = {cscRepoT.name};

fileEls = cellfun(@(x) strsplit(x, {'_','.'}), cscRepo, 'UniformOutput',false);

cscAllnum = cellfun(@(x) x{1}, fileEls , 'UniformOutput',false);

uniCSC = unique(cscAllnum);
useCSC = uniCSC(1);

allCSCns = transpose(cscRepo(ismember(cscAllnum,useCSC)));

% Loop through all extension
micAll = zeros(size(allCSCns));
ephInd = zeros(size(allCSCns));
for ci = 1:length(allCSCns)

    [TimestampsCSC, ~, ~, ~,...
        ~, ~] = Nlx2MatCSC(allCSCns{ci}, [1 1 1 1 1], 1, 1, [] );

    % Create interpolation
    TimestampsINT = nlxEVinterp(app , TimestampsCSC);

    % Create a table with the time difference between nearest value
    % and timestamp
    offSETtime = abs(TimestampsINT - timeSTAMP);
    [micOffset , ephysInd] = min(min(offSETtime));

    micAll(ci) = micOffset;
    ephInd(ci) = ephysInd;

end
% Output CSC duplicate with the lowest value
chckTable = table(allCSCns,micAll,ephInd);
chckTable.msAll = chckTable.micAll/(1e+6);

[~ , minREC] = min(chckTable.micAll);

foundCSC = chckTable.allCSCns{minREC};
timeDIF = chckTable.msAll(minREC);

end


function timeMAT = nlxEVinterp(timeVEC)

timeMAT = zeros(512,size(timeVEC,2));
timeMAT(1,:) = timeVEC;
for ti = 1:size(timeVEC,2)

    if ti == size(timeVEC,2)
        tmpl = linspace(timeVEC(ti),timeVEC(ti)+16000,511);
    else
        tmpl = linspace(timeVEC(ti),timeVEC(ti + 1),511);
    end
    tmplt = transpose(tmpl);
    timeMAT(2:512,ti) = tmplt;
end

end




function [outDATA , sampFrOUT , adBitVal, outTIME] = CSCLoader(app , tmpTable , elecTYPE)

% sessLOGdat

app.procPROG.Message = ['Working on file ', elecTYPE, ' table building'];

cd(app.eventLOC)

cscSuffix = getCurCSC(app);

if strcmp(elecTYPE,'MI')
    eleROWs = tmpTable.label(contains(tmpTable.label,'MI'));
    eleROWi = eleROWs{1};
    eleROWstrs = strsplit(eleROWi,'_');
    eleROWid = eleROWstrs{3}(2:end);
    tmpFnDim = ['CSC',eleROWid,cscSuffix];
elseif strcmp(elecTYPE,'MA')
    eleROWs = tmpTable.label(contains(tmpTable.label,'MA'));
    eleROWi = eleROWs{1};
    eleROWstrs = strsplit(eleROWi,'_');
    eleROWid = eleROWstrs{3}(2:end);
    tmpFnDim = ['CSC',eleROWid,cscSuffix];
end

% tmpEle to get dimesions
% Get Timestamps
% Create all ts vector
[TimestampsCSC, ~, sf, ~,...
    ~, ~] = Nlx2MatCSC(tmpFnDim, [1 1 1 1 1], 1, 1, [] );
TimestampsINT = nlxEVinterp(app , TimestampsCSC);
TimStpRsh = reshape(TimestampsINT,1,numel(TimestampsINT));
sampFrOUT = sf(1);

% Trim data container
%             sampDUR = app.sessLOGdat{1}.StopTime - app.sessLOGdat{1}.StartTime;
%             minDUR = (sampDUR/1000000)/60; % 1000000 = microseconds : convert to seconds
[~,startIND] = min(abs(TimStpRsh - app.sessLOGdat{app.curSESS}.StartTime));
[~,stopIND] = min(abs(TimStpRsh - app.sessLOGdat{app.curSESS}.StopTime));

% REMOVE BUFFER ------------------ 08/05/2023 -- JAT

% startBUFF = startIND - 5000000;
% if startBUFF < 0
%     startBUFF = startIND;
% end
%
% stopBUFF = stopIND + 5000000;
% if stopBUFF > stopIND
%     stopBUFF = stopIND;
% end

outTIME = TimStpRsh(startIND:stopIND);

outDATA = zeros(length(eleROWs),numel(startIND:stopIND));

% Loop through channel IDs
for ti = 1:length(eleROWs)
    eleROWti = eleROWs{ti};
    eleROWtstr = strsplit(eleROWti,'_');
    cscNUM = eleROWtstr{3}(2:end);
    tmpCSC = ['CSC', cscNUM , cscSuffix];

    % Get raw data from NLX

    app.procPROG.Message = ['Loading file ', num2str(ti), ' out of ',...
        num2str(length(eleROWs))];

    try
        [~, ~, ~, ~,...
            Samples, HeaderCSC] = Nlx2MatCSC(tmpCSC, [1 1 1 1 1], 1, 1, [] );

    catch

        disp(['ERROR on ', tmpCSC]);

    end
    adLine = HeaderCSC(contains(HeaderCSC, 'ADBit'));
    adItems = strsplit(adLine{1},' ');
    adBitVal = str2double(adItems{2});
    %  adbitsVal = adBitVal;
    %  actVolts = Samples .* adBitVal; % in Volts
    % Reshape
    reshSamp = reshape(Samples,1,numel(Samples));
    nfinSamp = reshSamp;
    % int16
    samp16 = int16(nfinSamp);
    % Stack
    outDATA(ti,:) = samp16(startIND:stopIND);
end


end

function cscSuffix = getCurCSC(app)

CSCfName = app.UITable.Data.("CSC ID"){app.curROW}; % Check ?

if ~contains(CSCfName,'_')
    cscSuffix = '.ncs';
else
    cscSuffix = ['_',extractAfter(CSCfName,strfind(CSCfName,'_'))];
end

end


function [filterData , nFs] = mmfilterFun(app , mWireData , sFs ,  wireType)
% Extract relevant NWB info
if wireType == 1
    elecTYPE = 'MAcro';
else
    elecTYPE = 'MIcro';
end
app.procPROG.Message = ['Initiating Filtering for ', elecTYPE, ' data'];
% Sampling frequency
% Access the struct names in the NWB acquisition field
mwireData = mWireData;

Fs = sFs;

% Extract channel data
% Extract vector of data
% Extract channel of interest

if wireType == 1
    % t = mwNWB.acquisition.get('MacroWireSeries').data(1,:);
    tmpMWire = mwireData(1,:);
    numCols = ceil(size(tmpMWire,2)/8);
    filterData = zeros(size(mwireData,1),...
        numCols,'int16');
else
    ALLchannelData = mwireData;
    filterData = zeros(size(ALLchannelData),'int16');
end

% loop through channel data
for ci = 1:size(mwireData,1)
    app.procPROG.Message = ['Filtering file ', num2str(ci), ' out of ',...
        num2str(size(mwireData,1))];
    tmpChannel = mwireData(ci,:);
    if wireType == 1 % macro data
        app.procPROG.Message = ['Resample and notch filter ', num2str(ci), ' out of ',...
            num2str(size(mwireData,1))];
        %                     reSampDat = resample(tmpChannel,1,8);
        reSampDat = downsample(tmpChannel,8);
        nFs = round(Fs/8);
        cgrDATAnew = spectrumInterpolation(app, reSampDat', nFs, 60, 3.5, 1);
        hpFreq = 0.1;
    else % micro data
        cgrDATAnew = tmpChannel;
        nFs = Fs;
        hpFreq = 600;
        lpFreq = 3000;
    end
    % Both micro and macro high pass filter
    app.procPROG.Message = ['High pass file ', num2str(ci), ' out of ',...
        num2str(size(mwireData,1))];
    [highPASS,~] = highpass(cgrDATAnew , hpFreq , nFs);

    app.procPROG.Message = ['Low pass file ', num2str(ci), ' out of ',...
        num2str(size(mwireData,1))];
    if wireType == 2 % micro data will get low pass filtered
        [filterTmp,~] = lowpass(highPASS, lpFreq, nFs,...
            'ImpulseResponse', 'iir', 'Steepness' ,0.8);
    else
        filterTmp = highPASS;
    end
    filterData(ci,:) = filterTmp;
end



end

function newDat = spectrumInterpolation(~, data, Fs, Fl, neighborsToSample, neighborsToReplace)
assert(length(data) > 1 && width(data) == 1, "Please transpose your vector, and ensure that you are only passing in 1D data")
spectrum = fft(data);
mag = abs(spectrum); % We use the real spectrum to interpolate and remove the powerline noise.
phase = angle(spectrum);

binStepSize = length(mag) / Fs;
nextPowerBin = binStepSize * Fl;
neighborsToSample = uint32(binStepSize * neighborsToSample);
neighborsToReplace =  uint32(binStepSize * neighborsToReplace);
% We have to take care of each end of the spectrum differently.
% For the first half, the spectra is not reversed.
nearestPowerlineHarmonic = nextPowerBin;
binStart = nearestPowerlineHarmonic;

for i=binStart:nextPowerBin:length(mag)/2
    neighborSamples = mag(i-neighborsToSample:i+neighborsToSample, :);
    neighborhoodAverage = median(neighborSamples);
    for j = 1:width(data)
        mag(i-neighborsToReplace:i+neighborsToReplace, j) = neighborhoodAverage(j);
    end
end

nyquistFrequency = Fs / 2;
nearestPowerlineHarmonic = mod(nyquistFrequency, Fl); % This gives us the distance to the nyquist frequency starting from the middle.
binStart = (length(mag)/2) + (nearestPowerlineHarmonic * binStepSize);

% Now replace the other side

for i=binStart:nextPowerBin:(length(mag) - nextPowerBin)
    neighborSamples = mag(i-neighborsToSample:i+neighborsToSample, :);
    neighborhoodAverage = median(neighborSamples);
    for j = 1:width(data)
        mag(i-neighborsToReplace:i+neighborsToReplace, j) = neighborhoodAverage(j);
    end
end


% Create a new signal based on euler's formula.
newDat = mag.*exp(1i.*phase);
newDat = real(ifft(newDat));
end
