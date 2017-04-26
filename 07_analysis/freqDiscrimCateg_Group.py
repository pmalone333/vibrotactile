#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import statistics as stat
import plotly.tools as tls
from frequencyGenerator import FrequencyGenerator as FG
from figureFunctions import FrequencyFunctions as FF
import plotly.graph_objs as go
import glob
import os

tls.set_credentials_file(username='cs1471', api_key='9xknhmjhas')

#################################################################################
#allows specified increments
#make list of frequencies tested
FL = FG()
FL.setFrequencyList()

#################################MAIN##########################################
# filename = input('Enter a filename: \n')
# fileDirectory = input('Enter the directory where you want your figure saved: /n')
# session = input('Enter the session number: \n')


#Use when debugging or manually editing
filename = ['20160130_1240-MR873_block7', '20160204_1051-MR946_block7', '20160203_1831-MR983_block7', '20160114_1207-MR998_block7', '20160118_1513-MR1000_block7', '20160209_1457-MR1008_block7']
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/06_frequencyDiscrimination/data/'

os.chdir(fileDirectory)

fileList = []
for file in glob.glob("*.mat"):
    fileList.append(file)


#load matfile
data873  = sio.loadmat(fileDirectory + '873/' + filename[0], struct_as_record=True)
data946  = sio.loadmat(fileDirectory + '946/' + filename[1], struct_as_record=True)
data983  = sio.loadmat(fileDirectory + '983/' + filename[2], struct_as_record=True)
data998  = sio.loadmat(fileDirectory + '998/' + filename[3], struct_as_record=True)
data1000 = sio.loadmat(fileDirectory + '1000/' + filename[4], struct_as_record=True)
data1008 = sio.loadmat(fileDirectory + '1008/' + filename[5], struct_as_record=True)

#pull relevant data from structures
RT = [ data873['trialOutput']['RT'], data946['trialOutput']['RT'], data983['trialOutput']['RT'],
       data998['trialOutput']['RT'], data1000['trialOutput']['RT'], data1008['trialOutput']['RT']]
accuracy = [ data873['trialOutput']['accuracy'], data946['trialOutput']['accuracy'], data983['trialOutput']['accuracy'],
             data998['trialOutput']['accuracy'], data1000['trialOutput']['accuracy'], data1008['trialOutput']['accuracy']]
stimuli = [ data873['trialOutput']['stimuli'], data946['trialOutput']['stimuli'], data983['trialOutput']['stimuli'],
            data998['trialOutput']['stimuli'], data1000['trialOutput']['stimuli'], data1008['trialOutput']['stimuli']]
subjectNumber = [ data873['exptdesign']['number'][0,0][0], data946['exptdesign']['number'][0,0][0], data983['exptdesign']['number'][0,0][0],
                  data998['exptdesign']['number'][0,0][0], data1000['exptdesign']['number'][0,0][0], data1008['exptdesign']['number'][0,0][0]]

#############################################################################
#Calculations by Acc category type
#############################################################################

#calculate accuracy by frequency


FL = [FL.frequencyList[0], FL.frequencyList[7], FL.frequencyList[13], FL.frequencyList[20]]
s_sameAcc = []
s_m3wHAcc = []
s_m3wLAcc = []
s_m3bAcc = []
s_m6_H_Acc = []
s_m6_L_Acc = []
s_sameRT = []
s_m3wHRT = []
s_m3wLRT = []
s_m3bRT = []
s_m6_H_RT = []
s_m6_L_RT = []
iSession = iTrial = iBlock = 0
for iSession in range(len(accuracy)):
    b_sameAcc = []
    b_m3wHAcc = []
    b_m3wLAcc = []
    b_m3bAcc = []
    b_m6_H_Acc = []
    b_m6_L_Acc = []
    b_sameRT = []
    b_m3wHRT = []
    b_m3wLRT = []
    b_m3bRT = []
    b_m6_H_RT = []
    b_m6_L_RT = []
    for iBlock in range(accuracy[iSession].size):
        sameAcc = []
        m3wHAcc = []
        m3wLAcc = []
        m3bAcc = []
        m6_H_Acc = []
        m6_L_Acc = []
        sameRT = []
        m3wHRT = []
        m3wLRT = []
        m3bRT = []
        m6_H_RT = []
        m6_L_RT = []
        for iTrial in range(accuracy[iSession][0,iBlock].size):
            stim1 = int(round(stimuli[iSession][0,iBlock][0,iTrial]))
            stim2 = int(round(stimuli[iSession][0,iBlock][1,iTrial]))
            stim3 = int(round(stimuli[iSession][0,iBlock][4,iTrial]))
            stim4 = int(round(stimuli[iSession][0,iBlock][5,iTrial]))
            if stim1 == stim3:
                sameAcc.append(accuracy[iSession][0,iBlock][0,iTrial])
                sameRT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((stim1 == FL[0] or stim1 == FL[2]) and (stim3 == FL[2] or stim3 == FL[0])):
                m6_L_Acc.append(accuracy[iSession][0,iBlock][0,iTrial])
                m6_L_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[3] or stim1 == FL[1]) and (stim3 == FL[1] or stim2 == FL[3]):
                m6_H_Acc.append(accuracy[iSession][0,iBlock][0,iTrial])
                m6_H_RT.append(RT[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[0] or stim1 == FL[1]) and (stim3 == FL[1] or stim3 == FL[0]):
                m3wLAcc.append(accuracy[iSession][0,iBlock][0,iTrial])
                m3wLRT.append(RT[iSession][0,iBlock][0,iTrial])
            elif (stim1 == FL[3] or stim1 == FL[2]) and (stim3 == FL[2] or stim3 == FL[3]):
                m3wHAcc.append(accuracy[iSession][0,iBlock][0,iTrial])
                m3wHRT.append(RT[iSession][0,iBlock][0,iTrial])
            elif ((stim1 == FL[1]) and (stim3 == FL[2])) or (stim1 == FL[2] and (stim3 == FL[1])):
                m3bAcc.append(accuracy[iSession][0,iBlock][0,iTrial])
                m3bRT.append(RT[iSession][0,iBlock][0,iTrial])

        b_sameAcc.append(stat.mean(sameAcc))
        b_m3wHAcc.append(stat.mean(m3wHAcc))
        b_m3wLAcc.append(stat.mean(m3wLAcc))
        b_m3bAcc.append(stat.mean(m3bAcc))
        b_m6_H_Acc.append(stat.mean(m6_H_Acc))
        b_m6_L_Acc.append(stat.mean(m6_L_Acc))
        b_sameRT.append(stat.mean(sameRT))
        b_m3wHRT.append(stat.mean(m3wHRT))
        b_m3wLRT.append(stat.mean(m3wLRT))
        b_m3bRT.append(stat.mean(m3bRT))
        b_m6_H_RT.append(stat.mean(m6_H_RT))
        b_m6_L_RT.append(stat.mean(m6_L_RT))
    s_sameAcc.append(stat.mean(b_sameAcc))
    s_m3wHAcc.append(stat.mean(b_m3wHAcc))
    s_m3wLAcc.append(stat.mean(b_m3wLAcc))
    s_m3bAcc.append(stat.mean(b_m3bAcc))
    s_m6_H_Acc.append(stat.mean(b_m6_H_Acc))
    s_m6_L_Acc.append(stat.mean(b_m6_L_Acc))
    s_sameRT.append(stat.mean(b_sameRT))
    s_m3wHRT.append(stat.mean(b_m3wHRT))
    s_m3wLRT.append(stat.mean(b_m3wLRT))
    s_m3bRT.append(stat.mean(b_m3bRT))
    s_m6_H_RT.append(stat.mean(b_m6_H_RT))
    s_m6_L_RT.append(stat.mean(b_m6_L_RT))
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
for iSession in range(len(accuracy)):
    O_reactionTime = []
    for iBlock in range(RT[iSession].size):
        O_reactionTime.append(np.mean(RT[iSession][0,iBlock]))
    sO_reactionTime.append(stat.mean(O_reactionTime))

#x-axis label
# x = []
# i=0
# for i in range(nBlocks):
#             x.append("Block: " + str(i+1)),
x2 = ["Same", "M3B", "M3WH", "M3WL", "M6H", "M6L"]

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

#make trace containing acc by frequency for Same and different Condition\
trace873_A   = make_trace_bar(x2, [s_sameAcc[0], s_m3bAcc[0], s_m3wHAcc[0], s_m3wLAcc[0], s_m6_H_Acc[0], s_m6_L_Acc[0]], "873")
trace873_RT  = make_trace_line(x2, [s_sameRT[0], s_m3bRT[0], s_m3wHRT[0], s_m3wLRT[0], s_m6_H_RT[0], s_m6_L_RT[0]], "873")
trace946_A   = make_trace_bar(x2, [s_sameAcc[1], s_m3bAcc[1], s_m3wHAcc[1], s_m3wLAcc[1], s_m6_H_Acc[1], s_m6_L_Acc[1]], "946")
trace946_RT  = make_trace_line(x2, [s_sameRT[1], s_m3bRT[1], s_m3wHRT[1], s_m3wLRT[1], s_m6_H_RT[1], s_m6_L_RT[1]], "946")
trace983_A   = make_trace_bar(x2, [s_sameAcc[2], s_m3bAcc[2], s_m3wHAcc[2], s_m3wLAcc[2], s_m6_H_Acc[2], s_m6_L_Acc[2]], "983")
trace983_RT  = make_trace_line(x2, [s_sameRT[2], s_m3bRT[2], s_m3wHRT[2], s_m3wLRT[2], s_m6_H_RT[2], s_m6_L_RT[2]], "983")
trace998_A   = make_trace_bar(x2, [s_sameAcc[3], s_m3bAcc[3], s_m3wHAcc[3], s_m3wLAcc[3], s_m6_H_Acc[3], s_m6_L_Acc[3]], "998")
trace998_RT  = make_trace_line(x2, [s_sameRT[3], s_m3bRT[3], s_m3wHRT[3], s_m3wLRT[3], s_m6_H_RT[3], s_m6_L_RT[3]], "998")
trace1000_A  = make_trace_bar(x2, [s_sameAcc[4], s_m3bAcc[4], s_m3wHAcc[4], s_m3wLAcc[4], s_m6_H_Acc[4], s_m6_L_Acc[4]], "1000")
trace1000_RT = make_trace_line(x2, [s_sameRT[4], s_m3bRT[4], s_m3wHRT[4], s_m3wLRT[4], s_m6_H_RT[4], s_m6_L_RT[4]], "1000")
trace1008_A  = make_trace_bar(x2, [s_sameAcc[5], s_m3bAcc[5], s_m3wHAcc[5], s_m3wLAcc[5], s_m6_H_Acc[5], s_m6_L_Acc[5]], "1008")
trace1008_RT = make_trace_line(x2, [s_sameRT[5], s_m3bRT[5], s_m3wHRT[5], s_m3wLRT[5], s_m6_H_RT[5], s_m6_L_RT[5]], "1008")

# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
figACC = tls.make_subplots( rows=1, cols=1, shared_xaxes=True,)
figRT  = tls.make_subplots( rows=1, cols=1, shared_xaxes=True,)

#set figure layout to hold mutlitple bars
figACC['layout'].update( barmode='group', bargroupgap=0, bargap=0.25,
    title = "New FreqDiscrim Accuracy by Morph Distance")

figRT['layout'].update( barmode='group', bargroupgap=0, bargap=0.25,
    title = "New FreqDiscrim RT by Morph Distance")

figACC['data']  = [trace873_A, trace946_A, trace983_A, trace998_A, trace1000_A, trace1008_A]
figRT['data']  = [trace873_RT, trace946_RT, trace983_RT, trace998_RT, trace1000_RT, trace1008_RT]

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
py.image.save_as(figACC, fileDirectory + "Group_CategFrequencyDiscrim_ACC.jpeg")
py.image.save_as(figRT, fileDirectory + "Group_CategFrequencyDiscrim_RT.jpeg")
#close all open files
# f.close()

print("Done!")
