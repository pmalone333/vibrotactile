function testChannelsExperiment(exptdesign)

    % frequencyDiscrimination
    % Courtney Sprouse cs1471@georgetown.edu
    
    % Open a screen and display instructions
    screenNumber = 0;
    
    % Open window with default settings:
    Screen('Preference', 'SkipSyncTests', 1)
    [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128]);
    %[w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128], [0 0 200 200]); 
   
    %HideCursor;
    %load images and textures
    fixationImage = imread(exptdesign.fixationImage);
    fixationTexture = Screen('MakeTexture', w, double(fixationImage));
    j = 1;
    for i = 1:length(exptdesign.stimBoardImages)
        stimBoardImages(:,:,:,j) = {imread(['imgScaled/' exptdesign.stimBoardImages(i).name])};
        j = j+1;
    end
    
    for i = 1:size(stimBoardImages,4)
        stimBoardTextures(i) = Screen('MakeTexture', w, double(stimBoardImages{:,:,:,i}));
    end
    
    stimPresentation = exptdesign.StimPresentationWindow;
    
    %load training stimuli
    load('testStimuli.mat');
    
    for iBlock=1:exptdesign.numBlocks
        drawAndCenterText(w, ['You will feel three pulses of a vibration at a particular channel.\n\n\n'...
            'You may repeat the vibration as many times as you would like until you feel the vibration\n\n\n '...
            'Please click the mouse when you are ready to advance'],1)
        
        for iTrial=1:exptdesign.numTrialsPerSession
           Screen('DrawTexture', w, fixationTexture);
               [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = Screen('Flip',w);
           
               
           Screen('DrawTexture', w, stimBoardTextures(iTrial));
               [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = Screen('Flip',w);
           
           %pre-load stimulus 
           loadStimuli(stimuli(:,iTrial));
           
           stimOnset = GetSecs;
           rtn=-1;
           while rtn==-1
               rtn=stimGenPTB('start');
           end
           stimFinished = GetSecs;
           stimDuration = stimFinished - stimOnset;
           stimOffset = stimPresentation - stimDuration;
           WaitSecs(stimOffset)

           WaitSecs(.5)
           drawAndCenterText(w,['Did you feel the vibration at the specified channel? \n\n\n'...
               'If YES click the LEFT mouse button '...
               'If NO click the RIGHT mouse button to replay the vibration'], 0)
           
           [sResp] = getResponseMouse();
           
           while sResp == 0
               
               Screen('DrawTexture', w, stimBoardTextures(:,iTrial));
               [FixationVBLTimestamp, FixationOnsetTime, FixationFlipTimestamp, FixationMissed] = Screen('Flip',w);
               
               stimOnset = GetSecs;
               rtn=-1;
               while rtn==-1
                   rtn=stimGenPTB('start');
               end
               stimFinished = GetSecs;
               stimDuration = stimFinished - stimOnset;
               stimOffset = stimPresentation - stimDuration;
               WaitSecs(stimOffset)
               
               drawAndCenterText(w,['Did you feel the vibration at the specified channel? \n\n\n'...
               'If YES click the LEFT mouse button '...
               'If NO click the RIGHT mouse button to replay the vibration'], 0)
           
               [sResp] = getResponseMouse();
           end
           
           Screen('Close', stimBoardTextures(iTrial))
           
           %Last flip screen
           if iTrial == exptdesign.numTrialsPerSession && iBlock == exptdesign.numBlocks
               drawAndCenterText(w, 'You have completed this training session.  Great job!', 1)
               Screen('CloseAll')
           end
           
        end  
        
    end
    
    ShowCursor;
    
end
    
function drawAndCenterText(window, message, wait)
    
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 0);             
    Screen('Flip',window);
    
    %KbWait(1) waits for a MOUSE click to continue
    if wait, KbWait(1); end %note on CAS computer = 4
    WaitSecs(0.2); %this is necessary on the windows XP machine to wait for mouse response -- DOES delay timing!
end

function [numericalAnswer] = getResponseMouse()

  %Wait for a response
  numericalAnswer = -1;
  mousePressed = 0;
  
  while mousePressed == 0
      %check to see if a button is pressed
       [x,y,buttons] = GetMouse();
       if buttons(1)
           numericalAnswer = 1;
           mousePressed = 1;
       elseif buttons(3) %note on cas computer = 2
           numericalAnswer = 0;
           mousePressed = 1;
       end
  end
end

function [stimLoadTime] = loadStimuli(stimuli)
    if size(stimuli,2) > 2
        f = [stimuli(1), stimuli(3)];
        p = [stimuli(2), stimuli(4)];
        
        stim = {...
        {'fixed',f(1),1,300},...
        {'fixchan',p(1)},...
        {'fixed',f(2),1,300},...
        {'fixchan',p(2)},...
        };
    else
        f = stimuli(1);
        p = stimuli(2);
        
        stim = {...
        {'fixed',f(1),1,500},...
        {'fixchan',p(1)},...
        };
    end 

    [t,s]=buildTSM_nomap(stim);
    
    startTime = tic;
    stimGenPTB('load',s,t);
    stimLoadTime = toc(startTime);
end
