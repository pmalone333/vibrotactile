#packages to import
import numpy as np
import scipy.io as sio
import plotly.plotly as py
import plotly.graph_objs as go
import plotly.tools as tls
from frequencyFunction_specific import FrequencySpecific
from category import category
from PositionFunction_General import Position_general
tls.set_credentials_file(username='cs1471', api_key='9xknhmjhas')



def CategoryTesting(fileDirectory, filename):
	#Use when debugging or manually editing
	#filename      = ('20160512_1431-MR1009_block6')
	#fileDirectory = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/09_CategoryTesting/data/1009/'
	session       = 'Test'

	#load matfile
	data = sio.loadmat(fileDirectory + filename, struct_as_record=True)

	#pull relevant data from structures
	reactionTime    = data['trialOutput']['RT']
	sResp           = data['trialOutput']['sResp']
	correctResponse = data['trialOutput']['correctResponse']
	accuracy        = data['trialOutput']['accuracy']
	stimuli         = data['trialOutput']['stimuli']
	nTrials         = data['exptdesign']['numTrialsPerSession'][0,0][0]
	nBlocks         = data['exptdesign']['numSessions'][0,0][0]
	subjectName     = data['exptdesign']['subName'][0,0][0]

	#############################################################################
	#Calculations by Frequency Pair
	#############################################################################

	FS = FrequencySpecific(stimuli=stimuli)
	mF, countTotal = FS.frequencyPair_parse(accuracy)
	catA = FS.category_parse_test(accuracy)

	#############################################################################
	#Calculations by morph
	#############################################################################

	catObj = category(stimuli= stimuli)
	RT,ACC = catObj.wrapper(accuracy, reactionTime)
	pos_acc = catObj.parseData_freq_block(accuracy, stimuli)

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
	for iBlock in range(reactionTime.size):
		O_reactionTime.append(np.mean(reactionTime[0,iBlock]))

	#x-axis label
	x = []
	i=0
	for i in range(5):
				x.append("Block: " + str(i+1)),

	#############################################################################
	#Generating figures
	#############################################################################


	#make trace containing each frequency pair
	x2 = ['[25,100]', '[27,91]', '[29,91]', '[31,83]', '[33,77]', '[36,71]', '[38,67]', '[40,62.5]',
		  '[62.5, 40]', '[67, 38]', '[71, 36]','[77, 33]', '[83, 31]', '[91, 29]', '[91, 27]','[100, 25]']
	x3 = ['100%', '90%', '80%', '70%', '65%', '60%', '40%', '35%', '30%', '20%', '10%', '0%']
	x4 = ['[25,100]', '[29,91]', '[33,77]', '[38,67]', '[40,62.5]',
		  '[62.5, 40]', '[67, 38]', '[77, 33]', '[91, 29]', '[100, 25]']

	trace_PG_ACC_1  = make_trace_bar(x4, pos_acc[0:11], 'pos1')
	trace_PG_ACC_7  = make_trace_bar(x4, pos_acc[12:23], 'pos7')
	trace_PG_ACC_8  = make_trace_bar(x4, pos_acc[24:35], 'pos8')

	trace_ACC_FP = make_trace_bar(x2, mF, '')

	# make categorization curve
	traceCatCurve = []
	for index, obj in enumerate(catA):
		traceCatCurve.append(make_trace_line(x3, obj, '', 'n'))

	# Generate Figure object with 2 axes on 2 rows, print axis grid to stdout
	fig_FP       = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)
	fig_CatCurve = tls.make_subplots(rows=1, cols=1)
	fig_pos      = tls.make_subplots(rows=1, cols=1, shared_xaxes=True)

	#set figure layout to hold mutlitple bars
	xZip = x2[:len(x2)]
	yZip = countTotal

	fig_FP['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
		title = subjectName + " Accuracy By Frequency Pair, Session " + session,  yaxis = dict(dtick = .1),
		annotations = [dict(x = xZip[i], y = mF[i], showarrow=False, text=yZip[i], xanchor='center', yanchor='bottom', ) for i in range(len(xZip))])

	fig_CatCurve['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
		title = subjectName + " Categorization Curve " + session, xaxis = dict(autorange = 'reversed', dtick = 5, range=[0,100], showgrid=True), yaxis = dict(range=[0,100], dtick = 5))

	fig_pos['layout'].update(barmode='group', bargroupgap=0, bargap=0.25,
		title = subjectName + " Pos Accuracy RA stimuli " + session, yaxis = dict(dtick = .1))

	colorRA = ['black', 'blue', 'black', 'black', 'black', 'black', 'black' ,'blue',
			   'blue', 'black', 'black', 'black', 'black', 'black' ,'blue', 'black']

	fig_FP['data'] = [go.Bar(x=x2, y=mF, marker = dict(color = colorRA))]
	fig_CatCurve['data'] = [go.Scatter(x = x3, y=catA, name = 'SubjectData'), go.Scatter(x= [50,50], y = [0,100], name = 'Category Boundary', line = dict(color='red'))]
	fig_pos['data'] = [trace_PG_ACC_1, trace_PG_ACC_7, trace_PG_ACC_8]

	#bread crumbs to make sure entered the correct information
	print("Your graph will be saved in this directory: " + fileDirectory + "\n")
	print("Your graph will be saved under: " + filename + "\n")
	print("The session number you have indicated is: " + session + "\n")

	#save images as png in case prefer compared to html
	py.image.save_as(fig_FP, fileDirectory + filename + "_FP_AccSession" + session + ".jpeg")
	py.image.save_as(fig_CatCurve, fileDirectory + filename + "_CatCurve_Session" + session + ".jpeg")
	py.image.save_as(fig_pos, fileDirectory + filename + "_PosRA_ACC_Session" + session + ".jpeg")

	print("Done!")


# (1.1) Define a trace-generating function (returns a Bar object)
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