%
% playStim - play specified stimuli, using keyboard to control
% can specify up to 10 stimuli, output with keys 1,2,3,4,5,6,7,8,9,0
%
% ARG: 
%  - can be name of a .mat file to load, with cell named 'config'
% OR
% - config = {{waveforms},{stim1},<{stim2}>...<{stim10}>}
% omit loading waveform data by using {} as first element
%
function playStim(config)
    % connect with stimulator box
    r = piezoDriverGen2('open');
    if strcmp(r,'Gen2 piezo stimulator') == 0
        fprintf('Piezo Stim System offline, or interface problem\n');
        return;
    end

    % if config a string, try loading MATLAB .mat file
    if exist('config','var') == 0
        run('doconfig.m'); % if it does not exist, exception
    elseif ischar(config) == 1
        load(config);
    end
    
    % program waveforms, if specified
    n = numel(config);
    n1 = numel(config{1});
    if n1 > 0
        % load specified waveforms
        loadWave(config{1});
    end
    
    % now extract raw gesture data into cell of arrays
    stim = cell(1,n-1);
    for i=2:n
        stim{i-1} = gen2ConvertGesture(config{i});
    end
    
    nStim = n-1;
    curStim = 100;
    if nStim == 0
        fprintf('playStim: no stimuli specified, format: {{waveforms},{stim1}...}\n');
    else
        fprintf('Push numeric key+enter to play associated waveform, enter to repeat last, x + enter to exit\n');
        while 1
            doload = -1;
            play = -1;
            % wait for keypress to specify which waveform to play
            num = input('stim > ','s');
            if numel(num) == 1 && num >= '0' && num <= '9'
                idx = str2num(num);
                if(idx == 0) 
                    idx = 10;
                end
                if idx > nStim
                    fprintf('Only %d stimuli specified 1-10(=0)\n',nStim-1);
                else
                    if idx ~= curStim
                        doload = idx;
                    end
                    play = 1;
                end
            elseif numel(num) == 0
                if curStim <= nStim
                    play = 1;
                end
            elseif num(1) == 'x' || num(1) == 'X'
                piezoDriverGen2('close');
                return;    
            else
                fprintf('Unknown input (keys 1-10, x/X allowed\n');
            end
                
            % load stimulus
            if doload ~= -1
                piezoDriverGen2('loadGesture',stim{doload});
                curStim = doload;
            end
            % play 
            if play == 1
                piezoDriverGen2('start');
            end
        end
    end
    piezoDriverGen2('close');
end
