%%
clear all;

s1 = load('Users/courtney/Documents/MATLAB/915s1_p.mat');
s4 = load('/Users/courtney/Documents/MATLAB/915s4_p.mat');
s5 = load('/Users/courtney/Documents/MATLAB/915s5_p.mat');
s6 = load('/Users/courtney/Documents/MATLAB/915s6_p.mat');
s7 = load('/Users/courtney/Documents/MATLAB/915s7_p.mat');
s8 = load('/Users/courtney/Documents/MATLAB/915s8_p.mat');

%%
%mean acc by pos and session at L1
s1.tAccP1L1 = [s1.accP1crossL1; s1.accP1sameL1];
s4.tAccP1L1 = [s4.accP1crossL1; s4.accP1sameL1];
s5.tAccP1L1 = [s5.accP1crossL1; s5.accP1sameL1];
s6.tAccP1L1 = [s6.accP1crossL1; s6.accP1sameL1];
s7.tAccP1L1 = [s7.accP1crossL1; s7.accP1sameL1];
s8.tAccP1L1 = [s8.accP1crossL1; s8.accP1sameL1];

s1.tAccP2L1 = [s1.accP2crossL1; s1.accP2sameL1];
s4.tAccP2L1 = [s4.accP2crossL1; s4.accP2sameL1];
s5.tAccP2L1 = [s5.accP2crossL1; s5.accP2sameL1];
s6.tAccP2L1 = [s6.accP2crossL1; s6.accP2sameL1];
s7.tAccP2L1 = [s7.accP2crossL1; s7.accP2sameL1];
s8.tAccP2L1 = [s8.accP2crossL1; s8.accP2sameL1];

s1.tAccP3L1 = [s1.accP3crossL1; s1.accP3sameL1];
s4.tAccP3L1 = [s4.accP3crossL1; s4.accP3sameL1];
s5.tAccP3L1 = [s5.accP3crossL1; s5.accP3sameL1];
s6.tAccP3L1 = [s6.accP3crossL1; s6.accP3sameL1];
s7.tAccP3L1 = [s7.accP3crossL1; s7.accP3sameL1];
s8.tAccP3L1 = [s8.accP3crossL1; s8.accP3sameL1];

s1.tAccP4L1 = [s1.accP4crossL1; s1.accP4sameL1];
s4.tAccP4L1 = [s4.accP4crossL1; s4.accP4sameL1];
s5.tAccP4L1 = [s5.accP4crossL1; s5.accP4sameL1];
s6.tAccP4L1 = [s6.accP4crossL1; s6.accP4sameL1];
s7.tAccP4L1 = [s7.accP4crossL1; s7.accP4sameL1];
s8.tAccP4L1 = [s8.accP4crossL1; s8.accP4sameL1];

%%
%mean acc by pos and session at L2
s1.tAccP1L2 = [s1.accP1crossL2; s1.accP1sameL2];
s4.tAccP1L2 = [s4.accP1crossL2; s4.accP1sameL2];
s5.tAccP1L2 = [s5.accP1crossL2; s5.accP1sameL2];
s6.tAccP1L2 = [s6.accP1crossL2; s6.accP1sameL2];
s7.tAccP1L2 = [s7.accP1crossL2; s7.accP1sameL2];
s8.tAccP1L2 = [s8.accP1crossL2; s8.accP1sameL2];

s1.tAccP2L2 = [s1.accP2crossL2; s1.accP2sameL2];
s4.tAccP2L2 = [s4.accP2crossL2; s4.accP2sameL2];
s5.tAccP2L2 = [s5.accP2crossL2; s5.accP2sameL2];
s6.tAccP2L2 = [s6.accP2crossL2; s6.accP2sameL2];
s7.tAccP2L2 = [s7.accP2crossL2; s7.accP2sameL2];
s8.tAccP2L2 = [s8.accP2crossL2; s8.accP2sameL2];

s1.tAccP3L2 = [s1.accP3crossL2; s1.accP3sameL2];
s4.tAccP3L2 = [s4.accP3crossL2; s4.accP3sameL2];
s5.tAccP3L2 = [s5.accP3crossL2; s5.accP3sameL2];
s6.tAccP3L2 = [s6.accP3crossL2; s6.accP3sameL2];
s7.tAccP3L2 = [s7.accP3crossL2; s7.accP3sameL2];
s8.tAccP3L2 = [s8.accP3crossL2; s8.accP3sameL2];

s1.tAccP4L2 = [s1.accP4crossL2; s1.accP4sameL2];
s4.tAccP4L2 = [s4.accP4crossL2; s4.accP4sameL2];
s5.tAccP4L2 = [s5.accP4crossL2; s5.accP4sameL2];
s6.tAccP4L2 = [s6.accP4crossL2; s6.accP4sameL2];
s7.tAccP4L2 = [s7.accP4crossL2; s7.accP4sameL2];
s8.tAccP4L2 = [s8.accP4crossL2; s8.accP4sameL2];
%%
%mean acc by pos and session at L3
s1.tAccP1L3 = [s1.accP1crossL3; s1.accP1sameL3];
s4.tAccP1L3 = [s4.accP1crossL3; s4.accP1sameL3];
s5.tAccP1L3 = [s5.accP1crossL3; s5.accP1sameL3];
s6.tAccP1L3 = [s6.accP1crossL3; s6.accP1sameL3];
s7.tAccP1L3 = [s7.accP1crossL3; s7.accP1sameL3];
s8.tAccP1L3 = [s8.accP1crossL3; s8.accP1sameL3];

s1.tAccP2L3 = [s1.accP2crossL3; s1.accP2sameL3];
s4.tAccP2L3 = [s4.accP2crossL3; s4.accP2sameL3];
s5.tAccP2L3 = [s5.accP2crossL3; s5.accP2sameL3];
s6.tAccP2L3 = [s6.accP2crossL3; s6.accP2sameL3];
s7.tAccP2L3 = [s7.accP2crossL3; s7.accP2sameL3];
s8.tAccP2L3 = [s8.accP2crossL3; s8.accP2sameL3];

s1.tAccP3L3 = [s1.accP3crossL3; s1.accP3sameL3];
s4.tAccP3L3 = [s4.accP3crossL3; s4.accP3sameL3];
s5.tAccP3L3 = [s5.accP3crossL3; s5.accP3sameL3];
s6.tAccP3L3 = [s6.accP3crossL3; s6.accP3sameL3];
s7.tAccP3L3 = [s7.accP3crossL3; s7.accP3sameL3];
s8.tAccP3L3 = [s8.accP3crossL3; s8.accP3sameL3];

s1.tAccP4L3 = [s1.accP4crossL3; s1.accP4sameL3];
s4.tAccP4L3 = [s4.accP4crossL3; s4.accP4sameL3];
s5.tAccP4L3 = [s5.accP4crossL3; s5.accP4sameL3];
s6.tAccP4L3 = [s6.accP4crossL3; s6.accP4sameL3];
s7.tAccP4L3 = [s7.accP4crossL3; s7.accP4sameL3];
s8.tAccP4L3 = [s8.accP4crossL3; s8.accP4sameL3];


%%
%graphing position 1 level 1
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP1L1) 
          mean(s4.tAccP1L1) 
          mean(s7.tAccP1L1) 
          mean(s8.tAccP1L1)
          ]';
      
errors = [std(s1.tAccP1L1)/sqrt(length(s1.tAccP1L1))...
          std(s4.tAccP1L1)/sqrt(length(s4.tAccP1L1))...
          std(s7.tAccP1L1)/sqrt(length(s7.tAccP1L1))...
          std(s8.tAccP1L1)/sqrt(length(s8.tAccP1L1))...
         ];

      
h = barweb(values, errors, 1, [] , 'Accuracy Cat Proto Morphs Position 1', [], 'Accuracy', [], [],...
    {'S1','S4', 'S7','S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 2 level 1
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP2L1)
          mean(s4.tAccP2L1)
          mean(s7.tAccP2L1)
          mean(s8.tAccP2L1)
          ]';

errors = [std(s1.tAccP2L1)/sqrt(length(s1.tAccP2L1))...
          std(s4.tAccP2L1)/sqrt(length(s4.tAccP2L1))...
          std(s7.tAccP2L1)/sqrt(length(s7.tAccP2L1))...
          std(s8.tAccP2L1)/sqrt(length(s8.tAccP2L1))...
         ];

      
h = barweb(values, errors, 1, [] , 'Accuracy Cat Proto Morphs Position 2', [], 'Accuracy', [], [],...
    {'S1', 'S4', 'S7', 'S7'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 3 level 1
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP3L1)
          mean(s4.tAccP3L1)
          mean(s7.tAccP3L1)
          mean(s8.tAccP3L1)
          ]';

errors = [std(s1.tAccP3L1)/sqrt(length(s1.tAccP3L1))...
          std(s4.tAccP3L1)/sqrt(length(s4.tAccP3L1))...
          std(s7.tAccP3L1)/sqrt(length(s7.tAccP3L1))...
          std(s8.tAccP3L1)/sqrt(length(s8.tAccP3L1))...
         ];

      
h = barweb(values, errors, 1, [] , 'Accuracy Cat Proto Morphs Position 3', [], 'Accuracy', [], [],...
    {'S1', 'S4', 'S7','S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 4 level 1
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP4L1)
          mean(s4.tAccP4L1)
          mean(s7.tAccP4L1)
          mean(s8.tAccP4L1)
          ]';
      
errors = [std(s1.tAccP4L1)/sqrt(length(s1.tAccP4L1))...
          std(s4.tAccP4L1)/sqrt(length(s4.tAccP4L1))...
          std(s7.tAccP4L1)/sqrt(length(s7.tAccP4L1))...
          std(s8.tAccP4L1)/sqrt(length(s8.tAccP4L1))...
         ];

      
h = barweb(values, errors, 1, [], 'Accuracy Cat Proto Morphs Position 4', [], 'Accuracy', [], [],...
    {'S1', 'S2', 'S7','S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 1 level 2
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP1L2)
          mean(s4.tAccP1L2) 
          mean(s5.tAccP1L2)
          mean(s6.tAccP1L2)
          mean(s7.tAccP1L2)
          mean(s8.tAccP1L2)
          ]';
errors = [std(s1.tAccP1L2)/sqrt(length(s1.tAccP1L2))...
          std(s4.tAccP1L2)/sqrt(length(s4.tAccP1L2))...
          std(s5.tAccP1L2)/sqrt(length(s5.tAccP1L2))...
          std(s6.tAccP1L2)/sqrt(length(s6.tAccP1L2))...
          std(s7.tAccP1L2)/sqrt(length(s7.tAccP1L2))...
          std(s8.tAccP1L2)/sqrt(length(s8.tAccP1L2))...
         ];

      
h = barweb(values, errors, 1, 'Sessions 1-8' , 'Accuracy Middle Morphs Position 1', [], 'Accuracy', [], [],...
    {'S1', 'S4', 'S5', 'S6', 'S7', 'S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 2 level 2
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP2L2)
          mean(s4.tAccP2L2)
          mean(s5.tAccP2L2) 
          mean(s6.tAccP2L2) 
          mean(s7.tAccP2L2)
          mean(s8.tAccP2L2)
          ]';
      
errors = [std(s1.tAccP2L2)/sqrt(length(s1.tAccP2L2))...
          std(s4.tAccP2L2)/sqrt(length(s4.tAccP2L2))...
          std(s5.tAccP2L2)/sqrt(length(s5.tAccP2L2))...
          std(s6.tAccP2L2)/sqrt(length(s6.tAccP2L2))...
          std(s7.tAccP2L2)/sqrt(length(s7.tAccP2L2))...
          std(s8.tAccP2L2)/sqrt(length(s8.tAccP2L2))...
         ];

      
h = barweb(values, errors, 1, 'Sessions 1-8' , 'Accuracy Middle Morphs Position 2', [], 'Accuracy', [], [],...
    {'S1', 'S4', 'S5', 'S6' 'S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 3 level 2
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP3L2)
          mean(s4.tAccP3L2) 
          mean(s5.tAccP3L2) 
          mean(s6.tAccP3L2) 
          mean(s7.tAccP3L2)
          mean(s8.tAccP3L2)
          ]';
errors = [std(s1.tAccP3L2)/sqrt(length(s1.tAccP3L2))...
          std(s4.tAccP3L2)/sqrt(length(s4.tAccP3L2))...
          std(s5.tAccP3L2)/sqrt(length(s5.tAccP3L2))...
          std(s6.tAccP3L2)/sqrt(length(s6.tAccP3L2))...
          std(s7.tAccP3L2)/sqrt(length(s7.tAccP3L2))...
          std(s8.tAccP3L2)/sqrt(length(s8.tAccP3L2))...
         ];

      
h = barweb(values, errors, 1, 'Sessions 1-8' , 'Accuracy Middle Morphs Position 3', [], 'Accuracy', [], [],...
    {'S1', 'S4', 'S5', 'S6', 'S7', 'S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 4 level 2
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP4L2) mean(s2.tAccP4L2) mean(s4.tAccP4L2) mean(s5.tAccP4L2) mean(s6.tAccP4L2) mean(s7.tAccP4L2)];
errors = [std(s1.tAccP4L2)/sqrt(length(s1.tAccP4L2))...
          std(s2.tAccP4L2)/sqrt(length(s2.tAccP4L2))...
          std(s4.tAccP4L2)/sqrt(length(s4.tAccP4L2))...
          std(s5.tAccP4L2)/sqrt(length(s5.tAccP4L2))...
          std(s6.tAccP4L2)/sqrt(length(s6.tAccP4L2))...
          std(s7.tAccP4L2)/sqrt(length(s7.tAccP4L2))...
         ];

      
h = barweb(values, errors, 1, 'Sessions 1-7' , 'Accuracy Middle Morphs Position 4', [], 'Accuracy', [], [],...
    {'S1', 'S2', 'S4', 'S5', 'S6' 'S7'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 1 level 3
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP1L3)
          mean(s4.tAccP1L3)
          mean(s5.tAccP1L3)
          mean(s6.tAccP1L3)
          mean(s7.tAccP1L3)
          mean(s8.tAccP1L3)
          ]';
      
errors = [std(s1.tAccP1L3)/sqrt(length(s1.tAccP1L3))...
          std(s4.tAccP1L3)/sqrt(length(s4.tAccP1L3))...
          std(s5.tAccP1L3)/sqrt(length(s5.tAccP1L3))...
          std(s6.tAccP1L3)/sqrt(length(s6.tAccP1L3))...
          std(s7.tAccP1L3)/sqrt(length(s7.tAccP1L3))...
          std(s8.tAccP1L3)/sqrt(length(s8.tAccP1L3))...
         ];

      
h = barweb(values, errors, 1, 'Sessions 1-8' , 'Accuracy CatBound Morphs Position 1', [], 'Accuracy', [], [],...
    {'S1', 'S4', 'S5', 'S6', 'S7', 'S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 2 level 3
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP2L3)
          mean(s4.tAccP2L3)
          mean(s5.tAccP2L3)
          mean(s6.tAccP2L3)
          mean(s7.tAccP2L3)
          mean(s8.tAccP2L3)
          ]';
      
errors = [std(s1.tAccP2L3)/sqrt(length(s1.tAccP2L3))...
          std(s4.tAccP2L3)/sqrt(length(s4.tAccP2L3))...
          std(s5.tAccP2L3)/sqrt(length(s5.tAccP2L3))...
          std(s6.tAccP2L3)/sqrt(length(s6.tAccP2L3))...
          std(s7.tAccP2L3)/sqrt(length(s7.tAccP2L3))...
          std(s8.tAccP2L3)/sqrt(length(s8.tAccP2L3))...
         ];

      
h = barweb(values, errors, 1, 'Sessions 1-8' , 'Accuracy CatBound Position 2', [], 'Accuracy', [], [],...
    {'S1' 'S4' 'S5' 'S6' 'S7' 'S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 3 level 3
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP3L3)
          mean(s4.tAccP3L3) 
          mean(s5.tAccP3L3) 
          mean(s6.tAccP3L3)
          mean(s7.tAccP3L3)
          mean(s8.tAccP3L3)
          ]';
      
errors = [std(s1.tAccP3L3)/sqrt(length(s1.tAccP3L3))...
          std(s4.tAccP3L3)/sqrt(length(s4.tAccP3L3))...
          std(s5.tAccP3L3)/sqrt(length(s5.tAccP3L3))...
          std(s6.tAccP3L3)/sqrt(length(s6.tAccP3L3))...
          std(s7.tAccP3L3)/sqrt(length(s7.tAccP3L3))...
          std(s8.tAccP3L3)/sqrt(length(s8.tAccP3L3))...
         ];

      
h = barweb(values, errors, 1, 'Sessions 1-8' , 'Accuracy CatBound Position 3', [], 'Accuracy', [], [],...
    {'S1' 'S4' 'S5' 'S6' 'S7' 'S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)

%%
%graphing position 4 level 2
%map = [.1 .8 .8 ; .2 .8 .8 ; .2 .8 .8 ; 0 0 0; .2 .8 .8 ;1 1 1; .6 .6 .6;];
values = [mean(s1.tAccP4L3) 
          mean(s4.tAccP4L3)
          mean(s5.tAccP4L3)
          mean(s6.tAccP4L3)
          mean(s7.tAccP4L3)
          mean(s8.tAccP4L3)
          ]';
      
errors = [std(s1.tAccP4L3)/sqrt(length(s1.tAccP4L3))...
          std(s4.tAccP4L3)/sqrt(length(s4.tAccP4L3))...
          std(s5.tAccP4L3)/sqrt(length(s5.tAccP4L3))...
          std(s6.tAccP4L3)/sqrt(length(s6.tAccP4L3))...
          std(s7.tAccP4L3)/sqrt(length(s7.tAccP4L3))...
          std(s8.tAccP4L3)/sqrt(length(s8.tAccP4L3))...
         ];

      
h = barweb(values, errors, 1, 'Sessions 1-8' , 'AccuracyCatBound Position 4', [], 'Accuracy', [], [],...
    {'S1' 'S4' 'S5' 'S6' 'S7' 'S8'} , 2, [], 'northWest')
%barwebpairs_positive(h, [], {[1 2; 2 3;1 3 ], []}, '-', text)
