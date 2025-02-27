//

module {

  func.func @matmul_tensors(%lhs: tensor<8x16xi32>, %rhs: tensor<16x32xi32>, %acc: tensor<8x32xi32>) -> tensor<8x32xi32> {
    %result = linalg.matmul ins(%lhs, %rhs: tensor<8x16xi32>, tensor<16x32xi32>) outs(%acc: tensor<8x32xi32>) -> tensor<8x32xi32>
    return %result : tensor<8x32xi32>
  }

  module attributes {transform.with_named_sequence} {
    transform.named_sequence @to_tile_forall(%arg0: !transform.any_op {transform.readonly}) {
      %0 = transform.structured.match ops{["linalg.matmul"]} in %arg0 : (!transform.any_op) -> !transform.any_op
      %tiled_op, %forall_op = transform.structured.tile_using_forall %0 tile_sizes [1, 8, 1] : (!transform.any_op) -> (!transform.any_op, !transform.any_op)
      transform.yield
    }
  }
  module attributes {transform.with_named_sequence} {
    transform.named_sequence @to_tile(%arg0: !transform.any_op) {
      %0 = transform.structured.match ops{["linalg.matmul"]} in %arg0 : (!transform.any_op) -> !transform.any_op
      %tiled_linalg_op, %loops:3 = transform.structured.tile_using_for %0 tile_sizes [1, 8, 1] : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)
      transform.yield
    }
  }
  module attributes {transform.with_named_sequence} {
    transform.named_sequence @to_vectorize(%arg0: !transform.any_op) {
      %0 = transform.structured.match ops{["linalg.matmul"]} in %arg0 : (!transform.any_op) -> !transform.any_op
      %tiled_linalg_op, %loops:3 = transform.structured.tile_using_for %0 tile_sizes [1, 8, 1] : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)
      %1 = transform.get_parent_op %tiled_linalg_op {isolated_from_above} : (!transform.any_op) -> !transform.any_op
      %2 = transform.structured.vectorize_children_and_apply_patterns %1 : (!transform.any_op) -> !transform.any_op
      transform.yield
    }
  }
  module attributes {transform.with_named_sequence} {
    transform.named_sequence @__transform_main(%arg0: !transform.any_op {transform.consumed}) {
      %0 = transform.structured.match ops{["linalg.matmul"]} in %arg0 : (!transform.any_op) -> !transform.any_op
      %tiled_linalg_op, %loops:3 = transform.structured.tile_using_for %0 tile_sizes [1, 8, 1] : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)
      %1 = transform.get_parent_op %tiled_linalg_op {isolated_from_above} : (!transform.any_op) -> !transform.any_op
      %2 = transform.structured.vectorize_children_and_apply_patterns %1 : (!transform.any_op) -> !transform.any_op
      %3 = transform.bufferization.one_shot_bufferize layout{IdentityLayoutMap} %arg0 {allow_return_allocs = true, bufferize_function_boundaries = true} : (!transform.any_op) -> !transform.any_op
      %4 = transform.structured.match ops{["func.func"]} in %3 : (!transform.any_op) -> !transform.any_op
      transform.apply_patterns to %4 {
        transform.apply_patterns.vector.lower_contraction
        transform.apply_patterns.vector.lower_outerproduct
      } : !transform.any_op
      transform.apply_patterns to %4 {
        transform.apply_patterns.vector.transfer_to_scf full_unroll = true
      } : !transform.any_op
      transform.yield
    }
  }
}

