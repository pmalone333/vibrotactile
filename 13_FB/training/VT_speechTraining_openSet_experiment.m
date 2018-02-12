%vibrotactile speech training. called by VT_speechTraining.m
%PSM pmalone333@gmail.com

function VT_speechTraining_openSet_experiment(name, exptdesign, stimType)

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
%     drawAndCenterText(w, ['Please review instructions \n'...
%         'Press any key to continue'],1)

    drawAndCenterText(w,'\nVibrotactile speech training.\n\n\nPress any key to continue.',0)
    KbWait
    
    
    if stimType == 1
        makeGUTrainingStim;
        load('stimuli_GU_openSet.mat');
    elseif stimType == 2
        makeFBTrainingStim;
        load('stimuli_FB_openSet.mat');
    end
    
    level = exptdesign.training.level;
    

    for iBlock=1:exptdesign.numSessions %how many blocks to run this training session
        drawAndCenterText(w,['Training Block #' num2str(iBlock) ' of ' num2str(exptdesign.numSessions) '\n\n\n\n'...
            'Press any key to continue'],0);
        while KbCheck; end % Wait until all keys are released.
        KbWait
        
        stimuli = stim;
        labels = label;
        stimOrder = randperm(length(stimuli))';
        stimuli = stimuli(stimOrder,:);
        labels = labels(stimOrder,:);

        for iTrial=1:exptdesign.numTrialsPerSession
            
            %get start sample and num_samples for each word in pair
            target = labels{iTrial,1};

            %draw fixation
            Screen('DrawTexture', w, fixationTexture);
            [FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed] = Screen('Flip',w);


  
            %play stimulus   target=worda worda wordb 
            s = stimuli{iTrial,1};
            t = stimuli{iTrial,2};
            piezoDriver32('load',t,s);
            piezoDriver32('start');
            
           
            while KbCheck; end % Wait until all keys are released.
            clear sResp
            FlushEvents
            responseStartTime = GetSecs;
            sResp = getEchoString(w,'Please type the word you felt, followed by the Enter key:',25, 400, [], [255 255 255]);
            responseFinishedTime = GetSecs;

            %score the answer
            accuracy=0;
            if strcmp(sResp,target)
                accuracy=1;
                drawAndCenterText(w, ['Correct!\n\nThe correct answer was ' target '.\n Press any key to continue.'], 0)
                while KbCheck; end % Wait until all keys are released.
                KbWait
            else
                drawAndCenterText(w, ['Incorrect.\n\nThe correct answer was ' target '.\n Press any key to continue.'], 0)
                while KbCheck; end % Wait until all keys are released.
                KbWait
            end
            

            %record parameters for the trial
            trialOutput(iBlock).responseStartTime(iTrial)=responseStartTime;
            trialOutput(iBlock).responseFinishedTime(iTrial)=responseFinishedTime;
            trialOutput(iBlock).RT(iTrial)=responseFinishedTime-responseStartTime;
            trialOutput(iBlock).sResp{iTrial}=sResp;
            trialOutput(iBlock).accuracy(iTrial)=accuracy;
            trialOutput(iBlock).target{iTrial}=target;
            trialOutput(iBlock).stim{iTrial}=stimuli{iTrial};
        end


            
            %tell subject how they did on last trial
            if iTrial==exptdesign.numTrialsPerSession && iBlock < exptdesign.numSessions
                accuracyForBlock=mean(trialOutput(iBlock).accuracy);
                drawAndCenterText(w, ['Your accuracy was ' num2str(round(accuracyForBlock.*100)) '%\n\n\n'...
                    'Press any key to continue' ],0)
                while KbCheck; end % Wait until all keys are released.
                KbWait

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
        
    %if accuracyForBlock>exptdesign.accuracyCutoff, level=level+1; end
    
    %record parameters for the block
    trialOutput(iBlock).order=stimOrder;
    trialOutput(iBlock).stimuli=stimuli;
    trialOutput(iBlock).labels=labels;
    trialOutput(iBlock).accuracyForBlock=accuracyForBlock;

    %save the session data in the data directory
    save(['./data/' exptdesign.subNumber '/' datestr(now, 'yyyymmdd_HHMM') '-' exptdesign.subName '_block' num2str(iBlock) '.mat'], 'trialOutput', 'exptdesign');
    
    %save the history data (stimuli, last level passed
    history = [exptdesign.training.history];
    exptdesign.training.history = history;
    %exptdesign.training.stimType = stimType;
    save(['./history/SUBJ' exptdesign.subNumber 'training.mat'], 'history', 'level', 'stimType');

    

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
