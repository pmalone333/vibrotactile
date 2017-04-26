function plotTrainingProgressPosDiff(exptFilename, saveName)
    exptData = load(exptFilename);
    
%     exptData = load('/Volumes/KINGSTON/915/20150804_1239-2015-08-04-11-20MR915_block7.mat');
    numTrials = exptData.exptdesign.numTrialsPerSession;
    numBlocks = length(exptData.trialOutput);
    
    %position
    s1=[1 2 5 6 1 2 5 6];
    s2=[9 10 13 14 10 9 14 13];
    stimulator=[s1; s2];
    stimSame = stimulator(:,1:4);
    stimCross = stimulator(:,5:8);
    
  %generate indexes by position pair
    for i=1:numBlocks
        for j=1:4
            indexP1same(i,:) = (ismember(exptData.trialOutput(i).stimuli(3,:),1)...
            & ismember(exptData.trialOutput(i).stimuli(4,:),9));
            indexP1cross(i,:) = ismember(exptData.trialOutput(i).stimuli(3,:),1)...
            & ismember(exptData.trialOutput(i).stimuli(4,:),10);
            indexP2same(i,:) = (ismember(exptData.trialOutput(i).stimuli(3,:),2)...
            & ismember(exptData.trialOutput(i).stimuli(4,:),10));
            indexP2cross(i,:) = ismember(exptData.trialOutput(i).stimuli(3,:),2)...
            & ismember(exptData.trialOutput(i).stimuli(4,:),9);
            indexP3same(i,:) = (ismember(exptData.trialOutput(i).stimuli(3,:),5)...
            & ismember(exptData.trialOutput(i).stimuli(4,:),13));
            indexP3cross(i,:) = ismember(exptData.trialOutput(i).stimuli(3,:),5)...
            & ismember(exptData.trialOutput(i).stimuli(4,:),14);
            indexP4same(i,:) = (ismember(exptData.trialOutput(i).stimuli(3,:),6)...
            & ismember(exptData.trialOutput(i).stimuli(4,:),14));
            indexP4cross(i,:) = ismember(exptData.trialOutput(i).stimuli(3,:),6)...
            & ismember(exptData.trialOutput(i).stimuli(4,:),13);
        end
    end
    
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
        acc(i,:) = exptData.trialOutput(i).accuracy;
    end
    
    accP1crossL1 = acc(indexP1cross & indexL1);
    accP2crossL1 = acc(indexP2cross & indexL1);
    accP3crossL1 = acc(indexP3cross & indexL1);
    accP4crossL1 = acc(indexP4cross & indexL1);
    
    accP1sameL1 = acc(indexP1same & indexL1);
    accP2sameL1 = acc(indexP2same & indexL1);
    accP3sameL1 = acc(indexP3same & indexL1);
    accP4sameL1 = acc(indexP4same & indexL1);
    
    accP1crossL2 = acc(indexP1cross & indexL2);
    accP2crossL2 = acc(indexP2cross & indexL2);
    accP3crossL2 = acc(indexP3cross & indexL2);
    accP4crossL2 = acc(indexP4cross & indexL2);
    
    accP1sameL2 = acc(indexP1same & indexL2);
    accP2sameL2 = acc(indexP2same & indexL2);
    accP3sameL2 = acc(indexP3same & indexL2);
    accP4sameL2 = acc(indexP4same & indexL2);
    
    accP1crossL3 = acc(indexP1cross & indexL3);
    accP2crossL3 = acc(indexP2cross & indexL3);
    accP3crossL3 = acc(indexP3cross & indexL3);
    accP4crossL3 = acc(indexP4cross & indexL3);
    
    accP1sameL3 = acc(indexP1same & indexL3);
    accP2sameL3 = acc(indexP2same & indexL3);
    accP3sameL3 = acc(indexP3same & indexL3);
    accP4sameL3 = acc(indexP4same & indexL3);
    
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

save (filename, 'acc*')

end

