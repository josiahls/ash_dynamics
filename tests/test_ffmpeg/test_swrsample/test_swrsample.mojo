from testing.suite import TestSuite
from testing.testing import assert_true, assert_equal
from memory import alloc, memset
from ffi import c_int, c_uchar, c_long_long, c_double
from ash_dynamics.ffmpeg.swrsample import Swrsample
from ash_dynamics.ffmpeg.avutil import Avutil
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.channel_layout import (
    AVChannelLayout,
    AV_CH_LAYOUT_STEREO,
    AVMatrixEncoding,
)
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.swrsample.swrsample import SwrContext


def test_swr_get_class():
    var swr = Swrsample()
    var cls = swr.swr_get_class()
    assert_true(Bool(cls))
    _ = swr


def test_swr_alloc():
    var swr = Swrsample()
    var ctx = swr.swr_alloc()
    assert_true(Bool(ctx))
    var ctx_ptr = alloc[UnsafePointer[SwrContext, MutExternalOrigin]](1)
    ctx_ptr[0] = ctx
    swr.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    _ = swr


def test_swr_alloc_and_init():
    var swr = Swrsample()
    var avutil = Avutil()
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
    var ctx_ptr = alloc[UnsafePointer[SwrContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    var ret = swr.swr_alloc_set_opts2(
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
    var init_ret = swr.swr_init(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]()
    )
    assert_equal(init_ret, 0)
    swr.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    _ = swr
    _ = avutil


def test_swr_is_initialized():
    var swr = Swrsample()
    var ctx = swr.swr_alloc()
    assert_equal(
        swr.swr_is_initialized(
            ctx.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
        ),
        0,
    )
    var ctx_ptr = alloc[UnsafePointer[SwrContext, MutExternalOrigin]](1)
    ctx_ptr[0] = ctx
    swr.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    _ = swr


def test_swr_close():
    var swr = Swrsample()
    var avutil = Avutil()
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
    var ctx_ptr = alloc[UnsafePointer[SwrContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    _ = swr.swr_alloc_set_opts2(
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
    _ = swr.swr_init(ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]())
    swr.swr_close(ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]())
    swr.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    _ = swr
    _ = avutil


def test_swr_convert():
    var swr = Swrsample()
    var avutil = Avutil()
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
    var ctx_ptr = alloc[UnsafePointer[SwrContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    _ = swr.swr_alloc_set_opts2(
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
    _ = swr.swr_init(ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]())
    var in_buf = alloc[c_uchar](1024)
    var out_buf = alloc[c_uchar](1024)
    var in_ptrs = alloc[UnsafePointer[c_uchar, ImmutExternalOrigin]](1)
    var out_ptrs = alloc[UnsafePointer[c_uchar, MutExternalOrigin]](1)
    in_ptrs[0] = in_buf.as_immutable()
    out_ptrs[0] = out_buf
    var n = swr.swr_convert(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        out_ptrs.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        256,
        in_ptrs.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        256,
    )
    assert_true(n >= 0)
    swr.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    _ = swr
    _ = avutil


def test_swr_next_pts():
    var swr = Swrsample()
    var avutil = Avutil()
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
    var ctx_ptr = alloc[UnsafePointer[SwrContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    _ = swr.swr_alloc_set_opts2(
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
    _ = swr.swr_init(ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]())
    var pts = swr.swr_next_pts(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_true(pts >= -1)
    swr.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    _ = swr
    _ = avutil


def test_swr_set_compensation():
    var swr = Swrsample()
    var avutil = Avutil()
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
    var ctx_ptr = alloc[UnsafePointer[SwrContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    _ = swr.swr_alloc_set_opts2(
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
    _ = swr.swr_init(ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]())
    var ret = swr.swr_set_compensation(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin](), 0, 0
    )
    assert_equal(ret, 0)
    swr.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    _ = swr
    _ = avutil


def test_swr_set_channel_mapping():
    var swr = Swrsample()
    var avutil = Avutil()
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
    var ctx_ptr = alloc[UnsafePointer[SwrContext, MutExternalOrigin]](1)
    memset(ctx_ptr, 0, 1)
    _ = swr.swr_alloc_set_opts2(
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
    var ret = swr.swr_set_channel_mapping(
        ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin](),
        map.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret, 0)
    _ = swr.swr_init(ctx_ptr[0].unsafe_origin_cast[MutExternalOrigin]())
    swr.swr_free(ctx_ptr.unsafe_origin_cast[MutExternalOrigin]())
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    _ = swr
    _ = avutil


def test_swr_build_matrix2():
    var swr = Swrsample()
    var avutil = Avutil()
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
    var ret = swr.swr_build_matrix2(
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
    assert_equal(ret, 0)
    avutil.av_channel_layout_uninit(
        out_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    avutil.av_channel_layout_uninit(
        in_layout.unsafe_origin_cast[MutExternalOrigin]()
    )
    _ = swr
    _ = avutil


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
