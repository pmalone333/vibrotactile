% wrapper for VT aim 2 eeg pilot experiment 
% calls by VT_eegPilot_experiment.m 
%
% PSM 8/2016 pmalone333@gmail.com

%% EEG related settings
exptdesign.netstationPresent   = 0;            % controls whether or not netstation is present
exptdesign.netstationIP        = '10.0.0.45';  % IP address of the netstation computer
exptdesign.netstationSyncLimit = 2;            % limit under which to sync the netstation computer and the Psychtoolbox IN MILLISECONDS


%% everything else
fprintf('distance to screen must be 90 cm\n');
name     = lower(input('subject code >> ','s'));
respType = lower(input('response same Left, input 1. Response same Right, input 2 >>'));
exptdesign.responseType = respType;
exptdesign.subjectName  = name;

% session/trial structure
exptdesign.numPracticeTrials   = 0;       % number of practice trials
exptdesign.numSessions         = 6;       % number of sessions to repeat the experiment
exptdesign.numTrialsPerSession = 96;      % number of trials per session
exptdesign.refresh             = 0.016679454248257;

% trial settings
% 12 frames is approximately 200 ms (200.2 ms);
exptdesign.stimulusDuration = 12 * exptdesign.refresh;      % amount of time to display the stimulus in seconds (0.0166667 is the frame time for 60hz)
exptdesign.isiDuration      = [200 400];                    % range for ISI (ms) (interval between first and second stimulus) 
exptdesign.itiDuration      = [1000 2000];                  % range for ITI (ms) (interval between trials)
exptdesign.noRespFreq       = [1 20];                       % range of no response stimuli before response 
exptdesign.responseDuration = 2.00;                         % amount of time to allow for a response in seconds
exptdesign.fixationDuration = 0.500;                        % amount of time to display the fixation point (secs)
exptdesign.waitForResponse  = 0;                            % controls whether we wait for a correctly entered response or continue on
exptdesign.usespace         = 0;                            % use space bar to start each trial?

% images
exptdesign.fixationImage = 'imgs/fixation.bmp';   % image for the fixation cross
exptdesign.blankImage    = 'imgs/blank.bmp';      % image for the blank screen

% begin experiment 
stimGenPTB('open');
[trialoutput] = VT_eegPilot_experiment(name,exptdesign);
