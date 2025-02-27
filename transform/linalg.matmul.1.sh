###############################################################################

PIPELINE=""
PIPELINE+="transform-interpreter{entry-point=__transform_main},"
PIPELINE+="canonicalize"
PIPELINE="builtin.module("$PIPELINE")"
DIR=_demos/tmp
mkdir -p $DIR
args=(
  --pass-pipeline="$PIPELINE"
  --dump-pass-pipeline
  -o $DIR/mlir-opt.mlir
  transform/linalg.matmul.1.mlir
)
mlir-opt "${args[@]}"

###############################################################################
