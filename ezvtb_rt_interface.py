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
        subprocess.run(['git', 'submodule','update', '--recursive', '--remote'], check=True, capture_output=True)
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



def get_core(
        #Device setting
        device_id:int = 0, 
        use_tensorrt:bool = True, 
        #THA3 model setting
        seperable_model:bool = True,
        model_half:bool = True,
        model_cache:bool = True,
        model_vram_cache:bool = False,
        model_cache_size:int = 1,
        #RIFE interpolation setting
        use_interpolation:bool = True,
        interpolation_scale:int = 2,
        interpolation_half:bool = True,
        #Cacher setting
        use_cacher:bool = True,
        cacher_on_database:bool = True,
        cacher_quality:int = 95,
        cacher_ram_size:int = 2,
        ):
    if use_tensorrt:
        try:
            from ezvtb_rt.trt_utils import cudaSetDevice,check_build_all_models
            cudaSetDevice(device_id)
            support_trt = check_build_all_models()
        except:
            support_trt = False
    if support_trt == False and use_tensorrt == True:
        print('TensorRT option selected but not supported')
        use_tensorrt = False
    if use_tensorrt:
        os.environ['CUDA_DEVICE'] = str(device_id)
        import pycuda.autoinit
        print(f'Using devcie {pycuda.autoinit.device.name()}')
    tha_model_path = os.path.join(project_path, 'tha3', 'seperable' if seperable_model else 'standard', )
    




import pycuda.autoinit
print( pycuda.autoinit.device.name())