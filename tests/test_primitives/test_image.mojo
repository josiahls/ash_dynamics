from std.testing import TestSuite, assert_equal
from ash_dynamics.primitives._clib import C_Union, TrivialOptionalField
from std.sys import size_of
from ash_dynamics.primitives.image import Image
from std.os import getenv
from std.os.path import join

import numojo as nm
from numojo.prelude import *
from numojo.core.layout.ndstrides import NDArrayStrides
from numojo.core.memory.data_container import DataContainer


def test_image_load() raises:
    var test_data_root = getenv("PIXI_PROJECT_ROOT")
    var root_path = join(test_data_root, "test_data/testsrc_128x128.png")
    var image = Image.load(root_path)

    print("Done Loading image")

    var data_container = DataContainer(
        ptr=image._data.unsafe_origin_cast[MutExternalOrigin](),
        size=Int(image.width * image.height * 3),
    )
    print("Done Creating data container")

    var array = nm.NDArray(
        shape=NDArrayShape(Int(image.height), Int(image.width), Int(3)),
        is_view=False,
        data=data_container^,
        strides=NDArrayStrides(1, 1, 1),
        offset=0,
    )

    print("Done Creating array")

    print(array[0, 0])
    print(array[127, 0])
    print(array[0, 127])
    print(array[127, 127])


def test_image_save() raises:
    var test_data_root = getenv("PIXI_PROJECT_ROOT")
    var root_path = join(test_data_root, "test_data/testsrc_128x128.png")
    var save_path = join(test_data_root, "test_data/test_image_image_save.png")
    # TODO: Next pr MUST fix the lifetimes to make this work.
    var image = Image.load(root_path)
    image.save(save_path)

    # TODO: The image object contexts do not cleanup properly.
    # Next steps is redoing all the origins so mojo can deallocate them properly.
    var image2 = Image.load(save_path)
    assert_equal(image2.width, image.width)
    assert_equal(image2.height, image.height)
    assert_equal(image2.format, image.format)
    assert_equal(image2.n_color_spaces, image.n_color_spaces)
    assert_equal(image2._data, image._data)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
