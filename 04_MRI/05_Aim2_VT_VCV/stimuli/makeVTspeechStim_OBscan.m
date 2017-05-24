function makeVTspeechStim_OBscan

nRuns = 6;
nStimPerBlock = 3; % number of stimuli presented in 6 second block 

labels = {'ada1';'ada2';'aza1';'aza2';'aba1';'aba2';'ata1';'ata2';'ana1';'ana2';...
    'ama1';'ama2';'asa1';'asa2';'apa1';'apa2';'ava1';'ava2';'afa1';'afa2';'aga1';'aga2';...
    'aka1';'aka2'};

%% convert stimulus files into format for stimulator box 
stim = cell(length(labels),1);
for i=1:length(labels)
    load([labels{i}]);
    tm = tactStim{1}{1};
    tm = tm/4; % changed because of a slower sampling rate on new pulseCapture software 
    ch = tactStim{1}{2};
    ch = remapChanVoc(ch); % mapping function from Silvio
    stim{i}{1} = tm;
    stim{i}{2} = ch;
    clear tactStim tm ch
end

%% replicate for multiple repitions per block
stim = repmat(stim,1,nStimPerBlock);
labels = repmat(labels,1,nStimPerBlock);
j = 1;

%% generate stimuli for each run
% 12 VCVs, 2 tokens each = 24 total stimuli + 4 repeats per run for 28
% blocks per run
tmp_stim = stim;
tmp_labels = labels;
clear stim labels
for i_run=1:nRuns
    stim{i_run} = [tmp_stim; tmp_stim(j:j+3,:)];
    labels{i_run} = [tmp_labels; tmp_labels(j:j+3,:)];
    j = j+4;
end

%% add OB stimulus

load('aba2_whiteNoiseAmplifiedC.mat'); % temp: replace with OB stim
tm = tactStim{1}{1};
tm = tm/4; % changed because of a slower sampling rate on new pulseCapture software
ch = tactStim{1}{2};
ch = remapChanVoc(ch); % mapping function from Silvio

% blocks/VCVs with OBs in each run
OB_positions = {[1 3 5 7 9 11 13 15];
                [2 4 6 8 10 12 14 16];
                [1 3 5 7 17 19 21 23]
                [2 4 6 8 18 20 22 24]
                [9 11 13 15 18 20 22 24]
                [10 12 14 16 17 19 21 23]};

for i_run=1:nRuns
    for b=1:length(OB_positions{i_run})
        r = randperm(3);
        stim{i_run}{OB_positions{i_run}(b),r(1)}{1} = tm;
        stim{i_run}{OB_positions{i_run}(b),r(1)}{2} = ch;
        labels{i_run}{OB_positions{i_run}(b),r(1)} = 'OB';
    end
end

%% run 2
save('VTspeechStim_OBscan','stim','labels');

end