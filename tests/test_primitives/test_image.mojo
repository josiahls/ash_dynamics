from testing.suite import TestSuite
from testing.testing import assert_equal
from ash_dynamics.primitives._clib import C_Union, TrivialOptionalField, Debug
from sys import size_of
from ash_dynamics.primitives.image import Image
import os

# import numojo as nm
# from numojo.prelude import *


def test_image():
    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    var root_path = os.path.join(
        test_data_root, "test_data/testsrc_128x128.png"
    )
    var image = Image.load(root_path)

    # for i in range(10):
    #     print(image._data[][Int(i)])
    # _ = image._data
    _ = image

    # var array = NDArray[i8](
    #     shape=(image.height, image.width, 3),
    #     strides=(1,1,1),
    #     offset=0,
    #     buffer=image._data
    # )


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
