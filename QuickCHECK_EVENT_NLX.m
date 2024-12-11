%% CD to event folder

cd('C:\Users\Admin\Downloads\2024-11-21_14-17-07\2024-11-21_14-17-07')

%% Load event file

[~, EventIDs, TTLs, ~, EventStrings, ~] =...
           Nlx2MatEV('Events.nev', [1 1 1 1 1], 1, 1, [] );

%% translate TTL
clc
EventStrings2 = EventStrings(contains(EventStrings,'TTL'));
EventHEX = hex2dec(extractBetween(EventStrings2,'(',')'));
tabulate(EventHEX)
