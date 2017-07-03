%
% VT aim 2 EEG pilot task for use at GW - ctl file
% NSF130201 - experiment for CV EEG testing with training
%
% PSM 8/2016
%
function rslt = VT_eegPilot_GW(subjID, session, controlFile, comment)
    global win;     % get info on screen to play video on
    global winscr;

    rslt = 'err: unspecified'; % assume bad

try
    eval(controlFile);
catch
    fprintf('Error parsing control file\n');
    rslt = 'err: "VT aim 2 eeg pilot parameter file parse';
    return;
end


% give instructions
if numel(instructs) > 10
    displayInstructions(instructs, [800,0,700,600], 11);
end


try % rest of setup    
    % start main screen if it does not exist
    if numel(win) == 0 || win == -1
        if numel(winscr) == 0
            winscr = max(Screen('Screens'));
        end
        Screen('Preference', 'VisualDebugLevel', 3);
        Screen('Preference', 'SuppressAllWarnings', 1);
        Screen('Preference', 'TextAlphaBlending', 1);
%        Screen('Blendfunction', ...)
        rect = [800,0,1600,600];
        [win, ~] = Screen(winscr,'OpenWindow',BlackIndex(winscr),rect,32);
        HideCursor;
    end

    % initialize PIC and response collection/timing system
    pic('Open');
    pic('ResetTimer');  % dummy first command, clears buffer
    fprintf('set up PIC system\n');
    
    % open response file for appending
    str = strcat('../results/',subjID,'.rsp');            
    outfile = fopen(str, 'a');
    if(outfile < 1)
       errlog(['Can''t open response file ',str]);
       fprintf(['Can''t open response file ',str]);
       rslt = 'err: can''t open response file';
       return;
    end
    fprintf('opened response file\n');
    
    % put info in response file
    line = ['$start ',datestr(now,30),13,10,...
        '$experiment VT_aim2_eegPilot',13,10,...
        '$controlfile ',controlFile,13,10,...
        '$subjectID ',subjID,13,10,...
        '$dataElements session,trial,stimType,stimulus,response,respTime',13,10];
    fwrite(outfile, line);
    
    % add comment to file, if specified
    if exist('comment','var') == 1
        fwrite(outfile, [comment,13,10]);
    end
    fprintf('appended response file\n');  
    
catch 
    fprintf('error setting up files for experiment\n');
    rslt = 'err: setup';
    return;   
end

    numStim = 0;    % keep track of which stim output we are in
    % take break after this many tokens
    take_break = break_stim_tokens;
    ntokens = numel(token_index);
    nrtoken = 0;
    tic();
    % also, set up for occasional response!
    if noRespStim == 1
        % go through main loop only for RESPONSE category, stay in
        % small loop for non-response category
        nrblock = 0;
        nrstim = 0;
        nrnumStim = numel(token_index_noresp);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % setup list of all experiment blocks to do
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('starting VT aim 2 eeg pilot, session=%s, subj=%s\n',session, subjID);
    
    % print instructions and get response
    Screen('FillRect',win,[0 0 0]);
    Screen('Flip',win,0,1);
    Screen('TextSize', win, stringFontSize);
    Screen('DrawText',win,startString,50, stringLocY,[255 255 255]);
    Screen('Flip',win,0,1);
    if get_button_resp == 1
        while pic() ~= 0
        end
        pic('ArmIRQchannel',0, 19, 0, 0);  % arm button
        while pic() == 0;
        end
    else
        getreturn();
    end
    Screen('FillRect',win,[0 0 0]);
    if display_cross == 1
        Screen('DrawText',win,'+',400, 300,[255 255 255]);
    end

    Screen('Flip',win,0,1);
    
    % calculate total tokens output
    stimTot = num_blocks * ntokens;
    
    % if also have no-resp stim, add those
    if noRespStim == 1
        nrnumstim = numel(token_index);
        avg = (noRespFreq(2) - noRespFreq(1) + 1)/2;
        % add in estimate of the extra no-response tokens
        stimTot = stimTot + (avg * num_blocks * ntokens);
    end
    
    % start ISI randomizer
    getISI(ISI,4);
    
    ListenChar(2); % don't pass keypresses to console
    
    for block = 1:num_blocks
        fprintf('\nExecuting block %d/%d (presentation number %d)....',block,num_blocks,numStim+1);
        % rerandomize tokens
        tokenOrder = ChooseKFromN(ntokens,ntokens,0);
        for token = 1:ntokens
            numStim = numStim + 1;
            % get small index for this token
            idx = tokenOrder(token);
            
            % get index of token in sound and video
            stimIDX = token_index(tokenOrder(token));
            
            % time to play bell?
%             if bell_stimNum ~= 0
%                 if bell_stimNum <= numStim
%                     % set stimID early to give time for serial download
%                     % NOTE: audio trigger should reset timer, but no packet
%                     pic('ArmCCPchannel', 0, 34, bell_stimID, 0);                     
%                     % also do timing for response time collection
%                     pic('ArmIRQchannel',0, 19, 0, 0);  % arm button
%                     
%                     % update next bell output
%                     bell_stimNum = bell_stimNum + round(bell_frequency(1)...
%                             + rand(1)*(bell_frequency(2)-bell_frequency(1)));
%                     
%                     % create audio buffer and play                    
%                     startFrame = bell_start_frame;
%                     numFrames = bell_duration;
% try
%                     awave = wavedata(1:2, startFrame:startFrame+numFrames);
%                     PsychPortAudio('FillBuffer', soundhandle, awave);
%                     % play token, wait for finish
%                     PsychPortAudio('Start', soundhandle);
%                     
%                     % get response, so we can abort bell sound
%                     % process PIC responses
%                     % now wait for responses, register it
%                     responseTime = 0;
%                     tic();
% %                    response = -1;
%                     if debug_mode == 0
%                         while respTimeout == 0 || toc() < respTimeout
%                             pr = pic();
%                             % process returned packet
%                             if numel(pr) > 1
%                                 if pr(1) == 16; % IRQ
%                                     % get response time in ms, and response
%                                     responseTime = double(pr(3))/1250.0;
% %                                    response = pr(2);
%                                     PsychPortAudio('Stop', soundhandle);
%                                     break;
%                                 else
%                                     fprintf('Unexpected packet from pic(), type %d\n',pr3(1));
%                                 end                
%                             end
%                         end 
%                     end                    
% %                     while(1)
% %                         s = PsychPortAudio('GetStatus', soundhandle);
% %                         if s.Active == 0
% %                             break;
% %                         end
% %                     end
%                     
% catch
%                     fprintf('problem creating sound buffer or playing bell sound\n');
%                     fclose(outfile);
%                     Screen('CloseAll');
%                     win = -1;
%                     PsychPortAudio('Close', soundhandle);   
%                     ListenChar(0);
%                     return;
% end                    
% 
%                     % write results to output file
%                     fprintf(outfile, '%s, %d, 0, 0, 0, %3.3f',...
%                         session,numStim,responseTime/1000.0);                     
%                     fwrite(outfile, [13,10]);
%                     
%                     % wait a little for things to settle before starting
%                     WaitSecs(1.0);
%                     
%                 end
%             end
            
            % do no-response stimuli here, as many as specified-
            % can be many more than response stimuli!
            if noRespStim == 1
                nrnumstim = numel(token_index);
                % how many this time around?
                numNoResp = round(noRespFreq(1) + rand(1)*(noRespFreq(2) - noRespFreq(1)));
                for i=1:numNoResp
                    % set up for next block?
                    if nrtoken == 0 || nrtoken > nrnumstim
                        nrblock = nrblock + 1;
                        nrTokenOrder = ChooseKFromN(nrnumStim,nrnumStim,0);
                        nrtoken = 1; % index into nrTokenOrder
                    end
                
                    % check for break here
                    if take_break <= numStim
                        take_break = take_break + break_stim_tokens;
                        str = strcat(restString,' (',num2str(numStim*100/stimTot,3),'% done)');
                        Screen('FillRect',win,[0 0 0]);
                        Screen('Flip',win,0,1);
                        Screen('DrawText',win,str,50, stringLocY,[255 255 255]);
                        Screen('Flip',win,0,1);
                        fprintf('\nresting (%d/%d)....',numStim,stimTot);
                        getreturn();
                     
                        % resume with black screen
                        Screen('FillRect',win,[0 0 0]);
                        if display_cross == 1
                            Screen('DrawText',win,'+',400, 300,[255 255 255]);
                        end
                        Screen('Flip',win,0,1);
                        WaitSecs(restEndSecs);
                    end                    
                    
                    numStim = numStim + 1;

                    % index into our (small) list
                    smallidx = nrTokenOrder(nrtoken);
                    
                    % index into big arrays (frames, etc)
                    nrstimIDX = token_index(smallidx);
                    
                    % set stimID early to give time for serial download
                    % NOTE: audio trigger should reset timer, but no packet
                    try
                    pic('ArmCCPchannel', 0, 34, stimIDnoresp(smallidx), 0);                     
                    catch
                        jj = 1;
                    end
                    
                    % update to get next token next iteration through loop
                    nrtoken = nrtoken + 1;
                    
                    % do ISI here in order to give stimID(s) time to download
                    ms = getISI();
                    WaitSecs(ms/1000.0);
                    % create audio buffer 
                    if sync_audio == 0  % use table to determine audio
                        startSample = audioStartSamples(nrstimIDX);
                        numSamples = audioNumSamples(nrstimIDX);
                    else % calculate audio frames from video frames
                        startSample = video_startFrames(nrstimIDX) * freq / 30;%1470;
                        numSamples = video_numFrames(nrstimIDX) * freq / 30;%1470;                
                    end
                    
                    awave = wavedata(1:2, startSample:startSample+numSamples);
                    PsychPortAudio('FillBuffer', soundhandle, awave);
                    % play sound and wait for completion
                    PsychPortAudio('Start', soundhandle);
fprintf('%c @ %f, ISI %d (%d,%d)\n',responsePromptString(smallidx),toc(),ms,startSample,numSamples);
                    WaitSecs(0.5); % wait for audio to start
                    while true
                        s = PsychPortAudio('GetStatus', soundhandle);
                        if s.Active == 0
                            break;
%                        else
%fprintf('.');                            
                        end
                    end                    
                end
            end
            
            % also check whether a break is called for
            if take_break <= numStim
                take_break = take_break + break_stim_tokens;
                str = strcat(restString,' (',num2str(100*numStim/stimTot,3),'% done)');
                Screen('FillRect',win,[0 0 0]);
                Screen('Flip',win,0,1);
                Screen('DrawText',win,str,50, stringLocY,[255 255 255]);
                Screen('Flip',win,0,1);
                fprintf('\nresting (%d/%d)....',numStim,stimTot);
                getreturn();
                % resume with black screen
                Screen('FillRect',win,[0 0 0]);
                Screen('Flip',win,0,1);
                WaitSecs(restEndSecs);
            end
            
            % do ISI here in order to give stimID(s) time to download
            WaitSecs(getISI()/1000.0);            
            
            % set stimID early to give time for serial download
            % NOTE: audio trigger should reset timer, but no packet
            pic('ArmCCPchannel', 0, 34, stimIDs(idx), 0);                     

            % do black frames here if so specified
            if blackFramesBetweenTokens ~= 0
               Screen('FillRect',win,[0 0 0]);
               if display_cross == 1
                   Screen('DrawText',win,'+',400, 300,[255 255 255]);
               end

               for i=1:blackFramesBetweenTokens
                    Screen('Flip',win,0,1);
               end
            end
            
            % do ISI here in order to give stimID(s) time to download
            %WaitSecs(getISI()/1000.0);
            
            % create audio buffer 
            if sync_audio == 0  % use table to determine audio
                startSample = audioStartSamples(stimIDX);
                numSamples = audioNumSamples(stimIDX);
            else % calculate audio frames from video frames
                startSample = video_startFrames(stimIDX) * freq / 30;%1470;
                numSamples = video_numFrames(stimIDX) * freq / 30;%1470;                
            end
try
            awave = wavedata(1:2, startSample:startSample+numSamples);
            PsychPortAudio('FillBuffer', soundhandle, awave);
catch
            fprintf('problem creating sound buffer or playing sound\n');
            fclose(outfile);
            Screen('CloseAll');
            win = -1;
            PsychPortAudio('Close', soundhandle);   
            ListenChar(0);
            return;
end                    
            
            % set up first frame in case needed for video or freeze frame
            vid_start = video_startFrames(stimIDX);
            
            % no video, just use audio
            if use_video == 0
                
                % set up video freeze frame if desired
                if use_video_freeze_frame == 1
                    Screen('SetMovieTimeIndex', movie, vid_start, 1);
                    itex = Screen('GetMovieImage', win, movie);
                    Screen('DrawTexture', win, itex);
                    Screen('DrawText',win,responsePromptString,stringLocX, stringLocY,[255 255 255],[0 0 0]);
                    Screen('Flip', win, 0,1);     
                    Screen('Close', itex);
                end
               
                % play token, wait for finish
                PsychPortAudio('Start', soundhandle);
                WaitSecs(0.5); % give time to start
                while true
                    s = PsychPortAudio('GetStatus', soundhandle);
                    if s.Active == 0
                        break;
                    end
                end
                
            else % play movie
                AV(movie,soundhandle,vid_start,...
                    video_numFrames(stimIDX)-1,freeze_init,freeze_final,responsePromptString,[255 255 255],stringLocX,stringLocY);
            end
            
            % do post wait first
            delay_ms = post_wait(1) + rand(1)*(post_wait(2) - post_wait(1));
            WaitSecs(delay_ms/1000.0);

            % now draw response prompt, if any
%             if numel(responsePromptString) > 0
%                 Screen('TextSize', win, stringFontSize);
%                 Screen('DrawText',win,responsePromptString,50, 100,[255 255 255]);
%                 Screen('Flip', win, 0,1); 
%             end
try            
            stim = tokenChars(tokenOrder(token));
catch
    debug = 1;
end
            % GET A RESPONSE, and process response time? 
            if getRespTime == 1
                responseTime = 0;
                resp = '0';   % in case of timeout
                
                % set up for feedback stimID here, if feedback will be
                % given
                if give_feedback == 1
                    pic('ArmCCPchannel', 0, 34, stimIDsRepeat(tokenOrder(token)), 0);                     
                end
                
                if getResponsePrompt ~= 0
                    Screen('DrawText',win,getResponsePrompt,stringLocX, stringLocY,[255 255 255],[0 0 0]);
                    Screen('Flip', win, 0,1);   
                    if exist('itex','var')
                        Screen('Close', itex);
                    end
                end
                
                if get_keyboard_resp == 1
                    [resp, responseTime] = getKey(allowedKeys, 1000);
                    
                elseif get_button_resp == 1
                    tic(); % for timeout
                    % is it pic response?
                    while toc() < 20.0
                        if get_button_resp == 1
                            pr = pic();
                            if pr ~= 0
                                % extract response time
                                responseTime = double(pr(3))/1250.0;
                                break;
                            end
                        end
                    end
                end
                
                if getResponsePrompt ~= 0
                    % erase prompt
                    Screen('FillRect',win,[0 0 0]);
                    if display_cross == 1
                        Screen('DrawText',win,'+',400, 300,[255 255 255]);
                    end
                    Screen('Flip',win,0,1);     
                end
                
                % figure out type: 1=trained, 2=untrained
                type = 1;
                if token > trained_tokens
                    type = 2;
                end

                if resp == '0'
                    fprintf('response timeout!\n');
                end
                
                % write results to output file, skip if there was no
                % response
                fprintf(outfile, '%s, %d, %d, %s, %s, %3.3f',...
                    session,numStim,type,stim,resp,responseTime/1000.00);                     
                fwrite(outfile, [13,10]);                 
            end
            
            % blank screen
  %          Screen('FillRect',win,[0 0 0]);
  %          Screen('Flip',win,0,1);
            
            % do feedback?
            if give_feedback == 1   % assume key was pressed
                % wipe old text
  %              Screen('DrawText',win,'',50, 100,[0 0 0]);
                
                % was key correct?
                if resp == stim
                    str = [FBcorrect,tokenChars(tokenOrder(token)),'                     '];
                    color = [0 255 0];
                else
                    str = [FBincorrect,tokenChars(tokenOrder(token)),'                   '];
                    color = [255 0 0];
                end
                Screen('DrawText',win,str,stringLocX, stringLocY,color,[0 0 0]);
                Screen('Flip',win,0,1);
                %WaitSecs(2);
                
                % play it again
                % no video, just use audio
                if use_video == 0
                    % play token again, wait for finish
                    PsychPortAudio('Start', soundhandle);
                    while(1)
                        s = PsychPortAudio('GetStatus', soundhandle);
                        if s.Active == 0
                            break;
                        end
                    end
                else  % AV  
                    
                    AV(movie,soundhandle,video_startFrames(stimIDX),...
                        video_numFrames(stimIDX)-1,freeze_init,freeze_final,str,color,stringLocX,stringLocY);
                end
            end
        end % tokens
    end % blocks

    % end of experiment string
    Screen('FillRect',win,[0 0 0]);
    Screen('Flip',win,0,1);

    Screen('DrawText',win,doneString,50, stringLocY,[255 255 255]);
    notifyAlarm(3,1);
    Screen('Flip',win,0,1);
    WaitSecs(10);
    
    % final line
    line = ['$end ',datestr(now,30),13,10];
    fwrite(outfile, line);
    
    % shutdown
    fprintf('NSF130201 completed successfully\n');
    fclose(outfile);
    Screen('CloseAll');
    win = -1;
    PsychPortAudio('Close', soundhandle);   
    ListenChar(0); % listen again
    rslt = 'success';
end %function

% play the AV snippet- note that audio already set up to go
function flip_missed = AV(movie,sndhandle,vid_start,num_frames,freeze1,freeze2,text,color,x,y)
global win;

    % start showing first frame as soon as possible
    Screen('SetMovieTimeIndex', movie, vid_start, 1);
    itex = Screen('GetMovieImage', win, movie);
    Screen('DrawTexture', win, itex);
    Screen('DrawText',win,text,x, y,color,[0 0 0]);    
    Screen('Flip', win, 0,1);

    nmaxpriority = MaxPriority(win);    
    flip_missed = 0;
   
    % now start play process.... movie already running
    Priority(nmaxpriority); 

    % sync to retrace
    for i=1:freeze1
        Screen('Flip', win, 0, 1);
        Screen('Flip', win, 0, 1);
    end
    % start audio here! 
    PsychPortAudio('Start', sndhandle, 1,0,1);

    % Catch glitch and restart audio if necessary
    Screen('Flip', win, 0,1);

    % now make sure that video start also successful
    Screen('SetMovieTimeIndex', movie, vid_start, 1); 
    Screen('Flip', win, 0,1);

    % now close original texture and draw second frame again
    Screen('Close', itex); 

    % Playback, outputting two frames per movie sample 
    % since monitor refresh rate is 60 Hz
    itex = Screen('GetMovieImage', win, movie);
    for frames = 1:num_frames
        Screen('DrawTexture', win, itex);
        Screen('DrawText',win,text,x, y,color,[0 0 0]);    
        [~, ~, ~, missed] = Screen('Flip', win,0,1);
        if missed >= 0
            flip_missed = flip_missed + 1;
        end
%        Screen('DrawTexture', win, itex);
%        Screen('DrawText',win,text,50, 100,color,[0 0 0]);    
        [~, ~, ~, missed] = Screen('Flip', win,0,1);
        if missed >= 0
            flip_missed = flip_missed + 1;
        end
        Screen('Close', itex);
        itex = Screen('GetMovieImage', win, movie);
    end

    % final freeze frames
    Screen('DrawTexture', win, itex);
    Screen('DrawText',win,text,x, y,color,[0 0 0]);    
    for i=1:freeze2
        Screen('Flip',win,0,1);
    end
    Screen('Close', itex);
    Priority(0);        
end



