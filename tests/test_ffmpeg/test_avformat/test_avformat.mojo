from testing.suite import TestSuite
from testing.testing import assert_equal

from sys.ffi import c_char
from sys import size_of
from ash_dynamics.ffmpeg.avformat.avformat import (
    AVOutputFormat,
    AVFormatContext,
)
from ash_dynamics.ffmpeg.avformat import Avformat
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.log import AVClassCategory, AVClass


def test_AVOutputFormat():
    var avformat = Avformat()

    var short_name = "mp4"
    var short_name_ptr = (
        short_name.as_c_string_slice().unsafe_ptr().as_immutable()
    )

    var fmt = avformat.av_guess_format(
        short_name=short_name_ptr,
        filename=UnsafePointer[c_char, ImmutExternalOrigin](),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](),
    )
    assert_equal(fmt[].video_codec, AVCodecID.AV_CODEC_ID_MPEG4._value)

    var filename = "some/path/to/test.mp4"
    var filename_ptr = filename.as_c_string_slice().unsafe_ptr().as_immutable()
    var fmt2 = avformat.av_guess_format(
        short_name=UnsafePointer[c_char, ImmutExternalOrigin](),
        filename=filename_ptr,
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](),
    )
    assert_equal(fmt2[].video_codec, AVCodecID.AV_CODEC_ID_MPEG4._value)

    var mime_type = "video/mp4"
    var mime_type_ptr = (
        mime_type.as_c_string_slice().unsafe_ptr().as_immutable()
    )
    var fmt3 = avformat.av_guess_format(
        short_name=UnsafePointer[c_char, ImmutExternalOrigin](),
        filename=UnsafePointer[c_char, ImmutExternalOrigin](),
        mime_type=mime_type_ptr,
    )
    # It is h264 here since we are directly indiciating this contains
    # video.
    assert_equal(fmt3[].video_codec, AVCodecID.AV_CODEC_ID_H264._value)

    print("fmt:", fmt2)
    _ = fmt
    _ = avformat


def test_alloc_output_context():
    var avformat = Avformat()
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)

    var filename = String("some/path/to/test.mp4")
    var ret = avformat.alloc_output_context(
        ctx=ctx,
        filename=filename,
    )
    assert_equal(ret, 0)
    assert_equal(Bool(ctx), True)

    # AVFormatContext field offsets:
    # av_class:        0
    # iformat:         8
    # oformat:         16
    # priv_data:       24
    # pb:              32
    # ctx_flags:       40
    # nb_streams:      44
    # nb_stream_groups: 56
    # packet_size:     120
    # max_delay:       124
    # flags:           128

    # Size of pointer: 8 bytes
    # Size of int: 4 bytes
    # Size of unsigned int: 4 bytes
    # Total struct size: 472 bytes

    # 472 bytes, same as c
    print(
        "sizeof(AVFormatContext) (Mojo):", size_of[AVFormatContext](), "bytes"
    )

    assert_equal(ctx[][].ctx_flags, 0)
    assert_equal(ctx[][].nb_streams, 0)
    assert_equal(ctx[][].nb_stream_groups, 0)
    assert_equal(ctx[][].packet_size, 0)
    assert_equal(ctx[][].max_delay, -1)
    assert_equal(ctx[][].flags, 2097152)
    assert_equal(ctx[][].probesize, 5000000)
    assert_equal(ctx[][].max_analyze_duration, 0)
    assert_equal(ctx[][].keylen, 0)
    assert_equal(ctx[][].nb_chapters, 0)
    assert_equal(ctx[][].nb_programs, 0)
    assert_equal(ctx[][].start_time, 0)
    assert_equal(ctx[][].duration, 0)
    assert_equal(ctx[][].bit_rate, 0)
    assert_equal(ctx[][].video_codec_id, 0)
    assert_equal(ctx[][].audio_codec_id, 0)
    assert_equal(ctx[][].subtitle_codec_id, 0)
    assert_equal(ctx[][].data_codec_id, 0)

    assert_equal(
        String(unsafe_from_utf8_ptr=ctx[][].av_class[].class_name),
        "AVFormatContext",
    )
    assert_equal(ctx[][].av_class[].state_flags_offset, 0)
    _ = ctx
    _ = ret
    _ = avformat


def test_avformat_get_class():
    var avformat = Avformat()
    var av_class = avformat.avformat_get_class()
    assert_equal(
        String(unsafe_from_utf8_ptr=av_class[].class_name), "AVFormatContext"
    )
    assert_equal(
        av_class[].category, AVClassCategory.AV_CLASS_CATEGORY_MUXER._value
    )
    assert_equal(av_class[].state_flags_offset, 0)
    _ = av_class
    _ = avformat


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
