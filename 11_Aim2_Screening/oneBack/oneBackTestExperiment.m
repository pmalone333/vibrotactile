
function trialOutput = oneBackTestExperiment(name,exptdesign)
%dbstop if error;
try
%     dbstop if error;
    KbName('UnifyKeyNames');
    Priority(1)

    %settings so that Psychtoolbox doesn't display annoying warnings--DON'T CHANGE
    oldLevel = Screen('Preference', 'VisualDebugLevel', 1);
    if ~exptdesign.debug
        HideCursor;
    end

    WaitSecs(1); % make sure it is loaded into memory;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		INITIALIZE EXPERIMENT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % open a screen and display instructions
    screens = Screen('Screens');
    screenNumber = min(screens);

    % Open window with default settings:
    if exptdesign.debug
        [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128], [0 0 800 800]); %for debugging
    else
        [w windowRect] = Screen('OpenWindow', screenNumber,[128 128 128]);
    end

    % Select specific text font, style and size, unless we're on Linux
    % where this combo is not available:
    if IsLinux==0
        Screen('TextFont',w, 'Courier New');
        Screen('TextSize',w, 14);
        Screen('TextStyle', w, 1+2);
    end;
    
    % Load fixation image from file
    fixationImage = imread(exptdesign.fixationImage);

    % generate fixation texture from image
    fixationTexture = Screen('MakeTexture', w, double(fixationImage));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		INTRO EXPERIMENT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if exptdesign.responseBox
        %flush event queue
        evt=1;
        
        %%while there is no event continue to flush queue
        while ~isempty(evt)
            evt = CMUBox('GetEvent', exptdesign.boxHandle); %empty queue 
        end
        
        % Get the responses keyed in from subject
        drawAndCenterText(w,'Please press the button.',0);
        evt = CMUBox('GetEvent', exptdesign.boxHandle, 1); % get event for button pressed
        responseMapping.button1 = evt.state; % stores button box in variable
      
        % Let the scanner signal the scan to start
        drawAndCenterText(w,'Please get ready.\n\nThe experiment will begin shortly.',0);
        % WARNING: TRRIGGER CORRESPONDS TO A PRESS OF BUTTON 3!!!
        triggername=4; %4 == button press on box 3
        trigger=0; %set equal to a different value 
        
        %while loop that continues to iterate until trigger is pressed at
        %which point triggername == trigger
        while ~isequal(triggername,trigger)
            evt       = CMUBox('GetEvent', exptdesign.boxHandle, 1);
            trigger   = evt.state;
            starttime = evt.time;
        end
        
        %store start time and response mapping in exptdesign struct
        exptdesign.scanStart       = starttime;
        exptdesign.responseMapping = responseMapping;
    else
        %checks for in between runs so that experminter can control run
        %start
        %responseMapping = exptdesign.responseKeyChange;
        drawAndCenterText(w,'Hit Enter to Continue...',1);
        exptdesign.scanStart = GetSecs;
    end
    
    %marks the number of runs passed in from exptdesign struct
    runCounter           = exptdesign.iRuns;
    numBlocks            = exptdesign.numBlocks;
    numTrialsPerSession  = exptdesign.numTrialsPerSession;
    stimulusPresentation = exptdesign.stimulusPresentation;

    %Display experiment instructions
    drawAndCenterText(w,['\nInstructions: press y if the 2 vibrations you feel are the same, n if they are different \n'],1)
    WaitSecs(3)
   
    %passes in response profile from wrapper function
    response = exptdesign.response;

 
        blockStart = GetSecs;
        stimOrder = {{'aza1','aba1'},{'apa1','apa1'},{'ava2','asa1'},{'ada1','afa1'},{'aga2','aga2'},{'afa1','aga1'} ...
            {'ana1','ada2'},{'ada1','aga1'},{'aga2','aza1'},{'ada1','afa1'},{'aga2','aga2'},{'aza1','ava2'} ...
            {'apa2','ata1'},{'aba1','asa2'},{'asa2','ava1'},{'ama1','ama1'},{'aga2','ama1'},{'afa1','ava1'} ...
            {'aba1','aza2'},{'aza1','aza1'},{'ata2','afa1'},{'aka1','afa1'},{'ada1','aba2'},{'afa1','aga1'} ...
            {'aka1','aka1'},{'ava2','asa1'},{'ava2','asa1'},{'ada2','afa2'},{'aga2','aga2'},{'ama2','apa1'} ...
            {'aza1','aba1'},{'apa1','apa1'},{'ava2','asa1'},{'ada1','afa1'},{'aga2','aga2'},{'afa1','aga1'} ...
            {'ana1','ada2'},{'ada1','aga1'},{'aga2','aza1'},{'ada1','afa1'},{'aga2','aga2'},{'aza1','ava2'} ...
            {'apa2','ata1'},{'aba1','asa2'},{'asa2','ava1'},{'ama1','ama1'},{'aga2','ama1'},{'afa1','ava1'} ...
            {'aba1','aza2'},{'aza1','aza1'},{'ata2','afa1'},{'aka1','afa1'},{'ada1','aba2'},{'afa1','aga1'} ...
            {'aka1','aka1'},{'ava2','asa1'},{'ava2','asa1'},{'ada2','afa2'},{'aga2','aga2'},{'ama2','apa1'}};
        accuracy = zeros(length(stimOrder),1);
        order = randperm(length(stimOrder));
        stimOrder = stimOrder(order);




        for i=1:length(stimOrder)
            
            %draw fixation
            Screen('DrawTexture', w, fixationTexture);
            [FixationVBLTimestamp FixationOnsetTime FixationFlipTimestamp FixationMissed] = Screen('Flip',w);

            load([stimOrder{i}{1} '.mat']);
            tm = tactStim{1}{1};
            tm = tm/4; % changed because of a slower sampling rate on new pulseCapture software
            ch = tactStim{1}{2};
            ch = remapChanVoc(ch); % mapping function from Silvio

            stimGenPTB('load',ch,tm);
            stimGenPTB('start');
            load([stimOrder{i}{2} '.mat']);
            tm = tactStim{1}{1};
            tm = tm/4; % changed because of a slower sampling rate on new pulseCapture software
            ch = tactStim{1}{2};
            ch = remapChanVoc(ch); % mapping function from Silvio
            stimGenPTB('load',ch,tm);
            WaitSecs(1);
            stimGenPTB('start')

            [nx, ny, bbox] = DrawFormattedText(w, ['Were the vibrations the same?'], 'center', 'center', 1);
            [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w);
            while 1
                % Check the state of the keyboard.
                [ keyIsDown, seconds, keyCode ] = KbCheck;
                if keyIsDown
                    sResp = KbName(keyCode);
                    break
                    while KbCheck; end
                end
            end

            if strcmp(stimOrder{i}{1},stimOrder{i}{2}) && (strcmp(sResp,'y'))
                accuracy(i) = 1;
            elseif ~strcmp(stimOrder{i}{1},stimOrder{i}{2}) && (strcmp(sResp,'n'))
                accuracy(i) = 1;
            end
            WaitSecs(1)
        end

           

        
%         %collect event queue
%         eventCount=0;
%         evt = CMUBox('GetEvent', exptdesign.boxHandle);
        
%         while ~isempty(evt)
%             eventCount = eventCount + 1;
%             %sResp ==1 if button pressed
%             sResp(eventCount) = 1;
%             %record end time of response
%             responseFinishedTime(eventCount)=evt.time;
%             
%             %load next event in the queue
%             evt = CMUBox('GetEvent', exptdesign.boxHandle);
%         end


        
        trialOutput.stimuli                 = stimOrder;
        trialOutput.accuracy              = accuracy;
    
     
    ShowCursor;
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %		END
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %save the session data in the data directory
    save([exptdesign.saveDir '/' name '.run' num2str(exptdesign.iRuns) '.mat'], 'trialOutput', 'exptdesign');
    
    % End of experiment, close window:
    Screen('CloseAll');
    Priority(0);
    % At the end of your code, it is a good idea to restore the old level.
    %     Screen('Preference','SuppressAllWarnings',oldEnableFlag);
    
    catch
    % This "catch" section executes in case of an error in the "try"
    % section []
    if exptdesign.responseBox
        CMUBox('Close',exptdesign.boxHandle);
    end
    
    % above.  Importantly, it closes the onscreen window if it's open.
    disp('Caught error and closing experiment nicely....');
    Screen('CloseAll');
    Priority(0);
    fclose('all');
    psychrethrow(psychlasterror);

end
end

function drawAndCenterText(window,message,wait, time)
    if nargin < 3
        wait = 1;
    end
    
    if nargin <4
        time =0;
    end
    
    % Now horizontally and vertically centered:
    [nx, ny, bbox] = DrawFormattedText(window, message, 'center', 'center', 0);
    black = BlackIndex(window); % pixel value for black               
    Screen('Flip',window, time);
%     if wait, KbWait(); end
end

function [loadTime] = loadStimuli(stimuliBlock, iTrial)
    
tm = stimuliBlock{1,iTrial}{1};
ch = stimuliBlock{1,iTrial}{2};

startTime = tic;
stimGenPTB('load',ch,tm);
loadTime = toc(startTime);

end

