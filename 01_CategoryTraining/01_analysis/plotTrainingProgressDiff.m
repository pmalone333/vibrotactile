function plotTrainingProgressDiff(exptFilename, saveName)

    exptData = load(exptFilename);
    
    %exptData = load('/Volumes/KINGSTON/915/20150804_1239-2015-08-04-11-20MR915_block7.mat');
    numTrials = exptData.exptdesign.numTrialsPerSession;
    numBlocks = length(exptData.trialOutput);
    blockIndex = (1:numBlocks)';
    
    %frequency line)
    f1=2.^([0:.1:2]+log2(25));
    f2=fliplr(f1);
    
    %generate indexes by level
    for i=1:numBlocks 
        indexL1(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(1:3) f2(1:3)]);
        indexL2(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(4:6) f2(4:6)]);
        indexL3(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(7:9) f2(7:9)]);
    end

 %%

    for i=1:numBlocks
        rt(i,:) = exptData.trialOutput(i).responseFinishedTime - exptData.trialOutput(i).responseStartTime;
    end
     
    rtL1 = rt(indexL1);
    rtL2 = rt(indexL2);
    rtL3 = rt(indexL3);
    
    mrtL1 = median(rtL1);
    mrtL2 = median(rtL2);
    mrtL3 = median(rtL3);
    
  %%  
    for i=1:numBlocks
        acc(i,:) = exptData.trialOutput(i).accuracy;
    end
    
    accL1 = acc(indexL1);
    accL2 = acc(indexL2);    
    accL3 = acc(indexL3);
    
    maccL1 = mean(accL1);
    maccL2 = mean(accL2);    
    maccL3 = mean(accL3);
      
     %%
%     %plot SOAs
%     h=gcf
%        
%     %plot performance
%     subplot(2,3,run)
%     plot(1:3, [accL1 accL2 accL3]);
%     %legend('B1 Acc', 'B2 Acc', 'B3 Acc', 'B4 Acc', 'B5 Acc', 'B6 Acc', 'B7 Acc', 'location', 'SouthWest')
%     xlabel('Block')
%     xlim([0 4])
%     title('Accuracy')
%     fixFonts
%     
%     %plot RTs
%     subplot(2,3,run+3)
%     plot(1:3, [rtL1 rtL2 rtL3]);
%     %legend('Block 1 RT', 'Block 2 RT', 'Block 3 RT', 'Block 4 RT', 'Block 5 RT', 'Block 6 RT', 'Block 7 RT', 'location', 'NorthEast')
%     xlabel('Block')
%     xlim([0 4])
%     title('Reaction Times, seconds')
%     fixFonts
%     
%    %saveFormats('test', [saveName], './', 100)
% %     
% %  
% %     

%%
filename = saveName;

save (filename, 'acc*', 'rt*', 'm*')

end