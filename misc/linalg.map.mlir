// RUN: mlir-opt --split-input-file --pass-pipeline="builtin.module(convert-linalg-to-loops,canonicalize)" %s

func.func @map(%arg0: memref<32x7xf32>, %arg1: memref<32x7xf32>, %arg2: memref<32x7xf32>) {
    linalg.map {arith.addf} ins(%arg0, %arg1: memref<32x7xf32>, memref<32x7xf32>) outs(%arg2: memref<32x7xf32>)
    return
}

// CHECK:    module {
// CHECK:      func.func @map(%arg0: memref<32x7xf32>, %arg1: memref<32x7xf32>, %arg2: memref<32x7xf32>) {
// CHECK:        %c0 = arith.constant 0 : index
// CHECK:        %c32 = arith.constant 32 : index
// CHECK:        %c1 = arith.constant 1 : index
// CHECK:        %c7 = arith.constant 7 : index
// CHECK:        scf.for %arg3 = %c0 to %c32 step %c1 {
// CHECK:          scf.for %arg4 = %c0 to %c7 step %c1 {
// CHECK:            %0 = memref.load %arg0[%arg3, %arg4] : memref<32x7xf32>
// CHECK:            %1 = memref.load %arg1[%arg3, %arg4] : memref<32x7xf32>
// CHECK:            %2 = arith.addf %0, %1 : f32
// CHECK:            memref.store %2, %arg2[%arg3, %arg4] : memref<32x7xf32>
// CHECK:          }
// CHECK:        }
// CHECK:        return
// CHECK:      }
// CHECK:    }
