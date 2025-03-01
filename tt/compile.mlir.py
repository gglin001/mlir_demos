import tempfile

import triton
import triton.backends


# test/Triton/ops.mlir
kernel_ir = r"""
module {
tt.func @dot_ops_infer(%ptr: !tt.ptr<f16>, %v : !tt.ptr<f16>) {
  %v128x32 = tt.splat %v : !tt.ptr<f16> -> tensor<128x32x!tt.ptr<f16>>
  %v32x128 = tt.splat %v : !tt.ptr<f16> -> tensor<32x128x!tt.ptr<f16>>
  %a = tt.load %v128x32 : tensor<128x32x!tt.ptr<f16>>
  %b = tt.load %v32x128 : tensor<32x128x!tt.ptr<f16>>
  %c = arith.constant dense<0.00e+00> : tensor<128x128xf16>

  %r1 = tt.dot %a, %b, %c : tensor<128x32xf16> * tensor<32x128xf16> -> tensor<128x128xf16>

  %ptr128x128 = tt.splat %ptr : !tt.ptr<f16> -> tensor<128x128x!tt.ptr<f16>>
  tt.store %ptr128x128, %r1 : tensor<128x128x!tt.ptr<f16>>
  tt.return
}
}
"""

with tempfile.NamedTemporaryFile(
    mode="w",
    suffix=".ttir",
    dir="_demos/tmp",
    delete=False,
) as fp:
    fp.write(kernel_ir)
    fp.seek(0)

    target = triton.backends.compiler.GPUTarget("cuda", 86, 32)
    # target = triton.backends.compiler.GPUTarget("cuda", 90, 32)

    options = {"ptx_version": 84}
    kernel = triton.compile(fp.name, target=target, options=options)
