from testing.suite import TestSuite
from testing.testing import assert_true, assert_equal
from memory import alloc, memset
from ffi import c_int, c_uchar, c_long_long, c_double
from ash_dynamics.ffmpeg import avutil
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.channel_layout import (
    AVChannelLayout,
    AV_CH_LAYOUT_STEREO,
    AVMatrixEncoding,
)
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.swrsample import swrsample


def test_swr_get_class():
    var cls = swrsample.swr_get_class()
    assert_true(Bool(cls))


def test_swr_alloc():
    var ctx = swrsample.swr_alloc()
    assert_true(Bool(ctx))
    var ctx_ptr = alloc[UnsafePointer[swrsample.SwrContext, MutExternalOrigin]](
        1
    )
    ctx_ptr[0] = ctx
    swrsample.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())


def test_swr_alloc_and_init():
    var out_layout = alloc[AVChannelLayout](1)
    var in_layout = alloc[AVChannelLayout](1)
    memset(out_layout, 0, 1)
    memset(in_layout, 0, 1)
    _ = avutil.av_channel_layout_from_mask(
        out_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    _ = avutil.av_channel_layout_from_mask(
        in_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    var ctx_ptr = alloc[UnsafePointer[swrsample.SwrContext, MutExternalOrigin]](
        1
    )
    memset(ctx_ptr, 0, 1)
    var ret = swrsample.swr_alloc_set_opts2(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        out_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        48000,
        in_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        44100,
        0,
        UnsafePointer[AVClass, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_equal(ret, 0)
    assert_true(Bool(ctx_ptr[0]))
    var init_ret = swrsample.swr_init(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]()
    )
    assert_equal(init_ret, 0)
    swrsample.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_swr_is_initialized():
    var ctx = swrsample.swr_alloc()
    assert_equal(
        swrsample.swr_is_initialized(
            ctx.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
        ),
        0,
    )
    var ctx_ptr = alloc[UnsafePointer[swrsample.SwrContext, MutExternalOrigin]](
        1
    )
    ctx_ptr[0] = ctx
    swrsample.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())


def test_swr_close():
    var out_layout = alloc[AVChannelLayout](1)
    var in_layout = alloc[AVChannelLayout](1)
    memset(out_layout, 0, 1)
    memset(in_layout, 0, 1)
    _ = avutil.av_channel_layout_from_mask(
        out_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    _ = avutil.av_channel_layout_from_mask(
        in_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    var ctx_ptr = alloc[UnsafePointer[swrsample.SwrContext, MutExternalOrigin]](
        1
    )
    memset(ctx_ptr, 0, 1)
    var ret = swrsample.swr_alloc_set_opts2(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        out_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        48000,
        in_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        44100,
        0,
        UnsafePointer[AVClass, ImmutExternalOrigin](unsafe_from_address=0),
    )
    _ = swrsample.swr_init(ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]())
    swrsample.swr_close(ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]())
    swrsample.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_swr_convert():
    var out_layout = alloc[AVChannelLayout](1)
    var in_layout = alloc[AVChannelLayout](1)
    memset(out_layout, 0, 1)
    memset(in_layout, 0, 1)
    _ = avutil.av_channel_layout_from_mask(
        out_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    _ = avutil.av_channel_layout_from_mask(
        in_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    var ctx_ptr = alloc[UnsafePointer[swrsample.SwrContext, MutExternalOrigin]](
        1
    )
    memset(ctx_ptr, 0, 1)
    var ret = swrsample.swr_alloc_set_opts2(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        out_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        48000,
        in_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        44100,
        0,
        UnsafePointer[AVClass, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_equal(ret, 0)
    var init_ret = swrsample.swr_init(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]()
    )
    assert_equal(init_ret, 0)
    var in_buf = alloc[c_uchar](1024)
    var out_buf = alloc[c_uchar](1024)
    var in_ptrs = alloc[UnsafePointer[c_uchar, ImmutExternalOrigin]](1)
    var out_ptrs = alloc[UnsafePointer[c_uchar, MutExternalOrigin]](1)
    in_ptrs[0] = in_buf.as_immutable()
    out_ptrs[0] = out_buf
    var n = swrsample.swr_convert(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        out_ptrs.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        256,
        in_ptrs.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        256,
    )
    assert_true(n >= 0)
    swrsample.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_swr_next_pts():
    var out_layout = alloc[AVChannelLayout](1)
    var in_layout = alloc[AVChannelLayout](1)
    memset(out_layout, 0, 1)
    memset(in_layout, 0, 1)
    _ = avutil.av_channel_layout_from_mask(
        out_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    _ = avutil.av_channel_layout_from_mask(
        in_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    var ctx_ptr = alloc[UnsafePointer[swrsample.SwrContext, MutExternalOrigin]](
        1
    )
    memset(ctx_ptr, 0, 1)
    var ret = swrsample.swr_alloc_set_opts2(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        out_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        48000,
        in_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        44100,
        0,
        UnsafePointer[AVClass, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_equal(ret, 0)
    var init_ret = swrsample.swr_init(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]()
    )
    assert_equal(init_ret, 0)
    var pts = swrsample.swr_next_pts(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_true(pts >= -1)
    swrsample.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_swr_set_compensation():
    var out_layout = alloc[AVChannelLayout](1)
    var in_layout = alloc[AVChannelLayout](1)
    memset(out_layout, 0, 1)
    memset(in_layout, 0, 1)
    _ = avutil.av_channel_layout_from_mask(
        out_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    _ = avutil.av_channel_layout_from_mask(
        in_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    var ctx_ptr = alloc[UnsafePointer[swrsample.SwrContext, MutExternalOrigin]](
        1
    )
    memset(ctx_ptr, 0, 1)
    var ret = swrsample.swr_alloc_set_opts2(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        out_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        48000,
        in_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        44100,
        0,
        UnsafePointer[AVClass, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_equal(ret, 0)
    var init_ret = swrsample.swr_init(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]()
    )
    assert_equal(init_ret, 0)
    var ret1 = swrsample.swr_set_compensation(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin](), 0, 0
    )
    assert_equal(ret1, 0)
    swrsample.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_swr_set_channel_mapping():
    var out_layout = alloc[AVChannelLayout](1)
    var in_layout = alloc[AVChannelLayout](1)
    memset(out_layout, 0, 1)
    memset(in_layout, 0, 1)
    _ = avutil.av_channel_layout_from_mask(
        out_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    _ = avutil.av_channel_layout_from_mask(
        in_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    var ctx_ptr = alloc[UnsafePointer[swrsample.SwrContext, MutExternalOrigin]](
        1
    )
    memset(ctx_ptr, 0, 1)
    var ret = swrsample.swr_alloc_set_opts2(
        ctx_ptr.unsafe_origin_cast[MutExternalOrigin](),
        out_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        48000,
        in_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVSampleFormat.AV_SAMPLE_FMT_S16._value,
        44100,
        0,
        UnsafePointer[AVClass, ImmutExternalOrigin](unsafe_from_address=0),
    )
    # Must be called before swr_init: context allocated but not yet initialized.
    var map = alloc[c_int](2)
    map[0] = 0
    map[1] = 1
    var ret1 = swrsample.swr_set_channel_mapping(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        map.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret1, 0)
    var init_ret = swrsample.swr_init(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]()
    )
    assert_equal(init_ret, 0)
    swrsample.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_swr_build_matrix2():
    var out_layout = alloc[AVChannelLayout](1)
    var in_layout = alloc[AVChannelLayout](1)
    memset(out_layout, 0, 1)
    memset(in_layout, 0, 1)
    _ = avutil.av_channel_layout_from_mask(
        out_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    _ = avutil.av_channel_layout_from_mask(
        in_layout.unsafe_origin_cast[MutExternalOrigin](),
        AV_CH_LAYOUT_STEREO,
    )
    var matrix = alloc[c_double](4)
    var ret1 = swrsample.swr_build_matrix2(
        in_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        out_layout.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        matrix.unsafe_origin_cast[MutExternalOrigin](),
        2,
        AVMatrixEncoding.AV_MATRIX_ENCODING_NONE._value,
        UnsafePointer[AVClass, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_equal(ret1, 0)
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
