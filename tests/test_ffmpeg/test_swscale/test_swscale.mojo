from testing.suite import TestSuite
from testing.testing import assert_true, assert_equal
from memory import alloc, memset
from ffi import c_double, c_int, c_uchar
from ash_dynamics.ffmpeg.swscale import Swscale
from ash_dynamics.ffmpeg.swscale.swscale import SwsFilter
from ash_dynamics.ffmpeg.avutil import Avutil
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avutil.pixfmt import (
    AVPixelFormat,
    AVColorSpace,
    AVColorPrimaries,
    AVColorTransferCharacteristic,
)


def test_swscale_version():
    var sws = Swscale()
    var v = sws.swscale_version()
    assert_true(v > 0)
    _ = sws


def test_swscale_configuration():
    var sws = Swscale()
    var cfg = sws.swscale_configuration()
    assert_true(Bool(cfg))
    _ = sws


def test_swscale_license():
    var sws = Swscale()
    var lic = sws.swscale_license()
    assert_true(Bool(lic))
    _ = sws


def test_sws_get_class():
    var sws = Swscale()
    var cls = sws.sws_get_class()
    assert_true(Bool(cls))
    _ = sws


def test_sws_test_format():
    var sws = Swscale()
    var ret = sws.sws_test_format(AVPixelFormat.AV_PIX_FMT_YUV420P._value, 0)
    assert_true(ret >= 0)
    _ = sws


def test_sws_test_colorspace():
    var sws = Swscale()
    var ret = sws.sws_test_colorspace(AVColorSpace.AVCOL_SPC_BT709._value, 0)
    assert_true(ret >= 0)
    _ = sws


def test_sws_test_primaries():
    var sws = Swscale()
    var ret = sws.sws_test_primaries(AVColorPrimaries.AVCOL_PRI_BT709._value, 0)
    assert_true(ret >= 0)
    _ = sws


def test_sws_test_transfer():
    var sws = Swscale()
    var ret = sws.sws_test_transfer(
        AVColorTransferCharacteristic.AVCOL_TRC_BT709._value, 0
    )
    assert_true(ret >= 0)
    _ = sws


def test_sws_isSupportedInput():
    var sws = Swscale()
    var ret = sws.sws_isSupportedInput(AVPixelFormat.AV_PIX_FMT_YUV420P._value)
    assert_true(ret >= 0)
    _ = sws


def test_sws_isSupportedOutput():
    var sws = Swscale()
    var ret = sws.sws_isSupportedOutput(AVPixelFormat.AV_PIX_FMT_YUV420P._value)
    assert_true(ret >= 0)
    _ = sws


def test_sws_isSupportedEndiannessConversion():
    var sws = Swscale()
    var ret = sws.sws_isSupportedEndiannessConversion(
        AVPixelFormat.AV_PIX_FMT_YUV420P._value
    )
    assert_true(ret >= 0)
    _ = sws


def test_sws_getCoefficients():
    var sws = Swscale()
    var coeffs = sws.sws_getCoefficients(5)
    assert_true(Bool(coeffs))
    _ = sws


def test_sws_getContext_and_free():
    var sws = Swscale()
    var ctx = sws.sws_getContext(
        640,
        480,
        AVPixelFormat.AV_PIX_FMT_YUV420P._value,
        320,
        240,
        AVPixelFormat.AV_PIX_FMT_YUV420P._value,
        0,
        UnsafePointer[SwsFilter, MutExternalOrigin](unsafe_from_address=0),
        UnsafePointer[SwsFilter, MutExternalOrigin](unsafe_from_address=0),
        UnsafePointer[c_double, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_true(Bool(ctx))
    sws.sws_freeContext(ctx.unsafe_origin_cast[MutExternalOrigin]())
    _ = sws


def test_sws_getDefaultFilter_and_free():
    var sws = Swscale()
    var f = sws.sws_getDefaultFilter(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
    assert_true(Bool(f))
    sws.sws_freeFilter(f.unsafe_origin_cast[MutExternalOrigin]())
    _ = sws


def test_sws_allocVec_and_free():
    var sws = Swscale()
    var v = sws.sws_allocVec(16)
    assert_true(Bool(v))
    sws.sws_freeVec(v.unsafe_origin_cast[MutExternalOrigin]())
    _ = sws


def test_sws_getGaussianVec():
    var sws = Swscale()
    var v = sws.sws_getGaussianVec(1.0, 1.0)
    assert_true(Bool(v))
    _ = sws


def test_sws_scaleVec():
    var sws = Swscale()
    var v = sws.sws_allocVec(8)
    assert_true(Bool(v))
    sws.sws_scaleVec(v.unsafe_origin_cast[MutExternalOrigin](), 2.0)
    sws.sws_freeVec(v.unsafe_origin_cast[MutExternalOrigin]())
    _ = sws


def test_sws_normalizeVec():
    var sws = Swscale()
    var v = sws.sws_allocVec(8)
    assert_true(Bool(v))
    sws.sws_normalizeVec(v.unsafe_origin_cast[MutExternalOrigin](), 1.0)
    sws.sws_freeVec(v.unsafe_origin_cast[MutExternalOrigin]())
    _ = sws


def test_sws_test_frame():
    var avutil = Avutil()
    var sws = Swscale()
    var frame = avutil.av_frame_alloc()
    frame[].width = 640
    frame[].height = 480
    frame[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    var ret = avutil.av_frame_get_buffer(
        frame.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_equal(ret, 0)
    var test_ret = sws.sws_test_frame(
        frame.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](), 0
    )
    assert_true(test_ret >= 0)
    _ = avutil
    _ = sws


def test_sws_scale_frame():
    var avutil = Avutil()
    var sws = Swscale()
    var src = avutil.av_frame_alloc()
    src[].width = 640
    src[].height = 480
    src[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    var ret1 = avutil.av_frame_get_buffer(
        src.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_equal(ret1, 0)
    var dst = avutil.av_frame_alloc()
    dst[].width = 320
    dst[].height = 240
    dst[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    var ret2 = avutil.av_frame_get_buffer(
        dst.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_equal(ret2, 0)
    var ctx = sws.sws_getContext(
        640,
        480,
        AVPixelFormat.AV_PIX_FMT_YUV420P._value,
        320,
        240,
        AVPixelFormat.AV_PIX_FMT_YUV420P._value,
        0,
        UnsafePointer[SwsFilter, MutExternalOrigin](unsafe_from_address=0),
        UnsafePointer[SwsFilter, MutExternalOrigin](unsafe_from_address=0),
        UnsafePointer[c_double, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_true(Bool(ctx))
    var scale_ret = sws.sws_scale_frame(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        dst.unsafe_origin_cast[MutExternalOrigin](),
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(scale_ret, 240)
    sws.sws_freeContext(ctx.unsafe_origin_cast[MutExternalOrigin]())
    _ = avutil
    _ = sws


def test_sws_scale():
    var avutil = Avutil()
    var sws = Swscale()
    var src_frame = avutil.av_frame_alloc()
    src_frame[].width = 64
    src_frame[].height = 48
    src_frame[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    var ret1 = avutil.av_frame_get_buffer(
        src_frame.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_equal(ret1, 0)
    var dst_frame = avutil.av_frame_alloc()
    dst_frame[].width = 32
    dst_frame[].height = 24
    dst_frame[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    var ret2 = avutil.av_frame_get_buffer(
        dst_frame.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_equal(ret2, 0)
    var ctx = sws.sws_getContext(
        64,
        48,
        AVPixelFormat.AV_PIX_FMT_YUV420P._value,
        32,
        24,
        AVPixelFormat.AV_PIX_FMT_YUV420P._value,
        0,
        UnsafePointer[SwsFilter, MutExternalOrigin](unsafe_from_address=0),
        UnsafePointer[SwsFilter, MutExternalOrigin](unsafe_from_address=0),
        UnsafePointer[c_double, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_true(Bool(ctx))
    var src_slice = alloc[UnsafePointer[c_uchar, ImmutExternalOrigin]](8)
    for i in range(8):
        src_slice[i] = src_frame[].data[i].as_immutable()
    var dst_slice = alloc[UnsafePointer[c_uchar, MutExternalOrigin]](8)
    for i in range(8):
        dst_slice[i] = dst_frame[].data[i]
    var scale_ret = sws.sws_scale(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        src_slice.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        src_frame[]
        .linesize.unsafe_ptr()
        .as_immutable()
        .unsafe_origin_cast[ImmutExternalOrigin](),
        0,
        48,
        dst_slice.unsafe_origin_cast[MutExternalOrigin](),
        dst_frame[]
        .linesize.unsafe_ptr()
        .as_immutable()
        .unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(scale_ret, 24)
    sws.sws_freeContext(ctx.unsafe_origin_cast[MutExternalOrigin]())
    _ = avutil
    _ = sws


def test_sws_is_noop():
    var avutil = Avutil()
    var sws = Swscale()
    var src = avutil.av_frame_alloc()
    src[].width = 64
    src[].height = 48
    src[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    _ = avutil.av_frame_get_buffer(
        src.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    var dst = avutil.av_frame_alloc()
    dst[].width = 64
    dst[].height = 48
    dst[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    _ = avutil.av_frame_get_buffer(
        dst.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    var noop = sws.sws_is_noop(
        dst.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(noop, 1)
    _ = avutil
    _ = sws


def test_sws_frame_setup():
    var avutil = Avutil()
    var sws = Swscale()
    var ctx = sws.sws_getContext(
        64,
        48,
        AVPixelFormat.AV_PIX_FMT_YUV420P._value,
        32,
        24,
        AVPixelFormat.AV_PIX_FMT_YUV420P._value,
        0,
        UnsafePointer[SwsFilter, MutExternalOrigin](unsafe_from_address=0),
        UnsafePointer[SwsFilter, MutExternalOrigin](unsafe_from_address=0),
        UnsafePointer[c_double, ImmutExternalOrigin](unsafe_from_address=0),
    )
    assert_true(Bool(ctx))
    var src = avutil.av_frame_alloc()
    src[].width = 64
    src[].height = 48
    src[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    _ = avutil.av_frame_get_buffer(
        src.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    var dst = avutil.av_frame_alloc()
    dst[].width = 32
    dst[].height = 24
    dst[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    _ = avutil.av_frame_get_buffer(
        dst.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    var ret = sws.sws_frame_setup(
        ctx.unsafe_origin_cast[MutExternalOrigin](),
        dst.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret, 0)
    sws.sws_freeContext(ctx.unsafe_origin_cast[MutExternalOrigin]())
    _ = avutil
    _ = sws


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
