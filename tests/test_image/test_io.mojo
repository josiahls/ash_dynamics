from testing.suite import TestSuite
from testing.testing import assert_equal
from ash_dynamics.primitives._clib import C_Union, TrivialOptionalField, Debug
from sys import size_of
from ash_dynamics.primitives.image import Image
import os

import numojo as nm
from numojo.prelude import *
from numojo.core.ndstrides import NDArrayStrides
from ash_dynamics.image.io import image_read
from logger import Logger, Level
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat


def test_image_read():
    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    var root_path = os.path.join(
        test_data_root, "test_data/testsrc_128x128.png"
    )
    var image = image_read(root_path)
    assert_equal(image.width, 128)
    assert_equal(image.height, 128)
    assert_equal(image.format, AVPixelFormat.AV_PIX_FMT_RGB24._value)
    assert_equal(image.n_color_spaces, 2)

    # NOTE: Simple test, we know that the first element is is black
    # and the last element is white.
    assert_equal(image.data[0], 0)
    assert_equal(image.data[49151], 255)


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
