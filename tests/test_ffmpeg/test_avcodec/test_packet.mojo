from testing.suite import TestSuite
from testing.testing import assert_equal
from memory import memset
import sys
import os
from ffi import c_uchar, c_int, c_char
from sys._libc_errno import ErrNo

from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avutil.avutil import AV_NOPTS_VALUE
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.buffer import AVBuffer, AVBufferRef
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


# def test_AVPacket():
#     var avcodec = Avcodec()
#     var data = InlineArray[c_uchar, 4](uninitialized=True)
#     data[0] = 104
#     data[1] = 101
#     data[2] = 108
#     data[3] = 10

#     var side_data_data = InlineArray[c_uchar, 4](uninitialized=True)
#     side_data_data[0] = 104
#     side_data_data[1] = 101
#     side_data_data[2] = 108
#     side_data_data[3] = 10

#     var side_data = AVPacketSideData(
#         data=side_data_data.unsafe_ptr().unsafe_origin_cast[
#             MutExternalOrigin
#         ](),
#         size=4,
#         type=AVPacketSideDataType.AV_PKT_DATA_PALETTE._value,
#     )

#     fn free_ptr(
#         opaque: OpaquePointer[MutExternalOrigin],
#         data: UnsafePointer[c_uchar, origin = MutExternalOrigin],
#     ):
#         print("freeing pointer")

#     var buffer = avcodec.av_buffer_alloc(4)
#     var buffer_ref = AVBufferRef(
#         buffer=UnsafePointer(to=buffer).unsafe_origin_cast[
#             MutExternalOrigin
#         ](),
#         data=buffer,
#         size=4,
#     )
#     _ = AVPacket(
#         buf=UnsafePointer(to=buffer_ref).unsafe_origin_cast[
#             MutExternalOrigin
#         ](),
#         pts=1000,
#         dts=1000,
#         data=data.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin](),
#         size=4,
#         stream_index=0,
#         flags=0,
#         side_data=UnsafePointer(to=side_data).unsafe_origin_cast[
#             MutExternalOrigin
#         ](),
#         side_data_elems=1,
#         duration=0,
#         pos=-1,
#         opaque=OpaquePointer[MutExternalOrigin](),
#         opaque_ref=UnsafePointer(to=buffer_ref).unsafe_origin_cast[
#             MutExternalOrigin
#         ](),
#         time_base=AVRational(num=1, den=1),
#     )


def test_av_packet_alloc():
    var avcodec = Avcodec()
    print("calling")
    var packet = avcodec.av_packet_alloc()
    print("called")
    print(packet)
    _ = avcodec  # Need this to keep the ffi bind alive


def test_av_packet_rescale_ts():
    var avcodec = Avcodec()
    var packet = avcodec.av_packet_alloc()
    packet[].pts = 0
    packet[].dts = 0
    packet[].duration = 0
    avcodec.av_packet_rescale_ts(
        packet, AVRational(num=1, den=25), AVRational(num=1, den=12800)
    )
    print(packet[].pts)
    print(packet[].dts)
    print(packet[].duration)
    _ = avcodec


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
