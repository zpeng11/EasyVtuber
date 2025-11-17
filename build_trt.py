from ezvtb_rt import init_model_path
from ezvtb_rt.trt_utils import check_build_all_models
import os

init_model_path(os.path.join(os.path.dirname(__file__), 'data', 'models'))

check_build_all_models()