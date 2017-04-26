subjs = {'1034','1036','940','1038','1043','1040','1058','1062','1064','1028'};
catA_RT_all = [];
catB_RT_all = [];

for i=1:length(subjs)
   data_path = dir(fullfile(subjs{i},'20*block6.mat'));
   load(fullfile(subjs{i},data_path(1).name));
   
   for b=1:length(trialOutput)
      catA_RT(b) = median(trialOutput(1).RT(trialOutput(b).stimuli(5,:)==1));
      catB_RT(b) = median(trialOutput(1).RT(trialOutput(b).stimuli(5,:)==2));
   end
   
catA_RT_all(i) = mean(catA_RT);
catB_RT_all(i) = mean(catB_RT);
clear catA_RT catB_RT
end