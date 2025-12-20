from testing.suite import TestSuite
from testing.testing import assert_equal
from memory import memset
import sys
import os
from sys.ffi import c_uchar, c_int, c_char, c_long_long, c_float
from sys._libc_errno import ErrNo

from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avutil import AV_NOPTS_VALUE
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil.buffer_internal import AVBuffer
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avcodec.av_codec_parser import AVCodecContext
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avcodec.packet import (
    AVPacketSideData,
    AVPacketSideDataType,
)
from ash_dynamics.ffmpeg.avcodec.defs import AV_INPUT_BUFFER_PADDING_SIZE
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec import Avcodec
from ash_dynamics.ffmpeg.avutil.error import AVERROR, AVERROR_EOF


@fieldwise_init
@register_passable("trivial")
struct OutputStream:
    var st: UnsafePointer[AVStream, origin = MutOrigin.external]
    var enc: UnsafePointer[AVCodecContext, origin = MutOrigin.external]
    var next_pts: c_long_long
    var samples_count: c_int
    var frame: UnsafePointer[AVFrame, origin = MutOrigin.external]
    var tmp_frame: UnsafePointer[AVFrame, origin = MutOrigin.external]
    var tmp_pkt: UnsafePointer[AVPacket, origin = MutOrigin.external]
    var t: c_float
    var tincr: c_float
    var tincr2: c_float
    var sws_ctx: UnsafePointer[SwsContext, origin = MutOrigin.external]


def test_av_mux_example():
    """From: https://www.ffmpeg.org/doxygen/8.0/decode_video_8c-example.html."""


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
