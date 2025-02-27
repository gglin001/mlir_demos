###############################################################################

PIPELINE=""
PIPELINE+="transform-interpreter{entry-point=to_tile_forall},"
PIPELINE+="canonicalize"
PIPELINE="builtin.module("$PIPELINE")"
DIR=_demos/tmp
mkdir -p $DIR
args=(
  --pass-pipeline="$PIPELINE"
  --dump-pass-pipeline
  -o $DIR/mlir-opt.to_tile_forall.mlir
  transform/linalg.matmul.0.mlir
)
mlir-opt "${args[@]}"

###############################################################################

PIPELINE=""
PIPELINE+="transform-interpreter{entry-point=to_tile},"
PIPELINE+="canonicalize"
PIPELINE="builtin.module("$PIPELINE")"
DIR=_demos/tmp
mkdir -p $DIR
args=(
  --pass-pipeline="$PIPELINE"
  --dump-pass-pipeline
  -o $DIR/mlir-opt.to_tile.mlir
  transform/linalg.matmul.0.mlir
)
mlir-opt "${args[@]}"

######

PIPELINE=""
PIPELINE+="transform-interpreter{entry-point=to_vectorize},"
PIPELINE+="canonicalize"
PIPELINE="builtin.module("$PIPELINE")"
DIR=_demos/tmp
mkdir -p $DIR
args=(
  --pass-pipeline="$PIPELINE"
  --dump-pass-pipeline
  -o $DIR/mlir-opt.to_vectorize.mlir
  transform/linalg.matmul.0.mlir
)
mlir-opt "${args[@]}"

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
  -o $DIR/mlir-opt.to_scf.mlir
  transform/linalg.matmul.0.mlir
)
mlir-opt "${args[@]}"

###############################################################################
