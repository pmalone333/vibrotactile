import tkinter
from tkinter import filedialog
from tkinter import messagebox

from freqDiscrimAnalysis_Category import freqDiscrimAnalysis_Category
from CategoryTrainingFigure_Funnel import CategoryTrainingFigure_Funnel
from CategoryTesting import CategoryTesting

class GUI(tkinter.Frame):
	def __init__(self, master=None, debug = False, repoDir = ""):
		tkinter.Frame.__init__(self, master)
		self.debug = debug
		self.repoDir = repoDir		#location of the Vibrotactile git repository on the computer running this script
		self.grid()
		self.createWidgets()


	def createWidgets(self):
		self.options = [{"Name": "Category Testing", "SessionRequired": False, "Directory": self.repoDir + "Vibrotactile\\09_CategoryTesting\\data\\"},
					{"Name": "Category Training", "SessionRequired": True, "Directory": self.repoDir + "Vibrotactile\\01_CategoryTraining\\data\\"},
					{"Name": "Frequency Discrimination", "SessionRequired": False, "Directory": self.repoDir + "Vibrotactile\\06_frequencyDiscrimination\\data\\"}]
			#Name is the string that goes in the menu; SessionRequired is whether the Session field is enabled
		self.sessionType = tkinter.StringVar()							#variable to hold choice
		self.selectedOption = 1;										#index of default option: 1 == Category Training
		self.sessionType.set(self.options[self.selectedOption]["Name"])						#set default option in menu

		self.optionMenu = tkinter.OptionMenu(self, self.sessionType, *[option["Name"] for option in self.options], command = self.updateSessionField)
		self.optionMenu.grid(row = 0, columnspan = 2)					#drop-down list with script options

		self.chooseFileButton = tkinter.Button(self, text = "Choose File...", command = self.chooseFile)
		self.chooseFileButton.grid(row = 2, column = 0, padx = 2)		#open file choice dialog for data file

		self.chosenFile = tkinter.StringVar()
		self.chosenFileField = tkinter.Entry(self, textvariable = self.chosenFile, width = 40, justify = tkinter.RIGHT)
		self.chosenFileField.grid(row = 2, column = 1)					#shows which data file was selected

		self.sessionLabel = tkinter.Label(self, text = "Session:")
		self.sessionLabel.grid(row = 3, column = 0, padx = 2, sticky = tkinter.E)

		self.session = tkinter.StringVar()
		self.sessionField = tkinter.Entry(self, textvariable = self.session, width = 3)
		self.sessionField.grid(row = 3, column = 1, sticky = tkinter.W)	#field to enter the number of the session
		self.updateSessionField()

		self.runButton = tkinter.Button(self, text = "Create Figures", command = (lambda: self.runScript(self.sessionType.get(), self.chosenFile.get(), self.session.get())))
		self.runButton.grid(row = 5, columnspan = 2)					#runs the chosen script

		self.status = tkinter.StringVar()
		self.status.set("Ready.")
		self.statusLabel = tkinter.Label(self, textvariable = self.status)
		self.statusLabel.grid(row = 6, columnspan = 2)


	def chooseFile(self):												#file choice dialog
		filename = filedialog.askopenfilename(initialdir = self.options[self.selectedOption]["Directory"], filetypes = [("MATLAB Data Files", ".mat"), ("All Files", ".*")])
		self.chosenFile.set(filename)

		self.chosenFileField.focus()
		self.chosenFileField.icursor(tkinter.END)						#so that the filename is visible


	def updateSessionField(self, event = None):							#session field is enabled or not based on chosen script
		self.selectedOption = [option["Name"] for option in self.options].index(self.sessionType.get())
		if self.options[self.selectedOption]["SessionRequired"]:
			self.sessionField["state"] = tkinter.NORMAL
		else:
			self.sessionField["state"] = tkinter.DISABLED


	def runScript(self, sessionType, dataFilename, session):
		self.status.set("Generating figures...")
		self.statusLabel.update()

		if "\\" in dataFilename:										#if the file path uses backslashes
			filename = dataFilename.split("\\")[-1]						#the name after the last slash
		else:															#if the file path uses forward slashes
			filename = dataFilename.split("/")[-1]						#the name after the last slash, and before

		fileDirectory = dataFilename[:-1 * len(filename)]				#file directory is the path up to the name

		if not(self.debug):
			try:
				if sessionType == "Category Testing":
					CategoryTesting(fileDirectory, filename[:-4])							#remove ".mat" from filename
				elif sessionType == "Category Training":
					CategoryTrainingFigure_Funnel(fileDirectory, filename[:-4], session)	#remove ".mat" from filename
				elif sessionType == "Frequency Discrimination":
					freqDiscrimAnalysis_Category(fileDirectory, filename[:-4])				#remove ".mat" from filename
			except:
				self.status.set("Error: " + filename + " failed.")
			else:
				self.status.set("Done: " + filename)
		else:
			if sessionType == "Category Testing":
				CategoryTesting(fileDirectory, filename[:-4])							#remove ".mat" from filename
			elif sessionType == "Category Training":
				CategoryTrainingFigure_Funnel(fileDirectory, filename[:-4], session)	#remove ".mat" from filename
			elif sessionType == "Frequency Discrimination":
				freqDiscrimAnalysis_Category(fileDirectory, filename[:-4])				#remove ".mat" from filename

			self.status.set("Done: " + filename)