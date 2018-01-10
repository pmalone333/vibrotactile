
nStimPerBlock = 60;

tmp = importdata('trainingset-editdistanceFB.csv');
dm = tmp.data;
load('wordlist_train.mat');

%% levels 1-3; 2-AFC

thresh = [3,2,0]; %dissimilarity threshold for levels 1-3

stim = {};
label = {};
for l=1:length(thresh)
    ind = find(dm>thresh(1));
    if l==2
        ind2 = find(dm>=thresh(2) & dm<=thresh(1));
        ind2 = repmat(ind2(1:244),2,1);
        ind = [ind; ind2];
    elseif l==3
        ind2 = find(dm>=thresh(2) & dm<=thresh(1));
        ind2 = repmat(ind2(1:244),2,1);
        ind3 = find(dm>=thresh(3) & dm<=thresh(2));
        ind3 = [ind3; ind3(1:20)];
        ind3 = repmat(ind3,3,1);
        ind = [ind; ind2; ind3];
    end
    [rows, columns] = ind2sub(size(dm), ind);
    k=1;
    for w=1:(length(wordlist)*2)
        load(['GU/' wordlist{k} '.mat']);
        label{l}{w,1} = wordlist{k};
        stim{l}{w,1} = s;
        stim{l}{w,2} = t;
        % get index of words with > thresh1 dissimilarity
        i = rows(columns==k);
        order = randperm(length(i));
        i = i(order); % randomize order of array
        load(['GU/' wordlist{i(1)} '.mat']);
        label{l}{w,2} = wordlist{i(1)};
%         stim{l}{w,3} = s;
%         stim{l}{w,4} = t;
        k=k+1;
        if k==31, k=1; end
    end
    %duplicate stimuli
    stim{l} = repmat(stim{l},nStimPerBlock/length(stim{l}),1);
    label{l} = repmat(label{l},nStimPerBlock/length(label{l}),1);
end

%% levels 4-6; 3-AFC

thresh = [3,2,0]; %dissimilarity threshold for levels 1-3

stim2 = {};
label2 = {};
for l=1:length(thresh)
    ind = find(dm>thresh(1));
    if l==2
        ind2 = find(dm>=thresh(2) & dm<=thresh(1));
        ind2 = repmat(ind2(1:244),2,1);
        ind = [ind; ind2];
    elseif l==3
        ind2 = find(dm>=thresh(2) & dm<=thresh(1));
        ind2 = repmat(ind2(1:244),2,1);
        ind3 = find(dm>=thresh(3) & dm<=thresh(2));
        ind3 = [ind3; ind3(1:20)];
        ind3 = repmat(ind3,3,1);
        ind = [ind; ind2; ind3];
    end
    k=1;
    for w=1:(length(wordlist)*2)
        load(['GU/' wordlist{k} '.mat']);
        label2{l}{w,1} = wordlist{k};
        stim2{l}{w,1} = s;
        stim2{l}{w,2} = t;
        % get index of words with > thresh1 dissimilarity
        i = rows(columns==k);
        order = randperm(length(i));
        i = i(order); % randomize order of array
        load(['GU/' wordlist{i(1)} '.mat']);
        label2{l}{w,2} = wordlist{i(1)};
        label2{l}{w,3} = wordlist{i(2)};
        k=k+1;
        if k==30, k=1; end
    end
    %duplicate stimuli
%     stim2{l} = repmat(stim2{l},nStimPerBlock/length(stim2{l}),1);
%     label2{l} = repmat(label2{l},nStimPerBlock/length(label2{l}),1);
end

%% levels 7-9; 4-AFC

thresh = [3,2,0]; %dissimilarity threshold for levels 1-3

stim3 = {};
label3 = {};

for l=1:length(thresh)
    ind = find(dm>thresh(1));
    if l==2
        ind2 = find(dm>=thresh(2) & dm<=thresh(1));
        ind2 = repmat(ind2(1:244),2,1);
        ind = [ind; ind2];
    elseif l==3
        ind2 = find(dm>=thresh(2) & dm<=thresh(1));
        ind2 = repmat(ind2(1:244),2,1);
        ind3 = find(dm>=thresh(3) & dm<=thresh(2));
        ind3 = [ind3; ind3(1:20)];
        ind3 = repmat(ind3,3,1);
        ind = [ind; ind2; ind3];
    end
    k=1;
    for w=1:(length(wordlist)*2)
        load(['GU/' wordlist{k} '.mat']);
        label3{l}{w,1} = wordlist{k};
        stim3{l}{w,1} = s;
        stim3{l}{w,2} = t;
        % get index of words with > thresh1 dissimilarity
        i = rows(columns==k);
        order = randperm(length(i));
        i = i(order); % randomize order of array
        load(['GU/' wordlist{i(1)} '.mat']);
        label3{l}{w,2} = wordlist{i(1)};
        label3{l}{w,3} = wordlist{i(2)};
        label3{l}{w,4} = wordlist{i(3)};
        k=k+1;
        if k==30, k=1; end
    end
    %duplicate stimuli
%     stim3n{l} = repmat(stim3{l},nStimPerBlock/length(stim3{l}),1);
%     label3n{l} = repmat(label3{l},nStimPerBlock/length(label3{l}),1);
end

%% levels 10; 5-AFC

thresh = 0; %dissimilarity threshold

stim4 = {};
label4 = {};

ind = find(dm>thresh);
[rows, columns] = ind2sub(size(dm), ind);
k=1;
for w=1:(length(wordlist)*2)
    load(['GU/' wordlist{k} '.mat']);
    label4{1}{w,1} = wordlist{k};
    stim4{1}{w,1} = s;
    stim4{1}{w,2} = t;
    % get index of words with > thresh1 dissimilarity
    i = rows(columns==k);
    order = randperm(length(i));
    i = i(order); % randomize order of array
    load(['GU/' wordlist{i(1)} '.mat']);
    label4{1}{w,2} = wordlist{i(1)};
    label4{1}{w,3} = wordlist{i(2)};
    label4{1}{w,4} = wordlist{i(3)};
    label4{1}{w,5} = wordlist{i(4)};
    k=k+1;
    if k==30, k=1; end
end
%duplicate stimuli
% stim4n{1} = repmat(stim4,nStimPerBlock/length(stim4),1);
% label4n{1} = repmat(label4,nStimPerBlock/length(label4),1);


stim = [stim stim2 stim3 stim4];
label = [label label2 label3 label4];

save('stimuli_FB','stim','label')