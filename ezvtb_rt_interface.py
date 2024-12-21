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

if not os.path.exists(os.path.join(project_path, 'data', 'tha3')):
    from ezvtb_rt.init_utils import check_exist_all_models
    print('Checking and downloading pretrained models')
    check_exist_all_models()


def get_core(
        #Device setting
        device_id:int = 0, 
        use_tensorrt:bool = True, 
        #THA3 model setting
        model_seperable:bool = True,
        model_half:bool = True, #If using directml+half, there is small numerical error on Nvidia, and huge numerical error on AMD
        model_cache:bool = True,#Only works for tensorrt
        model_vram_cache:bool = True, #Only works for tensorrt
        model_cache_size:int = 1, #unit of GigaBytes, only works for tensorrt
        #RIFE interpolation setting
        use_interpolation:bool = True,
        interpolation_scale:int = 2,
        interpolation_half:bool = True, #If using directml+half, there is small numerical error on Nvidia, and huge numerical error on AMD
        #Cacher setting
        use_cacher:bool = True,
        cacher_on_database:bool = False,
        cacher_quality:int = 85,
        cacher_ram_size:int = 2,#unit of GigaBytes
        cacher_db_path:str = './cacher.sqlite' #Ensure the db works on Solid State Drive, HHD's lag does not meet requirement
        ):
    support_trt = False
    if use_tensorrt: #Verify tensorrt
        print('Verifying TensorRT')
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

    tha_model_dir = os.path.join(project_path,'data', 'tha3',
                                 'seperable' if model_seperable else 'standard', 
                                 'fp16' if model_half else 'fp32')
    rife_model_path = ''
    if use_interpolation:
        rife_model_path = os.path.join(project_path,'data', 'rife_512',
                                       f'x{interpolation_scale}', 'fp16' if interpolation_half else 'fp32')
    print(f'THA3 Path:{tha_model_dir}')
    print(f'RIFE Path:{rife_model_path}')
    cacher = None
    if use_cacher: #Cacher runs on cpu therefore platform independant
        from ezvtb_rt.cache import RAMCacher, DBCacherMP
        if cacher_on_database:
            cacher = DBCacherMP(max_size = cacher_ram_size, db_dir=cacher_db_path, cache_quality = cacher_quality, image_size = 512)
        else:
            cacher = RAMCacher(max_size = cacher_ram_size, cache_quality = cacher_quality, image_size=512)
    
    core = None
    if use_tensorrt:
        tha = None
        if not model_cache:
            from ezvtb_rt.tha import THACoreSimple
            tha = THACoreSimple(tha_model_dir)
        else:
            if model_vram_cache:
                from ezvtb_rt.tha import THACoreCachedVRAM
                tha = THACoreCachedVRAM(tha_model_dir, float(model_cache_size))
            else:
                from ezvtb_rt.tha import THACoreCachedRAM
                tha = THACoreCachedRAM(tha_model_dir, float(model_cache_size))
        rife = None
        if use_interpolation:
            from ezvtb_rt.rife import RIFECoreLinked
            assert(os.path.isfile(rife_model_path+'.trt'))
            rife = RIFECoreLinked(rife_model_path, tha)
        from ezvtb_rt.core import CoreCached
        core = CoreCached(tha, cacher, rife)
    else: #Use directml
        from ezvtb_rt.core_ort import CoreORTCached
        core = CoreORTCached(tha_model_dir, rife_model_path if len(rife_model_path) > 0 else None, cacher=cacher, device_id=device_id)

    return core
    