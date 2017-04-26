function twoPtDiscrimExper(name,exptdesign)

    % Two point discrimination experiment
    % Patrick Malone pmalone333@gmail.com
    
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
    % BLANK IMAGE
    blankImage = imread(exptdesign.blankImage);
    
    fixationTexture=Screen('MakeTexture', w, double(fixationImage));
    blankTexture=Screen('MakeTexture', w, double(blankImage));
    
        %Display experiment instructions
    drawAndCenterText(w, ['Please review instructions \n'...
        'Please click a mouse button to advance at each screen'],1)
    
    drawAndCenterText(w,['\nOn each trial, you will feel 2 sets of vibrations, one after the other. \n'...
             'Indicate whether the vibrations are the same or different\n'...
             'by clicking the left mouse button for "same" and right button for "different".\n'],1)
         
    %load training stimuli
    load('trialStructTest.mat');
    
    for iBlock=1:exptdesign.numSessions
        
        stimulusTracking=[]; % what does this do? copied from Clara's code
        drawAndCenterText(w,['Block #' num2str(iBlock) ' of ' num2str(exptdesign.numSessions) '\n\n\n\n'...
            'Click the mouse to continue'],1); 
        %WaitSecs(1);
        KbWait(1);
        %randomize the stimuli for this level
        order=randperm(size(trialStruct,2));
        %stimuli=squeeze(trainingStimuli(:,order,level));
        stimuli=trialStruct(order);
        %lower and upper limit of fixation before stimulus is presented
        ll=.3;
        ul=.8;
        
        for iTrial=1:size(trialStruct,2)
            
           Screen('DrawTexture', w, fixationTexture);
           [FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed] = Screen('Flip',w);
           %after 300-800 ms, present the vibrotactile stimulus
           wait1 = ll + (ul-ll).*rand(1);
           WaitSecs(wait1);
           constructCategoryTrainingStimulus(stimuli{:,iTrial}(:,1)); % present stim 1
           % copied this wait code from above; how long should we wait
           % between stimuli
           wait1 = ll + (ul-ll).*rand(1);
           WaitSecs(wait1);
           constructCategoryTrainingStimulus(stimuli{:,iTrial}(:,2)); % present stim 2
           
           %drawAndCenterText(w,'Were the vibrations the same or different? \n',0)
           
           if isequal(stimuli{:,1}(:,1),stimuli{:,1}(:,2)) % are stimuli the same?
                    correctResponse=1;
           else
                    correctResponse=2;
           end

           DrawFormattedText(w, 'Were the vibrations the same or different? \n', 'center', 'center', 0);
           [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w);
           responseStartTime=GetSecs;
           sResp=getResponseMouse(100);
           responseFinishedTime=GetSecs;
          
           %score the answer -- is sResp(iTrial)==correctResponse?
           if sResp==correctResponse
               accuracy=1;
           else
               accuracy=0;
           end
           
           %record parameters for the trial
           trialOutput(iBlock).responseStartTime(iTrial)=responseStartTime;
           trialOutput(iBlock).responseFinishedTime(iTrial)=responseFinishedTime;
           trialOutput(iBlock).RT(iTrial)=responseFinishedTime-responseStartTime;
           trialOutput(iBlock).sResp(iTrial)=sResp;
           trialOutput(iBlock).accuracy(iTrial)=accuracy;
           trialOutput(iBlock).correctResponse(iTrial)=correctResponse;
           trialOutput(iBlock).wait1(iTrial)=wait1;
           trialOutput(iBlock).preOrPostTrain = exptdesign.preOrPostTrain;
           
           %save stimulus presentation timestamps
           %[FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed]
           %[RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed]
           %
           trialOutput(iBlock).FixationVBLTimestamp(iTrial)=FixationVBLTimestamp;
           trialOutput(iBlock).FixationOnsetTime(iTrial)=FixationOnsetTime;
           trialOutput(iBlock).FixationFlipTimestamp(iTrial)=FixationFlipTimestamp;
           trialOutput(iBlock).FixationMissed(iTrial)=FixationMissed;
           trialOutput(iBlock).RespVBLTimestamp(iTrial)=RespVBLTimestamp;
           trialOutput(iBlock).RespOnsetTime(iTrial)=RespOnsetTime;
           trialOutput(iBlock).RespFlipTimestamp(iTrial)=RespFlipTimestamp;
           trialOutput(iBlock).RespMissed(iTrial)=RespMissed;
           
           %tell subject how they did on last block
           if iTrial==size(trialStruct,2) && iBlock < exptdesign.numSessions
               %calculate accuracy
               accuracyForLevel=mean(trialOutput(iBlock).accuracy);
               drawAndCenterText(w, ['Your accuracy was ' num2str(round(accuracyForLevel.*100)) '%\n\n\n'...
                    'Click mouse to continue' ],1)
               %WaitSecs(2);
               KbWait(1);
           elseif iTrial==size(trialStruct,2) && iBlock == exptdesign.numSessions
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

        %record parameters for the block
        %stimuli, order
        trialOutput(iBlock).order=order;
        trialOutput(iBlock).stimuli=stimuli;
        
        %save the session data in the data directory
        save(['./data/' exptdesign.number '/' datestr(now, 'yyyymmdd_HHMM') '-' exptdesign.subjectName '_block' num2str(iBlock) '.mat'], 'trialOutput', 'exptdesign');
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

function numericalanswer = getResponseMouse(waitTime)

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
               numericalanswer = 1;
           elseif buttons(3)
               numericalanswer = 2;
           else
               numericalanswer = 0;
           end
          if numericalanswer ~= -1
              %stop checking for a button press
              mousePressed = 1;
          end
       end

  end
  if numericalanswer == -1
      numericalanswer =0;
  end
end
