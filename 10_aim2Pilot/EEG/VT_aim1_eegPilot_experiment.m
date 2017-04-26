% VT aim 1 eeg pilot experiment
% called by VT_eegPilot_wrapper.m
%
% PSM 8/2016 pmalone333@gmail.com

function trialOutput = VT_aim1_eegPilot_experiment(subjectName,exptdesign)

try
	Priority(1)
	
	%settings so that Psychtoolbox doesn't display annoying warnings--DON'T CHANGE
    oldLevel = Screen('Preference', 'VisualDebugLevel', 1);
  
%     oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', 1);
%     warning off
    HideCursor;

    WaitSecs(1); % make sure it is loaded into memory;
	
    % initialize the random number generator
	%rng('shuffle');
    %rng function above not available on MATLAB 2008 on WP-16 laptop
    rand('twister',sum(100*clock))

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	  INITIALIZE EXPERIMENT     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % open a screen and display instructions
    % Choosing the display with the highest display number is
    % a best guess about where you want the stimulus displayed.
    screens=Screen('Screens');
%     screenNumber=0;
    screenNumber=max(screens);

    % Open window with default settings:
    [w windowRect] =Screen('OpenWindow', screenNumber,[128 128 128]);
    white = WhiteIndex(w); % pixel value for white
    gray = GrayIndex(w); % pixel value for gray
    black = BlackIndex(w); % pixel value for black
    font='-misc-fixed-bold-r-normal--13-100-100-100-c-70-iso8859-1';       
    [o o1]=Screen(w, 'TextFont', font)
    
    %  calculate the center of the screen, for later reference
    center = [(windowRect(3)-windowRect(1))/2 (windowRect(4)-windowRect(2))/2];
    %  calculate the slack allowed during a flip interval   
    refresh = Screen('GetFlipInterval',w);
    slack = refresh/2;
    refresh        
    slack
    

    % Select specific text font, style and size, unless we're on Linux
    % where this combo is not available:
    if IsLinux==0
        Screen('TextFont',w, 'Courier New');
        Screen('TextSize',w, 14);
        Screen('TextStyle', w, 1+2);
    end;
    
    %% initializes the connection to netstation EEG setup
    if exptdesign.netstationPresent
        % Connect to Netstation 
        [status error] = NetStation('Connect', exptdesign.netstationIP)
        if status ==1 % there was an error!
             ME = MException('NETSTATION:CouldNotConnect', ['Could not connect to Netstation computer at IP ' exptdesign.netstationIP '.  Please check the IP and network connection and try again.\n  Error:' error]);
             throw(ME);
        end
    
    
       	% Tell Netstation to synchronize recording
        [status error] = NetStation('Synchronize',exptdesign.netstationSyncLimit);
        if status ==1 % there was an error!
             ME = MException('NETSTATION:CouldNotSync', ['Could not sync with Netstation to allowable limit of ' exptdesign.syncLimit '.  Please check the IP and connection and try again.\n  Error:' error]);
             throw(ME);
        end
    end
    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		INTRO EXPERIMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Now horizontally and vertically centered:
    drawAndCenterText(w,'Press any key to start experiment...');
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		SESSIONS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for iBlock=1:exptdesign.numSessions
       
        numTrials=exptdesign.numTrialsPerSession;
       
        tic;
        drawAndCenterText(w,'Setting up session, please wait...',0);
        
        load('aim1EEGstimuli.mat'); % load stimuli 
        
        % replicate stimuli to fill numTrials
        stimuli = repmat(stimuli,1,floor(numTrials/length(stimuli)));
        
        % randomize trial order
        permuteTrials = randperm(length(stimuli));
        stimuli = stimuli(:,permuteTrials);
        
        % fixation img
        fixationImage = imread(exptdesign.fixationImage);

        % blank img
        blankimage = imread(exptdesign.blankImage);
        size(blankimage)
        
        % category imgs for subject categorization response
        response1_img = imread(exptdesign.cat1label, 'png', 'BackgroundColor', [0.5 0.5 0.5]);
        response2_img = imread(exptdesign.cat2label, 'png', 'BackgroundColor', [0.5 0.5 0.5]);

        % inter-stimulus and inter-trial intervals, and range for number of
        % trials before subject response 
        itiDuration = exptdesign.itiDuration;
        noRespFreq  = exptdesign.noRespFreq;
        
        numNoResp = round(0 + rand(1)*(noRespFreq(2) - noRespFreq(1)));
        noRespCounter = 0; 
           
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %		TRIALS          %
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %  Set up the output data structure for all trials in this session
        trialOutput(iBlock).sessionNum = iBlock;

        disp('Finished setting up session :');
        toc;
        drawAndCenterText(w,'Finished setting up session (press key to begin)...');
        
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %       INSTRUCTIONS     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        if exptdesign.responseType==1
            drawAndCenterText(w,'INSTRUCTIONS: \n \n Push the left mouse button when the stimuli are the same. \n Push the right mouse button when the stimuli are different.  \n Push any key when you are ready to begin. ');
        else
            drawAndCenterText(w,'INSTRUCTIONS: \n \n Push the right mouse button when the stimuli are the same. \n Push the left mouse button when the stimuli are different.  \n Push any key when you are ready to begin. ');
        end
        
        
        %% Tell Netstation to start recording
        if exptdesign.netstationPresent
            [status error] = NetStation('StartRecording');
            if status ==1 % there was an error!
                status
                error
                 ME = MException('NETSTATION:CouldNotRecord', ['Could not tell Netstation to start recording.  Please check the IP and connection and try again.\n  Error:' error]);
                 throw(ME);
            end
            %  Wait for Netstation to Start Recording
            WaitSecs(2);
        end
        %%
        
        drawAndCenterText(w,'Please hold still for 5 seconds...',0);
        pause(5)
        drawAndCenterText(w,'Press a key to begin',1);
        
        for iTrial=1:numTrials
            
            if numNoResp == noRespCounter % trial requiring subject response occured last trial 
                numNoResp = round(0 + rand(1)*(noRespFreq(2) - noRespFreq(1)));
                noRespCounter = 0; 
            else
                noRespCounter = noRespCounter + 1;
            end
            
            % make textures for this trial
            fixationTexture=Screen('MakeTexture', w, double(fixationImage));
            response1Texture=Screen('MakeTexture', w, double(response1_img));
            response2Texture=Screen('MakeTexture', w, double(response2_img));
            
            Screen('DrawTexture', w, fixationTexture);
            Screen('FillRect',w,black,[0 0 32 32]);  % This is the stimulus marker block for the photodiode
            [stimulusVBLTimestamp, stimulusOnsetTime, stimulusFlipTimestamp, stimulusMissed] = Screen('Flip',w);
            % deliver first VT stim
            constructCategoryTrainingStimulus(stimuli(:,iTrial));
            
            responseStartTime = 0; responseFinishedTime = 0;
            RespVBLTimestamp = 0; RespOnsetTime= 0; RespFlipTimestamp= 0; RespMissed = 0; % default to 0 if no subject response on this trial
            sResp = -1; % default to -1 if no subject response on this trial
            if noRespCounter == numNoResp
                if mod(iBlock,2) % left-> right switch labels each block
                    Screen('DrawTexture', w, response1Texture);
                else
                    Screen('DrawTexture', w, response2Texture);
                end
                [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w);
                responseStartTime = GetSecs;
                if exptdesign.waitForResponse
                    sResp = getAnimalResponseMouseWait();
                else
                    sResp = getAnimalResponseMouse(exptdesign.responseDuration);
                end
                responseFinishedTime = GetSecs;
            end
            
            
            % inter trial interval duration 1-2 seconds
            wait_ITI = (ceil(itiDuration(1)* rand(1)) + (itiDuration(2)-itiDuration(1))) / 1000;
            
            % save trial data
            trialOutput(iBlock).stimulusVBLTimestamp(iTrial)    = stimulusVBLTimestamp;
            trialOutput(iBlock).stimulusOnsetTime(iTrial)       = stimulusOnsetTime;
            trialOutput(iBlock).stimulusFlipTimestamp(iTrial)   = stimulusFlipTimestamp;
            trialOutput(iBlock).stimulusMissed(iTrial)          = stimulusMissed;
            trialOutput(iBlock).RespVBLTimestamp(iTrial)        = RespVBLTimestamp;
            trialOutput(iBlock).RespOnsetTime(iTrial)           = RespOnsetTime;
            trialOutput(iBlock).RespFlipTimestamp(iTrial)       = RespFlipTimestamp;
            trialOutput(iBlock).RespMissed(iTrial)              = RespMissed;
            trialOutput(iBlock).ITI_duration(iTrial)            = wait_ITI;
            trialOutput(iBlock).responseFinishedTime(iTrial)    = responseFinishedTime;
            trialOutput(iBlock).responseStartTime(iTrial)       = responseStartTime;
            trialOutput(iBlock).responseFinishedTime(iTrial)    = responseFinishedTime;
            trialOutput(iBlock).RT(iTrial)                      = responseFinishedTime-responseStartTime;
            trialOutput(iBlock).sResp(iTrial)                   = sResp;
            
            WaitSecs(wait_ITI);

                        
            %% Send trial specific events to Netstation for recording (if present)
            if exptdesign.netstationPresent
                trialDuration = trialOutput(sessionNum).trials(trial).trialStartTime - trialOutput(sessionNum).trials(trial).trialEndTime;
                if  trialOutput(sessionNum).trials(trial).correctResponse == 1
%                     Netstation('Event','STIM',trialOutput(sessionNum).trials(trial).trialStartTime,0.001,'sess',num2str(sessionNum), 'tria',num2str(trial),'soad',num2str(soaDuration));
                    NetStation('Event','SAME',GetSecs,0.001,'sess',sessionNum, 'tria',trial,'cond',conditionThisBlock(trial), 'resp', numericalanswer, 'line', lineThisBlock(trial));
                else
                    NetStation('Event','DIFF',GetSecs,0.001,'sess',sessionNum, 'tria',trial,'cond',conditionThisBlock(trial), 'resp', numericalanswer, 'line', lineThisBlock(trial));
                end
            end
%%
                
            %  Close all open textures
            Screen('Close', fixationTexture);     
            
            if mod(iTrial, 49)==0
                drawAndCenterText(w, 'Please take a quick blink break, press any key to continue.',1);
            end
        
                
        end
        
        % save session data
        trialOutput(iBlock).stimuli = stimuli;
        
        drawAndCenterText(w,'Please hold still for 5 seconds...',0);
        pause(5)
        
        %% stop netstation run
        if exptdesign.netstationPresent
            %  Tell Netstation to Stop Recording
            [status error] = NetStation('StopRecording');
            if status ==1 % there was an error!
                status 
                error
                 ME = MException('NETSTATION:CouldNotStopRecording', ['Could not tell Netstation to stop recording.  Please check the IP and connection and try again.\n  Error:' error]);
                 throw(ME);
            end
        end
        %%
        
        %  Write the trial specific data to the output file.
        tic;
        save(['sub' subjectName '_block' num2str(iBlock).mat'],'trialOutput','exptdesign');
        toc;
        %  Display a short break message
%         acc=sum(ACCthisblock)./length(ACCthisblock);
%         if ( sessionNum < exptdesign.numSessions)
%             drawAndCenterText(w,['End of Block #' num2str(sessionNum) '.\n\n You got ' num2str(acc.*100) '% correct. \n\n Please take a short break.\n  Then press any key to continue.']);
%         else
%             drawAndCenterText(w,['End of Block #' num2str(sessionNum) '.\n\n Thank you for participating!\n  Press any key to end the experiment.']);
%         end
    
        
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % End of demo, close window:
    Screen('CloseAll');
    Priority(0);
    % At the end of your code, it is a good idea to restore the old level.
%     Screen('Preference','SuppressAllWarnings',oldEnableFlag);
    
    
catch
    % This "catch" section executes in case of an error in the "try"
    % section []
     if exptdesign.netstationPresent
        % Tell Netstation to stop recording
        [status error] = NetStation('StopRecording');
        if status ==1 % there was an error!
            status 
            error
             ME = MException('NETSTATION:CouldNotStopRecord', ['Could not tell Netstation to stop recording.  Please check the IP and connection and try again.\n  Error:' error]);
%              throw(ME);
            disp('ERROR stopping recoring in Netstation!');
        end
        
        [status error] = NetStation('Disconnect');
        if status ==1 % there was an error!
            status 
            error
             ME = MException('NETSTATION:CouldNotStopRecord', ['Could not tell Netstation to stop recording.  Please check the IP and connection and try again.\n  Error:' error]);
%              throw(ME);
            disp('ERROR disconnecting from Netstation!');

        end
    end

    % above.  Importantly, it closes the onscreen window if it's open.
    disp('Caught error and closing experiment nicely....');
    Screen('CloseAll');
    Priority(0);
    fclose('all');
    psychrethrow(psychlasterror);
end		
	
			
end


%% Subfunctions

function drawAndCenterText(window,message,wait)
    if nargin < 3
        wait = 1;
    end
    
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 0);
    black = BlackIndex(window); % pixel value for black    
    Screen('FillRect',window,black,[0 0 32 32]);  % This is the stimulus marker block for the photodiode                
    Screen('Flip',window);
%     KbWait;
%     while KbCheck; end;
    if wait
        KbPressWait
    end
end

function numericalanswer = getAnimalResponseMouseWait()
       [x,y,buttons] = GetMouse();
       while (~any(buttons))
           [x,y,buttons] = GetMouse();
       end

       if buttons(1)
           numericalanswer = 1;
       elseif buttons(3)
           numericalanswer = 2;
       else
           numericalanswer = 0;
       end
end

function numericalanswer = getAnimalResponseMouse(waitTime)

  %Wait for a response
  numericalanswer = -1;
  mousePressed = 0;
  startWaiting=GetSecs;
  while GetSecs-startWaiting < waitTime && mousePressed == 0
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