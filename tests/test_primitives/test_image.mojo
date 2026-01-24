from testing.suite import TestSuite
from testing.testing import assert_equal
from ash_dynamics.primitives._clib import C_Union, TrivialOptionalField, Debug
from sys import size_of
from ash_dynamics.primitives.image import Image
import os

import numojo as nm
from numojo.prelude import *
from numojo.core.layout.ndstrides import NDArrayStrides


def test_image_load():
    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    var root_path = os.path.join(
        test_data_root, "test_data/testsrc_128x128.png"
    )
    var image = Image.load(root_path)

    # var array = nm.NDArray[nm.u8](
    #     shape = nm.Shape(Int(image.height), Int(image.width), Int(3)),
    #     strides = nm.Strides(1, 1, 1),
    #     data = nm.core.memory.data_container.DataContainer(image._data.unsafe_origin_cast[MutExternalOrigin]()),
    # )

    var array = nm.NDArray(
        shape=NDArrayShape(Int(image.height), Int(image.width), Int(3)),
        buffer=image._data.unsafe_origin_cast[MutExternalOrigin](),
        offset=0,
        strides=NDArrayStrides(1, 1, 1),
    )

    print(array[0, 0])
    print(array[127, 0])
    print(array[0, 127])
    print(array[127, 127])


def test_image_save():
    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    var root_path = os.path.join(
        test_data_root, "test_data/testsrc_128x128.png"
    )
    var save_path = os.path.join(
        test_data_root, "test_data/test_image_image_save.png"
    )
    # TODO: Next pr MUST fix the lifetimes to make this work.
    # var image = Image.load(root_path)
    # image.save(save_path)

    # # TODO: The image object contexts do not cleanup properly.
    # # Next steps is redoing all the origins so mojo can deallocate them properly.
    # var image2 = Image.load(save_path)
    # assert_equal(image2.width, image.width)
    # assert_equal(image2.height, image.height)
    # assert_equal(image2.format, image.format)
    # assert_equal(image2.n_color_spaces, image.n_color_spaces)
    # assert_equal(image2._data, image._data)


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
