from testing.suite import TestSuite
from testing.testing import assert_equal
from memory import memset
import sys
import os
from sys.ffi import c_uchar, c_int, c_char, c_long_long, c_float, c_uint
from sys._libc_errno import ErrNo

from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avutil import AV_NOPTS_VALUE
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil.buffer_internal import AVBuffer
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avcodec.avcodec import AVCodecContext
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


fn open_video(
    avformat: Avformat,
    avcodec: Avcodec,
    oc: UnsafePointer[AVFormatContext, MutOrigin.external],
    video_codec: UnsafePointer[AVCodec, ImmutOrigin.external],
    ost: OutputStream,
    opt_arg: UnsafePointer[AVDictionary, ImmutOrigin.external],
):
    var ret: c_int = 0
    var c = ost.enc
    # NOTE: We need to add an override to avcodec_open2 that makes
    # an internal null pointer. Debug mode otherwise fails on this.
    var opt = alloc[AVDictionary](0)
    print("im opening a video")

    # TODO: Add later. Right now we are not using any options.
    # avformat.av_dict_copy(opt, opt_arg, 0)

    ret = avcodec.avcodec_open2(c, video_codec, opt)
    # TODO: Add later. Right now we are not using any options.
    # avformat.av_dict_free(opt)
    _ = c
    # _ = opt

    if ret < 0:
        os.abort("Failed to open video codec")


def add_stream(
    avformat: Avformat,
    avcodec: Avcodec,
    mut ost: OutputStream,
    oc: UnsafePointer[AVFormatContext, MutOrigin.external],
    video_codec: UnsafePointer[
        UnsafePointer[AVCodec, ImmutOrigin.external], MutOrigin.external
    ],
    video_codec_id: AVCodecID.ENUM_DTYPE,
):
    var i: c_int = 0
    var c = alloc[AVCodecContext](1)

    var codec = avcodec.avcodec_find_encoder(video_codec_id)
    if not codec:
        os.abort("Failed to find encoder")

    ost.tmp_pkt = avcodec.av_packet_alloc()
    if not ost.tmp_pkt:
        os.abort("Failed to allocate AVPacket")

    # var st = avformat.avformat_new_stream(oc, None)
    # if not st:
    #     os.abort("Failed to allocate stream")

    # st[][].id = oc[][].nb_streams - 1

    # var ret = avcodec.avcodec_alloc_context3(codec)
    # if ret < 0:
    #     os.abort("Failed to allocate encoding context")

    # ost.enc = ret


def test_av_mux_example():
    """From: https://www.ffmpeg.org/doxygen/8.0/mux_8c-example.html."""
    var video_st = OutputStream()
    # NOTE: Not interested in audio at the moment.
    # var audio_st = OutputStream()
    var fmt = alloc[UnsafePointer[AVOutputFormat, ImmutOrigin.external]](1)
    var oc = alloc[UnsafePointer[AVFormatContext, MutOrigin.external]](1)
    # var oc = UnsafePointer[AVFormatContext, MutAnyOrigin]()
    # NOTE: Not interested in audio at the moment.
    # var audio_codec = AVCodec()
    var video_codec = alloc[UnsafePointer[AVCodec, ImmutOrigin.external]](1)
    var ret = c_int(0)
    var have_video = c_int(0)
    # NOTE: Not interested in audio at the moment.
    # var have_audio = c_int(0)
    var encode_video = c_int(0)
    # var encode_audio = c_int(0)
    var opt = UnsafePointer(to=alloc[AVDictionary](1))
    var i = c_int(0)

    var avformat = Avformat()
    var avcodec = Avcodec()

    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    var input_filename: String = (
        "{}/test_data/testsrc_320x180_30fps_2s.h264".format(test_data_root)
    )
    var output_filename: String = (
        "{}/test_data/testsrc_320x180_30fps_2s.mp4".format(test_data_root)
    )

    # FIXME: Tryout without any flags, just h264 to mp4.
    # ret = avformat.alloc_output_context(oc, output_filename)

    ret = avformat.alloc_output_context(
        ctx=oc,
        filename=output_filename,
    )
    if not oc or ret < 0:
        os.abort("Failed to allocate output context")
        # Note: The example: mux.c will switch to 'mpeg' on failure. In our case
        # however, we want to be strict about the expected behavior.

    fmt = UnsafePointer(to=oc[][].oformat)
    video_codec = UnsafePointer(to=oc[][].video_codec)

    if fmt[][].video_codec != AVCodecID.AV_CODEC_ID_NONE._value:
        print("video codec is not none: ", fmt[][].video_codec)
        add_stream(
            avformat, avcodec, video_st, oc[], video_codec, fmt[][].video_codec
        )
        have_video = 1
        encode_video = 1
    else:
        print("video codec is none")
    # if fmt[].audio_codec != AV_CODEC_ID_NONE:
    #     print("audio codec is not none")
    # else:
    #     print("audio codec is none")

    # if have_video:
    #     open_video(avformat, avcodec, oc[], video_codec[], video_st, opt[])

    _ = ret
    _ = fmt
    _ = oc
    _ = avformat
    _ = avcodec


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
