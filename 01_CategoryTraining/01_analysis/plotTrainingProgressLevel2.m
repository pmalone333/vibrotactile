function plotTrainingProgressLevel2(exptFilename, saveName)

    exptData = load(exptFilename);
    
    %exptData = load('/Volumes/KINGSTON/915/20150810_1620-2015-08-10-15-25MR915_block6.mat');
    numTrials = exptData.exptdesign.numTrialsPerSession;
    numBlocks = length(exptData.trialOutput);
    
    %frequency line)
    f1=2.^([0:.1:2]+log2(25));
    f2=fliplr(f1);
    
    %generate indexes by level
    for i=1:numBlocks
         indexL1(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(1:5) f2(1:5)]);
        indexL2(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(1:2:9) f2(1:2:9)]);
        indexL3(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(2:2:10) f2(2:2:10)]);
        indexL4(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(5:9) f2(5:9)]);
    end

 %%
    for i=1:numBlocks
        if (indexL1(i,:) == 1)
            rtL1(i,:) = exptData.trialOutput(i).responseFinishedTime - exptData.trialOutput(i).responseStartTime;
        end
        if (indexL2(i,:)  == 1)
            rtL2(i,:) = exptData.trialOutput(i).responseFinishedTime - exptData.trialOutput(i).responseStartTime;
            rtL2(all(rtL2==0,2),:)=[];
        end
        if (indexL3(i,:)  == 1)
            rtL3(i,:) = exptData.trialOutput(i).responseFinishedTime - exptData.trialOutput(i).responseStartTime;
            rtL3(all(rtL3==0,2),:)=[];
        end
        if (indexL4(i,:)  == 1)
            rtL4(i,:) = exptData.trialOutput(i).responseFinishedTime - exptData.trialOutput(i).responseStartTime;
            rtL4(all(rtL4==0,2),:)=[];
        end
    end
    

  if exist('rtL1', 'var')
     rtL1 = median(rtL1');
     rt = rtL1;
  end
 
  if exist('rtL2', 'var')
     rtL2 = median(rtL2');
     if exist ('rt', 'var')
        rt = horzcat (rt, rtL2);
     else 
        rt = rtL2;
     end
  end
  
  if exist('rtL3', 'var')
     rtL3 = median(rtL3');
     if exist ('rt', 'var')
        rt = horzcat (rt, rtL3);
     else
         rt = rtL3;
     end
  end
  
  if exist('rtL4', 'var')
     rtL4 = median(rtL4');
     if exist ('rt', 'var')
        rt = horzcat (rt, rtL4);
     else
         rt = rtL4;
     end
  end 
  

  
  %%  
    for i=1:numBlocks
        if (indexL1(i,:) ~= 0)
            accL1(i,:) = exptData.trialOutput(i).accuracy;
            accL1(all(accL1==0,2),:)=[];
        end
        if (indexL2(i,:) ~= 0)
            accL2(i,:) = exptData.trialOutput(i).accuracy;
            accL2(all(accL2==0,2),:)=[];
        end
        if (indexL3(i,:) ~= 0)
            accL3(i,:) = exptData.trialOutput(i).accuracy;
            accL3(all(accL3==0,2),:)=[];
        end
        if (indexL4(i,:) ~= 0)
            accL4(i,:) = exptData.trialOutput(i).accuracy;
            accL4(all(accL4==0,2),:)=[];
        end
    end
    
  if exist('accL1', 'var')
     accL1 = sum(accL1')/numTrials;
     acc = accL1;
  end
 
  if exist('accL2', 'var')
     accL2 = sum(accL2')/numTrials;
     if exist ('acc', 'var')
         acc = horzcat (acc, accL2);
     else
         acc = accL2;
     end
     
  end
  
  if exist('accL3', 'var')
     accL3 = sum(accL3')/numTrials;
     if exist ('acc', 'var')
        acc = horzcat (acc, accL3);
     else
         acc = accL3;
     end
  end
  
  if exist('accL4', 'var')
     accL4 = sum(accL4')/numTrials;
     if exist ('acc', 'var')
        acc = horzcat (acc, accL4);
     else
         acc = accL4;
     end
  end 

%%
%     %plot SOAs
%     h=gcf
%        
%     %plot performance
%     subplot(2,3,run)
%     plot(1:numBlocks, acc);
%     %legend('B1 Acc', 'B2 Acc', 'B3 Acc', 'B4 Acc', 'B5 Acc', 'B6 Acc', 'B7 Acc', 'location', 'SouthWest')
%     xlabel('Block')
%     ylim([0 1])
%     xlim([0 9])
%     title('Accuracy')
%     fixFonts
%     
%     %plot RTs
%     subplot(2,3,run+3)
%     plot(1:numBlocks, rt);
%     %legend('Block 1 RT', 'Block 2 RT', 'Block 3 RT', 'Block 4 RT', 'Block 5 RT', 'Block 6 RT', 'Block 7 RT', 'location', 'NorthEast')
%     xlabel('Block')
%     ylim([0 1.5])
%     xlim([0 9])
%     title('Reaction Times, seconds')
%     fixFonts
%%    
filename = saveName;

save (filename, 'acc*')
%%
end
