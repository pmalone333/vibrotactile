function plotTrainingProgressPosLevel(exptFilename, saveName)
    exptData = load(exptFilename);
    
    %exptData = load('/Volumes/KINGSTON/915/20150810_1620-2015-08-10-15-25MR915_block6');
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
    
    %frequency line)
    f1=2.^([0:.1:2]+log2(25));
    f2=fliplr(f1);
    
    %generate indexes by level
    for i=1:numBlocks 
        indexL1(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(1:5) f2(1:5)]);
        indexL2(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(1:2:9) f2(1:2:9)]);
        indexL3(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(2:2:10) f2(2:2:10)]);
        indexL4(i,:) = ismember(exptData.trialOutput(i).stimuli(1,:),[f1(6:10) f2(6:10)]);
    end
    
 indexL1 = size(indexL1(all(indexL1==1,2),:),1);
 indexL2 = size(indexL2(all(indexL2==1,2),:),1);
 indexL3 = size(indexL3(all(indexL3==1,2),:),1);
 indexL4 = size(indexL4(all(indexL4==1,2),:),1);
 
 %%

 if indexL1 ==0
     clear indexL1;
 end
 
 if indexL2 ==0
     clear indexL2;
 end
 
 if indexL3 == 0
     clear indexL3;
 end
 
 if indexL4==0
     clear indexL4;
 end

for i=1:numBlocks
    acc(i,:) = exptData.trialOutput(i).accuracy;
end


  %%
  if exist ('indexL1', 'var')
      accP1crossL1 = acc(indexP1cross(1:indexL1,:));
      accP2crossL1 = acc(indexP2cross(1:indexL1,:));
      accP3crossL1 = acc(indexP3cross(1:indexL1,:));
      accP4crossL1 = acc(indexP4cross(1:indexL1,:));
      
      
      accP1sameL1 = acc(indexP1same(1:indexL1,:));
      accP2sameL1 = acc(indexP2same(1:indexL1,:));
      accP3sameL1 = acc(indexP3same(1:indexL1,:));
      accP4sameL1 = acc(indexP4same(1:indexL1,:));
  end
  
  if exist('indexL2', 'var')
      accP1crossL2 = acc(indexP1cross(1:indexL2,:));
      accP2crossL2 = acc(indexP2cross(1:indexL2,:));
      accP3crossL2 = acc(indexP3cross(1:indexL2,:));
      accP4crossL2 = acc(indexP4cross(1:indexL2,:));
      
      accP1sameL2 = acc(indexP1same(1:indexL2,:));
      accP2sameL2 = acc(indexP2same(1:indexL2,:));
      accP3sameL2 = acc(indexP3same(1:indexL2,:));
      accP4sameL2 = acc(indexP4same(1:indexL2,:));
  end
  
  if exist ('indexL3', 'var')
      accP1crossL3 = acc(indexP1cross(1:indexL3,:));
      accP2crossL3 = acc(indexP2cross(1:indexL3,:));
      accP3crossL3 = acc(indexP3cross(1:indexL3,:));
      accP4crossL3 = acc(indexP4cross(1:indexL3,:));
      
      accP1sameL3 = acc(indexP1same(1:indexL3,:));
      accP2sameL3 = acc(indexP2same(1:indexL3,:));
      accP3sameL3 = acc(indexP3same(1:indexL3,:));
      accP4sameL3 = acc(indexP4same(1:indexL3,:));
  end
  
   if exist ('indexL4', 'var')
      accP1crossL4 = acc(indexP1cross(1:indexL4,:));
      accP2crossL4 = acc(indexP2cross(1:indexL4,:));
      accP3crossL4 = acc(indexP3cross(1:indexL4,:));
      accP4crossL4 = acc(indexP4cross(1:indexL4,:));
      
      accP1sameL4 = acc(indexP1same(1:indexL4,:));
      accP2sameL4 = acc(indexP2same(1:indexL4,:));
      accP3sameL4 = acc(indexP3same(1:indexL4,:));
      accP4sameL4 = acc(indexP4same(1:indexL4,:));
   end 

%%
filename = saveName;

save (filename, 'acc*')

end

