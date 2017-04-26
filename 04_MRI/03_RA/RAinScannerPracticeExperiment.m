
function trialOutput = RAinScannerPracticeExperiment(name,exptdesign)

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

    % Passes in response profile from wrapper function
    response = exptdesign.response;
    responseDuration = exptdesign.responseDuration;
    trialDuration = exptdesign.trialDuration;
    stimulusPresentationTime = exptdesign.stimulusPresentationTime;
    
    % Display experiment instructions
    if response == '0'
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
    stimuli = load('stimuliRApractice1.mat');
    exptdesign.start = GetSecs;
    
    totalTrialCounter = 1;
    for iBlock = 1:exptdesign.numBlocks % How many blocks to run this training session 
        
        % Iterate over trials
        withinTrialCounter = 1;
        for iTrial = 1:exptdesign.numTrialsPerSession
            
            %pre cue first stimulus
            if withinTrialCounter == 1
                [stimLoadTime] = loadStimuli(stimuli(:,iTrial));
            end
            
            % Draw fixation/reset timing
            Screen('DrawTexture', w, fixationTexture);
            [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = ...
                Screen('Flip',w, exptdesign.start + 10*(iBlock) + trialDuration*(totalTrialCounter-1));
            
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
            
            %start response window
            responseStartTime=GetSecs;
            %record subject response for mouse click v button press
            [sResp,responseFinishedTime]...
                = getResponse(stimulusFinished, responseMapping, responseDuration);
            
            RT = responseFinishedTime - responseStartTime;
            
            %load stimulus for next trial
            if withinTrialCounter ~= 1 && withinTrialCounter ~= length(numTrialsPerSession)
                [stimLoadTime] = loadStimuli(stimuli(1:8,iTrial));
            end
            
            waitTime = exptdesign.trialDuration - (stimulusDuration + abs(RT));
            
            % Code correct response
            if isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial))
                correctResponse = 2;
            elseif ~isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial))
                correctResponse = 1;
            end
            
           
           withinTrialCounter = withinTrialCounter + 1;
           totalTrialCounter = totalTrialCounter + 1;
           
           % Load stimuli
           if withinTrialCounter ~= 1 && withinTrialCounter ~= 15 
            [stimLoadTime] = loadStimuli(stimuli(:,iTrial+1));
           end
           
           endOfTrialWaitTime = waitTime-stimLoadTime;    
           
           % Record parameters for the trial and block
           trialOutput(iBlock,1).sResp(iTrial)                 = sResp;
           trialOutput(iBlock,1).correctResponse(iTrial)       = correctResponse;
           trialOutput(iBlock,1).stimulusOnset(iTrial)         = stimulusOnset;
           trialOutput(iBlock,1).stimulusDuration(iTrial)      = stimulusDuration;
           trialOutput(iBlock,1).stimulusFinished(iTrial)      = stimulusFinished;
           trialOutput(iBlock,1).responseStartTime(iTrial)     = responseStartTime;
           trialOutput(iBlock,1).responseFinishedTime(iTrial)  = responseFinishedTime;
           trialOutput(iBlock,1).RT(iTrial)                    = responseFinishedTime - responseStartTime;
           trialOutput(iBlock,1).stimuli(:,iTrial)             = stimuli(:,iTrial);
           trialOutput(iBlock,1).FixationVBLTimestamp(iTrial)  = FixationVBLTimestamp;
           trialOutput(iBlock,1).FixationOnsetTime(iTrial)     = FixationOnsetTime;
           trialOutput(iBlock,1).FixationFlipTimestamp(iTrial) = FixationFlipTimestamp;
           trialOutput(iBlock,1).FixationMissed(iTrial)        = FixationMissed;
           trialOutput(iBlock,1).stimLoadTime(iTrial)          = stimLoadTime;
           trialOutput(iBlock,1).waitTime(iTrial)              = waitTime;
           trialOutput(iBlock,1).stimDurationOffset(iTrial)    = stimDurationOffset;
           trialOutput(iBlock,1).endOfTrialWaitTime(iTrial)    = endOfTrialWaitTime;
           
        end
    end
    
    % Draw fixation cross for last 10 seconds
    Screen('DrawTexture', w, fixationTexture);
    Screen('Flip',w)
    WaitSecs(10);
    
    ShowCursor;
  
    % Save the session data in the data directory
    save([exptdesign.saveDir '/' name '_block' num2str(iBlock) '.run' num2str(iRuns) '.mat'], 'trialOutput', 'exptdesign');
    
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

function drawAndCenterText(window,message, time)
    
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 0);             
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

function [sResp,responseFinishedTime]...
= getResponse(stimFinished, responseDuration)
% wait until response window passed or until there is an event
startWaiting = GetSecs;
mousePressed =0;
while (startWaiting < (stimFinished + responseDuration)...
        && mousePressed==0)
    %check to see if a button is pressed
    [x,y,buttons] = GetMouse();
    if (~buttons(1) && ~buttons(3))
        continue;
    else
        if buttons(1)
            if response == '0'
                sResp = 2;
            else
                sResp = 1;
            end
        elseif buttons(3)
            if response == '0'
                sResp = 1;
            else
                sResp = 2;
            end
        end
        responseFinishedTime = GetSecs;
        mousePressed = 1;
    end
end
     
end
