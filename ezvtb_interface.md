# Interface
## Basic
Use the get_core() function below to get a `core` object, 
you only need to interact with the `core` object with two methods:
`core.setImage()` and `core.inference()`. For example:

```
core = get_core() #create a core
core.setImage(img) #pass image to model
while True: #the eventloop
    ret = core.inference(pose_params) #go forward for models
    #do what ever you want with returned images
```

## Data interface
The core object is interacted through numpy interface
### Image data type
All images input& output using `np.uint8` datatype
### Image data layout
All images inputs&outputs are in `(Hight, Width, Channel)` data layout. For example, the input image that passed to `core.setImage()` must be in a shape of `(512, 512, 4)`
### Image channels
Inputs and output images are having alpha channel therefore 4 channels. The channel format must be BGRA.
### pose_params
Pose params are passed every time an inference going forward. It should be `np.float32` data in a shape of `(1, 45)` in a way works the same as Tha3 project.
### Output images
The returned object of `core.inference()` is a `List[np.ndarray]` object, which returns a list of one or multiple image results according to if interpolation is enabled, we will talk about what and how an interpolation happens soon. The output images in the list subjects to the above datatype&layout&channel constrains. 

The only thing you need to keep in mind is that, always consume(by transforming, or sending to other process, or do a copy to save) the result images before calling next `core.inference()`. The next return of inference will use those `np.ndarray`'s memory inplace.

## Concepts
The `core` object hides all details but still you need to know the following concepts to correctly configurate `get_core()` function.
There are four conponents in a core : `tha`, `cacher`, `rife`, and `sr`(undergoing integration).
`tha` component is mandatory, all other components are optional

### tha
`tha` component is where THA3 algorithm happens. It has following options.
1. `tha` component can use either *seperable* or *standard* convolution graph structure. This controls by `model_seperable` option in `get_core`, default to `True`.
2. By setting `model_half` to `True` to use half percision for `tha` component and vice versa. Default to `True`.
3. `model_cache` controls if `tha` model try to cache the intermediate results. Exchange RAM/VRAM space for time and GPU power. It is recommended and defaulted to `True`
4. Model caching intermediate result can happen on VRAM or RAM, controled by `model_vram_cache`. Default and recommended to `True`.
5. `model_cache_size` controls size of above cache in a unit of gigabytes, default to `1` as 1 gigabytes cache.

### cacher
In the implementation, `cacher` component is optionally appended to the end of `tha` component output to cache image results of `tha` output. It has following options.

1. `use_cacher` controls if cacher is enabled, default and recommended to `True`.
2. `cacher_on_database` controls if cacher is used on RAM or hard drive database. Default to `False` on RAM. 
3. Since we are using **turbojpeg** to compress and save images, we should sepecify the compression ratio of JPEG algorithm, which is `cacher_quality` param in integer from 0 to 100. Smaller ratio == smaller compressed size == more cached items == higher cache hit rates == lower GPU computation comsumption. And vice versa. From my observation, I can not see great difference when `cacher_quality >= 85`. And if `sr` component is enabled, `cacher_quality >= 70` still works good. When `cacher_quality == 100`, the core will give up **turbojpeg** and directly storing in non-compressed format. Default to `85`.
4. `cacher_ram_size` specifies cache size on ram in a unit of gigabytes. Default to `2`.
5. `cacher_db_path` to specify path to database file path if `cacher_on_database == True` .

### rife
In the core, we use RIFE algorithm to interpolate THA3 output. When this is enabled, the `core.inference()` will runs a bit slower and return multiple images at a time instead of just one. Please reference to above Interface section to understand how to handle outputs.
1. `use_interpolation` controls if you use `rife` component in core, default to `True`.
2. `interpolation_scale` is the scaling factor of `rife` interpolation. It can only be integer `2|3|4`. You will get same numbers of output images everything running `core.inference()`. For example, if `interpolation_scale==3` then `ret = core.inference()`, ret is a list of length 3, the first two images in the list are generated by `rife` and the last one is the orginal `tha` output. Default to `2`.
3. `interpolation_half` controls if using half percision `rife` model. Default to `True`


## Device setting
You can also specify some device setting in `get_core()` for multiple GPU and non-Nvidia GPU.
### device_id
`device_id` specifies device id integer, default to `0`.
### use_tensorrt
`use_tensorrt` specifies if TensorRT is used for inference. When `use_tensorrt == False`, DirectML will be used to support non-Nvidia GPUs. default to `True`.

## More detailed example
suppose we want to work on GPU1, use full percision seperable float, and half percison 4x interpolation, a 8Gb RAM cacher.
```
from ezvtb_interface import get_core
import cv2
import numpy as np
core = get_core(
        device_id = 1,
        model_seperable = True,
        model_half = True,
        interpolation_scale = 4,
        interpolation_half = True,
        cacher_ram_size = 8
        )
img = cv2.imread('img1.png', cv2.IMREAD_UNCHANGED) 
core.setImage(img)
while True: #Eventloop here
    pose_param = pipe.get(blocking=True)
    ret = core.inference(pose_param)
    for ret_img in ret:
        cv2.imwrite('result.png',ret_img) #imwrite just for example
```