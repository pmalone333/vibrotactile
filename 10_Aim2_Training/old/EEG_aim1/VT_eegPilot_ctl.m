%
% VT aim 2 EEG pilot task for use at GW - ctl file
% NSF130201ctl - CV testing with training
%
% PSM 8/2016
%
% response file line:
% session, trial, stimType, stimulusConsonant, responseConsonant, responseTime
% where stimType = 0:bell, 1:trained, 2:untrained

% enable for response bypass
debug_mode = 0;


% load stimuli 
load('vcv_stim_remap.mat');

% token strings in video/audio
% tokenStrings = {'cha','dha','dja','sha','tha','ba','da','fa','ga','ha','ka',...
%     'la','ma','na','pa','ra','sa','ta','va','wa','ya','za'};
% % tokenChars = ['C','D','J','S','T','b','d','f','g','h','k','l','m','n','p',...
% %     'r','s','t','v','w','y','z']; % use to insert into response file


% defaults
response_options = {}; % display these strings on the monitor
get_button_resp = 0;
get_KB_response = 0;
give_feedback = 0;
replay_after_feedback = 0;
post_wait = [10,30]; % wait random milliseconds in this interval after output
responsePromptString = '';
freeze_init = 10;   % freeze frames in case showing video
freeze_final = 10;
trained_tokens = 10;
getRespTime = 0;
noRespStim = 0;  % complex stim, sometimes no resp, sometimes resp
getResponsePrompt = 0;
restEndSecs = 2.0;  % wait this long after return following rest
blackFramesBetweenTokens = 15;
tokenChars = 'fhlprs';
display_cross = 0;

%
% strings 
%
%startStringButton = 'please push red button when ready to start';
startStringKeyboard = 'please push ENTER key when ready to start';
restString = 'please rest a few seconds, push ENTER to continue';
breakString = 'Break Time! Please wait for the attendant';
doneString = 'Done! Thank you. Please wait for the attendant';

stringFontSize = 14;
stringLocY = 499;  % Y dimension of string (0=top)
stringLocX = 250;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INSTRUCTIONS FOR DIFFERENT SESSIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% default for pre and posttraining parts
instructs = ...
'enter instructions here';

% pretest
switch(session)
    case 'RA'
        
        
        
        startString = startStringKeyboard;
        token_index = [10,8,3,48,2,9];
        stimIDs = [11,12,13,14,15,16];
        use_video = 0;
        use_video_freeze_frame = 0;
        use_audio = 1;    
        num_blocks = 10;    % 10 of each to get decent confusion matrix
        get_button_resp = 0; 
        get_keyboard_resp = 1;
        getRespTime = 1;
        ISI = [200, 400];  % ISI randomly selected from this range in milliseconds
        break_stim_tokens = 200; 
        sync_audio = 0; % don't sync audio to video (fast rate)
        responsePromptString = 'fhlprs ??   ';
        allowedKeys = {'f','h','l','p','r','s'};
        getResponsePrompt = responsePromptString; % prompt for no video
        
        % this session involves some number of no-response stimuli before a
        % stimuli is presented that requires a response. The following involve
        % the no-response tokens
        noRespStim = 1; % play a bunch of stimuli without response (audio only)
        token_index_noresp = [10,8,3,48,2,9];
        noRespFreq = [1, 20];   % range of no-response stimuli before response
        norespBlocks = 100;
        stimIDnoresp = [1,2,3,4,5,6];
        display_cross = 1;

    case 'pre2'
        startString = startStringKeyboard;
        token_index = [10,8,3,48,2,9];
        stimIDs = [31,32,33,34,35,36];
        use_video = 0;
        use_video_freeze_frame = 0;
        use_audio = 1;    
        num_blocks = 10;    % 10 of each to get decent confusion matrix
        get_button_resp = 0; 
        get_keyboard_resp = 1;
        getRespTime = 1;
        ISI = [200, 400];  % ISI randomly selected from this range in milliseconds
        break_stim_tokens = 200; 
        sync_audio = 0; % don't sync audio to video (fast rate)
        responsePromptString = 'fhlprs ??   ';
        allowedKeys = {'f','h','l','p','r','s'};
        getResponsePrompt = responsePromptString; % prompt for no video

        % this session involves some number of no-response stimuli before a
        % stimuli is presented that requires a response. The following involve
        % the no-response tokens
        noRespStim = 1; % play a bunch of stimuli without response (audio only)
        token_index_noresp = [10,8,3,48,2,9];
        noRespFreq = [1, 20];   % range of no-response stimuli before response
        norespBlocks = 100;
        stimIDnoresp = [21,22,23,24,25,26];
        display_cross = 1;   
    
    % post-training forced-choice on CVs... using all CVs
    case 'post'
        startString = startStringKeyboard;
        token_index = [10,8,3,48,2,9];
        stimIDs = [71,72,73,74,75,76];
        use_video = 0;
        use_video_freeze_frame = 0;
        use_audio = 1;    
        num_blocks = 16;    % 16 of each to get decent confusion matrix
        get_button_resp = 0; 
        get_keyboard_resp = 1;
        getRespTime = 1;
        ISI = [200, 400];  % ISI randomly selected from this range in milliseconds
        break_stim_tokens = 200; 
        sync_audio = 0; % don't sync audio to video (fast rate)
        responsePromptString = 'fhlprs ??   ';
        allowedKeys = {'f','h','l','p','r','s'};
        getResponsePrompt = responsePromptString; % prompt for no video

        % this session involves some number of no-response stimuli before a
        % stimuli is presented that requires a response. The following involve
        % the no-response tokens
        noRespStim = 1; % play a bunch of stimuli without response (audio only)
        token_index_noresp = [10,8,3,48,2,9];
        noRespFreq = [1, 20];   % range of no-response stimuli before response
        norespBlocks = 160;
        stimIDnoresp = [61,62,63,64,65,66];
        display_cross = 1;
    
        
        
    % training session - audio only
    case 'trainAO'
        startString = startStringKeyboard;
        token_index = [10,8,3,48,2,9];
        stimIDs = [101,102,103,104,105,106];
        stimIDsRepeat = [111,112,113,114,115,116];
        num_blocks = 15;
    %    nrnum_blocks = 100;
        break_stim_tokens = 25;
        use_audio = 1;
        get_keyboard_resp = 1;
        use_video_freeze_frame = 1;
        give_feedback = 1;
        replay_after_feedback = 1;
        vidStartFrame = [];
        vidNumFrames = [];
        blackFramesBetweenTokens = 15;
        ISI = [100,200]; % wait random milliseconds in this interval before output
        post_wait = [150, 300];
        getRespTime = 1;
        responsePromptString = 'fhlprs ??   ';
        FBcorrect = 'Correct!        ';
        FBincorrect = 'Sorry!          ';
        allowedKeys = {'f','h','l','p','r','s'};
        sync_audio = 1; % sync audio to video (slower rate)
        startString = startStringKeyboard;
        
instructs = ...
['      For this part of the experiment, you will learn to identify the consonants',...
' you heard in the first part.',...
' These sounds are distorted speech syllables consisting of a consonant followed by the /a/ vowel.',...
' You will see a still image of the talker''s face as each syllable is presented.',...
'      Each presentation will follow the same sequence:',13,10,...
'      1) A randomly-selected syllable will be played, while the list of possible consonants is displayed.',13,10,...
'      2) You will press the key (on the keyboard) for the consonant that you heard.',13,10,...
'      3) Green or red text will appear to let you know whether you were correct, and what the consonant was.',13,10,...
'      4) The same syllable will be repeated. Please do not push the key again at this point.',13,10,...
'      5) the screen will be black briefly while the computer prepares for the next presentation.',10,10,13,13,...
' In the final part of the experiment, you will again be asked to identify the consonants when they',...
' are presented without the talker''s face image, so please focus on the audio part of the presentation,',...
' and try to learn to distinguish each of the consonants. Some of them are easier, others more challenging.',10,10,13,13,...
'      Every so often, you will be prompted to rest briefly.',...
' Please take anywhere from a few tens of seconds to a few minutes to relax.',...
' If you feel the need to exit the booth, please push the yellow button,',...
' and the attendant will come and disconnect you from the EEG recording system.',...
' The prompt will also let you know what percentage of this part of the experiment you have completed.',10,10,13,13,...
'      Please try to stay relaxed during all parts of the experiment, and if you notice',...
' tension in your head or shoulders, make an effort to relax.',...
' Also, keep your eyes open, and try not to blink excessively.',...
' If possible, train yourself to blink between the sounds.',...
' Finally, since moving your gaze also adversely impacts the EEG traces,',...
' please try to keep your gaze fixed as much as possible, perhaps on the talker''s mouth or nose.',10,10,13,13,...
' Please ask the attendant if you have any questions, otherwise push the ENTER key'];
        
    % training session, AV
    case 'trainAV'
        startString = startStringKeyboard;
        token_index = [10,8,3,48,2,9];
        stimIDs = [201,202,203,204,205,206];
        stimIDsRepeat = [211,212,213,214,215,216];
        num_blocks = 15;
        nrISI = [20, 60]; % in ms
        break_stim_tokens = 25;
        use_audio = 1;
        use_video = 1;
        get_keyboard_resp = 1;
        use_video_freeze_frame = 0;   
        blackFramesBetweenTokens = 15;
        give_feedback = 1;
        replay_after_feedback = 1;
        ISI = [100, 200]; % between different tokens
        getRespTime = 1;
        responsePromptString = 'fhlprs ??   ';
        FBcorrect = 'Correct!        ';
        FBincorrect = 'Sorry!          ';
        allowedKeys = {'f','h','l','p','r','s'};
        sync_audio = 1; % sync audio to video (slower rate)
        startString = startStringKeyboard;
instructs = ...
['      For this part of the experiment, you will try to learn to identify the speech sounds',...
' you heard in the first part.',...
' You will see a video of the talker''s face as each syllable is presented.',...
'      Each presentation will follow the same sequence:',10,13,...
'      1) A randomly-selected syllable will be played, while the list of possible consonants is displayed.',10,13,...
'      2) You will press the key (on the keyboard) for the consonant that you heard.',10,13,...
'      3) Green or red text will appear to let you know whether you were correct, and what the consonant was.',10,13,...
'      4) The same syllable will be repeated. Please do not push the key again at this point.',10,13,...
'      5) the screen will be black briefly while the computer prepares for the next presentation.',10,10,13,13,...
' In the final part of the experiment, you will be asked to identify the consonants when they',...
' are presented without the talker''s face, so please focus on the audio part of the presentation,',...
' and try to learn to distinguish each of the consonants. Some of them are easier, others more challenging.',10,10,13,13,...
'      Every so often, you will be prompted to rest briefly.',...
' Please take anywhere from a few tens of seconds to a few minutes to relax.',...
' If you feel the need to exit the booth, please push the yellow button,',...
' and the attendant will come and disconnect you from the EEG recording system.',...
' The prompt will also let you know what percentage of this part of the experiment you have completed.',10,10,13,13,...
'      Please try to stay relaxed during all parts of the experiment, and if you notice',...
' tension in your head or shoulders, make an effort to relax.',...
' Also, keep your eyes open, and try not to blink excessively.',...
' If possible, train yourself to blink between the sounds.',...
' Finally, since moving your gaze also adversely impacts the EEG traces,',...
' please try to keep your gaze fixed as much as possible, perhaps on the talker''s mouth or nose.',10,10,13,13,...
' Please ask the attendant if you have any questions, otherwise push the ENTER key'];
    
    otherwise
       fprintf('session type not implemented!\n'); 
       rtn = 'err: session ID wrong';
       return;
end



