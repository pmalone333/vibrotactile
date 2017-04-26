function oddballPractice(response)
%     dbstop if error;
    if (nargin < 1) response = 1; end
    
    f1=2.^([0:.1:2]+log2(25));

    if response == 0
            position = [5 9];
            oddChannels = [1 7 13];
    elseif response == 1
            position = [6 10];
            oddChannels = [2 8 14];
    end
        
    frequency = [f1(2), f1(20)];    
        
    stimuliBlock = {[repmat(f1(21),1,3);  oddChannels], [frequency(1);position(1)], [frequency(1);position(1)], [frequency(1);position(1)], [frequency(1);position(1)], [frequency(1);position(1)];
                    [frequency(2);position(2)], [frequency(2);position(2)], [frequency(2);position(2)], [repmat(f1(21),1,3); oddChannels],  [frequency(2);position(2)],  [frequency(2);position(2)];...
                    [frequency(1);position(1)], [repmat(f1(21),1,3); oddChannels], [frequency(1);position(1)], [frequency(1);position(1)], [frequency(1);position(1)], [frequency(1);position(1)],};

    nBlocks = size(stimuliBlock,1);
    nTrials = size(stimuliBlock(1,:),2);
    
    for iBlock = 1:nBlocks
        if iBlock == 1
            waitSecs(5);
        end
        for iTrial = 1:nTrials
            constructStimuli(stimuliBlock(iBlock,:), iTrial)
            waitSecs(.7);
        end
        waitSecs(10);
    end
end

function constructStimuli(stimuliBlock, iTrial)

     if size(stimuliBlock{1,iTrial},2) > 1
        constructOddStimuli(stimuliBlock, iTrial)
     else
         
        f = stimuliBlock{1,iTrial}(1);
        p = stimuliBlock{1,iTrial}(2);


        stim = {...
            {'fixed',f(1),1,300},...
            {'fixchan',p(1)},...
            };
        
        [t,s]=buildTSM_nomap(stim);
        
        stimGenPTB('load',s,t);
        rtn=-1;
        while rtn==-1
            rtn=stimGenPTB('start');
        end
    end
end

function constructOddStimuli(stimuliBlock, iTrial)
    f = stimuliBlock{1,iTrial}(1,:);
    p = stimuliBlock{1,iTrial}(2,:);
    
    stim = {...
            {'fixed',f(1),1,90},...
            {'fixchan',p(1),1, 90},...
            {'fixed',f(1),100,190},...
            {'fixchan',p(2), 100,190},...
            {'fixed',f(1),200,290},...
            {'fixchan',p(3), 200,290},...
           };

    [t,s]=buildTSM_nomap(stim);    
       
    stimGenPTB('load',s,t);
    rtn=-1;
    while rtn==-1
        rtn = stimGenPTB('start');
    end
    
end