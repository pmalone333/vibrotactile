function [n] = Bvect2dec(iv)
% returns the decimal equivalent of a binary string 
%   Detailed explanation goes here
n=0;
vectnum = num2str(iv);
%    for i=1:length(vectnum)
%        if str2num(vectnum(i))>0
%            n=n+i;
%        end
%    end
    
n = bin2dec(vectnum);

return; 


