%
% remap channels on stimulstor
% input: uint16 from vocoder sampling sampling or synthesis
% LOOKING AT STIMULATOR side of assembly from elbow end, stim 1 is on 
% wrist end RIGHT SIDE
%
% output: uint16 array that can be passed to the stim 'load' command
% SPE 7/12/16 - based on Ed's code
function newchan = remapChanVoc(inArray)

n = numel(inArray);
newchan = zeros(1,n,'uint16');
imap = [11,4,13,6,12,5,14,7,1,8,3,10,2,9]; % bit 11 is lowest frequency ....  bit 9 is highpass filter
omap = [1024,8,4096,32,2048,16,8192,64,1,128,4,512,2,256]; % val 1024 activates lowest freq stimulator... 256 highest freq

for i=1:n
    % look at each bit and set appropriate output bit
    for b=1:14
        bt = imap(b);
        if bitget(inArray(i),bt) == 1        
            newchan(i) = newchan(i) + omap(b);
        end
    end
end % loop
end % function
