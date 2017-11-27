%
% piezoDriver32.m - driver for stimulator generator board
%
% 
%
% SPE, 1/21/14, modified for 32 piezo stimulators 10/20/17

function rtn = piezoDriver32(cmd, time, chansA, chansB)
global SportH;  %serial port object handle

try % in case open and bytes available 
    n = SportH.BytesAvailable;
    if n ~= 0
      val = fread(SportH, n, 'uint8');
      fprintf('stimGen: before action, read %d\n',val);
    end                
catch
end

    % parse command
    switch(cmd)
        case 'open' % open serial connection on specified port
            % default to serial COM1
            if exist('time','var') == 0
                time = 'COM1';
            end
            
            %close any open PIC18FSerialInterface Tags
            j = instrfind;            
            for n = 1:length(j)              
                  if(strcmp(j(n).Tag,'PIC18FSerialInterface'))                
                        fclose(j(n));
                        delete(j(n));               
                  end             
            end
            if(isa(SportH,'serial'))
                  delete(SportH);
            end
            SportH = 0;

            % try to open
            try
                SportH = serial(time,'BaudRate',19200);
                %serial port initialization
                SportH.InputBufferSize = 512;
                SportH.OutputBufferSize = 256;
                SportH.BytesAvailableFcnCount = 256;
                SportH.BytesAvailableFcnMode = 'byte';
                SportH.Terminator = '';
                SportH.ByteOrder = 'littleEndian';
                SportH.Timeout = 0.1;
                %s.ReadAsyncMode = 'manual';
                SportH.ReadAsyncMode = 'continuous';
                %s.BreakInterruptFcn = @serialbreak;
                SportH.Tag = 'PIC18FSerialInterface';

                fopen(SportH);
                rtn = SportH.Tag;

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
            j = instrfind;            
            for n = 1:length(j)              
                  if(strcmp(j(n).Tag,'PIC18FSerialInterface'))                
                        fclose(j(n));
                        delete(j(n));               
                  end             
            end
            
            if(isa(SportH,'serial'))
                  delete(SportH);
            end
            SportH = 0;
            rtn = 'closed';            
            return;            
            
        case 'test' % test interface to make sure it is there and alive
            writeSize(1);
            fwrite(SportH,1);
            tic();
            val = 0;
            while toc < 1
                if SportH.BytesAvailable ~= 0
                  val = fread(SportH, 1, 'uint8');
                  break;
                end                
            end
            if toc > 1
                rtn = 'err - no response from stimGen board\n';
            else
                if val == 132
                    rtn = 0;
                else
                    rtn = 'err - did not receive 132 from board';
                    fprintf('tactStimGen: received %d from board, not 132\n',val);
                end
            end

        case 'testxmit'
            for i=1:20000
                writeSize(1);
                fwrite(SportH,127);
            end
            
        case 'echo'
            while 1
                str = input('>>>','s'); % get string input
                for i=1:numel(str)
                   writeSize(1);
                   fwrite(SportH,str(i));
                end
                
                if SportH.BytesAvailable ~= 0
                  val = fread(SportH, 1, 'uint8');
                  fwrite(SportH,val);
                end                
            end
                
        case 'start' % start outputting stimulator sequence, wait for return
            writeSize(1);
            fwrite(SportH,3);
            tic();
            while toc < 5
                n = SportH.BytesAvailable;
                if n ~= 0
                  rtn = fread(SportH, n, 'uint8');
                  break;
                end                
            end
            if toc > 5
                rtn = 'err - no response from stimGen board\n';
            else
                if(rtn == 168) % completion code form board
                    rtn=0;
                else
                    fprintf('stimGen board returned timeout\n');
                    rtn = -1;
                end
            end            
            
        case 'load' % load with unsigned16 time and channel markers (from sampling)
            n = numel(time);
            % if only 16 chan data specified, send 0s to secondary array
            if exist('chansB','var') == 0
                chansB = zeros(1,n);
            end
            
            if numel(chansA) ~= n || numel(chansB) ~= n
                rtn = 1;
                fprintf('err - size of time and chan arrays different\n');
                return;
            end
            writeSize(1+(6*n));
            fwrite(SportH,2);
            fprintf('transferring to piezo system...\n');
            i256 = uint16(256);
            for i=1:n
                % combine arrays
                val = time(i);
                % separate into bytes
                v1 = uint8(idivide(val,i256,'fix'));
                v2 = uint8(rem(val,i256));
                fwrite(SportH,v1);
                fwrite(SportH,v2);
                % combine arrays
                val = chansA(i);
                % separate into bytes
                v3 = uint8(remap(idivide(val,i256,'fix')));
                v4 = uint8(remap(rem(val,256)));
                fwrite(SportH,v3);
                fwrite(SportH,v4);
                val = chansB(i);
                % separate into bytes
                v5 = uint8(remap(idivide(val,i256,'fix')));
                v6 = uint8(remap(rem(val,256)));
                fwrite(SportH,v5);
                fwrite(SportH,v6);
                fprintf('wrote: %i -> %x %x: %x %x    %x %x\n',time(i),v1,v2,v3,v4,v5,v6); 
            end            
            
%         case 'load' % load sequence
%             n = numel(time);
%             if numel(chan) ~= n
%                 rtn = 1;
%                 fprintf('err - size of time and chan arrays different\n');
%                 return;
%             end
%             writeSize(1+(2*n));
%             fwrite(SportH,2);
%             fprintf('transferring to stimGen...\n');
%             for i=1:n
%                 % combine arrays
%                 val = time(i) + (chan(i)* 4096);
%                 % separate into bytes
%                 v1 = uint8(val/256);
%                 v2 = uint8(rem(val,256));
%                 fwrite(SportH,v1);
%                 fwrite(SportH,v2);
%                 fprintf('%d: %d (%x, %x)\n',i,val,v1, v2);
%             end
% delay
tic();
while toc < 2.0
    if SportH.BytesAvailable>0
        break;
    end
end

n = SportH.BytesAvailable;
if n>0
 rtn = fread(SportH, n, 'uint8');
else
    fprintf('no acknowledgement after 2 seconds!\n');
end            
    otherwise
            fprintf('stimGen - unrecognized command %s\n',cmd);
    end
end
% write size
function writeSize(sz)
global SportH;  %serial port object handle
    % write two bytes of size
    %v1 = uint8(sz/256);
    %v2 = uint8(rem(sz,256));
    sz = uint16(sz);
    v1 = uint8(idivide(sz,uint16(256),'fix'));
    v2 = uint8(rem(sz,uint16(256)));

    fwrite(SportH,v1);
    fwrite(SportH,v2);
end
% remap function to fix the bit exchange, operate on lowest 8 bits
function rtn = remap(val)
    rtn = bitand(val,153); % good bits that don't need reversing
    if bitand(val,2) ~= 0
        rtn = rtn + 4;
    end
    if bitand(val,4) ~= 0
        rtn = rtn + 2;
    end
    
    if bitand(val,32) ~= 0
        rtn = rtn + 64;
    end
    if bitand(val,64) ~= 0
        rtn = rtn + 32;
    end    
end


