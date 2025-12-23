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
from ash_dynamics.ffmpeg.avformat.avformat import AVFormatContext, AVStream
from ash_dynamics.ffmpeg.avformat.avio import AVIOContext
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.codec_par import AVCodecParameters
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.swscale.swscale import SwsContext
from ash_dynamics.ffmpeg.avformat.avformat import (
    AVOutputFormat,
    AVFormatContext,
)
from ash_dynamics.ffmpeg.avformat import Avformat


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

    fn __init__(out self) raises:
        self.st = alloc[AVStream](1)
        self.enc = alloc[AVCodecContext](1)
        self.next_pts = c_long_long(0)
        self.samples_count = c_int(0)
        self.frame = alloc[AVFrame](1)
        self.tmp_frame = alloc[AVFrame](1)
        self.tmp_pkt = alloc[AVPacket](1)
        self.t = c_float(0)
        self.tincr = c_float(0)
        self.tincr2 = c_float(0)
        self.sws_ctx = alloc[SwsContext](1)


def test_av_mux_example():
    """From: https://www.ffmpeg.org/doxygen/8.0/mux_8c-example.html."""
    var video_st = OutputStream()
    # NOTE: Not interested in audio at the moment.
    # var audio_st = OutputStream()
    var fmt = UnsafePointer(to=alloc[AVOutputFormat](1))
    var oc = alloc[UnsafePointer[AVFormatContext, MutOrigin.external]](1)
    # NOTE: Not interested in audio at the moment.
    # var audio_codec = AVCodec()
    var video_codec = UnsafePointer(to=alloc[AVCodec](1))
    var ret = c_int(0)
    var have_video = c_int(0)
    # NOTE: Not interested in audio at the moment.
    # var have_audio = c_int(0)
    var encode_video = c_int(0)
    # var encode_audio = c_int(0)
    var opt = UnsafePointer(to=alloc[AVDictionary](1))
    var i = c_int(0)

    var avformat = Avformat()

    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    var input_filename: String = (
        "{}/test_data/testsrc_320x180_30fps_2s.h264".format(test_data_root)
    )
    var output_filename: String = (
        "{}/test_data/testsrc_320x180_30fps_2s.mp4".format(test_data_root)
    )

    # FIXME: Tryout without any flags, just h264 to mp4.
    # ret = avformat.alloc_output_context(oc, output_filename)
    ret = avformat._alloc_output_context(
        ctx=oc,
        oformat=UnsafePointer[AVOutputFormat, ImmutAnyOrigin](),
        format_name=UnsafePointer[c_char, ImmutAnyOrigin](),
        filename=output_filename.as_c_string_slice().unsafe_ptr(),
    )
    if not ret:
        os.abort("Failed to allocate output context")
    _ = ret
    _ = oc


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
