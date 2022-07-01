import pickle
import pandas as pd
import os

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'DATA.csv')

df = pd.read_excel(my_file)

def call(name):
    new = df[df["WELL NAME"] == name]
    dict1 = {"MD": new["MD"].tolist(), "TVD": new["TVDCalc"].tolist(), "Inclination": new["Inclination"].tolist(), "Azimuth" :new["Azimuth"].tolist()}
    return dict1

sortedwells = list(set(df["WELL NAME"]))
sortedwells.sort()
data = {well: call(well) for well in sortedwells}


def write_info_into_pickle(input_file, output_file):

    # save information into pickle
    with open(output_file, 'wb') as handle:
        pickle.dump(input_file, handle, protocol = pickle.HIGHEST_PROTOCOL)
        handle.close()

# writing data from different folders into one pickle file with multi-layer dict data structures
write_info_into_pickle(data, 'GOM_production_dict.pickle')

fr00 = open('survey_new.pickle','rb')  
all_prod_ref1 = pickle.load(fr00)  
fr00.close()
print(all_prod_ref1)