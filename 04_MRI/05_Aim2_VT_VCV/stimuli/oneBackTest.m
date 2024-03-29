<<<<<<< HEAD
exptdesign.debug = 0;
% get subject info
if exptdesign.debug
    number = '915';
else
    number = input('\n\nEnter Subject ID:\n\n','s');
end
exptdesign.number = number;
if isempty(number)
    name = [datestr(now,'yyyy-mm-dd-HH-MM') 'MR000'];
else
    name = [datestr(now,'yyyy-mm-dd-HH-MM') number];
end
WaitSecs(0.25);

%check if subject has data on file
exptdesign.saveDir = ['./data/' number];
if ~exist(exptdesign.saveDir,'dir')
    mkdir(exptdesign.saveDir)
end

exptdesign.subjectName = name;

%Trial/Block/Run lengths

if exptdesign.debug 
    disp('WARNING!!! YOU ARE IN DEBUG MODE') 
    exptdesign.numBlocks = 4;         
    exptdesign.numTrialsPerSession = 3;    
    exptdesign.numRuns = 1;
else
    exptdesign.numBlocks = 5;         
    exptdesign.numTrialsPerSession = 3;    
    exptdesign.numRuns = 1;
end


%fixation location/duration
exptdesign.fixationDuration =0.700;
exptdesign.stimulusPresentation = 0.900;
exptdesign.fixationImage = 'imgsscaled/fixation.bmp';  
exptdesign.imageDirectory = 'imgsscaled/';   

% Decide which response mapping you are using

%     exptdesign.response = 1;
%     exptdesign.responseBox = 0;
%     exptdesign.boxHandle = 2; % we still need this variable in the debug mode. 
% else
%     exptdesign.response = input('\n\nEnter response key profile (option 0 or 1):\n\n');
%     exptdesign.responseBox = 1;             % Controls whether we are using the keyboard or the response box for subj. responses.
% end


% exptdesign.response = input('\n\nEnter response key profile (option 0 or 1):\n\n');
% Line above is commented because now we need the RP to be 0 so that the
% correct stimulus file is generated.
exptdesign.response = 0;
exptdesign.responseBox = 0; 
exptdesign.interTrialInterval = 1.1;                % amount of time between trials

%open com3 port for button boxes
if exptdesign.responseBox
    % Ensure button-box configuration is correct
    disp('Ensure dip switches are set to E-PRIME and 5+');
    input('Hit Enter to Continue...');
    exptdesign.boxHandle = CMUBox('Open', 'pst', 'COM3', 'norelease');
end

%open com2 port for stimulator
stimGenPTB('open','COM1')

%run all 6 runs right after the last 
%%%CHANGE BACK TO 1%%%%%%%%%%%
for iRuns = 1:exptdesign.numRuns
    exptdesign.iRuns=iRuns;
    if iRuns == 1
        startOrNot = 'y';
    else
        startOrNot = input('Start the next run? y or n\n');
    end
    if strcmp(startOrNot,'y')==1
        [trialOutput.run] = oneBackTestExperiment(name,exptdesign);
    else
        fprintf(['Skipping run ' num2str(iRuns) '\n']);
    end
end

%close com3 port
if exptdesign.responseBox
    CMUBox('Close',exptdesign.boxHandle);
    handle = errordlg('Please ensure dip switches are set back to 4 and A');
    disp(handle)
end

%close com2 port 
stimGenPTB('close')
=======
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
>>>>>>> 1c2d5eada47c67a69bbfd885112ca90b9f8c02e1
