import pandas as pd
import numpy as np
import plotly.express as px
import os
# import warnings
# warnings.filterwarnings("ignore")

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'Directional Survey Data_6.15.2022.xlsx')

new = pd.read_excel(my_file)
tvd = new["TVDCalc"].tolist()

fig = px.line_3d(new, x="NSCalc", y="EWCalc", z=[-x for x in tvd], color="WELL NAME", labels={
    "NSCalc":"North-South", 
    "EWCalc":"East-West", 
    "z":"TVD",
    })

fig1 = px.line(new[new["WELL NAME"] == "BIGHORN PASS H06 BH"], x= "NSCalc", y="DLSCalc", labels={
    "NSCalc":"North-South",
    "DLSCalc":"DLS"
})
fig.update_traces(line_width=2.5)
fig.show()
fig1.show()