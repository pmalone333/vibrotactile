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
exptdesign.saveDir = ['./data_RAscan_practice/' number];

if ~exist(exptdesign.saveDir,'dir')
    mkdir(exptdesign.saveDir)
end

exptdesign.subjectName = name;

%Trial/Block/Run lengths
exptdesign.numBlocks = 1;             
exptdesign.numTrialsPerSession = 14;
exptdesign.numRuns = 1;

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

%open com2 port for stimulator
stimGenPTB('open')

%run all 1 runs right after the last 
for iRuns = 1:exptdesign.numRuns
    exptdesign.iRuns=iRuns;
    [trialOutput.run] = RAinScannerPracticeExperiment(name,exptdesign);
end

%close com2 port 
stimGenPTB('close')