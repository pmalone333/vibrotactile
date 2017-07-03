%
% stimGen.m - driver for stimulator generator board
%
% SPE, 1/21/14, mod 2/19/15 for PTB serial driver
function rtn = stimGenPTB(cmd, chan, time)
global SportH;  %serial port object handle

% command definitions - make same as PIC code
CMD_TEST = uint8(1);
CMD_LOAD = uint8(2);
CMD_START = uint8(3);
CMD_IGNORE = uint8(127);
CMD_INIT = uint8(4);
CMD_STOP = uint8(5);
CMD_LOAD_EXT = uint8(6);
CMD_EXTERNAL_INPUTS = uint8(7);
CMD_PULSE = uint8(8);

ACK_DID_RESET = uint8(16);
ACK_CMD_RCV = uint8(32);
ACK_TACTILE_DONE = uint8(48);
ACK_FAIL_TIMEOUT = uint8(64);
ACK_TEST = uint8(133);
ACK_LOAD = uint8(132);
ACK_OUTPUT_DONE = uint8(168);
ACK_UNKNOWN_CMD = uint8(199);
ACK_LOAD_SIZE_FAIL = uint8(220);

try % in case open and bytes available 
    n = IOPort('Read',SportH);
    if sizeof(n) ~= 0
        fprintf('stimGen: before action, read %d bytes\n',sizeof(n));
    end                
catch
end

try
    tm = toc(); % get initial time
catch
    tic();
    tm = toc(); % get initial time    
end
    % parse command
    switch(cmd)
        case 'open' % open serial connection on specified port
            % default to serial COM1
            if exist('chan','var') == 0
                chan = 'COM1';
            end
            
            % open port
            
            % try to open
            try
                
                [SportH,e]  = IOPort('OpenSerialPort',chan,'BaudRate=57600 FlowControl=None Parity=None DataBits=8 StopBits=1');
                if numel(e) > e
                    fprintf('Serial Port Open error: %s\n',e);
                    return;
                end
                %IOPort('ConfigureSerialPort', SportH, '');
                %IOPort('ConfigureSerialPort', SportH, '');
%                 SportH = serial(chan,'BaudRate',19200);
%                 %serial port initialization
%                 SportH.InputBufferSize = 512;
%                 SportH.OutputBufferSize = 256;
%                 SportH.BytesAvailableFcnCount = 1;
%                 SportH.BytesAvailableFcnMode = 'byte';
%                 SportH.Terminator = '';
%                 SportH.ByteOrder = 'littleEndian';
%                 SportH.Timeout = 0.1;
%                 %s.ReadAsyncMode = 'manual';
%                 SportH.ReadAsyncMode = 'continuous';
%                 %s.BreakInterruptFcn = @serialbreak;
%                 SportH.Tag = 'PIC18FSerialInterface';
% 
%                 fopen(SportH);
%                 rtn = SportH.Tag;

%                 %clear input buffer and reset PIC
%                 status = get_packet(3, SportH);
%                 if(status == -1)
%                     rtn = -1;
%                 end
                return;                    

            catch ME
                ME.identifier
                ME.message
                %ME.stack.file
                %ME.cause
                rtn = 'err - couldn''t open port';    
                return;
            end            
            
        case 'close' % close serial interface
            IOPort('Close',SportH);
            rtn = 'closed';            
            return;            
            
        case 'test' % test interface to make sure it is there and alive
            putPacket(CMD_TEST);
            %fwrite(SportH,1);
            %tic();
            val = 0;
            while (toc()-tm) < 1
                n = IOPort('Read',SportH);
                if numel(n) > 0
                    break;
                end
            end
            if (toc()-tm) > 1
                rtn = 'err - no response from stimGen board\n';
            elseif numel(n) > 0
                if uint8(n(1)) == ACK_TEST
                    rtn = 0;
                else
                    rtn = 'err - did not receive TEST_ACK from board';
                    fprintf('tactStimGen: received %d from board, not TEST_ACK\n',val);
                end
            end

        case 'pulse'    % single pulse on specified channels
            if exist('chan','var') == 0
                chan = 1;
            end
            barr(1) = uint8(floor(chan/256));
            barr(2) = uint8(rem(chan,256));
            putPacket(CMD_PULSE,barr);
            while (toc()-tm) < 5
                n = IOPort('Read',SportH);
                if n ~= 0
                  rtn = uint8(n(1));
                  break;
                end                
            end
            if (toc()-tm) > 5
                rtn = 'err - no response from stimGen board\n';
            else
                if(rtn == 168) % completion code form board
                    rtn=0;
                else
                    fprintf('stimGen board returned timeout\n');
                    rtn = -1;
                end
            end            
            
            
%         case 'testxmit'
%             for i=1:20000
%                 fwrite(SportH,127);
%             end
            
%         case 'echo'
%             while 1
%                 str = input('>>>','s'); % get string input
%                 for i=1:numel(str)
%                    fwrite(SportH,str(i));
%                 end
%                 
%                 if SportH.BytesAvailable ~= 0
%                   val = fread(SportH, 1, 'uint8');
%                   fwrite(SportH,val);
%                 end                
%             end
                
        case 'start' % start outputting stimulator sequence, wait for return
            putPacket(CMD_START);
            %fwrite(SportH,3);
            %tic();
            while (toc()-tm) < 5
                n = IOPort('BytesAvailable', SportH);
                if n ~= 0
                  rtn = IOPort('Read',SportH);
                  break;
                end                
            end
            if (toc()-tm) > 5
                rtn = 'err - no response from stimGen board\n';
            else
                if(rtn == 168) % completion code form board
                    rtn=0;
                else
                    fprintf('stimGen board returned timeout\n');
                    rtn = -1;
                end
            end            
            
        case 'load' % load sequence, first turn into byte array
            tic();
            n = numel(time);
            if numel(chan) ~= n
                rtn = 1;
                fprintf('err - size of time and chan arrays different\n');
                return;
            end
            barr = zeros(1,n*4,'uint8'); % storage for byte array
            barrp = 1; %pointer
            %fwrite(SportH,2);
            %fprintf('transferring to stimGen...');
            for i=1:n
                % interleave time and chan info
                val = double(time(i));
                % separate into bytes
                barr(barrp) = uint8(floor(val/256));
                barrp = barrp+1;
                barr(barrp) = uint8(rem(val,256));
                barrp = barrp+1;
                
                val = double(chan(i));
                barr(barrp) = uint8(floor(val/256));
                barrp = barrp+1;
                barr(barrp) = uint8(rem(val,256));
                barrp = barrp+1;
                % delay a tad - commented out on 11/11/16 according to
                % Silvio's suggestion to fix the long load times for aim 2
                % sitmuli 
%                 dly=toc(); 
%                 while toc()<(dly+0.01)
%                 end
            end
            
            % send packet
            fprintf('transferring to stimGen...');
            putPacket(CMD_LOAD,barr);
            
            % wait for response, or timeout
            %tic();
            good = 0;
            while (toc()-tm) < 10
                n = IOPort('BytesAvailable', SportH);
                if n >= 1
                    rtn = IOPort('Read',SportH);
                    if rtn == ACK_CMD_RCV
                        fprintf('\n');
                        good = 1;
                        break;
                    end
                end
            end
            rtn = barr;
            if good == 0
                fprintf('MATLAB timed out\n');
            end
            
% delay
% tic();
% while toc < 0.50
% end
% n = SportH.BytesAvailable
% if n>0
%  rtn = fread(SportH, n, 'uint8');
% else
%     fprintf('no bytes available!\n');
% end            
        otherwise
            fprintf('stimGen - unrecognized command %s\n',cmd);
    end

end

%
% putPacket - send packet of info to PIC: timeouts used
% format: two bytes indicating number of arg bytes to be sent
% then single-byte command, then specified arg bytes (often none)
function putPacket(cmd,arg)
global SportH;

% if no arg, bytes==1 (command only)
if exist('arg','var') == 0
    nbytes = 1;
    arg = [];
else
    nbytes = numel(arg)+1;
end

byts = zeros(1,2+nbytes,'uint8');
byts(1) = uint8(floor(nbytes/256));
byts(2) = uint8(rem(nbytes,256));
byts(3) = uint8(cmd);
byts(4:end) = arg;% nbytesL = uint8(rem(nbytes,256));
% nbytesH = uint8(floor(nbytes/256));


% put size
% fwrite(SportH,nbytesH);
% fwrite(SportH,nbytesL);
% fwrite(SportH,uint8(cmd));
% 
% % put arg,if any
% if nbytes>1
%     for i=1:nbytes-1
%         fwrite(SportH,uint8(arg(i)));
%     end
% end
IOPort('Write', SportH, byts);
IOPort('Purge', SportH);
end