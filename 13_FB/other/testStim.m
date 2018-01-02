piezoDriver32('open','COM5');
load('TSbus.mat');
piezoDriver32('load',t,s);
piezoDriver32('start');
piezoDriver32('close');