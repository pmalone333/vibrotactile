
function trialOutput = RAinScannerExperiment2(name,exptdesign)

try
    KbName('UnifyKeyNames');
    Priority(1)

    %settings so that Psychtoolbox doesn't display annoying warnings--DON'T CHANGE
    oldLevel = Screen('Preference', 'VisualDebugLevel', 1);
    HideCursor;

    WaitSecs(1); % make sure it is loaded into memory;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		INITIALIZE EXPERIMENT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % open a screen and display instructions
    screens = Screen('Screens');
    screenNumber = min(screens);

    % Open window with default settings:
    [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128]);
%     [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128], [0 0 800 800]); %for debugging
    white = WhiteIndex(w); % pixel value for white
    black = BlackIndex(w); % pixel value for black
    
    % Calculate the slack allowed during a flip interval
    refresh = Screen('GetFlipInterval',w);
    slack = refresh/2;

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
        %initialize event queue
        evt=1;
        
        %%while there is no event continue to flush queue
        while ~isempty(evt)
            evt = CMUBox('GetEvent', exptdesign.boxHandle); %empty queue 
        end
        
        % Get the responses keyed in from subject
        drawAndCenterText(w,'Please press the button for same vibration.',0);
        evt = CMUBox('GetEvent', exptdesign.boxHandle, 1); % get event for button pressed
        responseMapping.same = evt.state; % stores button box in variable
        
        drawAndCenterText(w,'Please press the button for different vibration.',0);
        evt = CMUBox('GetEvent', exptdesign.boxHandle, 1); % get event for button pressed
        responseMapping.different = evt.state; % stores button box in variable
      
        % Let the scanner signal the scan to start
        drawAndCenterText(w,'Please get ready.\n\nThe experiment will begin shortly.',0);
        % WARNING: TRRIGGER CORRESPONDS TO A PRESS OF BUTTON 3!!!
        triggername=4; %4 == button press on box 3
        trigger=0; %set equal to a different value 
        
        % While loop that continues to iterate until trigger is pressed at
        while ~isequal(triggername,trigger)
            evt = CMUBox('GetEvent', exptdesign.boxHandle, 1);
            trigger = evt.state;
            starttime = evt.time;
        end
        
        % Store start time and response mapping in exptdesign struct
        exptdesign.scanStart = starttime;
        exptdesign.responseMapping=responseMapping;
    else
        % Checks for in between runs so that experminter can control run start
        responseMapping = exptdesign.responseKeyChange;
        drawAndCenterText(w,'Hit Enter to Continue...',1);
        exptdesign.scanStart = GetSecs;
    end
    
    % Marks the number of runs passed in from exptdesign struct
    iRuns=exptdesign.iRuns;

    % Passes in response profile from wrapper function
    response = exptdesign.response;
    responseDuration = exptdesign.responseDuration;
    trialDuration = exptdesign.trialDuration;
    stimulusPresentationTime = exptdesign.stimulusPresentationTime;
   
    % Display experiment instructions
    if response == 0
        drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations \n'...
                             'You will indicate whether the vibrations were different categories by pressing \n'...
                             'the button with your index finger\n'...
                             'or the same category by pushing the button with your middle finger.'  ],1)
    else
        drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations \n'...
                             'You will indicate whether the vibrations were different categories by pressing \n'...
                             'the button with your middle finger\n'...
                             'or the same category by pushing the button with your index finger.'  ],1)
    end
    
    % Load stimuli file
    load('stimuliRA.mat');

    if iRuns == 1
        stimuli = stimuliRun1;
    elseif iRuns == 2
        stimuli = stimuliRun2;
    elseif iRuns ==3
        stimuli = stimuliRun3;
    else
        stimuli = stimuliRun4;
    end
    
    
    totalTrialCounter = 1;
    for iBlock = 1:exptdesign.numBlocks % How many blocks to run this training session 
        blockStart = GetSecs;
        % Iterate over trials
        withinTrialCounter = 1;
        for iTrial = 1:exptdesign.numTrialsPerSession
            % Initialize variable 
            trialStartTime = GetSecs;
            evt=1;
            
            % Clear event responses stored in cue
            while ~isempty(evt)
                evt = CMUBox('GetEvent', exptdesign.boxHandle);
            end
            
            %pre cue first stimulus 
            if withinTrialCounter == 1
                [stimLoadTime] = loadStimuli(stimuli(:,iTrial));
            end
           
           % Draw fixation/reset timing
           Screen('DrawTexture', w, fixationTexture);
           [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = ...
               Screen('Flip',w, exptdesign.scanStart + 10*(iBlock) + exptdesign.trialDuration*(totalTrialCounter-1)); 
           
           % Call function that generates stimuli for driver box
           if stimuli(1:4,iTrial) ~= 0
               
               % Cue stimuli in driver box
               stimulusOnset = GetSecs;
               rtn=-1;
               while rtn==-1
                    rtn=stimGenPTB('start');
               end
               stimulusFinished = GetSecs;
               stimulusDuration = stimulusFinished-stimulusOnset;
               stimDurationOffset = stimulusPresentationTime - stimulusDuration;
               WaitSecs(stimDurationOffset)
               
               % Start response window
               responseStartTime=GetSecs;
               
               % Wait until response window passed or until there is an event
               while (GetSecs < (stimulusFinished + responseDuration) && isempty(evt))
                   % If button pressed record response
                   evt = CMUBox('GetEvent', exptdesign.boxHandle);
               end
               
               % set variables == 0 if no response
               responseFinishedTime = 0;
               sResp = 0;
               RT = responseDuration; %codes RT for no response (max response window)
               
               % sResp =1 is same, sResp = 2 if differnt
               if ~isempty(evt)
                   if evt.state == responseMapping.same
                       if response == 0
                           sResp = 2;
                       elseif response == 1
                           sResp = 1;
                       end
                   elseif evt.state == responseMapping.different
                       if response == 0
                           sResp = 1;
                       elseif response == 1
                           sResp = 2;
                       end
                   else
                       sResp = -1;
                   end
                   % Record end time of response
                   responseFinishedTime=evt.time;
                   RT = responseFinishedTime - responseStartTime;
               end
               
               waitTime = exptdesign.trialDuration - (stimulusDuration + abs(RT));
               
               % Code correct response
               if isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial))
                   correctResponse = 2;
               elseif ~isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial))
                   correctResponse = 1;
               end
               
           else
               stimulusOnset = GetSecs;
               waitTime = trialDuration; 
               stimulusFinished = GetSecs;
               sResp = -1;
               correctResponse = -1;
           end
           
           withinTrialCounter = withinTrialCounter + 1;
           totalTrialCounter = totalTrialCounter + 1;
           
           % Load stimuli
           if withinTrialCounter ~= 1 && withinTrialCounter ~= 128 
            [stimLoadTime] = loadStimuli(stimuli(:,iTrial+1));
           end
           
           endOfTrialWaitTime = waitTime-stimLoadTime;
           WaitSecs(endOfTrialWaitTime)           
           
           % Record parameters for the trial and block
           trialOutput(iBlock,1).sResp(iTrial)                 = sResp;
           trialOutput(iBlock,1).correctResponse(iTrial)       = correctResponse;
           trialOutput(iBlock,1).stimulusOnset(iTrial)         = stimulusOnset;
           trialOutput(iBlock,1).stimulusDuration(iTrial)      = stimulusDuration;
           trialOutput(iBlock,1).stimulusFinished(iTrial)      = stimulusFinished;
           trialOutput(iBlock,1).responseStartTime(iTrial)     = responseStartTime;
           trialOutput(iBlock,1).responseFinishedTime(iTrial)  = responseFinishedTime;
           trialOutput(iBlock,1).RT(iTrial)                    = RT;
           trialOutput(iBlock,1).stimuli(:,iTrial)             = stimuli(:,iTrial);
           trialOutput(iBlock,1).FixationVBLTimestamp(iTrial)  = FixationVBLTimestamp;
           trialOutput(iBlock,1).FixationOnsetTime(iTrial)     = FixationOnsetTime;
           trialOutput(iBlock,1).FixationFlipTimestamp(iTrial) = FixationFlipTimestamp;
           trialOutput(iBlock,1).FixationMissed(iTrial)        = FixationMissed;
           trialOutput(iBlock,1).stimLoadTime(iTrial)          = stimLoadTime;
           trialOutput(iBlock,1).waitTime(iTrial)              = waitTime;
           trialOutput(iBlock,1).stimDurationOffset(iTrial)    = stimDurationOffset;
           trialOutput(iBlock,1).blockStart                    = blockStart;
           trialOutput(iBlock,1).endOfTrialWaitTime(iTrial)    = endOfTrialWaitTime;
           
           % Get trial duration parameters on each trial
           trialEndTime = GetSecs;
           trialOutput(iBlock,1).trialStartTime(iTrial)        = trialStartTime;
           trialOutput(iBlock,1).trialEndTime(iTrial)          = trialEndTime;
           trialOutput(iBlock,1).trialDuration(iTrial)         = trialEndTime - trialStartTime;
            
        end
        blockEndTime = GetSecs;
        trialOutput(iBlock,1).blockEndTime                     = blockEndTime;
        trialOutput(iBlock,1).blockDuration                    = blockEndTime - blockStart;
    end
    
    % Draw fixation cross for last 10 seconds
    Screen('DrawTexture', w, fixationTexture);
    Screen('Flip',w)
    WaitSecs(10);
    
    ShowCursor;
  
    % Save the session data in the data directory
    save(['./data_RAscan/' exptdesign.number '/' name '_block' num2str(iBlock) '.run' num2str(iRuns) '.mat'], 'trialOutput', 'exptdesign');
    
    % End of experiment, close window:
    Screen('CloseAll');
    Priority(0);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		                   END
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    catch
    % This "catch" section executes in case of an error in the "try"
    if exptdesign.responseBox
        CMUBox('Close',exptdesign.boxHandle);
    end
    
    %Importantly, it closes the onscreen window if it's open.
    disp('Caught error and closing experiment nicely....');
    Screen('CloseAll');
    Priority(0);
    fclose('all');
    psychrethrow(psychlasterror);

end
end

function drawAndCenterText(window,message, wait, time)
    
    if nargin <4
        time =0;
    end
    
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 0);
    black = BlackIndex(window); % pixel value for black               
    Screen('Flip',window, time);
end

function [stimLoadTime] = loadStimuli(stimuli)
    f = [stimuli(1:2), stimuli(5:6)];
    p = [stimuli(3:4), stimuli(7:8)];

    stim = {...
        {'fixed',f(1),1,300},...
        {'fixchan',p(1)},...
        {'fixed',f(2),1,300},...
        {'fixchan',p(2)},...
        {'fixed',f(3),700,1000},...
        {'fixchan',p(3)},...
        {'fixed',f(4),700,1000},...
        {'fixchan',p(4)},...
        };

    startTime = tic;
    [t,s]=buildTSM_nomap(stim);

    stimGenPTB('load',s,t);
    stimLoadTime = toc(startTime);
end
