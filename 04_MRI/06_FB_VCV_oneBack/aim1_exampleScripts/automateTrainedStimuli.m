function stimuliAllRuns = automateTrainedStimuli(nRuns)

nCond = 7;
if (nargin < 1) 
    nRuns = 6; 
end

%% Define the session master matrix.
% This is an nConditions-x-nRuns matrix specifying which condition will have
% an oddball during which run. 

sessionMatrix = zeros(nCond,nRuns);
sessionMatrix(1:7,1:4) = 1;
sessionMatrix(1:2,5) = 1;


% Randomize top half of the matrix
matrixRandomized = [];
while isempty(matrixRandomized)
    for iRow = 1:nCond
        if isequal(sum(sessionMatrix(1:nCond,:),1),[5 5 5 5 5 5])
            matrixRandomized = 1;
            fprintf('Randomized the top half\n');
            break
        else
            % randomize on
            topIdx = randperm(6);
            sessionMatrix(iRow,:) = sessionMatrix(iRow,topIdx);        
        end
    end
end

% Do a final check
if isequal(sum(sessionMatrix,1),[5 5 5 5 5 5]) &&...
        isequal(sum(sessionMatrix,2),[5 5 4 4 4 4 4]')
    fprintf('Passed the final check!\n')
else 
    error = input('Did not pass final check\n');
end


%% Generate the raw matrix of stimuli for each run and a raw metadata struct.
[stimuliAllRuns,f1,oddChannels] = makeTrainedOddballStimuli(nRuns);

% Make meta data
metaData = cell(1,nRuns);

for iRun = 1:nRuns
    metaData{iRun}.dataKey(:,1) = stimuliAllRuns{1}(:,1);
    metaData{iRun}.dataKey(:,2) = mat2cell([1:7 1:7 1:7 1:7]',ones(1,28),1);
    metaData{iRun}.conditionIndices = [1:7 1:7 1:7 1:7]';
    metaData{iRun}.oddballPosition = zeros(1,28)';
end

%% Populate the run matrix with oddballs and randomize its location

for iRun = 1:nRuns
    oddIdx = find(sessionMatrix(:,iRun) == 1);
    metaData{iRun}.oddballPosition(oddIdx) = 1;
    
    % Populate the second column with oddballs.
    for iOddIdx = 1:length(oddIdx)
%         % Is the oddball block f1 or f2 stimulus?
%         if stimuliAllRuns{iRun}{oddIdx(iOddIdx),1}(1) == f1
%             oddStimuli = [f2 f2 f2; oddChannels];
%         else
%             oddStimuli = [f1 f1 f1; oddChannels];
%         end
        oddStimuli = [f1(end) f1(end) f1(end); oddChannels];
        % Write the oddball stimuli in the second column of the run matrix.
        stimuliAllRuns{iRun}{oddIdx(iOddIdx),2} = oddStimuli;
    end
    
    % Now randomize the oddball position within blocks, until oddball is
    % repeated twice only on one trial positions.
    oddballSpread = [];
    while isempty(oddballSpread)
        for iOddIdx = 1:length(oddIdx)
        oddBlock = oddIdx(iOddIdx);
           if ~ismember(112,sum(cellfun(@length,stimuliAllRuns{iRun}(:,2:6)),1))
               oddballSpread = 1;
               display('Oddball spread within blocks!')
               break
           else 
              trialIdx = randperm(5) + 1; % because we skip 1st column.
              stimuliAllRuns{iRun}(oddBlock,2:end) = ...
              stimuliAllRuns{iRun}(oddBlock,trialIdx);
           end
        end
    end
    
    % Finally, randomize the blocks so that you get at least 1 oddball block
    % in the first 7, second 7, and third 7 and fourth 7 blocks. 
    blocksSpread = [];
    while isempty(blocksSpread)
       if numel(find(sum(cellfun(@length,stimuliAllRuns{iRun}(1:7,  2:6)),1) < 28)) >= 1 && ...
          numel(find(sum(cellfun(@length,stimuliAllRuns{iRun}(8:14, 2:6)),1) < 28)) >= 1 && ...
          numel(find(sum(cellfun(@length,stimuliAllRuns{iRun}(15:21,2:6)),1) < 28)) >= 1 && ...
          numel(find(sum(cellfun(@length,stimuliAllRuns{iRun}(22:28,2:6)),1) < 28)) >= 1
               
           blockSpread = 1;
           display('Blocks have been spread too!')
           break 
       else
            blockIdx = randperm(28);
            stimuliAllRuns{iRun} = stimuliAllRuns{iRun}          (blockIdx,:);
            metaData{iRun}.conditionIndices = metaData{iRun}.conditionIndices     (blockIdx,:);
            metaData{iRun}.oddballPosition = metaData{iRun}.oddballPosition(blockIdx,:);            
       end
    end
end

%% Do final check that everything looks alright.


for iRun = 1:nRuns
    % Does each run have 5 oddballs?
    if length(find(cellfun(@length,stimuliAllRuns{iRun}) == 3)) ~= 5
        error = input(['something is wrong with run ' int2str(iRun) ' oddballs']);
    else
        display('oddball numbers are correct')
    end
end
%% Save the matrix and metadata
save(['./stimuliAllRuns.mat'],'stimuliAllRuns','metaData');

end

