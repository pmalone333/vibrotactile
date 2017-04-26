vowel_cfg % load config file 


try
    % load audio
    [y, freq, ~] = wavread(audio_filename);
    wavedata = y';
    nrchannels = size(wavedata,1);
    InitializePsychSound;
    soundhandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);

    % fill primary buffer with waveform... tokens will be copied from this
    PsychPortAudio('FillBuffer', soundhandle, wavedata, 0, 1);  

catch me
    fprintf('error setting up audio output: (%s)\n',me.identifier);
    result = 'err: setup';
    return;   
end

nStim = numel(list_words);

for word = 1:nStim
       
        % calculate starting sample and num_samples
        startSamp = list_startSamples(word);
        numSamps = list_numSamples(word);
        
        % load sentence
        awave = wavedata(1, startSamp:startSamp+numSamps);
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
%        response = UIpanel('textbox','Please type the word you heard, and push ''Enter'' when done');
%        delete(gui.main); % Close the GUI
%         if numel(response) == 0
%             response = '{}';  % backwards compatible
%         end
%         fprintf(rslt_file, '%d, %s, %s',word, list_words(word),response);                     
%         fwrite(rslt_file, [13,10]); 
        % delay after response before next stim
%        WaitSecs(afterResponseWaitSecs);
end
% clean up files for this list
% fwrite(outfile, [13,10]);
  PsychPortAudio('Close',soundhandle); % for this list
% final cleanup
endTime = strcat('$endTime ',datestr(now, 30),13,10);
fwrite(rslt_file, endTime);
fclose(rslt_file);
result = 'success';
