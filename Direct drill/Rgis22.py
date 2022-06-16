import pandas as pd
import numpy as np
# import plotly.graph_objects as go
import plotly.colors as col
import plotly.express as px
import os
# import warnings
# warnings.filterwarnings("ignore")

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'Directional Survey Data.xlsx')

new = pd.read_excel(my_file)

# new = df[df["WELL NAME"] == "FAT TIRE A 1H"]
md = new["MD"].tolist()
tvd = new["TVDCalc"].tolist()
inc = new["Inclination"].tolist()
x = new["NSCalc"].tolist()
y = new["EWCalc"].tolist()
z = [-x for x in tvd]
# data = {'X values': x, 'Y values': y, 'Z values': z}

fig = px.line_3d(new, x="NSCalc", y="EWCalc", z=z, color="WELL NAME", labels="Mark")
# fig.update_traces(line_color='salmon', line_width=4)

fig.show()

# fig = go.Figure(data=go.Scatter3d(ff
#     x=x, y=y, z=z,
#     marker=dict(
#         size=4,
#         color=z,
#         colorscale='Viridis',
#     ),
#     line=dict(
#         color='darkblue',
#         width=2
#     )
# ))

# fig.show()