%Wrapper For Categoziation Training
%June 15 2015
%CAS cas243@georgetown.edu
% dbstop if error;
%prompt experimenter to check white noise, ear plubs
input('\n\nIs white noise playing? Hit Enter when "Yes."\n');
input('\n\nDoes participant have ear plugs? Hit Enter when "Yes."\n');

%get subject info
name = input('\n\nEnter Subject NUMBER:\n\n','s');
number=name;
exptdesign.number=number;
if isempty(name)
    name = ['MR000'];
else
    name = ['MR' name];
end
WaitSecs(0.25);
%check if the subject has a directory in data.  If not, make it.
if exist(['./data/' number],'dir')
else
    mkdir(['./data/' number])
end

%check if the subject has a saved level matrix.  If not, make it with
%starting levels.
%LOAD SUBJECT'S FILE TO APPEND
if exist(['./history/SUBJ' number 'training.mat'], 'file')
    exptdesign.training=load(['./history/SUBJ' number 'training.mat']);
    fprintf(['Subject has been here before, starting at level ' num2str(exptdesign.training.lastLevelPassed)])
else
    level=10;
    fprintf('Subject has not been entered before, starting at level 1')
    exptdesign.training.lastLevelPassed=10; %changed this to one cas 08/10/15
    exptdesign.training.history=[];
end
pause(2)
%exptdesign.level=max(level);
exptdesign.level=exptdesign.training.lastLevelPassed;

exptdesign.subjectName = name;
exptdesign.netstationPresent = 0;       % Controls whether or not Netstation is present
exptdesign.netstationIP = '10.0.0.45';  % IP address of the Netstation Computer
exptdesign.netstationSyncLimit = 2;     % Limit under which to sync the Netstation Computer and the Psychtoolbox IN MILLISECONDS

exptdesign.numSessions = 6;              % number of blocks (160 trials each) to complete this training session

% if/else statement to set the number of trials for the level
if exptdesign.level == 5
    exptdesign.numTrialsPerSession = 144;    % number of trials per block for level 5
else 
    exptdesign.numTrialsPerSession = 128;  % numbeer of trials per block for levels 1,2,3 and 4
end

exptdesign.refresh = 0.016679454248257;

exptdesign.fixationImage = 'imgsscaled/fixation.bmp';  % image for the fixation cross
exptdesign.blankImage = 'imgsscaled/blank.bmp';        % image for the blank screen

exptdesign.giveFeedback=1;
exptdesign.cat1label='imgsscaled/labels1.png'; 
exptdesign.cat2label='imgsscaled/labels2.png'; 

%feedback for incorrect answers == 4 possibilities
%edit 6/22/15 -- there will be no feedback for correct answers (advance
%immediatley to next trial)
exptdesign.fb1='imgsscaled/labelsSet1_wrong1.png';
exptdesign.fb2='imgsscaled/labelsSet1_wrong2.png';
exptdesign.fb3='imgsscaled/labelsSet2_wrong1.png';
exptdesign.fb4='imgsscaled/labelsSet2_wrong2.png';

%show correct answers
exptdesign.correct1='imgsscaled/replayBlue.png';
exptdesign.correct2='imgsscaled/replayRed.png';

exptdesign.imageDirectory = 'imgsscaled/';

%open COM1 port
try
stimGenPTB('CloseAll');
catch
end
stimGenPTB('open','COM1')

vtCategorizationTrainingExperimentFarPositions(name,exptdesign);