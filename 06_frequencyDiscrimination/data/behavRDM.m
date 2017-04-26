subjs = {'1028','1058','1062','1064','1072','1073'};
preOrPost = 'postT';
BDMs = zeros(length(subjs),6,6);

for i=1:length(subjs)
   data_path = dir(fullfile(subjs{i},preOrPost,'20*block7.mat'));
   load(fullfile(subjs{i},preOrPost,data_path(1).name));
   BDM_temp = zeros(6);
   BDM_totalTrials = zeros(6);
   
   for b=1:length(trialOutput)
        for s=1:length(trialOutput(b).RT)
            if (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 93)
                BDM_temp(1,2) = BDM_temp(1,2) + trialOutput(b).accuracy(s);
                BDM_totalTrials(1,2) = BDM_totalTrials(1,2) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 93)
                BDM_temp(1,3) = BDM_temp(1,3) + trialOutput(b).accuracy(s);
                BDM_totalTrials(1,3) = BDM_totalTrials(1,3) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 40) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 93)
                BDM_temp(1,4) = BDM_temp(1,4) + trialOutput(b).accuracy(s);
                BDM_totalTrials(1,4) = BDM_totalTrials(1,4) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 93)
                BDM_temp(1,5) = BDM_temp(1,5) + trialOutput(b).accuracy(s);
                BDM_totalTrials(1,5) = BDM_totalTrials(1,5) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 93)
                BDM_temp(1,6) = BDM_temp(1,6) + trialOutput(b).accuracy(s);
                BDM_totalTrials(1,6) = BDM_totalTrials(1,6) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 75)
                BDM_temp(2,1) = BDM_temp(2,1) + trialOutput(b).accuracy(s);
                BDM_totalTrials(2,1) = BDM_totalTrials(2,1) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 75)
                BDM_temp(2,3) = BDM_temp(2,3) + trialOutput(b).accuracy(s);
                BDM_totalTrials(2,3) = BDM_totalTrials(2,3) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 40) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 75)
                BDM_temp(2,4) = BDM_temp(2,4) + trialOutput(b).accuracy(s);
                BDM_totalTrials(2,4) = BDM_totalTrials(2,4) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 75)
                BDM_temp(2,5) = BDM_temp(2,5) + trialOutput(b).accuracy(s);
                BDM_totalTrials(2,5) = BDM_totalTrials(2,5) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 75)
                BDM_temp(2,6) = BDM_temp(2,6) + trialOutput(b).accuracy(s);
                BDM_totalTrials(2,6) = BDM_totalTrials(2,6) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 61)
                BDM_temp(3,1) = BDM_temp(3,1) + trialOutput(b).accuracy(s);
                BDM_totalTrials(3,1) = BDM_totalTrials(3,1) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 61)
                BDM_temp(3,2) = BDM_temp(3,2) + trialOutput(b).accuracy(s);
                BDM_totalTrials(3,2) = BDM_totalTrials(3,2) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 40) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 61)
                BDM_temp(3,4) = BDM_temp(3,4) + trialOutput(b).accuracy(s);
                BDM_totalTrials(3,4) = BDM_totalTrials(3,4) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 61)
                BDM_temp(3,5) = BDM_temp(3,5) + trialOutput(b).accuracy(s);
                BDM_totalTrials(3,5) = BDM_totalTrials(3,5) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 61)
                BDM_temp(3,6) = BDM_temp(3,6) + trialOutput(b).accuracy(s);
                BDM_totalTrials(3,6) = BDM_totalTrials(3,6) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 40)
                BDM_temp(4,5) = BDM_temp(4,5) + trialOutput(b).accuracy(s);
                BDM_totalTrials(4,5) = BDM_totalTrials(4,5) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 40)
                BDM_temp(4,6) = BDM_temp(4,6) + trialOutput(b).accuracy(s);
                BDM_totalTrials(4,6) = BDM_totalTrials(4,6) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 32)
                BDM_temp(5,6) = BDM_temp(5,6) + trialOutput(b).accuracy(s);
                BDM_totalTrials(5,6) = BDM_totalTrials(5,6) + 1;
            end
        end
   end
   BDM_temp = BDM_temp + BDM_temp';
   BDM_totalTrials = BDM_totalTrials + BDM_totalTrials';
   BDMs(:,:,i) = BDM_temp ./ BDM_totalTrials;
   BDMs(isnan(BDMs)) = 0;
   meanBDM = mean(BDMs,3);
end