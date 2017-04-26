function [stimuliAllRuns, f1, oddChannels] = makeTrainedOddballStimuli(numRuns)

if (nargin < 1)
    numRuns=6;
end

%     if response == 0
        s1=[7];
        s2=[13];
        position = [s1; s2];
        oddChannels = [2 8 14];
%     elseif response == 1
%         s1=[8];
%         s2=[14];
%         position =[s1; s2];
%         oddChannels = [1 7 13];
%     end

    %creat category prototype frequncies 
    f1=2.^([0:.1:2]+log2(25)); 
    f2=fliplr(f1);
    frequency = [f1(2), f1(5) f1(8), f1(11) f1(14), f1(17) f1(20);...
                 f2(2), f2(5) f2(8), f2(11) f2(14), f2(17) f2(20)];
    
    f_permutation = length(frequency) * size(position,2) + 1;
    permutation = 1;
    
    while permutation ~= f_permutation
        for j = 1:length(frequency)
            for i = 1:size(position,2)
                stimulator{permutation,:} = [frequency(:,j); position(:,i)];
                permutation = permutation +1;
            end
        end
    end

    for iRun = 1:numRuns
        
        %replicate 2X6 times for total number of stimuli 
        stimuli = repmat(stimulator,4,6);
          stimuliAllRuns{iRun} = stimuli;
          
          
    end
end