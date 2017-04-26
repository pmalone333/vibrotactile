function meanCalc(exptFilename)
exptData = load(exptFilename);

name = exptFilename;
mAcc= mean(exptData.acc);
mRT = mean(exptData.rt);

save ([name '_mean.mat' ], 'mAcc', 'mRT')
end
