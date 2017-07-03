%
% VT aim 2 EEG pilot ctl 
% modeled off of: NSF130201ctl - CV testing with training
%
% PSM 8/2016
%
% response file line:
% session, trial, stimType, stimulusConsonant, responseConsonant, responseTime
% where stimType = 0:bell, 1:trained, 2:untrained

% enable for response bypass
debug_mode = 0;

% define audio tokens
audioFile = 'garyCA_F2B.wav';
videoFile = 'garyCA.mov';

% define frames and intervals
tokenIndices = {...
    {1,6,30},... % C cha
    {20,44},... % D dha
    {19,43},... % S sha
    {21,45},... % T tha
    {7,31},... % Z zha
    {25,49},... % ba
    {18,42},... % da
    {10,34},... % fa
    {14,38},... % ga
    {8,32},... % ha
    {13,37},... % ja
    {23,47},... % ka
    {3,27},... % la
    {4,28},... % ma
    {22,46},... % na
    {24,48},... % pa
    {2,17,41},... % ra
    {9,33},... % sa
    {15,39},... % ta
    {26,50},... % va
    {12,36},... % wa
    {16,40},... % za
    {5,11,29,35}... % a
};    
    
consonantIndexString = 'CDSTZbdfghjklmnprstvwza';

% video info
video_startFrames = [0,30,61,94,122,149,179,209,238,269,307,343,375,405,435,464,495,528,562,590,622,651,...
    686,726,748,778,811,839,873,898,926,957,987,1018,1049,1088,1116,1145,1173,1201,1230,1261,1291,...
    1321,1350,1381,1410,1440,1470,1498];
    
video_numFrames = [29,31,34,28,27,30,30,29,31,38,34,33,30,30,29,31,33,34,28,32,29,35,41,22,30,43,29,35,...
    25,29,31,30,31,31,39,28,29,30,28,29,31,31,30,29,31,29,31,30,28,34];

audioStartSamples = [14054,68274,115644,162441,210766,246500,299233,348638,394142,...
    455085,507353,573057,615078,667197,713970,756454,815848,867786,914068,964712,1011227,1064355,...
    1120166,1171191,1219267,1266795,1310521,1358222,1409641,1441881,1493703,1545633,...
    1592987,1646051,1716968,1762752,1801171,1849786,1893198,1937125,1983889,2033371,...
    2075920,2129636,2174520,2225629,2272529,2325059,2373074,2424512];

audioNumSamples = [26567,24785,20655,21233,20015,25577,23760,21071,24800,19224,17941,19685,...
    23425,20271,19537,20187,20073,18184,24264,22740,18390,21632,22165,20098,18443,21513,...
    24017,23426,19099,24710,24968,21368,25095,20900,17974,18279,23201,19685,19765,20759,...
    21827,19367,26244,23600,25681,21448,20445,18569,18317,20154];

% % these are the frame identifiers for all but the training tokens
% % for training, use the list in the training section below
% % old pa blurry, #15, at 1163071 for 31209 samples,
% audioStartSamples = [33438,102184,186378,260372,342215,432488,509835,580617,...
%     671954,747207,840303,912245,993466,1082602,1162953,1233688,1310422,...
%     1399986,1477719,1567440,1644528,1734553];
% audioNumSamples = [32535,40189,35154,41642,39670,29133,30171,42109,32247,40189,...
%     32039,36970,39566,38009,36000,38580,42005,33389,39670,34479,41798,36334];
% audioTokens = numel(audioStartSamples); % don't count bell
% bell_start_frame = 1922580;%1804008;
% bell_duration = 35990;%123144;%124178; % longer, breaks rhythm
% respTimeout = 10;
% display_cross = 0; % use fixation cross?
% 
% % video movie info, old pa frame 769 for 51 frames 
% video_startFrames = [0,51,105,159,214,268,321,375,432,486,543,600,...
%     654,713,1205,819,872,928,982,1041,1097,1154];
% video_numFrames = [51,51,51,51,51,51,51,51,51,51,51,...
%     51,51,51,59,51,51,51,51,51,51,51];
% blackFramesBetweenTokens = 0;

% token strings in video/audio
tokenStrings = {'cha','dha','dja','sha','tha','ba','da','fa','ga','ha','ka',...
    'la','ma','na','pa','ra','sa','ta','va','wa','ya','za'};
tokenChars = ['C','D','J','S','T','b','d','f','g','h','k','l','m','n','p',...
    'r','s','t','v','w','y','z']; % use to insert into response file

% define audio path, and set volume level to calibrated value
pic('Open');
eval('NSF130201cal'); % sets output on speaker
GetAudioControls;
setAudioVariables(AudioControls,'volume','volume',snd_level);

% defaults
bell_frequency = 0; % use bell every once in a while? NO
response_options = {}; % display these strings on the monitor
use_video = 0;
use_video_freeze_frame = 0;
use_audio = 0;
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
['      For this part of the experiment, you will hear a number of highly distorted consonant-vowel utterances.',...
' Occasionally, after one of these syllables, you will be asked to identify what you thought the sconsonant was.',...
' On the screen a list of the consonants will appear, and your task is to push the key corresponding to the consonant you thought was last uttered. '...
' Your response will then restart the stream of syllables. ',10,10,13,13,...
'      Every so often, you will be prompted to rest briefly.',...
' Please take anywhere from a few tens of seconds to a few minutes to relax.',...
' If you feel the need to exit the booth, please push the yellow button,',...
' and the attendant will come to disconnect you from the EEG system.',...
' The prompt will also let you know what percentage of this part of the experiment you have completed.',10,10,13,13,...
'      Please try to stay relaxed during all parts of the experiment, and if you notice',...
' tension in your head or shoulders, make an effort to relax.',...
' Also, keep your eyes open, and try not to blink excessively.',...
' If possible, train yourself to blink between the sounds.',...
' Finally, since moving your gaze also adversely impacts the EEG traces,'...
' please try to keep your gaze fixed - as much as possible - on the cross displayed on the center of the screen.',10,10,13,13,...
' Please ask the attendant if you have any questions, otherwise push the ENTER key'];

% pretest
switch(session)
    case 'pre1'
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



