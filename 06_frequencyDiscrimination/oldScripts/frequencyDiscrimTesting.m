% FrequencyDiscrimWrapper
% Wrapper, calls frequencyDiscrimExperiment.m
% Courtney Sprouse cs1471@georgetown.edu && Patrick Malone pmalone333@gmail.com 
% && Levan Bokeria levan.bokeria@georgetown.edu

%prompt experimenter to check white noise, ear plugs
input('\n\nIs white noise playing? Hit Enter when "Yes."\n');
input('\n\nDoes participant have ear plugs? Hit Enter when "Yes."\n')

%get subject info
number = input('\n\nEnter Subject NUMBER:\n\n','s');
exptdesign.number = number;

preOrPostTrain = input('\n\nIs this pre or post-training? Enter 1 for pre-training, 2 for post-training:\n\n','s');
exptdesign.preOrPostTrain = preOrPostTrain; % 1 for pre, 2 for post

exptdesign.responseTime = 1.5;
exptdesign.interStimulusInterval = .4;

if isempty(number)
    name = 'MR000';
else
    name = ['MR' number];
end
WaitSecs(0.25);

exptdesign.subjectName = name;

%check if the subject has a directory in data.  If not, make it.
if exist(['./data/' number],'dir')
else
    mkdir(['./data/' number])
end

exptdesign.numBlocks = 7;              % number of blocks
exptdesign.numTrialsPerSession = 160;
exptdesign.numPracticeTrials = 20;


exptdesign.fixationImage = 'imgsscaled/fixation.bmp';  % image for the fixation cross
exptdesign.imageDirectory = 'imgsscaled/';

% open COM port1
try
stimGenPTB('close');
catch
end
stimGenPTB('open','COM1')

frequencyDiscrimExperiment(exptdesign);
stimGenPTB('close')