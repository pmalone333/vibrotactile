stimOrder = {{'aza1','aba1'},{'apa1','apa1'},{'ava2','asa1'},{'ada1','afa1'},{'aga2','aga2'},{'afa1','aga1'} ... 
             {'ana1','ada2'},{'ada1','aga1'},{'aga2','aza1'},{'ada1','afa1'},{'aga2','aga2'},{'aza1','ava2'} ... 
             {'apa2','ata1'},{'aba1','asa2'},{'asa2','ava1'},{'ama1','ama1'},{'aga2','ama1'},{'afa1','ava1'} ... 
             {'aba1','aza2'},{'aza1','aza1'},{'ata2','afa1'},{'aka1','afa1'},{'ada1','aba2'},{'afa1','aga1'} ... 
             {'aka1','aka1'},{'ava2','asa1'},{'ava2','asa1'},{'ada2','afa2'},{'aga2','aga2'},{'ama2','apa1'} ... 
             {'aza1','aba1'},{'apa1','apa1'},{'ava2','asa1'},{'ada1','afa1'},{'aga2','aga2'},{'afa1','aga1'} ... 
             {'ana1','ada2'},{'ada1','aga1'},{'aga2','aza1'},{'ada1','afa1'},{'aga2','aga2'},{'aza1','ava2'} ... 
             {'apa2','ata1'},{'aba1','asa2'},{'asa2','ava1'},{'ama1','ama1'},{'aga2','ama1'},{'afa1','ava1'} ... 
             {'aba1','aza2'},{'aza1','aza1'},{'ata2','afa1'},{'aka1','afa1'},{'ada1','aba2'},{'afa1','aga1'} ... 
             {'aka1','aka1'},{'ava2','asa1'},{'ava2','asa1'},{'ada2','afa2'},{'aga2','aga2'},{'ama2','apa1'}};
         
order = randperm(length(stimOrder));
stimOrder = stimOrder(order);


accuracy = zeroes(length(stimOrder));

stimGenPTB('open','COM1')

for i=1:length(stimOrder)
    
    load(stimOrder{i}(1));
    tm = tactStim{1}{1};
    tm = tm/4; % changed because of a slower sampling rate on new pulseCapture software 
    ch = tactStim{1}{2};
    ch = remapChanVoc(ch); % mapping function from Silvio

    stimGenPTB('load',ch,tm);
    stimGenPTB('start');
    load(stimOrder{i}(1));
    tm = tactStim{1}{1};
    tm = tm/4; % changed because of a slower sampling rate on new pulseCapture software 
    ch = tactStim{1}{2};
    ch = remapChanVoc(ch); % mapping function from Silvio
    stimGenPTB('load',ch,tm);
    WaitSecs(1);
    stimGenPTB('start')
    
    [nx, ny, bbox] = DrawFormattedText(w, ['Were the vibrations the same?'], 'center', 'center', 1);
    [RespVBLTimestamp RespOnsetTime RespFlipTimestamp RespMissed] = Screen('Flip', w);
    while 1
        % Check the state of the keyboard.
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            sResp = KbName(keyCode);
            break
            while KbCheck; end
        end
    end
    
    if strcmp(stimOrder{i}(1),stimOrder{i}(2)), accuracy(i) = 1; end
    WaitSecs(1)
end
