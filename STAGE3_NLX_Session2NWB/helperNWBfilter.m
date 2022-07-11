cd('C:\Users\John\Downloads\08192020\08192020\2020-08-19_11-04-04\NWB_Data')

%%

%ma_timestamps = nwb_pdil.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MacroWireSeries').timestamps.load;" 
% I get a 8214528x1 array


testfile = nwbRead('AT5_Session_1_filter.nwb');

%% Get processed/filtered neurophysiology
macrowires = testfile.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MacroWireSeries').data.load;
%%
ma_timestamps = testfile.processing.get('ecephys').nwbdatainterface.get('LFP').electricalseries.get('MacroWireSeries').timestamps.load;

beh_timestamps = testfile.acquisition.get('events').timestamps.load;

%% drop to 1khz
downTS = decimate(ma_timestamps,8);

%% Behavior event ID
behE = beh_timestamps(1);

%% Find index in ephys for Behavior Event 1 (behE)

[a,b] = min(abs(behE - downTS))