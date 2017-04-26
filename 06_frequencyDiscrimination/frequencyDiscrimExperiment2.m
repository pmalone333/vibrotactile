function frequencyDiscrimExperiment2(exptdesign)

    % frequencyDiscrimination
    % Patrick Malone pmalone333@gmail.com, Courtney Sprouse
    % cs1471@georgetown.edu, Levan Bokeria levan.bokeria@georgetown.edu
    rand('twister',sum(100*clock))
    % Open a screen and display instructions
    screens=Screen('Screens');
    screenNumber=0;
    
    % Open window with default settings:
    [w windowRect] =Screen('OpenWindow', screenNumber,[128 128 128]);
    white = WhiteIndex(w); % pixel value for white
    gray = GrayIndex(w); % pixel value for gray
    black = BlackIndex(w); % pixel value for black
    HideCursor;
    %load images
    fixationImage = imread(exptdesign.fixationImage);
    fixationTexture=Screen('MakeTexture', w, double(fixationImage));
    
    responseTime = exptdesign.responseTime;
    
    load('frequencyDiscrimStimuli3.mat');

    for iBlock=1:exptdesign.numBlocks
        if iBlock == 1
            drawAndCenterText(w, ['Please review instructions\n\n'...
                'Please click a mouse button to advance'],1)
            
            drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations, one after the other. \n'...
                'Indicate whether the vibrations are the same or different\n\n'...
                'LEFT mouse button = "SAME"\n\n'... 
                'RIGHT = "DIFFERENT".\n\n'...
                'Please click the mouse to continue\n'],1)
            
            drawAndCenterText(w,['\nFirst, you will do some practice trials with feedback. \n'...
                'After the practice trials, you will no longer recieve feedback.\n\n'...
                'Please click the mouse to continue\n'],1)
            
            drawAndCenterText(w,['Practice block \n\n\n\n'...
            'Click the mouse to continue'],1);
        
            %randomize stimuli
            order=randperm(size(stimuli,2));
            stimuli=stimuli(:, order);
            %lower and upper limit of fixation before stimulus is presented
            ll=.3;
            ul=.8;
            
           for iTrial=1:exptdesign.numPracticeTrials
               Screen('DrawTexture', w, fixationTexture);
                   [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = Screen('Flip',w);

               %pre-load stimulus 
                [stimLoadTime] = loadStimuli(stimuli(:,iTrial));

               %initial wait before stim presentation    
               wait1 = ll + (ul-ll).*rand(1);
               WaitSecs(wait1);

               stimOnset = GetSecs;
               rtn=-1;
               while rtn==-1
                   rtn=stimGenPTB('start');
               end
               stimFinished = GetSecs;

               drawAndCenterText(w,'Were the vibrations the same or different? \n', 0);

               %collect Response
               responseStartTime=GetSecs;
               sResp=getResponseMouse(responseTime, iBlock);
               responseFinishedTime=GetSecs;

               if isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial))
                   correctResponse=1;
               elseif ~isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial))
                   correctResponse=2;
               end

               %score the answer -- is sResp(iTrial)==correctResponse?
               if sResp==correctResponse
                   accuracy=1;
                   feedback = 'Correct!';
               else
                   accuracy=0;
                   feedback = 'Sorry, that was incorrect.';
               end
               drawAndCenterText(w,['\n' feedback '\n'...
                   'Please click the mouse to continue\n'],1)
               kbWait(1); % feedback screen would advance without waiting for mouse click, so added this as fix. requires 2 clicks when subject does not respond "same" or "different", however
               
               practiceTrialOutput.order                          = order;
               practiceTrialOutput.stimuli                        = stimuli;
               practiceTrialOutput.RT(iTrial)                     = responseFinishedTime-responseStartTime;
               practiceTrialOutput.sResp(iTrial)                  = sResp;
               practiceTrialOutput.correctResponse(iTrial)        = correctResponse;
               practiceTrialOutput.accuracy(iTrial)               = accuracy;
               
               clear correctResponse
           end
         
         drawAndCenterText(w,['\nYou have completed the practice trials.\n'...
         'Please click the mouse to continue\n'],1)
         kbWait(1);
        end
           
         if mod(iBlock,2)
            drawAndCenterText(w, ['Please review instructions\n\n'...
                'Please click a mouse button to advance'],1)
            
            drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations, one after the other. \n'...
                'Indicate whether the vibrations are the same or different\n\n'...
                'LEFT mouse button = "SAME"\n\n'... 
                'RIGHT = "DIFFERENT".\n\n'...
                'Please click the mouse to continue\n'],1)
            %after 300-800 ms, present the vibrotactile stimulus
            %on odd blocks, lower frequency @top is on left of screen
        else
            drawAndCenterText(w, ['Please review instructions \n Click the mouse to continue\n'...
                'Please click a mouse button to advance'],1)
            
            drawAndCenterText(w,['\nOn each trial, you will feel 2 vibrations, one after the other. \n'...
                'Indicate whether the vibrations are the same or different\n\n'...
                'RIGHT mouse button = "SAME"\n\n'... 
                'LEFT = "DIFFERENT".\n\n'...
                'Please click the mouse to continue\n'],1)
        end
        
        drawAndCenterText(w,['Block #' num2str(iBlock) ' of ' num2str(exptdesign.numBlocks) '\n\n\n\n'...
            'Click the mouse to continue'],1);
        blockStart = GetSecs;
        
        %randomize the stimuli for this level
        order=randperm(size(stimuli,2));
        stimuli=stimuli(:, order);
        %lower and upper limit of fixation before stimulus is presented
        ll=.3;
        ul=.8;
        
        for iTrial=1:exptdesign.numTrialsPerSession
           Screen('DrawTexture', w, fixationTexture);
               [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = Screen('Flip',w);
           
           %pre-load stimulus 
            [stimLoadTime] = loadStimuli(stimuli(:,iTrial));
               
           %initial wait before stim presentation    
           wait1 = ll + (ul-ll).*rand(1);
           WaitSecs(wait1);
           
           stimOnset = GetSecs;
           rtn=-1;
           while rtn==-1
               rtn=stimGenPTB('start');
           end
           stimFinished = GetSecs;
           
           drawAndCenterText(w,'Were the vibrations the same or different? \n', 0);
           
           %collect Response
           responseStartTime=GetSecs;
           sResp=getResponseMouse(responseTime, iBlock);
           responseFinishedTime=GetSecs;
           
           if isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial))
               correctResponse=1;
           elseif ~isequal(stimuli(1:4, iTrial),stimuli(5:8,iTrial))
               correctResponse=2;
           end

           %score the answer -- is sResp(iTrial)==correctResponse?
           if sResp==correctResponse
               accuracy=1;
           else
               accuracy=0;
           end
                    
           %record parameters for the trial
           trialOutput(iBlock).FixationVBLTimestamp(iTrial)   = FixationVBLTimestamp;
           trialOutput(iBlock).FixationOnsetTime(iTrial)      = FixationOnsetTime;
           trialOutput(iBlock).FixationFlipTimestamp(iTrial)  = FixationFlipTimestamp;
           trialOutput(iBlock).FixationMissed(iTrial)         = FixationMissed;
           trialOutput(iBlock).order                          = order;
           trialOutput(iBlock).stimuli                        = stimuli;
           trialOutput(iBlock).responseStartTime(iTrial)      = responseStartTime;
           trialOutput(iBlock).responseFinishedTime(iTrial)   = responseFinishedTime;
           trialOutput(iBlock).RT(iTrial)                     = responseFinishedTime-responseStartTime;
           trialOutput(iBlock).sResp(iTrial)                  = sResp;
           trialOutput(iBlock).correctResponse(iTrial)        = correctResponse;
           trialOutput(iBlock).accuracy(iTrial)               = accuracy;
           trialOutput(iBlock).wait1(iTrial)                  = wait1;
           trialOutput(iBlock).stimulusOnset(iTrial)          = stimOnset;
           trialOutput(iBlock).stimulusLoadTime(iTrial)       = stimLoadTime;
           trialOutput(iBlock).stimulusFinished(iTrial)       = stimFinished;
           trialOutput(iBlock).stimulusDuration(iTrial)       = stimFinished - stimOnset;
           trialOutput(iBlock).blockStart                     = blockStart;
           
           %tell subject how they did on last block
           if iTrial == exptdesign.numTrialsPerSession && iBlock < exptdesign.numBlocks
               %calculate accuracy
               accuracyForLevel=mean(trialOutput(iBlock).accuracy);
               drawAndCenterText(w, ['Your accuracy was ' num2str(round(accuracyForLevel.*100)) '%\n\n\n'...
                    'Click mouse to continue' ],1)
               %WaitSecs(2);
               KbWait(1);
           elseif iTrial == exptdesign.numTrialsPerSession && iBlock == exptdesign.numBlocks
               %calculate accuracy
               accuracyForLevel=mean(trialOutput(iBlock).accuracy);
               drawAndCenterText(w, ['Your accuracy was ' num2str(round(accuracyForLevel.*100)) '%\n\n\n'...
                   'You have completed this training session.  Great job!' ],1)
               %WaitSecs(2);
               KbWait(1);
               Screen('CloseAll')
           end
           
           clear correctResponse correctionTexture;
       end  

        %save the session data in the data directory
        save(['./data/' exptdesign.number '/' datestr(now, 'yyyymmdd_HHMM') '-' exptdesign.subjectName '_block' num2str(iBlock) '.mat'], 'trialOutput', 'exptdesign', 'practiceTrialOutput');
        %save the history data (stimuli, last level passed)
        
        
    end
    
    ShowCursor;
    
end
    
function drawAndCenterText(window,message,wait)
    if nargin < 3
        wait = 1;
    end
    
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 0);
    black = BlackIndex(window); % pixel value for black               
    Screen('Flip',window);
    %KbWait(1) waits for a MOUSE click to continue
    if wait, KbWait(1); end
    WaitSecs(0.2); %this is necessary on the windows XP machine to wait for mouse response -- DOES delay timing!
end

function [numericalanswer] = getResponseMouse(waitTime, nBlock)

  %Wait for a response
  numericalanswer = -1;
  mousePressed = 0;
  startWaiting=clock;
  while etime(clock,startWaiting) < waitTime && mousePressed == 0
      %check to see if a button is pressed
       [x,y,buttons] = GetMouse();
       if (~buttons(1) && ~buttons(3))
           continue;
       else
           if buttons(1)
               if (mod(nBlock,2))
                   numericalanswer = 1;
               else
                   numericalanswer = 2;
               end
           elseif buttons(3)
                if (mod(nBlock,2))
                   numericalanswer = 2;
               else
                   numericalanswer = 1;
               end
           else
               numericalanswer = 0;
           end
           if numericalanswer ~= -1
               %stop checking for a button press
               mousePressed = 1;
           end
       end

  end
end

function [stimLoadTime] = loadStimuli(stimuli)
    f1 = [stimuli(1), stimuli(2)];
    p1 = [stimuli(3), stimuli(4)];
    f2 = [stimuli(5), stimuli(6)];
    p2 = [stimuli(7), stimuli(8)];

    stim = {...
        {'fixed',f1(1),1,300},...
        {'fixchan',p1(1)},...
        {'fixed',f1(2),1,300},...
        {'fixchan',p1(2)},...
        {'fixed',f2(1),700,1000},...
        {'fixchan',p2(1)},...
        {'fixed',f2(2),700,1000},...
        {'fixchan',p2(2)},...
        };

    [t,s]=buildTSM_nomap(stim);
    
    startTime = tic;
    stimGenPTB('load',s,t);
    stimLoadTime = toc(startTime);
end
