//

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%arg1: !transform.any_op {transform.readonly}) {
    %0 = transform.structured.match ops{["linalg.matmul"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    // %1, %loops:3 = transform.structured.tile_using_for %0 tile_sizes [4, 4, 4] : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)
    %tiled_op, %forall_op = transform.structured.tile_using_forall %0 tile_sizes [4, 4, 4] : (!transform.any_op) -> (!transform.any_op, !transform.any_op)
    transform.yield
  }
}

func.func @const_16x32xi32() -> tensor<16x32xi32> {
  %0 = arith.constant dense<-42> : tensor<16x32xi32>
  func.return %0 : tensor<16x32xi32>
}

func.func @const_32x8xi32() -> tensor<32x8xi32> {
  %0 = arith.constant dense<-42> : tensor<32x8xi32>
  func.return %0 : tensor<32x8xi32>
}

func.func @const_16x8xi32() -> tensor<16x8xi32> {
  %0 = arith.constant dense<-42> : tensor<16x8xi32>
  func.return %0 : tensor<16x8xi32>
}

func.func @matmul() -> tensor<16x8xi32> {
  %lhs = func.call @const_16x32xi32() : () -> tensor<16x32xi32>
  %rhs = func.call @const_32x8xi32() : () -> tensor<32x8xi32>
  %acc = func.call @const_16x8xi32() : () -> tensor<16x8xi32>
  %result = linalg.matmul ins(%lhs, %rhs: tensor<16x32xi32>, tensor<32x8xi32>) outs(%acc: tensor<16x8xi32>) -> tensor<16x8xi32>
  return %result: tensor<16x8xi32>
}

// CHECK:    %3 = scf.for %arg0 = %c0 to %c16 step %c4 iter_args(%arg1 = %2) -> (tensor<16x8xi32>) {
// CHECK:      %4 = scf.for %arg2 = %c0 to %c8 step %c4 iter_args(%arg3 = %arg1) -> (tensor<16x8xi32>) {
// CHECK:        %5 = scf.for %arg4 = %c0 to %c32 step %c4 iter_args(%arg5 = %arg3) -> (tensor<16x8xi32>) {
