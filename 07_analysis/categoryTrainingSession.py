#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import statistics as stat
import plotly.graph_objs as go
import plotly.tools as tls
import glob
import os
from frequencyGenerator import FrequencyGenerator as FG

#################################MAIN##########################################

fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/01_CategoryTraining/data/983/'

os.chdir(fileDirectory)

fileList = []
for file in glob.glob("*6.mat"):
    fileList.append(file)

dataS0 = sio.loadmat(fileDirectory + fileList[0], struct_as_record=True)
dataS1 = sio.loadmat(fileDirectory + fileList[1], struct_as_record=True)
dataS2 = sio.loadmat(fileDirectory + fileList[2], struct_as_record=True)
dataS3 = sio.loadmat(fileDirectory + fileList[3], struct_as_record=True)
dataS4 = sio.loadmat(fileDirectory + fileList[4], struct_as_record=True)
dataS5 = sio.loadmat(fileDirectory + fileList[5], struct_as_record=True)


#make list of frequencies tested
FL = FG()
FL.setFrequencyList()

#pull relevant data from structures
RT       = [dataS0['trialOutput']['RT'], dataS1['trialOutput']['RT'], dataS2['trialOutput']['RT'],
            dataS3['trialOutput']['RT'], dataS4['trialOutput']['RT'], dataS5['trialOutput']['RT']]

accuracy = [dataS0['trialOutput']['accuracy'], dataS1['trialOutput']['accuracy'], dataS2['trialOutput']['accuracy'],
            dataS3['trialOutput']['accuracy'], dataS4['trialOutput']['accuracy'], dataS5['trialOutput']['accuracy']]

stimuli  = [dataS0['trialOutput']['stimuli'], dataS1['trialOutput']['stimuli'], dataS2['trialOutput']['stimuli'],
            dataS3['trialOutput']['stimuli'], dataS4['trialOutput']['stimuli'], dataS5['trialOutput']['stimuli']]

subjectNumber = dataS0['exptdesign']['number'][0,0][0]
subjectName = dataS0['exptdesign']['subjectName'][0,0][0]

#############################################################################
#Generating accuracy by category
#############################################################################
iSession = iBlock = iTrial = 0

s_categoryA_ACC = []
s_categoryB_ACC = []
s_categoryA_RT = []
s_categoryB_RT = []
for iSession in range(len(accuracy)):
    b_categoryA_ACC = []
    b_categoryB_ACC = []
    b_categoryA_RT = []
    b_categoryB_RT = []
    for iBlock in range(accuracy[iSession].size):
        categoryA_ACC = []
        categoryB_ACC = []
        categoryA_RT = []
        categoryB_RT = []
        for iTrial in range(accuracy[iSession][0,iBlock].size):
            stimulus = round(stimuli[iSession][0,iBlock][0,iTrial])
            if stimulus < 47:
                categoryA_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                categoryA_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif stimulus > 47:
                categoryB_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                categoryB_RT.append(RT[iSession][0,iBlock][0,iTrial])
            else:
                print("Sorry there is an error in your category parsing function and some stimuli are not being classified")
                print("This stimulus was not put into a category: ")
                print(stimulus)

        b_categoryA_ACC.append(stat.mean(categoryA_ACC))
        b_categoryB_ACC.append(stat.mean(categoryB_ACC))
        b_categoryA_RT.append(stat.mean(categoryA_RT))
        b_categoryB_RT.append(stat.mean(categoryB_RT))

    s_categoryA_ACC.append(stat.mean(b_categoryA_ACC))
    s_categoryB_ACC.append(stat.mean(b_categoryB_ACC))
    s_categoryA_RT.append(stat.mean(b_categoryA_RT))
    s_categoryB_RT.append(stat.mean(b_categoryB_RT))

#############################################################################
#Generating accuracy by morph
#############################################################################
#calculate the accuracy by morph
iBlock = iTrial = iSession = 0

s_catProto_accuracy = []
s_middleM_accuracy = []
s_catBound_accuracy = []
s_catProto_RT = []
s_middleM_RT = []
s_catBound_RT = []
for iSession in range(len(accuracy)):
    b_catProto_accuracy = []
    b_middleM_accuracy = []
    b_catBound_accuracy = []
    b_catProto_RT = []
    b_middleM_RT = []
    b_catBound_RT = []
    for iBlock in range(accuracy[iSession].size):
        catProto_accuracy = []
        middleM_accuracy = []
        catBound_accuracy = []
        catProto_RT = []
        middleM_RT = []
        catBound_RT = []
        for iTrial in range(accuracy[iSession][0,iBlock].size):
            stimulus = round(stimuli[iSession][0,iBlock][0,iTrial])
            if stimulus == FL.frequencyList[0] or stimulus == FL.frequencyList[1] or stimulus == FL.frequencyList[2]:
                catProto_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                catProto_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif stimulus == FL.frequencyList[20] or stimulus == FL.frequencyList[19] or stimulus == FL.frequencyList[18]:
                catProto_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                catProto_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif stimulus == FL.frequencyList[3] or stimulus == FL.frequencyList[4] or stimulus == FL.frequencyList[5]:
                middleM_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                middleM_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif stimulus == FL.frequencyList[17] or stimulus == FL.frequencyList[16] or stimulus == FL.frequencyList[15]:
                middleM_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                middleM_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif stimulus == FL.frequencyList[6] or stimulus == FL.frequencyList[7] or stimulus == FL.frequencyList[8]:
                catBound_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                catBound_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif stimulus == FL.frequencyList[14] or stimulus == FL.frequencyList[13] or stimulus == FL.frequencyList[12]:
                catBound_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                catBound_RT.append(RT[iSession][0,iBlock][0,iTrial])
            else:
                print("There is something wrong with your morph parsing function and stimuli are not be classified")
                print("The following were stimuli were not parsed: ")
                print(stimulus)
        if catProto_accuracy != []:
            b_catProto_accuracy.append(stat.mean(catProto_accuracy))
            b_catProto_RT.append(stat.mean(catProto_RT))

        if middleM_accuracy != []:
            b_middleM_RT.append(stat.mean(middleM_RT))
            b_middleM_accuracy.append(stat.mean(middleM_accuracy))

        if catBound_accuracy != []:
            b_catBound_accuracy.append(stat.mean(catBound_accuracy))
            b_catBound_RT.append(stat.mean(catBound_RT))
    if b_catProto_accuracy != []:
        s_catProto_accuracy.append(stat.mean(b_catProto_accuracy))
        s_catProto_RT.append(stat.mean(b_catProto_RT))
    else:
        s_catProto_accuracy.append(0)
        s_catProto_RT.append(0)
    if b_middleM_accuracy != []:
        s_middleM_accuracy.append(stat.mean(b_middleM_accuracy))
        s_middleM_RT.append(stat.mean(b_middleM_RT))
    else:
        s_middleM_accuracy.append(0)
        s_middleM_RT.append(0)
    if b_catBound_accuracy != []:
        s_catBound_accuracy.append(stat.mean(b_catBound_accuracy))
        s_catBound_RT.append(stat.mean(b_catBound_RT))
    else:
        s_catBound_accuracy.append(0)
        s_catBound_RT.append(0)

#############################################################################
#Generating accuracy by position
#############################################################################
iBlock = iTrial = iSession = 0

s_wrist_ACC = []
s_elbow_ACC = []
s_wrist_RT = []
s_elbow_RT = []
for iSession in range(len(accuracy)):
    b_wrist_ACC = []
    b_elbow_ACC = []
    b_wrist_RT = []
    b_elbow_RT = []
    for iBlock in range(accuracy[iSession].size):
        wrist_ACC = []
        elbow_ACC = []
        wrist_RT = []
        elbow_RT = []
        for iTrial in range(accuracy[iSession][0,iBlock].size):
            position = int(stimuli[iSession][0,iBlock][2,iTrial])
            if position == 1 or position == 2:
                wrist_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                wrist_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif position == 5 or position == 6:
                elbow_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                elbow_RT.append(RT[iSession][0,iBlock][0,iTrial])
            else:
                print("There is something wrong with your position parsing function and stimuli are not be classified")
                print("The following were stimuli were not parsed: ")
                print(stimulus)

        b_wrist_ACC.append(stat.mean(wrist_ACC))
        b_elbow_ACC.append(stat.mean(elbow_ACC))
        b_wrist_RT.append(stat.mean(wrist_RT))
        b_elbow_RT.append(stat.mean(elbow_RT))

    s_wrist_ACC.append(stat.mean(b_wrist_ACC))
    s_elbow_ACC.append(stat.mean(b_elbow_ACC))
    s_wrist_RT.append(stat.mean(b_wrist_RT))
    s_elbow_RT.append(stat.mean(b_elbow_RT))



##############################################################################
#Calculating mean acc and RT overall
#############################################################################
#calculate the mean overall accuracy by block
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
x = []
i=0
for i in range(len(fileList)):
            x.append("Session: " + str(i+1))

#############################################################################
#Generating figures
#############################################################################

# (1.1) Define a trace-generating function (returns a Bar object)
def make_trace_bar(y, name):
    return go.Bar(
        x     = x,
        y     = y,            # take in the y-coords
        name  = name,      # label for hover
        xaxis = 'x1',                    # (!) both subplots on same x-axis
        yaxis = 'y1'
    )

# (1.1) Define a trace-generating function (returns a line object)
def make_trace_line(y, name, dash):
     if dash == 'y':
        return go.Scatter(
            x     = x,
            y     = y,            # take in the y-coords
            name  = name,      # label for hover
            xaxis = 'x1',                    # (!) both subplots on same x-axis
            yaxis = 'y1',
                line = dict(
                    dash  = 'dash'
                )
        )
     else:
         return go.Scatter(
            x     = x,
            y     = y,            # take in the y-coords
            name  = name,      # label for hover
            xaxis = 'x1',                    # (!) both subplots on same x-axis
            yaxis = 'y1',
    )


#make trace containing acc and RT for morph
trace1 = make_trace_bar(s_catProto_accuracy,  "Category Prototype Acc")
trace2 = make_trace_bar(s_middleM_accuracy, "Middle Morph Acc")
trace3 = make_trace_bar(s_catBound_accuracy, "Category Boundary Acc")
trace4 = make_trace_line(s_catProto_RT, "Category Prototype RT", 'n')
trace5 = make_trace_line(s_middleM_RT, "Middle Morph RT", 'n')
trace6 = make_trace_line(s_catBound_RT, "Category Boundary RT", 'n')

#make trace containing overall acc and rt
trace7 = make_trace_line(sO_accuracy, "Overall Accuracy", 'y')
trace8 = make_trace_line(sO_reactionTime, "Overall RT", 'y')

#make trace containing acc and RT for category type
trace9 = make_trace_bar(s_categoryA_ACC, 'Category A Acc (LF prox to wrist)')
trace10 = make_trace_bar(s_categoryB_ACC, 'Category B Acc (HF prox to wrist)')
trace11 = make_trace_line(s_categoryA_RT, 'Category A RT (LF prox to wrist)', 'n')
trace12 = make_trace_line(s_categoryB_RT, 'Category B RT (HF prox to wrist)', 'n')

#make trace containing acc and rt for position
trace13 = make_trace_bar(s_wrist_ACC, "Wrist Accuracy")
trace14 = make_trace_bar(s_elbow_ACC, "Elbow Accuracy")
trace15 = make_trace_line(s_wrist_RT, "Wrist RT", 'n')
trace16 = make_trace_line(s_elbow_RT, "Elbow RT", 'n')

# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
fig  = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
fig2 = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
fig3 = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)

#set figure layout to hold mutlitple bars
fig['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT By Morph All Sessions")

fig2['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT By Category All Sessions")

fig3['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT By Position All Sessions")

# fig['data']  = [trace1, trace2, trace3, trace7, trace4, trace5, trace6, trace8]
# fig2['data'] = [trace9, trace10, trace7, trace11, trace12, trace8]
# fig3['data'] = [trace13, trace14, trace7, trace15, trace16, trace8]
fig['data']  = [trace1, trace2, trace3, trace7]
fig2['data'] = [trace9, trace10, trace7]
fig3['data'] = [trace13, trace14, trace7]


#get the url of your figure to embed in html later
# first_plot_url = py.plot(fig, filename= subjectName + "AccByMorph" + session, auto_open=False,)
# tls.get_embed(first_plot_url)
# second_plot_url = py.plot(fig2, filename= subjectName + "RTbyMorph" + session, auto_open=False,)
# tls.get_embed(second_plot_url)

#bread crumbs to make sure entered the correct information
print("Your graph will be saved in this directory: " + fileDirectory + "\n")

#save images as png in case prefer compared to html
py.image.save_as(fig, fileDirectory + subjectName + "_CategTrainingMorphAccAllSession.jpeg")
py.image.save_as(fig2, fileDirectory + subjectName + "_CategTrainingAllSession.jpeg")
py.image.save_as(fig3, fileDirectory + subjectName + "_CategTrainingByPositionAllSession.jpeg")

#close all open files
# f.close()

print("Done!")