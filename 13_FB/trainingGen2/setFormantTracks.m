%
% setFormantTracks - script to write formant tracks into data array,
% can be modified for specific phonemes by specific parameters
% FILLS in the stimActive array. 
%
% WAVEFORMS TO USE named in calling program
%
% modifiers:
% if formant_use_ampl = 0, calculate amplitude from intensity
% if formant_use_waveform = 0, use default values
% if stretch_phoneme = 0, don't stretch this phoneme
% 
% uses:
% data - PRAAT data, PRAATidxStart, PRAATidxEnd (first index of new phoneme)
% stimActive array of waveform info, with indices stimActiveIdxStart
% phonemeDurationMs (unstretched) gives the length of the phoneme
% F1_placeMapping, F1_placeMapping, F1_placeMapping to map freq to chans
% WFlengths gives length in ms for each waveform (1-31)

% QUESTION: if phoneme stretched, how to map input trajectories?
% interpolate across interval?

PRAATrecords = PRAATidxEnd - PRAATidxStart -1;
outRecs = phonemeDurationMS + stretch_phoneme;
% calculate whole number and skip number - i.e.
% every Nth output record just duplicate it
outRecsPerPRAAT = floor(outRecs/PRAATrecords);
remainderRecs = floor(outRecs/rem(outRecs,PRAATrecords));

outIdx = stimActiveIdxStart;
lastIdx = outIdx + phonemeDurationMS + stretch_phoneme -1;

% in case this interval is stretched, need to make in and out time
% pointers relative to the start of this phoneme
inTime = PRAATidxStart;
outTime = phonemeStartTimeMS;
elapsedInTime = 0.0;

% if stretch occurs during this phoneme, need timeWarp factor for 
% elapsed output vs PRAAT input times
timeWarp = (phonemeDurationMS + stretch_phoneme) / phonemeDurationMS;

% each PRAAT record is 4 ms long, maps onto 4 output records (or more)
for t=PRAATidxStart:PRAATidxEnd-1
    % if unvoiced interval, don't do anything
    if data{t,lab_voicing} == 0
        continue;
    end
    
    % HAVE VOICED INTERVAL - get remaining required info for this period
    % input time since phoneme started
    elapsedInTime = (1000*data{t,lab_time}) - PRAATphonStartTimeMS;
    % index of closest output time, taking into account phoneme stretch
    outIndex = floor(outTime + (elapsedInTime * timeWarp));
    if outIndex < 1
        outIndex = 1;
    end
    
    % get remaining PRAAT info needed for calculating formant trajectories
    voiced = data{t,lab_voicing};
    energy = data{t,lab_energy};
    F1freq = data{t,lab_F1};
    F2freq = data{t,lab_F2};
    F3freq = data{t,lab_F3};
    
    % LATER - look at trajectories throughout interval, 
    % later - multiple chans on high-energy?
    % LATER - allow edges to overlap between formants?
     
    % Do F2 first, because it has priority (in case of stim chan overlap)
    if F2.end <= outIndex 
        % F1 stimulation ended, place next pulse
        % get index of closest frequency in F2 freq array
        [~, i] = min(abs(freqStimMapping(:,2)-F2freq));
        % and find channel to stimulate
        chan = freqStimMapping(i,1);
        % now figure out which waveform
        if formant2_use_waveform > 0
            wf = formant2_use_waveform;
        elseif formant_use_waveform > 0
            wf = formant_use_waveform;
        else
            if formant_use_ampl > 0
                switch(formant_use_ampl)
                    case 1
                        wf = F2T10A1;     
                    case 2
                        wf = F2T10A2;     
                    case 3
                        wf = F2T10A3;  
                    otherwise
                        fprintf('ERROR 37\');
                end
            % default, use med or high amplitude waveform depending on energy
            elseif energy > F2energyThresh
                wf = F2T10A3;
            else
                wf = F2T10A2;
            end
        end
        % fill in output array
try
        length = WFlengths(wf);
catch
foo = 1;
end
try
        stimActive(chan,outIndex) = wf;
catch
    foo=1;
end
        for i=1:length-1
            stimActive(chan,outIndex+i) = -1;
        end
        % and fill in record for next pass
        F2.start = outIndex;
        F2.end = outIndex+length;
        F2.freq = F2freq;
        F2.energy = energy;
        F2.chan = chan;
        F2.wf = wf;
    end
    
    if F1.end <= outIndex
        % F1 stimulation ended, place next pulse
        % get index of closest frequency in F2 freq array
        [~, i] = min(abs(freqStimMapping(:,2)-F1freq));
        % and find channel to stimulate
        chan = freqStimMapping(i,1);
        % now figure out which waveform
        if formant1_use_waveform > 0
            wf = formant1_use_waveform;
        elseif formant_use_waveform > 0
            wf = formant_use_waveform;
        else
            % default, use med or high amplitude waveform depending on energy
            if formant_use_ampl > 0
                switch(formant_use_ampl)
                    case 1
                        wf = F1T10A1;     
                    case 2
                        wf = F1T10A2;     
                    case 3
                        wf = F1T10A3;  
                    otherwise
                        fprintf('ERROR 37\');
                end
            % default, use med or high amplitude waveform depending on energy
            elseif energy > F1energyThresh
                wf = F1T10A3;
            else
                wf = F1T10A2;
            end
        end
        % fill in output array
        length = WFlengths(wf);
        try
            stimActive(chan,floor(outIndex)) = wf;
        catch
            foo = 2;
        end
        
        for i=1:length-1
            stimActive(chan,outIndex+i) = -1;
        end
        % and fill in record for next pass
        F1.start = outIndex;
        F1.end = outIndex+length;
        F1.freq = F2;
        F1.energy = energy;
        F1.chan = chan;
        F1.wf = wf;        
    end
    
    if F3.end <= outIndex
        % F1 stimulation ended, place next pulse
        % get index of closest frequency in F2 freq array
        [~, i] = min(abs(freqStimMapping(:,2)-F3freq));
        % and find channel to stimulate
        chan = freqStimMapping(i,1);
        % now figure out which waveform
        if formant3_use_waveform > 0
            wf = formant3_use_waveform;
        elseif formant_use_waveform > 0
            wf = formant_use_waveform;
        else
            % default, use med or high amplitude waveform depending on energy
            if formant_use_ampl > 0
                switch(formant_use_ampl)
                    case 1
                        wf = F3T10A1;     
                    case 2
                        wf = F3T10A2;     
                    case 3
                        wf = F3T10A3; 
                    otherwise
                        fprintf('ERROR 37\');
                end
            % default, use med or high amplitude waveform depending on energy
            elseif energy > F3energyThresh
                wf = F3T10A3;
            else
                wf = F3T10A2;
            end
        end
        % fill in output array
        length = WFlengths(wf);
        stimActive(chan,outIndex) = wf;
        for i=1:length-1
            stimActive(chan,outIndex+i) = -1;
        end
        % and fill in record for next pass
        F3.start = outIndex;
        F3.end = outIndex+length;
        F3.freq = F2;
        F3.energy = energy;
        F3.chan = chan;
        F3.wf = wf;
    end
end % for loop to examine input data (every 4 ms)
