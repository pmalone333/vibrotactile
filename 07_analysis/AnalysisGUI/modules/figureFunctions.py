import plotly.graph_objs as go

class FrequencyFunctions:
    def __init__(self):
        self.x = 0
        self.y = 0
        self.name = ""

    # (1.1) Define a trace-generating function (returns a Bar object)
    def make_trace_bar(self, x, y, name):
        return go.Bar(
            x     = x,
            y     = y,            # take in the y-coords
            name  = name,      # label for hover
            xaxis = 'x1',                    # (!) both subplots on same x-axis
            yaxis = 'y1'
        )

    # (1.1) Define a trace-generating function (returns a line object)
    def make_trace_line(self, x, y, name):
        return go.Scatter(
            x     = x,
            y     = y,            # take in the y-coords
            name  = name,      # label for hover
            xaxis = 'x1',                    # (!) both subplots on same x-axis
            yaxis = 'y1'
        )
