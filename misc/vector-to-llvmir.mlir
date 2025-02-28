// RUN: mlir-opt --split-input-file --pass-pipeline="builtin.module(func.func(convert-arith-to-llvm),convert-vector-to-llvm,convert-func-to-llvm)" %s \
// RUN:   | mlir-translate --mlir-to-llvmir | FileCheck %s

module {
  func.func @const() -> vector<17xi32> {
    %0 = arith.constant dense<-1> : vector<17xi32>
    func.return %0 : vector<17xi32>
  }

  func.func @nop(%arg0 : vector<17xi32>) -> () {
    func.return
  }

  func.func @main() -> () {
    %0 = func.call @const() : () -> vector<17xi32>
    %1 = "arith.addi"(%0, %0) : (vector<17xi32>, vector<17xi32>) -> vector<17xi32>
    func.call @nop(%1) : (vector<17xi32>) -> ()
    return
  }
}

// CHECK:    define <17 x i32> @const() {
// CHECK:      ret <17 x i32> splat (i32 -1)
// CHECK:    }
// CHECK:    define void @nop(<17 x i32> %0) {
// CHECK:      ret void
// CHECK:    }
// CHECK:    define void @main() {
// CHECK:      %1 = call <17 x i32> @const()
// CHECK:      %2 = add <17 x i32> %1, %1
// CHECK:      call void @nop(<17 x i32> %2)
// CHECK:      ret void
// CHECK:    }
