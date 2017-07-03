function [ t ] = fixedfreq( pr,start,stop,timediv)
% fixedfreq this function generates the pulse times for
% a pulse of fixed frequency 
% acceptable pulse rates are between 1 and 250 pulses per second
% start and stop times are in milliseconds
minpr = 1;
maxpr = 250;
t = uint16(1);
if pr >= minpr && pr <= maxpr
    duration = round(timediv *(stop-start));
    interval = round((timediv* 1000)/pr);
    numpulses = round(duration/interval);
    value = start*timediv;
      for i = 1:numpulses
        t(i) = value;
        value = interval;
    end
    errorcode = 'ok';
else
    errorcode = 'invalid pulse rate';  
end