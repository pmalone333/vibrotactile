%vibrotactile speech training. called by VT_speechTraining.m
%PSM pmalone333@gmail.com

function VT_speechTraining_experiment(name, exptdesign)

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
    
    if exptdesign.training.stimType==1
        load('stimuli\stimuli_GU.mat');
    elseif exptdesign.training.stimType==2
        load('stimuli\stimuli_FB.mat');
    end
    
    level = exptdesign.training.level;

    for iBlock=1:exptdesign.numSessions %how many blocks to run this training session
        drawAndCenterText(w,['Training Block #' num2str(iBlock) ' of ' num2str(exptdesign.numSessions) '\n\n\n\n'...
            'You are on Level ' num2str(level) '\n\n\n\n'...
            'Click the mouse to continue'],1);
        
        stimuli = stim{level};
        labels = label{level};
        stimOrder = randperm(length(stimuli))';
        stimuli = stimuli(stimOrder,:);
        labels = labels(stimOrder,:);

        for iTrial=1:exptdesign.numTrialsPerSession
            
            %get start sample and num_samples for each word in pair
            target = labels{iTrial,1};

            %draw fixation
            Screen('DrawTexture', w, fixationTexture);
            [FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed] = Screen('Flip',w);

            r = randperm(size(labels,2)); %randomize order of labels for display 
            disp_labels = labels(iTrial,:);
            disp_labels = disp_labels(r);
            disp_str = '';
            for i=1:length(disp_labels)
                disp_str = [disp_str '     ' disp_labels{i}];
            end
            [nx, ny, bbox] = DrawFormattedText(w, disp_str, 'center', 'center', 1);
            [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w);
            
            %play stimulus   target=worda worda wordb 
            s = stimuli{iTrial,1};
            t = stimuli{iTrial,2};
            piezoDriver32('load',t,s);
            piezoDriver32('start');
            
            %get keyboard response
            while KbCheck; end % Wait until all keys are released.
            responseStartTime = GetSecs;
            while 1
                % Check the state of the keyboard.
                [ keyIsDown, seconds, keyCode ] = KbCheck;
                if keyIsDown
                    sResp = KbName(keyCode);
                    responseFinishedTime = GetSecs;
                    break
                    while KbCheck; end
                end
            end

            %score the answer
            accuracy=0;
            for i=1:length(size(labels,2))
                r = str2num(sResp(1));
                if strcmp(target,disp_labels{r}), accuracy=1;
                end
            end


            %feedback
            if accuracy==0
                drawAndCenterText(w, ['Incorrect.\n\nIf you would like to feel ' target ' again click the RIGHT mouse button.\n\nClick the LEFT mouse button to continue.'], 1.5);
                %WaitSecs(.1);
                %[CorrectionVBLTimestamp CorrectionOnsetTime CorrectionFlipTimestamp CorrectionMissed]=Screen('Flip', w);
                KbPressWait(1);
                [var1, keycode, var2] = KbPressWait(1);
                %tResp = getResponseMouse2();
                while keycode(1) ~= 1
                    rtn=-1;
                    while rtn==-1
                        rtn=piezoDriver32('start');
                    end
                    drawAndCenterText(w, ['Incorrect.\n\nIf you would like to feel ' target ' again click the RIGHT mouse button.\n\nClick the LEFT mouse button to continue.'], 1.5);
                    [var1, keycode, var2] = KbPressWait(1);
                    %tResp = getResponseMouse2();
                end
            else
                drawAndCenterText(w, ['Correct!\n\nIf you would like to feel ' target ' again click the RIGHT mouse button.\n\nClick the LEFT mouse button to continue.'], 1.5);
                %WaitSecs(.1);
                %[CorrectionVBLTimestamp CorrectionOnsetTime CorrectionFlipTimestamp CorrectionMissed]=Screen('Flip', w);
                KbPressWait(1);
                [var1, keycode, var2] = KbPressWait(1);
                %tResp = getResponseMouse2();
                while keycode(1) ~= 1
                    rtn=-1;
                    while rtn==-1
                        rtn=piezoDriver32('start');
                    end
                    drawAndCenterText(w, ['Correct!\n\nIf you would like to feel ' target ' again click the RIGHT mouse button.\n\nClick the LEFT mouse button to continue.'], 1.5);
                    [var1, keycode, var2] = KbPressWait(1);
                    %tResp = getResponseMouse2();
                end
            end
            
            %record parameters for the trial
            trialOutput(iBlock).responseStartTime(iTrial)=responseStartTime;
            trialOutput(iBlock).responseFinishedTime(iTrial)=responseFinishedTime;
            trialOutput(iBlock).RT(iTrial)=responseFinishedTime-responseStartTime;
            trialOutput(iBlock).sResp{iTrial}=sResp;
            trialOutput(iBlock).accuracy(iTrial)=accuracy;
            trialOutput(iBlock).target{iTrial}=target;
            trialOutput(iBlock).stim{iTrial}=stimuli{iTrial};
            trialOutput(iBlock).disp_labels{iTrial}=disp_labels;
            trialOutput(iBlock).disp_str{iTrial}=disp_str;

            %save stimulus presentation timestamps
%             trialOutput(iBlock).FixationVBLTimestamp(iTrial)=FixationVBLTimestamp;
%             trialOutput(iBlock).FixationOnsetTime(iTrial)=FixationOnsetTime;
%             trialOutput(iBlock).FixationFlipTimestamp(iTrial)=FixationFlipTimestamp;
%             trialOutput(iBlock).FixationMissed(iTrial)=FixationMissed;
%             trialOutput(iBlock).RespVBLTimestamp(iTrial)=RespVBLTimestamp;
%             trialOutput(iBlock).RespOnsetTime(iTrial)=RespOnsetTime;
%             trialOutput(iBlock).RespFlipTimestamp(iTrial)=RespFlipTimestamp;
%             trialOutput(iBlock).RespMissed(iTrial)=RespMissed;

         
          
            %tell subject how they did on last trial
            if iTrial==exptdesign.numTrialsPerSession && iBlock < exptdesign.numSessions
                accuracyForBlock=mean(trialOutput(iBlock).accuracy);
                drawAndCenterText(w, ['Your accuracy was ' num2str(round(accuracyForBlock.*100)) '%\n\n\n'...
                    'Click mouse to continue' ],1)
                KbWait(1)

            elseif iTrial==exptdesign.numTrialsPerSession && iBlock == exptdesign.numSessions
                %calculate accuracy
                accuracyForBlock=mean(trialOutput(iBlock).accuracy);
                drawAndCenterText(w, ['Your accuracy was ' num2str(round(accuracyForBlock.*100)) '%\n\n\n'...
                    'You have completed this training session.  Thank you for your work!' ],1)
                KbWait(1)
                Screen('CloseAll')
            end

            clear correctResp;
            
        end
        
    if accuracyForBlock>exptdesign.accuracyCutoff, level=level+1; end
    
    %record parameters for the block
    trialOutput(iBlock).order=stimOrder;
    trialOutput(iBlock).stimuli=stimuli;
    trialOutput(iBlock).labels=labels;
    trialOutput(iBlock).level=level;
    trialOutput(iBlock).accuracyForBlock=accuracyForBlock;

    %save the session data in the data directory
    save(['./data/' exptdesign.subNumber '/' datestr(now, 'yyyymmdd_HHMM') '-' exptdesign.subName '_block' num2str(iBlock) '.mat'], 'trialOutput', 'exptdesign');
    
    %save the history data (stimuli, last level passed
    history = [exptdesign.training.history];
    exptdesign.training.history = history;
    stimType = exptdesign.training.stimType;
    save(['./history/SUBJ' exptdesign.subNumber 'training.mat'], 'history', 'level', 'stimType');

    
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
