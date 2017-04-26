% FrequencyDiscrimWrapper
% Wrapper, calls frequencyDiscrimExperiment.m
% Courtney Sprouse cs1471@georgetown.edu && Patrick Malone pmalone333@gmail.com && 
% Levan Bokeria levan.bokeria@georgetown.edu

%get subject info
% number = input('\n\nEnter Subject NUMBER:\n\n','s');
% exptdesign.number = number;

number = [];
if isempty(number)
    name = 'MR000';
else
    name = ['MR' number];
end
WaitSecs(0.25);

exptdesign.subjectName = name;
exptdesign.numBlocks = 1;              % number of blocks
exptdesign.numTrialsPerSession = 4; 
exptdesign.StimPresentationWindow = .3;

exptdesign.fixationImage  = 'imgScaled/fixation.bmp';  % image for the fixation cross
exptdesign.stimBoardImages = dir('imgScaled/stimBoard*.bmp');

stimGenPTB('open')
testChannelsExperiment(exptdesign);
stimGenPTB('close')