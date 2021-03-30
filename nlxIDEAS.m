% The Header includes useful information such as type of file, version of Cheetah and type of system used, 
% sampling frequency, input range, filter settings, and ADBitVolts value. The ADBitVolts value is important 
% when importing data into another analysis tool such as MATLAB®. The value indicated is the multiplier used 
% in conjunction with the A/D value stored in each record from each sample. For example:

[Timestamps, ChannelNumbers, SampleFrequencies, NumberOfValidSamples,...
    Samples, Header] = Nlx2MatCSC('CSC257_0002.ncs', [1 1 1 1 1], 1, 1, [] );

adLine = Header(contains(Header, 'ADBit'));
adItems = strsplit(adLine{1},' ');
adBitVal = str2double(adItems{2});

adbitsVal = adBitVal;
sampleVal = Samples(1);

%%
% (Index 4: Sample4 value= 579) x (ADBitVolt value= 0.000000030518510385491027) =...
%           0.000017670217513199304633 Volts or 17.67 µV

actVolts = sampleVal * adbitsVal; % in Volts
microVolts = actVolts * 1000000;