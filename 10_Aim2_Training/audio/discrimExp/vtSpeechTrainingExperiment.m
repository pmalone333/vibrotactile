%vibrotactile speech training. called by vtSpeechTraining.m
%PSM pmalone333@gmail.com

function vtSpeechTrainingExperiment(name, exptdesign)

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
    
    vcv_cfg %load vowel-consonant-vowel config file 
    load VTspeechStim.mat;
    
    % each block trains a phonetic feature
    % randomize order of blocks
    feature_block = {'voicing','manner','place'};
    feature_block = repmat(feature_block,1,exptdesign.numSessions/3);
    block_order = randperm(length(feature_block));
    feature_block = feature_block(block_order);
    

    for iBlock=1:exptdesign.numSessions %how many blocks to run this training session
        drawAndCenterText(w,['Training Block #' num2str(iBlock) ' of ' num2str(exptdesign.numSessions) '\n\n\n\n'...
            'Click the mouse to continue'],1);
        

        if strcmp(feature_block{iBlock},'voicing'), word_pairs = repmat(word_pairs_voicing,1,floor(exptdesign.numTrialsPerSession/length(word_pairs_voicing)));
        elseif strcmp(feature_block{iBlock},'manner'), word_pairs = repmat(word_pairs_manner,1,floor(exptdesign.numTrialsPerSession/length(word_pairs_manner)));
        elseif strcmp(feature_block{iBlock},'place'), word_pairs = repmat(word_pairs_place,1,floor(exptdesign.numTrialsPerSession/length(word_pairs_place)));
        end
        
        stimOrder = randperm(length(word_pairs));
        word_pairs = word_pairs(stimOrder);

        for iTrial=1:exptdesign.numTrialsPerSession
            
            %get start sample and num_samples for each word in pair
            r = randperm(2); %random permutation of 1 and 2 to randomize word presentation order
            word1 = word_pairs{iTrial}(r(1));
            word2 = word_pairs{iTrial}(r(2));
            word1_ind = find(strcmp(list_words, char(word1)));
            %r = randperm(2); %random permutation of 1 and 2 determines
            %which copy of word1 is selected from list_words % commented
            %out on 3/20/17. only using 1 token for training
            %word1_ind = word1_ind(r(1));
            word1_ind = word1_ind(1);
            %word2_ind = strcmp(list_words,char(word2));
            word2_ind = find(strcmp(list_words, char(word2)));
            %word2_ind = find(not(cellfun('isempty', word2_ind)));
            %r = randperm(2); %random permutation of 1 and 2 determines which copy of word2 is selected from list_words
            %word2_ind = word2_ind(r(1));
            word2_ind = word2_ind(1);
            
            %draw fixation
            Screen('DrawTexture', w, fixationTexture);
            [FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed] = Screen('Flip',w);
            r = randperm(2); %random permutation of 1 and 2 to randomize correct word
            if r(1) == 1
                correctWord = word1;
                correctResp = 1;
            else
                correctWord = word2;
                correctResp = 2;
            end
            [nx, ny, bbox] = DrawFormattedText(w, [correctWord{1}], 'center', 'center', 1);
            [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w);
            
            %drawAndCenterText(w, correctWord{1},0)
            %after 300-800 ms, present the 2 VT speech stimuli
            %wait1 = ll + (ul-ll).*rand(1);
            %WaitSecs(wait1);
            stimGenPTB('load',VTspeechStim{2,word1_ind},VTspeechStim{1,word1_ind});
            stimGenPTB('start');
            stimGenPTB('load',VTspeechStim{2,word2_ind},VTspeechStim{1,word2_ind});
            WaitSecs(1);
            stimGenPTB('start');


            %show the two arm images at a latency of .6+wait1 seconds
            %drawAndCenterText(w, ['Was ' correctWord{1} ' the first or second stimulus?\n'],0)
            
%             [nx, ny, bbox] = DrawFormattedText(w, ['Was ' correctWord{1} ' the first or second stimulus?\n'], 'center', 'center', 1);
%             [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w);
            responseStartTime=GetSecs;
            sResp = getResponseMouse(100);
            responseFinishedTime=GetSecs;

            %score the answer -- is sResp(iTrial)==correctResponse?
            if sResp==correctResp
                accuracy=1;
            else
                accuracy=0;
            end

            %feedback
            if accuracy==0
                drawAndCenterText(w, 'Incorrect.',1)
            else
                drawAndCenterText(w, 'Correct!',1)
            end
            
            %record parameters for the trial
            trialOutput(iBlock).responseStartTime(iTrial)=responseStartTime;
            trialOutput(iBlock).responseFinishedTime(iTrial)=responseFinishedTime;
            trialOutput(iBlock).RT(iTrial)=responseFinishedTime-responseStartTime;
            trialOutput(iBlock).sResp(iTrial)=sResp;
            trialOutput(iBlock).accuracy(iTrial)=accuracy;
            trialOutput(iBlock).correctResp(iTrial)=correctResp;

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
    trialOutput(iBlock).feature_block = feature_block{iBlock};
    trialOutput(iBlock).stimuli=word_pairs;
    trialOutput(iBlock).stimuliToken=[word1_ind word2_ind];
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
