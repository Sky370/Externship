import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings("ignore")


THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'Directional Survey Data_6.15.2022.xlsx')

df = pd.read_excel(my_file)

print(df)
def call(name):
    new = df[df["WELL NAME"] == name]
    md = new["MD"].tolist()
    tvd = new["TVDCalc"].tolist()
    inc = new["Inclination"].tolist()
    del_x = new["NSCalc"].tolist()
    del_y = new["EWCalc"].tolist()

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
    return

call("DIETZ OL UNIT 3H")
