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
filename = ['20151118_1239-1000_block7.mat', 'MR1000_block7.144.mat']
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/03_spatialLocalization/data/1000/'


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
#Calculations by position
#############################################################################

sD_wristPos_accuracy = []
sD_elbowPos_accuracy = []
sD_crossMidline_accuracy = []
sS_wristPos_accuracy = []
sS_elbowPos_accuracy = []
sS_midline_accuracy = []
sD_wristPos_RT = []
sD_elbowPos_RT = []
sD_crossMidline_RT = []
sS_wristPos_RT = []
sS_elbowPos_RT = []
sS_midline_RT = []
#calculate the accuracy by position
iBlock = iTrial = iSession = 0
for iSession in range(len(accuracy)):
    bD_wristPos_accuracy = []
    bD_elbowPos_accuracy = []
    bD_crossMidline_accuracy = []
    bS_wristPos_accuracy = []
    bS_elbowPos_accuracy = []
    bS_midline_accuracy = []
    bD_wristPos_RT = []
    bD_elbowPos_RT = []
    bD_crossMidline_RT = []
    bS_wristPos_RT = []
    bS_elbowPos_RT = []
    bS_midline_RT = []
    for iBlock in range(accuracy[iSession].size):
        D_wristPos_accuracy = []
        D_elbowPos_accuracy = []
        D_crossMidline_accuracy = []
        S_wristPos_accuracy = []
        S_elbowPos_accuracy = []
        S_midline_accuracy = []
        D_wristPos_RT = []
        D_elbowPos_RT = []
        D_crossMidline_RT = []
        S_wristPos_RT = []
        S_elbowPos_RT = []
        S_midline_RT = []
        for iTrial in range(accuracy[iSession][0,iBlock].size):
            pos1 = int(stimuli[iSession][0,iBlock][0,iTrial])
            pos2 = int(stimuli[iSession][0,iBlock][2,iTrial])
            if pos1 != pos2:
                if (pos1 == 1 or pos1 == 2 or pos1 == 3 or pos1 == 4 or pos1 == 5 or pos1 == 6)\
                        and (pos2 == 1 or pos2 == 2 or pos2 == 3 or pos2 == 4 or pos2 == 5 or pos2 == 6):
                    D_wristPos_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                    D_wristPos_RT.append(RT[iSession][0,iBlock][0,iTrial])
                elif (pos1 == 9 or pos1 == 10 or pos1 == 11 or pos1 == 12 or pos1 == 13 or pos1 == 14)\
                        and (pos2 == 9 or pos2 == 10 or pos2 == 11 or pos2 == 12 or pos2 == 13 or pos2 == 14):
                    D_elbowPos_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                    D_elbowPos_RT.append(RT[iSession][0,iBlock][0,iTrial])
                else:
                    D_crossMidline_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                    D_crossMidline_RT.append(RT[iSession][0,iBlock][0,iTrial])
            else:
                if pos1 == 1 or pos1 == 2 or pos1 == 3 or pos1 == 4:
                    S_wristPos_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                    S_wristPos_RT.append(RT[iSession][0,iBlock][0,iTrial])
                elif pos1 == 5 or pos1 == 6 or pos1 == 9 or pos1 == 10:
                    S_midline_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                    S_midline_RT.append(RT[iSession][0,iBlock][0,iTrial])
                else:
                    S_elbowPos_accuracy.append(accuracy[iSession][0,iBlock][0,iTrial])
                    S_elbowPos_RT.append(RT[iSession][0,iBlock][0,iTrial])
    
        bD_wristPos_accuracy.append(stat.mean(D_wristPos_accuracy))
        bD_elbowPos_accuracy.append(stat.mean(D_elbowPos_accuracy))
        bD_crossMidline_accuracy.append(stat.mean(D_crossMidline_accuracy))
        bS_wristPos_accuracy.append(stat.mean(S_wristPos_accuracy))
        bS_elbowPos_accuracy.append(stat.mean(S_elbowPos_accuracy))
        bS_midline_accuracy.append(stat.mean(S_midline_accuracy))
        bD_wristPos_RT.append(stat.mean(D_wristPos_RT))
        bD_elbowPos_RT.append(stat.mean(D_elbowPos_RT))
        bD_crossMidline_RT.append(stat.mean(D_crossMidline_RT))
        bS_wristPos_RT.append(stat.mean(S_wristPos_RT))
        bS_elbowPos_RT.append(stat.mean(S_elbowPos_RT))
        bS_midline_RT.append(stat.mean(S_midline_RT))
    sD_wristPos_accuracy.append(stat.mean(bD_wristPos_accuracy))
    sD_elbowPos_accuracy.append(stat.mean(bD_elbowPos_accuracy))
    sD_crossMidline_accuracy.append(stat.mean(bD_crossMidline_accuracy))
    sS_wristPos_accuracy.append(stat.mean(bS_wristPos_accuracy))
    sS_elbowPos_accuracy.append(stat.mean(bS_elbowPos_accuracy))
    sS_midline_accuracy.append(stat.mean(bS_midline_accuracy))
    sD_wristPos_RT.append(stat.mean(bD_wristPos_RT))
    sD_elbowPos_RT.append(stat.mean(bD_elbowPos_RT))
    sD_crossMidline_RT.append(stat.mean(bD_crossMidline_RT))
    sS_wristPos_RT.append(stat.mean(bS_wristPos_RT))
    sS_elbowPos_RT.append(stat.mean(bS_elbowPos_RT))
    sS_midline_RT.append(stat.mean(bS_midline_RT))

#############################################################################
#Calculations for stimuli around Boundary
#############################################################################

    #calculate the accuracy by position
    iBlock = iTrial = iSession = 0
sD_pos5v1_ACC = []
sD_pos5v3_ACC = []
sD_pos5v9_ACC = []
sD_pos5v11_ACC = []
sD_pos9v3_ACC = []
sD_pos9v5_ACC = []
sD_pos9v11_ACC = []
sD_pos9v13_ACC = []
sD_pos5v1_RT = []
sD_pos5v3_RT = []
sD_pos5v9_RT = []
sD_pos5v11_RT = []
sD_pos9v3_RT = []
sD_pos9v5_RT = []
sD_pos9v11_RT = []
sD_pos9v13_RT = []
for iSession in range(len(accuracy)):
    bD_pos5v1_ACC = []
    bD_pos5v3_ACC = []
    bD_pos5v9_ACC = []
    bD_pos5v11_ACC = []
    bD_pos9v3_ACC = []
    bD_pos9v5_ACC = []
    bD_pos9v11_ACC = []
    bD_pos9v13_ACC = []
    bD_pos5v1_RT = []
    bD_pos5v3_RT = []
    bD_pos5v9_RT = []
    bD_pos5v11_RT = []
    bD_pos9v3_RT = []
    bD_pos9v5_RT = []
    bD_pos9v11_RT = []
    bD_pos9v13_RT = []
    
    for iBlock in range(accuracy[iSession].size):
        D_pos5v1_ACC = []
        D_pos5v3_ACC = []
        D_pos5v9_ACC = []
        D_pos5v11_ACC = []
        D_pos9v3_ACC = []
        D_pos9v5_ACC = []
        D_pos9v11_ACC = []
        D_pos9v13_ACC = []
        D_pos5v1_RT = []
        D_pos5v3_RT = []
        D_pos5v9_RT = []
        D_pos5v11_RT = []
        D_pos9v3_RT = []
        D_pos9v5_RT = []
        D_pos9v11_RT = []
        D_pos9v13_RT = []
        for iTrial in range(accuracy[iSession][0,iBlock].size):
            pos1 = int(stimuli[iSession][0,iBlock][0,iTrial])
            pos2 = int(stimuli[iSession][0,iBlock][2,iTrial])
            if ((pos1 == 5 or pos1 == 6) and (pos2 == 1 or pos2 == 2)) \
                    or ((pos1 == 1 or pos1 == 2) and (pos2 == 5 or pos2 == 6)):
                D_pos5v1_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                D_pos5v1_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((pos1 == 5 or pos1 == 6) and (pos2 == 3 or pos2 == 4))\
                        or ((pos1 == 3 or pos1 == 4) and (pos2 == 5 or pos2 == 6)):
                D_pos5v3_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                D_pos5v3_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((pos1 == 5 or pos1 == 6) and (pos2 == 9 or pos2 == 10)):
                D_pos5v9_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                D_pos5v9_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((pos1 == 5 or pos1 == 6) and (pos2 == 11 or pos2 ==12))\
                    or ((pos1 == 11 or pos1 ==12) and (pos2 == 5 or pos2 ==6)):
                D_pos5v11_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                D_pos5v11_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((pos1 == 9 or pos1 == 10) and (pos2 == 3 or pos2 == 4))\
                   or ((pos1 == 3 or pos1 == 4) and (pos2 == 9 or pos2 == 10)):
                D_pos9v3_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                D_pos9v3_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((pos1 == 9 or pos1 == 10) and (pos2 == 5 or pos2 == 6)):
                D_pos9v5_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                D_pos9v5_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((pos1 == 9 or pos1 == 10) and (pos2 == 11 or pos2 == 12))\
                    or ((pos1 == 11 or pos1 == 12) and (pos2 == 9 or pos2 ==10)):
                D_pos9v11_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                D_pos9v11_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((pos1 == 9 or pos1 == 10) and (pos2 == 13 or pos2 == 14))\
                    or ((pos1 == 13 or pos1 == 14) and (pos2 == 9 or pos2 == 10)):
                D_pos9v13_ACC.append(accuracy[iSession][0,iBlock][0,iTrial])
                D_pos9v13_RT.append(RT[iSession][0,iBlock][0,iTrial])
    
        bD_pos5v1_ACC.append(stat.mean(D_pos5v1_ACC))
        bD_pos5v1_RT.append(stat.mean(D_pos5v1_RT))
        bD_pos5v3_ACC.append(stat.mean(D_pos5v3_ACC))
        bD_pos5v3_RT.append(stat.mean(D_pos5v3_RT))
        bD_pos5v9_ACC.append(stat.mean(D_pos5v9_ACC))
        bD_pos5v9_RT.append(stat.mean(D_pos5v9_RT))
        bD_pos5v11_ACC.append(stat.mean(D_pos5v11_ACC))
        bD_pos5v11_RT.append(stat.mean(D_pos5v11_RT))
        bD_pos9v3_ACC.append(stat.mean(D_pos9v3_ACC))
        bD_pos9v3_RT.append(stat.mean(D_pos9v3_RT))
        bD_pos9v5_ACC.append(stat.mean(D_pos9v5_ACC))
        bD_pos9v5_RT.append(stat.mean(D_pos9v5_RT))
        bD_pos9v11_ACC.append(stat.mean(D_pos9v11_ACC))
        bD_pos9v11_RT.append(stat.mean(D_pos9v11_RT))
        bD_pos9v13_ACC.append(stat.mean(D_pos9v13_ACC))
        bD_pos9v13_RT.append(stat.mean(D_pos9v13_RT))
    sD_pos5v1_ACC.append(stat.mean(bD_pos5v1_ACC))
    sD_pos5v1_RT.append(stat.mean(bD_pos5v1_RT))
    sD_pos5v3_ACC.append(stat.mean(bD_pos5v3_ACC))
    sD_pos5v3_RT.append(stat.mean(bD_pos5v3_RT))
    sD_pos5v9_ACC.append(stat.mean(bD_pos5v9_ACC))
    sD_pos5v9_RT.append(stat.mean(bD_pos5v9_RT))
    sD_pos5v11_ACC.append(stat.mean(bD_pos5v11_ACC))
    sD_pos5v11_RT.append(stat.mean(bD_pos5v11_RT))
    sD_pos9v3_ACC.append(stat.mean(bD_pos9v3_ACC))
    sD_pos9v3_RT.append(stat.mean(bD_pos9v3_RT))
    sD_pos9v5_ACC.append(stat.mean(bD_pos9v5_ACC))
    sD_pos9v5_RT.append(stat.mean(bD_pos9v5_RT))
    sD_pos9v11_ACC.append(stat.mean(bD_pos9v11_ACC))
    sD_pos9v11_RT.append(stat.mean(bD_pos9v11_RT))
    sD_pos9v13_ACC.append(stat.mean(bD_pos9v13_ACC))
    sD_pos9v13_RT.append(stat.mean(bD_pos9v13_RT))

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
x = ["Different", "Same"]
x2 = ["(5,1) vs (9,13)", "(5,3) vs (9,11)", "(5,9) vs (9,5)", "(5,11) vs (9,3)"]
x3 = ["D_Wrist Accuracy", "D_Midline Accuracy", "D_Elbow Accuracy", "S_Wrist Accuracy", "S_Midline Accuracy", "S_Elbow Accuracy"]
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
trace1Dpre  = make_trace_bar( x3, [sD_wristPos_accuracy[0], sD_crossMidline_accuracy[0], sD_elbowPos_accuracy[0],
                                  sS_wristPos_accuracy[0], sS_midline_accuracy[0], sS_elbowPos_accuracy[0]], "Acc Pre" )
trace1Dpost = make_trace_bar( x3, [sD_wristPos_accuracy[1], sD_crossMidline_accuracy[1], sD_elbowPos_accuracy[1],
                                   sS_wristPos_accuracy[1], sS_midline_accuracy[1], sS_elbowPos_accuracy[1]], "Acc Post" )
trace2Dpre  = make_trace_line( x3, [sD_wristPos_RT[0], sD_crossMidline_RT[0], sD_elbowPos_RT[0],
                                   sS_wristPos_RT[0], sS_midline_RT[0], sS_elbowPos_RT[0]], "RT Pre")
trace2Dpost = make_trace_line( x3, [sD_wristPos_RT[1], sD_crossMidline_RT[1], sD_elbowPos_RT[1],
                                    sS_wristPos_RT[1], sS_midline_RT[1], sS_elbowPos_RT[1]], "RT Post")

#make trace parsing out positions 5 and 9
trace7_5pre  = make_trace_bar(x2, [sD_pos5v1_ACC[0], sD_pos5v3_ACC[0], sD_pos5v9_ACC[0], sD_pos5v11_ACC[0]], "Pos 5 Comparisons Acc - Pre")
trace7_5post = make_trace_bar(x2, [sD_pos5v1_ACC[1], sD_pos5v3_ACC[1], sD_pos5v9_ACC[1], sD_pos5v11_ACC[1]], "Pos 5 Comparisons Acc - Post")
trace7_9pre  = make_trace_bar(x2, [sD_pos9v13_ACC[0], sD_pos9v11_ACC[0], sD_pos9v5_ACC[0], sD_pos9v3_ACC[0]], "Pos 9 Comparisons Acc - Pre")
trace7_9post = make_trace_bar(x2, [sD_pos9v13_ACC[1], sD_pos9v11_ACC[1], sD_pos9v5_ACC[1], sD_pos9v3_ACC[1]], "Pos 9 Comparisons Acc - Post")
trace8_5pre  = make_trace_line(x2, [sD_pos5v1_RT[0], sD_pos5v3_RT[0], sD_pos5v9_RT[0], sD_pos5v11_RT[0]], "Pos 5 Comparisons RT - Pre")
trace8_5post = make_trace_line(x2, [sD_pos5v1_RT[1], sD_pos5v3_RT[1], sD_pos5v9_RT[1], sD_pos5v11_RT[1]], "Pos 5 Comparisons RT - Post")
trace8_9pre  = make_trace_line(x2, [sD_pos9v13_RT[0], sD_pos9v11_RT[0], sD_pos9v5_RT[0], sD_pos9v3_RT[0]], "Pos 9 Comparisons RT - Pre")
trace8_9post = make_trace_line(x2, [sD_pos9v13_RT[1], sD_pos9v11_RT[1], sD_pos9v5_RT[1], sD_pos9v3_RT[1]], "Pos 9 Comparisons RT - Post")

# matFileName = fileDirectory + filename
# dataFile = sio.savemat(matFileName, {'x':x, 'y':y, 'cp_mean': cp_mean, 'mm_mean': mm_mean, 'cb_mean': cb_mean)
# dataFile.write(x,y,cp_mean, mm_mean, cb_mean,)
# dataFile.close()


# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
fig = tls.make_subplots( rows=1, cols=1, shared_xaxes=True,)
fig2 = tls.make_subplots( rows=1, cols=1, shared_xaxes=True,)

#set figure layout to hold mutlitple bars
fig['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber[0] + " Accuracy and RT by Position Same v Different Pre v Post")

fig2['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber[0] + " Accuracy and RT at Position 5 and 9 Pre v Post")

fig['data']  = [trace1Dpre, trace1Dpost, trace2Dpre, trace2Dpost]
fig2['data'] = [trace7_5pre, trace7_5post, trace7_9pre, trace7_9post, trace8_5pre, trace8_5post, trace8_9pre, trace8_9post]

# #get the url of your figure to embed in html later
# first_plot_url = py.plot(fig, filename= subjectName + "AccByMorph" + session, auto_open=False,)
# tls.get_embed(first_plot_url)

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
# </html>'''
#
# #save figure data in location specific previously
# f = open(fileDirectory + filename + '.html','w')
# f.write(html_string)

# save images as png in case prefer compared to html
py.image.save_as(fig, fileDirectory + subjectName[0] + "spatialLoc_PreVPost.png")
py.image.save_as(fig2, fileDirectory + subjectName[0] + "spatialLoc5v9_PreVPost.png")
#close all open files
# f.close()

print("Done!")
