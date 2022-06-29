import pandas as pd
import plotly.express as px
import os
import warnings
warnings.filterwarnings("ignore")


THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'Matlab.xlsx')

df = pd.read_excel(my_file)
fig = px.scatter(df, x="Torque", y="TVDCalc", color="Color", labels={
    "TVDCalc":"MD"
})
fig.update_yaxes(autorange="reversed")
fig.show()