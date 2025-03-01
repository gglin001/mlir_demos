################################################################################

export TRITON_HOME="$PWD/_demos"

rm -rf _demos/.triton/cache
rm -rf _demos/.triton/dump

################################################################################

DIR="_demos/tmp" && mkdir -p $DIR
PY="tt/compile.mlir.py"

# python $PY

MLIR_ENABLE_DUMP=1 \
  MLIR_ENABLE_DUMP_DIR="$DIR/pass_manager_output" \
  python $PY 2>&1 0>&1 | tee $DIR/terminal.log

################################################################################
