exptdesign.debug = 0;
% get subject info
if exptdesign.debug
    number = '915';
else
    number = input('\n\nEnter Subject ID:\n\n','s');
end
exptdesign.number = number;
if isempty(number)
    name = [datestr(now,'yyyy-mm-dd-HH-MM') 'MR000'];
else
    name = [datestr(now,'yyyy-mm-dd-HH-MM') number];
end
WaitSecs(0.25);

%check if subject has data on file
exptdesign.saveDir = ['./data_Trained_Localizer/' number];
if ~exist(exptdesign.saveDir,'dir')
    mkdir(exptdesign.saveDir)
end

exptdesign.subjectName = name;

%Trial/Block/Run lengths

if exptdesign.debug 
    disp('WARNING!!! YOU ARE IN DEBUG MODE') 
    exptdesign.numBlocks = 3;         
    exptdesign.numTrialsPerSession = 6;    
    exptdesign.numRuns = 1;
else
    exptdesign.numBlocks = 28;         
    exptdesign.numTrialsPerSession = 6;    
    exptdesign.numRuns = 6;
end

% Create the random stimuli file
automateTrainedStimuli(exptdesign.numRuns);

%fixation location/duration
exptdesign.fixationDuration =0.700;
exptdesign.stimulusPresentation = 0.300;
exptdesign.fixationImage = 'imgsscaled/fixation.bmp';  
exptdesign.imageDirectory = 'imgsscaled/';   

% Decide which response mapping you are using

%     exptdesign.response = 1;
%     exptdesign.responseBox = 0;
%     exptdesign.boxHandle = 2; % we still need this variable in the debug mode. 
% else
%     exptdesign.response = input('\n\nEnter response key profile (option 0 or 1):\n\n');
%     exptdesign.responseBox = 1;             % Controls whether we are using the keyboard or the response box for subj. responses.
% end


% exptdesign.response = input('\n\nEnter response key profile (option 0 or 1):\n\n');
% Line above is commented because now we need the RP to be 0 so that the
% correct stimulus file is generated.
exptdesign.response = 0;
exptdesign.responseBox = 1; 
exptdesign.interTrialInterval = 0.7;                % amount of time between trials

%open com3 port for button boxes
if exptdesign.responseBox
    % Ensure button-box configuration is correct
    disp('Ensure dip switches are set to E-PRIME and 5+');
    input('Hit Enter to Continue...');
    exptdesign.boxHandle = CMUBox('Open', 'pst', 'COM3', 'norelease');
end

%open com2 port for stimulator
stimGenPTB('open')

%run all 6 runs right after the last 
%%%CHANGE BACK TO 1%%%%%%%%%%%
for iRuns = 1:exptdesign.numRuns
    exptdesign.iRuns=iRuns;
    if iRuns == 1
        startOrNot = 'y';
    else
        startOrNot = input('Start the next run? y or n\n');
    end
    if strcmp(startOrNot,'y')==1
        [trialOutput.run] = trainedOddballExperimentInScanner2(name,exptdesign);
    else
        fprintf(['Skipping run ' num2str(iRuns) '\n']);
    end
end

%close com3 port
if exptdesign.responseBox
    CMUBox('Close',exptdesign.boxHandle);
    handle = ERRORDLG('Please ensure dip switches are set back to 4 and A');
    disp(handle)
end

%close com2 port 
stimGenPTB('close')