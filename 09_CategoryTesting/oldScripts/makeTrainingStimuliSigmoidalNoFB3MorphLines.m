%make training stimuli for categorization training
%June 15 2015
%Clara Scholl cas243@georgetown.edu

function makeTrainingStimuliSigmoidalNoFB_3MorphLines

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
    s1=[1 7 8];
    s2=[9 13 14];
    stimulator=[s1; s2];
   
   %%  
     %level 5 goes through all stimuli, once; so stimulators and category
     %don't match anymore
     level = [f1(1) f1(3) f1(5) f1(7) f1(8) f1(9) f1(13) f1(14) f1(15) f1(17) f1(19) f1(21);
              f2(1) f2(3) f2(5) f2(7) f2(8) f2(9) f2(13) f2(14) f2(15) f2(17) f2(19) f2(21)];
     %level=[f1(1:9) f1(13:21); f2(1:9) f2(13:21)]; %frequency combos (18 total)
     level=repmat(level, 1,12); 
     stimulators = [repmat(stimulator(:,1), 1,48) repmat(stimulator(:,2), 1,48) repmat(stimulator(:,3), 1,48)];
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
    trainingStimuli={level5};
    
    save ('trainingStimuliSigmoidalNoFB_3MorphLines.mat', 'trainingStimuli')

end