%
% PRAAT2eventWaveforms - script that describes the default waveforms
% and functions to use them with
%
% Must include the waveform file as well as the functional specifications
% for which waveform to use for which functions (see PRAAT2eventRules)
%
% channel numbers 1-32, wf numbers 1-31

% records specifying how formant frequencies are mapped to stimulators: 
% each row is:      stimNum Freq;
freqStimMapping = [...
    1,200;...     % use stim 1 when F1 < 120
    2,325;...
    3,450;...
    4,600;...
    5,800;...     % use stim 1 when F1 < 120
    6,1000;...
    7,1200;...
    8,1400;...
    9,1600;...     % use stim 1 when F1 < 120
    10,1800;...
    11,2000;...
    12,2150;...    
    13,2300;...     % use stim 1 when F1 < 120
    14,2450;...
    15,2600;...
    16,2750;...
];
 
% energy threshold values for high-low intensity
F1energyThresh = 0.2;
F2energyThresh = 0.2;
F3energyThresh = 0.2;

% labels specifying which waveforms to use for formants
% Formant labels: Formant#(1,2,3), time duration(T5 or T50) in ms
% and amplitude (1,2,3)
%
% also given are the keys that give the pattern of stimulation overlays
% which are lists of triplets [msSinceStartOfPhoneme, chan, waveform; ...]
F1T5A1 = 1;
F1T10A1 = 2;
F1T5A2 = 3;
F1T10A2 = 4;
F1T5A3 = 5;
F1T10A3 = 6;

F2T5A1 = 7;
F2T10A1 = 8;
F2T5A2 = 9;
F2T10A2 = 10;
F2T5A3 = 11;
F2T10A3 = 12;

F3T5A1 = 13;
F3T10A1 = 14;
F3T5A2 = 15;
F3T10A2 = 16;
F3T5A3 = 17;
F3T10A3 = 18;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% plosives - give mix of frequencies, feels louder!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PlosT5A1 = 19;
PlosT50A1 = 20;
PlosT5A2 = 21;
PlosT50A2 = 22;

% t,d near elbow - delay start to emphasize VOT
key_td = [40,7,PlosT50A2;40,8,PlosT50A2;40,9,PlosT50A2;40,10,PlosT50A2];

% k,g in middle
key_kg = [40,4,PlosT50A2;40,5,PlosT50A2;40,12,PlosT50A2;40,13,PlosT50A2];

% p,b near wrist
key_pb = [40,1,PlosT50A2;40,2,PlosT50A2;40,15,PlosT50A2;40,16,PlosT50A2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% fricatives - two cycles of 50Hz stim = 40ms: very distinctive
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FricT40A1 = 23;
FricT40A2 = 24;
FricT40A3 = 25;

% s and z are random high-level stimuli on the elbow half of the array (4-11)
% when a channel is occupied, move stimulus to adjacent channel
% start one every 8 ms until s is over (25 specified)
key_sz = [0,10,FricT40A2;8,11,FricT40A2;16,5,FricT40A2;24,9,FricT40A2;32,12,FricT40A2;...
    40,8,FricT40A2;48,6,FricT40A2;56,7,FricT40A2;64,11,FricT40A2;72,5,FricT40A2;80,12,FricT40A2;...
    88,9,FricT40A2;96,10,FricT40A2;104,8,FricT40A2;112,7,FricT40A2;120,6,FricT40A2];

% similarly, SZ are mapped in the lower half of the array
key_SZ = [0,1,FricT40A2;8,13,FricT40A2;16,14,FricT40A2;24,3,FricT40A2;32,16,FricT40A2;...
    40,4,FricT40A2;48,2,FricT40A2;56,15,FricT40A2;64,13,FricT40A2;72,3,FricT40A2;80,1,FricT40A2;...
    88,16,FricT40A2;96,4,FricT40A2;104,14,FricT40A2;112,2,FricT40A2;120,15,FricT40A2];

% T/D 2 rows near elbow , low intensity, continuous
key_TD = [0,7,FricT40A1;8,8,FricT40A1;16,9,FricT40A1;24,10,FricT40A1];

% f,v 2 rows by writs, low intensity, continuous
key_fv = [0,1,FricT40A1;8,2,FricT40A1;16,15,FricT40A1;24,16,FricT40A1];

% h 2 rows in middle, low intensity, continuous
key_h = [0,4,FricT40A1;8,5,FricT40A1;16,12,FricT40A1;24,13,FricT40A1];

% CJ sweeps across, high intensity
key_CJ = [0,1,FricT40A2;0,16,FricT40A2;8,3,FricT40A2;8,14,FricT40A2;16,5,FricT40A2;...
    16,12,FricT40A2;24,7,FricT40A2;56,10,FricT40A2];

% liquids, glides 
waveW = 26;
waveL = 27;
waveR = 28;
waveY = 29;

%formant rapid transition signals
SweepT10Up = 30;
SweepT10Down = 31;

% select waveforms for liquids and glides
wf_w = waveW;

% FINALLY, define the waveforms for download (once)
waveformSpecs = {...
    {1, 1:16, 1, [150, 0.4, 1, 0, 0]},...   % F1T5A1 - 7ms
    {2, 1:16, 1, [150, 0.4, 3, 0, 0]},...   % F1T10A1 - 18 ms
    {3, 1:16, 1, [150, 0.7, 1, 0, 0]},...   % F1T5A2
    {4, 1:16, 1, [150, 0.7, 3, 0, 0]},...   % F1T10A2
    {5, 1:16, 1, [150, 1.0, 1, 0, 0]},...   % F1T5A3 
    {6, 1:16, 1, [150, 1.0, 3, 0, 0]},...   % F1T10A3 
    {7, 1:16, 1, [250, 0.4, 1, 0, 0]},...   %%% F2T5A1 - 8ms
    {8, 1:16, 1, [250, 0.4, 2, 0, 0]},...   % F2T10A1 - 16 ms
    {9, 1:16, 1, [250, 0.7, 1, 0, 0]},...   % F2T5A2 
    {10, 1:16, 1, [250, 0.7, 2, 0, 0]},...   % F2T10A2 
    {11, 1:16, 1, [250, 1.0, 1, 0, 0]},...   % F2T5A3 
    {12, 1:16, 1, [250, 1.0, 2, 0, 0]},...   % F2T10A3 
    {13, 1:16, 1, [350, 0.4, 2, 0, 0]},...   %%%% F3T5A1 - 5.7 ms
    {14, 1:16, 1, [350, 0.4, 4, 0, 0]},...   % F3T10A1 - 11.4
    {15, 1:16, 1, [350, 0.7, 2, 0, 0]},...   % F3T5A2 
    {16, 1:16, 1, [350, 0.7, 4, 0, 0]},...   % F3T10A2 
    {17, 1:16, 1, [350, 1.0, 2, 0, 0]},...   % F3T5A3 
    {18, 1:16, 1, [350, 1.0, 4, 0, 0]},...   % F3T10A3
    ... % non-formant waveforms:
    {19, 1:16, 1, [320,0.7,1,0,0;130,0.7,1,0,0;260,0.7,1,0,0;150,0.7,1,0,0]},...   %%%  PlosT5A1 * MiX OF FREQ
    {20, 1:16, 1, [320,0.7,1,0,0;130,0.7,1,0,0;260,0.7,1,0,0;150,0.7,1,0,0]},...   % PlosT10A1 
    {21, 1:16, 1, [320,1.0,1,0,0;130,1.0,1,0,0;260,1.0,1,0,0;150,1.0,1,0,0]},...   % PlosT5A2 
    {22, 1:16, 1, [320,1.0,1,0,0;130,1.0,1,0,0;260,1.0,1,0,0;150,1.0,1,0,0]},...   % PlosT10A2 
    {23, 1:16, 1, [50, 0.5, 2, 0, 0]},...   %%% FricT40A1 
    {24, 1:16, 1, [50, 0.75, 2, 0, 0]},...   % FricT40A2 
    {25, 1:16, 1, [50, 1.0, 2, 0, 0]},...   % FricT40A3 
    {26, 1:16, 1, [100, 1.0, 2, 0, 0; 200, 1.0, 2, 0, 0]},...   %%% waveW 
    {27, 1:16, 1, [250, 1.0, 3, 0, 0; 350, 1.0, 3, 0, 0]},...   % waveL 
    {28, 1:16, 1, [150, 1.0, 2, 0, 0; 300, 1.0, 2, 0, 0]},...   % waveR 
    {29, 1:16, 1, [300, 1.0, 4, 0, 0; 350, 1.0, 4, 0, 0]},...   % waveY 
    {30, 1:16, 1, [150, 1.0, 1, 0, 0;225, 1.0, 1, 0, 0;300, 1.0, 1, 0, 0;375, 1.0, 1, 0, 0;]},...   %%% SweepT10Up 
    {31, 1:16, 1, [375, 1.0, 1, 0, 0;300, 1.0, 1, 0, 0;225, 1.0, 1, 0, 0;150, 1.0, 1, 0, 0;]},...   % SweepT10Down 
};

%waveformDurations = getWaveformDurations(waveforms);
