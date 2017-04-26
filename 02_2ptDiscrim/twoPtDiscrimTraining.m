% Two point discrimination experiment
% Wrapper, calls twoPtDiscrimExper.m
% Patrick Malone pmalone333@gmail.com

%prompt experimenter to check white noise, ear plugs
input('\n\nIs white noise playing? Hit Enter when "Yes."\n');
input('\n\nDoes participant have ear plugs? Hit Enter when "Yes."\n')

%get subject info
name = input('\n\nEnter Subject NUMBER:\n\n','s');
number=name;
twoPtDesign.number=number;
preOrPostTrain = input('\n\nIs this pre or post-training? Enter 1 for pre-training, 2 for post-training:\n\n','s');
twoPtDesign.preOrPostTrain = preOrPostTrain; % 1 for pre, 2 for post
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

twoPtDesign.subjectName = name;          % what does this do? copied from Clara's vtCategorizationTraining code
twoPtDesign.netstationPresent = 0;       % Controls whether or not Netstation is present
twoPtDesign.netstationIP = '10.0.0.45';  % IP address of the Netstation Computer
twoPtDesign.netstationSyncLimit = 2;     % Limit under which to sync the Netstation Computer and the Psychtoolbox IN MILLISECONDS

twoPtDesign.numSessions = 3;              % number of blocks

twoPtDesign.refresh = 0.016679454248257; 

twoPtDesign.fixationImage = 'imgsscaled/fixation.bmp';  % image for the fixation cross
twoPtDesign.blankImage = 'imgsscaled/blank.bmp';        % image for the blank screen

twoPtDesign.imageDirectory = 'imgsscaled/';

twoPtDiscrimExper(name,twoPtDesign);
