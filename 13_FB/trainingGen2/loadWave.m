%
% loadWave - load wavefoms, checking each channel for proper write
%
% for now, supports LOW BANK ONLY, for testing gestures
%
% will add waveforms to existing waveforms by reading existing header
% and modifying appropriately.
%
function rtn = loadWave(waveData, checkWrites)
    init_header = 0;

    verbose = 0;
    
    % set up doCheck
    if exist('checkWrites','var') == 0
        doCheck = 1;
    else
        doCheck = checkWrites;
    end

    % default header with one wavelet (high byte==0 is page 1)
    % assumes that all waveforms are synthesized, but can easily be
    % overridden.
    header = [155,...
        128,158,0,161,1,... % waveforms 1-3 on Page 1, 8 wavelets
        128,190,0,193,1,...
        128,222,0,225,1,...
        129,0,1,3,1,...     %waveforms 4-7 on Page 2, 16 wavelets
        129,64,1,67,1,...
        129,128,1,131,1,...
        129,192,1,195,1,...
        130,0,2,3,1,...     %waveforms 8-11 on Page 3
        130,64,2,67,1,...
        130,128,2,131,1,...
        130,192,2,195,1,...
        131,0,3,3,1,...     %waveforms 12-15 on Page 4
        131,64,3,67,1,...
        131,128,3,131,1,...
        131,192,3,195,1,...
        132,0,4,3,1,...     %waveforms 16-19 on Page 5
        132,64,4,67,1,...
        132,128,4,131,1,...
        132,192,4,195,1,...
        133,0,5,3,1,...     %waveforms 20-23 on Page 6
        133,64,5,67,1,...
        133,128,5,131,1,...
        133,192,5,195,1,...
        134,0,6,3,1,...     %waveforms 24-27 on Page 7
        134,64,6,67,1,...
        134,128,6,131,1,...
        134,192,6,195,1,...
        135,0,7,3,1,...     %waveforms 28-31 on Page 8
        135,64,7,67,1,...
        135,128,7,131,1,...
        135,192,7,195,1,...
   ];    
    % start addresses for waveform DATA
    startAddrMemory = [414, 446, 478, 512, 576, 640, 704, 768, 832, 896, 960,...
        1024, 1088, 1152, 1216, 1280, 1344, 1408, 1472, 1536, 1600, 1664, 1728,...
        1792, 1856, 1920, 1984, 2048, 2112, 2176, 2240, 2304];
    startHdrHighByteVals = [0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7];
    startHdrLowByteVals = [158, 190, 222, 0, 64, 128, 192, 0, 64, 128, 192,...
        0, 64, 128, 192, 0, 64, 128, 192, 0, 64, 128, 192,...
        0, 64, 128, 192, 0, 64, 128, 192];
    
    % in case channel is closed, open here
%     r = piezoDriverGen2('open');
%     if strcmp(r,'Gen2 piezo stimulator') == 0
%         fprintf('COM port wrong, or interface problem\n');
%         return;
%     end    
    
    if init_header == 1
        % read current waveform header (limit chunk size to 32)
        hdr = uint8(zeros(1,160));
        startAddr = 256;
        for i=1:5
            % read segment of header, waveform 1
            rtn = loadRead(16,startAddr,32);
            startAddr = startAddr + 32;
            if numel(rtn) == 0
                fprintf('read channel 1 address %d failed, aborting\n',startAddr);
                return;
            end
            start = (i-1)*32+1;
            hdr(start:start+31) = rtn;
        end

        % program default header now if no header programmed (update chans as
        % needed)
        if hdr(1) ~= 155 || hdr(2) ~= 128
            fprintf('writing initial header.... ');
            hdr = header;
            startAddr = 256;
            startIndex = 1;
            for i=1:5
                if startIndex + 32 > numel(header)
                    endIndex = numel(header);
                else
                    endIndex = startIndex + 32;
                end
                rtn = loadWrite(1:16, startAddr, header(startIndex:endIndex), doCheck, verbose);
                if rtn == 0
                    fprintf('Error writing header, aborting\n');
                    return;
                end
                startAddr = startAddr +32;
                startIndex = startIndex+32;
            end
            fprintf('done\n');
        end
    end
    
    % now parse and write waveforms, and update header info
    numWF = numel(waveData);

    for i=1:numWF
        % extract data from record
        checkVals = waveData{i};
        wf = checkVals{1};
        chans = checkVals{2};
        repeats = checkVals{3};
        data = checkVals{4};  % just check first wavelet
        if repeats > 0
            rawData = gen2ConvertWave(data); % convert to TI-valued bytes
            nBytes = numel(rawData);
        else
            data = uint8(data);  % assume in 2-s complement form already
            nBytes = numel(data);
        end
        
        % PROGRAM SAMPLED WAVEFORM
        if repeats < 0
            if wf == 1
                fprintf('ERROR - Waveform 1 may not be a sampled waveform, aborting\n');
                return;
            end
            
            % print warning if subsequent waveform(s) overwritten
            if (wf < 4 && nBytes > 28) ||(wf > 3 && nBytes > 64)
                fprintf('WARNING: Sampled waveform %d overwrites later waveform(s)!\n',wf);
            end
            
            repeats = -repeats; % undo negative
            
            % write the waveform
            rtn = loadWrite(chans, startAddrMemory(wf), data, doCheck,verbose);
            
            % update the header
            headerStart = (wf-1)*5 + 257;
            % fix data crossing page
            addpg = 0;
            addrEnd = startHdrLowByteVals(wf) + nBytes -1;
            while addrEnd > 255
                addrEnd = addrEnd - 256;
                addpg = addPg + 1;
            end
            
            % 
            hdrData = [startHdrHighByteVals(wf), startHdrLowByteVals(wf),...
                startHdrHighByteVals(wf+addpg),addrEnd,repeats];
            rr = loadWrite(chans,headerStart,hdrData,doCheck,verbose); 
            if rr == 0 || rtn == 0
                fprintf('failed\n');            
            else
                fprintf('done\n');
            end
            
        else  % synthesized waveform specified          
            if (wf < 4 && nBytes > 28) || (wf > 3 && nBytes > 64)
                printf('ERROR - Waveform %d (record %d) has too many bytes, aborting\n',wf,i);
                return;
            end

            fprintf('Writing Waveform %d (record %d) to target(s)... ',wf,i);
            % write the waveform to the specified channels
            rtn = loadWrite(chans, startAddrMemory(wf), rawData, doCheck, verbose);

            % update the header info (add 128 to indicate synthesis)
            headerStart = (wf-1)*5 + 257;
            hdrData = [startHdrHighByteVals(wf)+128, startHdrLowByteVals(wf),...
                startHdrHighByteVals(wf),startHdrLowByteVals(wf)+nBytes-1,repeats];
            if wf==1
                headerStart = 256;
                hdrData = [155, hdrData];
            end
            rr = loadWrite(chans,headerStart,hdrData, doCheck, verbose); 
            if rr == 0 || rtn == 0
                fprintf('failed\n');            
            else
                fprintf('done\n');
            end
        end
    end
end

% read data, retry 10 times if fail (chan 1-16)
% return empty array if fail
function rtn = loadRead(chan, addr, bytes, verbose)
global SportH;
    rtn = [];
    if exist('verbose','var') == 0
        verbose = 0;
    end
    for i=1:10
        try
            rtn = piezoDriverGen2('readTIlocs',addr,bytes,chan);
        catch
            i=2;
            fprintf('readTIlocs raised exception\n');
        end
        
        % if successful, return (unsuccessful return has wrong number of bytes)
        if numel(rtn) == bytes
            return;
        end
        try
            fwrite(SportH,uint8([00, 01, 23])); % reset
            fwrite(SportH,uint8([00, 01, 23])); % reset
            fwrite(SportH,uint8([00, 01, 23])); % reset
        catch
            piezoDriverGen2('sync');
        end
        %pause(0.1); % wait for error to clear
        if verbose ~= 0
            fprintf('R%d ',chan);
        else
            fprintf(',');   % indicate read error
        end
    end
    fprintf('FAILED read chan %d addr %d num %d\n',chan,addr,bytes);
    rtn = [];
end

% write data, verify with read if check == 1
% (chanList 1-16)
% return 0 if fail, 1 otherwise
function rtn = loadWrite(chans, addr, data, check, verbose)
global SportH;
    data = uint8(data);
    rtn = 0;
    for i=1:10
        r = piezoDriverGen2('writeTIlocs',addr,data,chans,verbose);
        if r == 0
            break;
        end
        fprintf('.'); % indicate write error
        pause(0.1);
    end
    if i == 10
        % failed
        return;
    end
    
    % if checking, read written data, try to rewrite to individual channels
    if check == 1
        for i=1:numel(chans)
            vals = loadRead(chans(i),addr,numel(data));
            match = 1;
            if numel(data) ~= numel(vals)
                match = 0;
            elseif(data ~= vals)
                match = 0;
            end
            
            if(match == 0)
                % try writing to single channel
                fprintf('*');
                for j=1:10
                    r = piezoDriverGen2('writeTIlocs',addr,data,chans(i));
                    if r==0 % thinks it completed
                        vals = loadRead(chans(i),addr,numel(data));
                        if data == vals
                            break;
                        end
                    end
                    fwrite(SportH,uint8([00, 01, 23])); % send reset
                end
                if j == 10
                    fprintf('FAILED to write chan=%d, addr=%d, Nbytes=%d\n',chans(i),addr,numel(data));
                    return;
                end
            end
        end
    end
    rtn = 1;    % successful if it got here
    return;
end
