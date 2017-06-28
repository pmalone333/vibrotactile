%present the training stimulus
%f1 gives frequency of stimulator p1
%f2 gives frequency of stimulator p2
%p1 gives position of f1
%p2 gives position of f2
%Clara Scholl cas243 2015

function constructCategoryTrainingStimulus(stimulus)
    
    f1=stimulus(1);
    f2=stimulus(2);
    p1=stimulus(3);
    p2=stimulus(4);

    stim = {...
        {'fixed',f1,1,300},...
        {'fixchan',p1},...
        {'fixed',f2,1,300},...
        {'fixchan',p2},...
        };
    [t,s]=buildTSM_nomap(stim);
    
    stimGen('load',s,t);
    rtn=-1;
    while rtn==-1
        rtn=stimGen('start');
    end
end