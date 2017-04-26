#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import statistics as stat
import plotly.graph_objs as go
import plotly.tools as tls
from dPrime import Dprime
from Position import Position
import os
import glob


tls.set_credentials_file(username='cs1471', api_key='9xknhmjhas')

# filename = input('Enter a filename: \n')
# fileDirectory = input('Enter the directory where you want your figure saved: /n')
# session = input('Enter the session number: \n')

#Use when debugging or manually editing
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/03_spatialLocalization/data/groupData/'

os.chdir(fileDirectory)

data = []
for file in glob.glob("*.mat"):
    data.append(sio.loadmat(file, struct_as_record=True))

#load matfile
iSubject = 0
#pull relevant data from structures
RT            = [data[iSubject]['trialOutput']['RT'] for iSubject in range(len(data))]
accuracy      = [data[iSubject]['trialOutput']['accuracy'] for iSubject in range(len(data))]
stimuli       = [data[iSubject]['trialOutput']['stimuli'] for iSubject in range(len(data))]
subjectNumber = [data[iSubject]['exptdesign']['number'][0,0][0] for iSubject in range(len(data))]

#############################################################################
#Calculations by position
#############################################################################

positionObj = Position()
positionObj.parseData(accuracy, RT, stimuli, 'pos')

#############################################################################
#Calculations by position
#############################################################################

dPrimeObj = Dprime()
dprime = dPrimeObj.dPrimeCalc(accuracy, stimuli, 'p')

#############################################################################
#Calculating mean acc and RT overall
#############################################################################
#calculate the mean overall accuracy by block
sO_accuracy = []
iBlock = iSubject = 0
for iSubject in range(len(accuracy)):
    O_accuracy = []
    for iBlock in range(accuracy[iSubject].size):
        O_accuracy.append(np.mean(accuracy[iSubject][0,iBlock]))
sO_accuracy.append(stat.mean(O_accuracy))

#calculate the mean RT overall by block
sO_reactionTime = []
iBlock = iSubject = 0
for iSubject in range(len(RT)):
    O_reactionTime = []
    for iBlock in range(RT[iSubject].size):
        O_reactionTime.append(np.mean(RT[iSubject][0,iBlock]))
sO_reactionTime.append(stat.mean(O_reactionTime))

x = ["Different", "Same"]
x2 = ["(5,1)", "(9,13)", "(5,3)", "(9,11)", "(5,9)", "(9,5)", "(5,11)", "(9,3)"]
x3 = ["D_Wrist Accuracy", "D_Midline Accuracy", "D_Elbow Accuracy", "S_Wrist Accuracy", "S_Midline Accuracy", "S_Elbow Accuracy"]
x4 = ['Dprime', 'True Positive Rate', 'False Positive Rate', 'True Negative Rate', 'False Negative Rate']
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
trace_PC_ACC = []
trace_PC_RT = []
trace_dprime = []
for index, iSubject in enumerate(subjectNumber):
    trace_PG_ACC.append(make_trace_bar(x3, positionObj.PG.ACC[(index)], iSubject))
    trace_PG_RT.append(make_trace_line(x3, positionObj.PG.RT[(index)], iSubject))
    trace_PC_ACC.append(make_trace_bar(x2, positionObj.PC.ACC[(index)], iSubject))
    trace_PC_RT.append(make_trace_line(x2, positionObj.PC.RT[(index)], iSubject))
    trace_dprime.append(make_trace_bar(x4, [dprime[index], dPrimeObj.TPR[index], dPrimeObj.FPR[index], dPrimeObj.TNR[index], dPrimeObj.FNR[index]], iSubject))

# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
fig_Pos_ACC = tls.make_subplots( rows=1, cols=1, shared_xaxes=True)
fig_Pos_RT  = tls.make_subplots( rows=1, cols=1, shared_xaxes=True)
fig_dprime  = tls.make_subplots( rows=1, cols=1, shared_xaxes=True)
fig_Pos5v9_ACC = tls.make_subplots( rows=1, cols=1, shared_xaxes=True)
fig_Pos5v9_RT = tls.make_subplots( rows=1, cols=1, shared_xaxes=True)

#set figure layout to hold mutlitple bars
fig_Pos_ACC['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "Accuracy by Position Group Data for Spatial Localization Task")
fig_Pos_RT['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "RT by Position Group Data for Spatial Localization Task")
fig_dprime['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "dPrime Group Data for Spatial Localization Task")
fig_Pos5v9_ACC['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "Accuracy Position 5 and 9 Group Data for Spatial Localization Task")
fig_Pos5v9_RT['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = "RT Position 5 and 9 Group Data for Spatial Localization Task")

fig_Pos_ACC['data']    = trace_PG_ACC
fig_Pos_RT['data']     = trace_PG_RT
fig_dprime['data']     = trace_dprime
fig_Pos5v9_ACC['data'] = trace_PC_ACC
fig_Pos5v9_RT['data']  = trace_PC_RT

#bread crumbs to make sure entered the correct information
print("Your graph will be saved in this directory: " + fileDirectory + "\n")

# save images as png in case prefer compared to html
py.image.save_as(fig_Pos_ACC, fileDirectory + "spatialLoc_ACC_Group.jpeg")
py.image.save_as(fig_Pos_RT, fileDirectory + "spatialLoc_RT_Group.jpeg")
py.image.save_as(fig_dprime, fileDirectory + "spatialLoc_dprime_Group.jpeg")
py.image.save_as(fig_Pos5v9_ACC, fileDirectory + "spatialLoc5v9_ACC_Group.jpeg")
py.image.save_as(fig_Pos5v9_RT, fileDirectory + "spatialLoc5v9_RT_Group.jpeg")


print("Done!")
