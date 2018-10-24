%
% PRAAT2eventRules - script that gets executed every time a new phoneme is encountered
%
% inputs: 
%
% data is cell of PRAAT vectors, dataptr is pointer to current vector (row), 
% numRecs is number of records in this phoneme
%
% eventList is output events, eventPtr is pointer to next event to be programmed
% stretchTime - is extra ms in output time due to stretching phoneme subevents 
%
% phoneme is current phoneme to be processed (consonants, vowels):
%  pbmfvTDwrCJSZtdszkgGnlhy  iIE@acUu^xReAOWo
%
% This works by creating a table of stimulator-time-busy events that is
% used to determine whether any overlay can use that stimulator at a
% particular time. 
% One intent is to try to make formant tracks as continuous as possible.
% Priorities (highest to lowest) are: F2,F1,F3, phoneme overlay
%
% This file assumes that waveform records are loaded in variable memory
% with the following labels set to the waveform number index (1-31). the
% system checks to make sure that is the case!
%
% assumes that PRAAT output includes the following fields:
% {'timestamp','voicing','phoneme','f1','f2','f3','intens','F0'};

%if checkWFvariables == 1
    %SFTinit = 1;
    %eval('setFormantTracks');
    %SFTinit = 0;
    
    % check to make sure that all needed waveforms are defined
%     allGood = 1;
%     for i=1:numel(labelsUsed)
%         if exist(labelsUsed{i},'var') == 0
%             allGood = 0;
%             fprintf('ERROR PRAAT2eventRules: undefined waveform identifier: %s\n',labelsUsed{i});
%         end
%     end
%     if allGood == 0
%         return;
%     end
%     checkWFvariables = 0;
%     phIdx = 1; % debug
    
    % get the lengths of all waveforms
%    WFlengths = getWaveformDurations(waveformSpecs);
%    stimActiveIdxStart = 1; % start at beginning
%    stimActiveIdxEnd = 1;
%end

% now generate the tracks for the next phoneme, assume the following values
% phoneme, phonemeLast, phonemeNext - current, prev, and next phonemes
% phonemeDurationMs - number of ms in current phoneme
% PRAATidxStart - first PRAAT index for this phoneme
% PRAATidxEnd - first PRAAT index for NEXT phoneme
%
% THIS FILE creates and keeps track of the following event-based parameters
% phonemeIdxStart - index into next record to be populated
% phonemeIdxEnd - index of last record to be populated
%
 
% set defaults for formant tracks - used for most vowels, modify below
formant_use_ampl = 0;       % autodetect
formant1_use_waveform = 0;   % use default for 0
formant2_use_waveform = 0;
formant3_use_waveform = 0;
formant_use_waveform = 0;
stretch_phoneme = 0;        % don't stretch phoneme by this many ms

switch(phoneme)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CONSONANTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plosive-like (voiced following unvoiced)
    case 't' % unvoiced, overlay only
        stimActive = Toverlay(key_td, stimActive, stimActiveIdxStart, WFlengths);
    case 'd'
        setFormantTracks;
        stimActive = Toverlay(key_td, stimActive, stimActiveIdxStart, WFlengths);
    case 'k'
        stimActive = Toverlay(key_kg, stimActive, stimActiveIdxStart, WFlengths);
    case 'g'
        setFormantTracks;
        stimActive = Toverlay(key_kg, stimActive, stimActiveIdxStart, WFlengths);        
    case 'p'
        stimActive = Toverlay(key_pb, stimActive, stimActiveIdxStart, WFlengths);
    case 'b'
        setFormantTracks;
        stimActive = Toverlay(key_pb, stimActive, stimActiveIdxStart, WFlengths);        
        
    % fricative-like (voiced following unvoiced)
    case 's'
        stimActive = Toverlay(key_sz, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'z'
        setFormantTracks;
        stimActive = Toverlay(key_sz, stimActive, stimActiveIdxStart, WFlengths);        
    
    case 'S'
        stimActive = Toverlay(key_SZ, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'Z'
        setFormantTracks;
        stimActive = Toverlay(key_SZ, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'T'
        stimActive = Toverlay(key_TD, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'D'
        setFormantTracks;
        stimActive = Toverlay(key_TD, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'f'
        stimActive = Toverlay(key_fv, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'v'
        setFormantTracks;
        stimActive = Toverlay(key_fv, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'C'
        stimActive = Toverlay(key_CJ, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'J'
        setFormantTracks;
        stimActive = Toverlay(key_CJ, stimActive, stimActiveIdxStart, WFlengths);        
        
    case 'h'
        stimActive = Toverlay(key_h, stimActive, stimActiveIdxStart, WFlengths);        
        
    % nasals
    case 'm'
        formant_use_ampl = 1;
        setFormantTracks;
    case 'n'
        formant_use_ampl = 1;
        setFormantTracks;
    case 'G'
        formant_use_ampl = 1;
        setFormantTracks;
        
    % liquids and glides
    case 'l'
        formant_use_waveform = waveL;
        setFormantTracks;
        
    case 'w'
        formant_use_waveform = waveW;
        setFormantTracks;
    
    case 'r'
        formant_use_waveform = waveR;
        setFormantTracks;
        
    case 'y'
        formant_use_waveform = waveY;
        setFormantTracks;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % VOWELS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FOR NOW, ALL VOWELS DEFAULT to straight formant tracking
    otherwise
        % for now, just track formants with standard params
        setFormantTracks;
end % switch phoneme

% return number of records in this phoneme
stimActiveNumRecs = stretch_phoneme + phonemeDurationMS;

% clean up before returning
stretchTime = stretchTime + stretch_phoneme;    % in case stretched in time
