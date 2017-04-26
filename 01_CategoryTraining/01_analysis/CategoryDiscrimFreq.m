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
            output(i,j) = {(exptData(i).trialOutput(j).stimuli(:,:))};
            accuracy(i,j) = {(exptData(i).trialOutput(j).accuracy(:,:))};
        end
    end

    %%
    for i = 1:nSessions
        for j = 1:nBlocks
            for k = 1:nTrials(i)
                catIndex1{i,j}(k) = ismember(output{i,j}(5,k), 1);
                catIndex2{i,j}(k) = ismember(output{i,j}(5,k), 1);
            end
        end
    end
                
   %%
   for i = 1:nSessions
      for j=1:nBlocks(j)
          for k=1:nTrials(i)
              if (output{i,j}(1,k)==f1(1) && catIndex1{i,j}(k) == 1)
                  accF1C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(21) && catIndex1{i,j}(k) == 0)
                  accF1C2{i,j}(k) = accuracy{i,j}(k);
              end
 
              if (output{i,j}(1,k)==f1(2) && catIndex1{i,j}(k) == 1)
                  accF2C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(20) && catIndex1{i,j}(k) == 0)
                  accF2C2{i,j}(k) = accuracy{i,j}(k);
              end
              
              if (output{i,j}(1,k)==f1(3) && catIndex1{i,j}(k) == 1)
                  accF3C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(19) && catIndex1{i,j}(k) == 0)
                  accF3C2{i,j}(k) = accuracy{i,j}(k);
              end
              
              if (output{i,j}(1,k)==f1(4) && catIndex1{i,j}(k) == 1)
                  accF4C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(18) && catIndex1{i,j}(k) == 0)
                  accF4C2{i,j}(k) = accuracy{i,j}(k);
              end
                  
              if(output{i,j}(1,k)==f1(5) && catIndex1{i,j}(k) == 1)
                  accF5C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(17) && catIndex1{i,j}(k) == 0)
                  accF5C2{i,j}(k) = accuracy{i,j}(k);
              end 
              
              if(output{i,j}(1,k)==f1(6) && catIndex1{i,j}(k) == 1)
                  accF6C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(16) && catIndex1{i,j}(k) == 0)
                  accF6C2{i,j}(k) = accuracy{i,j}(k);
              end 
              
              if(output{i,j}(1,k)==f1(7) && catIndex1{i,j}(k) == 1)
                  accF7C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(15) && catIndex1{i,j}(k) == 0)
                  accF7C2{i,j}(k) = accuracy{i,j}(k);
              end 
              
              if(output{i,j}(1,k)==f1(8) && catIndex1{i,j}(k) == 1)
                  accF8C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(14) && catIndex1{i,j}(k) == 0)
                  accF8C2{i,j}(k) = accuracy{i,j}(k);
              end
              
              if(output{i,j}(1,k)==f1(9) && catIndex1{i,j}(k) == 1)
                  accF9C1{i,j}(k) = accuracy{i,j}(k);
              elseif (output{i,j}(1,k)==f1(13) && catIndex1{i,j}(k) == 0)
                  accF9C2{i,j}(k) = accuracy{i,j}(k);
              end
              
          end
      end
   end
      
 
   accF1C1 = accF1C1(~cellfun(@isempty,accF1C1));
   accF1C2 = accF1C2(~cellfun(@isempty,accF1C2));
   accF2C1 = accF2C1(~cellfun(@isempty,accF2C1));
   accF2C2 = accF2C2(~cellfun(@isempty,accF2C2));
   accF3C1 = accF3C1(~cellfun(@isempty,accF3C1));
   accF3C2 = accF3C2(~cellfun(@isempty,accF3C2));
   accF4C1 = accF4C1(~cellfun(@isempty,accF4C1));
   accF4C2 = accF4C2(~cellfun(@isempty,accF4C2));
   accF5C1 = accF5C1(~cellfun(@isempty,accF5C1));
   accF5C2 = accF5C2(~cellfun(@isempty,accF5C2));
   accF6C1 = accF6C1(~cellfun(@isempty,accF6C1));
   accF6C2 = accF6C2(~cellfun(@isempty,accF6C2));
   accF7C1 = accF7C1(~cellfun(@isempty,accF7C1));
   accF7C2 = accF7C2(~cellfun(@isempty,accF7C2));
   accF8C1 = accF8C1(~cellfun(@isempty,accF8C1));
   accF8C2 = accF8C2(~cellfun(@isempty,accF8C2));
   accF9C1 = accF9C1(~cellfun(@isempty,accF9C1));
   accF9C2 = accF9C2(~cellfun(@isempty,accF9C2));
   
   %%
   for i = 1:size(accF1C1,1)
       accuracyF1C1{i} = sum(accF1C1{i})/16;
   end
   
   for i = 1:size(accF1C2,1)
       accuracyF1C2{i} = sum(accF1C2{i})/16;
   end
   
   for i = 1:size(accF2C1,1)
       accuracyF2C1{i} = sum(accF2C1{i})/16;
   end
   
   for i = 1:size(accF2C2,1)
       accuracyF2C2{i} = sum(accF2C2{i})/16;
   end
   
   for i = 1:size(accF3C1,1)
       accuracyF3C1{i} = sum(accF3C1{i})/16;
   end
   
   for i = 1:size(accF3C2,1)
       accuracyF3C2{i} = sum(accF3C2{i})/16;
   end
   
   for i = 1:size(accF4C1,1)
       accuracyF4C1{i} = sum(accF4C1{i})/16;
   end
   
   for i = 1:size(accF4C2,1)
       accuracyF4C2{i} = sum(accF4C2{i})/16;
   end
   
   for i = 1:size(accF5C1,1)
       accuracyF5C1{i} = sum(accF5C1{i})/16;
   end
   
   for i = 1:size(accF5C2,1)
       accuracyF5C2{i} = sum(accF5C2{i})/16;
   end
   
   for i = 1:size(accF6C1,1)
       accuracyF6C1{i} = sum(accF6C1{i})/16;
   end
   
   for i = 1:size(accF6C2,1)
       accuracyF6C2{i} = sum(accF6C2{i})/16;
   end
   
   for i = 1:size(accF7C1,1)
       accuracyF7C1{i} = sum(accF7C1{i})/16;
   end
   
   for i = 1:size(accF7C2,1)
       accuracyF7C2{i} = sum(accF7C2{i})/16;
   end
   
   for i = 1:size(accF8C1,1)
       accuracyF8C1{i} = sum(accF8C1{i})/16;
   end
   
   for i = 1:size(accF8C2,1)
       accuracyF8C2{i} = sum(accF8C2{i})/16;
   end
   
   for i = 1:size(accF9C1,1)
       accuracyF9C1{i} = sum(accF9C1{i})/16;
   end
   
   for i = 1:size(accF9C2,1)
       accuracyF9C2{i} = sum(accF9C2{i})/16;
   end
   
   
   
   %%
    m_accuracyF1C1 = mean(cell2mat(accuracyF1C1));
    m_accuracyF1C2 = mean(cell2mat(accuracyF1C2));
    m_accuracyF2C1 = mean(cell2mat(accuracyF2C1));
    m_accuracyF2C2 = mean(cell2mat(accuracyF2C2));
    m_accuracyF3C1 = mean(cell2mat(accuracyF3C1));
    m_accuracyF3C2 = mean(cell2mat(accuracyF3C2));
    m_accuracyF4C1 = mean(cell2mat(accuracyF4C1));
    m_accuracyF4C2 = mean(cell2mat(accuracyF4C2));
    m_accuracyF5C1 = mean(cell2mat(accuracyF5C1));
    m_accuracyF5C2 = mean(cell2mat(accuracyF5C2));
    m_accuracyF6C1 = mean(cell2mat(accuracyF6C1));
    m_accuracyF6C2 = mean(cell2mat(accuracyF6C2));
    m_accuracyF7C1 = mean(cell2mat(accuracyF7C1));
    m_accuracyF7C2 = mean(cell2mat(accuracyF7C2));
    m_accuracyF8C1 = mean(cell2mat(accuracyF8C1));
    m_accuracyF8C2 = mean(cell2mat(accuracyF8C2));
    m_accuracyF9C1 = mean(cell2mat(accuracyF9C1));
    m_accuracyF9C2 = mean(cell2mat(accuracyF9C2));
   
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
values = [m_accuracyF1C1, m_accuracyF1C2;
          m_accuracyF2C1, m_accuracyF2C2;
          m_accuracyF3C1, m_accuracyF3C2;
          m_accuracyF4C1, m_accuracyF4C2;
          m_accuracyF5C1, m_accuracyF5C2;
          m_accuracyF6C1, m_accuracyF6C2;
          m_accuracyF7C1, m_accuracyF7C2;
          m_accuracyF8C1, m_accuracyF8C2;
          m_accuracyF9C1, m_accuracyF9C2;
        ];
% calculates the SEM for your mean values    
errors = zeros (9,2);
% sets the figure to one default size
figure('units','normalized','position',[.1 .1 .4 .4])

% %plots the graph and saves in variable h; see barweb for what each param
% %does
h = barweb(values, errors, 1, {'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9'} ,...
    s2 , [], 'Accuracy', map, 'y', {'Cat1', 'Cat2'}, 2, [], 'northWest')

% plots p values on bars for you
% barwebpairs_positive(h, [], {[1 2] ,[1 2], [1 2], [1,2], [1,2] }, '-', text)

%saves the graph as a jpg with the subject number and title
saveFormats('test', [getfield(exptData(2).exptdesign,'number') 'CategoryFreq'], './', 100)
           
   