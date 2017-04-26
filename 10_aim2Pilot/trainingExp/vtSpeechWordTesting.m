%wrapper for vibrotactile speech word testing 
%4/5/17
%PSM pmalone333@gmail.com

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

exptdesign.numSessions = 6; %number of blocks
exptdesign.numTrialsPerSession = 50; %50

exptdesign.fixationImage = 'imgsscaled/fixation.bmp';  % image for the fixation cross
exptdesign.blankImage = 'imgsscaled/blank.bmp';        % image for the blank screen

stimGenPTB('open','COM1');
vtSpeechWordTestingExperiment(name,exptdesign);
stimGenPTB('close');