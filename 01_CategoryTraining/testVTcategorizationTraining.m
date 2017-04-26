%Wrapper For Categoziation Training
%June 15 2015
%CAS cas243@georgetown.edu
%prompt experimenter to check white noise, ear plubs

%get subject info
number = '915';
name = ['MR' number];
exptdesign.subNumber = number; 
exptdesign.subName = name;
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
    level=1;
    fprintf('Subject has not been entered before, starting at level 1')
    exptdesign.training.lastLevelPassed=1; %changed this to one cas 08/10/15
    exptdesign.training.history=[];
end
pause(2)

exptdesign.level=exptdesign.training.lastLevelPassed;

exptdesign.numSessions = 2;              % number of blocks (160 trials each) to complete this training session

% if/else statement to set the number of trials for the level
exptdesign.numTrialsPerSession = 144;    % number of trials per block for level 5

exptdesign.fixationImage = 'imgsscaled/fixation.bmp';  % image for the fixation cross
exptdesign.blankImage = 'imgsscaled/blank.bmp';        % image for the blank screen
exptdesign.maxLevel = 14;

exptdesign.giveFeedback=1;
exptdesign.cat1label='imgsscaled/labelsGarkTrelp.png'; 
exptdesign.cat2label='imgsscaled/labelsTrelpGark.png'; 

%feedback for incorrect answers == 4 possibilities
%edit 6/22/15 -- there will be no feedback for correct answers (advance
%immediatley to next trial)
exptdesign.fb1='imgsscaled/labelsWordSet1_wrong1.png';
exptdesign.fb2='imgsscaled/labelsWordSet1_wrong2.png';
exptdesign.fb3='imgsscaled/labelsWordSet2_wrong1.png';
exptdesign.fb4='imgsscaled/labelsWordSet2_wrong2.png';

%show correct answers
exptdesign.correct1='imgsscaled/replayGark.png';
exptdesign.correct2='imgsscaled/replayTrelp.png';

exptdesign.imageDirectory = 'imgsscaled/';

%try
stimGenPTB('open','COM1')
vtCategorizationTrainingExperiment7(name,exptdesign);
% catch
% Screen('CloseAll')
% stimGenPTB('CloseAll');
% end