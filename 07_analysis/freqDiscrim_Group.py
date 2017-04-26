#packages to import
import scipy.io as sio
import plotly.plotly as py
import plotly.graph_objs as go
import plotly.tools as tls
import glob
import os
from dPrime import Dprime
from FrequencyFunction_General import FrequencyGeneral
from PositionFunction_General import Position_general
import numpy as np


tls.set_credentials_file(username='cs1471', api_key='9xknhmjhas')

#Use when debugging or manually editing
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/06_frequencyDiscrimination/data/groupData/'

os.chdir(fileDirectory)

data = []
for file in glob.glob("*.mat"):
    data.append(sio.loadmat(file, struct_as_record=True))

#pull relevant data from structures
iSubject = 0
#pull relevant data from structures
RT            = [data[iSubject]['trialOutput']['RT'] for iSubject in range(len(data))]
ACC           = [data[iSubject]['trialOutput']['accuracy'] for iSubject in range(len(data))]
stimuli       = [data[iSubject]['trialOutput']['stimuli'] for iSubject in range(len(data))]
subjectNumber = [data[iSubject]['exptdesign']['number'][0,0][0] for iSubject in range(len(data))]
nBlocks       = [data[iSubject]['exptdesign']['numBlocks'][0,0][0] for iSubject in range(len(data))]

#############################################################################
#Calculations by Acc category type
#############################################################################

FreqObj = FrequencyGeneral(stimuli = stimuli)
FreqObj.calcAccRT(ACC, RT, 'Subject')

#############################################################################
#Calculations by position
#############################################################################
PosObj = Position_general()
PosObj.calcAccRT(ACC, RT, stimuli, 'freq', 'Subject')

#############################################################################
#Calculating dPrime
#############################################################################
dPrimeObj = Dprime()
dprime = dPrimeObj.dPrimeCalc(ACC, stimuli, 'f')

#############################################################################
#Calculating overall frequency accuracy
#############################################################################

#calculate the mean overall accuracy by block
O_accuracy = []
iBlock = iSubject = 0
for iSubject in range(len(ACC)):
    accuracy = []
    for iBlock in range(ACC[iSubject].size):
        accuracy.append(np.mean(ACC[iSubject][0,iBlock]))
    O_accuracy.append(accuracy)

x = ["Diff Pos3", "Diff Pos5", "Diff Pos9", "Diff Pos11", "Same Pos3", "Same Pos5", "Same Pos9", "Same Pos11"]
x2 = ["Same", "62.50 v 40.00", "90.91 v 62.50", "40.00 v 27.03", "90.91 v 40.00", "62.50 v 27.03"]
x3 = ['Dprime', 'True Positive Rate', 'False Positive Rate', 'True Negative Rate', 'False Negative Rate']
x4 = []
i=0
for i in range(7):
            x4.append("Block: " + str(i+1)),
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

#make trace containing acc and RT by position for Different Condition
trace_PG_ACC = []
trace_PG_RT = []
trace_FG_ACC = []
trace_FG_RT = []
trace_dprime = []
trace_Overall = []
for index, iSubject in enumerate(subjectNumber):
    trace_PG_ACC.append(make_trace_bar(x, PosObj.ACC[(index)], iSubject))
    trace_PG_RT.append(make_trace_line(x, PosObj.RT[(index)], iSubject))
    trace_FG_ACC.append(make_trace_bar(x2, FreqObj.ACC[(index)], iSubject))
    trace_FG_RT.append(make_trace_line(x2, FreqObj.RT[(index)], iSubject))
    trace_dprime.append(make_trace_bar(x3, [dprime[index], dPrimeObj.TPR[index], dPrimeObj.FPR[index], dPrimeObj.TNR[index], dPrimeObj.FNR[index]], iSubject))
    trace_Overall.append(make_trace_bar(x4, O_accuracy[index], iSubject))


# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
figFreq_ACC = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figPos_ACC  = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figFreq_RT  = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figPos_RT   = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figDPrime   = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figOverall  = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)

#set figure layout to hold mutlitple bars
figFreq_ACC['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "Accuracy by Frequency on Single Stimuli Frequency Discrimination Task", yaxis = dict(dtick = .1))

figPos_ACC['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "Accuracy by Position on Single Stimuli Frequency Discrimination Task", yaxis = dict(dtick = .1))

figDPrime['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "Dprime Across Subjects on Single Stimuli Frequency Discrimination Task", yaxis = dict(dtick = .1))

figFreq_RT['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "RT by Frequency on Single Stimuli Frequency Discrimination Task", yaxis = dict(dtick = .1))

figPos_RT['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "RT by Position on Single Stimuli Frequency Discrimination Task", yaxis = dict(dtick = .1))

figOverall['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "Accuracy by Block for Frequency Discrimination Single Stimulus", yaxis = dict(dtick = .1))

figFreq_ACC['data'] = trace_FG_ACC
figFreq_RT['data']  = trace_FG_RT
figDPrime['data']   = trace_dprime
figPos_ACC['data']  = trace_PG_ACC
figPos_RT['data']   = trace_PG_RT
figOverall['data']  = trace_Overall

#bread crumbs to make sure entered the correct information
print("Your graph will be saved in this directory: " + fileDirectory + "\n")

# save images as png in case prefer compared to html
# py.image.save_as(figFreq_ACC, fileDirectory + "frequencyDiscrim_Freq_ACC_Group.jpeg")
# py.image.save_as(figFreq_RT, fileDirectory + "frequencyDiscrim_Freq_RT_Group.jpeg")
py.image.save_as(figDPrime, fileDirectory + "frequencyDiscrim_Dprime_Group.jpeg")
# py.image.save_as(figPos_ACC, fileDirectory + "frequencyDiscrim_Pos_ACC_Group.jpeg")
# py.image.save_as(figPos_RT, fileDirectory + "frequencyDiscrim_Pos_RT_Group.jpeg")
py.image.save_as(figOverall, fileDirectory + "frequencyDiscrim_Overall_Group.jpeg")


print("Done!")
