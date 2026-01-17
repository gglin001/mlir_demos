import cutlass
import cutlass.cute as cute

@cute.jit
def add(a, b, print_result: cutlass.Constexpr):
  if print_result:
      cute.printf("Result: %d\n", a + b)
  return a + b

# jit_executor = cute.compile(add, 1, 2, True)
jit_executor = cute.compile(add, 1, 2, False)

res = jit_executor(1, 2)
print(res)
