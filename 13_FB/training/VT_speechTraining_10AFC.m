%wrapper for vibrotactile speech training 
%1/2/18
%PSM pmalone333@gmail.com


clear; %make sure to clear workspace 
%get subject info
number = input('\n\nEnter Subject NUMBER:\n\n','s');
name = number;
if isempty(name)
    name = 'MR000';
else
    name = ['MR' name];
end
exptdesign.subNumber = number; 
exptdesign.subName = name;
WaitSecs(0.25);
%check if the subject has a directory in data
if exist(['./data/' number],'dir')
else
    mkdir(['./data/' number])
end

if exist(['./history/' number],'dir')
else
    mkdir(['./history/' number])
end


if exist(['./history/SUBJ' number 'training.mat'], 'file')
    exptdesign.training=load(['./history/SUBJ' number 'training.mat']);
    stimType = exptdesign.training.stimType;
    fprintf(['Subject has been here before, starting at level ' num2str(exptdesign.training.level)])
    %stimType = stimType;
else
    fprintf('Subject has not been entered before, starting at level 1')
    exptdesign.training.level=1; %changed this to one cas 08/10/15
    exptdesign.training.history=[];
    stimType = input('\n\nEnter stim type (1=GU algorithm, 2=FB algorithm):\n\n');
end
pause(2)

exptdesign.numSessions = 4; %number of blocks
exptdesign.numTrialsPerSession = 60;
exptdesign.accuracyCutoff = 0.8; %accuracy required to advance level 

exptdesign.fixationImage = 'imgsscaled/fixation.bmp';  % image for the fixation cross
exptdesign.blankImage = 'imgsscaled/blank.bmp';        % image for the blank screen

piezoDriver32('open','COM5');
VT_speechTraining_10AFC_experiment(name,exptdesign,stimType);
sessDate = datestr(now, 'yyyymmdd_HHMM');
%makeTrainingFigure(number,sessDate);
piezoDriver32('close');
clear