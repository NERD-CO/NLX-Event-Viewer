% 1. Check strict property existence (Fixes the "missing property" error)
disp('--- Checking Required Properties ---');
try
    % Access the properties directly. If these error, the constructor wasn't called right.
    if ~isempty(nwbA.general_extracellular_ephys_electrodes.group)
        disp('✓ Property "group" is present.');
    else
        disp('X Property "group" is EMPTY.');
    end

    if ~isempty(nwbA.general_extracellular_ephys_electrodes.location)
        disp('✓ Property "location" is present.');
    else
        disp('X Property "location" is EMPTY.');
    end
catch ME
    disp(['X Error accessing properties: ' ME.message]);
end

% 2. Check internal data storage (vectordata)
disp(' ');
disp('--- Checking VectorData Storage ---');
keys = nwbA.general_extracellular_ephys_electrodes.vectordata.keys;
disp(['Columns found: ' strjoin(keys, ', ')]);

% Verify 'group' and 'location' are inside vectordata too
if any(strcmp(keys, 'group')) && any(strcmp(keys, 'location'))
    disp('✓ "group" and "location" are correctly mapped to VectorData.');
else
    disp('X "group" or "location" missing from VectorData keys.');
end

% 3. Check "colnames" (The final piece of the puzzle)
disp(' ');
disp('--- Checking Colnames ---');
cols = nwbA.general_extracellular_ephys_electrodes.colnames;
disp(['Colnames: ' strjoin(cols, ', ')]);

if all(ismember({'group', 'location'}, cols))
    disp('✓ Colnames includes required fields.');
else
    disp('X Colnames is missing required fields.');
end