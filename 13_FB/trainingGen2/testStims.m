%
% test system by cycling around the stimulators
%

LOW_BANK = 1; % 1= low bank of stimulators, 0=high bank of stimulators

loadWaveform = 1; % load waveform to test that interface? Set to 0 to use default.

% specify waveforms, arbitrary number of records in cell
% this format allows programming different waveforms to different channels
% format: [waveNum(1-31), chanList(1:32), NumRepeates (1-255), data(<=7 wavelets waveforms 1-3, <=16 wavelets waveforms 4-31)]
% where each wavelet is [freq(Hz, amplitude (0-1.0), numCycles, risetime(ms), falltime(ms))]
% NOTE: if waveform not programmed but played, can get long, random waveforms
% USE SEMICOLONS to separate each wavelet
% NOTE: INCLUDE WAVEFORM 1 IN THE TABLE -> this causes header numberBytes
% to be written to TI chips. Otherwise, must write 155 to loc. 256 for
% standard waveform structure to work.
% wf1 = {{1, 1:16, 1, [130, 1.0, 10, 0, 0]}};
waveformSpecsL = {...
    {1, 1:16, 1, [130, 1.0, 10, 0, 0]},...  % waveform 1 spec
    {2, 1:16, 1, [160, 1.0, 5, 0, 0]},...  % waveform 2 spec
    {3, 1:16, 1, [170, 1.0, 5, 0, 0]},...  % waveform 3 spec
    {4, 1:16, 1, [180, 1.0, 5, 0, 0]},...  % waveform 4 spec
    {5, 1:16, 1, [190, 1.0, 5, 0, 0]},...  % waveform 5 spec
    {6, 1:16, 1, [200, 1.0, 5, 0, 0]},...  % waveform 6 spec
    {7, 1:16, 1, [210, 1.0, 5, 0, 0]},...  % waveform 7 spec
    {8, 1:16, 1, [220, 1.0, 5, 0, 0]},...  % waveform 8 spec
    {9, 1:16, 1, [230, 1.0, 5, 0, 0]},...  % waveform 9 spec
    {10, 1:16, 1, [240, 1.0, 5, 0, 0]},...  % waveform 10 spec
    {11, 1:16, 1, [250, 1.0, 5, 0, 0]},...  % waveform 11 spec
    {12, 1:16, 1, [260, 1.0, 5, 0, 0]},...  % waveform 12 spec
    {13, 1:16, 1, [270, 1.0, 5, 0, 0]},...  % waveform 13 spec
    {14, 1:16, 1, [280, 1.0, 5, 0, 0]},...  % waveform 14 spec
    {15, 1:16, 1, [290, 1.0, 5, 0, 0]},...  % waveform 15 spec
    {16, 1:16, 1, [300, 1.0, 5, 0, 0]},...  % waveform 16 spec
    {17, 1:16, 1, [310, 1.0, 5, 0, 0]},...  % waveform 17 spec
    {18, 1:16, 1, [320, 1.0, 5, 0, 0]},...  % waveform 18 spec
    {19, 1:16, 1, [330, 1.0, 5, 0, 0]},...  % waveform 19 spec
    {20, 1:16, 1, [340, 1.0, 5, 0, 0]},...  % waveform 20 spec
    {21, 1:16, 1, [350, 1.0, 5, 0, 0]},...  % waveform 21 spec
    {22, 1:16, 1, [360, 1.0, 5, 0, 0]},...  % waveform 22 spec
    {23, 1:16, 1, [370, 1.0, 5, 0, 0]},...  % waveform 23 spec
    {24, 1:16, 1, [380, 1.0, 5, 0, 0]},...  % waveform 24 spec
    {25, 1:16, 1, [390, 1.0, 5, 0, 0]},...  % waveform 25 spec
    {26, 1:16, 1, [400, 1.0, 5, 0, 0]},...  % waveform 26 spec
    {27, 1:16, 1, [410, 1.0, 5, 0, 0]},...  % waveform 27 spec
    {28, 1:16, 1, [420, 1.0, 5, 0, 0]},...  % waveform 28 spec
    {29, 1:16, 1, [430, 1.0, 5, 0, 0]},...  % waveform 29 spec
    {30, 1:16, 1, [440, 1.0, 5, 0, 0]},...  % waveform 30 spec
    {31, 1:16, 1, [450, 1.0, 5, 0, 0]},...  % waveform 31 spec    
    };

comport = 'COM4';
NUM_CYCLES = 5; % repeat cycle this many times

r = piezoDriverGen2('open');
if strcmp(r,'Gen2 piezo stimulator') == 0
    fprintf('COM port wrong, or interface problem\n');
    return;
end

% has the system been initialized (to default waveform schema)?
% check memory loc 256 - should be 155 (decimal)
% vals = piezoDriverGen2('readTIlocs', 256, 3, 1);
% fprintf('Read of locs & location 256: %d %d %d\n',vals(1),vals(2),vals(3));
if loadWaveform == 1
    loadWave(waveformSpecsL);
%     % now also check whether the waveformSpecsL have already been programmed
%     checkVals = waveformSpecsL{end};
%     wf = checkVals{1};
%     chan = checkVals{2}(end);
%     repeats = checkVals{3};
%     data = checkVals{4};  % get last waveform in list
%     rawData = gen2ConvertWave(data);
%     rsp = piezoDriverGen2('getWaveform',wf,chan); % retrieve waveform
% 
%     % check whether last waveform is programmed in last channel
%     if isequal(rawData, rsp) == 0
%         %fprintf('Writing waveforms....');
%         % write the waveform data 
%         piezoDriverGen2('programWaveforms',waveformSpecsL);
%         fprintf('Done programming Waveforms\n');
%     end
% 
%     % start up the TI chips by writing the critical registers (chans 1-16)
%     w = [2,2,1,0];
%     piezoDriver32('writeTIlocs', 1, w, 1:16)
end
% convert to raw data that can be written to TI chips
% note that the header info in page 1 must be changed as well as the wave
% data, with the default values set up for 31 waveforms (1-31) as:
% the system is initialized with the header size and start addresses,
% assuming that Waveforms 1-3 are short (33 bytes each max)
% Waveforms 4-31 can be complex, up to 64 bytes each.
%
% HEADER: 155 (size),
% WF1startHigh, WF1startLow, WF1endHigh, WF1endLow, repeats,
% WF2... same up to WF31
%
%[wf1Header, wf1DATA] = convertWF(wf1, 1);

% create the gesture record using the default Waveform-1 signals
% ON THE PRIMARY STIMULATOR UNIT
% Each event consists of:
% Number of (whole) ms until next event is triggered (0-63)
% Channel number: 0-31
% Waveform number to trigger (1-31, or 0 to delay without trigger)

gestureL = [...
    63,0,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,1,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,2,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,3,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,4,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,5,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,6,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,7,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,8,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,9,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,10,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,11,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,12,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,13,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,14,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,15,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
];

VgestureL = [...
    63,0,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,1,2;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,2,3;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,3,4;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,4,5;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,5,6;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,6,7;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,7,8;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,8,9;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,9,10;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,10,11;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,11,12;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,12,13;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,13,14;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,14,15;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,15,16;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,17;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,1,18;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,2,19;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,3,20;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,4,21;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,5,22;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,6,23;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,7,24;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,8,25;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,9,26;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,10,27;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,11,28;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,12,29;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,13,30;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,14,31;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,15,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
];

gestureH = [...
    63,16,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,17,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,18,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,19,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,20,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,21,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,22,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,23,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,24,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,25,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,26,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,27,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,28,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,29,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,30,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,31,1;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
];


% now convert gesture to the primitive uint16 values sent to the stimulator, with bits:
% 0-4 specifying the waveform number 1-31 (or 0 to delay, without a waveform trigger)
% 5-9 specifying the channel (0=right-hand by thumb, 31 left hand by thumb)
% 10-15 specifying the number of ms until the next record (0-63 ms)
if LOW_BANK == 1
    rawGesture = gen2ConvertGesture(VgestureL);
else
    rawGesture = gen2ConvertGesture(gestureH);
end

% write gesture to stimulator
piezoDriverGen2('loadGesture',rawGesture);

% need to wait a bit for gesture to load fully
%tic();
%while toc() < 5
%end

% now write the file
for i=1:NUM_CYCLES
    fprintf('%d/%d.',i,NUM_CYCLES);
    piezoDriverGen2('start');
end
fprintf('\n');

%piezoDriverGen2('close');

