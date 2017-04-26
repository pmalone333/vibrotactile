from frequencyGenerator import FrequencyGenerator
import statistics as stat
#############################################################################
#Calculations by frequency pair
#############################################################################

class FrequencySpecific():
    def __init__(self, stimuli = None):
        self.ACC = []
        self.RT = []
        self.FL = FrequencyGenerator()
        self.stimuli = stimuli

    def frequencyPair_parse(self, rawData):
        f1 = []
        f2 = []
        f3 = []
        f4 = []
        f5 = []
        f6 = []
        f7 = []
        f8 = []
        f14 = []
        f15 = []
        f16 = []
        f17 = []
        f18 = []
        f19 = []
        f20 = []
        f21 = []

        countF1 = countF2 = countF3 = countF4 = countF5 = countF6 = countF7 = countF8 = 0
        countF14 = countF15 = countF16 = countF17 = countF18 = countF19 = countF20 = countF21 = 0
        for iBlock in range(rawData.size):
            for iTrial in range(rawData[0,iBlock].size):
                stimulus = round(self.stimuli[0,iBlock][0,iTrial])
                if stimulus == self.FL.frequencyList[0]:
                    f1.append(rawData[0,iBlock][0,iTrial])
                    countF1 += 1
                elif stimulus == self.FL.frequencyList[20]:
                    f21.append(rawData[0,iBlock][0,iTrial])
                    countF21 += 1
                elif stimulus == self.FL.frequencyList[1]:
                    f2.append(rawData[0,iBlock][0,iTrial])
                    countF2 += 1
                elif stimulus == self.FL.frequencyList[19]:
                    f20.append(rawData[0,iBlock][0,iTrial])
                    countF20 += 1
                elif stimulus == self.FL.frequencyList[2]:
                    f3.append(rawData[0,iBlock][0,iTrial])
                    countF3 += 1
                elif stimulus == self.FL.frequencyList[18]:
                    f19.append(rawData[0,iBlock][0,iTrial])
                    countF19 += 1
                elif stimulus == self.FL.frequencyList[3]:
                    f4.append(rawData[0,iBlock][0,iTrial])
                    countF4 += 1
                elif stimulus == self.FL.frequencyList[17]:
                    f18.append(rawData[0,iBlock][0,iTrial])
                    countF18 += 1
                elif stimulus == self.FL.frequencyList[4]:
                    f5.append(rawData[0,iBlock][0,iTrial])
                    countF5 += 1
                elif stimulus == self.FL.frequencyList[16]:
                    f17.append(rawData[0,iBlock][0,iTrial])
                    countF17 += 1
                elif stimulus == self.FL.frequencyList[5]:
                    f6.append(rawData[0,iBlock][0,iTrial])
                    countF6 += 1
                elif stimulus == self.FL.frequencyList[15]:
                    f16.append(rawData[0,iBlock][0,iTrial])
                    countF16 += 1
                elif stimulus == self.FL.frequencyList[6]:
                    f7.append(rawData[0,iBlock][0,iTrial])
                    countF7 += 1
                elif stimulus == self.FL.frequencyList[14]:
                    f15.append(rawData[0,iBlock][0,iTrial])
                    countF15 += 1
                elif stimulus == self.FL.frequencyList[7]:
                    f8.append(rawData[0,iBlock][0,iTrial])
                    countF8 += 1
                elif stimulus == self.FL.frequencyList[13]:
                    f14.append(rawData[0,iBlock][0,iTrial])
                    countF14 += 1

        temp = [f1, f2, f3, f4, f5, f6, f7, f8, f14, f15, f16, f17, f18, f19, f20, f21]
        countTotal = [str(countF1), str(countF2), str(countF3), str(countF4),
                      str(countF5), str(countF6), str(countF7), str(countF8),
                      str(countF14), str(countF15), str(countF16), str(countF17),
					  str(countF18), str(countF19), str(countF20), str(countF21)]

        self.checkForZero(temp)

        mF = [stat.mean(f1), stat.mean(f2), stat.mean(f3), stat.mean(f4), stat.mean(f5),
              stat.mean(f6), stat.mean(f7), stat.mean(f8), stat.mean(f14), stat.mean(f15),
			  stat.mean(f16), stat.mean(f17), stat.mean(f18), stat.mean(f19), stat.mean(f20), stat.mean(f21)]

        return mF, countTotal


    def category_parse_RA(self, rawData):
        countF2 = countF8 = 0
        countF2_b = countF8_b = 0
        countF14 = countF20 = 0
        countF14_a = countF20_a = 0
        for iBlock in range(rawData.size):
            for iTrial in range(rawData[0,iBlock].size):
                stimulus = round(self.stimuli[0,iBlock][0,iTrial])
                catAorB = int(self.stimuli[0,iBlock][4,iTrial])
                if catAorB == 1 and rawData[0,iBlock][0,iTrial] == 1:
                    if stimulus == self.FL.frequencyList[1]:
                        countF2 += 1
                    elif stimulus == self.FL.frequencyList[7]:
                        countF8 += 1
                elif catAorB == 1 and rawData[0,iBlock][0,iTrial] == 0:
                    if stimulus == self.FL.frequencyList[1]:
                        countF2_b += 1
                    elif stimulus == self.FL.frequencyList[7]:
                        countF8_b += 1
                elif catAorB == 2 and rawData[0,iBlock][0,iTrial] == 1:
                    if stimulus == self.FL.frequencyList[19]:
                        countF20 += 1
                    elif stimulus == self.FL.frequencyList[13]:
                        countF14 += 1
                elif catAorB == 2 and rawData[0,iBlock][0,iTrial] == 0:
                    if stimulus == self.FL.frequencyList[19]:
                        countF20_a += 1
                    elif stimulus == self.FL.frequencyList[13]:
                        countF14_a += 1


        countTotal = [countF2/(countF2+countF2_b), countF8/(countF8+countF8_b), countF14_a/(countF14+countF14_a), countF20_a/(countF20+countF20_a)]

        countTotal = [count*100 for count in countTotal]


        return countTotal

    def category_parse(self, rawData):
        countF1 = countF2 = countF3 = countF4 = countF5 = countF6 = countF7 = countF8 = 0
        countF1_b = countF2_b = countF3_b = countF4_b = countF5_b = countF6_b = countF7_b = countF8_b = countF9_b = 0
        countF14 = countF15 = countF16 = countF17 = countF18 = countF19 = countF20 = countF21 = 0
        countF13_a = countF14_a = countF15_a = countF16_a = countF17_a = countF18_a = countF19_a = countF20_a = countF21_a = 0
        for iBlock in range(rawData.size):
            for iTrial in range(rawData[0,iBlock].size):
                stimulus = round(self.stimuli[0,iBlock][0,iTrial])
                catAorB = int(self.stimuli[0,iBlock][4,iTrial])
                if catAorB == 1 and rawData[0,iBlock][0,iTrial] == 1:
                    if stimulus == self.FL.frequencyList[0]:
                        countF1 += 1
                    elif stimulus == self.FL.frequencyList[1]:
                        countF2 += 1
                    elif stimulus == self.FL.frequencyList[2]:
                        countF3 += 1
                    elif stimulus == self.FL.frequencyList[3]:
                        countF4 += 1
                    elif stimulus == self.FL.frequencyList[4]:
                        countF5 += 1
                    elif stimulus == self.FL.frequencyList[5]:
                        countF6 += 1
                    elif stimulus == self.FL.frequencyList[6]:
                        countF7 += 1
                    elif stimulus == self.FL.frequencyList[7]:
                        countF8 += 1
                elif catAorB == 1 and rawData[0,iBlock][0,iTrial] == 0:
                    if stimulus == self.FL.frequencyList[0]:
                        countF1_b += 1
                    elif stimulus == self.FL.frequencyList[1]:
                        countF2_b += 1
                    elif stimulus == self.FL.frequencyList[2]:
                        countF3_b += 1
                    elif stimulus == self.FL.frequencyList[3]:
                        countF4_b += 1
                    elif stimulus == self.FL.frequencyList[4]:
                        countF5_b += 1
                    elif stimulus == self.FL.frequencyList[5]:
                        countF6_b += 1
                    elif stimulus == self.FL.frequencyList[6]:
                        countF7_b += 1
                    elif stimulus == self.FL.frequencyList[7]:
                        countF8_b += 1
                elif catAorB == 2 and rawData[0,iBlock][0,iTrial] == 1:
                    if stimulus == self.FL.frequencyList[20]:
                        countF21 += 1
                    elif stimulus == self.FL.frequencyList[19]:
                        countF20 += 1
                    elif stimulus == self.FL.frequencyList[18]:
                        countF19 += 1
                    elif stimulus == self.FL.frequencyList[17]:
                        countF18 += 1
                    elif stimulus == self.FL.frequencyList[16]:
                        countF17 += 1
                    elif stimulus == self.FL.frequencyList[15]:
                        countF16 += 1
                    elif stimulus == self.FL.frequencyList[14]:
                        countF15 += 1
                    elif stimulus == self.FL.frequencyList[13]:
                        countF14 += 1
                elif catAorB == 2 and rawData[0,iBlock][0,iTrial] == 0:
                    if stimulus == self.FL.frequencyList[20]:
                        countF21_a += 1
                    elif stimulus == self.FL.frequencyList[19]:
                        countF20_a += 1
                    elif stimulus == self.FL.frequencyList[18]:
                        countF19_a += 1
                    elif stimulus == self.FL.frequencyList[17]:
                        countF18_a += 1
                    elif stimulus == self.FL.frequencyList[16]:
                        countF17_a += 1
                    elif stimulus == self.FL.frequencyList[15]:
                        countF16_a += 1
                    elif stimulus == self.FL.frequencyList[14]:
                        countF15_a += 1
                    elif stimulus == self.FL.frequencyList[13]:
                        countF14_a += 1


        countTotal = [countF1/(countF1+countF1_b), countF2/(countF2+countF2_b), countF3/(countF3+countF3_b),
                      countF4/(countF4+countF4_b), countF5/(countF5+countF5_b), countF6/(countF6+countF6_b),
                      countF7/(countF7+countF7_b), countF8/(countF8+countF8_b),
                      countF14_a/(countF14+countF14_a), countF15_a/(countF15+countF15_a),
                      countF16_a/(countF16+countF16_a), countF17_a/(countF17+countF17_a), countF18_a/(countF18+countF18_a),
                      countF19_a/(countF19+countF19_a), countF20_a/(countF20+countF20_a), countF21_a/(countF21+countF21_a)]

        countTotal = [count*100 for count in countTotal]


        return countTotal

    def category_parse_test(self, rawData):
        countF1 = countF3 = countF5 = countF7 = countF8 = countF9 = 0
        countF1_b = countF3_b = countF5_b = countF7_b = countF8_b = countF9_b = 0
        countF13 = countF14 = countF15 = countF17 = countF19 = countF21 = 0
        countF13_a = countF14_a = countF15_a = countF17_a = countF19_a = countF21_a = 0
        for iBlock in range(rawData.size):
            for iTrial in range(rawData[0,iBlock].size):
                stimulus = round(self.stimuli[0,iBlock][0,iTrial])
                catAorB = int(self.stimuli[0,iBlock][4,iTrial])
                if catAorB == 1 and rawData[0,iBlock][0,iTrial] == 1:
                    if stimulus == self.FL.frequencyList[0]:
                        countF1 += 1
                    elif stimulus == self.FL.frequencyList[2]:
                        countF3 += 1
                    elif stimulus == self.FL.frequencyList[4]:
                        countF5 += 1
                    elif stimulus == self.FL.frequencyList[6]:
                        countF7 += 1
                    elif stimulus == self.FL.frequencyList[7]:
                        countF8 += 1
                    elif stimulus == self.FL.frequencyList[8]:
                        countF9 += 1
                elif catAorB == 1 and rawData[0,iBlock][0,iTrial] == 0:
                    if stimulus == self.FL.frequencyList[0]:
                        countF1_b += 1
                    elif stimulus == self.FL.frequencyList[2]:
                        countF3_b += 1
                    elif stimulus == self.FL.frequencyList[4]:
                        countF5_b += 1
                    elif stimulus == self.FL.frequencyList[6]:
                        countF7_b += 1
                    elif stimulus == self.FL.frequencyList[7]:
                        countF8_b += 1
                    elif stimulus == self.FL.frequencyList[8]:
                        countF9_b += 1
                elif catAorB == 2 and rawData[0,iBlock][0,iTrial] == 1:
                    if stimulus == self.FL.frequencyList[20]:
                        countF21 += 1
                    elif stimulus == self.FL.frequencyList[18]:
                        countF19 += 1
                    elif stimulus == self.FL.frequencyList[16]:
                        countF17 += 1
                    elif stimulus == self.FL.frequencyList[14]:
                        countF15 += 1
                    elif stimulus == self.FL.frequencyList[13]:
                        countF14 += 1
                    elif stimulus == self.FL.frequencyList[12]:
                        countF13 += 1
                elif catAorB == 2 and rawData[0,iBlock][0,iTrial] == 0:
                    if stimulus == self.FL.frequencyList[20]:
                        countF21_a += 1
                    elif stimulus == self.FL.frequencyList[18]:
                        countF19_a += 1
                    elif stimulus == self.FL.frequencyList[16]:
                        countF17_a += 1
                    elif stimulus == self.FL.frequencyList[14]:
                        countF15_a += 1
                    elif stimulus == self.FL.frequencyList[13]:
                        countF14_a += 1
                    elif stimulus == self.FL.frequencyList[12]:
                        countF13_a += 1


        countTotal = [countF1/(countF1+countF1_b), countF3/(countF3+countF3_b), countF5/(countF5+countF5_b),
                      countF7/(countF7+countF7_b), countF8/(countF8+countF8_b), countF9/(countF9+countF9_b),
                      countF13_a/(countF13+countF13_a), countF14_a/(countF14+countF14_a), countF15_a/(countF15+countF15_a),
                      countF17_a/(countF17+countF17_a), countF19_a/(countF19+countF19_a), countF21_a/(countF21+countF21_a)]

        countTotal = [count*100 for count in countTotal]


        return countTotal

    def checkForZero(self, list):
        for subList in list:
            if subList == []:
                subList.append(0)
                subList.append(0)