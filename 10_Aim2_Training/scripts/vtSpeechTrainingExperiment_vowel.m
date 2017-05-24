    sca
sca
%vibrotactile speech training. called by vtSpeechTraining.m
%PSM pmalone333@gmail.com

function vtSpeechTrainingExperiment_vowel(name, exptdesign)

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

    drawAndCenterText(w,'\nAim 2 VT speech training',1)
    
    vowel_cfg %load vowel config file 

    %load audio
    [y,freq,dummy] = wavread(audio_filename);
    wavedata = y';
    nrchannels = size(wavedata,1);
    InitializePsychSound;
    soundhandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);

    %fill primary buffer with waveform... tokens will be copied from this
    PsychPortAudio('FillBuffer', soundhandle, wavedata, 0, 1);  

    for iBlock=1:exptdesign.numSessions %how many blocks to run this training session
        drawAndCenterText(w,['Training Block #' num2str(iBlock) ' of ' num2str(exptdesign.numSessions) '\n\n\n\n'...
            'Click the mouse to continue'],1);

        %lower and upper limit of fixation before stimulus is presented
        ll=.3;
        ul=.8;
        
        if iBlock == 1, word_pairs = repmat(word_pairs_H1L1,1,floor(60/length(word_pairs_H1L1)));
        %elseif iBlock == 2, word_pairs = repmat(word_pairs_H2L2,1,floor(60/length(word_pairs_H2L2)));
        %elseif iBlock == 3, word_pairs = repmat(word_pairs_H1L1,1,floor(60/length(word_pairs_H1L1)));
        %elseif iBlock == 4, word_pairs = repmat(word_pairs_M2L2,1,floor(60/length(word_pairs_M2L2)));
        %elseif iBlock == 5, word_pairs = repmat(word_pairs_M1L1,1,floor(60/length(word_pairs_M1L1)));
        %elseif iBlock == 6, word_pairs = repmat(word_pairs_H2M2,1,floor(60/length(word_pairs_H2M2)));
        %elseif iBlock == 7, word_pairs = repmat(word_pairs_H1M1,1,floor(60/length(word_pairs_H1M1)));
        end
        
        stimOrder = randperm(length(word_pairs));
        word_pairs = word_pairs(stimOrder);

        for iTrial=1:exptdesign.numTrialsPerSession
            
            %get start sample and num_samples for each word in pair
            r = randperm(2); %random permutation of 1 and 2 to randomize word presentation order
            word1 = word_pairs{iTrial}(r(1));
            word2 = word_pairs{iTrial}(r(2));
            word1_ind = find(strcmp(list_words, char(word1)));
            %word1_ind = strcmp(list_words,char(word1));
            %word1_ind = find(not(cellfun('isempty', word1_ind)));
            word2_ind = find(strcmp(list_words, char(word2)));
            %word2_ind = strcmp(list_words,char(word2));
            %word2_ind = find(not(cellfun('isempty', word2_ind)));
            
            %start sample and duration for word1 
            startSamp1 = list_startSamples(word1_ind);
            numSamps1 = list_numSamples(word1_ind);
            %start sample and duration for word2
            startSamp2 = list_startSamples(word2_ind);
            numSamps2 = list_numSamples(word2_ind);
            
            %draw fixation
            %Screen('DrawTexture', w, fixationTexture);
            %[FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed] = Screen('Flip',w);
            r = randperm(2); %random permutation of 1 and 2 to randomize correct word
            if r(1) == 1
                correctWord = word1;
                correctResp = 1;
            else
                correctWord = word2;
                correctResp = 2;
            end
            
            drawAndCenterText(w, correctWord{1},0)
            %after 300-800 ms, present the 2 VT speech stimuli
            wait1 = ll + (ul-ll).*rand(1);
            WaitSecs(wait1);
        
            %load word1
            %awave = wavedata(1:2, startSamp:startSamp+numSamps);
            awave = wavedata(1, startSamp1:startSamp1+numSamps1);
            PsychPortAudio('FillBuffer', soundhandle, awave);

            %start audio, wait for it to finish
            PsychPortAudio('Start', soundhandle, 1,0,1);
            while 1
                status = PsychPortAudio('GetStatus', soundhandle);
                %wait for playback to finish
                if status.Active == 0
                    break;
                end
            end
            
            %load word2
            %awave = wavedata(1:2, startSamp:startSamp+numSamps);
            awave = wavedata(1, startSamp2:startSamp2+numSamps2);
            PsychPortAudio('FillBuffer', soundhandle, awave);

            %start audio, wait for it to finish
            PsychPortAudio('Start', soundhandle, 1,0,1);
            while 1
                status = PsychPortAudio('GetStatus', soundhandle);
                %wait for playback to finish
                if status.Active == 0
                    break;
                end
            end

            %show the two arm images at a latency of .6+wait1 seconds
            %drawAndCenterText(w, ['Was ' correctWord{1} ' the first or second stimulus?\n'],0)
            
            [nx, ny, bbox] = DrawFormattedText(w, ['Was ' correctWord{1} ' the first or second stimulus?\n'], 'center', 'center', 1);
            [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w, 0.6+wait1);
            responseStartTime=GetSecs;
            sResp = getResponseMouse(100);
            responseFinishedTime=GetSecs;

            %score the answer -- is sResp(iTrial)==correctResponse?
            if sResp==correctResp
                accuracy=1;
            else
                accuracy=0;
            end

            %replay stimuli if incorrect
            if accuracy==0
                %these 200 ms pauses prevent the code from skipping steps on
                %the Dell Windows XP machine
                %Screen('DrawTexture', w, errorTexture);
                WaitSecs(.1);
                [CorrectionVBLTimestamp CorrectionOnsetTime CorrectionFlipTimestamp CorrectionMissed]=Screen('Flip', w);
                %KbPressWait(1);
                drawAndCenterText(w, ['Incorrect. ' correctWord{1} ' was stimulus number ' num2str(correctResp) '\n' ...
                    'Click the mouse to play the stimuli again.'], 1);
                %load word1
                %awave = wavedata(1:2, startSamp:startSamp+numSamps);
                awave = wavedata(1, startSamp1:startSamp1+numSamps1);
                PsychPortAudio('FillBuffer', soundhandle, awave);

                %start audio, wait for it to finish
                PsychPortAudio('Start', soundhandle, 1,0,1);
                while 1
                    status = PsychPortAudio('GetStatus', soundhandle);
                    %wait for playback to finish
                    if status.Active == 0
                        break;
                    end
                end

                %load word2
                %awave = wavedata(1:2, startSamp:startSamp+numSamps);
                awave = wavedata(1, startSamp2:startSamp2+numSamps2);
                PsychPortAudio('FillBuffer', soundhandle, awave);

                %start audio, wait for it to finish
                PsychPortAudio('Start', soundhandle, 1,0,1);
                while 1
                    status = PsychPortAudio('GetStatus', soundhandle);
                    %wait for playback to finish
                    if status.Active == 0
                        break;
                    end
                end
                drawAndCenterText(w, [correctWord{1} ' was stimulus number ' num2str(correctResp) '\n' ...
                    'Click the mouse to advance to the next trial.'], 1)
            end
            
            %record parameters for the trial
            trialOutput(iBlock).responseStartTime(iTrial)=responseStartTime;
            trialOutput(iBlock).responseFinishedTime(iTrial)=responseFinishedTime;
            trialOutput(iBlock).RT(iTrial)=responseFinishedTime-responseStartTime;
            trialOutput(iBlock).sResp(iTrial)=sResp;
            trialOutput(iBlock).accuracy(iTrial)=accuracy;
            trialOutput(iBlock).correctResp(iTrial)=correctResp;
            trialOutput(iBlock).wait1(iTrial)=wait1;

            %save stimulus presentation timestamps
%             trialOutput(iBlock).FixationVBLTimestamp(iTrial)=FixationVBLTimestamp;
%             trialOutput(iBlock).FixationOnsetTime(iTrial)=FixationOnsetTime;
%             trialOutput(iBlock).FixationFlipTimestamp(iTrial)=FixationFlipTimestamp;
%             trialOutput(iBlock).FixationMissed(iTrial)=FixationMissed;
%             trialOutput(iBlock).RespVBLTimestamp(iTrial)=RespVBLTimestamp;
%             trialOutput(iBlock).RespOnsetTime(iTrial)=RespOnsetTime;
%             trialOutput(iBlock).RespFlipTimestamp(iTrial)=RespFlipTimestamp;
%             trialOutput(iBlock).RespMissed(iTrial)=RespMissed;

            if accuracy==0
                %[CorrectionVBLTimestamp CorrectionOnsetTime CorrectionFlipTimestamp CorrectionMissed]
                trialOutput(iBlock).CorrectionVBLTimestamp(iTrial)=CorrectionVBLTimestamp;
                trialOutput(iBlock).CorrectionOnsetTime(iTrial)=CorrectionOnsetTime;
                trialOutput(iBlock).CorrectionFlipTimestamp(iTrial)=CorrectionFlipTimestamp;
                trialOutput(iBlock).CorrectionMissed(iTrial)=CorrectionMissed;
            else
                trialOutput(iBlock).CorrectionVBLTimestamp(iTrial)=NaN;
                trialOutput(iBlock).CorrectionOnsetTime(iTrial)=NaN;
                trialOutput(iBlock).CorrectionFlipTimestamp(iTrial)=NaN;
                trialOutput(iBlock).CorrectionMissed(iTrial)=NaN;
                trialOutput(iBlock).FeedbackVBLTimestamp(iTrial)=NaN;
                trialOutput(iBlock).FeedbackOnsetTime(iTrial)=NaN;
                trialOutput(iBlock).FeedbackFlipTimestamp(iTrial)=NaN;
                trialOutput(iBlock).FeedbackMissed(iTrial)=NaN;
            end
            
            %tell subject how they did on last trial
            if iTrial==exptdesign.numTrialsPerSession && iBlock < exptdesign.numSessions
                %calculate accuracy
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
    %record parameters for the block
    trialOutput(iBlock).order=stimOrder;
    trialOutput(iBlock).stimuli=word_pairs;
    trialOutput(iBlock).accuracyForBlock=accuracyForBlock;

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
