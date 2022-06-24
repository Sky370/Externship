import pandas as pd
import pickle
import plotly.express as px
import os
# import warnings
# warnings.filterwarnings("ignore")

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'Directional Survey Data_6.15.2022.xlsx')

new = pd.read_excel(my_file)
tvd = new["TVDCalc"].tolist()
sortedwells = list(set(new["WELL NAME"]))
sortedwells.sort()

for i in range(len(sortedwells)):
    df = new[new["WELL NAME"] == sortedwells[i]]
    Md = df["MD"].to_list()
    TVD = df["TVDCalc"].to_list()
    INC = df["Inclination"].to_list()
    index = [i-1 for i in range(1, len(TVD)) if TVD[i] - TVD[i-1] < 10 and INC[i] > 80]
    LL = Md[-1] - Md[index[0]]
    print("Well name: {}, MD: {}, TVD: {}, Lateral Length: {}".format(sortedwells[i], Md[-1], max(TVD), LL))

fig = px.line_3d(new, x="NSCalc", y="EWCalc", z=[-x for x in tvd], color="WELL NAME", labels={
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

fig.show()
fig1.show()
fig2.show()