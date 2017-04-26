function makeFreqDiscrimFigs_dprime_s1000(sub,positionType,cfg)
    % patrick malone pmalone333@gmail.com 11/23/15
    % passed args sub must be string (i.e '900' for subj 900), if
    % cfg isn't passed it is created using config_subjects_VT.m 
    % positionType = 1 for odd positions, 2 for even 
    
    if exist('cfg','var') % if cfg was passed, use it; else, create one
        cfg = config_subjects_VT(cfg);
    else
        cfg = config_subjects_VT;
    end
    
    % change preTrain to post for post training figs
    data_path = dir(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim'));
    load(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',data_path(4).name));

    %% d prime by block
    numBlocks = length(trialOutput);
    dPrime = ones(numBlocks,1);
    for iBlock=1:numBlocks
        h = sum(trialOutput(iBlock).sResp(1:192) == 2 & trialOutput(iBlock).correctResponse(1:192) == 2)/sum(trialOutput(iBlock).correctResponse(1:192) == 2);
        fa = sum(trialOutput(iBlock).sResp(1:192) == 2 & trialOutput(iBlock).correctResponse(1:192) == 1)/sum(trialOutput(iBlock).correctResponse(1:192) == 1);
        dPrime(iBlock) = calcDprime(h,fa);
        clear h fa
    end
    plot(dPrime);
    xlabel('Block');
    ylabel('D prime');
    ylim([0 2])
    title(['Sub ' sub ' frequency discrim d prime by block']);
    print(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',['sub' sub '_freqDiscrim_dPrimeByBlock']),'-dpng');
    
    %% d prime by position
    if positionType==2, pos=[2 4 12 14]; 
    else pos=[1 3 11 13];
    end
    dPrime = ones(length(pos),1);
    for p=1:length(pos)
        h = []; % hits
        fa = []; % false alarms
        for iBlock=1:numBlocks
            h = [h sum(trialOutput(iBlock).stimuli(2,1:192) == pos(p) & trialOutput(iBlock).sResp(1:192) == 2 & trialOutput(iBlock).correctResponse(1:192) == 2) / ... 
                   sum(trialOutput(iBlock).stimuli(2,1:192) == pos(p) & trialOutput(iBlock).correctResponse(1:192) == 2)]; 
            fa = [fa sum(trialOutput(iBlock).stimuli(2,1:192) == pos(p) & trialOutput(iBlock).sResp(1:192) == 2 & trialOutput(iBlock).correctResponse(1:192) == 1)/ ... 
                     sum(trialOutput(iBlock).stimuli(2,1:192) == pos(p) & trialOutput(iBlock).correctResponse(1:192) == 1)]; 
        end
        dPrime(p) = calcDprime(h,fa);
    end
    bar(dPrime);
    xlabel('Position');
    ylabel('D prime');
    ylim([0 2])
    title(['Sub ' sub ' freq discrim d prime by position']);
    set(gca,'XTickLabel',pos)
    print(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',['sub' sub '_freqDiscrim_dPrimeByPos']),'-dpng');
       
    %% diff freq discrim d prime 
    freq = [26 40 61 93];
    dPrime = ones(length(freq),1);
    for f=1:length(freq)
        h = []; % hits
        fa = []; % false alarms
        for iBlock=1:numBlocks
           h = [h sum((floor(trialOutput(iBlock).stimuli(1,1:192)) == freq(f) | floor(trialOutput(iBlock).stimuli(3,1:192)) == freq(f)) & trialOutput(iBlock).sResp(1:192) == 2 & trialOutput(iBlock).correctResponse(1:192) == 2) / ... 
                   sum((floor(trialOutput(iBlock).stimuli(1,1:192)) == freq(f) | floor(trialOutput(iBlock).stimuli(3,1:192)) == freq(f)) & trialOutput(iBlock).correctResponse(1:192) == 2)]; 
           fa = [fa sum((floor(trialOutput(iBlock).stimuli(1,1:192)) == freq(f) | floor(trialOutput(iBlock).stimuli(3,1:192)) == freq(f)) & trialOutput(iBlock).sResp(1:192) == 2 & trialOutput(iBlock).correctResponse(1:192) == 1) / ... 
                    sum((floor(trialOutput(iBlock).stimuli(1,1:192)) == freq(f) | floor(trialOutput(iBlock).stimuli(3,1:192)) == freq(f)) & trialOutput(iBlock).correctResponse(1:192) == 1)]; 
        end
        dPrime(f) = calcDprime(h,fa);
    end
    bar(dPrime)
    xlabel('Frequency');
    ylabel('D prime');
    ylim([0 2])
    title(['Sub ' sub ' freq discrim d prime by freq']);
    set(gca,'XTickLabel',freq)
    print(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',['sub' sub '_freqDiscrim_dPrimeByFreq']),'-dpng');
    
end