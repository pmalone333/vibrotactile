
function trialOutput = RAinScannerExperimentLab(name,exptdesign)

try
    % following codes should be used when you are getting key presses using
    % fast routines like kbcheck.
    KbName('UnifyKeyNames');
    Priority(1)

    %settings so that Psychtoolbox doesn't display annoying warnings--DON'T CHANGE
    oldLevel = Screen('Preference', 'VisualDebugLevel', 1);
    %     oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', 1);
    %     warning offc
    if ~exptdesign.debug
        HideCursor;
    else
        dbstop if error;
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
        [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128], [0 0 250 250]); %for debugging
    else
        [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128]);
    end
    white = WhiteIndex(w); % pixel value for white
    black = BlackIndex(w); % pixel value for black
    stimulusPresentationTime = exptdesign.stimulusPresentationTime;

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
    if exptdesign.responseBox == 1
        %flush event queue
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
        
        %while loop that continues to iterate until trigger is pressed at
        %which point triggername == trigger
        while ~isequal(triggername,trigger)
            evt = CMUBox('GetEvent', exptdesign.boxHandle, 1);
            trigger = evt.state;
            starttime = evt.time;
        end
        
        %store start time and response mapping in exptdesign struct
        exptdesign.scanStart = starttime;
        exptdesign.responseMapping=responseMapping;
    else 
        exptdesign.exptStart = GetSecs;
        responseMapping = exptdesign.response;
    end
    
    %marks the number of runs passed in from exptdesign struct
    iRuns=exptdesign.iRuns;

    %passes in response profile from wrapper function
    response = exptdesign.response;
    trialDuration = exptdesign.trialDuration;
    numTrialsPerSession = exptdesign.numTrialsPerSession;
    responseDuration = exptdesign.responseDuration;
   
    %Display experiment instructions
    if response == 0
        drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations. \n'...
             'You will indicate whether the 2 vibrations are members of the same or different categories\n'...
             'by clicking the mouse. Click the left mouse button to indicate "same category" and the right mouse\n' ...
              'button to indicate "different category".'  ],1)
    else
      drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations. \n'...
             'You will indicate whether the 2 vibrations are members of the same or different categories\n'...
             'by clicking the mouse. Click the left mouse button to indicate "same category" and the right mouse\n' ...
              'button to indicate "different category".'  ],1)
    end
    
    %load stimuli file
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
    
    % note that the randomization of stimuli order below should only be
    % done for the practice RA session, not for the MRI. MRI has a specific
    % predetermined order (m sequence) 
    order = randperm(size(stimuli,2));
    stimuli = stimuli(:,order);
    totalTrialCounter = 1;
    for iBlock = 1:exptdesign.numBlocks %how many blocks to run this training session 
        blockStartTime = GetSecs;
        
        withinTrialCounter = 1;
        %iterate over trials
        for iTrial=1:exptdesign.numTrialsPerSession
           trialStartTime = GetSecs;
           
           if withinTrialCounter == 1
               stimLoadTime = loadStimuli(stimuli(1:8,iTrial));
           end
           
           %draw fixation/reset timing
           Screen('DrawTexture', w, fixationTexture);
           [FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed] = ...
               Screen('Flip',w, exptdesign.exptStart + 10*(iBlock) + 4*(totalTrialCounter-1));
           
           %call function that generates stimuli for driver box
           stimulusOnset = GetSecs;
           %set variables == 0 if no response
           responseFinishedTime = 0;
           responseStartTime    = 0;
           sResp                = 0;
           responseMapping      = 0;
           
           if stimuli(1:4,iTrial) ~= 0
               
               %cue stimulus presentation 
               rtn=-1;
               while rtn==-1
                   rtn=stimGenPTB('start');
               end
               stimulusFinished = GetSecs;
               stimulusDuration = stimulusFinished-stimulusOnset;
               stimDurationOffset = stimulusPresentationTime - stimulusDuration;
               WaitSecs(stimDurationOffset)
               
               %start response window
               responseStartTime=GetSecs;
               %record subject response for mouse click v button press
               mousePressed = 0;
               while (GetSecs < (responseStartTime + responseDuration)) && mousePressed == 0
                   [x,y,buttons] = GetMouse();
                   if buttons(1)
                       sResp = 1;
                       mousePressed = 1;
                   elseif buttons(3)
                       sResp = 2;
                       mousePressed = 1;
                   end
                   responseFinishedTime = GetSecs;
                   
               end
               
               RT = responseFinishedTime - responseStartTime
               waitTime = exptdesign.trialDuration - (stimulusDuration + stimLoadTime + abs(RT));
 
           else 
               stimulusFinished = GetSecs;
               waitTime = trialDuration; 
               sResp = -1;
               RT=0;
           end
           
           %code correct response
           if isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial)) && ~stimuli(1, iTrial) == 0
               correctResponse=1;
           elseif stimuli(1, iTrial) == 0
               correctResponse = -1; % null trial
           else
               correctResponse = 2;
           end
           
           %load stimulus for next trial
           if withinTrialCounter ~= 1 && withinTrialCounter ~= length(numTrialsPerSession)
               [stimLoadTime] = loadStimuli(stimuli(1:8,iTrial));
           end
           
           if sResp == correctResponse
               accuracy = 1;
           else
               accuracy = 0;
           end
           
           withinTrialCounter = withinTrialCounter + 1;
           totalTrialCounter = totalTrialCounter + 1;
           trialEndTime = GetSecs;
           
           endOfTrialWaitTime = waitTime-stimLoadTime;
           
           %record parameters for the trial and block           
           trialOutput(iBlock,1).sResp(iTrial)                 = sResp;
           trialOutput(iBlock,1).correctResponse(iTrial)       = correctResponse;
           trialOutput(iBlock,1).stimulusOnset(iTrial)         = stimulusOnset;
           trialOutput(iBlock,1).stimulusDuration(iTrial)      = stimulusFinished-stimulusOnset;
           trialOutput(iBlock,1).stimulusFinished(iTrial)      = stimulusFinished;
           trialOutput(iBlock,1).responseStartTime(iTrial)     = responseStartTime;
           trialOutput(iBlock,1).responseFinishedTime(iTrial)  = responseFinishedTime;
           trialOutput(iBlock,1).RT(iTrial)                    = responseFinishedTime-responseStartTime;
           trialOutput(iBlock,1).stimuli(:,iTrial)             = stimuli(:,iTrial);
           trialOutput(iBlock,1).FixationVBLTimestamp(iTrial)  = FixationVBLTimestamp;
           trialOutput(iBlock,1).FixationOnsetTime(iTrial)     = FixationOnsetTime;
           trialOutput(iBlock,1).FixationFlipTimestamp(iTrial) = FixationFlipTimestamp;
           trialOutput(iBlock,1).FixationMissed(iTrial)        = FixationMissed;
           trialOutput(iBlock,1).stimLoadTime(iTrial)          = stimLoadTime;
           trialOutput(iBlock,1).trialStartTime(iTrial)        = trialStartTime;
           trialOutput(iBlock,1).trialEndTime(iTrial)          = trialEndTime;
           trialOutput(iBlock,1).trialDuration(iTrial)         = trialEndTime-trialStartTime;
           trialOutput(iBlock,1).waitTime(iTrial)               = waitTime;
           
        end
        blockEndTime = GetSecs;
        trialOutput(iBlock,1).blockStartTime                   = blockStartTime;
        trialOutput(iBlock,1).blockEndTime                     = blockEndTime;
        trialOutput(iBlock,1).blockDuration                    = blockEndTime - blockStartTime;
        
    end
    
    %draw fixation cross for last 10 seconds
    Screen('DrawTexture', w, fixationTexture);
    Screen('Flip',w)
    WaitSecs(10);
    
    ShowCursor;
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		END
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %  Write the trial specific data to the output file.
    tic;
     %save the session data in the data directory
        save(['./data_RAscan/' exptdesign.number '/' exptdesign.subjectName '.run' num2str(iRuns) '.mat'], 'trialOutput', 'exptdesign');
    toc;
    
    % End of experiment, close window:
    Screen('CloseAll');
    Priority(0);
    
catch ME
    % This "catch" section executes in case of an error in the "try"
    if exptdesign.responseBox
        CMUBox('Close',exptdesign.boxHandle);
    end

    disp('Caught error and closing experiment nicely....');
    Screen('CloseAll');
    Priority(0);
    fclose('all');
    rethrow(ME);
    %Importantly, it closes the onscreen window if it's open.
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

function [loadTime] = loadStimuli(stimuli)
        f = [stimuli(1:2,:), stimuli(5:6,:)];
        p = [stimuli(3:4,:), stimuli(7:8,:)];
     
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
   
        [t,s]=buildTSM_nomap(stim);
        
        startTime = tic;
        stimGenPTB('load',s,t);
        loadTime=toc(startTime);
end