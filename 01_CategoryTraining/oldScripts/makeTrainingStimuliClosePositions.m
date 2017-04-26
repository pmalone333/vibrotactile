%make training stimuli for categorization training
%June 15 2015
%Clara Scholl cas243@georgetown.edu

function makeTrainingStimuliHighFreq

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
    f1=2.^([0:.1:2]+log2(25));
    f2=fliplr(f1);
    
    %find possible stimulator combinations (8 combos total)
    s1=[1 1 1 1 1 1 1 1];
    s2=[9 9 9 9 9 9 9 9];
    stimulator=[s1; s2];
    
    %combine frequencies and stimulator combinations into stimuli for each
    %level
    
    %level 1 has 5 stimuli closest to prototypes at each position (10 stimuli), two
    %times
    level=[f1(1:4) f1(18:21); f2(1:4) f2(18:21)]; %frequency combos (8 total)
    level=repmat(level, 1,8); %repeat 8 times
    stimulators = [repmat(stimulator(:,1), 1,8) repmat(stimulator(:,2), 1,8) ...
                   repmat(stimulator(:,3), 1,8) repmat(stimulator(:,4), 1,8) ...
                   repmat(stimulator(:,5), 1,8) repmat(stimulator(:,6), 1,8) ...
                   repmat(stimulator(:,7), 1,8) repmat(stimulator(:,8), 1,8)];
    %label each stimulus as belonging to category 1 or 2
    for iStim=1:length(level)
        if level(1,iStim)<level(2,iStim)
            category(iStim)=1;
        else 
            category(iStim)=2;
        end
    end
    
    level1 = [level level; stimulators stimulators; category category];	
    clear level;
    
    %level 2 has frequencies at positions 1, 3, 5, 7, 9
    level=[f1(1:2:7) f1(15:2:21); f2(1:2:7) f2(15:2:21)]; %frequency combos (8 total)
    level=repmat(level, 1,8); %repeat 8 times
    level2=[level level; stimulators stimulators; category category];
    clear level;
   
    %level 3 has frequencies at positions 2, 4, 6, 9, 10 (position 11 is
    %the category boundary)
    level=[f1(2:2:8) f1(14:2:20); f2(2:2:8) f2(14:2:20)]; %frequency combos (8 total)
    level=repmat(level, 1,8); %repeat 8 times
    level3=[level level; stimulators stimulators; category category];
    clear level;

    %%
    %level 4 has frequencies at positions 6:10, 12:16;
     level=[f1(6:9) f1(13:16); f2(6:9) f2(13:16)]; %frequency combos (8 total)
     level=repmat(level, 1,8); %repeat 8 times
     level4=[level level; stimulators stimulators; category category];
     clear level stimulators category;
   
   %%  
     %level 5 goes through all stimuli, once; so stimulators and category
     %don't match anymore
     level=[f1(1:9) f1(13:21); f2(1:9) f2(13:21)]; %frequency combos (18 total)
     level=repmat(level, 1,8); %repeat 8 times (this is 128!)
     stimulators = [repmat(stimulator(:,1), 1,18) repmat(stimulator(:,2), 1,18) ...
                    repmat(stimulator(:,3), 1,18) repmat(stimulator(:,4), 1,18) ...
                    repmat(stimulator(:,5), 1,18) repmat(stimulator(:,6), 1,18) ...
                    repmat(stimulator(:,7), 1,18) repmat(stimulator(:,8), 1,18)];
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
    trainingStimuli={(level1) (level2) (level3) (level4) (level5)};
    %trainingStimuli=cat(3,level1, level2, level3, level4, level5);
    %values in trainingStimuli by dimension:
    %DIM1 is [f1 f2 s1 s2 category]
    %DIM2 is trials (160 trials perlevel)
    %DIM3 is level -- there are 20 levels! The stimuli are the same in 1-5,
    %6-10, etc.
    trainingStimuli=repmat(trainingStimuli,[1 3]);
   
    %levelAccuracy gives the accuracy required to pass the level (1-20);
    levelAccuracy=[repmat(.75,[1 3]) .70 .75 repmat(.8, [1 3]) .75 .80 repmat(.85, [1 3]) .80 .85];
    save ('trainingStimuliClosePositions.mat', 'trainingStimuli', 'levelAccuracy')

end