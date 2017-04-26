#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import statistics as stat
import plotly.tools as tls
from frequencyGenerator import FrequencyGenerator as FG
from figureFunctions import FrequencyFunctions as FF
import plotly.graph_objs as go



def freqDiscrimAnalysis_Category(fileDirectory, filename):
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
	#filename = ('20160606_1338-MR1036_block7')
	#fileDirectory = 'C:\\Users\\Jason\\Documents\\MaxLab\\Repos\\Vibrotactile\\06_frequencyDiscrimination\\data\\1036\\'


	#load matfile
	data = sio.loadmat(fileDirectory + filename, struct_as_record=True)

	#pull relevant data from structures
	RT = data['trialOutput']['RT']
	sResp = data['trialOutput']['sResp']
	correctResponse = data['trialOutput']['correctResponse']
	accuracy = data['trialOutput']['accuracy']
	stimuli = data['trialOutput']['stimuli']
	nTrials = data['exptdesign']['numTrialsPerSession'][0,0][0]
	nBlocks = data['exptdesign']['numBlocks'][0,0][0]
	subjectNumber = data['exptdesign']['number'][0,0][0]
	subjectName = data['exptdesign']['subjectName'][0,0][0]

	if int(data['exptdesign']['preOrPostTrain'][0,0][0]) == 1:
		session = "Pre"
	else:
		session = "post"

	#############################################################################
	#Calculations by Acc category type
	#############################################################################

	#calculate accuracy by frequency
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

	FL = [FL.frequencyList[0], FL.frequencyList[7], FL.frequencyList[13], FL.frequencyList[20]]

	iTrial = iBlock = 0
	for iBlock in range(sResp.size):
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
		for iTrial in range(sResp[0,iBlock].size):
			stim1 = int(round(stimuli[0,iBlock][0,iTrial]))
			stim2 = int(round(stimuli[0,iBlock][1,iTrial]))
			stim3 = int(round(stimuli[0,iBlock][4,iTrial]))
			stim4 = int(round(stimuli[0,iBlock][5,iTrial]))
			if stim1 == stim3:
				sameAcc.append(accuracy[0,iBlock][0,iTrial])
				sameRT.append(RT[0,iBlock][0,iTrial])
			elif ((stim1 == FL[0] or stim1 == FL[2]) and (stim3 == FL[2] or stim3 == FL[0])):
				m6_L_Acc.append(accuracy[0,iBlock][0,iTrial])
				m6_L_RT.append(RT[0,iBlock][0,iTrial])
			elif (stim1 == FL[3] or stim1 == FL[1]) and (stim3 == FL[1] or stim2 == FL[3]):
				m6_H_Acc.append(accuracy[0,iBlock][0,iTrial])
				m6_H_RT.append(RT[0,iBlock][0,iTrial])
			elif (stim1 == FL[0] or stim1 == FL[1]) and (stim3 == FL[1] or stim3 == FL[0]):
				m3wLAcc.append(accuracy[0,iBlock][0,iTrial])
				m3wLRT.append(RT[0,iBlock][0,iTrial])
			elif (stim1 == FL[3] or stim1 == FL[2]) and (stim3 == FL[2] or stim3 == FL[3]):
				m3wHAcc.append(accuracy[0,iBlock][0,iTrial])
				m3wHRT.append(RT[0,iBlock][0,iTrial])
			elif ((stim1 == FL[1]) and (stim3 == FL[2])) or (stim1 == FL[2] and (stim3 == FL[1])):
				m3bAcc.append(accuracy[0,iBlock][0,iTrial])
				m3bRT.append(RT[0,iBlock][0,iTrial])

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

	#############################################################################
	#Calculating mean acc and RT overall
	#############################################################################
	#calculate the mean overall accuracy by block
	O_accuracy = []
	iBlock = 0
	for iBlock in range(accuracy.size):
		O_accuracy.append(np.mean(accuracy[0,iBlock]))

	#calculate the mean RT overall by block
	O_reactionTime = []
	iBlock = 0
	for iBlock in range(RT.size):
		O_reactionTime.append(np.mean(RT[0,iBlock]))

	x = ["Different", "Same"]
	x2 = ["Same", "M3B", "M3WH", "M3WL", "M6H", "M6L"]

	#############################################################################
	#Generating figures
	#############################################################################

	#make trace containing acc by frequency for Same and different Condition\
	trace1 = make_trace_bar(x2, [stat.mean(b_sameAcc), stat.mean(b_m3bAcc), stat.mean(b_m3wHAcc), stat.mean(b_m3wLAcc), stat.mean(b_m6_H_Acc), stat.mean(b_m6_L_Acc)], "Acc")
	trace2 = make_trace_line(x2, [stat.mean(b_sameRT), stat.mean(b_m3bRT), stat.mean(b_m3wHRT), stat.mean(b_m3wLRT), stat.mean(b_m6_H_RT), stat.mean(b_m6_L_RT)], "RT")

	# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
	fig = tls.make_subplots( rows=1, cols=1, shared_xaxes=True,)

	#set figure layout to hold mutlitple bars
	fig['layout'].update( barmode='group', bargroupgap=0, bargap=0.25,
		title = subjectNumber + " Accuracy by Morph Distance conditions " + session)

	fig['data']  = [trace1, trace2]

	#bread crumbs to make sure entered the correct information
	print("Your graph will be saved in this directory: " + fileDirectory + "\n")
	print("Your graph will be saved under: " + filename + "\n")
	print("The session number you have indicated is: " + session + "\n")


	# save images as png in case prefer compared to html
	py.image.save_as(fig, fileDirectory + filename + "frequencyDiscrim_CategStimuli" + session + ".jpeg")
	#close all open files
	# f.close()

	print("Done!")


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