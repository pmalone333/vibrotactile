
function trialOutput = trainedOddballExperimentInScanner(name,exptdesign)
% dbstop if error;
try
%     dbstop if error;
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
            evt = CMUBox('GetEvent', exptdesign.boxHandle, 1);
            trigger = evt.state;
            starttime = evt.time;
        end
        
        %store start time and response mapping in exptdesign struct
        exptdesign.scanStart = starttime;
        exptdesign.responseMapping=responseMapping;
    else
        %checks for in between runs so that experminter can control run
        %start
        responseMapping = exptdesign.responseKeyChange;
        drawAndCenterText(w,'Hit Enter to Continue...',1);
        exptdesign.scanStart = GetSecs;
    end
    
    %marks the number of runs passed in from exptdesign struct
    runCounter=exptdesign.iRuns;


    %Display experiment instructions
    drawAndCenterText(w,['\nOn each trial, you will feel 6 vibrations \n'...
             'You will indicate the vibration that felt different from the other 5 vibrations\n'...
             'by pushing the button.'  ],1)
   
   %passes in response profile from wrapper function
   response = exptdesign.response;

    %load training stimuli
    load(['stimuliAllRunsRP' int2str(response) '.mat']);
    stimuli = stimuliAllRuns{runCounter};
    
    trialCounter = 1;
    for iBlock=1:numBlocks %how many blocks to run this training session
        blockStart = GetSecs;
        for i = 1:size(stimuli,2)
            stimuliBlock{i} = stimuli{iBlock,i};
        end
        
        %iterate over trials
        for iTrial=1:numTrialsPerSession
            %initialize variable 
            evt=1;
            
            %clear event responses stored in cue
            while ~isempty(evt)
                evt = CMUBox('GetEvent', exptdesign.boxHandle);
            end
           
           %draw fixation
           Screen('DrawTexture', w, fixationTexture);
           [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = Screen('Flip',w, exptdesign.scanStart + 10*(iBlock) + 1*(trialCounter-1)); 
           
           %call function that generates stimuli for driver box
           if trialCounter == 1
               stimLoadTime = loadStimuli(stimuliBlock, iTrial);
           end
           
           stimulusOnset = GetSecs;
           rtn=-1;
           while rtn==-1
               rtn = stimGenPTB('start');
           end
           stimulusFinished = GetSecs;
           
           responseStartTime=GetSecs;
           while GetSecs < (stimulusFinished + exptdesign.responseDuration) && isempty(evt)
                %if button pressed record response
                evt = CMUBox('GetEvent', exptdesign.boxHandle);
           end
           
           %set variables == 0 if no response
           responseFinishedTime = 0;
           sResp=0;
           
           %inter trial time unless there is a response
           waitTime = exptdesign.responseDuration;
           
           %sResp ==1 if button pressed
           if ~isempty(evt)
               sResp = 1;
               %record end time of response
               responseFinishedTime=evt.time;
               waitTime = exptdesign.responseDuration-responseFinishedTime;
           end
           
           WaitSecs(waitTime - stimLoadTime);
           
           % Load stimuli
           [stimLoadTime] = loadStimuli(stimuli(:,iTrial+1));
           
           if length(stimuliBlock{1,iTrial}(1,:)) > 1
                correctResponse = 1;
           else
                correctResponse = 0;
           end
           
           %record parameters for the trial and block           
           trialOutput(iBlock,1).metaData{runCounter}          = metaData;
           trialOutput(iBlock,1).sResp(iTrial)                 = sResp;
           trialOutput(iBlock,1).correctResponse(iTrial)       = correctResponse;
           trialOutput(iBlock,1).stimulusOnset(iTrial)         = stimulusOnset;
           trialOutput(iBlock,1).stimulusDuration(iTrial)      = stimulusFinished-stimulusOnset;
           trialOutput(iBlock,1).stimulusFinished(iTrial)      = stimulusFinished;
           trialOutput(iBlock,1).stimulusLoadTime(iTrial)      = stimLoadTime;
           trialOutput(iBlock,1).responseStartTime(iTrial)     = responseStartTime;
           trialOutput(iBlock,1).responseFinishedTime(iTrial)  = responseFinishedTime;
           trialOutput(iBlock,1).RT(iTrial)                    = responseFinishedTime-responseStartTime;
           trialOutput(iBlock,1).stimuli                       = stimuliBlock;
           trialOutput(iBlock,1).FixationVBLTimestamp(iTrial)  = FixationVBLTimestamp;
           trialOutput(iBlock,1).FixationOnsetTime(iTrial)     = FixationOnsetTime;
           trialOutput(iBlock,1).FixationFlipTimestamp(iTrial) = FixationFlipTimestamp;
           trialOutput(iBlock,1).FixationMissed(iTrial)        = FixationMissed;
           trialOutput(iBlock,1).blockStart                    = blockStart;
           
           trialCounter = trialCounter + 1;
        end
    end
    
    Screen('DrawTexture', w, fixationTexture);
    Screen('Flip',w)
    WaitSecs(10);
     
    ShowCursor;
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		END
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %save the session data in the data directory
    save([exptdesign.saveDir '/' name '_block' num2str(iBlock) '.run' num2str(exptdesign.iRuns) '.mat'], 'trialOutput', 'exptdesign');
    
    % End of experiment, close window:
    Screen('CloseAll');
    Priority(0);
    % At the end of your code, it is a good idea to restore the old level.
    %     Screen('Preference','SuppressAllWarnings',oldEnableFlag);
    
    catch
    % This "catch" section executes in case of an error in the "try"
    % section []
    if exptdesign.responseBox
        CMUBox('Close',exptdesign.boxHandle);
    end
        
%     switch error.identifier
%         case 'Error:Mismatch'
%             warning('Mismatch between oddball. Would you like to continue?');
%     end
    
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

     if size(stimuliBlock{iTrial},2) > 1
        loadTime = constructOddStimuli(stimuliBlock, iTrial);
     else
         
        f = stimuliBlock{1,iTrial}(1:2,:);
        p = stimuliBlock{1,iTrial}(3:4,:);

        stim = {...
            {'fixed',f(1),1,300},...
            {'fixchan',p(1)},...
            {'fixed',f(2),1,300},...
            {'fixchan',p(2)},...
            };
        
        [t,s]=buildTSM_nomap(stim);
        startTime = tic;
        stimGenPTB('load',s,t);
        loadTime = toc(startTime);
        
    end
end

function [loadTime] = constructOddStimuli(stimuliBlock, iTrial)
    f = stimuliBlock{1,iTrial}(1,:);
    p = stimuliBlock{1,iTrial}(2,:);
    
    stim = {...
            {'fixed',f(1),1,90},...
            {'fixchan',p(1),1, 90},...
            {'fixed',f(1),100,190},...
            {'fixchan',p(2), 100,190},...
            {'fixed',f(1),200,290},...
            {'fixchan',p(3), 200,290},...
           };

    [t,s]=buildTSM_nomap(stim);    
       
    startTime = tic;
    stimGenPTB('load',s,t);
    loadTime = toc(startTime);
    
end