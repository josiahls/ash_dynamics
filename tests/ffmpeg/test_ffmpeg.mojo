from testing.suite import TestSuite
from testing.testing import assert_equal
from memory import memset
import sys
from sys.ffi import c_uchar, c_int

from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avutil import AV_NOPTS_VALUE
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil.buffer_internal import AVBuffer
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avcodec.packet import (
    AVPacketSideData,
    AVPacketSideDataType,
)
from ash_dynamics.ffmpeg.avcodec.defs import AV_INPUT_BUFFER_PADDING_SIZE
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec import avcodec


def test_AVPacket():
    var data = InlineArray[c_uchar, 4](uninitialized=True)
    data[0] = 104
    data[1] = 101
    data[2] = 108
    data[3] = 10

    var side_data_data = InlineArray[c_uchar, 4](uninitialized=True)
    side_data_data[0] = 104
    side_data_data[1] = 101
    side_data_data[2] = 108
    side_data_data[3] = 10

    var side_data = AVPacketSideData(
        data=side_data_data.unsafe_ptr().unsafe_origin_cast[
            MutOrigin.external
        ](),
        size=4,
        type=AVPacketSideDataType.AV_PKT_DATA_PALETTE._value,
    )

    fn free_ptr(
        opaque: OpaquePointer[MutOrigin.external],
        data: UnsafePointer[c_uchar, origin = MutOrigin.external],
    ):
        print("freeing pointer")

    var buffer = AVBuffer(
        data=data.unsafe_ptr().unsafe_origin_cast[MutOrigin.external](),
        size=4,
        refcount=1,
        free=free_ptr,
        opaque=OpaquePointer[MutOrigin.external](),
        flags=0,
        flags_internal=0,
    )
    var buffer_ref = AVBufferRef(
        buffer=UnsafePointer(to=buffer).unsafe_origin_cast[
            MutOrigin.external
        ](),
        data=buffer.data,
        size=buffer.size,
    )
    _ = AVPacket(
        buf=UnsafePointer(to=buffer_ref).unsafe_origin_cast[
            MutOrigin.external
        ](),
        pts=1000,
        dts=1000,
        data=data.unsafe_ptr().unsafe_origin_cast[MutOrigin.external](),
        size=4,
        stream_index=0,
        flags=0,
        side_data=UnsafePointer(to=side_data).unsafe_origin_cast[
            MutOrigin.external
        ](),
        side_data_elems=1,
        duration=0,
        pos=-1,
        opaque=OpaquePointer[MutOrigin.external](),
        opaque_ref=UnsafePointer(to=buffer_ref).unsafe_origin_cast[
            MutOrigin.external
        ](),
        time_base=AVRational(num=1, den=1),
    )


def test_av_packet_alloc():
    var avcodec = avcodec()
    print("calling")
    var packet = avcodec.av_packet_alloc()
    print("called")
    print(packet)
    _ = avcodec  # Need this to keep the ffi bind alive


def test_codec_id():
    # NOTE: May need to have this test adjust depending on FFmpeg versions.
    # Note: This test assumes all of the flags in the xors are true
    assert_equal(AVCodecID.AV_CODEC_ID_MPEG1VIDEO._value, 1)
    assert_equal(AVCodecID.AV_CODEC_ID_MPEG2VIDEO._value, 2)
    assert_equal(AVCodecID.AV_CODEC_ID_H264._value, 27)
    # 1st macro alias another enum field
    assert_equal(AVCodecID.AV_CODEC_ID_IFF_BYTERUN1._value, 136)
    # 2nd macro that optionally inserts AV_CODEC_ID_V410 as a field.
    assert_equal(AVCodecID.AV_CODEC_ID_V410._value, 156)
    assert_equal(AVCodecID.AV_CODEC_ID_XWD._value, 157)
    # 3rd macro alias another enum field
    assert_equal(AVCodecID.AV_CODEC_ID_H265._value, 173)
    # 4th macro alias another enum field
    assert_equal(AVCodecID.AV_CODEC_ID_H266._value, 196)
    assert_equal(AVCodecID.AV_CODEC_ID_TARGA_Y216._value, 201)
    assert_equal(AVCodecID.AV_CODEC_ID_V308._value, 202)
    assert_equal(AVCodecID.AV_CODEC_ID_V408._value, 203)
    assert_equal(AVCodecID.AV_CODEC_ID_YUV4._value, 204)
    assert_equal(AVCodecID.AV_CODEC_ID_AVRN._value, 205)
    assert_equal(AVCodecID.AV_CODEC_ID_PRORES_RAW._value, 274)

    # Audio enum fields.
    assert_equal(AVCodecID.AV_CODEC_ID_FIRST_AUDIO._value, 65536)
    assert_equal(AVCodecID.AV_CODEC_ID_PCM_S16LE._value, 65536)
    assert_equal(AVCodecID.AV_CODEC_ID_PCM_SGA._value, 65536 + 36)
    # various ADPCM codecs
    assert_equal(AVCodecID.AV_CODEC_ID_ADPCM_IMA_QT._value, 69632)
    assert_equal(AVCodecID.AV_CODEC_ID_ADPCM_SANYO._value, 69632 + 53)

    # AMR
    assert_equal(AVCodecID.AV_CODEC_ID_AMR_NB._value, 0x12000)
    assert_equal(AVCodecID.AV_CODEC_ID_AMR_WB._value, 0x12000 + 1)
    # RealAudio codecs
    assert_equal(AVCodecID.AV_CODEC_ID_RA_144._value, 0x13000)
    assert_equal(AVCodecID.AV_CODEC_ID_RA_288._value, 0x13000 + 1)
    # various DPCM codecs
    assert_equal(AVCodecID.AV_CODEC_ID_ROQ_DPCM._value, 0x14000)
    assert_equal(AVCodecID.AV_CODEC_ID_CBD2_DPCM._value, 0x14000 + 8)
    # audio codecs
    assert_equal(AVCodecID.AV_CODEC_ID_MP2._value, 0x15000)
    assert_equal(AVCodecID.AV_CODEC_ID_G728._value, 0x15000 + 107)
    # subtitle / other sections
    assert_equal(AVCodecID.AV_CODEC_ID_FIRST_SUBTITLE._value, 0x17000)
    # Note there are 2 fields with the same id, so the fields are -1 lower.
    assert_equal(AVCodecID.AV_CODEC_ID_IVTV_VBI._value, 0x17000 + 26)
    # other specific kind of codecs
    assert_equal(AVCodecID.AV_CODEC_ID_FIRST_UNKNOWN._value, 0x18000)
    assert_equal(AVCodecID.AV_CODEC_ID_TTF._value, 0x18000)
    assert_equal(AVCodecID.AV_CODEC_ID_SMPTE_436M_ANC._value, 0x18000 + 13)

    # Misc other codec ids
    assert_equal(AVCodecID.AV_CODEC_ID_PROBE._value, 0x19000)
    assert_equal(AVCodecID.AV_CODEC_ID_MPEG2TS._value, 0x20000)
    assert_equal(AVCodecID.AV_CODEC_ID_MPEG4SYSTEMS._value, 0x20001)
    assert_equal(AVCodecID.AV_CODEC_ID_FFMETADATA._value, 0x21000)
    assert_equal(AVCodecID.AV_CODEC_ID_WRAPPED_AVFRAME._value, 0x21001)
    assert_equal(AVCodecID.AV_CODEC_ID_VNULL._value, 0x21001 + 1)
    assert_equal(AVCodecID.AV_CODEC_ID_ANULL._value, 0x21001 + 2)


def test_av_decode_video_example():
    """From: https://www.ffmpeg.org/doxygen/8.0/decode_video_8c-example.html."""
    comptime INBUF_SIZE = c_int(4096)

    var input_buffer = alloc[c_uchar](
        Int(INBUF_SIZE + AV_INPUT_BUFFER_PADDING_SIZE)
    )

    var avcodec = avcodec()

    # Set the padding portion of the input_buffer to zero.
    memset(
        input_buffer + INBUF_SIZE,
        0,
        Int(AV_INPUT_BUFFER_PADDING_SIZE),
    )
    var packet = avcodec.av_packet_alloc()
    print(packet[])

    var codec = avcodec.avcodec_find_decoder(AVCodecID.AV_CODEC_ID_H264._value)
    print(codec[])

    var parser = avcodec.av_parser_init(codec[].id)
    print(parser[])

    var context = avcodec.avcodec_alloc_context3(codec)
    print(context[])

    ptr = alloc[AVDictionary](0)
    try_open = avcodec.avcodec_open2(context, codec, ptr)
    if try_open < 0:
        print("Failed to open codec")
        sys.exit(1)
    else:
        print("Opened codec")

    with open(
        "/home/mojo_user/ash_dynamics/test_data/akiyo_qcif.h264", "r"
    ) as f:
        while True:
            var data_size = c_int(
                f.read[c_uchar.dtype](
                    Span(ptr=input_buffer, length=Int(INBUF_SIZE))
                )
            )

            if data_size == 0:
                break

            var data = input_buffer
            while data_size > 0:
                var ret = avcodec.av_parser_parse2(
                    parser,
                    context,
                    UnsafePointer(to=packet[].data),
                    UnsafePointer(to=packet[].size),
                    data,
                    data_size,
                    AV_NOPTS_VALUE,
                    AV_NOPTS_VALUE,
                    0,
                )
                if ret < 0:
                    print("Failed to parse data")
                    sys.exit(1)
                elif parser[].flags & AVPacket.AV_PKT_FLAG_CORRUPT:
                    print("Parsed data is corrupted")
                else:
                    print("Parsed data is valid")
                data += ret
                data_size -= ret

                if packet[].size > 0:
                    print("Packet size: ", packet[].size)
                    # TODO: `decode()`...

    _ = codec

    _ = avcodec  # Need this to keep the ffi bind alive


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
