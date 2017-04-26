function plotTrainingProgressFreq(directory, saveName)
files = dir(directory);   
for i=1:length(files)
    exptData(i,:) = load(files(i).name);
end

%%
nSessions = length(files);

for j = 1:nSessions
    nTrials(j) = exptData(j).exptdesign.numTrialsPerSession;
    nBlocks(j) = length(exptData(j).trialOutput);
end
    
    %frequency line)
    f1=2.^([0:.1:2]+log2(25));
    f2=fliplr(f1);
    
    %generate indexes by frequency pair
    for i=1:numBlocks 
        indexF1(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(1) f2(1)]);
        indexF2(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(2) f2(2)]);
        indexF3(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(3) f2(3)]);
        indexF4(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(4) f2(4)]);
        indexF5(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(5) f2(5)]);
        indexF6(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(6) f2(6)]);
        indexF7(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(7) f2(7)]);
        indexF8(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(8) f2(8)]);
        indexF9(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(9) f2(9)]);
    end

 %%

    for i=1:numBlocks
        rt(i,:) = exptData.trialOutput(i).responseFinishedTime - exptData.trialOutput(i).responseStartTime;
    end
     
    rtF1 = rt(indexF1);
    rtF2 = rt(indexF2);
    rtF3 = rt(indexF3);
    rtF4 = rt(indexF4);
    rtF5 = rt(indexF5);
    rtF6 = rt(indexF6);
    rtF7 = rt(indexF7);
    rtF8 = rt(indexF8);
    rtF9 = rt(indexF9);
    
  %%  
    for i=1:numBlocks
        acc(i,:) = exptData.trialOutput(i).accuracy;
    end
    
    accF1 = acc(indexF1);
    accF2 = acc(indexF2);    
    accF3 = acc(indexF3);
    accF4 = acc(indexF4);
    accF5 = acc(indexF5);
    accF6 = acc(indexF6);
    accF7 = acc(indexF7);
    accF8 = acc(indexF8);
    accF9 = acc(indexF9);
   
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

save (filename, 'acc*', 'rt*')

end

