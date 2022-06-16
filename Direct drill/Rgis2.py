import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings("ignore")


THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'BIGHORN PEAK H 04BH.xlsx')

df = pd.read_excel(my_file)

md = df["MD"].tolist()
tvd = df["TVDCalc"].tolist()
inc = df["Inclination"].tolist()
# az = df["Azim. (o)"].tolist()
# betta = df["DLSCalc"].tolist()

 
# curv_start = [tvd[i+1] for i in range(1, len(md)) if md[i] - tvd[i] < 0.2]
# curv_end = [tvd[i] for i in range(2, len(tvd)) if tvd[i] - tvd[i-2] < 10 and tvd[i] - tvd[i-1] > 0]

# ind_s = tvd.index(curv_start[-1])       # Index_start
# ind_e = tvd.index(curv_end[0])          # Index_end

# print("The Kick off point parameters are: MD is {}, TVD is {}, Incl is {}, Azim is {}".format(md[ind_s], tvd[ind_s], inc[ind_s], az[ind_s]))
# print("The Kick out point parameters are: MD is {}, TVD is {}, Incl is {}, Azim is {}".format(md[ind_e-1], tvd[ind_e-1], inc[ind_e-1], az[ind_e-1]))

# inc_rad = [np.deg2rad(inc[i]) for i in range(len(inc))]
# az_rad = [np.deg2rad(az[i]) for i in range(len(az))]

# # Minimum Curvature Method
# betta = [2*np.arcsin(np.sqrt(np.sin((inc_rad[i+1]-inc_rad[i])/2)**2+np.sin(inc_rad[i])*np.sin(inc_rad[i+1])*np.sin((az_rad[i+1]-az_rad[i])/2)**2)) for i in range(len(md)-1)]

# RF = [(md[i+1]-md[i])/betta[i]*np.tan(betta[i]/2) for i in range(len(md)-1)]
# del_x = [RF[i]*(np.sin(inc_rad[i])*np.cos(az_rad[i])+np.sin(inc_rad[i+1])*np.cos(az_rad[i+1])) for i in range(len(md)-1)]
# del_y = [RF[i]*(np.sin(inc_rad[i])*np.sin(az_rad[i])+np.sin(inc_rad[i+1])*np.sin(az_rad[i+1])) for i in range(len(md)-1)]
del_x = df["NSCalc"].tolist()
del_y = df["EWCalc"].tolist()
del_z = df["VSCalc"].tolist()

# Data for three-dimensional line and points
x = del_x
y = del_y
z = [-x for x in tvd]
x.insert(0,0)
y.insert(0,0)
z.insert(0,0)

# Plotting trajectory
fig = plt.figure()
ax = plt.axes(projection='3d')
ax.plot3D(x, y, z, 'green')
ax.scatter3D(x, y, z, c=z, cmap='winter')
plt.show()

print("The North displacement is: {}".format(round(x[-1], 2)))
print("The East displacement is: {}".format(round(y[-1], 2)))
print("TVD is: {}".format(round(abs(z[-1]), 2)))