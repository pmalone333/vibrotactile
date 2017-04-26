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
filename = ('20160217_1644-MR1008_block6')
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/01_CategoryTraining/data/1008/'
session = '4'

#load matfile
data = sio.loadmat(fileDirectory + filename, struct_as_record=True)

#make list of frequencies tested
frequencyList = makeFrequency()

#pull relevant data from structures
RT = data['trialOutput']['RT']
sResp = data['trialOutput']['sResp']
correctResponse = data['trialOutput']['correctResponse']
accuracy = data['trialOutput']['accuracy']
level = data['trialOutput']['level']
stimuli = data['trialOutput']['stimuli']
nTrials = data['exptdesign']['numTrialsPerSession'][0,0][0]
nBlocks = data['exptdesign']['numSessions'][0,0][0]
subjectNumber = data['exptdesign']['number'][0,0][0]
subjectName = data['exptdesign']['subjectName'][0,0][0]


#############################################################################
#Calculations by category type
#############################################################################

#calculate accuracy by category type
b_categoryA = []
b_categoryB = []
b_categoryA_RT = []
b_categoryB_RT = []
iBlock = iTrial = 0
for iBlock in range(sResp.size):
    categoryA = []
    categoryB = []
    categoryA_RT = []
    categoryB_RT = []
    for iTrial in range(sResp[0,iBlock].size):
        stimulus = round(stimuli[0,iBlock][0,iTrial])
        if stimulus < 47:
            categoryA.append(accuracy[0,iBlock][0,iTrial])
            categoryA_RT.append(RT[0,iBlock][0,iTrial])
        elif stimulus > 47:
            categoryB.append(accuracy[0,iBlock][0,iTrial])
            categoryB_RT.append(RT[0,iBlock][0,iTrial])
        else:
            print("Sorry there is an error in your category parsing function and some stimuli are not being classified")
            print("This stimulus was not put into a category: ")
            print(stimulus)

    b_categoryA.append(stat.mean(categoryA))
    b_categoryB.append(stat.mean(categoryB))
    b_categoryA_RT.append(stat.mean(categoryA_RT))
    b_categoryB_RT.append(stat.mean(categoryB_RT))

#############################################################################
#Calculations by morph
#############################################################################

#calculate the accuracy by morph
iBlock = iTrial = 0
b_catProto_accuracy = []
b_middleM_accuracy = []
b_catBound_accuracy = []
b_catProto_RT = []
b_middleM_RT = []
b_catBound_RT = []
for iBlock in range(sResp.size):
    catProto_accuracy = []
    middleM_accuracy = []
    catBound_accuracy = []
    catProto_RT = []
    middleM_RT = []
    catBound_RT = []
    for iTrial in range(sResp[0,iBlock].size):
        stimulus = round(stimuli[0,iBlock][0,iTrial])
        if stimulus == frequencyList[0] or stimulus == frequencyList[1] or stimulus == frequencyList[2]:
            catProto_accuracy.append(accuracy[0,iBlock][0,iTrial])
            catProto_RT.append(RT[0,iBlock][0,iTrial])
        elif stimulus == frequencyList[20] or stimulus == frequencyList[19] or stimulus == frequencyList[18]:
            catProto_accuracy.append(accuracy[0,iBlock][0,iTrial])
            catProto_RT.append(RT[0,iBlock][0,iTrial])
        elif stimulus == frequencyList[3] or stimulus == frequencyList[4] or stimulus == frequencyList[5]:
            middleM_accuracy.append(accuracy[0,iBlock][0,iTrial])
            middleM_RT.append(RT[0,iBlock][0,iTrial])
        elif stimulus == frequencyList[17] or stimulus == frequencyList[16] or stimulus == frequencyList[15]:
            middleM_accuracy.append(accuracy[0,iBlock][0,iTrial])
            middleM_RT.append(RT[0,iBlock][0,iTrial])
        elif stimulus == frequencyList[6] or stimulus == frequencyList[7] or stimulus == frequencyList[8]:
            catBound_accuracy.append(accuracy[0,iBlock][0,iTrial])
            catBound_RT.append(RT[0,iBlock][0,iTrial])
        elif stimulus == frequencyList[14] or stimulus == frequencyList[13] or stimulus == frequencyList[12]:
            catBound_accuracy.append(accuracy[0,iBlock][0,iTrial])
            catBound_RT.append(RT[0,iBlock][0,iTrial])
        else:
            print("There is something wrong with your morph parsing function and stimuli are not be classified")
            print("The following were stimuli were not parsed: ")
            print(stimulus)
    if catProto_accuracy != []:
        b_catProto_accuracy.append(stat.mean(catProto_accuracy))
        b_catProto_RT.append(stat.mean(catProto_RT))
    else:
        b_catProto_accuracy.append(stat.mean(0))
        b_catProto_RT.append(0)

    if middleM_accuracy != []:
        b_middleM_RT.append(stat.mean(middleM_RT))
        b_middleM_accuracy.append(stat.mean(middleM_accuracy))
    else:
        b_middleM_RT.append(0)
        b_middleM_accuracy.append(0)

    if catBound_accuracy != []:
        b_catBound_accuracy.append(stat.mean(catBound_accuracy))
        b_catBound_RT.append(stat.mean(catBound_RT))
    else:
        b_catBound_accuracy.append(0)
        b_catBound_RT.append(0)


#############################################################################
#Calculations by Position Pair
#############################################################################
#calculate the accuracy by morph
iBlock = iTrial = 0
b_wrist_ACC = []
b_elbow_ACC = []
b_wrist_RT = []
b_elbow_RT = []
for iBlock in range(sResp.size):
    wrist_ACC = []
    elbow_ACC = []
    wrist_RT = []
    elbow_RT = []
    for iTrial in range(sResp[0,iBlock].size):
        position = int(stimuli[0,iBlock][2,iTrial])
        if position == 1 or position == 2:
            wrist_ACC.append(accuracy[0,iBlock][0,iTrial])
            wrist_RT.append(RT[0,iBlock][0,iTrial])
        elif position == 5 or position == 6:
            elbow_ACC.append(accuracy[0,iBlock][0,iTrial])
            elbow_RT.append(RT[0,iBlock][0,iTrial])
        else:
            print("There is something wrong with your position parsing function and stimuli are not be classified")
            print("The following were stimuli were not parsed: ")
            print(stimulus)
    b_wrist_ACC.append(stat.mean(wrist_ACC))
    b_elbow_ACC.append(stat.mean(elbow_ACC))
    b_wrist_RT.append(stat.mean(wrist_RT))
    b_elbow_RT.append(stat.mean(elbow_RT))

#############################################################################
#Calculating mean acc and RT overall
#############################################################################
#calculate the mean overall accuracy by block
O_accuracy = []
iBlock = 0
for iBlock in range(accuracy.size):
    O_accuracy.append(np.mean([accuracy[0,iBlock]]))

#calculate the mean RT overall by block
O_reactionTime = []
iBlock = 0
for iBlock in range(RT.size):
    O_reactionTime.append(np.mean(RT[0,iBlock]))

#x-axis label
x = []
i=0
for i in range(nBlocks):
            x.append("Block: " + str(i+1) + ", Level: " + str(level[0,i][0,0])),

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
trace1 = make_trace_bar(b_catProto_accuracy,  "Category Prototype Acc")
trace2 = make_trace_bar(b_middleM_accuracy, "Middle Morph Acc")
trace3 = make_trace_bar(b_catBound_accuracy, "Category Boundary Acc")
trace4 = make_trace_line(b_catProto_RT, "Category Prototype RT", 'n')
trace5 = make_trace_line(b_middleM_RT, "Middle Morph RT", 'n')
trace6 = make_trace_line(b_catBound_RT, "Category Boundary RT", 'n')

#make trace containing overall acc and rt
trace7 = make_trace_line(O_accuracy, "Overall Accuracy", 'y')
trace8 = make_trace_line(O_reactionTime, "Overall RT", 'y')

#make trace containing acc and RT for category type
trace9 = make_trace_bar(b_categoryA, 'Category A Acc (LF prox to wrist)')
trace10 = make_trace_bar(b_categoryB, 'Category B Acc (HF prox to wrist)')
trace11 = make_trace_line(b_categoryA_RT, 'Category A RT (LF prox to wrist)', 'n')
trace12 = make_trace_line(b_categoryB_RT, 'Category B RT (HF prox to wrist)', 'n')

#make trace containing acc and rt for position
trace13 = make_trace_bar(b_wrist_ACC, "Wrist Accuracy")
trace14 = make_trace_bar(b_elbow_ACC, "Elbow Accuracy")
trace15 = make_trace_line(b_wrist_RT, "Wrist RT", 'n')
trace16 = make_trace_line(b_elbow_RT, "Elbow RT", 'n')

# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
fig  = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
fig2 = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
fig3 = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)

#set figure layout to hold mutlitple bars
fig['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT By Morph Session " + session)

fig2['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT By Category Session " + session)

fig3['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
    title = subjectNumber + " Accuracy and RT By Position Session " + session)

fig['data']  = [trace1, trace2, trace3, trace7, trace4, trace5, trace6, trace8]
fig2['data'] = [trace9, trace10, trace7, trace11, trace12, trace8]
fig3['data'] = [trace13, trace14, trace7, trace15, trace16, trace8]

#get the url of your figure to embed in html later
# first_plot_url = py.plot(fig, filename= subjectName + "AccByMorph" + session, auto_open=False,)
# tls.get_embed(first_plot_url)
# second_plot_url = py.plot(fig2, filename= subjectName + "RTbyMorph" + session, auto_open=False,)
# tls.get_embed(second_plot_url)

#bread crumbs to make sure entered the correct information
print("Your graph will be saved in this directory: " + fileDirectory + "\n")
print("Your graph will be saved under: " + filename + "\n")
print("The session number you have indicated is: " + session + "\n")


#embed figure data in html
# html_string = '''
# <html>
#     <head>
#         <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
#         <style>body{ margin:0 100; background:whitesmoke; }</style>
#     </head>
#     <body>
#         <!-- *** Accuracy by Morph *** --->
#         <iframe width="1000" height="550" frameborder="0" seamless="seamless" scrolling="no" \
# src="'''+ first_plot_url + '''.embed?width=800&height=550"></iframe>
#         <!-- *** Accuracy by Morph *** --->
#         <iframe width="1000" height="550" frameborder="0" seamless="seamless" scrolling="no" \
# src="'''+ second_plot_url + '''.embed?width=800&height=550"></iframe>
#         <!-- *** Accuracy by Morph *** --->
#         <iframe width="1000" height="550" frameborder="0" seamless="seamless" scrolling="no" \
# src="'''+ third_plot_url + '''.embed?width=800&height=550"></iframe>
#         <!-- *** Accuracy by Morph *** --->
#         <iframe width="1000" height="550" frameborder="0" seamless="seamless" scrolling="no" \
# src="'''+ fourth_plot_url + '''.embed?width=800&height=550"></iframe>
#     </body>
# </html>'''
#
# #save figure data in location specific previously
# f = open(fileDirectory + filename + '.html','w')
# f.write(html_string)

#save images as png in case prefer compared to html
py.image.save_as(fig, fileDirectory + filename + "_CategTrainingMorphAccSession" + session + ".jpeg")
py.image.save_as(fig2, fileDirectory + filename + "_CategTrainingSession" + session + ".jpeg")
py.image.save_as(fig3, fileDirectory + filename + "_CategTrainingByPositionSession" + session + ".jpeg")

#close all open files
# f.close()

print("Done!")
