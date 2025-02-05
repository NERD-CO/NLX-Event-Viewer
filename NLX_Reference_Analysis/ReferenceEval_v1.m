getPCname = getenv('COMPUTERNAME');

switch getPCname
    case 'yy' % Home PC
        githubStub = 'C:\Users\johna\OneDrive\Documents\Github';

    case 'DESKTOP-EGFQKAI' % Laptop
        githubStub = 'C:\Users\johna\OneDrive\Documents\Github';

    case 'DESKTOP-I5CPDO7' % Work PC
        githubStub = 'C:\Users\Admin\Documents\Github';

end

%% Add Github paths
addpath([githubStub,'\NLX-Event-Viewer\NLX_Reference_Analysis\'])
addpath([githubStub,'\NLX-Event-Viewer\NLX_IO_Code\'])

%% CD to data folder 11/19/2024
dataFOLDER = 'H:\Transfer_01272025\transfer_01222025\MW44\2025-01-16_10-16-26';

cd(dataFOLDER);

eventFILEname = 'Events.nev';

[Timestamps, ~, TTLs, ~, EventStrings, Header] =...
            Nlx2MatEV(eventFILEname, [1 1 1 1 1], 1, 1, [] );

%% 11/19/2024 - First reference recording

% 1. Within tetrode
% 2. Across tetrode
% 3. Macro within hybrid
% 4. Macro ipsilateral
% 5. Macro contralateral

% Find 'Starting Recording'

startINDICES = matches(EventStrings,'Starting Recording');
startLOCS = find(startINDICES);
stopINDICES = matches(EventStrings,'Stopping Recording');
stopLOCS = find(stopINDICES);

startTStamps = Timestamps(startINDICES);
stopTStamps = Timestamps(stopINDICES);

offSET_minutes = ((stopTStamps - startTStamps)/1000000)/60;

lessTHAN5mins = logical([1 0 0 0 0 0 0]);
useSTARTi = startLOCS(lessTHAN5mins);
useSTOPi = stopLOCS(lessTHAN5mins);
useTIMESstart = startTStamps(lessTHAN5mins);
useTIMESstop = stopTStamps(lessTHAN5mins);

refStyle = {'within_tetrode','across_tetrode','macro_onHybrid'};
recDepth = '1mm';
reference1 = struct;
for ii = 1:sum(lessTHAN5mins)
 
    reference1.style{ii} = refStyle{ii};
    reference1.startNLX_IND(ii) = useSTARTi(ii);
    reference1.startNLX_time(ii) = useTIMESstart(ii);
    reference1.stopNLX_IND(ii) = useSTOPi(ii);
    reference1.stopNLX_time(ii) = useTIMESstop(ii);

end

save('MW44_Ref2.mat','reference1')

%% CD to data folder 11/21/2024
dataFOLDER = 'I:\EMU_MW40\NWB\2024-11-21_10-02-41';

cd(dataFOLDER);

eventFILEname = 'Events.nev';

[Timestamps, ~, TTLs, ~, EventStrings, Header] =...
            Nlx2MatEV(eventFILEname, [1 1 1 1 1], 1, 1, [] );




%% 11/19/2024 - First reference recording

% 1. Within tetrode
% 2. Across tetrode
% 3. Macro within hybrid

% Find 'Starting Recording'

startINDICES = matches(EventStrings,'Starting Recording');
startLOCS = find(startINDICES);
stopINDICES = matches(EventStrings,'Stopping Recording');
stopLOCS = find(stopINDICES);

startTStamps = Timestamps(startINDICES);
stopTStamps = Timestamps(stopINDICES);

offSET_minutes = ((stopTStamps - startTStamps)/1000000)/60;

useSTARTi = startLOCS;
useSTOPi = stopLOCS;
useTIMESstart = startTStamps;
useTIMESstop = stopTStamps;

refStyle = {'within_tetrode','across_tetrode','macro_onHybrid'};
recDepth = '0.5mm';
reference2 = struct;
for ii = 1:3
 
    reference2.style{ii} = refStyle{ii};
    reference2.startNLX_IND(ii) = startLOCS(ii);
    reference2.startNLX_time(ii) = startTStamps(ii);
    reference2.stopNLX_IND(ii) = stopLOCS(ii);
    reference2.stopNLX_time(ii) = stopTStamps(ii);

end

refStyle = {'within_tetrode','across_tetrode','macro_onHybrid'};
recDepth = '1mm';
reference3 = struct;
for ii = 1:3
 
    reference3.style{ii} = refStyle{ii};
    reference3.startNLX_IND(ii) = startLOCS(ii+3);
    reference3.startNLX_time(ii) = startTStamps(ii+3);
    reference3.stopNLX_IND(ii) = stopLOCS(ii+3);
    reference3.stopNLX_time(ii) = stopTStamps(ii+3);

end

