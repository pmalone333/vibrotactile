%
% SpokenWordID 
%
% ETA 4-22-14
%
% Last modification 4/22/2014
function result = SpokenWordID(subjID, session, controlFile, text)
global gui;
global win;
exptID = 'SPWID';
% get rid of warnings - define in the control file
list_filenames = '';
list_startSamples = '';
list_numSamples = '';
list_words='';
afterResponseWaitSecs = 0;
lists = '';
randomize_lists = 0;
% disable screen, use normal interfaces
if win >0
    Screen('CloseAll');
end
% try to read control file
try
   eval(controlFile);
catch me
   if win > 0
       Screen('CloseAll');
       win = -1;
   end
   UIpanel('string', 'System error, please notify attendant', 'buttons',{50 5 'OK'});
   errlog(strcat('Exception for ',subjID,' task (',exptID,'):',me.identifier));
   putlog(strcat('Exception for ',subjID,' task (',exptID,'):',me.identifier));
   result = 'ERR: controlFile parse error';
   return;    
end

% open result file for appending
str = strcat('../results/s',subjID,'.rsp');
rslt_file = fopen(str, 'a');
if(rslt_file < 0)
   errlog(['Can''t open response file ',rslt_file]);
   result = 'ERR: could not open subject response file';
   return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% give instructions now, if any specified
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('instructions','var') == 1
    displayInstructions(instructions);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% set volume level based on the calibration.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval('SPWIDcal'); 
GetAudioControls;
setAudioVariables(AudioControls,'volume','volume',snd_level);   
fprintf('set sound level to %f, calibration date: %s\n',snd_level,snd_calib_date);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ready to go: write info to response file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
line = ['$start ',datestr(now,30),13,10,...
'$experiment SPWID',13,10,...
'$controlfile ',controlFile,13,10,...
'$subjectID ',subjID,13,10,...
'$session ',session,13,10,...
'$soundlevel ',num2str(snd_level),13,10,...
'$calibrationDate ', snd_calib_date,13,10,...
'$dataElements sentenceNum, score, responseTime, response',13,10];
fwrite(rslt_file, line);

% if extra response file text is included, add it in here
if exist('text','var')
   text = [text,13,10];
   fwrite(rslt_file, text);
end

% randomize list order if specified
% nLists = numel(lists);
%if randomize_lists == 0
%    listOrder = (1:nLists);
%else
%    listOrder = ChooseKFromN(nLists,nLists);
%end

try
    % load audio clip - all sentences for this list
    [y, freq, ~] = wavread(audio_filename);
    %y = y * level_multiplier;   % convert from 70dB SPL to HL
    %fprintf('loaded wave file %s\n',audioFile);
    wavedata = y';
    nrchannels = size(wavedata,1);
    InitializePsychSound;
    soundhandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
%    setAudio('speaker','PCmono');

    % fill primary buffer with waveform... tokens will be copied from this
    PsychPortAudio('FillBuffer', soundhandle, wavedata, 0, 1);    
    
catch me
    fprintf('error setting up audio output: (%s)\n',me.identifier);
    result = 'err: setup';
    return;   
end
%%%%%%%%%%STILL NEED TO MODIFY FOR RANDOM ORDER    
% randomize list order if specified
 nStim = numel(list_words);
if randomize_lists == 0
   stmOrder = (1:nStim);
else
   stmOrder = ChooseKFromN(nStim,nStim);
end

for word = 1:nStim
       
        % calculate starting sample and num_samples
        startSamp = list_startSamples(stimOrder(word));
        numSamps = list_numSamples(stimOrder(word));
        
        % load sentence
        awave = wavedata(1:2, startSamp:startSamp+numSamps);
        PsychPortAudio('FillBuffer', soundhandle, awave);

        % start audio, wait for it to finish
        PsychPortAudio('Start', soundhandle, 1,0,1);
        while 1
            status = PsychPortAudio('GetStatus', soundhandle);
            % wait for playback to finish
            if status.Active == 0
                break;
            end
        end
        
        
        % get response
        response = UIpanel('textbox','Please type the word you heard, and push ''Enter'' when done');
%        delete(gui.main); % Close the GUI
        if numel(response) == 0
            response = '{}';  % backwards compatible
        end
        fprintf(rslt_file, '%d, %s, %s',word, list_words(word),response);                     
        fwrite(rslt_file, [13,10]); 
        % delay after response before next stim
        WaitSecs(afterResponseWaitSecs);
    end
% clean up files for this list
% fwrite(outfile, [13,10]);
  PsychPortAudio('Close',soundhandle); % for this list
% final cleanup
endTime = strcat('$endTime ',datestr(now, 30),13,10);
fwrite(rslt_file, endTime);
fclose(rslt_file);
result = 'success';
end
