function makeFreqDiscrimFigsEven(sub,cfg)
    
    % patrick malone pmalone333@gmail.com 11/23/15
    % passed args1:92 sub must be string (i.e '900' for subj 900), if
    % cfg isn't passed it is created using config_subjects_VT.m 
    
    if exist('cfg','var') % if cfg was passed, use it; else, create one
        cfg = config_subjects_VT(cfg);
    else
        cfg = config_subjects_VT;
    end
    
    % change preTrain to post for post training figs
    data_path = dir(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim'));
    load(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',data_path(3).name));

    %% plot overall accuracy by block
    plot([mean(trialOutput(1).accuracy) mean(trialOutput(2).accuracy) mean(trialOutput(3).accuracy) ...
          mean(trialOutput(4).accuracy) mean(trialOutput(5).accuracy) mean(trialOutput(6).accuracy) ...
          mean(trialOutput(7).accuracy)]);
    xlabel('Block');
    ylabel('Accuracy');
    ylim([0.4 1])
    hline = refline([0 0.5]);
    hline.Color = 'r';
    title(['Sub ' sub ' overall frequency discrim acc']);
    print(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',['sub' sub '_freqDiscrim_OverallBlockAcc']),'-dpng');
    
    %% plot freq discrim by position 
    pos2 = mean([trialOutput(1).accuracy(trialOutput(1).stimuli(2,1:92) == 2) trialOutput(2).accuracy(trialOutput(2).stimuli(2,1:92) == 2) ...
        trialOutput(3).accuracy(trialOutput(3).stimuli(2,1:92) == 2) trialOutput(4).accuracy(trialOutput(4).stimuli(2,1:92) == 2) ...
        trialOutput(5).accuracy(trialOutput(5).stimuli(2,1:92) == 2) trialOutput(6).accuracy(trialOutput(6).stimuli(2,1:92) == 2) ... 
        trialOutput(7).accuracy(trialOutput(7).stimuli(2,1:92) == 2)]);
    pos4 = mean([trialOutput(1).accuracy(trialOutput(1).stimuli(2,1:92) == 4) trialOutput(2).accuracy(trialOutput(2).stimuli(2,1:92) == 4) ...
        trialOutput(3).accuracy(trialOutput(3).stimuli(2,1:92) == 4) trialOutput(4).accuracy(trialOutput(4).stimuli(2,1:92) == 4) ...
        trialOutput(5).accuracy(trialOutput(5).stimuli(2,1:92) == 4) trialOutput(6).accuracy(trialOutput(6).stimuli(2,1:92) == 4) ... 
        trialOutput(7).accuracy(trialOutput(7).stimuli(2,1:92) == 4)]);
    pos12 = mean([trialOutput(1).accuracy(trialOutput(1).stimuli(2,1:92) == 12) trialOutput(2).accuracy(trialOutput(2).stimuli(2,1:92) == 12) ...
        trialOutput(3).accuracy(trialOutput(3).stimuli(2,1:92) == 12) trialOutput(4).accuracy(trialOutput(4).stimuli(2,1:92) == 12) ...
        trialOutput(5).accuracy(trialOutput(5).stimuli(2,1:92) == 12) trialOutput(6).accuracy(trialOutput(6).stimuli(2,1:92) == 12) ... 
        trialOutput(7).accuracy(trialOutput(7).stimuli(2,1:92) == 12)]);
    pos14 = mean([trialOutput(1).accuracy(trialOutput(1).stimuli(2,1:92) == 14) trialOutput(2).accuracy(trialOutput(2).stimuli(2,1:92) == 14) ...
        trialOutput(3).accuracy(trialOutput(3).stimuli(2,1:92) == 14) trialOutput(4).accuracy(trialOutput(4).stimuli(2,1:92) == 14) ...
        trialOutput(5).accuracy(trialOutput(5).stimuli(2,1:92) == 14) trialOutput(6).accuracy(trialOutput(6).stimuli(2,1:92) == 14) ... 
        trialOutput(7).accuracy(trialOutput(7).stimuli(2,1:92) == 14)]);
    bar([pos2 pos4 pos12 pos14])
    xlabel('Position');
    ylabel('Accuracy');
    ylim([0.4 1])
    hline = refline([0 0.5]);
    hline.Color = 'r';
    title(['Sub ' sub ' freq discrim acc by position']);
    set(gca,'XTickLabel',[1 3 11 13])
    print(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',['sub' sub '_freqDiscrim_accByPos']),'-dpng');
    
    %% same freq discrim acc 
   freq27 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 26 & floor(trialOutput(1).stimuli(3,1:92)) == 26) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 26 & floor(trialOutput(2).stimuli(3,1:92)) == 26) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 26 & floor(trialOutput(3).stimuli(3,1:92)) == 26) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 26 & floor(trialOutput(4).stimuli(3,1:92)) == 26) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 26 & floor(trialOutput(5).stimuli(3,1:92)) == 26) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 26 & floor(trialOutput(6).stimuli(3,1:92)) == 26) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 26 & floor(trialOutput(7).stimuli(3,1:92)) == 26)]);
   freq40 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 40 & floor(trialOutput(1).stimuli(3,1:92)) == 40) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 40 & floor(trialOutput(2).stimuli(3,1:92)) == 40) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 40 & floor(trialOutput(3).stimuli(3,1:92)) == 40) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 40 & floor(trialOutput(4).stimuli(3,1:92)) == 40) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 40 & floor(trialOutput(5).stimuli(3,1:92)) == 40) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 40 & floor(trialOutput(6).stimuli(3,1:92)) == 40) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 40 & floor(trialOutput(7).stimuli(3,1:92)) == 40)]);
   freq61 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 61 & floor(trialOutput(1).stimuli(3,1:92)) == 61) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 61 & floor(trialOutput(2).stimuli(3,1:92)) == 61) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 61 & floor(trialOutput(3).stimuli(3,1:92)) == 61) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 61 & floor(trialOutput(4).stimuli(3,1:92)) == 61) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 61 & floor(trialOutput(5).stimuli(3,1:92)) == 61) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 61 & floor(trialOutput(6).stimuli(3,1:92)) == 61) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 61 & floor(trialOutput(7).stimuli(3,1:92)) == 61)]);
   freq93 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 93 & floor(trialOutput(1).stimuli(3,1:92)) == 93) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 93 & floor(trialOutput(2).stimuli(3,1:92)) == 93) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 93 & floor(trialOutput(3).stimuli(3,1:92)) == 93) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 93 & floor(trialOutput(4).stimuli(3,1:92)) == 93) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 93 & floor(trialOutput(5).stimuli(3,1:92)) == 93) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 93 & floor(trialOutput(6).stimuli(3,1:92)) == 93) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 93 & floor(trialOutput(7).stimuli(3,1:92)) == 93)]);
    bar([freq27 freq40 freq61 freq93])
    xlabel('Frequency');
    ylabel('Accuracy');
    ylim([0.4 1])
    hline = refline([0 0.5]);
    hline.Color = 'r';
    title(['Sub ' sub ' freq discrim acc by freq - same cond']);
    set(gca,'XTickLabel',[27 40 61 93])
    print(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',['sub' sub '_freqDiscrim_sameCondAcc']),'-dpng');
    
    %% diff freq discrim acc 
    freq27_40 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 26 & floor(trialOutput(1).stimuli(3,1:92)) == 40) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 26 & floor(trialOutput(2).stimuli(3,1:92)) == 40) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 26 & floor(trialOutput(3).stimuli(3,1:92)) == 40) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 26 & floor(trialOutput(4).stimuli(3,1:92)) == 40) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 26 & floor(trialOutput(5).stimuli(3,1:92)) == 40) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 26 & floor(trialOutput(6).stimuli(3,1:92)) == 40) ...
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 26 & floor(trialOutput(7).stimuli(3,1:92)) == 40) ...
        trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 40 & floor(trialOutput(1).stimuli(3,1:92)) == 26) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 40 & floor(trialOutput(2).stimuli(3,1:92)) == 26) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 40 & floor(trialOutput(3).stimuli(3,1:92)) == 26) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 40 & floor(trialOutput(4).stimuli(3,1:92)) == 26) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 40 & floor(trialOutput(5).stimuli(3,1:92)) == 26) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 40 & floor(trialOutput(6).stimuli(3,1:92)) == 26) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 40 & floor(trialOutput(7).stimuli(3,1:92)) == 26)]);
    freq27_61 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 26 & floor(trialOutput(1).stimuli(3,1:92)) == 61) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 26 & floor(trialOutput(2).stimuli(3,1:92)) == 61) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 26 & floor(trialOutput(3).stimuli(3,1:92)) == 61) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 26 & floor(trialOutput(4).stimuli(3,1:92)) == 61) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 26 & floor(trialOutput(5).stimuli(3,1:92)) == 61) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 26 & floor(trialOutput(6).stimuli(3,1:92)) == 61) ...
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 26 & floor(trialOutput(7).stimuli(3,1:92)) == 61) ...
        trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 61 & floor(trialOutput(1).stimuli(3,1:92)) == 26) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 61 & floor(trialOutput(2).stimuli(3,1:92)) == 26) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 61 & floor(trialOutput(3).stimuli(3,1:92)) == 26) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 61 & floor(trialOutput(4).stimuli(3,1:92)) == 26) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 61 & floor(trialOutput(5).stimuli(3,1:92)) == 26) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 61 & floor(trialOutput(6).stimuli(3,1:92)) == 26) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 61 & floor(trialOutput(7).stimuli(3,1:92)) == 26)]);
    freq27_93 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 26 & floor(trialOutput(1).stimuli(3,1:92)) == 93) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 26 & floor(trialOutput(2).stimuli(3,1:92)) == 93) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 26 & floor(trialOutput(3).stimuli(3,1:92)) == 93) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 26 & floor(trialOutput(4).stimuli(3,1:92)) == 93) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 26 & floor(trialOutput(5).stimuli(3,1:92)) == 93) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 26 & floor(trialOutput(6).stimuli(3,1:92)) == 93) ...
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 26 & floor(trialOutput(7).stimuli(3,1:92)) == 93) ...
        trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 93 & floor(trialOutput(1).stimuli(3,1:92)) == 26) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 93 & floor(trialOutput(2).stimuli(3,1:92)) == 26) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 93 & floor(trialOutput(3).stimuli(3,1:92)) == 26) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 93 & floor(trialOutput(4).stimuli(3,1:92)) == 26) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 93 & floor(trialOutput(5).stimuli(3,1:92)) == 26) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 93 & floor(trialOutput(6).stimuli(3,1:92)) == 26) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 93 & floor(trialOutput(7).stimuli(3,1:92)) == 26)]);
    freq40_61 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 40 & floor(trialOutput(1).stimuli(3,1:92)) == 61) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 40 & floor(trialOutput(2).stimuli(3,1:92)) == 61) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 40 & floor(trialOutput(3).stimuli(3,1:92)) == 61) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 40 & floor(trialOutput(4).stimuli(3,1:92)) == 61) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 40 & floor(trialOutput(5).stimuli(3,1:92)) == 61) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 40 & floor(trialOutput(6).stimuli(3,1:92)) == 61) ...
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 40 & floor(trialOutput(7).stimuli(3,1:92)) == 61) ...
        trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 61 & floor(trialOutput(1).stimuli(3,1:92)) == 40) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 61 & floor(trialOutput(2).stimuli(3,1:92)) == 40) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 61 & floor(trialOutput(3).stimuli(3,1:92)) == 40) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 61 & floor(trialOutput(4).stimuli(3,1:92)) == 40) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 61 & floor(trialOutput(5).stimuli(3,1:92)) == 40) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 61 & floor(trialOutput(6).stimuli(3,1:92)) == 40) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 61 & floor(trialOutput(7).stimuli(3,1:92)) == 40)]);
    freq40_93 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 40 & floor(trialOutput(1).stimuli(3,1:92)) == 93) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 40 & floor(trialOutput(2).stimuli(3,1:92)) == 93) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 40 & floor(trialOutput(3).stimuli(3,1:92)) == 93) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 40 & floor(trialOutput(4).stimuli(3,1:92)) == 93) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 40 & floor(trialOutput(5).stimuli(3,1:92)) == 93) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 40 & floor(trialOutput(6).stimuli(3,1:92)) == 93) ...
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 40 & floor(trialOutput(7).stimuli(3,1:92)) == 93) ...
        trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 93 & floor(trialOutput(1).stimuli(3,1:92)) == 40) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 93 & floor(trialOutput(2).stimuli(3,1:92)) == 40) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 93 & floor(trialOutput(3).stimuli(3,1:92)) == 40) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 93 & floor(trialOutput(4).stimuli(3,1:92)) == 40) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 93 & floor(trialOutput(5).stimuli(3,1:92)) == 40) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 93 & floor(trialOutput(6).stimuli(3,1:92)) == 40) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 93 & floor(trialOutput(7).stimuli(3,1:92)) == 40)]);
    freq61_93 = mean([trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 61 & floor(trialOutput(1).stimuli(3,1:92)) == 93) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 61 & floor(trialOutput(2).stimuli(3,1:92)) == 93) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 61 & floor(trialOutput(3).stimuli(3,1:92)) == 93) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 61 & floor(trialOutput(4).stimuli(3,1:92)) == 93) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 61 & floor(trialOutput(5).stimuli(3,1:92)) == 93) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 61 & floor(trialOutput(6).stimuli(3,1:92)) == 93) ...
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 61 & floor(trialOutput(7).stimuli(3,1:92)) == 93) ...
        trialOutput(1).accuracy(floor(trialOutput(1).stimuli(1,1:92)) == 93 & floor(trialOutput(1).stimuli(3,1:92)) == 61) trialOutput(2).accuracy(floor(trialOutput(2).stimuli(1,1:92)) == 93 & floor(trialOutput(2).stimuli(3,1:92)) == 61) ...
        trialOutput(3).accuracy(floor(trialOutput(3).stimuli(1,1:92)) == 93 & floor(trialOutput(3).stimuli(3,1:92)) == 61) trialOutput(4).accuracy(floor(trialOutput(4).stimuli(1,1:92)) == 93 & floor(trialOutput(4).stimuli(3,1:92)) == 61) ...
        trialOutput(5).accuracy(floor(trialOutput(5).stimuli(1,1:92)) == 93 & floor(trialOutput(5).stimuli(3,1:92)) == 61) trialOutput(6).accuracy(floor(trialOutput(6).stimuli(1,1:92)) == 93 & floor(trialOutput(6).stimuli(3,1:92)) == 61) ... 
        trialOutput(7).accuracy(floor(trialOutput(7).stimuli(1,1:92)) == 93 & floor(trialOutput(7).stimuli(3,1:92)) == 61)]);
    bar([freq27_40 freq27_61 freq27_93 freq40_61 freq40_93 freq61_93])
    xlabel('Frequency pair');
    ylabel('Accuracy');
    ylim([0 1])
    hline = refline([0 0.5]);
    hline.Color = 'r';
    title(['Sub ' sub ' freq discrim acc by freq pair - diff cond']);
    set(gca,'XTickLabel',{'27+40','27+61','27+93','40+61','40+93','61+93'})
    print(fullfile(cfg.dirs.behav_dir,sub,'preTrain','freqDiscrim',['sub' sub '_freqDiscrim_diffCondAcc']),'-dpng');
    
end