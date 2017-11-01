piezoDriver32('open','COM1');
load('TSfullsweep_48000.mat');
piezoDriver32('load',uint16(t),uint16(s));
piezoDriver32('start');
piezoDriver32('close');