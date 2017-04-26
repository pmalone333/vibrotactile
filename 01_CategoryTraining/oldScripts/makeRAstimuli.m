%make training stimuli for categorization training
%June 15 2015
%Clara Scholl cas243@georgetown.edu

function makeRAstimuli

    %dimensions are 240 stimuli x 4 parameters x 20 levels
    %the five columns (dimension 2) are:
    %column 1 -- f1, top stimulator frequency
    %column 2 -- f2, bottom stimulator frequency
    %column 3 -- p1, top stimulator position
    %column 4 -- p2, bottom stimulator position
    %column 5 -- category 1 or 2.
    
    %category 1 has lower frequency @ position closer to wrist
    %category 2 has lower frequency @ position closer to elbow
    
    %find possible frequencies: 1/10th octave steps (5% steps along
    %frequency line)
    f1=2.^([0:.1:2]+log2(25));
    f2=fliplr(f1);
    
    %find possible stimulator combinations (8 combos total)
    s1=[3 3];
    s2=[9 9];
    stimulator=[s1; s2];
   
   %%  
     %level 5 goes through all stimuli, once; so stimulators and category
     %don't match anymore
     level=[f1(2) f1(8) f1(14) f1(20); f1(20) f1(14) f1(8) f1(2)]; %frequency combos (18 total)
     level=repmat(level, 1,36); %repeat 8 times (this is 128!)
     stimulators = [repmat(stimulator(:,1), 1,72) repmat(stimulator(:,2), 1,72)];
    %label each stimulus as belonging to category 1 or 2
    for iStim=1:length(level)
        if level(1,iStim)<level(2,iStim)
            category(iStim)=1;
        else 
            category(iStim)=2;
        end
    end
    level5=[level; stimulators; category];
    %now combine the 5 levels into all 20 levels (repeating each 4 times)
    trainingStimuli={(level5) (level5) (level5) (level5) (level5) (level5)};
   
    %levelAccuracy gives the accuracy required to pass the level (1-20);
    levelAccuracy = repmat(.9,8,1);
    
    save ('trainingStimuliRA.mat', 'trainingStimuli', 'levelAccuracy')

end