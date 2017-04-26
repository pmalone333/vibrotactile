f1=2.^([0:.1:2]+log2(25));

load('/Users/courtney/Desktop/erraruns/forCourtney-1.txt')
%generate frequency pairs 5,35,65,95% steps along the morph line
frequency = [f1(2) f1(8) f1(14) f1(20); f1(20) f1(14) f1(8) f1(2)];

%generate stimulator channel pairs
s1=[1 2 3 4 5 6 1 2 3 4 5 6];
s2=[9 10 11 12 13 14 10 9 12 11 14 13];
stimulator=[s1; s2];   

%comparisons along morph lines
m0 = [repmat(frequency(:,1),1,36) repmat(frequency(:,2),1,24) repmat(frequency(:,3),1,24) repmat(frequency(:,4),1,36);
      repmat(stimulator,1,10);
      repmat(frequency(:,1),1,36) repmat(frequency(:,2),1,24) repmat(frequency(:,3),1,24) repmat(frequency(:,4),1,36);
      repmat(stimulator,1,10)];
m3w = [repmat(frequency(:,1),1,24) repmat(frequency(:,4),1,24);
       repmat(stimulator,1,4)
       repmat(frequency(:,2),1,24) repmat(frequency(:,3),1,24);
       repmat(stimulator,1,4)];
m3b = [repmat(frequency(:,2),1,24);
       repmat(stimulator,1,2);
       repmat(frequency(:,3),1,24);
       repmat(stimulator,1,2)];
m6 = [repmat(frequency(:,1),1,24) repmat(frequency(:,4),1,24);
      repmat(stimulator,1,4);
      repmat(frequency(:,3),1,24) repmat(frequency(:,2),1,24);
      repmat(stimulator,1,4)];

stimuli = [m0, m3w, m3b, m6];
% populate stimuli file
save ('RAstimuli.mat','stimuli')
