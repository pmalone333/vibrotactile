%make training stimuli for categorization training
%June 15 2015
%Clara Scholl cas243@georgetown.edu

function makeWeightedTrainingStimuli3(prevAcc, prevStim, name)

    %dimensions are 240 stimuli x 4 parameters x 20 levels
    %the five columns (dimension 2) are:
    %column 1 -- f1, top stimulator frequency
    %column 2 -- f2, bottom stimulator frequency
    %column 3 -- p1, top stimulator position
    %column 4 -- p2, bottom stimulator position
    %column 5 -- category 1 or 2.
    
    %category 1 has lower frequency @ position closer to wrist
    %category 2 has lower frequency @ position closer to elbow
    
    %levels 1-5 repeat four times, with increasing accuracy requirements
    %required to advance (see levelAccuracy below).
    
    %find possible frequencies: 1/10th octave steps (5% steps along
    %frequency line)
    f1 = 2.^((0:.1:2)+log2(25));
    f2 = fliplr(f1);
    numFreqPairs = (length(f1));
    stimulator = [7; 13];
    
   %%
   for i = 1:numFreqPairs
       if ismember(i,[9,10,11,12,13]), continue; end
        f(i,:) = {prevAcc(prevStim(1,:) == f1(i))};
   end
   
   f = cellfun(@mean, f);
   [fSort, fMinInd] = sort(f);

   %%  
   f = [f1(fMinInd(1:2)), f1(22-fMinInd(1:2)); f1(22-fMinInd(1:2)), f1(fMinInd(1:2))];
   
   %level 5 goes through all stimuli, once; so stimulators and category
   %don't match anymore
   level=[f1(1:8) f1(14:21); f2(1:8) f2(14:21)]; %frequency combos (18 total)
   level=repmat(level, 1,5); %repeat 8 times (this is 128!)
   weightedLevel = [repmat(f(:,1),1,16), repmat(f(:,3),1,16), repmat(f(:,2),1,16), repmat(f(:,4),1,16)];
   
   level = [level, weightedLevel];
   
   stimulators = repmat(stimulator, 1,144);
   %label each stimulus as belonging to category 1 or 2
   for iStim=1:length(level)
       if level(1,iStim)<level(2,iStim)
           category(iStim)=1;
       else
           category(iStim)=2;
       end
   end
   
   level = [level; stimulators; category];
   
   %now combine the 5 levels into all 20 levels (repeating each 4 times)
   trainingStimuli={(level)};
   %trainingStimuli=cat(3,level1, level2, level3, level4, level5);
   %values in trainingStimuli by dimension:
   %DIM1 is [f1 f2 s1 s2 category]
   %DIM2 is trials (160 trials perlevel)
   %DIM3 is level -- there are 20 levels! The stimuli are the same in 1-5,
   %6-10, etc.
   if exist(['./history/' name],'dir')
   else
       mkdir(['./history/' name])
   end

   save (['./history/' name '/trainingStimuliWeight_' datestr(now, 'yyyymmdd_HHMM') '.mat'], 'trainingStimuli')

end