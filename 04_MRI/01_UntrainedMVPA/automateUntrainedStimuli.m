function automateUntrainedStimuli(nRuns,response)

nCond = 8;
if (nargin < 1) 
    nRuns = 6; 
    response = 1;
end

%% Define the session master matrix.
% This is an nConditions-x-nRuns matrix specifying which condition will have
% an oddball during which run. 

sessionMatrix = zeros(nCond,nRuns);
sessionMatrix(:,1:4) = 1;
% sessionMatrix(1:4,5) = 1;

% Randomize the whole matrix
allRandomized = [];
while isempty(allRandomized)
    for iRow = 1:nCond
        if length(find(sum(sessionMatrix,1) == 5)) == 4 && ...
           length(find(sum(sessionMatrix,1) == 6)) == 2
            allRandomized = 1;
            fprintf('Randomized the whole matrix\n');
            break
        else
            % randomize on
            topIdx = randperm(6);
            sessionMatrix(iRow,:) = sessionMatrix(iRow,topIdx);        
        end
    end
end

% Do a final check
assert(isequal(sum(sessionMatrix,2),[4;4;4;4;4;4;4;4]),...
        'Did not pass final check!')

%% Generate the raw matrix of stimuli for each run and a raw metadata struct.
[stimuliAllRuns,allFreq,~,oddChannels] = makeUntrainedOddballStimuli(nRuns,response);

% Make meta data
metaData = cell(1,nRuns);

for iRun = 1:nRuns
    metaData{iRun}.dataKey(:,1) = stimuliAllRuns{1}(:,1);
    metaData{iRun}.dataKey(:,2) = mat2cell([1:8 1:8 1:8]',ones(1,24),1);
    metaData{iRun}.conditionIndices = [1:8 1:8 1:8]';
    metaData{iRun}.oddballPosition = zeros(1,24)';
end

%% Populate the run matrix with oddballs and randomize its location

for iRun = 1:nRuns
    oddIdx = find(sessionMatrix(:,iRun) == 1);
    metaData{iRun}.oddballPosition(oddIdx) = 1;
    
    % Populate the second column with oddballs.
    for iOddIdx = 1:length(oddIdx)
        oddStimuli = [allFreq(end) allFreq(end) allFreq(end); oddChannels];
        % Write the oddball stimuli in the second column of the run matrix.
        stimuliAllRuns{iRun}{oddIdx(iOddIdx),2} = oddStimuli;
    end
    
    % Now randomize the oddball position within blocks, until oddball is
    % repeated twice only on one trial positions.
    oddballSpread = [];
    sumLength = sum(cellfun(@length,stimuliAllRuns{iRun}(:,6)),1); 
    % sumLength is the sum of the lengths of each cell in column 6. As long
    % as that sum is 48 that means there is no oddball in that column. The
    % while loop below loops until no column sumLength is 48, so every
    % column has an oddball!
                                                                   
    while isempty(oddballSpread)
        for iOddIdx = 1:length(oddIdx)
        oddBlock = oddIdx(iOddIdx);
           if ~ismember(sumLength,sum(cellfun(@length,stimuliAllRuns{iRun}(:,2:6)),1))
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
    
    % Finally, randomize the blocks so that you get two oddball blocks
    % in the first 8, second 8, and third 8 blocks. 
    blocksSpread = [];
    sumLength2 = sum(cellfun(@length,stimuliAllRuns{iRun}(1:8,1)),1);
    % sumLength2 is sum of lengths of each cell within one column of 8
    % rows, where none of the cells are the oddball.
    while isempty(blocksSpread)
       if numel(find(sum(cellfun(@length,stimuliAllRuns{iRun}(1:8,  2:6)),1) > sumLength2)) >= 1 && ...
          numel(find(sum(cellfun(@length,stimuliAllRuns{iRun}(9:16, 2:6)),1) > sumLength2)) >= 1 && ...
          numel(find(sum(cellfun(@length,stimuliAllRuns{iRun}(17:24,2:6)),1) > sumLength2)) >= 1
               
           blockSpread = 1;
           display('Blocks have been spread too!')
           break 
       else
            blockIdx = randperm(24);
            stimuliAllRuns{iRun}            = stimuliAllRuns{iRun}           (blockIdx,:);
            metaData{iRun}.conditionIndices = metaData{iRun}.conditionIndices(blockIdx,:);
            metaData{iRun}.oddballPosition  = metaData{iRun}.oddballPosition (blockIdx,:);            
       end
    end
end

%% Do final check that everything looks alright.
% for iRun = 1:nRuns
%     % Does each run have 6 oddballs?
%     if length(find(cellfun(@length,stimuliAllRuns{iRun}) == 3)) ~= 6 
%         error = input(['something is wrong with run ' int2str(iRun) ' oddballs']);
%     else
%         display('oddball numbers are correct')
%     end
% end
%% Save the matrix and metadata
save(['./stimuliAllRunsRP' int2str(response) '.mat'],'stimuliAllRuns','metaData');

end

