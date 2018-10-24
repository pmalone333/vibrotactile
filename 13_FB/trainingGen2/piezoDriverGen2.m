%
% piezoDriver32.m - driver for stimulator generator board
%
% driver for Gen-2 32-channel piezoelectric stimulator 
% using T.I. DRV2667 tactile chips
% returns requested numbers, or 0 if successful, or error string.
%
% SPE, 1/21/14, modified for 32 piezo stimulators 10/20/17
% modified 1/16/2018 for Gen2 functionality

function rtn = piezoDriverGen2(cmd, arg1, arg2, arg3, arg4, arg5)
global SportH;  %serial port object handle
persistent waveMemprogrammed;

%DEBUG = 1; % print the packets sent to the piezo driver
rtn = 'err';
verbose = 0;
ack_code = 0;
loadAck128 = 0;  % require ACK on load Gesture? yes=1, no=0

try % in case open and bytes available 
    n = SportH.BytesAvailable;
    if n ~= 0
      %fprintf('stimGen: before action, read %d\n',val);
      for i=1:n
          val = fread(SportH, 1, 'uint8');
          %fprintf('%x ',val);
      end  
    end                
catch
end

    % in case we need it below
    i256 = uint16(256);
    % parse command
    switch(cmd)
        case 'open' % open serial connection on specified port
            port = 'COM5'; %serialNames('piezo');
            if numel(port) == 0
                fprintf('Cannot find serial port with active Gen-2 stimulator\n');
                return;
            end
            
%             % default to serial COM1
%             if exist('arg1','var') == 0
%                 arg1 = 'COM4';
%             end
            
            %close any open PIC18FSerialInterface Tags
            j = instrfind;            
            for n = 1:length(j)              
                  if(strcmp(j(n).Tag,'Gen2 piezo stimulator'))                
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
                SportH = serial(port,'BaudRate',19200);
                %serial port initialization
                SportH.InputBufferSize = 512;
                SportH.OutputBufferSize = 1024;
                SportH.BytesAvailableFcnCount = 256;
                SportH.BytesAvailableFcnMode = 'byte';
                SportH.Terminator = '';
                SportH.ByteOrder = 'littleEndian';
                SportH.Timeout = 0.1;
                %s.ReadAsyncMode = 'manual';
                SportH.ReadAsyncMode = 'continuous';
                %s.BreakInterruptFcn = @serialbreak;
                SportH.Tag = 'Gen2 piezo stimulator'; %'PIC18FSerialInterface';

                fopen(SportH);
                rtn = SportH.Tag;

%                 %clear input buffer and reset PIC
%                 status = get_packet(3, SportH);
%                 if(status == -1)
%                     rtn = -1;
%                 end
                % determine whether Gen2
                isGen2 = 0;
                writeSize(1);
                fwrite(SportH,1); % TEST command
                tic();
                %val = 0;
                while toc < 2
                    if SportH.BytesAvailable ~= 0
                      val = fread(SportH, 1, 'uint8');
                      break;
                    end                
                end
                if toc > 1
                    rtn = 'err - no response from stimGen board\n';
                end      
                % need to do 2 read operations for proper function!
                readTI(0,6,4);
                readTI(0,6,4);
                waveMemprogrammed = 0; % assume that power was cycled
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
            ack_code = 1;

%         case 'testxmit'
%             for i=1:20000
%                 writeSize(1);
%                 fwrite(SportH,127);
%             end
%             return;
%             
%         case 'echo'
%             while 1
%                 str = input('>>>','s'); % get string input
%                 for i=1:numel(str)
%                    writeSize(1);
%                    fwrite(SportH,str(i));
%                 end
%                 
%                 if SportH.BytesAvailable ~= 0
%                   val = fread(SportH, 1, 'uint8');
%                   fwrite(SportH,val);
%                 end                
%             end
%             %return;
                
        case 'start' % start outputting stimulator sequence, wait for return
            writeSize(1);
            fwrite(SportH,3);
            tic();
            while toc < 7
                n = SportH.BytesAvailable;
                if n ~= 0
                  rtn = fread(SportH, n, 'uint8');
                  break;
                end                
            end
            if toc > 7
                rtn = 'err - no response from stimGen board\n';
            else
                if(rtn == 3) % completion code from board
                    rtn=0;
                else
                    fprintf('stimGen error "start": incorrect ACK = %d\n',rtn);
                    rtn = -1;
                end
            end  
            return;
            
        case 'load' % load with unsigned16 time and channel markers (from sampling)
            n = numel(arg1);
            % if only 16 chan data specified, send 0s to secondary array
            if exist('arg3','var') == 0
                arg3 = zeros(1,n);
            end
            
            if numel(arg2) ~= n || numel(arg3) ~= n
                rtn = 1;
                fprintf('err - size of time and chan arrays different\n');
                return;
            end
            writeSize(1+(6*n));
            fwrite(SportH,2);
            %fprintf('transferring pulse stimulus to piezo system...\n');
            for i=1:n
                % combine arrays
                val = arg1(i);
                % separate into bytes
                v1 = uint8(idivide(val,i256,'fix'));
                v2 = uint8(rem(val,i256));
                fwrite(SportH,v1);
                fwrite(SportH,v2);
                % combine arrays
                val = arg2(i);
                % separate into bytes
                v3 = uint8(idivide(val,i256,'fix'));
                v4 = uint8(rem(val,256));
%                 v3 = uint8(remap(idivide(val,i256,'fix')));
%                 v4 = uint8(remap(rem(val,256)));
                fwrite(SportH,v3);
                fwrite(SportH,v4);
                val = arg3(i);
                % separate into bytes
%                 v5 = uint8(remap(idivide(val,i256,'fix')));
%                 v6 = uint8(remap(rem(val,256)));
                v5 = uint8(idivide(val,i256,'fix'));
                v6 = uint8(rem(val,256));
                fwrite(SportH,v5);
                fwrite(SportH,v6);
                %fprintf('wrote: %i -> %x %x: %x %x    %x %x\n',time(i),v1,v2,v3,v4,v5,v6);
                
                % after each 256 bytes, wait for acknowledgement
                % so that device receive buffer does not overflow
                if(rem(i,42) == 0)
                    tic();
                    while toc < 5
                        n = SportH.BytesAvailable;
                        if n ~= 0
                          rtn = fread(SportH, n, 'uint8');
                          if(rtn == 2)
                              break;
                          end
                        end                
                    end
                    if toc > 5
                        rtn = 'err - load failed, no 258-byte ACK from stimGen board\n';
                        return;
                    end            
                end                
            end
            ack_code = 38;

        case 'loadGesture' % load with unsigned16 events in 'time' array
            n = numel(arg1);
            % if only 16 chan data specified, send 0s to secondary array
            writeSize(1+(2*n));
            fwrite(SportH,18);
            %fprintf('transferring gesture to piezo system... ');
            for i=1:n
                % combine arrays
                val = arg1(i);
                % separate into bytes
                v1 = uint8(idivide(val,i256,'fix'));
                v2 = uint8(rem(val,i256));
                fwrite(SportH,v1);
                fwrite(SportH,v2);
                % after each 256 bytes, wait for acknowledgement
                % so that device receive buffer does not overflow
                if((loadAck128 == 1) && (rem(i,128) == 0))
                    tic();
                    while toc < 5
                        n = SportH.BytesAvailable;
                        if n ~= 0
                          rtn = fread(SportH, n, 'uint8');
                          if(rtn == 18)
                              break;
                          end
                        end                
                    end
                    if toc > 5
                        rtn = 'err - loadGesture failed, no 256-byte ACK from stimGen board\n';
                        return;
                    else
                        if(rtn == 26) % completion code from board
                            rtn=0;
                        else
                            fprintf('stimGen board returned timeout\n');
                            rtn = -1;
                        end
                    end            
                end
            end
            if loadAck128 == 0  % wait until ACK received
                tic();
                while toc() < 2 % timeout after a few seconds
                    n = SportH.BytesAvailable;
                    if n ~= 0
                      rtn = fread(SportH, 1, 'uint8');
                      %fprintf('%d, ',rtn);
                      if(rtn == 38)
                          break;
                          rtn = 0;
                      end
                    end                
                end
                if toc() > 2
                    %rtn = -1;
                    fprintf('err - loadGesture failed, no 256-byte ACK from stimGen board\n');
                    rtn = 'err - loadGesture failed, no 256-byte ACK from stimGen board';
                end
            end
            %fprintf('done\n');
            ack_code = 0; % already processed ack
            
        case 'stop' % stop play by resetting TI board CPUs
            writeSize(1);
            fwrite(SportH,5);
            ack_code = 5;
            
        case 'sync'
            rtn = resync();
            return;
            
        case 'testWaveform' % stop play by resetting TI board CPUs
            writeSize(6);
            fwrite(SportH,8);
            if exist('arg2','var')
                writeChannels(arg2);
            else
                % target all channels
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);                
            end
            fwrite(SportH,uint8(arg1)); % waveform number to use
            ack_code = 8;
            
        case 'testStimulators' % 
            writeSize(5);
            fwrite(SportH,12);
            if exist('arg1','var')
                writeChannels(arg1);
            else
                % target all channels
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);                
            end            
            ack_code = 12;
            
        case 'externalInputs' % stop play by resetting TI board CPUs
            writeSize(8);
            fwrite(SportH,7);
            if exist(arg3)
                writeChannels(arg3);
            else
                % target all channels
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);                
            end            
            % split intensity into 2 bytes
            val = arg1;
            % separate into bytes
            v3 = uint8(idivide(val,i256,'fix'));
            v4 = uint8(rem(val,256));
            fwrite(SportH,v3);
            fwrite(SportH,v4);            
            fwrite(SportH,uint8(arg2));
            ack_code = 7;

        case 'setIntensity' % set MAX chip intensity
            writeSize(7);
            fwrite(SportH,14);
            if exist(arg2)
                writeChannels(arg2);
            else
                % target all channels
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);                
            end            
            % split intensity into 2 bytes
            val = arg1;
            % separate into bytes
            v3 = uint8(idivide(val,i256,'fix'));
            v4 = uint8(rem(val,256));
            fwrite(SportH,v3);
            fwrite(SportH,v4);            
            ack_code = 14;            
            
        case 'setMode'
            writeSize(7);
            fwrite(SportH,15);
            if exist(arg2)
                writeChannels(arg2);
            else
                % target all channels
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);                
            end            
            val = arg1;
            % separate into bytes
            v3 = uint8(idivide(val,i256,'fix'));
            v4 = uint8(rem(val,256));
            fwrite(SportH,v3);
            fwrite(SportH,v4);            
            ack_code = 15;            
            
        case 'setWaveform'
            writeSize(6);
            fwrite(SportH,16);
            if exist(arg2)
                writeChannels(arg2);
            else
                % target all channels
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);
                fwrite(SportH,255);                
            end            
            % split intensity into 2 bytes
            fwrite(SportH,uint8(arg1));
            ack_code = 16;                        
            
        % get waveform in standard format from specified channel
        % argv1 = waveform number (1...31), argv2 is channel (1...32)
        case 'getWaveform'
            rtn = [];  % bad return
            % get header info for this waveform
            headerStart = (arg1-1)*5 + 257;
            val = piezoDriverGen2('readTIlocs',headerStart,4,arg2);
            if val(1) >= uint8(128)
                val(1) = val(1) - uint8(128); % synthesis bit specifyer
            end
            if numel(val) ~= 4
                return;
            elseif val(1) ~= val(3) || val(2) >= val(4)
                return;
            end
            % get size
            numData = val(4) - val(2) +1;
            if numData > 64 
                return;
            end
            % get and return data
            wfStart = (uint16(val(1)) * uint16(256)) + uint16(val(2))+256;
            rtn = piezoDriverGen2('readTIlocs',wfStart,numData,arg2);
            fprintf('getWaveform wf=%d chan=%d: header [%d %d %d %d], %d bytes read\n',arg1,arg2,val(1),val(2),val(3),val(4),numel(rtn));
            
        %  arg1 = waveformSpecs, only arg
        % assumes that the default infrastructure is in place
        case 'programWaveforms' % write waveform data AND header info for waveform
            rtn = loadWave(arg1);
            
%             % waveform Start Addresses (low byte)
%             startHdrHighByteVals = [1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8];
%             startHdrLowByteVals = [158, 190, 222, 0, 64, 128, 192, 0, 64, 128, 192,...
%                 0, 64, 128, 192, 0, 64, 128, 192, 0, 64, 128, 192,...
%                 0, 64, 128, 192, 0, 64, 128, 192];
%             startAddMemory = [414, 446, 478, 512, 576, 640, 704, 768, 832, 896, 960,...
%                 1024, 1088, 1152, 1216, 1280, 1344, 1408, 1472, 1536, 1600, 1664, 1728,...
%                 1792, 1856, 1920, 1984, 2048, 2112, 2176, 2240, 2304];
%             
%             numWF = numel(arg1);
%             
%             for i=1:numWF
%                 % extract data from record
%                 checkVals = arg1{i};
%                 wf = checkVals{1};
%                 chans = checkVals{2};
%                 repeats = checkVals{3};
%                 data = checkVals{4};  % just check first wavelet
%                 rawData = gen2ConvertWave(data); % convert to TI-valued bytes
%                 nBytes = numel(rawData);
%                 if (wf < 4 && nBytes > 28) || (wf > 3 && nBytes > 64)
%                     printf('ERROR - Waveform line %d too many bytes, aborted operation\n',i);
%                     return;
%                 end
%                 
%                 % get the other record for this waveform
%                 %startAddr = startAddresses(wf);
%                 %endAddr = startAddr+nBytes;
%                 
%                 % write the waveform first
%                 writeTI(19,chans,startAddMemory(wf),rawData);
%                 
%                 % update the header info, but if waveform 1 also write
%                 % num header bytes
%                 headerStart = (wf-1)*5 + 257;
%                 hdrData = [startHdrHighByteVals(wf), startHdrLowByteVals(wf),...
%                     startHdrHighByteVals(wf),startHdrLowByteVals(wf)+nBytes-1,repeats];
%                 if wf==1
%                     headerStart = 256;
%                     hdrData = [155, hdrData];
%                 end
%                 writeTI(19,chans,headerStart,hdrData); 
%                 fprintf('.');
%                 fprintf('Record %d: programmed waveform %d\n',i,wf);
%             end
%             fprintf(' done\n');
            return;
            
%         case 'initDefaultWaveformTable'
%             % initialize afresh the waveform table
%            % this is the header structure that acts as lookup table for
%            % the TI chip - programmed once
%            % values given in decimal
%            % HIGH BYTE VALUES START AT 0, HIGH START ALSO 128 ADDED
%            header = [155,...
%                 1,156,1,156,1,... % waveforms 1-3 on Page 1, 8 wavelets
%                 1,188,1,188,1,...
%                 1,220,1,220,1,...
%                 2,0,2,0,1,...     %waveforms 4-7 on Page 2, 16 wavelets
%                 2,64,2,64,1,...
%                 2,128,2,128,1,...
%                 2,192,2,192,1,...
%                 3,0,3,0,1,...     %waveforms 8-11 on Page 3
%                 3,64,3,64,1,...
%                 3,128,3,128,1,...
%                 3,192,3,192,1,...
%                 4,0,4,0,1,...     %waveforms 12-15 on Page 4
%                 4,64,4,64,1,...
%                 4,128,4,128,1,...
%                 4,192,4,192,1,...
%                 5,0,5,0,1,...     %waveforms 16-19 on Page 5
%                 5,64,5,64,1,...
%                 5,128,5,128,1,...
%                 5,192,5,192,1,...
%                 6,0,6,0,1,...     %waveforms 20-23 on Page 6
%                 6,64,6,64,1,...
%                 6,128,6,128,1,...
%                 6,192,6,192,1,...
%                 7,0,7,0,1,...     %waveforms 24-27 on Page 7
%                 7,64,7,64,1,...
%                 7,128,7,128,1,...
%                 7,192,7,192,1,...
%                 8,0,8,0,1,...     %waveforms 28-31 on Page 8
%                 8,64,8,64,1,...
%                 8,128,8,128,1,...
%                 8,192,8,192,1,...
%            ];                       
%             
%            if exist('arg1','var') == 0
%                chans = 1:32;
%            else
%                chans = arg1;
%            end
%        
%            % now set up the waveform lookup table
%            writeTI(19,chans,256,header);


        case 'writeTIlocs' % write array to TI chip (addr, data, <chans>)
            if exist('arg3', 'var')
                chans = arg3;
            else
                chans = [1:64];
            end   
            %try
                if writeTI(19,chans,arg1,arg2) == 0 % 0=fail
                    return;
                end
            %catch
            %    fprintf('writeTIlocs raised exception\n');
            %    return;
            %end
            ack_code = 38;                          
            
        case 'readTIlocs' % read a sequential array of TI locations
            tic();
            
            % wait for errors to subside
            n = SportH.BytesAvailable;
            if n > 0
                val = uint8(fread(SportH, n));
%                 if verbose ~= 0
%                     if numel(val) > 10
%                         fprintf('IN ERROR LOOP! Abort WRITE');
%                         return;
%                     else
%                         fprintf('IN QUEUE: ');
%                         for i=1:numel(val)
%                             fprintf('%d ',val(i));
%                         end
%                         fprintf('\n');
%                     end
%                 end
%                 if toc() > 10
%                     return; % fail
%                 end
                pause(0.03);
            end            
            
            if SportH.BytesAvailable > 0 % assume error state
                % send stop command
                fprintf('^');
                val = uint8([0,1,23]);
                fwrite(SportH,val);
                pause(0.05);
                n = SportH.BytesAvailable;
                rr = fread(SportH, n);
            end
                
            % now try the read
            writeSize(5);
            fwrite(SportH,uint8(20));
            % chan to read (1-32)
            fwrite(SportH,uint8(arg3));
            % split start address into 2 bytes
            val = arg1;
%             v3 = uint8(remap(idivide(val,i256,'fix')));
%             v4 = uint8(remap(rem(val,256)));
            v3 = uint8(idivide(val,i256,'fix'));
            v4 = uint8(rem(val,256));
            fwrite(SportH,v3);
            fwrite(SportH,v4);   
            % n bytes processing
            if(arg2 > 256)
                fprintf('stimGen board error: cmd "readTIlocs" bytes must be <= 256\n');
                rtn = -1;  
                return;
            elseif(arg2==256)
                arg2 = 0;
            end
            tic();
            fwrite(SportH,uint8(arg2));
            i = 0;
            rtn = uint8.empty;
            while(toc() < 0.5)
                % get and output arg2+1 bytes
                n = SportH.BytesAvailable;
                if n ~= 0
                  rtn = [rtn,uint8(fread(SportH, n)')];             
                  i = i+n;
                  if(i >= arg2+1)
                      %if(rtn(end) ~= 20)
                          %fprintf('Read failed: got %d\n',rtn(end));
                      %end
                      rtn = rtn(1:end-1);
%                      fprintf('%d ',rtn);
                      break;
                  end
                end                            
            end
            if(toc >= 0.5)
                fprintf('stimGen - READ timed out after reading %d bytes\n',i);
                %rtn = 'err - timeout';
            end
            ack_code = 20;
            return; 
            
        otherwise
                fprintf('stimGen - unrecognized command %s\n',cmd);
    end
    
    % wait for expected ACK, COMMON TO ALL INSTRUCTIONS
    if(ack_code > 0)
        tic();
        while(toc() < 1)
            % get and output arg2 bytes
            n = SportH.BytesAvailable;
            if n ~= 0
                val = uint8(fread(SportH, n));
                % process error codes and response
                if(ack_code ~= val(end))
                    fprintf('r');
                    %fprintf('piezoDriverGen2:%s returned %d rather than expected %d\n',cmd,val(end),ack_code);
                else
                    rtn = 0;
                end
                break;
            end                            
        end
        if(toc >= 1)
            fprintf('stimGen - READ timed out\n');
            %rtn = 'err - timeout';
        end
    end
end

% write arbitrary bytes to TI chip(s)
% split large files into smaller ones to avoid major error issue
% return 0 if fail, -1 if success
function  rtn = writeTI(cmd,chans,addr,data,verbose)
global SportH;
    rtn = 0;
    if exist('verbose','var') == 0
        verbose = 0;
    end
    % empty input queue if not erroring, wait a while if erroring
    tic();
    % wait for errors to subside
    n = SportH.BytesAvailable;
    if n > 0
        val = uint8(fread(SportH, n));
%                 if verbose ~= 0
%                     if numel(val) > 10
%                         fprintf('IN ERROR LOOP! Abort WRITE');
%                         return;
%                     else
%                         fprintf('IN QUEUE: ');
%                         for i=1:numel(val)
%                             fprintf('%d ',val(i));
%                         end
%                         fprintf('\n');
%                     end
%                 end
%                 if toc() > 10
%                     return; % fail
%                 end
        pause(0.03);
    end            

    if SportH.BytesAvailable > 0 % assume error state
        % send stop command
        fprintf('^');
        val = uint8([0,1,23]);
        fwrite(SportH,val);
        pause(0.05);
        n = SportH.BytesAvailable;
        rr = fread(SportH, n);
    end

    % setup to do write
    TIwriteSize = 24;
    n = numel(data);
    ptr = 1;
    
    try
        % write in chunks, wait for ACK.
        while n > 0
            if n > TIwriteSize
                size = TIwriteSize;
                n = n - TIwriteSize;
            else
                size = n;
                n = 0;
            end
            writeSize(size+7);
            fwrite(SportH,uint8(cmd));
            writeChannels(chans);
            % split start address into 2 bytes
            v3 = uint8(idivide(addr,uint16(256),'fix'));
            v4 = uint8(rem(addr,256));
            fwrite(SportH,v3);
            fwrite(SportH,v4);     
            % write data here
            for i=1:size
                fwrite(SportH,uint8(data(ptr)));
                ptr = ptr + 1;
            end
            % wait a while for data to clear
            tic();
            while toc() < 0.05
            end

            % update for next data batch
            addr = addr+size;
        end
    catch
        fprintf('>');
        resync();
        return;
    end
    rtn = 1;
end

% write size
function writeSize(sz)
    rtn = 0;
global SportH;  %serial port object handle
    % write two bytes of size
    %v1 = uint8(sz/256);
    %v2 = uint8(rem(sz,256));
    sz = uint16(sz);
    v1 = uint8(idivide(sz,uint16(256),'fix'));
    v2 = uint8(rem(sz,uint16(256)));
    fwrite(SportH,v1,'sync');
    fwrite(SportH,v2,'sync');
end

% remap function to fix the bit exchange, operate on lowest 8 bits
function rtn = remap(val)
    global isGen2;

    if(isGen2 ~= 0)
        rtn = val;
        return;
    end
    
    % gen1 bit exchange
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

% function to write 4 bytes that specify channel list
function rtn = writeChannels(chans)
    rtn = uint32(0);
    
    % convert list of channels to 4-byte value
    for i=1:numel(chans)
        switch(chans(i))
            case 1
                rtn = rtn + 1;
            case 2
                rtn = rtn + 2;
            case 3
                rtn = rtn + 4;
            case 4
                rtn = rtn + 8;
            case 5
                rtn = rtn + 16;
            case 6
                rtn = rtn + 32;
            case 7
                rtn = rtn + 64;
            case 8
                rtn = rtn + 128;
            case 9
                rtn = rtn + 256;
            case 10
                rtn = rtn + 512;
            case 11
                rtn = rtn + 1024;
            case 12
                rtn = rtn + 2048;
            case 13
                rtn = rtn + 4096;
            case 14
                rtn = rtn + 8192;
            case 15
                rtn = rtn + 16384;
            case 16
                rtn = rtn + 32768;
            case 17
                rtn = rtn + 65536;
            case 18
                rtn = rtn + 2^17;
            case 19
                rtn = rtn + 2^18;
            case 20
                rtn = rtn + 2^19;
            case 21
                rtn = rtn + 2^20;
            case 22
                rtn = rtn + 2^21;
            case 23
                rtn = rtn + 2^22;
            case 24
                rtn = rtn + 2^23;
            case 25
                rtn = rtn + 2^24;
            case 26
                rtn = rtn + 2^25;
            case 27
                rtn = rtn + 2^26;
            case 28
                rtn = rtn + 2^27;
            case 29
                rtn = rtn + 2^28;
            case 30
                rtn = rtn + 2^29;
            case 31
                rtn = rtn + 2^30;
            case 32
                rtn = rtn + 2^31;
            otherwise
                fprintf('piezoDriverGen2 error: channel list includes element outside of 1:32 (%d)\n',chans(i));
                fprintf('Command run with no channels\n')
                rtn = 0;
                return;
        end
    end
    write4(rtn);
end

function write4(chans) % call with uint32, writes high-to-low order bytes
global SportH;
    % write 4 bytes fro 32-bit integer
    v(1) = uint8(bitand(chans,255));
    chans = bitsrl(chans, 8);
    v(2) = uint8(bitand(chans,255));
    chans = bitsrl(chans, 8);
    v(3) = uint8(bitand(chans,255));
    chans = bitsrl(chans, 8);
    v(4) = uint8(bitand(chans,255));

    fwrite(SportH,v(4));
    fwrite(SportH,v(3));
    fwrite(SportH,v(2));
    fwrite(SportH,v(1));    
end

function ok = resync()
global SportH
    ok = 0;
    n = SportH.BytesAvailable;
    if n > 0
        fread(SportH, n, 'uint8');
    end
    for i=1:100
        try
            fwrite(SportH,uint8(0));
            pause(0.001);
            n = SportH.BytesAvailable;
        catch
            continue; % occasional glitch
        end
        if n > 0
            rtn = fread(SportH, n, 'uint8');
        else
            rtn = [];
        end
        if numel(rtn) == 1
            if rtn == uint8(0)
                ok = 1;
                return;
            end
        end
    end
end
