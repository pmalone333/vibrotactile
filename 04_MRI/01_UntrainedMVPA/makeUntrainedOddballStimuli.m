function [stimuliAllRunsRaw,allFreq,frequency,oddChannels] = makeUntrainedOddballStimuli(nRuns, response)
dbstop if error;
if (nargin < 1)
    nRuns = 6;
    response = 0;
end
nTrials = 6;

    if response == 0
        position = [5 9 5 9];
        oddChannels = [1 7 13];
    elseif response == 1
        position = [6 10 6 10];
        oddChannels = [2 8 14];
    end

    %creat category prototype frequncies 
    allFreq=2.^([0:.1:2]+log2(25)); 
%     f2=fliplr(f1);
    frequency = [allFreq(2), allFreq(8), allFreq(14), allFreq(20)];
    
    freqMatrix = [frequency' position'; frequency' flipud(position')];
    
    for iFreq = 1:size(freqMatrix,1)
        freqMatCell{iFreq,1} = [freqMatrix(iFreq,1); freqMatrix(iFreq,2)];
    end
    
    stimuliAllRunsRaw{1} = repmat(freqMatCell,3,nTrials);
    stimuliAllRunsRaw = repmat(stimuliAllRunsRaw,1,nRuns);
    
end