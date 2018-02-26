function makeFBTrainingStim_10AFC

nStimPerBlock = 60;

tmp = importdata('stimuli\trainingset-editdistanceFB.csv');
dm = tmp.data;
load('stimuli/wordlist_train.mat');

thresh = [0]; %dissimilarity threshold for levels 1-

stim = {};
label = {};

ind = find(dm>thresh(1));
[rows, columns] = ind2sub(size(dm), ind);
k=1;

for w=1:(length(wordlist)*2)
    load(['stimuli/FB/' wordlist{k} '.mat']);
    label{w,1} = wordlist{k};
    stim{w,1} = s;
    stim{w,2} = t;
    % get index of words with > thresh1 dissimilarity
    i = rows(columns==k);
    order = randperm(length(i));
    i = i(order); % randomize order of array
    load(['stimuli/FB/' wordlist{i(1)} '.mat']);
    label{w,2} = wordlist{i(1)};
    stim{w,3} = s;
    stim{w,4} = t;
    label{w,3} = wordlist{i(2)};
    label{w,4} = wordlist{i(3)};
    label{w,5} = wordlist{i(4)};
    label{w,6} = wordlist{i(5)};
    label{w,7} = wordlist{i(6)};
    label{w,8} = wordlist{i(7)};
    label{w,9} = wordlist{i(8)};
    label{w,10} = wordlist{i(9)};
    load(['stimuli/FB/' wordlist{i(2)} '.mat']);
    stim{w,5} = s;
    stim{w,6} = t;
    load(['stimuli/FB/' wordlist{i(3)} '.mat']);
    stim{w,7} = s;
    stim{w,8} = t;
    load(['stimuli/FB/' wordlist{i(4)} '.mat']);
    stim{w,9} = s;
    stim{w,10} = t;
    load(['stimuli/FB/' wordlist{i(5)} '.mat']);
    stim{w,11} = s;
    stim{w,12} = t;
    load(['stimuli/FB/' wordlist{i(6)} '.mat']);
    stim{w,13} = s;
    stim{w,14} = t;
    load(['stimuli/FB/' wordlist{i(7)} '.mat']);
    stim{w,15} = s;
    stim{w,16} = t;
    load(['stimuli/FB/' wordlist{i(8)} '.mat']);
    stim{w,17} = s;
    stim{w,18} = t;
    load(['stimuli/FB/' wordlist{i(9)} '.mat']);
    stim{w,19} = s;
    stim{w,20} = t;
    k=k+1;
    if k==30, k=1; end
end

save('stimuli_FB_10AFC','stim','label')

end