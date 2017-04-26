f1=2.^([0:.1:2]+log2(25));
for i = 1:length(trialOutput)
    freqCP = 0;
    freqMM = 0;
    freqCB = 0;
    for j = 1:length(trialOutput(i).stimuli)
        if any(f1(1:3) == trialOutput(i).stimuli(1,j)) == 1
            freqCP = freqCP + 1;
        elseif any(f1(4:6) == trialOutput(i).stimuli(1,j)) == 1
            freqMM = freqMM + 1;
        elseif any(f1(7:9) == trialOutput(i).stimuli(1,j)) == 1
            freqCB = freqCB + 1;
        end
    end
    freqCP_block(i) = freqCP;
    freqMM_block(i) = freqMM;
    freqCB_block(i) = freqCB;
end