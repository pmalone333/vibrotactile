#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import statistics as stat
import plotly.graph_objs as go
import plotly.tools as tls
from Position import Position

tls.set_credentials_file(username='cs1471', api_key='9xknhmjhas')

# filename = input('Enter a filename: \n')
# fileDirectory = input('Enter the directory where you want your figure saved: /n')
# session = input('Enter the session number: \n')

#Use when debugging or manually editing
filename = ('20160420_1822-MR1032_block7.144')
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/03_spatialLocalization/data/1032/'


#load matfile
data = sio.loadmat(fileDirectory + filename, struct_as_record=True)

#pull relevant data from structures
RT            = data['trialOutput']['RT']
ACC           = data['trialOutput']['accuracy']
stimuli       = data['trialOutput']['stimuli']
subjectNumber = data['exptdesign']['number'][0,0][0]

if int(data['trialOutput']['preOrPostTrain'][0,0][0]) == 1:
    session = "Pre"
else:
    session = "post"

#############################################################################
#Calculations by position
#############################################################################

PosObj = Position()
PosObj.PG.calcAccRT(ACC, RT, stimuli, 'pos', 'Block')

#############################################################################
#Calculations at boundary
#############################################################################

PosObj.PC.calcAccRT(ACC, RT, stimuli, 'Block')

#############################################################################
#Calculating mean acc and RT overall
#############################################################################
#calculate the mean overall accuracy by block
O_accuracy = []
iBlock = 0
for iBlock in range(ACC.size):
    O_accuracy.append(np.mean(ACC[0,iBlock]))

#calculate the mean RT overall by block
O_reactionTime = []
iBlock = 0
for iBlock in range(RT.size):
    O_reactionTime.append(np.mean(RT[0,iBlock]))

x = ["Different", "Same"]
x2 = ["(5,1) vs (9,13)", "(5,3) vs (9,11)", "(5,9) vs (9,5)", "(5,11) vs (9,3)"]
#############################################################################
#Generating figures
#############################################################################

# (1.1) Define a trace-generating function (returns a Bar object)
def make_trace_bar(x, y, name):
    return go.Bar( x = x, y = y, name  = name, xaxis = 'x1', yaxis = 'y1')

# (1.1) Define a trace-generating function (returns a line object)
def make_trace_line(x, y, name):
    return go.Scatter( x = x, y = y, name = name, xaxis = 'x1', yaxis = 'y1')

#make trace containing acc and RT by position for Different Condition
trace1 = make_trace_bar( x, [PosObj.PG.ACC[0], PosObj.PG.ACC[3]], "Wrist Accuracy" )
trace2 = make_trace_bar( x, [PosObj.PG.ACC[1], PosObj.PG.ACC[4]], "Across Mid Accuracy" )
trace3 = make_trace_bar( x, [PosObj.PG.ACC[2], 0], "Elbow Accuracy" )
trace4 = make_trace_line( x, [PosObj.PG.RT[0], PosObj.PG.RT[3]], "Wrist RT" )
trace5 = make_trace_line( x, [PosObj.PG.RT[1], PosObj.PG.RT[4]], "Across Mid RT" )
trace6 = make_trace_line( x, [PosObj.PG.RT[2], 0], "Elbow RT" )

#make trace parsing out positions 5 and 9
trace7 = make_trace_bar(x2, PosObj.PC.ACC[0:4], "Pos 5 Comparisons Acc")
trace8 = make_trace_bar(x2, PosObj.PC.ACC[4:8], "Pos 9 Comparisons Acc")
trace9 = make_trace_line(x2, PosObj.PC.RT[0:4], "Pos 5 Comparisons RT")
trace10 = make_trace_line(x2, PosObj.PC.RT[4:8], "Pos 9 Comparisons RT")

# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
fig = tls.make_subplots( rows=1, cols=1, shared_xaxes=True,)
fig2 = tls.make_subplots( rows=1, cols=1, shared_xaxes=True,)

#set figure layout to hold mutlitple bars
fig['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT by Position Same v Different " + session)

fig2['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT at Position 5 and 9 " + session)

fig['data']  = [trace1, trace2, trace3, trace4, trace5, trace6]
fig2['data'] = [trace7, trace8, trace9, trace10]

#bread crumbs to make sure entered the correct information
print("Your graph will be saved in this directory: " + fileDirectory + "\n")
print("Your graph will be saved under: " + filename + "\n")
print("The session number you have indicated is: " + session + "\n")

# save images as png in case prefer compared to html
py.image.save_as(fig, fileDirectory + filename + "spatialLoc" + session + ".png")
py.image.save_as(fig2, fileDirectory + filename + "spatialLoc5v9" + session + ".png")
print("Done!")
