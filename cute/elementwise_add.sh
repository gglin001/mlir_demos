# media/docs/pythonDSL/cute_dsl_general/debugging.rst
# python/CuTeDSL/base_dsl/env_manager.py

export CUTE_DSL_LOG_TO_CONSOLE=1
export CUTE_DSL_LOG_TO_FILE=cute_dsl.log
export CUTE_DSL_LOG_LEVEL=10
export CUTE_DSL_PRINT_IR=1
export CUTE_DSL_KEEP_IR=1

pushd cute
python elementwise_add.py 2>&1 | tee elementwise_add.sh.log
popd
