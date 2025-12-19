from testing.suite import TestSuite
from testing.testing import assert_equal
from memory import memset
import sys
import os
from sys.ffi import c_uchar, c_int, c_char
from sys._libc_errno import ErrNo

from ash_dynamics.ffmpeg.avutil.error import AVERROR, AVERROR_EOF
from ash_dynamics.ffmpeg.avutil.error import FFERRTAG
from compile.reflection import get_type_name


def test_FFERRTAG():
    """Check:
    Basic 0,1,2,3 values make sense.
    That 'B' and named StaticStrings compile into the variant.
    """
    assert_equal(FFERRTAG(0, 1, 2, 3), -33751296)
    comptime s: StaticString = "S"
    comptime f: StaticString = "F"
    assert_equal(FFERRTAG(0, "B", s, f), -1397113344)


def test_AVERROR():
    assert_equal(AVERROR(ErrNo.ENOENT.value), -2)
    assert_equal(AVERROR(ErrNo.EIO.value), -5)
    assert_equal(AVERROR(ErrNo.ENOMEM.value), -12)
    assert_equal(AVERROR(ErrNo.EINVAL.value), -22)
    assert_equal(AVERROR(ErrNo.EAGAIN.value), -11)
    assert_equal(AVERROR(ErrNo.EBUSY.value), -16)
    assert_equal(AVERROR(ErrNo.EPERM.value), -1)


# def test_AVERROR_EOF():
#     assert_equal(AVERROR_EOF, -541478725)


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
