function makeGUGeneralizationStim_openSet

nStimPerBlock = 60;

load('stimuli/wordlist_generalization.mat');


stim = {};
label = {};
for w=1:(length(wordlist))
    load(['stimuli/FB_generalization/' wordlist{w} '.mat']);
    label{w,1} = wordlist{w};
    stim{w,1} = s;
    stim{w,2} = t;
end
%duplicate stimuli
stim = repmat(stim,nStimPerBlock/length(stim),1);
label = repmat(label,nStimPerBlock/length(label),1);

save('stimuli_FB_generalization_openSet','stim','label')

end