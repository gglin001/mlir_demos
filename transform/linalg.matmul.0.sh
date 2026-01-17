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

PIPELINE=""
PIPELINE+="transform-interpreter{entry-point=__transform_main},"
PIPELINE+="lower-affine,"
PIPELINE+="convert-scf-to-cf,"
PIPELINE+="func.func(convert-arith-to-llvm),"
PIPELINE+="convert-vector-to-llvm{vector-contract-lowering=matmul vector-transpose-lowering=flat},"
PIPELINE+="convert-to-llvm,"
PIPELINE+="canonicalize"
PIPELINE="builtin.module("$PIPELINE")"
DIR=_demos/tmp
mkdir -p $DIR
args=(
  --pass-pipeline="$PIPELINE"
  --dump-pass-pipeline
  -o $DIR/mlir-opt.mlir
  transform/linalg.matmul.0.mlir
)
mlir-opt "${args[@]}"

######

# TODO: add a pass
# rm transform-dialect manually
# get `main.mlir`
# or
# `xyz.mlir_erase_transform` from https://github.com/gglin001/xyz/tree/main/src/xyz/mlir_erase_transform

DIR=_demos/tmp
mkdir -p $DIR
args=(
  -o $DIR/main.mlir
  $DIR/mlir-opt.mlir
)
xyz.mlir_erase_transform "${args[@]}"

######

DIR=_demos/tmp
args=(
  --mlir-to-llvmir
  -o $DIR/main.ll
  $DIR/main.mlir
)
mlir-translate "${args[@]}"

###############################################################################

exit

DIR="_demos/tmp" && mkdir -p $DIR
args=(
  --mattr=+m
  --mattr=+zve64x
  -riscv-v-vector-bits-min=512
  #
  -target-abi=lp64
  -march=riscv64
  -mcpu=generic-rv64
  #
  -O0
  -o $DIR/main.s
  $DIR/main.ll
)
llc "${args[@]}"

###############################################################################
