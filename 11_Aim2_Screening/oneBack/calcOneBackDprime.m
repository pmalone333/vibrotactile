h = 0;
num_same = 0;
f = 0;
num_diff = 0;

for i=1:length(trialOutput.stimuli)
   if strcmp(trialOutput.stimuli{i}{1},trialOutput.stimuli{i}{2})
       num_same = num_same + 1;
       if trialOutput.accuracy(i) == 1, h=h+1; end
   elseif ~strcmp(trialOutput.stimuli{i}{1},trialOutput.stimuli{i}{2})
       num_diff = num_diff + 1;
       if trialOutput.accuracy(i) == 0, f=f+1; end
   end
end

h = h/num_same;
f = f/num_diff;

% hit and FA rates must fall between 0 and 1
if h == 1, h = 0.99; end
if f == 0, f = 0.01; end
    
zh = norminv(h);
zf = norminv(f);

d_prime = zh - zf;