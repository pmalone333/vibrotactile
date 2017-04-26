#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import statistics as stat
import plotly.graph_objs as go
import plotly.tools as tls
from FrequencyFunction_General import FrequencyGeneral
from PositionFunction_General import Position_general

tls.set_credentials_file(username='cs1471', api_key='9xknhmjhas')

# filename = input('Enter a filename: \n')
# fileDirectory = input('Enter the directory where you want your figure saved: /n')
# session = input('Enter the session number: \n')

#Use when debugging or manually editing
filename = ('20160421_1107-MR1032_block7')
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/06_frequencyDiscrimination/data/1032/'

#load matfile
data = sio.loadmat(fileDirectory + filename, struct_as_record=True)

iBlock = 0
#pull relevant data from structures
RT            = data['trialOutput']['RT']
ACC           = data['trialOutput']['accuracy']
stimuli       = data['trialOutput']['stimuli']
subjectNumber = data['exptdesign']['number'][0,0][0]
nBlocks       = data['exptdesign']['numBlocks'][0,0][0]

if int(data['exptdesign']['preOrPostTrain'][0,0][0]) == 1:
    session = "Pre"
else:
    session = "post"

#############################################################################
#Calculations by Acc by frequency
#############################################################################

FreqObj = FrequencyGeneral(stimuli=stimuli)
FreqObj.calcAccRT(ACC, RT, 'Block')


#############################################################################
#Calculations by Acc by position
#############################################################################

PosObj = Position_general()
PosObj.calcAccRT(ACC, RT, stimuli, 'freq', 'Block')

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

#x-axis label
x3 = []
i=0
for i in range(nBlocks):
            x3.append("Block: " + str(i+1)),
x = ["Different", "Same"]
x2 = ["Same", "62.50 v 40.00", "90.91 v 62.50", "40.00 v 27.03", "90.91 v 40.00", "62.50 v 27.03"]

#############################################################################
#Generating figures
#############################################################################

# (1.1) Define a trace-generating function (returns a Bar object)
def make_trace_bar(x, y, name):
    return go.Bar( x = x, y = y, name  = name, xaxis = 'x1', yaxis = 'y1')

# (1.1) Define a trace-generating function (returns a line object)
def make_trace_line(x, y, name):
    return go.Scatter(x = x, y = y, name = name, xaxis = 'x1', yaxis = 'y1')

#make trace containing acc and RT by position for Different Condition

trace_FG_ACC = []
trace_FG_RT = []

trace_PG_ACC_3or4   = make_trace_bar(x, [PosObj.ACC[0][0], PosObj.ACC[0][4]], "Position 3 or 4 Acc" )
trace_PG_ACC_5or6   = make_trace_bar(x, [PosObj.ACC[0][1],PosObj.ACC[0][5]],"Position 5 or 6 Acc" )
trace_PG_ACC_9or10  = make_trace_bar(x, [PosObj.ACC[0][2],PosObj.ACC[0][6]],"Position 9 or 10 Acc" )
trace_PG_ACC_11or12 = make_trace_bar(x, [PosObj.ACC[0][3],PosObj.ACC[0][7]],"Position 11 or 12 Acc" )
trace_PG_RT_3or4    = make_trace_line(x, [PosObj.RT[0][0],PosObj.RT[0][4]],"Position 3 or 4 RT" )
trace_PG_RT_5or6    = make_trace_line(x, [PosObj.RT[0][1],PosObj.RT[0][5]],"Position 5 or 6 RT" )
trace_PG_RT_9or10   = make_trace_line(x, [PosObj.RT[0][2],PosObj.RT[0][6]],"Position 9 or 10 RT" )
trace_PG_RT_11or12  = make_trace_line(x, [PosObj.RT[0][3],PosObj.RT[0][7]],"Position 11 or 12 RT" )

#make trace containing acc by frequency for Same and different Condition
trace_FG_ACC.append(make_trace_bar(x2, [FreqObj.ACC[0][0], FreqObj.ACC[0][1], FreqObj.ACC[0][2], FreqObj.ACC[0][3], FreqObj.ACC[0][4], FreqObj.ACC[0][5]] , "Acc"))

for index in range(6):
    trace_FG_RT.append(make_trace_line(x2[index], FreqObj.RT[0][index], "RT"))

# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
fig_frequency = tls.make_subplots( rows=1, cols=1, shared_xaxes=True )
fig_position = tls.make_subplots( rows=1, cols=1, shared_xaxes=True )

#set figure layout to hold mutlitple bars
fig_frequency['layout'].update( barmode='group', bargroupgap=0, bargap=0.25,
                                title = subjectNumber + " Accuracy by Frequency across conditions " + session )

fig_position['layout'].update( barmode='group', bargroupgap=0, bargap=0.25,
                       title = subjectNumber + " Accuracy by Position across conditions " + session )

fig_frequency['data']  = trace_FG_ACC
fig_position['data'] = [trace_PG_ACC_3or4, trace_PG_ACC_5or6, trace_PG_ACC_9or10, trace_PG_ACC_11or12,
                          trace_PG_RT_3or4, trace_PG_RT_5or6, trace_PG_RT_9or10, trace_PG_RT_11or12 ]

#bread crumbs to make sure entered the correct information
print("Your graph will be saved in this directory: " + fileDirectory + "\n")
print("Your graph will be saved under: " + filename + "\n")
print("The session number you have indicated is: " + session + "\n")

# save images as png in case prefer compared to html
py.image.save_as(fig_frequency, fileDirectory + filename + "frequencyDiscrim_freq" + session + ".jpeg")
py.image.save_as(fig_position, fileDirectory + filename + "frequencyDiscrim_pos" + session + ".jpeg")

print("Done!")
