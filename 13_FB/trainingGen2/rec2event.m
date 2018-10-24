%
% rec2event(PRAATrec, <eventName>, <params>) create speech record from event
%
% PRAATrec has periodic state vector of speech info
% eventName is the filename to output to (default .tev)
% params is optional parameter file to tune various things:
%   - VOTstretch is unvoiced consonant time (can be used to stretch output time)
%   - 
% returns cell struct of event in any case, 
% phonemeTiming is cell array {phonSymbol, startSecs, endSecs; ...}
function [eventList, PRAATdata, phonemeTiming] = rec2event(PRAATrec, outFileName, rulesFile, waveformFile)

    % match up start time of PRAAT with delay events on output?
    syncStart = 0;

    eventList = {}; % in case of failure
    PRAATdata = {};
    phonemeTiming = cell(2,1);
    
    % initialize formant tracking structs to support appending
    % initialize to no previous for this phoneme if non existent
    % [freq, stim, intensity, start, end, wf]   - last track laid down
    F1.start = 0;
    F1.end = 0;
    F1.wf = 0;
    F1.energy = 0;
    F1.freq = 0;
    F1.chan = 0;

    F2.start = 0;
    F2.end = 0;
    F2.wf = 0;
    F2.energy = 0;
    F2.freq = 0;
    F2.chan = 0;

    F3.start = 0;
    F3.end = 0;
    F3.wf = 0;
    F3.energy = 0;
    F3.freq = 0;
    F3.chan = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % set up rules file pointer, and read in waveform specs needed
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % link default rules file
    if exist('rulesFile','var') == 0
        rulesFile = 'PRAAT2eventRules';
    end
    
    % execute waveform information script - must contain definitions required in rules
    if exist('waveformFile','var') == 0
        % get default waveform file
        PRAAT2eventWaveforms;
    else
        waveformFile;   % read it in here
    end
    
    % finally, get durations in ms for each waveform specified
    WFlengths = getWaveformDurations(waveformSpecs);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % get PRAAT input and extract various parameters
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isstr(PRAATrec) == 1
        fprintf('%s: ',PRAATrec);
        % if .mat, load
        [a,b,c] = fileparts(PRAATrec);
        if strcmp(c,'.mat')
            load(PRAATrec);
            labels = wordvoc(1,:);
            data = wordvoc(2:end,:);
            clear('wordvoc');
            [nlines, ~] = size(data);
        else % assume text file
            f = fopen(PRAATrec, 'r');
            nlines = fileLines(PRAATrec);
            labels = getElements(fgetl(f));
            % read rest of PRAAT file into cell to allow looking into the future
            data = cell(nlines-1, numel(labels));
            for i=1:nlines-1
                try 
                    data(i,:) = getElements(fgetl(f));
                catch
                    foo = 1;
                end
            end
            fclose(f);  
        end
    % if cell, cotains record
    elseif iscell(PRAATrec) == 1
        labels = PRAATrec(1,:);
        data = PRAATrec(2:end,:);
        [nlines, ~] = size(data);
    end
    
    % get PRAAT file labels and find the indices needed
    lab_phoneme = find(strcmp('phoneme',labels));
    lab_time = find(strcmp('timestamp',labels));
    lab_voicing = find(strcmp('voicing',labels));
    lab_F1 = find(strcmp('f1',labels));
    lab_F2 = find(strcmp('f2',labels));
    lab_F3 = find(strcmp('f3',labels));
    lab_energy = find(strcmp('intens',labels));
      
    % find PRAAT time that first phoneme starts
    PRstart = nlines+1; % causes abort if no phonemes
    for i=1:nlines
        if data{i,lab_phoneme} ~= '#'
            phonemeNext = data{i,lab_phoneme};
            PRstart = i;
            PRstartTimeMS = 1000 * data{i,lab_time};
            break;
        end
    end
    phonemeTiming = cell(1,2);
    if PRstart > 1
        phonemeTiming(1,:) = {'#',0};
        ptIdx = 2;
    else
        ptIdx = 1;
    end
    % put first real phoneme in output record
    phonemeTiming(ptIdx,:) = {phonemeNext,data{i,lab_time};};
    ptIdx = ptIdx + 1;  % next one to fill in
    
    % find PRAAT time after last phoneme (# is no-phoneme indicator)
    PRlast = nlines;
    PRlastTime = 0;
    while PRlast > PRstart
        if data{PRlast,lab_phoneme} ~= '#'
            if PRlast < nlines
                PRlastTime = data{PRlast+1,lab_time};
            end
            break;
        end 
        PRlast = PRlast -1;
    end
   
    % keep records with phoneme data for statistics analysis
    PRAATdata = data(PRstart:PRlast,:);
    
    PRendTimeMS = 1000 * data{PRlast,lab_time};
    PRstepTimeMS = PRendTimeMS - (1000 * data{PRlast-1,lab_time});
    PRendTimeMS = PRendTimeMS + PRstepTimeMS; % allow time after last record
    PRstimDurationMS = PRendTimeMS - PRstartTimeMS + PRstepTimeMS;
    
    % initialize stimActive array - every ms of elapsed time and channel
    elapsedInTime = floor(PRstimDurationMS + 100.0);
    stimActive = zeros(32,elapsedInTime); % give extra elements on end for time stretch

    % initialize variables
    stretchTime = 0;    % allow for stretching output elapsed time    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Cycle through PRAAT array (called data here) and for each phoneme
    % call the rulesfile script to put waveforms on the stimActive record
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    phoneme = '#'; % start with dummy to trigger 'new phoneme' determination
    PRAATidxEnd = PRstart; % first index of real phoneme
    numSArecordsInPhon = 0;
    stimActiveIdxStart = 1;
    stimActiveIdxEnd = 1;
    stimActiveNumRecs = 0; 
    
%     phonemeNext = data{PRAATidxEnd,lab_phoneme}; % next becomes present below
%     phonemeStartTime = data{PRAATidxEnd,lab_time} * 1000;
     
    % loop through all phonemes, leave pointer pointing to first new
    % phoneme in each case
    while PRAATidxEnd <= nlines
        % set up for new phoneme (based on previous end detemination)
        PRAATidxStart = PRAATidxEnd; % start on previous end (first new phoneme)
        % elapsed time for this phoneme
        PRAATphonStartTimeMS = (1000 * data{PRAATidxStart,lab_time}); % - PRstartTimeMS;
        PRAATphonEndTimeMS = PRAATphonStartTimeMS + PRstepTimeMS;
        
        % update identifier for this phoneme
        phonemeLast = phoneme;
        phoneme = phonemeNext;
        phonemeNext = '#'; % initialize in case it's the last one
        
        % index into stimActive array for phoneme takes into account cumulative stretch
        phonemeStartTimeMS = PRAATphonStartTimeMS+stretchTime;
        if syncStart == 0
            phonemeStartTimeMS = phonemeStartTimeMS - PRstartTimeMS;
        end
        
        % loop through PRAAT records to get next phoneme identity and index
        phonemeEndTimeMS = phonemeStartTimeMS+PRstepTimeMS; % default in case we are done
        PRAATidxEnd = PRAATidxStart + 1;
        while PRAATidxEnd <= nlines
            if data{PRAATidxEnd,lab_phoneme} ~= phoneme
                phonemeNext = data{PRAATidxEnd,lab_phoneme};
                phonemeEndTimeMS = (1000 * data{PRAATidxEnd,lab_time}); % - PRstartTimeMS;
                if syncStart == 0 % normalize to start time
                    phonemeEndTimeMS = phonemeEndTimeMS - PRstartTimeMS;
                end
                
                break;
            end
            PRAATidxEnd = PRAATidxEnd + 1;
        end
        
        if PRAATidxEnd < nlines
            phonemeTiming(ptIdx,:) = {phonemeNext,data{PRAATidxEnd,lab_time}};
            ptIdx = ptIdx + 1;  % next one to fill in
        end
        
        % calculate the number of ms in phoneme
        phonemeDurationMS = phonemeEndTimeMS - phonemeStartTimeMS;
        
        % set stimActive parameters for this next phoneme
        % by adding the number of records for previou phoneme
        stimActiveIdxStart = stimActiveIdxStart + stimActiveNumRecs;
        
        % execute the phoneme - sets the output pointer appropriately
        %eval(rulesFile);
        eval(rulesFile);
    end % process PRAAT input
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % extract eventlist from stimActive database
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %fprintf('creating event record .... \n');
    evtIdx = 1;    % index into event data
    lastTimeStamp = 0;  % stimActive time of last event
    
    % now create max size event record allowed
    eventList = zeros(3000,3); %triplet: timeToNext, chan, waveform
    
    % loop to do conversion, examine each stimActive column to extract events
    [sar, sac] = size(stimActive);
    for t=1:sac
        % make vector of channels at current time, find events (if any)
        vect = find((stimActive(:,t) > 0));
        
        % if any found, and lastTimestamp > 0
        if (numel(vect) > 0)
            % update the delay time of the previous index?
            if lastTimeStamp > 0
                eventList(evtIdx-1,1) = t-lastTimeStamp;
            end
            
            % process all events
            for e=1:numel(vect)
                %fprintf('.');
                wf = stimActive(vect(e),t);
                eventList(evtIdx,:) = [0,vect(e)-1,wf];
                evtIdx = evtIdx+1;
            end 
            
            % flag the need to update the delay of this last event
            lastTimeStamp = t;
        else   
            % Check whether we need a non-stimulus time delay event
            % because too long an interval has elepsed (>=63 ms)
            % since last event
            if t-lastTimeStamp >= 63
                if lastTimeStamp > 0
                    % update last event delay time
                    eventList(evtIdx-1,1) = 63;
                end
                lastTimeStamp = t;
                eventList(evtIdx,:) = [0,0,0];
                evtIdx = evtIdx + 1;
            end
        end
        % make sure that was not last event index
        if evtIdx >= 3000
            fprintf('ERROR rec2event: EVENT LIST EXCEEDS GEN2 CAPACITY (3000)\n');
            return;
        end
    end % create eventlist
    
    % CLEAN UP and return
    evtIdx = evtIdx - 1;    % pointed to next record
    eventList = eventList(1:evtIdx,:); % truncate to number of events generated
    if exist('outFileName','var') == 1
        save(outFileName, eventList, PRAATrec); % save original name/type of PRAAT record too
    end
    evtDur = sum(eventList(:,1));
    fprintf('Speech dur %u ms, Tactile dur %d ms, %d events\n',int32(PRstimDurationMS),evtDur,evtIdx);
end % function
