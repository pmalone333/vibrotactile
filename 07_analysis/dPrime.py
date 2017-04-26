from scipy import stats
import statistics as stat
from scipy.special import ndtri

class Dprime:
    def __init__(self):
        self.TPR = []
        self.FPR = []
        self.TNR = []
        self.FNR = []
        self.totalTP = []
        self.totalFP = []
        self.totalTN = []
        self.totalFN = []

    def parseData(self, accuracy, stimuli, flag):
        for iSubject in range(len(accuracy)):
            truePositive = []
            falsePositive = []
            trueNegative = []
            falseNegative = []
            for iBlock in range(accuracy[iSubject].size):
                for iTrial in range(accuracy[iSubject][0,iBlock].size):
                    if flag == 'p':
                        if iSubject == 0 or iSubject == 1 or iSubject == 2:
                            stim1 = int(stimuli[iSubject][0,iBlock][0,iTrial])
                            stim2 = int(stimuli[iSubject][0,iBlock][2,iTrial])
                        else:
                            stim1 = int(stimuli[iSubject][0,iBlock][1,iTrial])
                            stim2 = int(stimuli[iSubject][0,iBlock][3,iTrial])
                    else:
                        stim1 = int(stimuli[iSubject][0,iBlock][0,iTrial])
                        stim2 = int(stimuli[iSubject][0,iBlock][2,iTrial])

                    if stim1 != stim2:
                        if accuracy[iSubject][0,iBlock][0,iTrial] == 1:
                            truePositive.append(1)
                        elif accuracy[iSubject][0,iBlock][0,iTrial] != 1:
                            falseNegative.append(1)
                        else:
                            print("Sorry something seems to be wrong with your parse data function in your dprime class")
                            print("Here are the different stimuli that are not being parsed")
                            print(stim1, stim2)
                    elif stim1 == stim2:
                        if accuracy[iSubject][0,iBlock][0,iTrial] == 1:
                            trueNegative.append(1)
                        elif accuracy[iSubject][0,iBlock][0,iTrial] != 1:
                            falsePositive.append(1)
                        else:
                            print("Sorry something seems to be wrong with your parse data function in your dprime class")
                            print("Here are the same stimuli that are not being parsed")
                            print(stim1, stim2)
            self.TPR.append(sum(truePositive)/sum(truePositive + falseNegative))
            self.FPR.append(sum(falsePositive)/sum(trueNegative + falsePositive))
            self.TNR.append(sum(trueNegative)/sum(trueNegative + falsePositive))
            self.FNR.append(sum(falseNegative)/sum(truePositive + falseNegative))
            self.totalTP.append(sum(truePositive))
            self.totalFP.append(sum(falsePositive))
            self.totalTN.append(sum(trueNegative))
            self.totalFN.append(sum(falseNegative))

    def zscore(self):
        zscore = [stats.zscore(self.TPR), stats.zscore(self.FPR),
                  stats.zscore(self.TNR), stats.zscore(self.FNR)]

        return zscore

    def dPrimeCalc(self, accuracy, stimuli, flag):
        dprime = []
        self.parseData(accuracy, stimuli, flag)
        for index, value in enumerate(self.TPR):
            dprime.append(ndtri(value) - ndtri(self.FPR[index]))
        return dprime