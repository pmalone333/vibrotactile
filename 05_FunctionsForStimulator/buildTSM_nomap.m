function [ t, s ] = buildTSM_nomap( defMatrix, outputDevice )
%2/9/15 suppress the mapping output
% BuildTSM This function is the command driven version of
% what will become a GUI for stimulus development
% defMatrix contains the definition of the stimuli
% in the tactile stimulus montage (TSM).
% this function:
% 1 Reads in a defMatrix 
% 2 generates the TSM
% 3 Displays the TSM 
% 4 return T and S vectors that for output to the device 
%    and presentation of the TSM.
% 7/1/15 added alternate output display options ETA
maxstimdur = 1001;  % Sets the maximum stim duration in Milliseconds
timediv = 1; % Sets the time subdivision in terms of 1/x milliseconds
TSMdur = maxstimdur * timediv;
nchannels = 14;
TSM = zeros(nchannels,TSMdur);
%default to old style output board if not specified for backward
%compatibility
if exist('outputDevice', 'var') == 0
     outputDevice=1;
    end
% 1 Read in a defMatrix

    if exist('defMatrix', 'var') == 0
        load(defMatrix);
    end

% 2 generate the TSM

for j=1:2:numel(defMatrix)

    S = zeros(1,TSMdur);

    cmd = defMatrix{j};
        
        switch cmd{1}
            case 'fixed'
        
            pps = cmd{2};
            start = cmd{3};
            stop = cmd{4};
            times = fixedfreq(pps,start,stop,timediv);

            case 'linear'
        
            pps1 = cmd{2};
            pps2 = cmd{3};
            start = cmd{4};
            stop = cmd{5};
            times = linfreq(pps1,pps2,start,stop,timediv);
            case 'burst'
            pattern = cmd{2};    
            pps = cmd{3};
            delay = cmd{4};
            start = cmd{5};
            stop = cmd{6};
            times = burstfreq(pattern,pps,delay,start,stop,timediv);
                
        end

        
    cmd = defMatrix{j+1};
        
        switch cmd{1}
            case 'fixchan'        

            channel = cmd{2};
            s=fixchannel(channel,0,TSMdur,timediv,maxstimdur);
            
            case 'linchan'
            channel = cmd{2};
            start = cmd{3};
            stop = cmd{4};
            s=linchannel(channel,start,stop,timediv,maxstimdur);
        
            case 'durchannel'
            channels = cmd{2};
            s=durchannel(channels,timediv,maxstimdur);
        
        end
             t=0;   
             matsiz = size(s);

            for i = 1:length(times)
               
%            interval = round(times(i),0);
                interval = times(i);
                t = t + interval; % offset by 1 
                
                if t<=maxstimdur
                    for j = 1:matsiz(1)
                    if s(j,t) > 0
                     TSM(s(j,t),t)=1;
                    end
                    end
               end
            end
end       
% 3 return T and S vectors that for output to the device
 
    [t,s]=mat2stim(TSM,TSMdur/timediv,nchannels,outputDevice); % correct the initial pulse issue

% 4 Display the TSM 
 
%    mapit(t,s);



end

