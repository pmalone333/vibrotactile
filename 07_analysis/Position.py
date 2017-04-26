from PositionFunction_General import Position_general as PG
from PositionFunction_Specific import Position_catBound as PC
import statistics as stat

class Position():
    def __init__(self):
        self.PG = PG()
        self.PC = PC()

    def parseData(self, accuracy, RT, stimuli, type):
        self.PG.calcAccRT(accuracy, RT, stimuli, type, 'Subject')
        self.PC.calcAccRT(accuracy, RT, stimuli, 'Subject')

    def parserBySubject(self, dataRaw, stimuli):
        data = []
        for iBlock in range(len(dataRaw)):
            same = []
            m3w5 = []
            m3w95 = []
            m3b = []
            m6_5 = []
            m6_95 = []
            for iTrial in range(dataRaw[0,iBlock].size):
                stim1 = int(round(stimuli[0,iBlock][0,iTrial]))
                stim2 = int(round(stimuli[0,iBlock][2,iTrial]))

                if stim1 == stim2:
                    same.append(dataRaw[0,iBlock][0,iTrial])
                elif self.m6_5(stim1, stim2) == True:
                    m6_5.append(dataRaw[0,iBlock][0,iTrial])
                elif self.m6_95(stim1, stim2) == True:
                    m6_95.append(dataRaw[0,iBlock][0,iTrial])
                elif self.m3w5(stim1, stim2) == True:
                    m3w5.append(dataRaw[0,iBlock][0,iTrial])
                elif self.m3w95(stim1, stim2) == True:
                    m3w95.append(dataRaw[0,iBlock][0,iTrial])
                elif self.m3b(stim1, stim2) == True:
                    m3b.append(dataRaw[0,iBlock][0,iTrial])

            data.append([sum(same)/len(same), stat.mean(m3w5), stat.mean(m3w95), stat.mean(m3b), stat.mean(m6_5), stat.mean(m6_95)])

        return data