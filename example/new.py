import pandas as pd
import pickle
import os
# import warnings
# warnings.filterwarnings("ignore")

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'survey_new_4694.pickle')
my_file1 = os.path.join(THIS_FOLDER, 'Directional Survey Data_6.15.2022.xlsx')

fr00 = open(my_file, 'rb')  
newww = pickle.load(fr00)  
fr00.close()

new = pd.read_excel(my_file1)
tvd = [-x for x in new["TVDCalc"].tolist()]
sortedwells = list(set(new["WELL NAME"]))
# sortedwells.pop(0)
sortedwells.sort()

x = [val["3D_tortuosity_index"] for val in newww.values()]
y = [x[i][z] for i in range(len(x)) for z in range(len(x[i]))]
new["3D_Tortuosity_Index"] = y

new.to_csv("Filename.csv")

