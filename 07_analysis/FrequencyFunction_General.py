import statistics as stat
from frequencyGenerator import FrequencyGenerator

class FrequencyGeneral():
    def __init__(self, stimuli = None):
        self.RT = []
        self.ACC = []
        self.FL = FrequencyGenerator()
        self.stimuli = stimuli

    def m3b(self, f1, f2):
        if (f1 == self.FL.frequencyList[7] and f2 == self.FL.frequencyList[13])\
                or (f1 == self.FL.frequencyList[13] and f2 == self.FL.frequencyList[7]):
            return True
        else:
            return False

    def m3w5(self, f1, f2):
        if (f1 == self.FL.frequencyList[19] and f2 == self.FL.frequencyList[13])\
                or (f1 == self.FL.frequencyList[13] and f2 == self.FL.frequencyList[19]):
            return True
        else:
            return False

    def m3w95(self, f1, f2):
        if (f1 == self.FL.frequencyList[1] and f2 == self.FL.frequencyList[7])\
                or (f1 == self.FL.frequencyList[7] and f2 == self.FL.frequencyList[1]):
            return True
        else:
            return False

    def m6_5(self, f1, f2):
        if (f1 == self.FL.frequencyList[7] and f2 == self.FL.frequencyList[19])\
                or (f1 == self.FL.frequencyList[19] and f2 == self.FL.frequencyList[7]):
            return True
        else:
            return False

    def m6_95(self, f1, f2):
        if (f1 == self.FL.frequencyList[1] and f2 == self.FL.frequencyList[13])\
                or (f1 == self.FL.frequencyList[13] and f2 == self.FL.frequencyList[1]):
            return True
        else:
            return False

    def calcAccRT(self, ACC, RT, ParseBy):
        self.ACC = self._calcAccRT('ACC', ACC, ParseBy)
        self.RT = self._calcAccRT('RT', RT, ParseBy)

    def _calcAccRT(self, dataStringID, dataToParse, ParseBy):
        if ParseBy == 'Block':
            if dataStringID == 'ACC':
                return self.parser_block(dataToParse)
            elif dataStringID == 'RT':
                return self.parser_block(dataToParse)
            else:
                print("Sorry the data requested to parse is not recognized")
        elif ParseBy == 'Subject':
            if dataStringID == 'ACC':
                return self.parser(dataToParse)
            elif dataStringID == 'RT':
                return self.parser(dataToParse)
            else:
                print("Sorry the data requested to parse is not recognized")
        else:
            print('Sorry your ParseBy parameter was not recognized. Please check your input value')

    def parser(self, dataRaw):
        data = []
        for iSubject in range(len(dataRaw)):
            same = []
            m3w5 = []
            m3w95 = []
            m3b = []
            m6_5 = []
            m6_95 = []
            for iBlock in range(dataRaw[iSubject].size):
                for iTrial in range(dataRaw[iSubject][0,iBlock].size):
                    stim1 = int(round(self.stimuli[iSubject][0,iBlock][0,iTrial]))
                    stim2 = int(round(self.stimuli[iSubject][0,iBlock][2,iTrial]))

                    if stim1 == stim2:
                        same.append(dataRaw[iSubject][0,iBlock][0,iTrial])
                    elif self.m6_5(stim1, stim2) == True:
                        m6_5.append(dataRaw[iSubject][0,iBlock][0,iTrial])
                    elif self.m6_95(stim1, stim2) == True:
                        m6_95.append(dataRaw[iSubject][0,iBlock][0,iTrial])
                    elif self.m3w5(stim1, stim2) == True:
                        m3w5.append(dataRaw[iSubject][0,iBlock][0,iTrial])
                    elif self.m3w95(stim1, stim2) == True:
                        m3w95.append(dataRaw[iSubject][0,iBlock][0,iTrial])
                    elif self.m3b(stim1, stim2) == True:
                        m3b.append(dataRaw[iSubject][0,iBlock][0,iTrial])

            data.append([sum(same)/len(same), stat.mean(m3w5), stat.mean(m3w95), stat.mean(m3b), stat.mean(m6_5), stat.mean(m6_95)])

        return data

    def parser_block(self, dataRaw):
        data = []
        same = []
        m3w5 = []
        m3w95 = []
        m3b = []
        m6_5 = []
        m6_95 = []
        for iBlock in range(dataRaw.size):
            for iTrial in range(dataRaw[0,iBlock].size):
                stim1 = int(round(self.stimuli[0,iBlock][0,iTrial]))
                stim2 = int(round(self.stimuli[0,iBlock][2,iTrial]))

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