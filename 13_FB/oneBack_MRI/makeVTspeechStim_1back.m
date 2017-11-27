function makeVTspeechStim_1back(stimType)
% stimType; 0=GU algorithm, 1=FB algorithm
nRuns = 7;
nStimPerRun = 111; % number of stimuli presented in 6 second block 
nOneBacks = 12; % number of one back trials

labels = {'sand','tanned','mask','teams','toads','dense','most','nest','dance','spit','spin'...
    ,'stoop','meat','peace','nose','send','tend','max','seems','zones','nets','meant','mist'...
    ,'maps','snip','skin','stoke','peat','knees','soak','null','null','null'};
labels = labels';

% convert stimulus files into format for stimulator box 
stim = cell(length(labels),1);
for i=1:length(labels)
    if strcmp(labels{i},'null')
       stim{i}{1} = 'null';
       stim{i}{2} = 'null';
       continue
    end
    if stimType==1
        load(['stimuli/GU/' labels{i}]);
    elseif stimType==2
        load(['stimuli/FB/' labels{i}]);
    end
%     t = tactStim{1}{1};
%     t = t/4; % changed because of a slower sampling rate on new pulseCapture software 
%     s = tactStim{1}{2};
%     s = remapChanVoc(s); % mapping function from Silvio
    stim{i}{1} = t;
    stim{i}{2} = s;
    clear tactStim tm ch
end

%% replicate stimuli for all trials in run
stim = repmat(stim,floor((nStimPerRun-nOneBacks)/length(stim)),nRuns);
labels = repmat(labels,floor((nStimPerRun-nOneBacks)/length(labels)),nRuns);
j = 1;


%% add one back stimuli randomly throughout each run
stim2 = {};
labels2 = {};
for i_run=1:size(labels,2)
    l = labels(:,i_run);
    s = stim(:,i_run);
    % randomize order
    order = randperm(size(l,1));
    s = s(order);
    l = l(order);
    for j=1:nOneBacks
        tmp_l = l;
        tmp_s = s;
        arr = 1:length(tmp_l)-1;
        ind = datasample(arr,1);
        while strcmp(l{ind},'null') | strcmp(l{ind+1},'null')
            arr = 1:length(tmp_l)-1;
            ind = datasample(arr,1);
        end
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



%% test number of 1backs
count = zeros(nRuns,1);
for i_run=1:nRuns
    for j=1:size(labels2,1)-1
        if strcmp(labels2{j,i_run},labels2{j+1,i_run})
           count(i_run) = count(i_run)+1; 
        end
    end
end

save('VTspeechStim_1back','stim2','labels2');

end