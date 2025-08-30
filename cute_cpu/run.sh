###############################################################################

script_path="$0"
script_path_no_ext="${script_path%.*}"
script_dir=$(dirname "$script_path")
script_filename=$(basename "$script_path")
script_name_no_ext="${script_filename%.*}"

###############################################################################

# media/docs/pythonDSL/cute_dsl_general/debugging.rst
# python/CuTeDSL/base_dsl/env_manager.py
# CUTE_DSL

export CUTE_DSL_LOG_TO_CONSOLE=1
# export CUTE_DSL_LOG_TO_FILE=cute_dsl.log
export CUTE_DSL_LOG_TO_FILE=1
export CUTE_DSL_LOG_LEVEL=10
export CUTE_DSL_PRINT_IR=1
export CUTE_DSL_KEEP_IR=1
export CUTE_DSL_PRINT_AFTER_PREPROCESSOR=1

export CUTE_DSL_ARCH=sm_86
# export CUTE_DSL_ARCH=sm_90
# export CUTE_DSL_ARCH=sm_100

# TODO: needs real cuda runtime
# export CUTE_DSL_DRYRUN=1

# nvidia/cuda:13.0.0-cudnn-devel-ubuntu24.04
export CUDA_TOOLKIT_PATH="/usr/local/cuda"
export LD_LIBRARY_PATH="/usr/local/cuda/compat:$LD_LIBRARY_PATH"

# for custom patch
# export PYTHONPATH="/repos/cutlass/python/CuTeDSL:$PYTHONPATH"

pushd $script_dir
python elementwise_add.py 2>&1 | tee elementwise_add.py.log
# python add.py 2>&1 | tee add.py.log
popd
