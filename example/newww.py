import pandas as pd
import scipy.io as sio
import os
# import warnings
# warnings.filterwarnings("ignore")

THIS_FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file = os.path.join(THIS_FOLDER, 'survey.xlsx')


FOLDER = os.path.dirname(os.path.abspath(__file__))
my_file1 = os.path.join(FOLDER, '2 - Torque and Drag and MOP')

# data_dir = join(dirname(sio.__file__), '2 - Torque and Drag and MOP')
mat_fname = os.path.join(my_file1, 'Hookload_pass.mat')

mat_contents = sio.loadmat(mat_fname)
hkld = [y[0] for y in mat_contents['hookLoad']]


new = pd.read_excel(my_file)
new["Hookload"] = hkld
new.to_csv('filename.csv')
