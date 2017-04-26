%%
clear all;

s1 = load('/Volumes/KINGSTON/111/111_s1.mat');
s2 = load('/Volumes/KINGSTON/111/111_s2.mat');
s3 = load('/Volumes/KINGSTON/111/111_s3.mat');
s4 = load('/Volumes/KINGSTON/111/111_s4.mat');
s5 = load('/Volumes/KINGSTON/111/111_s5.mat');

%%
%unPaired ttest comparing each mean accuracy across session 1-3 for cat
%proto morphs

[h, p.pL1Acc(1,1)] = ttest2(s1.accL1, s2.accL1);
[h, p.pL1Acc(2,1)] = ttest2(s2.accL1, s3.accL1);
[h, p.pL1Acc(3,1)] = ttest2(s3.accL1, s4.accL1);
[h, p.pL1Acc(5,1)] = ttest2(s4.accL1, s5.accL1);
[h, p.pL1Acc(4,1)] = ttest2(s3.accL1, s5.accL1);
[h, p.pL1Acc(6,1)] = ttest2(s1.accL1, s5.accL1);

%converting obtained p values into strings
for i = length(p.pL1Acc)
    text={['p=' num2str(p.pL1Acc(1))]
          ['p=' num2str(p.pL1Acc(2))]
          ['p=' num2str(p.pL1Acc(3))]
          ['p=' num2str(p.pL1Acc(4))]
          ['p=' num2str(p.pL1Acc(5))]
          ['p=' num2str(p.pL1Acc(6))]
          };
end

%graphing
map = [.2 .2 .2; 1 1 1; .8 .8 .8; 0 0 0; .5 .5 .5];
values = [s1.maccL1 s2.maccL1 s3.maccL1 s4.maccL1 s5.maccL1];
errors = [std(s1.accL1)/sqrt(length(s1.accL1))...
          std(s2.accL1)/sqrt(length(s2.accL1))...
          std(s3.accL1)/sqrt(length(s3.accL1))...
          std(s4.accL1)/sqrt(length(s4.accL1))...
          std(s5.accL1)/sqrt(length(s5.accL1))...
         ];

     
figure('units','normalized','position',[.1 .1 .4 .4])
      
h = barweb(values, errors, 1, [], 'Cat Proto Morphs', [], 'Accuracy', map, 'y', {'Session 1', 'Session 2', 'Session 3', 'Session 4', 'Session 5'}, 2, [], 'northWest')
barwebpairs_positive(h, [], {[1 2; 2 3;3 4;4 5;3 5; 1 5], []}, '-', text)

saveFormats('test', 'AccCatProtoMorphs', './', 100)
%%
%unPaired ttest comparing each mean accuracy across session 4-6 for cat
%proto morphs

[h, p.pL1Acc(1,1)] = ttest2(s4.accL1, s5.accL1);
[h, p.pL1Acc(2,1)] = ttest2(s5.accL1, s6.accL1);
[h, p.pL1Acc(3,1)] = ttest2(s4.accL1, s6.accL1);

%converting obtained p values into strings
text={['p=' num2str(p.pL1Acc(1,1))],...
      ['p=' num2str(p.pL1Acc(2,1))],...
      ['p=' num2str(p.pL1Acc(3,1))],...
      };

%graphing
map = [.3 .3 .3; 1 1 1; .6 .6 .6];
values = [s4.maccL1 s5.maccL1 s6.maccL1];
errors = [std(s4.accL1)/sqrt(length(s4.accL1))...
          std(s5.accL1)/sqrt(length(s5.accL1))...
          std(s6.accL1)/sqrt(length(s6.accL1))
         ];


figure('units','normalized','position',[.1 .1 .4 .4])

h = barweb(values, errors, 1, [], 'Cat Proto Morphs', [], 'Accuracy', map, [], {'Session 4', 'Session 5', 'Session 6'}, 2, [], 'northWest')
barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)


%%
%unPaired ttest comparing each mean accuracy across session 1-3 for middle
%morphs

[h, p.pL2Acc(1,1)] = ttest2(s1.accL2, s2.accL2);
[h, p.pL2Acc(2,1)] = ttest2(s2.accL2, s3.accL2);
[h, p.pL2Acc(3,1)] = ttest2(s3.accL2, s4.accL2);
[h, p.pL2Acc(4,1)] = ttest2(s4.accL2, s5.accL2);
[h, p.pL2Acc(5,1)] = ttest2(s1.accL2, s5.accL2);

%converting obtained p values into strings
%converting obtained p values into strings
text={['p=' num2str(p.pL2Acc(1,1))]
      ['p=' num2str(p.pL2Acc(2,1))]
      ['p=' num2str(p.pL2Acc(3,1))]
      ['p=' num2str(p.pL2Acc(4,1))]
      ['p=' num2str(p.pL2Acc(5,1))]
      };

%graphing
map = [.3 .3 .3; 1 1 1; .6 .6 .6; 0 0 0];
values = [s1.maccL2 s2.maccL2 s3.maccL2 s4.maccL2 s5.maccL2];
errors = [std(s1.accL2)/sqrt(length(s1.accL2))...
          std(s2.accL2)/sqrt(length(s2.accL2))...
          std(s3.accL2)/sqrt(length(s3.accL2))...
          std(s4.accL2)/sqrt(length(s4.accL2))...
          std(s5.accL2)/sqrt(length(s5.accL2))...
          ];

figure('units','normalized','position',[.1 .1 .4 .4])

h = barweb(values, errors, [], [], 'Middle Morphs', [], 'Accuracy',...
    map, 'y', {'Session 1', 'Session 2', 'Session 3', 'Session 4', 'Session 5'}, 2, [], 'northWest')
barwebpairs_positive(h, [], {[1 2; 2 3;3 4;4 5;1 5 ], []}, '-', text)

saveFormats('test', 'AccMiddleMorphs', './', 100)
%%
%unPaired ttest comparing each mean accuracy across session 4-6 for middle
%morphs

[h, p.pL2Acc(1,1)] = ttest2(s4.accL2, s5.accL2);
[h, p.pL2Acc(2,1)] = ttest2(s5.accL2, s6.accL2);
[h, p.pL2Acc(3,1)] = ttest2(s4.accL2, s6.accL2);

%converting obtained p values into strings
text={['p=' num2str(p.pL2Acc(1,1))],...
      ['p=' num2str(p.pL2Acc(2,1))],...
      ['p=' num2str(p.pL2Acc(3,1))],...
      };

%graphing
map = [.3 .3 .3; 1 1 1; .6 .6 .6];
values = [s4.maccL2 s5.maccL2 s6.maccL2];
errors = [std(s4.accL2)/sqrt(length(s4.accL2))...
          std(s5.accL2)/sqrt(length(s5.accL2))...
          std(s6.accL2)/sqrt(length(s6.accL2))
         ];

figure('units','normalized','position',[.1 .1 .4 .4])      

h = barweb(values, errors, 1, [], 'Middle Morphs', [], 'Accuracy', map, [], {'Session 4', 'Session 5', 'Session 6'}, 2, [], 'northWest')
barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%unPaired ttest comparing each mean accuracy across session 4-6 for middle
%morphs

[h, p.pL2Acc(1,1)] = ttest2(s1.accL2, s4.accL2);
[h, p.pL2Acc(2,1)] = ttest2(s4.accL2, s7.accL2);
[h, p.pL2Acc(3,1)] = ttest2(s1.accL2, s7.accL2);

%converting obtained p values into strings
text={['p=' num2str(p.pL2Acc(1,1))],...
      ['p=' num2str(p.pL2Acc(2,1))],...
      ['p=' num2str(p.pL2Acc(3,1))],...
      };

%graphing
map = [.3 .3 .3; 1 1 1; .6 .6 .6];
values = [s1.maccL2 s4.maccL2 s7.maccL2];
errors = [std(s1.accL2)/sqrt(length(s1.accL2))...
          std(s4.accL2)/sqrt(length(s4.accL2))...
          std(s7.accL2)/sqrt(length(s7.accL2))
         ];


figure('units','normalized','position',[.1 .1 .4 .4])

h = barweb(values, errors, 1, [], 'Middle Morphs', [], 'Accuracy', map, [], {'Session 1', 'Session 4', 'Session 7'}, 2, [], 'northWest')
barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)


%%
%unPaired ttest comparing each mean accuracy across session 1-3 for cat
%bound morphs

%[h, p.pL3Acc(1,1)] = ttest2(s1.accL3, s2.accL3);
%[h, p.pL3Acc(2,1)] = ttest2(s2.accL3, s3.accL3);
[h, p.pL3Acc(1,1)] = ttest2(s3.accL3, s4.accL3);
[h, p.pL3Acc(2,1)] = ttest2(s4.accL3, s5.accL3);
[h, p.pL3Acc(3,1)] = ttest2(s3.accL3, s5.accL3);

%converting obtained p values into strings
%converting obtained p values into strings
text={['p=' num2str(p.pL3Acc(1,1))],...
      ['p=' num2str(p.pL3Acc(2,1))],...
      ['p=' num2str(p.pL3Acc(3,1))],...
%       ['p=' num2str(p.pL3Acc(4,1))],...
      };

%graphing
map = [.3 .3 .3; 1 1 1; .6 .6 .6; 0 0 0];
values = [s3.maccL3 s4.maccL3 s5.maccL3];
errors = [
          std(s3.accL3)/sqrt(length(s3.accL3))...
          std(s4.accL3)/sqrt(length(s4.accL3))...
          std(s5.accL3)/sqrt(length(s5.accL3))...
          ];

figure('units','normalized','position',[.1 .1 .4 .4])

h = barweb(values, errors, [], [], 'Cat Bound Morphs', [], 'Accuracy',...
    map, 'y', {'Session 3', 'Session 4', 'Session 5'}, 2, [], 'northWest')
barwebpairs_positive(h, [], {[1 2; 2 3; 1 3], []}, '-', text)

saveFormats('test', 'AccCatBoundMorphs', './', 100)
%%
%unPaired ttest comparing each mean accuracy across session 4-6 for cat
%bound morphs

[h, p.pL3Acc(1,1)] = ttest2(s4.accL3, s5.accL3);
[h, p.pL3Acc(2,1)] = ttest2(s5.accL3, s6.accL3);
[h, p.pL3Acc(3,1)] = ttest2(s4.accL3, s6.accL3);

%converting obtained p values into strings
text={['p=' num2str(p.pL3Acc(1,1))],...
      ['p=' num2str(p.pL3Acc(2,1))],...
      ['p=' num2str(p.pL3Acc(3,1))],...
      };

%graphing
map = [.3 .3 .3; 1 1 1; .6 .6 .6];
values = [s4.maccL3 s5.maccL3 s6.maccL3];
errors = [std(s4.accL3)/sqrt(length(s4.accL3))...
          std(s5.accL3)/sqrt(length(s5.accL3))...
          std(s6.accL3)/sqrt(length(s6.accL3))
         ];


figure('units','normalized','position',[.1 .1 .4 .4])

h = barweb(values, errors, 1, [], 'Cat Bound Morphs', [], 'Accuracy', map, [], {'Session 4', 'Session 5', 'Session 6'}, 2, [], 'northWest')
barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%unPaired ttest comparing each mean accuracy across session 4-6 for middle
%morphs

[h, p.pL3Acc(1,1)] = ttest2(s1.accL3, s4.accL3);
[h, p.pL3Acc(2,1)] = ttest2(s4.accL3, s7.accL3);
[h, p.pL3Acc(3,1)] = ttest2(s1.accL3, s7.accL3);

%converting obtained p values into strings
text={['p=' num2str(p.pL3Acc(1,1))],...
      ['p=' num2str(p.pL3Acc(2,1))],...
      ['p=' num2str(p.pL3Acc(3,1))],...
      };

%graphing
map = [.3 .3 .3; 1 1 1; .6 .6 .6];
values = [s1.maccL2 s4.maccL2 s7.maccL2];
errors = [std(s1.accL3)/sqrt(length(s1.accL3))...
          std(s4.accL3)/sqrt(length(s4.accL3))...
          std(s7.accL3)/sqrt(length(s7.accL3))
         ];

figure('units','normalized','position',[.1 .1 .4 .4])

h = barweb(values, errors, 1, [], 'Cat Bound Morphs', [], 'Accuracy', map, [], {'Session 1', 'Session 4', 'Session 7'}, 2, [], 'northWest')
barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)
