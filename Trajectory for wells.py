import pandas as pd
import plotly.express as px
import os
import warnings
warnings.filterwarnings("ignore")

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'Directional Survey Data_6.15.2022.xlsx')

new = pd.read_excel(my_file)

md = new["MD"].tolist()
well_names = new["WELL NAME"].tolist()
tvd = new["TVDCalc"].tolist()
inc = new["Inclination"].tolist()
az = new["Azimuth"].tolist()
x = new["NSCalc"].tolist()
y = new["EWCalc"].tolist()
z = [-x for x in tvd]
# data = {'X values': x, 'Y values': y, 'Z values': z}

# fig = px.line_3d(new, x="NSCalc", y="EWCalc", z=z, color="WELL NAME", labels="Mark")
# fig.update_traces(line_color='salmon', line_width=4)

# fig.show()