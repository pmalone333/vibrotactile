import numpy as np
import scipy.io as sio
from matplotlib import pyplot as plt
import statistics as stat

# filename = input('Enter a filename: ')
# dprimeCalc = input('Do you want to calculate dprime (y/n): \n')
filename = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/04_MRI/03_RA/data_RAscan/915/2015-12-10-915_block1.run1.mat'
dprimeCalc = 'n'
data = sio.loadmat(filename, struct_as_record=True)

f1=27.0
f2=41.0
f3=62.0
f4=93.0

#pull relevant data from structures
responseStartTime = data['trialOutput']['responseStartTime']
responseFinishedTime = data['trialOutput']['responseFinishedTime']
RT = data['trialOutput']['RT']
sResp = data['trialOutput']['sResp']
correctResponse = data['trialOutput']['correctResponse']
# accuracy = data['trialOutput']['accuracy']
stimuli = data['trialOutput']['stimuli']
nTrials=data['exptdesign']['numTrialsPerSession'][0,0][0]
subjectName = data['exptdesign']['subjectName'][0,0][0]
subjectNumber = data['exptdesign']['number'][0,0][0]

if dprimeCalc == 'y':
    hit = generalMiss = false_alarm = correct_rejection = correctResponseDiff = correctResponseSame = miss = 0
    for i in range(sResp.size):
        for counter in range(sResp[0,i].size):
            if sResp[0,i][0,counter]==2 and correctResponse[0,i][0,counter]==2:
                hit += 1
                correctResponseDiff += 1
            elif sResp[0,i][0,counter]==1 and correctResponse[0,i][0,counter]==1:
                correct_rejection += 1
                correctResponseSame += 1
            elif sResp[0,i][0,counter]==2 and correctResponse[0,i][0,counter]==1:
                false_alarm += 1
            elif sResp[0,i][0,counter]==1 and correctResponse[0,i][0,counter]==2:
                miss += 1
            else:
                generalMiss += 1

    dprime = (sum(hit))/len(hit) - (sum(false_alarm))/len(false_alarm)/(stat.stdev(hit)-stat.stdev(false_alarm))

i=counter=0
accuracy = []
for i in range(sResp.size):
    for counter in range(sResp[0,i].size):
        if sResp[0,i][0,counter]==correctResponse[0,i][0,counter]:
            accuracy.append(1)
        else:
            accuracy.append(0)

i=counter=0
m0_accuracy =[]
m3b_accuracy =[]
m3w_accuracy =[]
m6_accuracy=[]
for counter in range(stimuli[0,0][1].size):
    if stimuli[0,0][0,counter] == stimuli[0,0][4,counter]:
        if accuracy[counter]==1:
            m0_accuracy.append(1)
        else:
            m0_accuracy.append(0)
    else:
        if accuracy[counter]==1:
            if round(stimuli[0,0][0,counter]) == f2 and round(stimuli[0,0][4,counter]) == f3:
                m3b_accuracy.append(1)
            elif round(stimuli[0,0][0,counter]) == f1 and round(stimuli[0,0][4,counter]) == f2:
                m3w_accuracy.append(1)
            elif round(stimuli[0,0][0,counter]) == f4 and round(stimuli[0,0][4,counter]) == f3:
                m3w_accuracy.append(1)
            elif round(stimuli[0,0][0,counter]) == f1 and round(stimuli[0,0][4,counter]) == f3:
                m6_accuracy.append(1)
            elif round(stimuli[0,0][0,counter]) == f4 and round(stimuli[0,0][4,counter]) == f2:
                m6_accuracy.append(1)
        else:
            if round(stimuli[0,0][0,counter]) == f2 and round(stimuli[0,0][4,counter]) == f3:
                m3b_accuracy.append(0)
            elif round(stimuli[0,0][0,counter]) == f1 and round(stimuli[0,0][4,counter]) == f2:
                m3w_accuracy.append(0)
            elif round(stimuli[0,0][0,counter]) == f4 and round(stimuli[0,0][4,counter]) == f3:
                m3w_accuracy.append(0)
            elif round(stimuli[0,0][0,counter]) == f1 and round(stimuli[0,0][4,counter]) == f3:
                m6_accuracy.append(0)
            elif round(stimuli[0,0][0,counter]) == f4 and round(stimuli[0,0][4,counter]) == f2:
                m6_accuracy.append(0)

n_groups = 4
accuracy_mean = ((sum(m0_accuracy)/len(m0_accuracy)), (sum(m3w_accuracy)/len(m3w_accuracy)), (sum(m3b_accuracy)/len(m3b_accuracy)), (sum(m6_accuracy)/len(m6_accuracy)))
SEM = (np.std(m0_accuracy), np.std(m3w_accuracy), np.std(m3b_accuracy), np.std(m6_accuracy))
fig = plt.subplot()
index = np.arange(n_groups)
bar_width = 0.35
opacity = 1

plt.bar(index, accuracy_mean, alpha=opacity, color='b')

plt.xlabel('Accuracy by Condition')
plt.ylabel('Accuracy')
plt.title(subjectNumber + ' RA Accuracy by Condition')
plt.xticks(index+(bar_width), ('M0', 'M3W', 'M3B', 'M6'))
plt.tight_layout()
plt.grid(b=None, which='major', axis='y')

saveName = '/Users/courtney/GoogleDrive/Riesenhuber/05_2015_scripts/Vibrotactile/04_MRI/03_RA/data_RAscan/' + subjectNumber +'/' + subjectName+'_RAaccuracy.jpg'

print('Saving under...'+ saveName)
plt.savefig(saveName)
print('done!')
plt.show()