from testing.suite import TestSuite
from testing.testing import assert_equal
from memory import memset
import sys
from sys.info import size_of
import os
from sys.ffi import c_uchar, c_int, c_char
from ash_dynamics.ffmpeg.avutil import Avutil
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from sys._libc_errno import ErrNo

from ash_dynamics.ffmpeg.avutil.mathematics import (
    AVRounding,
    av_rescale_rnd,
    av_rescale_q_rnd,
)


def test_AVRounding():
    assert_equal(AVRounding.AV_ROUND_ZERO.value, 0)
    assert_equal(AVRounding.AV_ROUND_INF.value, 1)
    assert_equal(AVRounding.AV_ROUND_DOWN.value, 2)
    assert_equal(AVRounding.AV_ROUND_UP.value, 3)
    assert_equal(AVRounding.AV_ROUND_NEAR_INF.value, 5)
    assert_equal(AVRounding.AV_ROUND_PASS_MINMAX.value, 8192)


def test_av_rescale_q_rnd():
    var avutil = Avutil()
    var a = 0
    var bq = AVRational(num=1, den=25)
    var cq = AVRational(num=2, den=12800)
    print("sizeof(AVRational) = {}".format(size_of[AVRational]()))  # Also 8
    # C side is Stopping early.sizeof(a) = 8
    var rnd = AVRounding.AV_ROUND_NEAR_INF.value
    # The operation is mathematically equivalent to `a * bq / cq`
    print("a * bq / cq = {}".format(a * bq.num / cq.den))  # Outputs 0 (correct)
    var result = avutil.av_rescale_q_rnd(a, bq, cq, rnd)
    print("result = {}".format(result))  # Outputs -9223372036854775808 (wrong)
    assert_equal(result, 0)
    _ = avutil


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
