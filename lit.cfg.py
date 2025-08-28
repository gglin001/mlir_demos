import lit.TestingConfig
import lit.formats
import os
import tempfile

# for type hint
config = config  # noqa: F821
config: lit.TestingConfig.TestingConfig

config.name = "mlir_demos"
config.test_format = lit.formats.ShTest(execute_external=True)
config.suffixes = set([".mlir"])

config.test_exec_root = os.path.join(tempfile.gettempdir(), "lit")
# config.test_exec_root = os.path.join("_demos", "lit") # debug
