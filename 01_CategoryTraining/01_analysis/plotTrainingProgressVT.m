function plotTrainingProgressVT(exptFilename)

    exptData = load(exptFilename);
    %exptData = load('/Volumes/KINGSTON/915/20150804_1239-2015-08-04-11-20MR915_block7.mat');
    
    numTrials = length(exptData.trialOutput(1).responseStartTime);
    numBlocks = length(exptData.trialOutput);
 
    for i=1:numBlocks
       rt(i,:) = exptData.trialOutput(i).responseFinishedTime - exptData.trialOutput(i).responseStartTime;
    end

    for i=1:numBlocks
        acc(i,:) = exptData.trialOutput(i).accuracy;
    end
%%
       %Acuracy values by block
       acc = sum(acc')/numTrials;
       
       %four RT values
   
       rt = median(rt');

       save([exptData.exptdesign.subjectName],'rt','acc')
    %%
%    
%     
%     %plot SOAs
%     h=gcf
%     
%     %plot performance
%     subplot(3,3,run)
%     plot(1:numBlocks, acc);
%     %legend('B1 Acc', 'B2 Acc', 'B3 Acc', 'B4 Acc', 'B5 Acc', 'B6 Acc', 'B7 Acc', 'location', 'SouthWest')
%     xlabel('block')
%     ylim([0 .9])
%     xlim([0 9])
%     title('Accuracy')
%     fixFonts
%     
%     %plot RTs
%     subplot(3,3,run+3)
%     plot(1:numBlocks, rt);
%     %legend('Block 1 RT', 'Block 2 RT', 'Block 3 RT', 'Block 4 RT', 'Block 5 RT', 'Block 6 RT', 'Block 7 RT', 'location', 'NorthEast')
%     xlabel('block')
%     ylim([0 1.5])
%     xlim([0 9])
%     title('Reaction Times, seconds')
%     fixFonts
%     
   %saveFormats('test', [saveName], './', 100)
%     
%  
%     
end