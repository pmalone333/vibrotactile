print("Loading...")

from GUI import GUI



DEBUG_MODE = True		#break and dump on exceptions if True, recover if False

app = GUI(debug = DEBUG_MODE, repoDir = "C:\\Users\\Jason\\Documents\\MaxLab\\Repos\\")
app.master.title('Vibrotactile Data Analysis')
app.mainloop()