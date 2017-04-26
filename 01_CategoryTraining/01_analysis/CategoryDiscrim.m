clear all;
    
%%
files = dir('/Volumes/KINGSTON/111/2015*.mat');
for i=1:length(files)
    exptData(i,:) = load(files(i).name);
end

%%
nSessions = length(files);

for j = 1:nSessions
    nTrials(j) = exptData(j).exptdesign.numTrialsPerSession;
    nBlocks(j) = length(exptData(j).trialOutput);
end

    f1=2.^([0:.1:2]+log2(25));
    f2=fliplr(f1);
    
    for i = 1:nSessions
        for j = 1:nBlocks
            output(i,j) = {(exptData(i).trialOutput(j).stimuli(5,:))};
            level(i,j) = {(exptData(i).trialOutput(j).level(:,:))};
            accuracy(i,j) = {(exptData(i).trialOutput(j).accuracy(:,:))};
        end
    end

    %%
    for i = 1:nSessions
        for j = 1:nBlocks
            for k = 1:nTrials(i)
                catIndex1{i,j}(k) = ismember(output{i,j}(k), 1);
                catIndex2{i,j}(k) = ismember(output{i,j}(k), 1);
            end
        end
    end
                
   %%
   for i = 1:nSessions
      for j=1:nBlocks(j)
          for k=1:nTrials(i)
              if (level{i,j} == 1 | level{i,j} == 6 | level{i,j} == 11 && catIndex1{i,j}(k) == 1)
                  accL1C1{i,j}(k) = accuracy{i,j}(k);
              elseif (level{i,j} == 1 | level{i,j} == 6 | level{i,j} == 11 && catIndex1{i,j}(k) == 0)
                  accL1C2{i,j}(k) = accuracy{i,j}(k);
              end
 
              if (level{i,j} == 2 | level{i,j} == 7 | level{i,j} == 12  && catIndex1{i,j}(k) == 1)
                  accL2C1{i,j}(k) = accuracy{i,j}(k);
              elseif (level{i,j} == 2 | level{i,j} == 7 | level{i,j} == 12  && catIndex1{i,j}(k) == 0)
                  accL2C2{i,j}(k) = accuracy{i,j}(k);
              end
              
              if (level{i,j} == 2 | level{i,j} == 7 | level{i,j} == 12 && catIndex1{i,j}(k) == 1)
                  accL3C1{i,j}(k) = accuracy{i,j}(k);
              elseif (level{i,j} == 2 | level{i,j} == 7 | level{i,j} == 12  && catIndex1{i,j}(k) == 0)
                  accL3C2{i,j}(k) = accuracy{i,j}(k);
              end
              
              if (level{i,j} == 4 | level{i,j} == 9 | level{i,j} == 14 && catIndex1{i,j}(k) == 1)
                  accL4C1{i,j}(k) = accuracy{i,j}(k);
              elseif (level{i,j} == 4 | level{i,j} == 9 | level{i,j} == 14 && catIndex1{i,j}(k) == 0)
                  accL4C2{i,j}(k) = accuracy{i,j}(k);
              end
                  
              if(level{i,j} == 5 | level{i,j} == 10 | level{i,j} == 15 && catIndex1{i,j}(k) == 1)
                  accL5C1{i,j}(k) = accuracy{i,j}(k);
              elseif (level{i,j} == 5 | level{i,j} == 10 | level{i,j} == 15 && catIndex1{i,j}(k) == 0)
                  accL5C2{i,j}(k) = accuracy{i,j}(k);
              end 
          end
      end
   end
      
 
   accL1C1 = accL1C1(~cellfun(@isempty,accL1C1));
   accL1C2 = accL1C2(~cellfun(@isempty,accL1C2));
   accL2C1 = accL2C1(~cellfun(@isempty,accL2C1));
   accL2C2 = accL2C2(~cellfun(@isempty,accL2C2));
   accL3C1 = accL3C1(~cellfun(@isempty,accL3C1));
   accL3C2 = accL3C2(~cellfun(@isempty,accL3C2));
   accL4C1 = accL4C1(~cellfun(@isempty,accL4C1));
   accL4C2 = accL4C2(~cellfun(@isempty,accL4C2));
   accL5C1 = accL5C1(~cellfun(@isempty,accL5C1));
   accL5C2 = accL5C2(~cellfun(@isempty,accL5C2));
   
   
   %%
   for i = 1:size(accL1C1,1)
       if (size (accL1C1{i},2) > 129)
           accuracyL1C1{i} = sum(accL1C1{i})/80;
           accuracyL1C2{i} = sum(accL1C2{i})/80;
       else
           accuracyL1C1{i} = sum(accL1C1{i})/64;
           accuracyL1C2{i} = sum(accL1C2{i})/64;
       end
   end
   
   for i = 1:size(accL2C1,1)
       if (size (accL2C1{i},2) > 129)
           accuracyL2C1{i} = sum(accL2C1{i})/80;
           accuracyL2C2{i} = sum(accL2C2{i})/80;
       else
           accuracyL2C1{i} = sum(accL2C1{i})/64;
           accuracyL2C2{i} = sum(accL2C2{i})/64;
       end
   end
   
   for i = 1:size(accL3C1,1)
       if (size (accL3C1{i},2) > 129)
           accuracyL3C1{i} = sum(accL3C1{i})/80;
           accuracyL3C2{i} = sum(accL3C2{i})/80;
       else
           accuracyL3C1{i} = sum(accL3C1{i})/64;
           accuracyL3C2{i} = sum(accL3C2{i})/64;
       end
   end
   
   for i = 1:size(accL4C1,1)
       if (size (accL4C1{i},2) > 129)
           accuracyL4C1{i} = sum(accL4C1{i})/80;
           accuracyL4C2{i} = sum(accL4C2{i})/80;
       else
           accuracyL4C1{i} = sum(accL4C1{i})/64;
           accuracyL4C2{i} = sum(accL4C2{i})/64;
       end
   end
   
   for i = 1:size(accL5C1,1)
       if (size (accL5C1{i},2) > 129)
           accuracyL5C1{i} = sum(accL5C1{i})/80;
           accuracyL5C2{i} = sum(accL5C2{i})/80;
       else
           accuracyL5C1{i} = sum(accL5C1{i})/64;
           accuracyL5C2{i} = sum(accL5C2{i})/64;
       end
   end
   
   %%
    m_accuracyL1C1 = mean(cell2mat(accuracyL1C1));
    m_accuracyL1C2 = mean(cell2mat(accuracyL1C2));
    m_accuracyL2C1 = mean(cell2mat(accuracyL2C1));
    m_accuracyL2C2 = mean(cell2mat(accuracyL2C2));
    m_accuracyL3C1 = mean(cell2mat(accuracyL3C1));
    m_accuracyL3C2 = mean(cell2mat(accuracyL3C2));
    m_accuracyL4C1 = mean(cell2mat(accuracyL4C1));
    m_accuracyL4C2 = mean(cell2mat(accuracyL4C2));
    m_accuracyL5C1 = mean(cell2mat(accuracyL5C1));
    m_accuracyL5C2 = mean(cell2mat(accuracyL5C2));
   
    %%
  % generates p values for your graph
%   for i = 1:length(files)
%       [h, pCent(:,i)] = ttest(singleCentPerf(:,i), dualCentPerf(:,i));
%   end
% 
%   % generates p values as strings so they can be plotted on your graph
%   for i = 1:length(files)
%       %converting obtained p values into strings
%       text = {['p=' num2str(pCent(1))],...
%               ['p=' num2str(pCent(2))],...
%               ['p=' num2str(pCent(3))],...
%               ['p=' num2str(pCent(4))],...
%               ['p=' num2str(pCent(5))],...
%             };
%   end

%graphing central dual vs single
% colors of the bar graph
map = [.3 .3 .3; 0 0 0];

% generates a subject specific title
s1 = getfield(exptData(2).exptdesign,'number');
s2 = strcat(s1,' Cat1 Vs Cat2');

%calculates the mean for you the values you want to plot
values = [m_accuracyL1C1, m_accuracyL1C2;
          m_accuracyL2C1, m_accuracyL2C2;
          m_accuracyL3C1, m_accuracyL3C2;
%           m_accuracyL4C1, m_accuracyL4C2;
%           m_accuracyL5C1, m_accuracyL5C2;
        ];
% calculates the SEM for your mean values    
errors = zeros (3,2);
% sets the figure to one default size
figure('units','normalized','position',[.1 .1 .4 .4])

% %plots the graph and saves in variable h; see barweb for what each param
% %does
h = barweb(values, errors, 1, {'Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'} ,...
    s2 , [], 'Accuracy', map, 'y', {'Cat1', 'Cat2'}, 2, [], 'northWest')

% plots p values on bars for you
% barwebpairs_positive(h, [], {[1 2] ,[1 2], [1 2], [1,2], [1,2] }, '-', text)

%saves the graph as a jpg with the subject number and title
saveFormats('test', [getfield(exptData(2).exptdesign,'number') 'Category'], './', 100)
           
   