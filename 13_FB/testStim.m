piezoDriver32('open','COM5');
load('M_6000.mat');
piezoDriver32('load',t,s);
piezoDriver32('start');
piezoDriver32('close');