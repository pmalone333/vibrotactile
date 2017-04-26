files = dir('/Volumes/KINGSTON/*.mat');
for i=1:length(files)
    exptData(i,:) = load(files(i).name);
end

% map = [.3 .3 .3];
% 
% % generates a subject specific title
% 
% %calculates the mean for you the values you want to plot
for i = 1:length(exptData)
    valuesA(i) = [exptData(i).mAcc];
end

for i = 1:length(exptData)
    valuesR(i) = [exptData(i).mRT];
end


% % calculates the SEM for your mean values    
% errors = zeros (1,10);
% % sets the figure to one default size
% figure('units','normalized','position',[.1 .1 .4 .4])
% 
% % %plots the graph and saves in variable h; see barweb for what each param
% % %does
% h = barweb(values, errors, 1, {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9'} ,...
%     'Accuracy Across Session' , [], 'Accuracy', map, 'y', [], 2, [], 'northWest')

% plots p values on bars for you
% barwebpairs_positive(h, [], {[1 2] ,[1 2], [1 2], [1,2], [1,2] }, '-', text)

    %plot SOAs
    h=gcf
    subplot(2,1,1)
    %plot performance
    plot(1:length(files), valuesA);
    %legend('B1 Acc', 'B2 Acc', 'B3 Acc', 'B4 Acc', 'B5 Acc', 'B6 Acc', 'B7 Acc', 'location', 'SouthWest')
    xlabel('Session')
    ylim([0 1])
    xlim([0 11])
    title('Accuracy')
    fixFonts
    
    h=gcf
    subplot(2,1,2)
    %plot performance
    plot(1:length(files), valuesR);
    %legend('B1 Acc', 'B2 Acc', 'B3 Acc', 'B4 Acc', 'B5 Acc', 'B6 Acc', 'B7 Acc', 'location', 'SouthWest')
    xlabel('Session')
    ylim([0 1])
    xlim([0 11])
    title('RT')
    fixFonts
    
    

%saves the graph as a jpg with the subject number and title
saveFormats('test', [getfield(exptData(2).exptdesign,'number') 'Accuracy'], './', 100)
