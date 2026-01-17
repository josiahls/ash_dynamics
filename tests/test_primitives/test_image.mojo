from testing.suite import TestSuite
from testing.testing import assert_equal
from ash_dynamics.primitives._clib import C_Union, TrivialOptionalField, Debug
from sys import size_of
from ash_dynamics.primitives.image import Image
import os

import numojo as nm
from numojo.prelude import *
from numojo.core.ndstrides import NDArrayStrides


def test_image():
    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    var root_path = os.path.join(
        test_data_root, "test_data/testsrc_128x128.png"
    )
    var image = Image.load(root_path)

    # for i in range(10):
    #     print(image._data[][Int(i)])
    # _ = image._data
    # for row in range(image.height):
    #     for i in range(image.width):
    #         if i % 3 == 0:
    #             print()
    #         print(image._data[Int(i + row * image.width)], end=" ")
    #     print()

    var array = nm.NDArray(
        shape=NDArrayShape(Int(image.height), Int(image.width), Int(3)),
        buffer=image._data.unsafe_origin_cast[MutExternalOrigin](),
        offset=0,
        strides=NDArrayStrides(1, 1, 1),
    )

    # for i in range(128):
    #     for j in range(128):
    #         print(array[i, j], end=" ")
    #     print()
    # _ = image
    print(array[0, 0])
    print(array[127, 0])
    print(array[0, 127])
    print(array[127, 127])


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
