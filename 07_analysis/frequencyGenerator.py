import math as m

class FrequencyGenerator:
    def __init__(self):
        self.frequencyList = self.setFrequencyList()

    #allows specified increments
    def my_range(self, start, end, step):
        while start <= end:
            yield start
            start += step

    #generates a list of frequencies that we test
    def setFrequencyList(self):
        self.frequencyList = [i for i in self.my_range(0, 2.05, 0.1)]

        for index,obj in enumerate(self.frequencyList):
            obj += m.log2(25)
            self.frequencyList[index] = round(2**obj)
        return self.frequencyList