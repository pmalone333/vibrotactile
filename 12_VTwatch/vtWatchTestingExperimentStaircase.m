%VT watch testing. called by vtWatchTesting.m
%PSM pmalone333@gmail.com

function vtWatchTestingExperimentStaircase(name, exptdesign)

    rand('twister',sum(100*clock))

    %open a screen and display instructions
    screens = Screen('Screens');
    screenNumber = min(screens);

    %open window with default settings:
    [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128]);
    
    %set font size
    Screen('TextSize',w, 24);

    %load images
    fixationImage = imread(exptdesign.fixationImage);
    blankImage = imread(exptdesign.blankImage);
    fixationTexture=Screen('MakeTexture', w, double(fixationImage));
    blankTexture=Screen('MakeTexture', w, double(blankImage));

    %display experiment instructions
    drawAndCenterText(w, ['Please review instructions \n'...
        'Please click a mouse button to advance at each screen'],1)

    drawAndCenterText(w,'\nVibrotactile speech training',1)
    
    stim = {'ada1';'ada2';'aza1';'aza2';'aba1';'aba2';'ata1';'ata2';'ana1';'ana2';...
    'ama1';'ama2';'asa1';'asa2';'apa1';'apa2';'ava1';'ava2';'afa1';'afa2';'aga1';...
    'aga2';'aka1';'aka2'};

    numReversal = 0;
    
    for iBlock=1:exptdesign.numSessions %how many blocks to run this training session
        drawAndCenterText(w,['Block #' num2str(iBlock) ' of ' num2str(exptdesign.numSessions) '\n\n\n\n'...
            'Click the mouse to continue'],1);
        
        stimuli = repmat(stim,floor(exptdesign.numTrialsPerSession/length(stim)),1);        
        stimOrder = randperm(length(stimuli));
        stimuli = stimuli(stimOrder);

        for iTrial=1:exptdesign.numTrialsPerSession
            
            if numReversal == exptdesign.numReversals
                drawAndCenterText(w, ['You have completed the session.  Thank you for your work!'],1)
                KbWait(1)
                break;
                Screen('CloseAll')
            end
                 
            %draw fixation
            Screen('DrawTexture', w, fixationTexture);
            [FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed] = Screen('Flip',w);
            clear y 
            [y,freq,dummy2] = wavread(['audio\' stimuli{iTrial} '.wav']);
            wavedata = y';
            nrchannels = size(wavedata,1);
            InitializePsychSound;
            if iTrial == 1
            soundhandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
            end
            % set initial volume
            if iTrial == 1
                volume = 0.9;
            end
            PsychPortAudio('Volume', soundhandle, volume);
            %fill primary buffer with waveform... tokens will be copied from this
            PsychPortAudio('FillBuffer', soundhandle, wavedata, 0, 1);
                        %start audio, wait for it to finish
            PsychPortAudio('Start', soundhandle, 1,0,1);
            while 1
                status = PsychPortAudio('GetStatus', soundhandle);
                %wait for playback to finish
                if status.Active == 0
                    break;
                end
            end
            
            [nx, ny, bbox] = DrawFormattedText(w, ['What consonant did you hear?'], 'center', 'center', 1);
            [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w);
            
            while KbCheck; end % Wait until all keys are released.
            responseStartTime = GetSecs;
            while 1
                % Check the state of the keyboard.
                [ keyIsDown, seconds, keyCode ] = KbCheck;
                if keyIsDown
                    sResp = KbName(keyCode);
                    break
                    while KbCheck; end
                end
            end

            RT = seconds - responseStartTime;
            if strcmp(sResp,stimuli{iTrial}(2))
                accuracy = 1;
            else 
                accuracy = 0;
            end
            
            if accuracy == 0
                volume = volume + exptdesign.staircaseStep;
                reversal = 1;
                numReversal = numReversal+1;
            elseif iTrial~=1 && accuracy == 1
                if accuracy == 1 && trialOutput(iBlock).accuracy(iTrial-1)==1 && iTrial ~= 1
                volume = volume - exptdesign.staircaseStep;
                reversal = 0;
                end
            elseif accuracy == 1 && iTrial == 1
                reversal = 0;    
            end
            
            %record parameters for the trial
            %trialOutput(iBlock).responseStartTime(iTrial)=responseStartTime;
            %trialOutput(iBlock).responseFinishedTime(iTrial)=responseFinishedTime;
            %trialOutput(iBlock).RT(iTrial)=responseFinishedTime-responseStartTime;
            trialOutput(iBlock).sResp{iTrial}=sResp;
            trialOutput(iBlock).RT(iTrial)=RT;
            trialOutput(iBlock).accuracy(iTrial)=accuracy;
            trialOutput(iBlock).volume(iTrial)=volume;
            trialOutput(iBlock).reversal(iTrial)=reversal;
            %trialOutput(iBlock).correctResp(iTrial)=correctResp;

            %save stimulus presentation timestamps
%             trialOutput(iBlock).FixationVBLTimestamp(iTrial)=FixationVBLTimestamp;
%             trialOutput(iBlock).FixationOnsetTime(iTrial)=FixationOnsetTime;
%             trialOutput(iBlock).FixationFlipTimestamp(iTrial)=FixationFlipTimestamp;
%             trialOutput(iBlock).FixationMissed(iTrial)=FixationMissed;
%             trialOutput(iBlock).RespVBLTimestamp(iTrial)=RespVBLTimestamp;
%             trialOutput(iBlock).RespOnsetTime(iTrial)=RespOnsetTime;
%             trialOutput(iBlock).RespFlipTimestamp(iTrial)=RespFlipTimestamp;
%             trialOutput(iBlock).RespMissed(iTrial)=RespMissed;

            
            if iTrial==exptdesign.numTrialsPerSession && iBlock < exptdesign.numSessions
                drawAndCenterText(w, ['Click mouse to continue'],1)
                KbWait(1)

            elseif iTrial==exptdesign.numTrialsPerSession && iBlock == exptdesign.numSessions
                drawAndCenterText(w, ['You have completed the session.  Thank you for your work!'],1)
                KbWait(1)
                Screen('CloseAll')
            end
        end
    %record parameters for the block
    trialOutput(iBlock).order=stimOrder;
    trialOutput(iBlock).stimuli=stimuli;

    %save the session data in the data directory
    save(['./data/' exptdesign.subNumber '/' datestr(now, 'yyyymmdd_HHMM') '-' exptdesign.subName '_block' num2str(iBlock) '.mat'], 'trialOutput', 'exptdesign');
    
    end
    ShowCursor;
end

function drawAndCenterText(window,message, wait)
if wait == 1
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 1);
    Screen('Flip',window);
    KbPressWait(1);
else
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 1);
    Screen('Flip',window);
end
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
