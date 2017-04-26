correct = 0;
for i=1:length(trialOutput.sResp)
    if trialOutput.correctResponse(i) == -1, continue; end
    if trialOutput.sResp(i) == trialOutput.correctResponse(i), correct = correct+1; end
end