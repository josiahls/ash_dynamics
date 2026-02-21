from testing.suite import TestSuite
from testing.testing import assert_equal
from memory import memset
import sys
import os
from ffi import c_uchar, c_int, c_char
from sys._libc_errno import ErrNo

from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avutil import Avutil


def test_av_frame_alloc():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    assert_equal(frame[].width, 0)
    assert_equal(frame[].height, 0)
    assert_equal(frame[].format, -1)
    assert_equal(frame[].nb_samples, 0)
    assert_equal(frame[].nb_side_data, 0)
    assert_equal(frame[].flags, 0)

    fn accept_frame(frame: UnsafePointer[AVFrame, MutAnyOrigin]) raises:
        "Test whether frame survives being passed by reference."
        assert_equal(frame[].width, 0)

    accept_frame(frame)
    assert_equal(frame[].flags, 0)
    # _ = avutil


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
