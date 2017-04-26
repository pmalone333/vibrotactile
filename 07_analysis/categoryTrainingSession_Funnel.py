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

fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/01_CategoryTraining/data/888/'

os.chdir(fileDirectory)

fileList = []
for file in glob.glob("*6.mat"):
    fileList.append(file)

dataS0 = sio.loadmat(fileDirectory + fileList[0], struct_as_record=True)
dataS1 = sio.loadmat(fileDirectory + fileList[1], struct_as_record=True)


#make list of frequencies tested
FL = FG()
FL.setFrequencyList()

#pull relevant data from structures
RT            = [dataS0['trialOutput']['RT'], dataS1['trialOutput']['RT']]
accuracy      = [dataS0['trialOutput']['accuracy'], dataS1['trialOutput']['accuracy']]
stimuli       = [dataS0['trialOutput']['stimuli'], dataS1['trialOutput']['stimuli']]
subjectNumber = dataS0['exptdesign']['subNumber'][0,0][0]
subjectName   = dataS0['exptdesign']['subName'][0,0][0]

#############################################################################
#Generating accuracy by category
#############################################################################
iSession = iBlock = iTrial = 0

s_categoryA_ACC = []
s_categoryB_ACC = []
s_categoryA_RT = []
s_categoryB_RT = []
for iSession in range(len(accuracy)):
    categoryA_ACC = []
    categoryB_ACC = []
    categoryA_RT = []
    categoryB_RT = []
    for iBlock in range(accuracy[iSession].size):
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

    s_categoryA_ACC.append(sum(categoryA_ACC)/len(categoryA_ACC))
    s_categoryB_ACC.append(sum(categoryB_ACC)/len(categoryB_ACC))
    s_categoryA_RT.append(sum(categoryA_RT)/len(categoryA_RT))
    s_categoryB_RT.append(sum(categoryB_RT)/len(categoryB_RT))

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
    catProto_accuracy = []
    middleM_accuracy = []
    catBound_accuracy = []
    catProto_RT = []
    middleM_RT = []
    catBound_RT = []
    for iBlock in range(accuracy[iSession].size):
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
        s_catProto_accuracy.append(stat.mean(catProto_accuracy))
        s_catProto_RT.append(stat.mean(catProto_RT))
    else:
        s_catProto_accuracy.append(0)
        s_catProto_RT.append(0)
    if middleM_accuracy != []:
        s_middleM_accuracy.append(stat.mean(middleM_accuracy))
        s_middleM_RT.append(stat.mean(middleM_RT))
    else:
        s_middleM_accuracy.append(0)
        s_middleM_RT.append(0)
    if catBound_accuracy != []:
        s_catBound_accuracy.append(stat.mean(catBound_accuracy))
        s_catBound_RT.append(stat.mean(catBound_RT))
    else:
        s_catBound_accuracy.append(0)
        s_catBound_RT.append(0)

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

# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
fig  = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
fig2 = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
fig3 = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)

#set figure layout to hold mutlitple bars
fig['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT By Morph All Sessions")

fig2['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT By Category All Sessions")

# fig['data']  = [trace1, trace2, trace3, trace7, trace4, trace5, trace6, trace8]
# fig2['data'] = [trace9, trace10, trace7, trace11, trace12, trace8]
# fig3['data'] = [trace13, trace14, trace7, trace15, trace16, trace8]
fig['data']  = [trace1, trace2, trace3, trace7]
fig2['data'] = [trace9, trace10, trace7]

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

#close all open files
# f.close()

print("Done!")