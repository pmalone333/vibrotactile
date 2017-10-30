function makeVTspeechStim_1back

nRuns = 6;
nStimPerRun = 96; % number of stimuli presented in 6 second block 
nOneBacks = 12; % number of one back trials

labels = {'ada1';'aza1';'aba1';'ata1';'ana1';...
    'ama1';'asa1';'apa1';'ava1';'afa1';'aga1';...
    'aka1'};

%% convert stimulus files into format for stimulator box 
stim = cell(length(labels),1);
for i=1:length(labels)
    load(['stimuli/' labels{i}]);
    tm = tactStim{1}{1};
    tm = tm/4; % changed because of a slower sampling rate on new pulseCapture software 
    ch = tactStim{1}{2};
    ch = remapChanVoc(ch); % mapping function from Silvio
    stim{i}{1} = tm;
    stim{i}{2} = ch;
    clear tactStim tm ch
end

%% replicate stimuli for all trials in run
stim = repmat(stim,floor((nStimPerRun-nOneBacks)/length(stim)),6);
labels = repmat(labels,floor((nStimPerRun-nOneBacks)/length(labels)),6);
j = 1;


%% add one back stimuli randomly throughout each run
stim2 = {};
labels2 = {};
for i_run=1:size(stim,2)
    l = labels(:,i_run);
    s = stim(:,i_run);
    % randomize order
    order = randperm(size(s,1));
    s = s(order);
    l = l(order);
    for j=1:nOneBacks
        tmp_l = l;
        tmp_s = s;
        arr = 1:length(tmp_l);
        ind = datasample(arr,1);
        l = tmp_l(1:ind);
        s = tmp_s(1:ind);
        l = [l; l(ind)]; %repeat stim at ind for 1back
        s = [s; s(ind)]; 
        l = [l; tmp_l(ind+1:end)];
        s = [s; tmp_s(ind+1:end)];
    end
    labels2(:,i_run) = l;
    stim2(:,i_run) = s;
end

% %% test number of 1backs
% count = zeros(6,1);
% for i_run=1:6
%     for j=1:size(labels2,1)-1
%         if strcmp(labels2{j,i_run},labels2{j+1,i_run})
%            count(i_run) = count(i_run)+1; 
%         end
%     end
% end

save('VTspeechStim_1back','stim2','labels2');

end