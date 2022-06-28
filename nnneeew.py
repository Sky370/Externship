import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings("ignore")


THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'Matlab.xlsx')

df = pd.read_excel(my_file)
rows = [df.columns[i] for i in range(len(df.columns))]
print(rows)
# l = [float(num) for num in rows]
# pets = [round(float(num)) for num in rows]