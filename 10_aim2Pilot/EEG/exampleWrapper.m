%% EEG related settings
exptdesign.netstationPresent = 1;       % Controls whether or not Netstation is present
exptdesign.netstationIP = '10.0.0.45';  % IP address of the Netstation Computer
exptdesign.netstationSyncLimit = 2;     % Limit under which to sync the Netstation Computer and the Psychtoolbox IN MILLISECONDS


%% Everything else
fprintf('distance to screen must be 90 cm\n');
name=lower(input('subject code >> ','s'))
respType = lower(input('response same Left, input 1. Response same Right, input 2 >>'))
exptdesign.responseType = respType;

exptdesign.subjectName = name;

%general settings
exptdesign.numPracticeTrials = 0;         % number of practice trials
exptdesign.numSessions = 6;               % number of sessions to repeat the experiment
exptdesign.numTrialsPerSession = 192;     % number of trials per session
exptdesign.refresh = 0.016679454248257;

%trial settings
%12 frames is approximately 200 ms (200.2 ms);
exptdesign.stimulusDuration = 12 * exptdesign.refresh; % amount of time to display the stimulus in seconds (0.0166667 is the frame time for 60hz)
exptdesign.isiDuration = 12 * exptdesign.refresh;      % amount of time after stimulus display before the second stimulus is presented
exptdesign.responseDuration = 2.00;                    % amount of time to allow for a response in seconds
exptdesign.fixationDuration =0.500;                    % amount of time to display the fixation point (secs)
exptdesign.waitForResponse = 0;                        % controls whether we wait for a correctly entered response or continue on
exptdesign.usespace=0;                                 % use space bar to start each trial?

    %defining the location of stimulus images
    exptdesign.line1files1 = 'xnew/jittered_f0t5*_0.jpg';
    exptdesign.line2files1 = 'xnew/jittered_f13t5*_0.jpg';
    exptdesign.line3files1 = 'xnew/jittered_f13t11*_0.jpg';
    exptdesign.line4files1 = 'xnew/jittered_f0t11*_0.jpg';
    exptdesign.line5files1 = 'xnew/jittered_f0t13*_0.jpg';
    exptdesign.line6files1 = 'xnew/jittered_f5t11*_0.jpg';
    
    exptdesign.line1files2 = 'xnew/jittered_f0t5*_2.jpg';
    exptdesign.line2files2 = 'xnew/jittered_f13t5*_2.jpg';
    exptdesign.line3files2 = 'xnew/jittered_f13t11*_2.jpg';
    exptdesign.line4files2 = 'xnew/jittered_f0t11*_2.jpg';
    exptdesign.line5files2 = 'xnew/jittered_f0t13*_2.jpg';
    exptdesign.line6files2 = 'xnew/jittered_f5t11*_2.jpg';
    
    exptdesign.line1files3 = 'xnew/jittered_f0t5*_4.jpg';
    exptdesign.line2files3 = 'xnew/jittered_f13t5*_4.jpg';
    exptdesign.line3files3 = 'xnew/jittered_f13t11*_4.jpg';
    exptdesign.line4files3 = 'xnew/jittered_f0t11*_4.jpg';
    exptdesign.line5files3 = 'xnew/jittered_f0t13*_4.jpg';
    exptdesign.line6files3 = 'xnew/jittered_f5t11*_4.jpg';
    
    exptdesign.line1files4 = 'xnew/jittered_f0t5*_6.jpg';
    exptdesign.line2files4 = 'xnew/jittered_f13t5*_6.jpg';
    exptdesign.line3files4 = 'xnew/jittered_f13t11*_6.jpg';
    exptdesign.line4files4 = 'xnew/jittered_f0t11*_6.jpg';
    exptdesign.line5files4 = 'xnew/jittered_f0t13*_6.jpg';
    exptdesign.line6files4 = 'xnew/jittered_f5t11*_6.jpg';
    
    exptdesign.line1files5 = 'xnew/jittered_f0t5*_8.jpg';
    exptdesign.line2files5 = 'xnew/jittered_f13t5*_8.jpg';
    exptdesign.line3files5 = 'xnew/jittered_f13t11*_8.jpg';
    exptdesign.line4files5 = 'xnew/jittered_f0t11*_8.jpg';
    exptdesign.line5files5 = 'xnew/jittered_f0t13*_8.jpg';
    exptdesign.line6files5 = 'xnew/jittered_f5t11*_8.jpg';
    
    exptdesign.line1files6 = 'xnew/jittered_f0t5*_10.jpg';
    exptdesign.line2files6 = 'xnew/jittered_f13t5*_10.jpg';
    exptdesign.line3files6 = 'xnew/jittered_f13t11*_10.jpg';
    exptdesign.line4files6 = 'xnew/jittered_f0t11*_10.jpg';
    exptdesign.line5files6 = 'xnew/jittered_f0t13*_10.jpg';
    exptdesign.line6files6 = 'xnew/jittered_f5t11*_10.jpg';


exptdesign.fixationImage = 'xnew/fixationg.jpg';  % image for the fixation cross
exptdesign.blankImage = 'xnew/blankg.jpg';        % image for the blank screen
exptdesign.imageDirectory = 'xnew/';

[trialoutput] = exampleExperimentFunction(name,exptdesign)
