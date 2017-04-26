#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import plotly.graph_objs as go
import plotly.tools as tls
import glob
import os

tls.set_credentials_file(username='cs1471', api_key='9xknhmjhas')

#Use when debugging or manually editing
fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Automaticity/03_EEG/01_Behavioral/'
fileMRI = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Automaticity/03_EEG/groupAccuracyAim2RA.mat'
os.chdir(fileDirectory)

dataMRI = sio.loadmat(fileMRI, struct_as_record=True)
temp = dataMRI['accuracyData'][0]
ACC_mri = np.delete(temp, [8])
temp2 = dataMRI['accuracyData'][1]
subjectList = np.delete(temp2, [8])

ACC_mri2 = []
for element in ACC_mri:
    ACC_mri2.append(element)

subjectList.sort()
sList_string = []
for num in subjectList:
    sList_string.append(str(int(num)))

data = []
for file in glob.glob("*.mat"):
    data.append(sio.loadmat(file, struct_as_record=True))

#pull relevant data from structures
iSubject = 0
#pull relevant data from structures
ACC            = [data[iSubject]['trialOutputNew'][0]['ACC'] for iSubject in range(len(data))]
condition      = [data[iSubject]['trialOutputNew'][0]['condition'] for iSubject in range(len(data))]
mLine          = [data[iSubject]['trialOutputNew'][0]['mLine'] for iSubject in range(len(data))]
subjectNumber  = [data[iSubject]['exptdesign']['subjectName'][0,0][0] for iSubject in range(len(data))]
startTime      = [data[iSubject]['trialOutputNew'][0]['startTime'] for iSubject in range(len(data))]
endTime        = [data[iSubject]['trialOutputNew'][0]['endTime'] for iSubject in range(len(data))]


iSubject = iBlock = iTrial = 0
m0_mean   = []
m3w_mean  = []
m3b_mean  = []
m6_mean   = []
for iSubject in range(len(condition)):
    m0  = []
    m3w = []
    m3b = []
    m6  = []
    for iBlock in range(len(condition[iSubject])):
        for iTrial, value in enumerate(condition[iSubject][iBlock][0]):
            if value == 1:
                m0.append(ACC[iSubject][iBlock][0][iTrial])
            elif value == 2:
                m3w.append(ACC[iSubject][iBlock][0][iTrial])
            elif value == 3:
                m3b.append(ACC[iSubject][iBlock][0][iTrial])
            elif value == 4:
                m6.append(ACC[iSubject][iBlock][0][iTrial])
            else:
                print('Seek new employment because you cannot generate a working script')

    m0_mean.append(sum(m0)/len(m0))
    m3w_mean.append(sum(m3w)/len(m3w))
    m3b_mean.append(sum(m3b)/len(m3b))
    m6_mean.append(sum(m6)/len(m6))

iSubject = iBlock = iTrial = 0
m0_mean_RT   = []
m3w_mean_RT  = []
m3b_mean_RT  = []
m6_mean_RT   = []
for iSubject in range(len(condition)):
    m0_RT  = []
    m3w_RT = []
    m3b_RT = []
    m6_RT  = []
    for iBlock in range(len(condition[iSubject])):
        for iTrial, value in enumerate(condition[iSubject][iBlock][0]):
            if value == 1:
                m0_RT.append(endTime[iSubject][iBlock][0][iTrial] - startTime[iSubject][iBlock][0][iTrial])
            elif value == 2:
                m3w_RT.append(endTime[iSubject][iBlock][0][iTrial] - startTime[iSubject][iBlock][0][iTrial])
            elif value == 3:
                m3b_RT.append(endTime[iSubject][iBlock][0][iTrial] - startTime[iSubject][iBlock][0][iTrial])
            elif value == 4:
                m6_RT.append(endTime[iSubject][iBlock][0][iTrial] - startTime[iSubject][iBlock][0][iTrial])
            else:
                print('Seek new employment because you cannot generate a working script')

    m0_mean_RT.append(sum(m0_RT)/len(m0_RT))
    m3w_mean_RT.append(sum(m3w_RT)/len(m3w_RT))
    m3b_mean_RT.append(sum(m3b_RT)/len(m3b_RT))
    m6_mean_RT.append(sum(m6_RT)/len(m6_RT))


iSubject = iBlock = iTrial = 0
m1_mean  = []
m2_mean  = []
m3_mean  = []
m4_mean  = []
for iSubject in range(len(mLine)):
    m1  = []
    m2 = []
    m3 = []
    m4  = []
    for iBlock in range(len(mLine[iSubject])):
        for iTrial, value in enumerate(mLine[iSubject][iBlock][0]):
            if value == 1:
                m1.append(ACC[iSubject][iBlock][0][iTrial])
            elif value == 2:
                m3.append(ACC[iSubject][iBlock][0][iTrial])
            elif value == 3:
                m4.append(ACC[iSubject][iBlock][0][iTrial])
            elif value == 4:
                m2.append(ACC[iSubject][iBlock][0][iTrial])
            else:
                print('Seek new employment because you cannot generate a working script')

    m1_mean.append(sum(m1)/len(m1))
    m2_mean.append(sum(m2)/len(m2))
    m3_mean.append(sum(m3)/len(m3))
    m4_mean.append(sum(m4)/len(m4))

iSubject = iBlock = iTrial = 0
m1_mean_RT  = []
m2_mean_RT  = []
m3_mean_RT  = []
m4_mean_RT  = []
for iSubject in range(len(mLine)):
    m1_RT  = []
    m2_RT = []
    m3_RT = []
    m4_RT  = []
    for iBlock in range(len(mLine[iSubject])):
        for iTrial, value in enumerate(mLine[iSubject][iBlock][0]):
            if value == 1:
                m1_RT.append(endTime[iSubject][iBlock][0][iTrial] - startTime[iSubject][iBlock][0][iTrial])
            elif value == 2:
                m3_RT.append(endTime[iSubject][iBlock][0][iTrial] - startTime[iSubject][iBlock][0][iTrial])
            elif value == 3:
                m4_RT.append(endTime[iSubject][iBlock][0][iTrial] - startTime[iSubject][iBlock][0][iTrial])
            elif value == 4:
                m2_RT.append(endTime[iSubject][iBlock][0][iTrial] - startTime[iSubject][iBlock][0][iTrial])
            else:
                print('Seek new employment because you cannot generate a working script')

    m1_mean_RT.append(sum(m1_RT)/len(m1_RT))
    m2_mean_RT.append(sum(m2_RT)/len(m2_RT))
    m3_mean_RT.append(sum(m3_RT)/len(m3_RT))
    m4_mean_RT.append(sum(m4_RT)/len(m4_RT))


iSubject = iBlock = 0
meanACC_Sub = []
for iSubject in range(len(ACC)):
    meanACC = []
    for iBlock in range(len(ACC[iSubject])):
        meanACC.append(sum(ACC[iSubject][iBlock][0])/len(ACC[iSubject][iBlock][0]))
    meanACC_Sub.append(sum(meanACC)/len(meanACC))
iSubject = 0
meanRT_Sub = []
for iSubject in range(len(endTime)):
    meanRT = []
    for iBlock in range(len(endTime[iSubject])):
        meanRT.append(sum(endTime[iSubject][iBlock][0] - startTime[iSubject][iBlock][0]))
    meanRT_Sub.append(sum(meanRT)/len(meanRT))

x = [i for i in subjectNumber]
xMorph = ['m0', 'm3w', 'm3b', 'm6']
xLine = ['1', '2', '3', '4']

def make_trace_bar(x, y, name):
    return go.Bar(
        x     = x,
        y     = y,            # take in the y-coords
        name  = name,      # label for hover
        xaxis = 'x1',
        yaxis = 'y1',
    )

# (1.1) Define a trace-generating function (returns a line object)
def make_trace_line(x, y, name, dash):
     if dash == 'y':
        return go.Scatter(
            x     = x,
            y     = y,            # take in the y-coords
            name  = name,      # label for hover
            xaxis = 'x1',                    # (!) both subplots on same x-axis
            yaxis = 'y1',
                line = dict(
                    width = 4,
                    color = 'black'
                )
        )
     else:
         return go.Scatter(
            x     = x,
            y     = y,            # take in the y-coords
            name  = name,      # label for hover
            xaxis = 'x1',                    # (!) both subplots on same x-axis
            yaxis = 'y1',
            mode = 'markers'
    )

#overall acc trace
traceAcc = make_trace_bar(x,meanACC_Sub,'Accuracy')
traceRT = make_trace_line(x, meanRT_Sub, 'RT', 'n')

#morphline specific trace
traceACC_line  = []
traceACC_line_RT = []
for itr in range(len(subjectNumber)):
    traceACC_line.append(make_trace_line(xLine, [m1_mean[itr],m2_mean[itr],m3_mean[itr], m4_mean[itr]], subjectNumber[itr], 'n'))
    traceACC_line_RT.append(make_trace_line(xLine, [m1_mean_RT[itr],m2_mean_RT[itr],m3_mean_RT[itr], m4_mean_RT[itr]], subjectNumber[itr], 'n'))

traceACC_line_O = make_trace_line(xLine, [sum(m1_mean)/len(m1_mean), sum(m2_mean)/len(m2_mean), sum(m3_mean)/len(m3_mean), sum(m4_mean)/len(m4_mean)], 'Overall', 'y')
traceACC_line_O_RT = make_trace_line(xLine, [sum(m1_mean_RT)/len(m1_mean_RT), sum(m2_mean_RT)/len(m2_mean_RT), sum(m3_mean_RT)/len(m3_mean_RT), sum(m4_mean_RT)/len(m4_mean_RT)], 'Overall', 'y')

#morphdistance trace
traceACC_morph = []
traceACC_morph_RT = []
for itr in range(len(subjectNumber)):
    traceACC_morph.append(make_trace_line(xMorph, [m0_mean[itr],m3w_mean[itr],m3b_mean[itr], m6_mean[itr]], subjectNumber[itr], 'n'))
    traceACC_morph_RT.append(make_trace_line(xMorph, [m0_mean_RT[itr],m3w_mean_RT[itr],m3b_mean_RT[itr], m6_mean_RT[itr]], subjectNumber[itr], 'n'))

traceACC_morph_O = make_trace_line(xMorph, [sum(m0_mean)/len(m0_mean), sum(m3w_mean)/len(m3w_mean), sum(m3b_mean)/len(m3b_mean), sum(m6_mean)/len(m6_mean)], 'Overall', 'y')
traceACC_morph_O_RT = make_trace_line(xMorph, [sum(m0_mean_RT)/len(m0_mean_RT), sum(m3w_mean_RT)/len(m3w_mean_RT), sum(m3b_mean_RT)/len(m3b_mean_RT), sum(m6_mean_RT)/len(m6_mean_RT)], 'Overall', 'y')

#MRI data for scatter plot
trace1 = make_trace_line(meanACC_Sub, ACC_mri2, sList_string[:], 'n')
trace2 = make_trace_line(meanACC_Sub[1], ACC_mri2[1], sList_string[1], 'n')

figOverall = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figLine    = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figLine_RT = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figMorph   = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figMorph_RT   = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
figMRIvEEG = tls.make_subplots(rows=1, cols=1, shared_xaxes=True, shared_yaxes=True)

figOverall['data']  = [traceAcc]
figLine['data']     = [traceACC_line[0], traceACC_line[1], traceACC_line[2], traceACC_line[3], traceACC_line[4], traceACC_line[5],
                       traceACC_line[6], traceACC_line[7], traceACC_line[8], traceACC_line[9],  traceACC_line[10], traceACC_line_O]
figLine_RT['data']     = [traceACC_line_RT[0], traceACC_line_RT[1], traceACC_line_RT[2], traceACC_line_RT[3], traceACC_line_RT[4],traceACC_line_RT[5],
                          traceACC_line_RT[6], traceACC_line_RT[7], traceACC_line_RT[8], traceACC_line_RT[9], traceACC_line_RT[10], traceACC_line_O_RT]
figMorph['data']    = [traceACC_morph[0], traceACC_morph[1], traceACC_morph[2], traceACC_morph[3], traceACC_morph[4], traceACC_morph[5],
                       traceACC_morph[6], traceACC_morph[7], traceACC_morph[8], traceACC_morph[9], traceACC_morph[10], traceACC_morph_O]
figMorph_RT['data']    = [traceACC_morph_RT[0], traceACC_morph_RT[1], traceACC_morph_RT[2], traceACC_morph_RT[3], traceACC_morph_RT[4], traceACC_morph_RT[5],
                          traceACC_morph_RT[6], traceACC_morph_RT[7], traceACC_morph_RT[8], traceACC_morph_RT[9], traceACC_morph_RT[10], traceACC_morph_O_RT]
figMRIvEEG['data'] = [trace1]

figOverall['layout'].update(barmode='group', bargroupgap=0, bargap=0.25, title = "Accuracy Overall EEG data", yaxis = dict(dtick = .1))
figLine['layout'].update(barmode='group', bargroupgap=0, bargap=0.25, title = "Accuracy Overall by Morph Line EEG data", yaxis = dict(dtick = .05))
figMorph['layout'].update(barmode='group', bargroupgap=0, bargap=0.25, title = "Accuracy Overall by Morph Distance EEG data", yaxis = dict(dtick = .05))
figLine_RT['layout'].update(barmode='group', bargroupgap=0, bargap=0.25, title = "RT Overall by Morph Line EEG data", yaxis = dict(dtick = .05))
figMorph_RT['layout'].update(barmode='group', bargroupgap=0, bargap=0.25, title = "RT Overall by Morph Distance EEG data", yaxis = dict(dtick = .05))
figMRIvEEG['layout'].update(barmode='group', bargroupgap=0, bargap=0.25, title = "Accuracy Overall EEG vs MRI", yaxis = dict(dtick = .05))

py.image.save_as(figOverall, fileDirectory + "Group_ACC_EEG.jpeg")
py.image.save_as(figMorph, fileDirectory + "Group_ACC_EEG_byMorph.jpeg")
py.image.save_as(figLine, fileDirectory + "Group_ACC_EEG_byLine.jpeg")
py.image.save_as(figMorph_RT, fileDirectory + "Group_RT_EEG_byMorph.jpeg")
py.image.save_as(figLine_RT, fileDirectory + "Group_RT_EEG_byLine.jpeg")
py.image.save_as(figMRIvEEG, fileDirectory + "Group_ACC_MRI_EEG.jpeg")

print('Done!')

