count = zeros(5,1);

for i_stim=1:length(trialOutput.stimuli)
    
    if strcmp(trialOutput.stimuli{i_stim}(1),'apa') && strcmp(trialOutput.stimuli{i_stim}(2),'ata')
        count(1,1) = count(1,1) + 1;
    elseif strcmp(trialOutput.stimuli{i_stim}(1),'aba') && strcmp(trialOutput.stimuli{i_stim}(2),'aga')
        count(2,1) = count(2,1) + 1;
    elseif strcmp(trialOutput.stimuli{i_stim}(1),'ava') && strcmp(trialOutput.stimuli{i_stim}(2),'aza')
        count(3,1) = count(3,1) + 1;
    elseif strcmp(trialOutput.stimuli{i_stim}(1),'afa') && strcmp(trialOutput.stimuli{i_stim}(2),'asa')
        count(4,1) = count(4,1) + 1;
    elseif strcmp(trialOutput.stimuli{i_stim}(1),'ama') && strcmp(trialOutput.stimuli{i_stim}(2),'ana')
        count(5,1) = count(5,1) + 1;
    end
    
end