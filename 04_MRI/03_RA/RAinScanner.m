% get subject info
number = input('\n\nEnter Subject ID:\n\n','s');
exptdesign.number = number;
if isempty(number)
    name = [datestr(now,'yyyy-mm-dd-HH-MM-') 'MR000'];
else
    name = [datestr(now,'yyyy-mm-dd-HH-MM-') number];
end
WaitSecs(0.25);

%check if subject has data on file
if ~exist(['./data_RAscan/' number],'dir')
    mkdir(['./data_RAscan/' number])
end

exptdesign.subjectName = name;

%Trial/Block/Run lengths
exptdesign.numBlocks = 1;
exptdesign.numTrialsPerSession = 127;
exptdesign.numRuns = 2;

%fixation location/duration         
exptdesign.fixationImage = 'imgsscaled/fixation.bmp';  
exptdesign.imageDirectory = 'imgsscaled/';  
exptdesign.trialDuration = 4.0; % added by LB 12/18/2015

% Decide which response mapping you are using
exptdesign.response = input('\n\nEnter response key profile (option 0 or 1):\n\n');
exptdesign.responseDuration = 2;        % amount of time to allow for a response in seconds
exptdesign.responseBox = 1;             % Controls whether we are using the keyboard or the response box for subj. responses.
exptdesign.usespace=0;                  % use space bar to start each trial?
exptdesign.stimulusLoadWindow = 1;
exptdesign.stimulusPresentationTime = 1;

%open com3 port for button boxes
if exptdesign.responseBox
    % Ensure button-box configuration is correct
    disp('Ensure dip switches are set to E-PRIME and 5+');
    input('Hit Enter to Continue...');
    exptdesign.boxHandle = CMUBox('Open', 'pst', 'COM3', 'norelease');
end

%open com2 port for stimulator
stimGenPTB('open')

%run all 1 runs right after the last 
for iRuns = 1:exptdesign.numRuns
    if iRuns == 1
        startOrNot = 'y';
    else
        startOrNot = input('Start the next run? y or n\n');
    end
    if strcmp(startOrNot,'y')==1
        [trialOutput.run] =  RAinScannerExperiment4(name,exptdesign);
    else
        fprintf(['Skipping run ' num2str(iRun) '\n']);
    end
    exptdesign.iRuns=iRuns;
end

exptdesign.raExtra = input('\n\n Press 0 to run an extra run else enter 1(option 0 or 1):\n\n');

if exptdesign.raExtra == '0'
    for iRuns = 3:3
        exptdesign.iRuns=iRuns;
        [trialOutput.run] = RAinScannerExperiment4(name,exptdesign);
    end
end

%close com3 port
if exptdesign.responseBox
    CMUBox('Close',exptdesign.boxHandle);
    handle = errordlg('Please ensure the dip switches are set back to 4 and A');
    disp(handle);
end

%close com2 port 
stimGenPTB('close')