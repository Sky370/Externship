import pickle
import pandas as pd
import os
import plotly.express as px
from plotly.subplots import make_subplots
import plotly.graph_objects as go
from quadSmoothing import *


THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'survey.xlsx')
my_file1 = os.path.join(THIS_FOLDER, 'df_ts.pickle')

df_traj = pd.read_excel(my_file)
df_traj = df_traj.sort_values(by=['MD'])

md = df_traj['MD'].tolist()
tvd = df_traj['TVDCalc'].tolist()
inc = df_traj['Inclination'].tolist()
del_x = df_traj['NSCalc'].tolist()
del_y = df_traj['EWCalc'].tolist()

fig = px.line_3d(df_traj, x='NSCalc', y='EWCalc', z='TVDCalc',title='BIGHORN PEAK H04 BH - 3D Trajectory')
fig.update_scenes(zaxis_autorange="reversed")
fig.show()

#loads the pickle file with the GOM production data 
fr00 = open(my_file1,'rb')  
df_ts = pickle.load(fr00)  
fr00.close()

time = df_ts.index
trq = df_ts['Rotary Torque']
hkld = df_ts['Hook Load']
wob = df_ts['Weight on Bit']
md = df_ts['Hole Depth']
mbp = df_ts['Bit Depth']
diff = df_ts['Bit Depth'] - df_ts['Hole Depth']
rpm = df_ts['Rotary RPM']
spp = df_ts['Standpipe Pressure']

fig = make_subplots(rows=4, cols=2, subplot_titles=('Rotary Torque', 'Hook Load', 'Rotary RPM', 'Bit Depth', 
                                                    'Weight on Bit', 'Standpipe Pressure', 'Hole Depth', 'Relative Depth'))

fig.append_trace(go.Scatter(
    x=time,
    y=trq,
), row=1, col=1)

fig.append_trace(go.Scatter(
    x=time,
    y=rpm,
), row=2, col=1)

fig.append_trace(go.Scatter(
    x=time,
    y=wob
), row=3, col=1)

fig.append_trace(go.Scatter(
    x=time,
    y=md,
), row=4, col=1)

fig.append_trace(go.Scatter(
    x=time,
    y=hkld,
), row=1, col=2)

fig.append_trace(go.Scatter(
    x=time,
    y=mbp,
), row=2, col=2)

fig.append_trace(go.Scatter(
    x=time,
    y=spp
), row=3, col=2)

fig.append_trace(go.Scatter(
    x=time,
    y=diff,
), row=4, col=2)

fig.update_layout(height=600, width=600, title_text="Stacked Subplots")
fig.update_layout(showlegend=False)
fig.show()

df_1 = df_ts[(df_ts['Weight on Bit']==0) & ((df_ts['Hole Depth'] - df_ts['Bit Depth'])>=10)
             & ((df_ts['Hole Depth'] - df_ts['Bit Depth'])<=100) & (df_ts['Hole Depth']<3050) & (df_ts['Hole Depth']>3024)
            & (df_ts.index <= pd.to_datetime('2021-10-08 01:00:00'))]

df_1['HKLA'] = despike_log(np.array(df_1['Hook Load']), 2, 0)

time = df_1.index
hkld = df_1['HKLA']
md = df_1['Hole Depth']
mpb = df_1['Bit Depth']
t = time[5:35]
hkld_predicted = [98560]*len(t)


# Create traces
fig = make_subplots(specs=[[{"secondary_y": True}]])
fig.add_trace(go.Scatter(x=time, y=hkld,
                    mode='lines',
                    name='hkld'))
fig.add_trace(go.Scatter(x=t, y=hkld_predicted,
                    mode='markers',
                    name='hkld_predicted'))
fig.add_trace(go.Scatter(x=time, y=md,
                    mode='lines',
                    name='md'), secondary_y=True)
fig.add_trace(go.Scatter(x=time, y=mpb,
                    mode='lines', name='mpb'), secondary_y=True)
fig.update_yaxes(range=[50000, 150000], secondary_y=False)
fig.show()

df_2 = df_ts[(df_ts['Weight on Bit']==0) & ((df_ts['Hole Depth'] - df_ts['Bit Depth'])>=10)
             & ((df_ts['Hole Depth'] - df_ts['Bit Depth'])<=100) & (df_ts['Hole Depth']<9791) & (df_ts['Hole Depth']>9311)
            & (df_ts.index <= pd.to_datetime('2021-10-15 16:00:00'))]

df_2['HKLA'] = despike_log(np.array(df_2['Hook Load']), 2, 0)

time = df_2.index
hkld = df_2['HKLA']
md = df_2['Hole Depth']
mpb = df_2['Bit Depth']
t = time[-500:]
hkld_predicted = [217500]*len(t)


# Create traces
fig = make_subplots(specs=[[{"secondary_y": True}]])
fig.add_trace(go.Scatter(x=time, y=hkld,
                    mode='lines',
                    name='hkld'))
fig.add_trace(go.Scatter(x=t, y=hkld_predicted,
                    mode='markers',
                    name='hkld_predicted'))
fig.add_trace(go.Scatter(x=time, y=md,
                    mode='lines',
                    name='md'), secondary_y=True)
fig.add_trace(go.Scatter(x=time, y=mpb,
                    mode='lines', name='mpb'), secondary_y=True)
fig.update_yaxes(range=[50000, 300000], secondary_y=False)
fig.show()

df_3 = df_ts[(df_ts['Weight on Bit']==0) & ((df_ts['Hole Depth'] - df_ts['Bit Depth'])>=10)
             & ((df_ts['Hole Depth'] - df_ts['Bit Depth'])<=100) & (df_ts['Hole Depth']<16890) & (df_ts['Hole Depth']>9790)
            & (df_ts.index >= pd.to_datetime('2021-11-02 17:00:00'))]

df_3['HKLA'] = despike_log(np.array(df_3['Hook Load']), 2, 0)

time = df_3.index
hkld = df_3['HKLA']
md = df_3['Hole Depth']
mpb = df_3['Bit Depth']
t = time[-500:]
hkld_predicted = [274200]*len(t)


# Create traces
fig = make_subplots(specs=[[{"secondary_y": True}]])
fig.add_trace(go.Scatter(x=time, y=hkld,
                    mode='lines',
                    name='hkld'))
fig.add_trace(go.Scatter(x=t, y=hkld_predicted,
                    mode='markers',
                    name='hkld_predicted'))
fig.add_trace(go.Scatter(x=time, y=md,
                    mode='lines',
                    name='md'), secondary_y=True)
fig.add_trace(go.Scatter(x=time, y=mpb,
                    mode='lines', name='mpb'), secondary_y=True)
fig.update_yaxes(range=[50000, 500000], secondary_y=False)
fig.show()