from testing.suite import TestSuite
from testing.testing import assert_equal, assert_true

from ffi import c_char, c_int, c_uint, c_uchar, c_long_long
from sys._libc import fdopen, fflush
from memory import alloc, memset
from sys import size_of
import os
from pathlib import Path
from ash_dynamics.ffmpeg.avformat.avformat import (
    AVOutputFormat,
    AVFormatContext,
    AVStreamGroupParamsType,
    AVInputFormat,
    AVProbeData,
    AVProgram,
)
from ash_dynamics.ffmpeg import avformat
from ash_dynamics.ffmpeg.avformat.avio import AVIOContext, AVIO_FLAG_READ
from ash_dynamics.ffmpeg.avformat.internal import AVCodecTag
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg import avcodec
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg import avutil
from ash_dynamics.ffmpeg.avutil.log import AVClassCategory, AVClass
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avutil.frame import AVFrame


def test_AVOutputFormat():
    var short_name = "mp4"
    var short_name_ptr = (
        short_name.as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin]()
    )

    var fmt = avformat.av_guess_format(
        short_name=short_name_ptr,
        filename=UnsafePointer[c_char, ImmutExternalOrigin](),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](),
    )
    assert_equal(fmt[].video_codec, AVCodecID.AV_CODEC_ID_MPEG4._value)

    var filename = "some/path/to/test.mp4"
    var filename_ptr = (
        filename.as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin]()
    )
    var fmt2 = avformat.av_guess_format(
        short_name=UnsafePointer[c_char, ImmutExternalOrigin](),
        filename=filename_ptr,
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](),
    )
    assert_equal(fmt2[].video_codec, AVCodecID.AV_CODEC_ID_MPEG4._value)

    var mime_type = "video/mp4"
    var mime_type_ptr = (
        mime_type.as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin]()
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


def test_alloc_output_context():
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


def test_avformat_get_class():
    var av_class = avformat.avformat_get_class()
    assert_equal(
        String(unsafe_from_utf8_ptr=av_class[].class_name), "AVFormatContext"
    )
    assert_equal(
        av_class[].category, AVClassCategory.AV_CLASS_CATEGORY_MUXER._value
    )
    assert_equal(av_class[].state_flags_offset, 0)
    _ = av_class


def test_avformat_version():
    var ver = avformat.avformat_version()
    assert_true(ver > 0)


def test_avformat_configuration():
    var cfg = avformat.avformat_configuration()
    assert_true(Bool(cfg))
    _ = String(unsafe_from_utf8_ptr=cfg)


def test_avformat_license():
    var lic = avformat.avformat_license()
    assert_true(Bool(lic))
    _ = String(unsafe_from_utf8_ptr=lic)


def test_avformat_network_init_deinit():
    var ret = avformat.avformat_network_init()
    assert_equal(ret, 0)
    var ret2 = avformat.avformat_network_deinit()
    assert_equal(ret2, 0)


def test_av_muxer_iterate():
    var opaque = alloc[OpaquePointer[MutExternalOrigin]](1)
    memset(opaque, 0, 1)
    var count = 0
    while True:
        var fmt = avformat.av_muxer_iterate(
            opaque.unsafe_origin_cast[MutExternalOrigin](),
        )
        if not Bool(fmt):
            break
        count += 1
    assert_true(count > 0)


def test_av_demuxer_iterate():
    var opaque = alloc[OpaquePointer[MutExternalOrigin]](1)
    memset(opaque, 0, 1)
    var count = 0
    while True:
        var fmt = avformat.av_demuxer_iterate(
            opaque.unsafe_origin_cast[MutExternalOrigin](),
        )
        if not Bool(fmt):
            break
        count += 1
    assert_true(count > 0)


def test_avformat_alloc_free_context():
    var ctx = avformat.avformat_alloc_context()
    assert_true(Bool(ctx))
    avformat.avformat_free_context(ctx)


def test_av_find_input_format():
    var name = "mp4"
    var ptr = name.as_c_string_slice().unsafe_ptr().as_immutable()
    var fmt = avformat.av_find_input_format(
        ptr.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_true(Bool(fmt))
    assert_equal(
        String(unsafe_from_utf8_ptr=fmt[].name), "mov,mp4,m4a,3gp,3g2,mj2"
    )


def test_av_disposition_from_string_to_string():
    var disp_str = "default"
    var ptr = disp_str.as_c_string_slice().unsafe_ptr().as_immutable()
    var disp = avformat.av_disposition_from_string(
        ptr.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(disp, 1)
    var back = avformat.av_disposition_to_string(disp)
    assert_true(Bool(back))
    assert_equal(String(unsafe_from_utf8_ptr=back), "default")


def test_av_match_ext():
    var filename = "test.mp4"
    var ext = "mp4,mov,m4a"
    var fn_ptr = filename.as_c_string_slice().unsafe_ptr().as_immutable()
    var ext_ptr = ext.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.av_match_ext(
        fn_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        ext_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_true(ret > 0)
    var txt_ext = "txt,log"
    var txt_ptr = txt_ext.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret2 = avformat.av_match_ext(
        fn_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        txt_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret2, 0)


def test_avformat_get_riff_mov_tags():
    var riff_video = avformat.avformat_get_riff_video_tags()
    var riff_audio = avformat.avformat_get_riff_audio_tags()
    var mov_video = avformat.avformat_get_mov_video_tags()
    var mov_audio = avformat.avformat_get_mov_audio_tags()
    assert_true(Bool(riff_video))
    assert_true(Bool(riff_audio))
    assert_true(Bool(mov_video))
    assert_true(Bool(mov_audio))


def test_av_codec_get_id_and_tag():
    var tags = avformat.avformat_get_riff_video_tags()
    var table = alloc[UnsafePointer[AVCodecTag, ImmutExternalOrigin]](2)
    table[0] = tags
    table[1] = UnsafePointer[AVCodecTag, ImmutExternalOrigin](
        unsafe_from_address=0
    )
    # MKTAG('H','2','6','4') = 0x34363248 on little-endian
    var tag = c_uint(0x34363248)
    var codec_id = avformat.av_codec_get_id(
        table.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        tag,
    )
    assert_equal(codec_id, AVCodecID.AV_CODEC_ID_H264._value)
    var tag_out = avformat.av_codec_get_tag(
        table.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_equal(Int(tag_out), Int(tag))


def test_av_filename_number_test():
    var valid = "frame_%03d.png"
    var valid_ptr = valid.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.av_filename_number_test(
        valid_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret, 1)
    var invalid = "frame.png"
    var invalid_ptr = invalid.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret2 = avformat.av_filename_number_test(
        invalid_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret2, 0)


def test_av_stream_get_parser():
    var ctx = avformat.avformat_alloc_context()
    var st = avformat.avformat_new_stream(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    var parser = avformat.av_stream_get_parser(
        st.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(Bool(parser), False)
    avformat.avformat_free_context(ctx)


def test_av_find_default_stream_index():
    var ctx = avformat.avformat_alloc_context()
    var idx = avformat.av_find_default_stream_index(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
    )
    assert_equal(idx, -1)
    avformat.avformat_free_context(ctx)


def test_av_hex_dump():
    var buf = alloc[c_uchar](16)
    for i in range(16):
        buf[i] = c_uchar(i)
    var f = fdopen(1, "w".as_c_string_slice().unsafe_ptr().as_immutable())
    avformat.av_hex_dump(
        f,
        buf.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        16,
    )
    _ = fflush(f)


def test_av_dump_format():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    if ret == 0:
        avformat.av_dump_format(
            ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
            -1,
            path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
            0,
        )
        avformat.avformat_close_input(
            ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
        )


def test_av_stream_get_class():
    var cls = avformat.av_stream_get_class()
    assert_true(Bool(cls))
    _ = String(unsafe_from_utf8_ptr=cls[].class_name)


def test_av_stream_group_get_class():
    var cls = avformat.av_stream_group_get_class()
    assert_true(Bool(cls))
    _ = String(unsafe_from_utf8_ptr=cls[].class_name)


def test_avformat_stream_group_name():
    var name = avformat.avformat_stream_group_name(
        AVStreamGroupParamsType.AV_STREAM_GROUP_PARAMS_TILE_GRID.value,
    )
    assert_true(Bool(name))
    assert_equal(String(unsafe_from_utf8_ptr=name), "Tile Grid")


def test_avformat_stream_group_create_new_stream_add_stream():
    var ctx = avformat.avformat_alloc_context()
    assert_true(Bool(ctx))
    var stg = avformat.avformat_stream_group_create(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        AVStreamGroupParamsType.AV_STREAM_GROUP_PARAMS_TILE_GRID.value,
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_true(Bool(stg))
    var st = avformat.avformat_new_stream(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_true(Bool(st))
    var ret = avformat.avformat_stream_group_add_stream(
        stg.unsafe_origin_cast[MutExternalOrigin](),
        st.unsafe_origin_cast[MutExternalOrigin](),
    )
    assert_equal(ret, 0)
    avformat.avformat_free_context(ctx)


def test_av_new_program():
    var ctx = avformat.avformat_alloc_context()
    assert_true(Bool(ctx))
    var prog = avformat.av_new_program(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        1,
    )
    assert_true(Bool(prog))
    avformat.avformat_free_context(ctx)


def test_av_guess_codec():
    var short_name = "mp4"
    var short_ptr = short_name.as_c_string_slice().unsafe_ptr().as_immutable()
    var fmt = avformat.av_guess_format(
        short_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[c_char, ImmutExternalOrigin](),
        UnsafePointer[c_char, ImmutExternalOrigin](),
    )
    assert_true(Bool(fmt))
    var codec_id = avformat.av_guess_codec(
        fmt,
        short_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[c_char, ImmutExternalOrigin](),
        UnsafePointer[c_char, ImmutExternalOrigin](),
        AVMediaType.AVMEDIA_TYPE_VIDEO._value,
    )
    assert_true(
        codec_id == AVCodecID.AV_CODEC_ID_H264._value
        or codec_id == AVCodecID.AV_CODEC_ID_MPEG4._value
    )


def test_avformat_query_codec():
    var short_name = "mp4"
    var short_ptr = short_name.as_c_string_slice().unsafe_ptr().as_immutable()
    var fmt = avformat.av_guess_format(
        short_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[c_char, ImmutExternalOrigin](),
        UnsafePointer[c_char, ImmutExternalOrigin](),
    )
    assert_true(Bool(fmt))
    var ret = avformat.avformat_query_codec(
        fmt,
        AVCodecID.AV_CODEC_ID_H264._value,
        0,
    )
    assert_true(ret >= 0)


def test_av_codec_get_tag2():
    var tags = avformat.avformat_get_riff_video_tags()
    var table = alloc[UnsafePointer[AVCodecTag, ImmutExternalOrigin]](2)
    table[0] = tags
    table[1] = UnsafePointer[AVCodecTag, ImmutExternalOrigin](
        unsafe_from_address=0
    )
    var tag_out = alloc[c_uint](1)
    var ret = avformat.av_codec_get_tag2(
        table.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVCodecID.AV_CODEC_ID_H264._value,
        tag_out.unsafe_origin_cast[MutExternalOrigin](),
    )
    assert_true(ret > 0)
    assert_equal(Int(tag_out[]), 0x34363248)


def test_av_get_frame_filename():
    var buf = alloc[c_char](256)
    memset(buf, 0, 256)
    var path = "frame_%03d.png"
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.av_get_frame_filename(
        buf.unsafe_origin_cast[MutExternalOrigin](),
        256,
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        42,
    )
    assert_equal(ret, 0)
    assert_equal(String(unsafe_from_utf8_ptr=buf), "frame_042.png")


def test_av_get_frame_filename2():
    var buf = alloc[c_char](256)
    memset(buf, 0, 256)
    var path = "frame_%03d.png"
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.av_get_frame_filename2(
        buf.unsafe_origin_cast[MutExternalOrigin](),
        256,
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        42,
        0,
    )
    assert_equal(ret, 0)
    assert_equal(String(unsafe_from_utf8_ptr=buf), "frame_042.png")


def test_avformat_match_stream_specifier():
    var ctx = avformat.avformat_alloc_context()
    var st = avformat.avformat_new_stream(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    var spec = "v:0"
    var spec_ptr = spec.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_match_stream_specifier(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        st.unsafe_origin_cast[MutExternalOrigin](),
        spec_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_true(ret >= 0)
    avformat.avformat_free_context(ctx)


def test_av_url_split():
    var proto = alloc[c_char](256)
    var auth = alloc[c_char](256)
    var host = alloc[c_char](256)
    var path = alloc[c_char](256)
    var port = alloc[c_int](1)
    memset(proto, 0, 256)
    memset(auth, 0, 256)
    memset(host, 0, 256)
    memset(path, 0, 256)
    var url = "https://example.com:443/path/to/resource"
    var url_ptr = url.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.av_url_split(
        proto.unsafe_origin_cast[MutExternalOrigin](),
        256,
        auth.unsafe_origin_cast[MutExternalOrigin](),
        256,
        host.unsafe_origin_cast[MutExternalOrigin](),
        256,
        port.unsafe_origin_cast[MutExternalOrigin](),
        path.unsafe_origin_cast[MutExternalOrigin](),
        256,
        url_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_true(ret >= 0)
    assert_equal(String(unsafe_from_utf8_ptr=proto), "https")
    assert_equal(String(unsafe_from_utf8_ptr=host), "example.com")
    assert_equal(port[], 443)


def test_avformat_find_stream_info():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_find_best_stream():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    var stream_idx = avformat.av_find_best_stream(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        AVMediaType.AVMEDIA_TYPE_VIDEO._value,
        -1,
        -1,
        UnsafePointer[
            UnsafePointer[AVCodec, ImmutExternalOrigin], ImmutExternalOrigin
        ](unsafe_from_address=0),
        0,
    )
    assert_true(stream_idx >= 0)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_read_frame():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    var pkt_ptr = alloc[UnsafePointer[AVPacket, MutExternalOrigin]](1)
    pkt_ptr[0] = avcodec.av_packet_alloc()
    assert_true(Bool(pkt_ptr[0]))
    ret = avformat.av_read_frame(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        pkt_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
    )
    assert_true(ret >= 0)
    avcodec.av_packet_unref(pkt_ptr[0])
    avcodec.av_packet_free(pkt_ptr)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_get_packet():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    var pb = ctx_ptr[][].pb
    assert_true(Bool(pb))
    var pkt_ptr = alloc[UnsafePointer[AVPacket, MutExternalOrigin]](1)
    pkt_ptr[0] = avcodec.av_packet_alloc()
    assert_true(Bool(pkt_ptr[0]))
    ret = avformat.av_get_packet(
        pb.unsafe_origin_cast[MutExternalOrigin](),
        pkt_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        1024,
    )
    assert_true(ret > 0)
    avcodec.av_packet_unref(pkt_ptr[0])
    avcodec.av_packet_free(pkt_ptr)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_append_packet():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    var pb = ctx_ptr[][].pb
    assert_true(Bool(pb))
    var pkt_ptr = alloc[UnsafePointer[AVPacket, MutExternalOrigin]](1)
    pkt_ptr[0] = avcodec.av_packet_alloc()
    assert_true(Bool(pkt_ptr[0]))
    ret = avformat.av_get_packet(
        pb.unsafe_origin_cast[MutExternalOrigin](),
        pkt_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        512,
    )
    assert_true(ret > 0)
    ret = avformat.av_append_packet(
        pb.unsafe_origin_cast[MutExternalOrigin](),
        pkt_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        256,
    )
    assert_true(ret > 0)
    avcodec.av_packet_unref(pkt_ptr[0])
    avcodec.av_packet_free(pkt_ptr)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_hex_dump_log():
    var buf = alloc[c_uchar](16)
    for i in range(16):
        buf[i] = c_uchar(i)
    avformat.av_hex_dump_log(
        OpaquePointer[MutExternalOrigin](unsafe_from_address=0),
        0,
        buf.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        16,
    )


def test_av_guess_frame_rate():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    var nb_streams = ctx_ptr[][].nb_streams
    assert_true(nb_streams > 0)
    var st = ctx_ptr[][].streams[0]
    var ret_rational = avformat.av_guess_frame_rate(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        st.unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVFrame, MutExternalOrigin](unsafe_from_address=0),
    )
    assert_true(ret_rational.num > 0)
    assert_true(ret_rational.den > 0)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_guess_sample_aspect_ratio():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    var nb_streams = ctx_ptr[][].nb_streams
    assert_true(nb_streams > 0)
    var st = ctx_ptr[][].streams[0]
    var frame = avutil.av_frame_alloc()
    assert_true(Bool(frame))
    _ = avformat.av_guess_sample_aspect_ratio(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        st.unsafe_origin_cast[MutExternalOrigin](),
        frame.unsafe_origin_cast[MutExternalOrigin](),
    )
    # assert_true(ret_rational.num > 0)
    # assert_true(ret_rational.den > 0)
    var frame_ptr = alloc[UnsafePointer[AVFrame, MutExternalOrigin]](1)
    frame_ptr[] = frame
    var frame_ptr_ptr = alloc[type_of(frame_ptr)](1)
    frame_ptr_ptr[] = frame_ptr
    avutil.av_frame_free(frame_ptr_ptr)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_probe_input_format():
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var buf_size = 64
    var pad = AVProbeData.AVPROBE_PADDING_SIZE
    var buf = InlineArray[c_uchar, 64 + 32](uninitialized=True)
    memset(buf.unsafe_ptr(), 0, buf_size + pad)
    var n: Int
    with open(Path(path), "r") as f:
        n = f.read(buffer=buf)
    assert_true(n > 0)
    var filename = "test.h264"
    var filename_ptr = filename.as_c_string_slice().unsafe_ptr().as_immutable()
    var pd_ptr = alloc[AVProbeData](1)
    pd_ptr[0] = AVProbeData(
        filename=filename_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        buf=buf.unsafe_ptr().unsafe_origin_cast[MutExternalOrigin](),
        buf_size=c_int(n),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
    )
    var fmt = avformat.av_probe_input_format(
        pd_ptr.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        0,
    )
    var score_max = alloc[c_int](1)
    score_max[0] = 100
    var fmt2 = avformat.av_probe_input_format2(
        pd_ptr.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        0,
        score_max,
    )
    assert_true(n > 0)
    var score_ret = alloc[c_int](1)
    var fmt3 = avformat.av_probe_input_format3(
        pd_ptr.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        0,
        score_ret,
    )
    _ = fmt
    _ = fmt2
    _ = fmt3
    _ = score_ret


def test_av_probe_input_buffer2():
    var pb_ptr = alloc[UnsafePointer[AVIOContext, MutExternalOrigin]](1)
    memset(pb_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avio_open(
        pb_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        AVIO_FLAG_READ,
    )
    assert_equal(ret, 0)
    assert_true(Bool(pb_ptr[0]))
    var fmt_ptr = alloc[UnsafePointer[AVInputFormat, ImmutExternalOrigin]](1)
    memset(fmt_ptr, 0, 1)
    ret = avformat.av_probe_input_buffer2(
        pb_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        fmt_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        OpaquePointer[MutExternalOrigin](unsafe_from_address=0),
        0,
        0,
    )
    assert_true(ret >= 0)
    ret = avformat.avio_closep(pb_ptr.unsafe_origin_cast[MutExternalOrigin]())
    assert_true(ret >= 0)

    _ = fmt_ptr


def test_av_probe_input_buffer():
    var pb_ptr = alloc[UnsafePointer[AVIOContext, MutExternalOrigin]](1)
    memset(pb_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avio_open(
        pb_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        AVIO_FLAG_READ,
    )
    assert_equal(ret, 0)
    assert_true(Bool(pb_ptr[0]))
    var fmt_ptr = alloc[UnsafePointer[AVInputFormat, ImmutExternalOrigin]](1)
    memset(fmt_ptr, 0, 1)
    ret = avformat.av_probe_input_buffer(
        pb_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        fmt_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        OpaquePointer[MutExternalOrigin](unsafe_from_address=0),
        0,
        0,
    )
    assert_equal(ret, 0)
    ret = avformat.avio_closep(pb_ptr.unsafe_origin_cast[MutExternalOrigin]())
    assert_true(ret >= 0)

    _ = fmt_ptr


def test_av_seek_frame():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    _ = avformat.av_seek_frame(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        -1,
        0,
        0,
    )
    # assert_true(ret >= 0)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_avformat_seek_file():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    ret = avformat.avformat_seek_file(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        -1,
        -9223372036854775808,
        0,
        9223372036854775807,
        0,
    )
    _ = ret
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_avformat_flush():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    avformat.avformat_flush(ctx_ptr[].unsafe_origin_cast[MutExternalOrigin]())
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_read_play_pause():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    avformat.av_read_play(ctx_ptr[].unsafe_origin_cast[MutExternalOrigin]())
    avformat.av_read_pause(ctx_ptr[].unsafe_origin_cast[MutExternalOrigin]())
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_find_program_from_stream():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    var prog = avformat.av_find_program_from_stream(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVProgram, MutExternalOrigin](unsafe_from_address=0),
        0,
    )
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )

    _ = prog


def test_av_program_add_stream_index():
    var ctx = avformat.avformat_alloc_context()
    var prog = avformat.av_new_program(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        1,
    )
    assert_true(Bool(prog))
    avformat.av_program_add_stream_index(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        1,
        0,
    )
    avformat.avformat_free_context(ctx)


def test_av_pkt_dump2():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    var pkt_ptr = alloc[UnsafePointer[AVPacket, MutExternalOrigin]](1)
    pkt_ptr[0] = avcodec.av_packet_alloc()
    ret = avformat.av_read_frame(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        pkt_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
    )
    assert_true(ret >= 0)
    var st = ctx_ptr[][].streams[0]
    var f = fdopen(1, "w".as_c_string_slice().unsafe_ptr().as_immutable())
    avformat.av_pkt_dump2(
        f,
        pkt_ptr[0].as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        0,
        st.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    _ = fflush(f)
    avcodec.av_packet_unref(pkt_ptr[0])
    avcodec.av_packet_free(pkt_ptr)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_pkt_dump_log2():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    var pkt_ptr = alloc[UnsafePointer[AVPacket, MutExternalOrigin]](1)
    pkt_ptr[0] = avcodec.av_packet_alloc()
    ret = avformat.av_read_frame(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        pkt_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
    )
    assert_true(ret >= 0)
    var st = ctx_ptr[][].streams[0]
    avformat.av_pkt_dump_log2(
        OpaquePointer[MutExternalOrigin](unsafe_from_address=0),
        0,
        pkt_ptr[0].as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        0,
        st.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    avcodec.av_packet_unref(pkt_ptr[0])
    avcodec.av_packet_free(pkt_ptr)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_index_search_timestamp():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    var st = ctx_ptr[][].streams[0]
    var idx = avformat.av_index_search_timestamp(
        st.unsafe_origin_cast[MutExternalOrigin](),
        0,
        0,
    )
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )

    _ = idx


def test_avformat_index_get_entries_count():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    var st = ctx_ptr[][].streams[0]
    var count = avformat.avformat_index_get_entries_count(
        st.unsafe_origin_cast[MutExternalOrigin](),
    )
    assert_true(count >= 0)
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_avformat_index_get_entry():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    var st = ctx_ptr[][].streams[0]
    var count = avformat.avformat_index_get_entries_count(
        st.unsafe_origin_cast[MutExternalOrigin](),
    )
    if count > 0:
        var entry = avformat.avformat_index_get_entry(
            st.unsafe_origin_cast[MutExternalOrigin](),
            0,
        )
        _ = entry
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_avformat_index_get_entry_from_timestamp():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_find_stream_info(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](unsafe_from_address=0),
    )
    assert_true(ret >= 0)
    var st = ctx_ptr[][].streams[0]
    var entry = avformat.avformat_index_get_entry_from_timestamp(
        st.unsafe_origin_cast[MutExternalOrigin](),
        0,
        0,
    )
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )

    _ = entry


def test_av_add_index_entry():
    var ctx = avformat.avformat_alloc_context()
    var st = avformat.avformat_new_stream(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    var ret = avformat.av_add_index_entry(
        st.unsafe_origin_cast[MutExternalOrigin](),
        0,
        0,
        100,
        1,
        0,
    )
    assert_true(ret >= 0)
    avformat.avformat_free_context(ctx)


def test_avformat_queue_attached_pictures():
    var ctx_ptr = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var path = String("{}/test_data/testsrc_320x180_30fps_2s.h264").format(
        os.getenv("PIXI_PROJECT_ROOT"),
    )
    var path_ptr = path.as_c_string_slice().unsafe_ptr().as_immutable()
    var ret = avformat.avformat_open_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        path_ptr.unsafe_origin_cast[ImmutExternalOrigin](),
        UnsafePointer[AVInputFormat, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ](
            unsafe_from_address=0,
        ),
    )
    assert_equal(ret, 0)
    ret = avformat.avformat_queue_attached_pictures(
        ctx_ptr[].unsafe_origin_cast[MutExternalOrigin](),
    )
    avformat.avformat_close_input(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )

    _ = ret


def test_av_get_output_timestamp():
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var filename = String("some/path/to/test.mp4")
    var ret = avformat.alloc_output_context(ctx=ctx, filename=filename)
    assert_equal(ret, 0)
    var dts = alloc[c_long_long](1)
    var wall = alloc[c_long_long](1)
    ret = avformat.av_get_output_timestamp(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        0,
        dts,
        wall,
    )
    avformat.avformat_free_context(ctx[])

    _ = ret
    _ = dts
    _ = wall


def test_avformat_write_header_trailer():
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var fmt = avformat.av_guess_format(
        short_name="null".as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin](),
        filename=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
    )
    if not Bool(fmt):
        return
    var filename = String("")
    var ret = avformat.alloc_output_context(
        ctx=ctx,
        oformat=fmt,
        format_name=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        filename=filename,
    )
    if ret < 0:
        return
    var st = avformat.avformat_new_stream(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    if not Bool(st):
        avformat.avformat_free_context(ctx[])

        return
    st[].time_base.num = 1
    st[].time_base.den = 25
    st[].codecpar[].codec_type = AVMediaType.AVMEDIA_TYPE_VIDEO._value
    st[].codecpar[].codec_id = AVCodecID.AV_CODEC_ID_H264._value
    st[].codecpar[].width = 640
    st[].codecpar[].height = 480
    var opt = UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ](
        unsafe_from_address=0,
    )
    ret = avformat.avformat_write_header(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        opt,
    )
    if ret >= 0:
        ret = avformat.av_write_trailer(
            ctx[].unsafe_origin_cast[MutExternalOrigin]()
        )
    avformat.avformat_free_context(ctx[])

    _ = ret
    _ = st


def test_av_sdp_create():
    var ac = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    ac[0] = avformat.avformat_alloc_context()
    assert_true(Bool(ac[0]))
    var buf = alloc[c_char](256)
    memset(buf, 0, 256)
    var ret = avformat.av_sdp_create(
        ac.unsafe_origin_cast[MutExternalOrigin](),
        1,
        buf.unsafe_origin_cast[MutExternalOrigin](),
        256,
    )
    assert_equal(ret, 0)
    avformat.avformat_free_context(ac[0])

    _ = buf


def test_avformat_init_output():
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var fmt = avformat.av_guess_format(
        short_name="null".as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin](),
        filename=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
    )
    if not Bool(fmt):
        return
    var filename = String("")
    var ret = avformat.alloc_output_context(
        ctx=ctx,
        oformat=fmt,
        format_name=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        filename=filename,
    )
    if ret < 0:
        return
    var st = avformat.avformat_new_stream(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    if not Bool(st):
        avformat.avformat_free_context(ctx[])

        return
    st[].time_base.num = 1
    st[].time_base.den = 25
    st[].codecpar[].codec_type = AVMediaType.AVMEDIA_TYPE_VIDEO._value
    st[].codecpar[].codec_id = AVCodecID.AV_CODEC_ID_H264._value
    st[].codecpar[].width = 640
    st[].codecpar[].height = 480
    var opt = UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ](
        unsafe_from_address=0,
    )
    ret = avformat.avformat_init_output(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        opt,
    )
    assert_true(ret >= 0)
    # ret may be < 0 for null muxer without pb; we just verify the API call completes
    avformat.avformat_free_context(ctx[])

    _ = st


def test_av_write_frame():
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var fmt = avformat.av_guess_format(
        short_name="null".as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin](),
        filename=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
    )
    if not Bool(fmt):
        return
    var filename = String("")
    var ret = avformat.alloc_output_context(
        ctx=ctx,
        oformat=fmt,
        format_name=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        filename=filename,
    )
    if ret < 0:
        return
    var st = avformat.avformat_new_stream(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    if not Bool(st):
        avformat.avformat_free_context(ctx[])

        return
    st[].time_base.num = 1
    st[].time_base.den = 25
    st[].codecpar[].codec_type = AVMediaType.AVMEDIA_TYPE_VIDEO._value
    st[].codecpar[].codec_id = AVCodecID.AV_CODEC_ID_H264._value
    st[].codecpar[].width = 640
    st[].codecpar[].height = 480
    var opt = UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ](
        unsafe_from_address=0,
    )
    ret = avformat.avformat_write_header(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        opt,
    )
    if ret >= 0:
        ret = avformat.av_write_frame(
            ctx[].unsafe_origin_cast[MutExternalOrigin](),
            UnsafePointer[AVPacket, MutExternalOrigin](unsafe_from_address=0),
        )
        assert_true(ret >= 0)
        ret = avformat.av_write_trailer(
            ctx[].unsafe_origin_cast[MutExternalOrigin]()
        )
        assert_true(ret >= 0)
    avformat.avformat_free_context(ctx[])

    _ = st


def test_av_interleaved_write_frame():
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var fmt = avformat.av_guess_format(
        short_name="null".as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin](),
        filename=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
    )
    if not Bool(fmt):
        return
    var filename = String("")
    var ret = avformat.alloc_output_context(
        ctx=ctx,
        oformat=fmt,
        format_name=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        filename=filename,
    )
    if ret < 0:
        return
    var st = avformat.avformat_new_stream(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    if not Bool(st):
        avformat.avformat_free_context(ctx[])

        return
    st[].time_base.num = 1
    st[].time_base.den = 25
    st[].codecpar[].codec_type = AVMediaType.AVMEDIA_TYPE_VIDEO._value
    st[].codecpar[].codec_id = AVCodecID.AV_CODEC_ID_H264._value
    st[].codecpar[].width = 640
    st[].codecpar[].height = 480
    var opt = UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ](
        unsafe_from_address=0,
    )
    ret = avformat.avformat_write_header(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        opt,
    )
    if ret >= 0:
        ret = avformat.av_interleaved_write_frame(
            ctx[].unsafe_origin_cast[MutExternalOrigin](),
            UnsafePointer[AVPacket, MutExternalOrigin](unsafe_from_address=0),
        )
        assert_true(ret >= 0)
        ret = avformat.av_write_trailer(
            ctx[].unsafe_origin_cast[MutExternalOrigin]()
        )
        assert_true(ret >= 0)
    avformat.avformat_free_context(ctx[])

    _ = st


def test_av_write_uncoded_frame_query():
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var fmt = avformat.av_guess_format(
        short_name="null".as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin](),
        filename=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
    )
    if not Bool(fmt):
        return
    var filename = String("")
    var ret = avformat.alloc_output_context(
        ctx=ctx,
        oformat=fmt,
        format_name=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        filename=filename,
    )
    if ret < 0:
        return
    var st = avformat.avformat_new_stream(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    if not Bool(st):
        avformat.avformat_free_context(ctx[])

        return
    st[].time_base.num = 1
    st[].time_base.den = 25
    st[].codecpar[].codec_type = AVMediaType.AVMEDIA_TYPE_VIDEO._value
    st[].codecpar[].codec_id = AVCodecID.AV_CODEC_ID_H264._value
    st[].codecpar[].width = 640
    st[].codecpar[].height = 480
    _ = avformat.av_write_uncoded_frame_query(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        0,
    )
    avformat.avformat_free_context(ctx[])

    _ = st


def test_av_write_uncoded_frame():
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var fmt = avformat.av_guess_format(
        short_name="null".as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin](),
        filename=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
    )
    if not Bool(fmt):
        return
    var filename = String("")
    var ret = avformat.alloc_output_context(
        ctx=ctx,
        oformat=fmt,
        format_name=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        filename=filename,
    )
    if ret < 0:
        return
    var st = avformat.avformat_new_stream(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    if not Bool(st):
        avformat.avformat_free_context(ctx[])

        return
    st[].time_base.num = 1
    st[].time_base.den = 25
    st[].codecpar[].codec_type = AVMediaType.AVMEDIA_TYPE_VIDEO._value
    st[].codecpar[].codec_id = AVCodecID.AV_CODEC_ID_H264._value
    st[].codecpar[].width = 640
    st[].codecpar[].height = 480
    var opt = UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ](
        unsafe_from_address=0,
    )
    ret = avformat.avformat_write_header(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        opt,
    )
    if ret >= 0:
        _ = avformat.av_write_uncoded_frame(
            ctx[].unsafe_origin_cast[MutExternalOrigin](),
            0,
            UnsafePointer[AVFrame, MutExternalOrigin](unsafe_from_address=0),
        )
        # assert_true(ret >= 0)
        _ = avformat.av_write_trailer(
            ctx[].unsafe_origin_cast[MutExternalOrigin]()
        )
        # assert_true(ret >= 0)
    avformat.avformat_free_context(ctx[])

    _ = st


def test_av_interleaved_write_uncoded_frame():
    var ctx = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var fmt = avformat.av_guess_format(
        short_name="null".as_c_string_slice()
        .unsafe_ptr()
        .unsafe_origin_cast[ImmutExternalOrigin](),
        filename=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        mime_type=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
    )
    if not Bool(fmt):
        return
    var filename = String("")
    var ret = avformat.alloc_output_context(
        ctx=ctx,
        oformat=fmt,
        format_name=UnsafePointer[c_char, ImmutExternalOrigin](
            unsafe_from_address=0
        ),
        filename=filename,
    )
    if ret < 0:
        return
    var st = avformat.avformat_new_stream(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        UnsafePointer[AVCodec, ImmutExternalOrigin](unsafe_from_address=0),
    )
    if not Bool(st):
        avformat.avformat_free_context(ctx[])

        return
    st[].time_base.num = 1
    st[].time_base.den = 25
    st[].codecpar[].codec_type = AVMediaType.AVMEDIA_TYPE_VIDEO._value
    st[].codecpar[].codec_id = AVCodecID.AV_CODEC_ID_H264._value
    st[].codecpar[].width = 640
    st[].codecpar[].height = 480
    var opt = UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ](
        unsafe_from_address=0,
    )
    ret = avformat.avformat_write_header(
        ctx[].unsafe_origin_cast[MutExternalOrigin](),
        opt,
    )
    if ret >= 0:
        _ = avformat.av_interleaved_write_uncoded_frame(
            ctx[].unsafe_origin_cast[MutExternalOrigin](),
            0,
            UnsafePointer[AVFrame, MutExternalOrigin](unsafe_from_address=0),
        )
        # assert_true(ret >= 0)
        _ = avformat.av_write_trailer(
            ctx[].unsafe_origin_cast[MutExternalOrigin]()
        )
        # assert_true(ret >= 0)
    avformat.avformat_free_context(ctx[])

    _ = st


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
    # test_avformat_init_output()
