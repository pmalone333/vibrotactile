function makeSpatialLocFigs_dprime(sub,positionType,preOrPost,cfg)
    % patrick malone pmalone333@gmail.com 11/23/15
    % passed args sub must be string (i.e '900' for subj 900), if
    % cfg isn't passed it is created using config_subjects_VT.m 
    % positionType = 1 for odd positions, 2 for even 
    % preOrPost - 'preTrain' or 'postTrain'
    
    if exist('cfg','var') % if cfg was passed, use it; else, create one
        cfg = config_subjects_VT(cfg);
    else
        cfg = config_subjects_VT;
    end
    
    % change preTrain to post for post training figs
    data_path = dir(fullfile(cfg.dirs.behav_dir,sub,preOrPost,'spatialLoc','*block7.mat'));
    if size(data_path,1)>1, error('More than 1 spatial localization data structure found'), end
    load(fullfile(cfg.dirs.behav_dir,sub,preOrPost,'spatialLoc',data_path(1).name));

    %% d prime by block
    numBlocks = length(trialOutput);
    dPrimeByBlock = ones(numBlocks,1);
    for iBlock=1:numBlocks
        h = sum(trialOutput(iBlock).sResp(1:144) == 2 & trialOutput(iBlock).correctResponse(1:144) == 2)/sum(trialOutput(iBlock).correctResponse(1:144) == 2);
        fa = sum(trialOutput(iBlock).sResp(1:144) == 2 & trialOutput(iBlock).correctResponse(1:144) == 1)/sum(trialOutput(iBlock).correctResponse(1:144) == 1);
        dPrimeByBlock(iBlock) = calcDprime(h,fa);
        clear h fa
    end
    plot(dPrimeByBlock);
    xlabel('Block');
    ylabel('D prime');
    ylim([0 3.25])
    title(['Sub ' sub ' spatial localization d prime by block']);
    save(fullfile(cfg.dirs.behav_dir,sub,preOrPost,'spatialLoc',['sub' sub '_spatialLoc_' preOrPost '_dPrime']),'dPrimeByBlock');
    print(fullfile(cfg.dirs.behav_dir,sub,preOrPost,'spatialLoc',['sub' sub '_spatialLoc_' preOrPost '_dPrimeByBlock']),'-dpng');
    
    %% d prime by position 
    if positionType==1, pos=[2 4 6 10 12 14]; 
    else pos=[1 3 5 9 11 13];
    end
    dPrimeByPos = ones(length(pos),1);
    for p=1:length(pos)
        h = []; % hits
        fa = []; % false alarms
        for iBlock=1:numBlocks
           h = [h sum((floor(trialOutput(iBlock).stimuli(1,1:144)) == pos(p) | floor(trialOutput(iBlock).stimuli(3,1:144)) == pos(p)) & trialOutput(iBlock).sResp(1:144) == 2 & trialOutput(iBlock).correctResponse(1:144) == 2) / ... 
                   sum((floor(trialOutput(iBlock).stimuli(1,1:144)) == pos(p) | floor(trialOutput(iBlock).stimuli(3,1:144)) == pos(p)) & trialOutput(iBlock).correctResponse(1:144) == 2)]; 
           fa = [fa sum((floor(trialOutput(iBlock).stimuli(1,1:144)) == pos(p) | floor(trialOutput(iBlock).stimuli(3,1:144)) == pos(p)) & trialOutput(iBlock).sResp(1:144) == 2 & trialOutput(iBlock).correctResponse(1:144) == 1) / ... 
                    sum((floor(trialOutput(iBlock).stimuli(1,1:144)) == pos(p) | floor(trialOutput(iBlock).stimuli(3,1:144)) == pos(p)) & trialOutput(iBlock).correctResponse(1:144) == 1)]; 
        end
        if fa==0, fa=(1/sum(trialOutput(iBlock).stimuli(1,1:144) == pos(p))); end
        %if h==1, h=1-(1/sum(trialOutput(iBlock).stimuli(2,1:96) == pos(p))); end
        dPrimeByPos(p) = calcDprime(h,fa);
    end
    bar(dPrimeByPos);
    xlabel('Position');
    ylabel('D prime');
    ylim([0 3.25])
    title(['Sub ' sub ' spatial localization d prime by position']);
    set(gca,'XTickLabel',pos)
    save(fullfile(cfg.dirs.behav_dir,sub,preOrPost,'spatialLoc',['sub' sub '_spatialLoc_' preOrPost '_dPrime']),'dPrimeByPos','-append');
    print(fullfile(cfg.dirs.behav_dir,sub,preOrPost,'spatialLoc',['sub' sub '_spatialLoc_' preOrPost '_dPrimeByPos']),'-dpng');
    
    %% d prime by freq
    freq = [26 93];
    dPrimeByFreq = ones(length(freq),1);
    for f=1:length(freq)
        h = []; % hits
        fa = []; % false alarms
        for iBlock=1:numBlocks
            h = [h sum(floor(trialOutput(iBlock).stimuli(2,1:144)) == freq(f) & trialOutput(iBlock).sResp(1:144) == 2 & trialOutput(iBlock).correctResponse(1:144) == 2) / ... 
                   sum(floor(trialOutput(iBlock).stimuli(2,1:144)) == freq(f) & trialOutput(iBlock).correctResponse(1:144) == 2)]; 
            fa = [fa sum(floor(trialOutput(iBlock).stimuli(2,1:144)) == freq(f) & trialOutput(iBlock).sResp(1:144) == 2 & trialOutput(iBlock).correctResponse(1:144) == 1)/ ... 
                     sum(floor(trialOutput(iBlock).stimuli(2,1:144)) == freq(f) & trialOutput(iBlock).correctResponse(1:144) == 1)]; 
        end
        dPrimeByFreq(f) = calcDprime(h,fa);
    end
    bar(dPrimeByFreq);
    xlabel('Frequency');
    ylabel('D prime');
    ylim([0 3.25])
    title(['Sub ' sub ' spatial localization d prime by frequency']);
    set(gca,'XTickLabel',freq)
    save(fullfile(cfg.dirs.behav_dir,sub,preOrPost,'spatialLoc',['sub' sub '_spatialLoc_' preOrPost '_dPrime']),'dPrimeByFreq','-append');
    print(fullfile(cfg.dirs.behav_dir,sub,preOrPost,'spatialLoc',['sub' sub '_spatialLoc_' preOrPost '_dPrimeByFreq']),'-dpng');
    
end