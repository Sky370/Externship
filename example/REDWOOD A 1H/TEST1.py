import os
import pickle
import pandas as pd

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, '27515176.xlsx')

df = pd.read_excel(my_file)
date = pd.to_datetime(df['YYYY/MM/DD'].astype(str) + ' ' + df['HH:MM:SS'].astype(str))
dv = df.iloc[:, range(10)].set_index(date)
