subjs = {'1028','1058','1062','1064','1072','1073'};
preOrPost = 'postT';
BDMs = {};

for i=1:length(subjs)
   data_path = dir(fullfile(subjs{i},preOrPost,'20*block7.mat'));
   load(fullfile(subjs{i},data_path(1).name));
   BDM_temp = zeros(6);
   
   for b=1:length(trialOutput)
        for s=1:length(trialOutput(b).stimuli)
            if (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 93)
                BDM_temp(1,2) = BDM_temp(1,2) + trialOutput(b).ac
            end
        end
   end
   
end