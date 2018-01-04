nStimPerBlock = 60;

tmp = importdata('rsaset.csv');
dm = tmp.data;
load('wordlist.mat');

%% levels 1-5; 2-AFC

thresh = [3.99, 3.49, 3, 2, 0]; %dissimilarity threshold for levels 1-5

stim = {};
label = {};
for l=1:5
    ind = find(dm>thresh(l));
    [rows, columns] = ind2sub(size(dm), ind);
    for w=1:length(wordlist)
        load(['GU/' wordlist{w} '.mat']);
        label{l}{w,1} = wordlist{w};
        stim{l}{w,1} = s;
        stim{l}{w,2} = t;
        % get index of words with > thresh1 dissimilarity
        i = rows(columns==w);
        order = randperm(length(i));
        i = i(order); % randomize order of array
        load(['GU/' wordlist{i(1)} '.mat']);
        label{l}{w,2} = wordlist{i(1)};
%         stim{l}{w,3} = s;
%         stim{l}{w,4} = t;
    end
    %duplicate stimuli
    stim{l} = repmat(stim{l},nStimPerBlock/length(stim{l}),1);
    label{l} = repmat(label{l},nStimPerBlock/length(label{l}),1);
end

%% levels 6-10; 3-AFC

thresh = [3.99, 3.49, 3, 2, 0]; %dissimilarity threshold for levels 6-10

stim2 = {};
label2 = {};
for l=1:5
    ind = find(dm>thresh(l));
    [rows, columns] = ind2sub(size(dm), ind);
    for w=1:length(wordlist)
        load(['GU/' wordlist{w} '.mat']);
        label2{l}{w,1} = wordlist{w};
        stim2{l}{w,1} = s;
        stim2{l}{w,2} = t;
        % get index of words with > thresh1 dissimilarity
        i = rows(columns==w);
        order = randperm(length(i));
        i = i(order); % randomize order of array
        load(['GU/' wordlist{i(1)} '.mat']);
        label2{l}{w,2} = wordlist{i(1)};
        label2{l}{w,3} = wordlist{i(2)};
    end
    %duplicate stimuli
    stim2{l} = repmat(stim2{l},nStimPerBlock/length(stim2{l}),1);
    label2{l} = repmat(label2{l},nStimPerBlock/length(label2{l}),1);
end

%% levels 11; 4-AFC

thresh = 0; %dissimilarity threshold

stim3 = {};
label3 = {};

ind = find(dm>thresh);
[rows, columns] = ind2sub(size(dm), ind);
for w=1:length(wordlist)
    load(['GU/' wordlist{w} '.mat']);
    label3{w,1} = wordlist{w};
    stim3{w,1} = s;
    stim3{w,2} = t;
    % get index of words with > thresh1 dissimilarity
    i = rows(columns==w);
    order = randperm(length(i));
    i = i(order); % randomize order of array
    load(['GU/' wordlist{i(1)} '.mat']);
    label3{w,2} = wordlist{i(1)};
    label3{w,3} = wordlist{i(2)};
    label3{w,4} = wordlist{i(3)};
end
%duplicate stimuli
stim3n{1} = repmat(stim3,nStimPerBlock/length(stim3),1);
label3n{1} = repmat(label3,nStimPerBlock/length(label3),1);

%% levels 12; 5-AFC

thresh = 0; %dissimilarity threshold

stim4 = {};
label4 = {};

ind = find(dm>thresh);
[rows, columns] = ind2sub(size(dm), ind);
for w=1:length(wordlist)
    load(['GU/' wordlist{w} '.mat']);
    label4{w,1} = wordlist{w};
    stim4{w,1} = s;
    stim4{w,2} = t;
    % get index of words with > thresh1 dissimilarity
    i = rows(columns==w);
    order = randperm(length(i));
    i = i(order); % randomize order of array
    load(['GU/' wordlist{i(1)} '.mat']);
    label4{w,2} = wordlist{i(1)};
    label4{w,3} = wordlist{i(2)};
    label4{w,4} = wordlist{i(3)};
    label4{w,5} = wordlist{i(4)};
end
%duplicate stimuli
stim4n{1} = repmat(stim4,nStimPerBlock/length(stim4),1);
label4n{1} = repmat(label4,nStimPerBlock/length(label4),1);


stim = [stim stim2 stim3n stim4n];
label = [label label2 label3n label4n];

save('stimuli_GU','stim','label')