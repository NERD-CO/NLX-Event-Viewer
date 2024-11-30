getPCname = getenv('COMPUTERNAME');

switch getPCname
    case 'xx' % Home PC

    case 'DESKTOP-EGFQKAI' % Laptop
        githubStub = 'C:\Users\johna\OneDrive\Documents\Github';

    case 'yy' % Work PC

end

%% Add Github paths
addpath([githubStub,'\NLX-Event-Viewer\NLX_Reference_Analysis\'])
addpath([githubStub,'\NLX-Event-Viewer\NLX_IO_Code\'])

%% CD to data folder
dataFOLDER = '';

cd(dataFOLDER);

eventFILEname = '';

[Timestamps, EventIDs, TTLs, Extras, EventStrings, Header] =...
            Nlx2MatEV(eventFILEname, [1 1 1 1 1], 1, 1, [] );


