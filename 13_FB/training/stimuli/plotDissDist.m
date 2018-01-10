tmp = importdata('trainingset-phdistanceGUGW.csv');
%tmp = importdata('trainingset-editdistanceFB.csv');
dm = tmp.data;
load('wordlist_train.mat');

thresh = [3.99, 2.45,0]; %dissimilarity threshold for levels 1-4
d = zeros(length(thresh),1);

for t=1:length(thresh)
d(t) = length(find(dm>thresh(t)));
end

