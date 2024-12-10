import os 
import sys
import subprocess
import urllib.request
import shutil

dir_path = os.path.dirname(os.path.realpath(__file__))
ezvtb_path = os.path.join(dir_path, 'ezvtuber-rt')
ezvtb_main_path = os.path.join(dir_path, 'ezvtuber-rt-main')
if not os.path.exists(ezvtb_path) and not os.path.exists(ezvtb_main_path): #Check if rt not exist
    print('Trying to clone ezvtb_rt')
    try:
        subprocess.run(['git', 'submodule','init'], check=True, capture_output=True)
        subprocess.run(['git', 'submodule','update'], check=True, capture_output=True)
        subprocess.run(['git', 'checkout','main'], check=True, capture_output=True)
    except:
        print('Git submodule init update failed, try to download from github')
        zip_path = 'https://github.com/zpeng11/ezvtuber-rt/archive/refs/heads/main.zip'
        filehandle, _ = urllib.request.urlretrieve(zip_path)
        os.rename(filehandle, filehandle + '.zip')
        shutil.unpack_archive(filehandle + '.zip' , '.')
    print('Please go to download pretrained model to ezvtuber-rt or ezvtuber-rt-main data folder!')
    exit(1)

project_path = ''
if os.path.exists(ezvtb_path):
    project_path = ezvtb_path
else:
    project_path = ezvtb_main_path

if project_path not in sys.path:
    sys.path.append(project_path)

from ezvtb_rt.trt_utils import check_build_all_models

def get_rt_core():
    check_build_all_models()
get_rt_core()