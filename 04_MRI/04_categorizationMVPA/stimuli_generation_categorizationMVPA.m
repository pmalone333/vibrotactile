function stimuliAllRuns = stimuli_generation_categorizationMVPA(nRuns)

if (nargin < 1) 
    nRuns = 6; 
end

%% Generate the raw matrix of stimuli for each run and a raw metadata struct.
[stimuliAllRuns] = makeCategorizationMVPAStimuli(nRuns);

% Make meta data
metaData = cell(1,nRuns);

for iRun = 1:nRuns
    metaData{iRun}.dataKey(:,1) = stimuliAllRuns{1}(:,1);
    metaData{iRun}.dataKey(:,2) = mat2cell([1:7 1:7 1:7 1:7]',ones(1,28),1);
    metaData{iRun}.conditionIndices = [1:7 1:7 1:7 1:7]';
end

%% Shuffle the categories within each run
for iRun = 1:nRuns
        blockIdx = randperm(28);
        stimuliAllRuns{iRun}            = stimuliAllRuns{iRun}           (blockIdx,:);
        metaData{iRun}.conditionIndices = metaData{iRun}.conditionIndices(blockIdx,:);
end
%% Save the matrix and metadata
save('./stimuliAllRuns_categorizationMVPA.mat','stimuliAllRuns','metaData');

end

