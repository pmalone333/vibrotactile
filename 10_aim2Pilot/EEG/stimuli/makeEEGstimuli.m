vcv_stim = {'aba1','aba2','ada1','ada2','afa1','afa2', ... 
    'aga1','aga2','aka1','aka2','ama1','ama2','ana1','ana2', ...
    'apa1','apa2','asa1','asa2','ata1','ata2','ava1','ava2', ...
    'aza1','aza2'};

stimuli = cell(length(vcv_stim),3);

for s=1:length(vcv_stim)
    load([vcv_stim{s} '_remapChan.mat']);
    stimuli{s,1} = vcv_stim(s);
    stimuli{s,2} = ch;
    stimuli{s,3} = tm;
    clear ch tm
end

stimuliSame = [stimuli stimuli];

% 'same' condition should also pair 2 different 
% tokens for same vcv  
for s=1:2:length(stimuli)-1
    stimuli2(s,:) = stimuli(s+1,:);
    stimuli2(s+1,:) = stimuli(s,:);
end

stimuliSame = [stimuliSame; stimuli2 stimuli];
permuteTrials = randperm(length(stimuliSame));
stimuliSame = stimuliSame(permuteTrials,:);

stimuliDiff = [stimuli; stimuli];
permuteTrials = randperm(length(stimuliDiff));
stimuliDiff = stimuliDiff(permuteTrials,:);

stimuliDiff2 = [stimuli; stimuli];
stimuliDiff = [stimuliDiff stimuliDiff2];
