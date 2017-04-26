clear;
f1=2.^([0:.1:2]+log2(25));

%rng('shuffle')

order_cond = [load('C:\Users\User\Documents\MATLAB\Vibrotactile\04_MRI\03_RA\RAtxtFiles\forCourtney-1.txt'),...
              load('C:\Users\User\Documents\MATLAB\Vibrotactile\04_MRI\03_RA\RAtxtFiles\forCourtney-2.txt'),...
              load('C:\Users\User\Documents\MATLAB\Vibrotactile\04_MRI\03_RA\RAtxtFiles\forCourtney-3.txt'),...
              load('C:\Users\User\Documents\MATLAB\Vibrotactile\04_MRI\03_RA\RAtxtFiles\forCourtney-4.txt')];

order_condV = vertcat(order_cond(:,1), order_cond(:,2), order_cond(:,3), order_cond(:,4))';

%generate frequency pairs 5,35,65,95% steps along the morph line
frequency = [f1(2) f1(8) f1(14) f1(20); f1(20) f1(14) f1(8) f1(2)];

%generate stimulator channel pairs
s1=[1 2 3 4 5 6 1 2 3 4 5 6];
s2=[9 10 11 12 13 14 10 9 12 11 14 13];
stimulator=[s1; s2]; 

% define the stimuli
m0 = [repmat(frequency(:,1),1,40) repmat(frequency(:,2),1,10) repmat(frequency(:,3),1,10) repmat(frequency(:,4),1,41);
      repmat(stimulator,1,8), stimulator(:,8:12);
      repmat(frequency(:,1),1,40) repmat(frequency(:,2),1,10) repmat(frequency(:,3),1,10) repmat(frequency(:,4),1,41);
      repmat(stimulator,1,8), stimulator(:,8:12)];
m3w = [repmat(frequency(:,1),1,51) repmat(frequency(:,4),1,51);
       repmat(stimulator,1,8), stimulator(:,2:6), stimulator(:,12);
       repmat(frequency(:,2),1,51) repmat(frequency(:,3),1,51);
       repmat(stimulator,1,8), stimulator(:,2:6), stimulator(:,12)];
m3b = [repmat(frequency(:,2),1,102);
       repmat(stimulator,1,8), stimulator(:,6:11);
       repmat(frequency(:,3),1,102);
       repmat(stimulator,1,8), stimulator(:,6:11)];
m6 = [repmat(frequency(:,1),1,51) repmat(frequency(:,4),1,50);
      repmat(stimulator,1,8), stimulator(:,1:5);
      repmat(frequency(:,3),1,51) repmat(frequency(:,2),1,50);
      repmat(stimulator,1,8), stimulator(:,1:5)];
null = zeros(8,102);
  
%randomly shuffle stimuli
nCond1 = find(order_condV == 1);
nCond2 = find(order_condV == 2);
nCond3 = find(order_condV == 3);
nCond4 = find(order_condV == 4);
nNull = find(order_condV == 5);

nCond1 = randperm(size(nCond1,2));
nCond2 = randperm(size(nCond2,2));
nCond3 = randperm(size(nCond3,2));
nCond4 = randperm(size(nCond4,2));
nNull = randperm(size(nNull,2));


m0 = m0(:,nCond1);
m3w = m3w(:,nCond2);
m3b = m3b(:,nCond3);
m6 = m6(:,nCond4);
null = null(:,nNull);


counter1=1;
counter2=1;
counter3=1;
counter4=1;
counter5=1;

for i = 1:length(order_condV) 
    if order_condV(i)==1 && counter1 <= length(m0)
        stimuli(:,i) = m0(:,counter1);
        counter1 = counter1 +1;
    elseif order_condV(i)==2 && counter2 <= length(m3w)
        stimuli(:,i) = m3w(:,counter2);
        counter2 = counter2 +1;
    elseif order_condV(i)==3 && counter3 <= length(m3b)
        stimuli(:,i) = m3b(:,counter3);
        counter3 = counter3 +1;
    elseif order_condV(i)==4 && counter4 <= length(m6)
        stimuli(:,i) = m6(:,counter4);
        counter4 = counter4 +1;
    elseif order_condV(i)==5 && counter5 <= length(null)
        stimuli(:,i) = null(:,counter5);
        counter5 = counter5 +1;
    end
end

stimuliRun1 = stimuli(:,1:127);
stimuliRun2 = stimuli(:,128:254);
stimuliRun3 = stimuli(:,255:381); 
stimuliRun4 = stimuli(:,382:508);

save('stimuliRA','stimuliRun1','stimuliRun2','stimuliRun3', 'stimuliRun4')  

