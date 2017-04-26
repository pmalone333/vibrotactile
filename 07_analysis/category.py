from frequencyGenerator import FrequencyGenerator
import statistics as stat

class category():
    def __init__(self, stimuli):
        self.stim = stimuli
        self.FL = FrequencyGenerator()

    def catProtoMorph95(self, stim):
        if stim == self.FL.frequencyList[0] or stim == self.FL.frequencyList[1] or stim == self.FL.frequencyList[2]:
            return True
        else:
            return False

    def catProtoMorph5(self, stim):
        if stim == self.FL.frequencyList[20] or stim == self.FL.frequencyList[19] or stim == self.FL.frequencyList[18]:
            return True
        else:
            return False

    def middleMorph95(self, stim):
        if stim == self.FL.frequencyList[3] or stim == self.FL.frequencyList[4] or stim == self.FL.frequencyList[5]:
            return True
        else:
            return False

    def middleMorph5(self, stim):
        if stim == self.FL.frequencyList[17] or stim == self.FL.frequencyList[16] or stim == self.FL.frequencyList[15]:
            return True
        else:
            return False

    def catBoundMorph95(self, stim):
        if stim == self.FL.frequencyList[6] or stim == self.FL.frequencyList[7] or stim == self.FL.frequencyList[8]:
            return True
        else:
            return False

    def catBoundMorph5(self, stim):
        if stim == self.FL.frequencyList[14] or stim == self.FL.frequencyList[13] or stim == self.FL.frequencyList[12]:
            return True
        else:
            return False

    def parseCategory(self, rawData):
        #calculate accuracy by category type
        b_categoryA = []
        b_categoryB = []
        for iBlock in range(rawData.size):
            categoryA = []
            categoryB = []
            for iTrial in range(rawData[0,iBlock].size):
                stimulus = round(rawData[0,iBlock][0,iTrial])
                if stimulus < 47:
                    categoryA.append(rawData[0,iBlock][0,iTrial])
                elif stimulus > 47:
                    categoryB.append(rawData[0,iBlock][0,iTrial])
                else:
                    print("Sorry there is an error in your category parsing function and some stimuli are not being classified")
                    print("This stimulus was not put into a category: ")
                    print(stimulus)

            b_categoryA.append(stat.mean(categoryA))
            b_categoryB.append(stat.mean(categoryB))

        data = [b_categoryA, b_categoryB]
        return data

    def parser(self, rawData):
        #calculate the accuracy by morph
        data = []
        for iBlock in range(rawData.size):
            b_catProto = []
            b_middleM = []
            b_catBound = []
            for iTrial in range(rawData[0,iBlock].size):
                stimulus = round(self.stim[0,iBlock][0,iTrial])
                if self.catProtoMorph95(stimulus) == True:
                    b_catProto.append(rawData[0,iBlock][0,iTrial])
                elif  self.catProtoMorph5(stimulus) == True:
                    b_catProto.append(rawData[0,iBlock][0,iTrial])
                elif self.middleMorph95(stimulus):
                    b_middleM.append(rawData[0,iBlock][0,iTrial])
                elif self.middleMorph5(stimulus):
                    b_middleM.append(rawData[0,iBlock][0,iTrial])
                elif self.catBoundMorph95(stimulus):
                    b_catBound.append(rawData[0,iBlock][0,iTrial])
                elif self.catBoundMorph5(stimulus):
                    b_catBound.append(rawData[0,iBlock][0,iTrial])
                else:
                    print("There is something wrong with your morph parsing function and stimuli are not be classified")
                    print("The following were stimuli were not parsed: ")
                    print(stimulus)
            if b_catProto != []:
                data.append(sum(b_catProto)/len(b_catProto))
            else:
                data.append(0)

            if b_middleM != []:
                data.append(stat.mean(b_middleM))
            else:
                data.append(0)

            if b_catBound != []:
                data.append(stat.mean(b_catBound))
            else:
                data.append(0)
        return data


    def parseData_freq_block (self, rawData, stimuli):
        pos7_f1 = []
        pos7_f3 = []
        pos7_f5 = []
        pos7_f7 = []
        pos7_f8 = []
        pos7_f14 = []
        pos7_f15 = []
        pos7_f17 = []
        pos7_f19 = []
        pos7_f21 = []
        pos1_f1 = []
        pos1_f3 = []
        pos1_f5 = []
        pos1_f7 = []
        pos1_f8 = []
        pos1_f14 = []
        pos1_f15 = []
        pos1_f17 = []
        pos1_f19 = []
        pos1_f21 = []
        pos8_f1 = []
        pos8_f3 = []
        pos8_f5 = []
        pos8_f7 = []
        pos8_f8 = []
        pos8_f14 = []
        pos8_f15 = []
        pos8_f17 = []
        pos8_f19 = []
        pos8_f21 = []

        for iBlock in range(rawData.size):
            for iTrial in range(rawData[0,iBlock].size):
                pos1 = int(stimuli[0,iBlock][2,iTrial])
                freq1 = round(stimuli[0,iBlock][0,iTrial])
                if pos1 == 7 and freq1 ==self.FL.frequencyList[0]:
                    pos7_f1.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[2]:
                    pos7_f3.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[4]:
                    pos7_f5.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[6]:
                    pos7_f7.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[7]:
                    pos7_f8.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[13]:
                    pos7_f14.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[14]:
                    pos7_f15.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[16]:
                    pos7_f17.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[18]:
                    pos7_f19.append(rawData[0,iBlock][0,iTrial])
                elif pos1 == 7 and freq1 ==self.FL.frequencyList[20]:
                    pos7_f21.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[0]:
                #    pos1_f1.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[2]:
                #    pos1_f3.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[4]:
                #    pos1_f5.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[6]:
                #    pos1_f7.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[7]:
                #    pos1_f8.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[8]:
                #    pos1_f9.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[12]:
                #    pos1_f13.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[13]:
                #    pos1_f14.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[14]:
                #    pos1_f15.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[16]:
                #    pos1_f17.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[18]:
                #    pos1_f19.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 1 and freq1 ==self.FL.frequencyList[20]:
                #    pos1_f21.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[0]:
                #    pos8_f1.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[2]:
                #    pos8_f3.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[4]:
                #    pos8_f5.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[6]:
                #    pos8_f7.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[7]:
                #    pos8_f8.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[8]:
                #    pos8_f9.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[12]:
                #    pos8_f13.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[13]:
                #    pos8_f14.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[14]:
                #    pos8_f15.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[16]:
                #    pos8_f17.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[18]:
                #    pos8_f19.append(rawData[0,iBlock][0,iTrial])
                #elif pos1 == 8 and freq1 ==self.FL.frequencyList[20]:
                #    pos8_f21.append(rawData[0,iBlock][0,iTrial])

        #data =      [stat.mean(pos1_f1), stat.mean(pos1_f3), stat.mean(pos1_f5), stat.mean(pos1_f7),
        #             stat.mean(pos1_f8), stat.mean(pos1_f9), stat.mean(pos1_f13), stat.mean(pos1_f14),
        #             stat.mean(pos1_f15), stat.mean(pos1_f17), stat.mean(pos1_f19), stat.mean(pos1_f21),
        #             stat.mean(pos7_f1), stat.mean(pos7_f3), stat.mean(pos7_f5), stat.mean(pos7_f7),
        #             stat.mean(pos7_f8), stat.mean(pos7_f9), stat.mean(pos7_f13), stat.mean(pos7_f14),
        #             stat.mean(pos7_f15), stat.mean(pos7_f17), stat.mean(pos7_f19), stat.mean(pos7_f21),
        #             stat.mean(pos8_f1), stat.mean(pos8_f3), stat.mean(pos8_f5), stat.mean(pos8_f7),
        #             stat.mean(pos8_f8), stat.mean(pos8_f9), stat.mean(pos8_f13), stat.mean(pos8_f14),
        #             stat.mean(pos8_f15), stat.mean(pos8_f17), stat.mean(pos8_f19), stat.mean(pos8_f21)]

        data =      [stat.mean(pos7_f1), stat.mean(pos7_f3), stat.mean(pos7_f5), stat.mean(pos7_f7),
                     stat.mean(pos7_f8), stat.mean(pos7_f14),
                     stat.mean(pos7_f15), stat.mean(pos7_f17), stat.mean(pos7_f19), stat.mean(pos7_f21)]

        return data

    def wrapper(self, ACC, RT):
        RT = self.parser(RT)
        ACC = self.parser(ACC)
        return RT, ACC
