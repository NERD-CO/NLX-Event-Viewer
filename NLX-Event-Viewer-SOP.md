## Purpose / General Information
This SOP walks through the NLX-Event-Viewer apps to process raw microwire and macrowire ephys data from the NLX system. 

###### *Last update: Sept 14 2021*

### Requirements 
* The matnwb interface library needs to be downloaded to read and write Neurodata Without Borders (NWB) files that are created with the Stage 3 app (see below). 
  * The interface library can be found in the [`NLX-Event-Viewer` repository](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/NLX_IO_Code) 
  * Instructions and further information about the interface library can be found on the [NWB website](https://neurodatawithoutborders.github.io/matnwb/#setup) 
  * The Stage 3 app will download the matnwb interface library if it is not already on your machine
* Download the patient's `macroChanInfo.csv` and `microChanInfo.csv` files. These contain information about the patient's electrodes such channel numbers of the macro/microwires, and where each electrode was implanted. 
* Download the patient's `CSC.ncs` and `Events.nev` files 
   * Only download the `CSC.ncs` files up to the number of macrowire channels that the patient had. Check `macroChanInfo.csv` to determine the number of macro channels. 
* Create subfolder within Patient's folder called `Processing`, and a subfolder within `Processing` called `Events`
   * Copy `.csv` files into `Processing` subfolder
   * Copy `CSC.ncs` and `Events.nev` files into `Events` subfolder

### Apps
* [NLX_Stage_Select](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/NLX_Stage_Select): Meta-app to select app (listed below) you would like to use for stage 1, 2 or 3 of processing
* [STAGE1_NLX_EventFinder](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/STAGE1_NLX_EventFinder): Sort through event files (.nev) to find useable data; creates folder/file structure setup
* [STAGE2_NLX_SessionInspect](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/STAGE2_NLX_SessionInspect): View event file contents and split files into different experiments or epochs
   
   *Note:* This app is optional and only used if splitting an event file
* [STAGE3_NLX_Session2NWB](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/STAGE3_NLX_Session2NWB): Convert data file into [NWB format](https://www.nwb.org/nwb-neurophysiology/) 

## Stage 1
[STAGE1_NLX_EventFinder](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/STAGE1_NLX_EventFinder)
1. Click on gear icon button and select the patient's `Events` folder. 
    * Will create `NWB` and `SessionSave` folders as well as `NWB_Process_Folder_Check.m` to be used in later steps.
2. Click through the available `Events.nev` files and choosing which ones you want to analyze
    * The event list will populate as you choose to keep certain files
3. Create an event log
   * Fill in 'Start' and 'Stop' index 
       * 'Start' index = found in 'Start Index' column of table 
       * 'Stop' index = Number in 'Start Index' column + Number in 'Num events' column
   * Decide whether the event file is 'Resting' or 'Behavior' by looking at the number of TTLs and the length of time of the recording
   * Switch the 'Accept' button to 'On' to add the event log for that file
4. Click the 'Session' button to select the next event
5. When there is no more events, click 'Export' to save
   * Use patient ID when saving
6. Close program

## Stage 2
[STAGE2_NLX_SessionInspect](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/STAGE2_NLX_SessionInspect)
1. Click on gear icon button and select the patient's `NWB_Process_Folder_Check.m` file to load in ID'ed sessions from the Stage 1 app
2. Select the session you would like to split
3. Click the 'Process Session' button
4. Enter session information into 'Session Split' box
     * Number Sessions = The number of sessions you would like to split the file into
     * If splitting into 2 sessions:
       * SessionID = Enter either 'Resting' or 'Behavior'
       * StartIndex 1 = Same as StartIndex from above table in app
       * StopIndex 1 = Same as OffsetIndex 1
       * StartIndex 2 = StopIndex 1 + 1
       * StopIndex 2 = Same as #TTLs from above table in app
    ![image](https://user-images.githubusercontent.com/78009407/133321136-891a2ac5-a727-4232-bbd3-6371b42a076c.png)
5. Click 'SET" button
6. Check the file details in the 'New Session' box. If it looks good, click the 'SPLIT' button. If not, click the 'RESET' button to restart the process
7. Continue with the rest of the sessions that need to be split
8. Click 'DONE' when complete
   * You are able to unclick 'DONE' to make any changes
9. Click the 'EXPORT SESSIONS' button
10. Close program 

## Stage 3
[STAGE3_NLX_Session2NWB](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/STAGE3_NLX_Session2NWB)
1. Click on gear icon button and select the patient's `NWB_Process_Folder_Check.m` file to load in ID'ed sessions from the Stage 1 app
2. Click on 'CONFIRM Directories' button if information in the 'Directory Locations' spaces are correct
3. Click on 'START Process' button 
    * The 'Session Processing' table will populate with information such as which `CSC.ncs` files correspond to the `Events.nev` files 
5. Click on the Step 1 button: 'Import Neuro Labels'
6. Navigate to the patient's `microChanInfo.csv` file
7. Navigate to the patient's `macroChanInfo.csv` file
8. Click on the Step 2 button: 'Check for NWB'
   * This step will check to see if you have the [matnwb inferface library](https://github.com/NERD-CO/NLX-Event-Viewer/tree/main/NLX_IO_Code) on your path and will add it if not
9. Click on the Step 3 button: 'Export to NWB' to create the NWB file
10. Close program when all sessions have been exported
