% 
% list_words = {'asa1','asa2','aza1','aza2','ada1','ada2','aka1','aka2','afa1','afa2',...
%     'aba1','aba2','ava1','ava2','ana1','ana2','ama1','ama2','aga1','aga2','apa1',...
%     'apa2','ata1','ata2'};

list_words = {'asa1','asa2','aza1','aza2','ada1','ada2','aka1','aka2','afa1','afa2',...
    'aba1','aba2','ava1','ava2','ana1','ana2','ama1','ama2','apa1',...
    'apa2','ata1','ata2'};


numChannels = 14;
window_width = 100; % num time points window width 
%xypoints_all = zeros(length(list_words),floor((num_tm_points/window_width),1),numChannels); % VCVs x channels x time points

% for w=1:length(list_words)
% 
%        load([list_words{w} '_xypoints.mat']);
%        
%        tm_counter = 1;
%        for tm=1:window_width:(length(xypoints_preproc)-window_width)
%            for c=1:numChannels
%            xypoints_all(w,tm_counter,c) = sum(xypoints_preproc(tm:tm+(window_width),c));
%            end
%            tm_counter = tm_counter+1;
%        end
%        
% end
% 
% 
% VCV_distances = [];
% 
% for c=1:numChannels
%    
%     temp = xypoints_all(:,:,c);
%     VCV_distances(c,:) = pdist(temp);
% 
%     
% end

for w=1:length(list_words)

       load([list_words{w} '_xypoints.mat']);
       
       tm_counter = 1;
       for tm=1:window_width:(length(xypoints_preproc)-window_width)
           for c=1:numChannels
           xypoints_all(w,c,tm_counter) = sum(xypoints_preproc(tm:tm+(window_width),c));
           end
           tm_counter = tm_counter+1;
       end
       
end


VCV_distances = [];

for tm=1:size(xypoints_all,3)
   
    temp = xypoints_all(:,:,tm);
    VCV_distances(tm,:) = pdist(temp);

    
end

%% get average within and between VCV distance 
VCV_distances = sum(VCV_distances,1); % sum across all channels 
VCV_distances = squareform(VCV_distances);
within_VCV_distance = zeros(1,12);
within_counter = 1;

for i=1:2:length(VCV_distances)
    within_VCV_distance(within_counter) = VCV_distances(i,i+1);
    within_counter=within_counter+1;
end

%VCV_distances = mean(VCV_distances,1);
% VCV_distances = squareform(VCV_distances);

% classifical MDS 
[Y,eigvals] = cmdscale(VCV_distances);