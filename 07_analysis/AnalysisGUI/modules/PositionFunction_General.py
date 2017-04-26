import statistics as stat

class Position_general():
    def __init__(self):
        self.RT = []
        self.ACC = []

    def secondRow_pos(self, pos1):
        if (pos1 == 3 or pos1 == 4):
            return True
        else:
            return False

    def thirdRow_pos(self, pos1):
        if (pos1 == 5 or pos1 == 6 or pos1 == 1 or pos1 == 2):
            return True
        else:
            return False

    def fourthRow_pos(self, pos1):
        if (pos1 == 7 or pos1 == 8):
            return True
        else:
            return False

    def fifthRow_pos(self, pos1):
        if (pos1 == 9 or pos1 == 10):
            return True
        else:
            return False

    def wristPos_Different(self, pos1, pos2):
        if (pos1 == 1 or pos1 == 2 or pos1 == 3 or pos1 == 4 or pos1 == 5 or pos1 == 6)\
            and (pos2 == 1 or pos2 == 2 or pos2 == 3 or pos2 == 4 or pos2 == 5 or pos2 == 6):
            return True
        else:
            return False

    def wristPos_Same(self, pos1, pos2):
         if pos1 == 1 or pos1 == 2 or pos1 == 3 or pos1 == 4:
             return True
         else:
             return False

    def elbowPos_Different(self, pos1, pos2):
        if (pos1 == 9 or pos1 == 10 or pos1 == 11 or pos1 == 12 or pos1 == 13 or pos1 == 14)\
            and (pos2 == 9 or pos2 == 10 or pos2 == 11 or pos2 == 12 or pos2 == 13 or pos2 == 14):
            return True
        else:
            return False

    def elbowPos_Same(self, pos1, pos2):
        if  pos1 == 11 or pos1 == 12 or pos1 == 13 or pos1 == 14:
            return True
        else:
            return False

    def parseData(self, rawData, stimuli, dataStringID, type, parseBy):
        if type == 'pos':
            if parseBy == 'Block':
                if dataStringID == 'ACC':
                    self.ACC = self.parseData_pos_block(rawData, stimuli)
                elif dataStringID == 'RT':
                    self.RT = self.parseData_pos_block(rawData, stimuli)
            elif parseBy == 'Subject':
                if dataStringID == 'ACC':
                    self.ACC = self.parseData_pos(rawData, stimuli)
                elif dataStringID == 'RT':
                    self.RT = self.parseData_pos(rawData, stimuli)
        elif type == 'freq':
            if parseBy == 'Block':
                if dataStringID == 'ACC':
                    self.ACC = self.parseData_freq_block(rawData, stimuli)
                elif dataStringID == 'RT':
                    self.RT = self.parseData_freq_block(rawData, stimuli)
            elif parseBy == 'Subject':
                if dataStringID == 'ACC':
                    self.ACC = self.parseData_freq(rawData, stimuli)
                elif dataStringID == 'RT':
                    self.RT = self.parseData_freq(rawData, stimuli)

    def parseData_pos (self, rawData, stimuli):
        data = []
        for iSubject in range(len(rawData)):
            D_wristPos = []
            D_elbowPos = []
            D_crossMidline = []
            S_wristPos = []
            S_elbowPos = []
            S_midline = []
            for iBlock in range(rawData[iSubject].size):
                for iTrial in range(rawData[iSubject][0,iBlock].size):
                    if iSubject == 0 or iSubject == 1 or iSubject == 2:
                        pos1 = int(stimuli[iSubject][0,iBlock][0,iTrial])
                        pos2 = int(stimuli[iSubject][0,iBlock][2,iTrial])
                    else:
                        pos1 = int(stimuli[iSubject][0,iBlock][1,iTrial])
                        pos2 = int(stimuli[iSubject][0,iBlock][3,iTrial])
                    if pos1 != pos2:
                        if self.wristPos_Different(pos1, pos2) == True:
                            D_wristPos.append(rawData[iSubject][0,iBlock][0,iTrial])
                        elif self.elbowPos_Different(pos1, pos2) == True:
                            D_elbowPos.append(rawData[iSubject][0,iBlock][0,iTrial])
                        else:
                            D_crossMidline.append(rawData[iSubject][0,iBlock][0,iTrial])
                    else:
                        if self.wristPos_Same(pos1, pos2) == True:
                            S_wristPos.append(rawData[iSubject][0,iBlock][0,iTrial])
                        elif self.elbowPos_Same(pos1, pos2) == True:
                            S_elbowPos.append(rawData[iSubject][0,iBlock][0,iTrial])
                        else:
                            S_midline.append(rawData[iSubject][0,iBlock][0,iTrial])

            data.append([stat.mean(D_wristPos), stat.mean(D_crossMidline), stat.mean(D_elbowPos),
                            stat.mean(S_wristPos), stat.mean(S_midline), stat.mean(S_elbowPos)])
        return data

    def parseData_freq (self, rawData, stimuli):
        data = []
        for iSubject in range(len(rawData)):
            D_pos3or4 = []
            D_pos5or6 = []
            D_pos9or10 = []
            D_pos11or12 = []
            S_pos3or4 = []
            S_pos5or6 = []
            S_pos9or10 = []
            S_pos11or12 = []
            for iBlock in range(rawData[iSubject].size):
                for iTrial in range(rawData[iSubject][0,iBlock].size):
                    pos1 = int(stimuli[iSubject][0,iBlock][1,iTrial])
                    stim1 = stimuli[iSubject][0,iBlock][0,iTrial]
                    stim2 = stimuli[iSubject][0,iBlock][2,iTrial]
                    if stim1 != stim2:
                        if self.secondRow_pos(pos1) == True:
                            D_pos3or4.append(rawData[iSubject][0,iBlock][0,iTrial])
                        elif self.thirdRow_pos(pos1) == True:
                            D_pos5or6.append(rawData[iSubject][0,iBlock][0,iTrial])
                        elif self.fourthRow_pos(pos1) == True:
                            D_pos9or10.append(rawData[iSubject][0,iBlock][0,iTrial])
                        elif self.fifthRow_pos(pos1) == True:
                            D_pos11or12.append(rawData[iSubject][0,iBlock][0,iTrial])
                        else:
                            print("Your script is broked and stimuli are not meeting criteria for position of different stimuli")
                            print(stim1, stim2)
                            print(pos1)
                    else:
                        if self.secondRow_pos(pos1) == True:
                            S_pos3or4.append(rawData[iSubject][0,iBlock][0,iTrial])
                        elif self.thirdRow_pos(pos1) == True:
                            S_pos5or6.append(rawData[iSubject][0,iBlock][0,iTrial])
                        elif self.fourthRow_pos(pos1) == True:
                            S_pos9or10.append(rawData[iSubject][0,iBlock][0,iTrial])
                        elif self.fifthRow_pos(pos1) == True:
                            S_pos11or12.append(rawData[iSubject][0,iBlock][0,iTrial])
                        else:
                            print("Your script is broked and stimuli are not meeting criteria for position of same stimuli")
                            print(stim1, stim2)
                            print(pos1)

            data.append([stat.mean(D_pos3or4), stat.mean(D_pos5or6), stat.mean(D_pos9or10),stat.mean(D_pos11or12),
                            stat.mean(S_pos3or4), stat.mean(S_pos5or6), stat.mean(S_pos9or10), stat.mean(S_pos11or12) ])
        return data

    def parseData_pos_block (self, rawData, stimuli):
        D_wristPos = []
        D_elbowPos = []
        D_crossMidline = []
        S_wristPos = []
        S_elbowPos = []
        S_midline = []
        for iBlock in range(rawData.size):
            for iTrial in range(rawData[0,iBlock].size):
                # if iSubject == 0 or iSubject == 1 or iSubject == 2:
                #     pos1 = int(stimuli[0,iBlock][0,iTrial])
                #     pos2 = int(stimuli[0,iBlock][2,iTrial])
                pos1 = int(stimuli[0,iBlock][1,iTrial])
                pos2 = int(stimuli[0,iBlock][3,iTrial])
                if pos1 != pos2:
                    if self.wristPos_Different(pos1, pos2) == True:
                        D_wristPos.append(rawData[0,iBlock][0,iTrial])
                    elif self.elbowPos_Different(pos1, pos2) == True:
                        D_elbowPos.append(rawData[0,iBlock][0,iTrial])
                    else:
                        D_crossMidline.append(rawData[0,iBlock][0,iTrial])
                else:
                    if self.wristPos_Same(pos1, pos2) == True:
                        S_wristPos.append(rawData[0,iBlock][0,iTrial])
                    elif self.elbowPos_Same(pos1, pos2) == True:
                        S_elbowPos.append(rawData[0,iBlock][0,iTrial])
                    else:
                        S_midline.append(rawData[0,iBlock][0,iTrial])

        data = [sum(D_wristPos)/len(D_wristPos), sum(D_crossMidline)/len(D_crossMidline), sum(D_elbowPos)/len(D_elbowPos),
                sum(S_wristPos)/len(S_wristPos), sum(S_midline)/len(S_midline), sum(S_elbowPos)/len(S_elbowPos)]
        return data

    def parseData_freq_block (self, rawData, stimuli):
        data = []
        D_pos3or4 = []
        D_pos5or6 = []
        D_pos9or10 = []
        D_pos7or8 = []
        S_pos3or4 = []
        S_pos5or6 = []
        S_pos9or10 = []
        S_pos7or8 = []
        for iBlock in range(rawData.size):
            for iTrial in range(rawData[0,iBlock].size):
                pos1 = int(stimuli[0,iBlock][1,iTrial])
                stim1 = stimuli[0,iBlock][0,iTrial]
                stim2 = stimuli[0,iBlock][2,iTrial]
                if stim1 != stim2:
                    if self.secondRow_pos(pos1) == True:
                        D_pos3or4.append(rawData[0,iBlock][0,iTrial])
                    elif self.thirdRow_pos(pos1) == True:
                        D_pos5or6.append(rawData[0,iBlock][0,iTrial])
                    elif self.fourthRow_pos(pos1) == True:
                        D_pos7or8.append(rawData[0,iBlock][0,iTrial])
                    elif self.fifthRow_pos(pos1) == True:
                        D_pos9or10.append(rawData[0,iBlock][0,iTrial])
                    else:
                        print("Your script is broked and stimuli are not meeting criteria for position of different stimuli")
                        print(stim1, stim2)
                        print(pos1)
                else:
                    if self.secondRow_pos(pos1) == True:
                        S_pos3or4.append(rawData[0,iBlock][0,iTrial])
                    elif self.thirdRow_pos(pos1) == True:
                        S_pos5or6.append(rawData[0,iBlock][0,iTrial])
                    elif self.fourthRow_pos(pos1) == True:
                        S_pos7or8.append(rawData[0,iBlock][0,iTrial])
                    elif self.fifthRow_pos(pos1) == True:
                        S_pos9or10.append(rawData[0,iBlock][0,iTrial])
                    else:
                        print("Your script is broked and stimuli are not meeting criteria for position of same stimuli")
                        print(stim1, stim2)
                        print(pos1)

        data.append([stat.mean(D_pos3or4), stat.mean(D_pos5or6), stat.mean(D_pos7or8),stat.mean(D_pos9or10),
                     stat.mean(S_pos3or4), stat.mean(S_pos5or6), stat.mean(S_pos7or8), stat.mean(S_pos9or10) ])
        return data

    def calcAccRT(self, accuracy, RT, stimuli, type, parseBy):
        self.parseData(accuracy, stimuli, 'ACC', type, parseBy)
        self.parseData(RT, stimuli, 'RT', type, parseBy)