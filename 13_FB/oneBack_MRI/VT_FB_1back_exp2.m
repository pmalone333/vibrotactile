
function trialOutput = VT_FB_1back_exp2(name,exptdesign)
%dbstop if error;
try
    rand('twister',sum(100*clock))
%     dbstop if error;
    KbName('UnifyKeyNames');
    Priority(1)

    %settings so that Psychtoolbox doesn't display annoying warnings--DON'T CHANGE
    oldLevel = Screen('Preference', 'VisualDebugLevel', 1);
    if ~exptdesign.debug
        HideCursor;
    end

    WaitSecs(1); % make sure it is loaded into memory;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		INITIALIZE EXPERIMENT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % open a screen and display instructions
    screens = Screen('Screens');
    screenNumber = min(screens);

    % Open window with default settings:
    if exptdesign.debug
        [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128], [0 0 800 800]); %for debugging
    else
        [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128]);
    end

    % Select specific text font, style and size, unless we're on Linux
    % where this combo is not available:
    if IsLinux==0
        Screen('TextFont',w, 'Courier New');
        Screen('TextSize',w, 14);
        Screen('TextStyle', w, 1+2);
    end;
    
    % Load fixation image from file
    fixationImage = imread(exptdesign.fixationImage);

    % generate fixation texture from image
    fixationTexture = Screen('MakeTexture', w, double(fixationImage));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		INTRO EXPERIMENT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if exptdesign.responseBox
        %flush event queue
        evt=1;
        
        %%while there is no event continue to flush queue
        while ~isempty(evt)
            evt = CMUBox('GetEvent', exptdesign.boxHandle); %empty queue 
        end
        
        % Get the responses keyed in from subject
        drawAndCenterText(w,'Please press the button.',0);
        evt = CMUBox('GetEvent', exptdesign.boxHandle, 1); % get event for button pressed
        responseMapping.button1 = evt.state; % stores button box in variable
      
        % Let the scanner signal the scan to start
        drawAndCenterText(w,'Please get ready.\n\nThe experiment will begin shortly.',0);
        % WARNING: TRRIGGER CORRESPONDS TO A PRESS OF BUTTON 3!!!
        triggername=4; %4 == button press on box 3
        trigger=0; %set equal to a different value 
        
        %while loop that continues to iterate until trigger is pressed at
        %which point triggername == trigger
        while ~isequal(triggername,trigger)
            evt       = CMUBox('GetEvent', exptdesign.boxHandle, 1);
            trigger   = evt.state;
            starttime = evt.time;
        end
        
        %store start time and response mapping in exptdesign struct
        exptdesign.scanStart       = starttime;
        exptdesign.responseMapping = responseMapping;
    else
        %checks for in between runs so that experminter can control run
        %start
        %responseMapping = exptdesign.responseKeyChange;
        drawAndCenterText(w,'Hit Enter to Continue...',1);
        exptdesign.scanStart = GetSecs;
    end
    
    %marks the number of runs passed in from exptdesign struct
    runCounter           = exptdesign.iRuns;
    numTrialsPerSession  = exptdesign.numTrialsPerSession;
    stimulusPresentation = exptdesign.stimulusPresentation;

    %Display experiment instructions
    drawAndCenterText(w,['\nInstructions: press the button whenever you feel the same vibration twice in a row \n'],1)
   
    %passes in response profile from wrapper function
    response = exptdesign.response;

    %make and load training stimuli
    stimType = exptdesign.stimType;
    makeVTspeechStim_1back(stimType);
    load('VTspeechStim_1back.mat');
    stimuli = stim2(:,runCounter);
    label = labels2(:,runCounter);

    
    %clear event responses stored in queue
    while ~isempty(evt)
        evt = CMUBox('GetEvent', exptdesign.boxHandle);
    end
    
    %% iterate over trials
    for iTrial = 1:numTrialsPerSession
        
        %clear event responses stored in queue
        while ~isempty(evt)
            evt = CMUBox('GetEvent', exptdesign.boxHandle);
        end
        
        if strcmp(stimuli{iTrial},'null')
            continue
        else
            stimLoadTime = loadStimuli(stimuli, iTrial);
        end
        
        %draw fixation
        Screen('DrawTexture', w, fixationTexture);
        [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = Screen('Flip',w, exptdesign.scanStart + 10 + (exptdesign.interTrialInterval*(iTrial-1)));
        
        stimulusOnset = GetSecs;
        rtn=-1; % why do we still have this?...
        while rtn==-1
            rtn = piezoDriver32('start');
        end
        stimulusFinished = GetSecs;
        stimulusDuration = stimulusFinished     - stimulusOnset;
        stimulusOffset   = stimulusPresentation - stimulusDuration;
        WaitSecs(stimulusOffset)
        
        responseStartTime = GetSecs;
        

        %waitTime = exptdesign.interTrialInterval - stimLoadTime;
        %WaitSecs(waitTime);
        
        correctResponse = 0;
        if iTrial ~= 1
            if strcmp(label{iTrial-1},label{iTrial})
                correctResponse = 1;
            end
        end
        %set variables == 0 if no response
        responseFinishedTime = 0;
        sResp=0;
        
        %collect event queue
        eventCount=0;
        respCount = 0; % for tallying sResp for display at end of run
        evt = CMUBox('GetEvent', exptdesign.boxHandle);
        
        while ~isempty(evt)
            eventCount = eventCount + 1;
            %sResp ==1 if button pressed
            sResp(eventCount) = 1;
            respCount = 1; 
            %record end time of response
            responseFinishedTime(eventCount)=evt.time;
            %responseFinishedTime=evt.time;
            
            %load next event in the queue
            evt = CMUBox('GetEvent', exptdesign.boxHandle);
        end
        
        if sResp == correctResponse
            accuracy = 1;
        else
            accuracy = 0;
        end
        
        
        %record parameters for the trial and block
        trialOutput.correctResponse(iTrial)       = correctResponse;
        trialOutput.stimulusLoadTime(iTrial)      = stimLoadTime;
        trialOutput.stimulusOnset(iTrial)         = stimulusOnset;
        trialOutput.stimulusDuration(iTrial)      = stimulusFinished-stimulusOnset;
        trialOutput.stimulusFinished(iTrial)      = stimulusFinished;
        trialOutput.responseStartTime(iTrial)     = responseStartTime;
        trialOutput.responseFinishedTime{iTrial}  = responseFinishedTime;
        trialOutput.FixationVBLTimestamp(iTrial)  = FixationVBLTimestamp;
        trialOutput.FixationOnsetTime(iTrial)     = FixationOnsetTime;
        trialOutput.FixationFlipTimestamp(iTrial) = FixationFlipTimestamp;
        trialOutput.FixationMissed(iTrial)        = FixationMissed;
        trialOutput.sResp{iTrial}                 = sResp;
        trialOutput.accuracy(iTrial)              = accuracy;
        trialOutput.respCount(iTrial)             = respCount;
        trialOutput.stimuli(iTrial)               = stimuli(iTrial);
        trialOutput.label(iTrial)                 = label(iTrial);
        
    
    end % end of trial loop
    
    if iTrial == numTrialsPerSession
        WaitSecs(2);
    end
    
    
         
    
    sum2 = 0;
    sum_sResp = 0;
    for i = 1:length(trialOutput.sResp)
        sum2 = sum2 + trialOutput.accuracy(i);
        sum_sResp = sum_sResp + trialOutput.respCount(i);
    end
    Screen('DrawTexture', w, fixationTexture);
    Screen('Flip',w)
    WaitSecs(10);
     
    ShowCursor;
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		END
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %save the session data in the data directory
    save([exptdesign.saveDir '/' name '.run' num2str(exptdesign.iRuns) '.mat'], 'trialOutput', 'exptdesign');
    
    % End of experiment, close window:
    Screen('CloseAll');
    Priority(0);
        Screen('CloseAll');
    Priority(0);
   handle = errordlg(['Subject Responses: ' num2str(sum_sResp)]);
   disp(handle)
    % At the end of your code, it is a good idea to restore the old level.
    %     Screen('Preference','SuppressAllWarnings',oldEnableFlag);
    
    catch
    % This "catch" section executes in case of an error in the "try"
    % section []
    if exptdesign.responseBox
        CMUBox('Close',exptdesign.boxHandle);
    end
    
    % above.  Importantly, it closes the onscreen window if it's open.
    disp('Caught error and closing experiment nicely....');
    Screen('CloseAll');
    Priority(0);
    fclose('all');
    psychrethrow(psychlasterror);

end
end

function drawAndCenterText(window,message,wait, time)
    if nargin < 3
        wait = 1;
    end
    
    if nargin <4
        time =0;
    end
    
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 0);
    black = BlackIndex(window); % pixel value for black               
    Screen('Flip',window, time);
%     if wait, KbWait(); end
end

function [loadTime] = loadStimuli(stimuliBlock, iTrial)
    
t = stimuliBlock{iTrial}{1};
s = stimuliBlock{iTrial}{2};

startTime = tic;
piezoDriver32('load',t,s);
loadTime = toc(startTime);

end