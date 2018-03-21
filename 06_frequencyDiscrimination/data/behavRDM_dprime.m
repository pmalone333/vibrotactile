subjs = {'1028','1058','1062','1064','1072','1073','1103','1106','1108','1112'};
%subjs = {'1028','1058','1062','1064','1072','1106'};
preOrPost = 'preT';
BDMs = zeros(6,6,length(subjs));
%BDMs = {};

for i=1:length(subjs)
   data_path = dir(fullfile(subjs{i},preOrPost,'20*block7.mat'));
   load(fullfile(subjs{i},preOrPost,data_path(1).name));
   BDM_temp_hit = zeros(6);
   BDM_temp_miss = zeros(6);
   BDM_temp_fa = zeros(6);
   BDM_totalTrials = zeros(6);
   BDM_totalTrials_fa = zeros(6);
   
   for b=1:length(trialOutput)
        for s=1:length(trialOutput(b).RT)
            if (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 93)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(1,2) = BDM_temp_hit(1,2) + 1;
                else
                    BDM_temp_miss(1,2) = BDM_temp_miss(1,2) + 1;
                end
                BDM_totalTrials(1,2) = BDM_totalTrials(1,2) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 93)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(1,3) = BDM_temp_hit(1,3) + 1;
                else
                    BDM_temp_miss(1,3) = BDM_temp_miss(1,3) + 1;
                end
                BDM_totalTrials(1,3) = BDM_totalTrials(1,3) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 40) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 93)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(1,4) = BDM_temp_hit(1,4) + 1;
                else
                    BDM_temp_miss(1,4) = BDM_temp_miss(1,4) + 1;
                end
                BDM_totalTrials(1,4) = BDM_totalTrials(1,4) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 93)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(1,5) = BDM_temp_hit(1,5) + 1;
                else
                    BDM_temp_miss(1,5) = BDM_temp_miss(1,5) + 1;
                end
                BDM_totalTrials(1,5) = BDM_totalTrials(1,5) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 93)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(1,6) = BDM_temp_hit(1,6) + 1;
                else
                    BDM_temp_miss(1,6) = BDM_temp_miss(1,6) + 1;
                end
                BDM_totalTrials(1,6) = BDM_totalTrials(1,6) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 75)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(2,1) = BDM_temp_hit(2,1) + 1;
                else
                    BDM_temp_miss(2,1) = BDM_temp_miss(2,1) + 1;
                end
                BDM_totalTrials(2,1) = BDM_totalTrials(2,1) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 75)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(2,3) = BDM_temp_hit(2,3) + 1;
                else
                    BDM_temp_miss(2,3) = BDM_temp_miss(2,3) + 1;
                end
                BDM_totalTrials(2,3) = BDM_totalTrials(2,3) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 40) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 75)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(2,4) = BDM_temp_hit(2,4) + 1;
                else
                    BDM_temp_miss(2,4) = BDM_temp_miss(2,4) + 1;
                end
                BDM_totalTrials(2,4) = BDM_totalTrials(2,4) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 75)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(2,5) = BDM_temp_hit(2,5) + 1;
                else
                    BDM_temp_miss(2,5) = BDM_temp_miss(2,5) + 1;
                end
                BDM_totalTrials(2,5) = BDM_totalTrials(2,5) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 75)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(2,6) = BDM_temp_hit(2,6) + 1;
                else
                    BDM_temp_miss(2,6) = BDM_temp_miss(2,6) + 1;
                end
                BDM_totalTrials(2,6) = BDM_totalTrials(2,6) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 61)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(3,1) = BDM_temp_hit(3,1) + 1;
                else
                    BDM_temp_miss(3,1) = BDM_temp_miss(3,1) + 1;
                end
                BDM_totalTrials(3,1) = BDM_totalTrials(3,1) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 61)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(3,2) = BDM_temp_hit(3,2) + 1;
                else
                    BDM_temp_miss(3,2) = BDM_temp_miss(3,2) + 1;
                end
                BDM_totalTrials(3,2) = BDM_totalTrials(3,2) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 40) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 61)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(3,4) = BDM_temp_hit(3,4) + 1;
                else
                    BDM_temp_miss(3,4) = BDM_temp_miss(3,4) + 1;
                end
                BDM_totalTrials(3,4) = BDM_totalTrials(3,4) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 61)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(3,5) = BDM_temp_hit(3,5) + 1;
                else
                    BDM_temp_miss(3,5) = BDM_temp_miss(3,5) + 1;
                end
                BDM_totalTrials(3,5) = BDM_totalTrials(3,5) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 61)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(3,6) = BDM_temp_hit(3,6) + 1;
                else
                    BDM_temp_miss(3,6) = BDM_temp_miss(3,6) + 1;
                end
                BDM_totalTrials(3,6) = BDM_totalTrials(3,6) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 40)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(4,5) = BDM_temp_hit(4,5) + 1;
                else
                    BDM_temp_miss(4,5) = BDM_temp_miss(4,5) + 1;
                end
                BDM_totalTrials(4,5) = BDM_totalTrials(4,5) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 40)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(4,6) = BDM_temp_hit(4,6) + 1;
                else
                    BDM_temp_miss(4,6) = BDM_temp_miss(4,6) + 1;
                end
                BDM_totalTrials(4,6) = BDM_totalTrials(4,6) + 1;
            elseif (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 26) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 32)
                if trialOutput(b).accuracy(s)==1
                    BDM_temp_hit(5,6) = BDM_temp_hit(5,6) + 1;
                else
                    BDM_temp_miss(5,6) = BDM_temp_miss(5,6) + 1;
                end
                BDM_totalTrials(5,6) = BDM_totalTrials(5,6) + 1;
            end
        end
   end
   
   
   
   
   for b=1:length(trialOutput)
       for s=1:length(trialOutput(b).RT)
           if trialOutput(b).correctResponse(s)==1
               if (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 75)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(1,2) = BDM_temp_fa(1,2) + 1;
                   end
                   BDM_totalTrials_fa(1,2) = BDM_totalTrials_fa(1,2) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 61)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(1,3) = BDM_temp_fa(1,3) + 1;
                   end
                   BDM_totalTrials_fa(1,3) = BDM_totalTrials_fa(1,3) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 40)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(1,4) = BDM_temp_fa(1,4) + 1;
                   end
                   BDM_totalTrials_fa(1,4) = BDM_totalTrials_fa(1,4) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 32)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(1,5) = BDM_temp_fa(1,5) + 1;
                   end
                   BDM_totalTrials_fa(1,5) = BDM_totalTrials_fa(1,5) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 93) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 26)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(1,6) = BDM_temp_fa(1,6) + 1;
                   end
                   BDM_totalTrials_fa(1,6) = BDM_totalTrials_fa(1,6) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 93)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(2,1) = BDM_temp_fa(2,1) + 1;
                   end
                   BDM_totalTrials_fa(2,1) = BDM_totalTrials_fa(2,1) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 61)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(2,3) = BDM_temp_fa(2,3) + 1;
                   end
                   BDM_totalTrials_fa(2,3) = BDM_totalTrials_fa(2,3) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 40)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(2,4) = BDM_temp_fa(2,4) + 1;
                   end
                   BDM_totalTrials_fa(2,4) = BDM_totalTrials_fa(2,4) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 32)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(2,5) = BDM_temp_fa(2,5) + 1;
                   end
                   BDM_totalTrials_fa(2,5) = BDM_totalTrials_fa(2,5) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 75) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 26)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(2,6) = BDM_temp_fa(2,6) + 1;
                   end
                   BDM_totalTrials_fa(2,6) = BDM_totalTrials_fa(2,6) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 93 && floor(trialOutput(b).stimuli(5,s)) == 93)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(3,1) = BDM_temp_fa(3,1) + 1;
                   end
                   BDM_totalTrials_fa(3,1) = BDM_totalTrials_fa(3,1) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 75 && floor(trialOutput(b).stimuli(5,s)) == 75)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(3,2) = BDM_temp_fa(3,2) + 1;
                   end
                   BDM_totalTrials_fa(3,2) = BDM_totalTrials_fa(3,2) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 40)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(3,4) = BDM_temp_fa(3,4) + 1;
                   end
                   BDM_totalTrials_fa(3,4) = BDM_totalTrials_fa(3,4) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 32)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(3,5) = BDM_temp_fa(3,5) + 1;
                   end
                   BDM_totalTrials_fa(3,5) = BDM_totalTrials_fa(3,5) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 61 && floor(trialOutput(b).stimuli(5,s)) == 61) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 26)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(3,6) = BDM_temp_fa(3,6) + 1;
                   end
                   BDM_totalTrials_fa(3,6) = BDM_totalTrials_fa(3,6) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 40) || (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 32)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(4,5) = BDM_temp_fa(4,5) + 1;
                   end
                   BDM_totalTrials_fa(4,5) = BDM_totalTrials_fa(4,5) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 40 && floor(trialOutput(b).stimuli(5,s)) == 40) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 26)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(4,6) = BDM_temp_fa(4,6) + 1;
                   end
                   BDM_totalTrials_fa(4,6) = BDM_totalTrials_fa(4,6) + 1;
               end
               if (floor(trialOutput(b).stimuli(1,s)) == 32 && floor(trialOutput(b).stimuli(5,s)) == 32) || (floor(trialOutput(b).stimuli(1,s)) == 26 && floor(trialOutput(b).stimuli(5,s)) == 26)
                   if trialOutput(b).accuracy(s)==0
                       BDM_temp_fa(5,6) = BDM_temp_fa(5,6) + 1;
                   end
                   BDM_totalTrials_fa(5,6) = BDM_totalTrials_fa(5,6) + 1;
               end
           end
       end
   end
   
   
   
   BDM_temp_hit = BDM_temp_hit + BDM_temp_hit';
   BDM_temp_miss = BDM_temp_miss + BDM_temp_miss';
   BDM_temp_fa = BDM_temp_fa + BDM_temp_fa';
   BDM_totalTrials = BDM_totalTrials + BDM_totalTrials';    
   BDM_totalTrials_fa = BDM_totalTrials_fa + BDM_totalTrials_fa';
   hr = BDM_temp_hit ./ BDM_totalTrials;
   mr = BDM_temp_miss ./ BDM_totalTrials;
   fa = BDM_temp_fa ./ BDM_totalTrials_fa;
   hr(hr==1) = 0.99;
   mr(mr==0) = 0.01;
   hr(hr==0) = 0.01;
   mr(mr==1) = 0.99;
   fa(fa==1) = 0.99;
   fa(fa==0) = 0.01;
   tmp = norminv(hr)-norminv(fa);
   %BDMs{i} = tmp;
   BDMs(:,:,i) = tmp;
   BDMs(isnan(BDMs)) = 0;
   meanBDM = mean(BDMs,3);
end