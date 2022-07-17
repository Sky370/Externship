import pandas as pd
import plotly as px
import os
# import warnings
# warnings.filterwarnings("ignore")

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'survey.xlsx')

new = pd.DataFrame(my_file)
fig = px.line_3d(new, x="NSCalc", y="EWCalc", z=tvd, color="WELL NAME", labels={
    "NSCalc":"North-South", 
    "EWCalc":"East-West", 
    "z":"TVD",
    "WELL NAME":"WELL NAMES"
    })

fig1 = px.line(new, x= "NSCalc", y="DLSCalc", color="WELL NAME", labels={
    "NSCalc":"North-South",
    "DLSCalc":"DLS"
})
fig.update_traces(line_width=2.5)

fig2 = px.line(new, x="TVDCalc", y="3D Tortuosity Index", color="WELL NAME")
fig3 = px.line(new, x="NSCalc", y=tvd, color="WELL NAME", labels={
    "NSCalc":"North-South",
    "y":"TVD"
})

fig.show()
fig1.show()
fig2.show()
fig3.show()