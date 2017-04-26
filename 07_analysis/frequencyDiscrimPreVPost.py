#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import statistics as stat
import math as m
import plotly.graph_objs as go
import plotly.tools as tls

tls.set_credentials_file(username='cs1471', api_key='9xknhmjhas')

#################################################################################
#allows specified increments
def my_range(start, end, step):
    while start <= end:
        yield start
        start += step

#generates a list of frequencies that we test
def makeFrequency():
    frequencyList = [i for i in my_range(0, 2.05, 0.1)]

    for index,obj in enumerate(frequencyList):
        obj += m.log2(25)
        frequencyList[index] = round(2**obj)
    return frequencyList

#################################MAIN##########################################
# filename = input('Enter a filename: \n')
# fileDirectory = input('Enter the directory where you want your figure saved: /n')
# session = input('Enter the session number: \n')

#Use when debugging or manually editing
filename = ['20151120_1031-1000_block5', '20151214_1433-1000_block5']
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/06_frequencyDiscrimination/data/1000/'


#load matfile
dataPre = sio.loadmat(fileDirectory + filename[0], struct_as_record=True)
dataPost = sio.loadmat(fileDirectory + filename[1], struct_as_record=True)

#make list of frequencies tested
frequencyList = makeFrequency()

#pull relevant data from structures
RT = [dataPre['trialOutput']['RT'], dataPost['trialOutput']['RT']]
sResp = [dataPre['trialOutput']['sResp'], dataPost['trialOutput']['sResp']]
correctResponse = [dataPre['trialOutput']['correctResponse'], dataPost['trialOutput']['correctResponse']]
accuracy = [dataPre['trialOutput']['accuracy'], dataPost['trialOutput']['accuracy']]
stimuli = [dataPre['trialOutput']['stimuli'], dataPost['trialOutput']['stimuli']]
nTrials = [dataPre['exptdesign']['numTrialsPerSession'][0,0][0], dataPost['exptdesign']['numTrialsPerSession'][0,0][0]]
nBlocks = [dataPre['exptdesign']['numBlocks'][0,0][0], dataPost['exptdesign']['numBlocks'][0,0][0]]
subjectNumber = [dataPre['exptdesign']['number'][0,0][0], dataPost['exptdesign']['number'][0,0][0]]
subjectName = [dataPre['exptdesign']['subjectName'][0,0][0], dataPre['exptdesign']['subjectName'][0,0][0]]

session = ["Pre", "Post"]

#############################################################################
#Calculations by Acc category type
#############################################################################

#calculate accuracy by frequency
FL = [frequencyList[1], frequencyList[7], frequencyList[13], frequencyList[19]]
s_sameAcc = []
s_m3w5Acc = []
s_m3w95Acc = []
s_m3bAcc = []
s_m6_95Acc = []
s_m6_5Acc = []

iTrial = iBlock = iSession = 0

for iSession in range(len(sResp)):
    b_sameAcc = []
    b_m3w5Acc = []
    b_m3w95Acc = []
    b_m3bAcc = []
    b_m6_95Acc = []
    b_m6_5Acc = []
    for iBlock in range(sResp[iSession].size):
        sameAcc = []
        m3w5Acc = []
        m3w95Acc = []
        m3bAcc = []
        m6_5Acc = []
        m6_95Acc = []
        for iTrial in range(sResp[iSession][0,iBlock].size):
            stim1 = int(round(stimuli[iSession][0,iBlock][0,iTrial]))
            stim2 = int(round(stimuli[iSession][0,iBlock][2,iTrial]))

            if stim1 == stim2:
                sameAcc.append(accuracy[iSession][0,iBlock][0,iTrial])
                print("Accuracy on same")
                print(accuracy[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[1] and stim2 == FL[3]) or (stim1 == FL[3] and stim2 == FL[1]):
                m6_5Acc.append(accuracy[iSession][0,iBlock][0,iTrial])
                print("Accuracy on 91 vs 40")
                print(accuracy[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[0] and stim2 == FL[2]) or (stim1 == FL[2] and stim2 == FL[0]):
                m6_95Acc.append(accuracy[iSession][0,iBlock][0,iTrial])
                print("Accuracy on 27 vs 63")
                print(accuracy[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[3] and stim2 == FL[2]) or (stim1 == FL[2] and stim2 == FL[3]):
                m3w5Acc.append(accuracy[iSession][0,iBlock][0,iTrial])
                print("Accuracy on 91 vs 63")
                print(accuracy[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[1] and stim2 == FL[0]) or (stim1 == FL[0] and stim2 == FL[1]):
                m3w95Acc.append(accuracy[iSession][0,iBlock][0,iTrial])
                print("Accuracy on 27 vs 63")
                print(accuracy[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[1] and stim2 == FL[2]) or (stim1 == FL[2] and stim2 == FL[1]):
                m3bAcc.append(accuracy[iSession][0,iBlock][0,iTrial])
                print("Accuracy on 40 vs 63")
                print(accuracy[iSession][0,iBlock][0,iTrial])
            else:
                print("Your script is broken and there are stimuli not being parsed correctly in frequency discrimination acc")
                print("here are the stimuli causing problems:")
                print(stim1)
                print(stim2)

        b_sameAcc.append(stat.mean(sameAcc))
        b_m3w5Acc.append(stat.mean(m3w5Acc))
        b_m3w95Acc.append(stat.mean(m3w95Acc))
        b_m3bAcc.append(stat.mean(m3bAcc))
        b_m6_5Acc.append(stat.mean(m6_5Acc))
        b_m6_95Acc.append(stat.mean(m6_95Acc))

    s_sameAcc.append(b_sameAcc)
    s_m3w5Acc.append(b_m3w5Acc)
    s_m3w95Acc.append(b_m3w95Acc)
    s_m3bAcc.append(b_m3bAcc)
    s_m6_95Acc.append(b_m6_95Acc)
    s_m6_5Acc.append(b_m6_5Acc)

############################################################################
#Calculations by Acc category RT
#############################################################################
#calculate accuracy by frequency
s_sameRT = []
s_m3w5RT = []
s_m3w95RT = []
s_m3bRT = []
s_m6_95RT = []
s_m6_5RT = []

iTrial = iBlock = iSession = 0
for iSession in range(len(sResp)):
    b_sameRT = []
    b_m3w5RT = []
    b_m3w95RT = []
    b_m3bRT = []
    b_m6_95RT = []
    b_m6_5RT = []
    for iBlock in range(sResp[iSession].size):
        sameRT = []
        m3w5RT = []
        m3w95RT = []
        m3bRT = []
        m6_95RT = []
        m6_5RT = []

        for iTrial in range(sResp[iSession][0,iBlock].size):
            stim1 = int(round(stimuli[iSession][0,iBlock][0,iTrial]))
            stim2 = int(round(stimuli[iSession][0,iBlock][2,iTrial]))

            if stim1 == stim2:
                sameRT.append(RT[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[0] and stim2 == FL[2]) or (stim1 == FL[2] and stim2 == FL[0]):
                m6_5RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[3] and stim2 == FL[1]) or (stim1 == FL[1] and stim2 == FL[3]):
                m6_95RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[0] and stim2 == FL[1]) or (stim1 == FL[1] and stim2 == FL[0]):
                m3w5RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[3] and stim2 == FL[2]) or (stim1 == FL[2] and stim2 == FL[3]):
                m3w95RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[1] and stim2 == FL[2]) or (stim1 == FL[2] and stim2 == FL[1]):
                m3bRT.append(RT[iSession][0,iBlock][0,iTrial])
            else:
                print("Your script is broken and there are stimuli not being parsed correctly in frequency discrimination RT")
                print("here are the stimuli causing problems:")
                print(stim1)
                print(stim2)

        b_sameRT.append(stat.mean(sameRT))
        b_m3w5RT.append(stat.mean(m3w5RT))
        b_m3w95RT.append(stat.mean(m3w95RT))
        b_m3bRT.append(stat.mean(m3bRT))
        b_m6_95RT.append(stat.mean(m6_95RT))
        b_m6_5RT.append(stat.mean(m6_5RT))
    s_sameRT.append(b_sameRT)
    s_m3w5RT.append(b_m3w5RT)
    s_m3w95RT.append(b_m3w95RT)
    s_m3bRT.append(b_m3bRT)
    s_m6_95RT.append(b_m6_95RT)
    s_m6_5RT.append(b_m6_5RT)

#############################################################################
#Calculations by position
#############################################################################

#calculate the reaction time by position
iBlock = iTrial = iSession = 0
sD_pos3or4_RT = []
sD_pos5or6_RT = []
sD_pos9or10_RT = []
sD_pos11or12_RT = []
sS_pos3or4_RT = []
sS_pos5or6_RT = []
sS_pos9or10_RT = []
sS_pos11or12_RT = []

for iSession in range(len(sResp)):
    bD_pos3or4_RT = []
    bD_pos5or6_RT = []
    bD_pos9or10_RT = []
    bD_pos11or12_RT = []
    bS_pos3or4_RT = []
    bS_pos5or6_RT = []
    bS_pos9or10_RT = []
    bS_pos11or12_RT = []
    for iBlock in range(sResp[iSession].size):
        D_pos3or4_RT = []
        D_pos5or6_RT = []
        D_pos9or10_RT = []
        D_pos11or12_RT = []
        S_pos3or4_RT = []
        S_pos5or6_RT = []
        S_pos9or10_RT = []
        S_pos11or12_RT = []
        for iTrial in range(sResp[iSession][0,iBlock].size):
            pos1 = int(stimuli[iSession][0,iBlock][1,iTrial])
            pos2 = int(stimuli[iSession][0,iBlock][3,iTrial])
            stim1 = stimuli[iSession][0,iBlock][0,iTrial]
            stim2 = stimuli[iSession][0,iBlock][2,iTrial]
            if stim1 != stim2:
                if (pos1 == 3 or pos1 == 4):
                    D_pos3or4_RT.append(RT[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 5 or pos1 == 6) or (pos1 == 1):
                    D_pos5or6_RT.append(RT[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 9 or pos1 == 10) or (pos1 == 13):
                    D_pos9or10_RT.append(RT[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 11 or pos1 == 12):
                    D_pos11or12_RT.append(RT[iSession][0,iBlock][0,iTrial])
                else:
                    print("Your script for Accuracy is broken and stimuli are not meeting criteria for position of different stimuli")
                    print("here are the stimuli causing problems:")
                    print(stim1)
                    print(stim2)
                    print("here are the positions causing problems:")
                    print(pos1)
                    print(pos2)
            else:
                if (pos1 == 3 or pos1 == 4):
                    S_pos3or4_RT.append(RT[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 5 or pos1 == 6) or (pos1 == 1):
                    S_pos5or6_RT.append(RT[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 9 or pos1 == 10)  or (pos1 == 13):
                    S_pos9or10_RT.append(RT[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 11 or pos1 == 12):
                    S_pos11or12_RT.append(RT[iSession][0,iBlock][0,iTrial])
                else:
                    print("Your script for Accuracy is broken and stimuli are not meeting criteria for position of same stimuli")
                    print("here are the stimuli causing problems:")
                    print(stim1)
                    print(stim2)
                    print("here are the positions causing problems:")
                    print(pos1)
                    print(pos2)

        bD_pos3or4_RT.append(stat.mean(D_pos3or4_RT))
        bD_pos5or6_RT.append(stat.mean(D_pos5or6_RT))
        bD_pos9or10_RT.append(stat.mean(D_pos9or10_RT))
        bD_pos11or12_RT.append(stat.mean(D_pos11or12_RT))
        bS_pos3or4_RT.append(stat.mean(S_pos3or4_RT))
        bS_pos5or6_RT.append(stat.mean(S_pos5or6_RT))
        bS_pos9or10_RT.append(stat.mean(S_pos9or10_RT))
        bS_pos11or12_RT.append(stat.mean(S_pos11or12_RT))
    sD_pos3or4_RT.append(bD_pos3or4_RT)
    sD_pos5or6_RT.append(bD_pos5or6_RT)
    sD_pos9or10_RT.append(bD_pos9or10_RT)
    sD_pos11or12_RT.append(bD_pos11or12_RT)
    sS_pos3or4_RT.append(bS_pos3or4_RT)
    sS_pos5or6_RT.append(bS_pos5or6_RT)
    sS_pos9or10_RT.append(bS_pos9or10_RT)
    sS_pos11or12_RT.append(bS_pos11or12_RT)


#calculate the accuracy by position
iBlock = iTrial = iSession = 0

sD_pos3or4_accuracy = []
sD_pos5or6_accuracy = []
sD_pos9or10_accuracy = []
sD_pos11or12_accuracy = []
sS_pos3or4_accuracy = []
sS_pos5or6_accuracy = []
sS_pos9or10_accuracy = []
sS_pos11or12_accuracy = []
for iSession in range(len(sResp)):
    bD_pos3or4_accuracy = []
    bD_pos5or6_accuracy = []
    bD_pos9or10_accuracy = []
    bD_pos11or12_accuracy = []
    bS_pos3or4_accuracy = []
    bS_pos5or6_accuracy = []
    bS_pos9or10_accuracy = []
    bS_pos11or12_accuracy = []
    for iBlock in range(sResp[iSession].size):
        D_pos3or4_accuracy = []
        D_pos5or6_accuracy = []
        D_pos9or10_accuracy = []
        D_pos11or12_accuracy = []
        S_pos3or4_accuracy = []
        S_pos5or6_accuracy = []
        S_pos9or10_accuracy = []
        S_pos11or12_accuracy = []
        for iTrial in range(sResp[iSession][0,iBlock].size):
            pos1 = int(stimuli[iSession][0,iBlock][1,iTrial])
            pos2 = int(stimuli[iSession][0,iBlock][3,iTrial])
            stim1 = stimuli[iSession][0,iBlock][0,iTrial]
            stim2 = stimuli[iSession][0,iBlock][2,iTrial]
            if stim1 != stim2:
                if (pos1 == 3 or pos1 == 4):
                    D_pos3or4_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 5 or pos1 == 6) or (pos1 == 1):
                    D_pos5or6_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 9 or pos1 == 10) or (pos1 == 13):
                    D_pos9or10_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 11 or pos1 == 12):
                    D_pos11or12_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                else:
                    print("Your script for RT is broken and stimuli are not meeting criteria for position of different stimuli")
                    print("here are the stimuli causing problems:")
                    print(stim1)
                    print(stim2)
                    print("here are the positions causing problems:")
                    print(pos1)
                    print(pos2)
            else:
                if (pos1 == 3 or pos1 == 4):
                    S_pos3or4_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 5 or pos1 == 6) or (pos1 == 1):
                    S_pos5or6_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 9 or pos1 == 10) or (pos1 == 13):
                    S_pos9or10_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 11 or pos1 == 12):
                    S_pos11or12_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                else:
                    print("Your script is broked and stimuli are not meeting criteria for position of same stimuli")
                    print("here are the stimuli causing problems:")
                    print(stim1)
                    print(stim2)
                    print("here are the positions causing problems:")
                    print(pos1)
                    print(pos2)

        bD_pos3or4_accuracy.append(stat.mean(D_pos3or4_accuracy))
        bD_pos5or6_accuracy.append(stat.mean(D_pos5or6_accuracy))
        bD_pos9or10_accuracy.append(stat.mean(D_pos9or10_accuracy))
        bD_pos11or12_accuracy.append(stat.mean(D_pos11or12_accuracy))
        bS_pos3or4_accuracy.append(stat.mean(S_pos3or4_accuracy))
        bS_pos5or6_accuracy.append(stat.mean(S_pos5or6_accuracy))
        bS_pos9or10_accuracy.append(stat.mean(S_pos9or10_accuracy))
        bS_pos11or12_accuracy.append(stat.mean(S_pos11or12_accuracy))
    sD_pos3or4_accuracy.append(bD_pos3or4_accuracy)
    sD_pos5or6_accuracy.append(bD_pos5or6_accuracy)
    sD_pos9or10_accuracy.append(bD_pos9or10_accuracy)
    sD_pos11or12_accuracy.append(bD_pos11or12_accuracy)
    sS_pos3or4_accuracy.append(bS_pos3or4_accuracy)
    sS_pos5or6_accuracy.append(bS_pos5or6_accuracy)
    sS_pos9or10_accuracy.append(bS_pos9or10_accuracy)
    sS_pos11or12_accuracy.append(bS_pos11or12_accuracy)

#############################################################################
#Calculating mean acc and RT overall
#############################################################################
#calculate the mean overall accuracy by block
sO_accuracy = []
iBlock = iSession = 0
for iSession in range(len(accuracy)):
    O_accuracy = []
    for iBlock in range(accuracy[iSession].size):
        O_accuracy.append(np.mean(accuracy[iSession][0,iBlock]))
sO_accuracy.append(stat.mean(O_accuracy))

#calculate the mean RT overall by block
sO_reactionTime = []
iBlock = iSession = 0
for iSession in range(len(RT)):
    O_reactionTime = []
    for iBlock in range(RT[iSession].size):
        O_reactionTime.append(np.mean(RT[iSession][0,iBlock]))
sO_reactionTime.append(stat.mean(O_reactionTime))

#x-axis label
# x = []
# i=0
# for i in range(nBlocks):
#             x.append("Block: " + str(i+1)),
x = ["Same", "Different"]
x2 = ["Same", "62.50 v 40.00", "90.91 v 62.50", "40.00 v 27.03", "90.91 v 40.00", "62.50 v 27.03"]
# x3 = ["Position 3", "Position 5", "Position 9", "Position 11"]
x3 = ["Position 3", "Position 1", "Position 13", "Position 11"]
#############################################################################
#Generating figures
#############################################################################

# (1.1) Define a trace-generating function (returns a Bar object)
def make_trace_bar(x, y, name):
    return go.Bar(
        x     = x,
        y     = y,            # take in the y-coords
        name  = name,      # label for hover
        xaxis = 'x1',                    # (!) both subplots on same x-axis
        yaxis = 'y1'
    )

# (1.1) Define a trace-generating function (returns a line object)
def make_trace_line(x, y, name):
    return go.Scatter(
        x     = x,
        y     = y,            # take in the y-coords
        name  = name,      # label for hover
        xaxis = 'x1',                    # (!) both subplots on same x-axis
        yaxis = 'y1'
    )


#make trace containing acc by position for Different Condition Pre v Post
trace1Dpre   = make_trace_bar(x3, [stat.mean(sD_pos3or4_accuracy[0]),stat.mean(sS_pos3or4_accuracy[0]), stat.mean(sD_pos5or6_accuracy[0]),stat.mean(sD_pos9or10_accuracy[0]),stat.mean(sD_pos11or12_accuracy[0])],"Pre")
trace1Dpost  = make_trace_bar(x3, [stat.mean(sD_pos3or4_accuracy[1]),stat.mean(sS_pos3or4_accuracy[1]), stat.mean(sD_pos5or6_accuracy[1]),stat.mean(sD_pos9or10_accuracy[1]),stat.mean(sD_pos11or12_accuracy[1])],"Post")

#make trace containing acc by position for Same Condition Pre v Post
trace1Spre   = make_trace_bar(x3, [stat.mean(sS_pos3or4_accuracy[0]),stat.mean(sS_pos3or4_accuracy[0]), stat.mean(sS_pos5or6_accuracy[0]),stat.mean(sS_pos9or10_accuracy[0]),stat.mean(sS_pos11or12_accuracy[0])],"Pre")
trace1Spost  = make_trace_bar(x3, [stat.mean(sS_pos3or4_accuracy[1]),stat.mean(sS_pos3or4_accuracy[1]), stat.mean(sS_pos5or6_accuracy[1]),stat.mean(sS_pos9or10_accuracy[1]),stat.mean(sS_pos11or12_accuracy[1])],"Post")

#make trace containing RT by position for Different Condition Pre v Post
trace2Dpre   = make_trace_line(x3, [stat.mean(sD_pos3or4_RT[0]),stat.mean(sS_pos3or4_RT[0]), stat.mean(sD_pos5or6_RT[0]),stat.mean(sD_pos9or10_RT[0]),stat.mean(sD_pos11or12_RT[0])],"Pre")
trace2Dpost  = make_trace_line(x3, [stat.mean(sD_pos3or4_RT[1]),stat.mean(sS_pos3or4_RT[1]), stat.mean(sD_pos5or6_RT[1]),stat.mean(sD_pos9or10_RT[1]),stat.mean(sD_pos11or12_RT[1])],"Post")

#make trace containing RT by position for Same Condition Pre v Post
trace2Spre   = make_trace_line(x3, [stat.mean(sS_pos3or4_RT[0]),stat.mean(sS_pos3or4_RT[0]), stat.mean(sS_pos5or6_RT[0]),stat.mean(sS_pos9or10_RT[0]),stat.mean(sS_pos11or12_RT[0])],"Pre")
trace2Spost  = make_trace_line(x3, [stat.mean(sS_pos3or4_RT[1]),stat.mean(sS_pos3or4_RT[1]), stat.mean(sS_pos5or6_RT[1]),stat.mean(sS_pos9or10_RT[1]),stat.mean(sS_pos11or12_RT[1])],"Post")

#make trace containing acc by frequency for Same and different Condition
trace3pre    = make_trace_bar(x2, [stat.mean(s_sameAcc[0]), stat.mean(s_m3bAcc[0]), stat.mean(s_m3w5Acc[0]), stat.mean(s_m3w95Acc[0]), stat.mean(s_m6_5Acc[0]), stat.mean(s_m6_95Acc[0])], "Pre")
trace3post   = make_trace_bar(x2, [stat.mean(s_sameAcc[1]), stat.mean(s_m3bAcc[1]), stat.mean(s_m3w5Acc[1]), stat.mean(s_m3w95Acc[1]), stat.mean(s_m6_5Acc[1]), stat.mean(s_m6_95Acc[1])], "Post")
trace4pre    = make_trace_line(x2, [stat.mean(s_sameRT[0]), stat.mean(s_m3bRT[0]), stat.mean(s_m3w5RT[0]), stat.mean(s_m3w95RT[0]), stat.mean(s_m6_5RT[0]), stat.mean(s_m6_95RT[0])], "Pre")
trace4post   = make_trace_line(x2, [stat.mean(s_sameRT[1]), stat.mean(s_m3bRT[1]), stat.mean(s_m3w5RT[1]), stat.mean(s_m3w95RT[1]), stat.mean(s_m6_5RT[1]), stat.mean(s_m6_95RT[1])], "Pre")

# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
figDifferentPrePost_Pos = tls.make_subplots(
                    rows=1,
                    cols=1,
                    shared_xaxes=True,
                    )

figSamePrePost_Pos = tls.make_subplots(
                rows=1,
                cols=1,
                shared_xaxes=True,
                )

figPrePost_freq  = tls.make_subplots(
                rows=1,
                cols=1,
                shared_xaxes=True,
                )

#set figure layout to hold mutlitple bars
figDifferentPrePost_Pos['layout'].update(
    barmode     = 'group',
    bargroupgap = 0,
    bargap      = 0.25,
    title       = subjectNumber[0] + " Pre and Post Accuracy and RT by Position for Different Condition on FD task "
)

figSamePrePost_Pos['layout'].update(
    barmode     = 'group',
    bargroupgap = 0,
    bargap      = 0.25,
    title       = subjectNumber[0] + " Pre and Post Accuracy and RT by Position for Same Condition on FD task "
)

figPrePost_freq['layout'].update(
    barmode     = 'group',
    bargroupgap = 0,
    bargap      = 0.25,
    title       = subjectNumber[0] + " Pre and Post Accuracy and RT by Frequency on FD task "
)
figDifferentPrePost_Pos['data']  = [trace1Dpre, trace1Dpost, trace2Dpre, trace2Dpost]
figSamePrePost_Pos['data']       = [trace1Spre, trace1Spost, trace2Spre, trace2Spost]
figPrePost_freq['data']          = [trace3pre, trace3post, trace4pre, trace4post]

#get the url of your figure to embed in html later
# first_plot_url = py.plot(fig, filename= subjectName + "AccByMorph" + session, auto_open=False,)
# tls.get_embed(first_plot_url)
# second_plot_url = py.plot(fig2, filename= subjectName + "RTbyMorph" + session, auto_open=False,)
# tls.get_embed(second_plot_url)
# third_plot_url = py.plot(fig3, filename= subjectName + "AccByCatgeory" + session, auto_open=False,)
# tls.get_embed(third_plot_url)

#bread crumbs to make sure entered the correct information
print("Your graph will be saved in this directory: " + fileDirectory + "\n")

# #embed figure data in html
# html_string = '''
# <html>
#     <head>
#         <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
#         <style>body{ margin:0 100; background:whitesmoke; }</style>
#     </head>
#     <body>
#         <!-- *** FirstPlot *** --->
#         <iframe width="1000" height="550" frameborder="0" seamless="seamless" scrolling="no" \
# src="'''+ first_plot_url + '''.embed?width=800&height=550"></iframe>
#         <!-- *** Second Plot *** --->
#         <iframe width="1000" height="550" frameborder="0" seamless="seamless" scrolling="no" \
# src="'''+ second_plot_url + '''.embed?width=800&height=550"></iframe>
#         <!-- *** ThirdPlot *** --->
#         <iframe width="1000" height="550" frameborder="0" seamless="seamless" scrolling="no" \
# src="'''+ third_plot_url + '''.embed?width=800&height=550"></iframe>
# </html>'''
#
# #save figure data in location specific previously
# f = open(fileDirectory + filename + '.html','w')
# f.write(html_string)

# save images as png in case prefer compared to html
print("Your image will save under: " + "frequencyDiscrim_Dpos_PrePost" + subjectNumber[0] + "\n")
print("Your image will save under: " + "frequencyDiscrim_Spos_PrePost" + subjectNumber[0] + "\n")
print("Your image will save under: " + "frequencyDiscrim_freq_PrePost" + subjectNumber[0] + "\n")

py.image.save_as(figDifferentPrePost_Pos, fileDirectory + "frequencyDiscrim_Dpos_PrePost" + subjectNumber[0] + ".jpeg")
py.image.save_as(figSamePrePost_Pos, fileDirectory + "frequencyDiscrim_Spos_PrePost" + subjectNumber[0] + ".jpeg")
py.image.save_as(figPrePost_freq, fileDirectory + "frequencyDiscrim_freq_PrePost" + subjectNumber[0] + ".jpeg")
#close all open files
# f.close()

print("Done!")
