function [t, s] = mat2stim (m,dur,chan,outputDevice)
%mat2stim takes a matrix of dimensions duration and channels that defines
% stimulus space and then returns the t and s arrays to send to the
% stimulator. ETA 11/14/14
%   Detailed explanation goes here

%[w l]=size(m);
   t = zeros(1,1,'double');
   s = zeros(1,1,'double');
%t = zeros(1,l+1);
step = 1;
%vect = m(1:chan,1);
%s(step) = Bvect2dec(transpose(vect));
%step = step + 1;
%s = zeros(1,l+1);
%timecounter = 1;
for i = 1:dur
    vect = m(1:chan,i);
    %vect = fliplr(vect1);
    if (sum(vect) > 0)
%        temps = 0;
%        for j = 1:chan
%            if (vect(j)>0)
%            temps = temps + j
%            end
%        end
%      if (step > 1)   
%        t(step-1) = timecounter;
        t(step) = i;
        if outputDevice == 0
        s(step) = Bvect2dec(remap2device_old(fliplr(transpose(vect))));
        end
        if outputDevice == 1
        s(step) = Bvect2dec(remap2device(fliplr(transpose(vect))));
        end

        %        s(step) = temps;
        step=step+1;
%        timecounter = 1;
      %else
      %  s(step) = Bvect2dec(transpose(vect));
      %  step=step+1;
      end
%    else
%        timecounter=timecounter + 1;
%    end
end
totsteps=sum(t);
%t(step)= dur-totsteps;
%t(step)=0;
%s(step)=0;
end


