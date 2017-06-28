function [ s ] = fixchannel(channels,start,stop,timediv,totduration)
%fixchannel this function takes a start channel, end channel, start time
%and stop time and computes a transition from one channel to the other
% over the avaliable time duration.  times are in milleseconds.
%  ETA 10-16-2014

            duration = timediv*(stop-start);
            resolution_re_ms = timediv*1000; 
            et = 0.0;     % elapsed time (in ms) at each interval
            nchannels = length(channels);
            stepsize = duration/nchannels;
            %s = uint16(1);
            value = timediv * start; 
            tick=1; 
            for i=1:totduration    
                for j=1:nchannels
                    s(j,i) = channels(j);
                end
            end
end

