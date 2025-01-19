import numpy as np
import onnxruntime
import time
from onnxruntime.quantization import QuantFormat, QuantType, quantize_static

quantize_static