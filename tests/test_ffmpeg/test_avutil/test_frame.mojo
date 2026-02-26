from testing.suite import TestSuite
from testing.testing import assert_equal, assert_true
from memory import memset
import sys
import os
from ffi import c_uchar, c_int, c_char
from memory import alloc
from sys._libc_errno import ErrNo
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat

from ash_dynamics.ffmpeg.avutil.frame import (
    AVFrame,
    AVFrameSideData,
    AVFrameSideDataType,
)
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil import Avutil


def test_av_frame_alloc():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    assert_equal(frame[].width, 0)
    assert_equal(frame[].height, 0)
    assert_equal(frame[].format, -1)
    assert_equal(frame[].nb_samples, 0)
    assert_equal(frame[].nb_side_data, 0)
    assert_equal(frame[].flags, 0)

    fn accept_frame(frame: UnsafePointer[AVFrame, MutAnyOrigin]) raises:
        "Test whether frame survives being passed by reference."
        assert_equal(frame[].width, 0)

    accept_frame(frame)
    assert_equal(frame[].flags, 0)
    _ = avutil


def test_av_frame_free():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    avutil.av_frame_free(frame.unsafe_origin_cast[MutExternalOrigin]())
    _ = avutil


def test_av_frame_ref():
    var avutil = Avutil()
    var src = avutil.av_frame_alloc()
    var dst = alloc[AVFrame](1)
    memset(dst, 0, 1)
    src[].width = 640
    src[].height = 480
    src[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    var ret1 = avutil.av_frame_get_buffer(
        src.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_equal(ret1, 0)
    var ret2 = avutil.av_frame_ref(
        dst,
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret2, 0)
    assert_equal(dst[].width, 640)
    assert_equal(dst[].height, 480)
    _ = avutil


def test_av_frame_replace():
    var avutil = Avutil()
    var src = avutil.av_frame_alloc()
    var dst = avutil.av_frame_alloc()
    src[].width = 320
    src[].height = 240
    var ret = avutil.av_frame_replace(
        dst.unsafe_origin_cast[MutExternalOrigin](),
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret, 0)
    assert_equal(dst[].width, 320)
    assert_equal(dst[].height, 240)
    _ = avutil


def test_av_frame_clone():
    var avutil = Avutil()
    var src = avutil.av_frame_alloc()
    src[].width = 1280
    src[].height = 720
    src[].format = AVPixelFormat.AV_PIX_FMT_YUV420P._value
    _ = avutil.av_frame_get_buffer(
        src.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    var clone = avutil.av_frame_clone(
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )
    assert_true(Bool(clone))
    assert_equal(clone[].width, 1280)
    assert_equal(clone[].height, 720)
    _ = avutil


def test_av_frame_unref():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    frame[].width = 100
    avutil.av_frame_unref(frame.unsafe_origin_cast[MutExternalOrigin]())
    assert_equal(frame[].width, 0)
    _ = avutil


def test_av_frame_move_ref():
    var avutil = Avutil()
    var src = avutil.av_frame_alloc()
    var dst = avutil.av_frame_alloc()
    src[].width = 800
    src[].height = 600
    avutil.av_frame_move_ref(
        dst.unsafe_origin_cast[MutExternalOrigin](),
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(dst[].width, 800)
    assert_equal(dst[].height, 600)
    assert_equal(src[].width, 0)
    _ = avutil


def test_av_frame_get_buffer():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    frame[].width = 64
    frame[].height = 64
    frame[].format = 0  # AV_PIX_FMT_YUV420P
    var ret = avutil.av_frame_get_buffer(
        frame.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    assert_equal(ret, 0)
    _ = avutil


def test_av_frame_is_writable():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    # A frame without a buffer is not writable.
    assert_equal(
        avutil.av_frame_is_writable(
            frame.unsafe_origin_cast[MutExternalOrigin]()
        ),
        0,
    )
    _ = avutil


def test_av_frame_make_writable():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    frame[].width = 64
    frame[].height = 64
    frame[].format = 0  # AV_PIX_FMT_YUV420P
    _ = avutil.av_frame_get_buffer(
        frame.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    var ret = avutil.av_frame_make_writable(
        frame.unsafe_origin_cast[MutExternalOrigin]()
    )
    assert_equal(ret, 0)
    assert_equal(
        avutil.av_frame_is_writable(
            frame.unsafe_origin_cast[MutExternalOrigin]()
        ),
        1,
    )
    _ = avutil


def test_av_frame_copy():
    var avutil = Avutil()
    var src = avutil.av_frame_alloc()
    var dst = avutil.av_frame_alloc()
    src[].width = 64
    src[].height = 64
    src[].format = 0  # AV_PIX_FMT_YUV420P
    dst[].width = 64
    dst[].height = 64
    dst[].format = 0
    _ = avutil.av_frame_get_buffer(
        src.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    _ = avutil.av_frame_get_buffer(
        dst.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    var ret = avutil.av_frame_copy(
        dst.unsafe_origin_cast[MutExternalOrigin](),
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret, 0)
    _ = avutil


def test_av_frame_copy_props():
    var avutil = Avutil()
    var src = avutil.av_frame_alloc()
    var dst = avutil.av_frame_alloc()
    src[].pts = 42
    src[].flags = 1
    var ret = avutil.av_frame_copy_props(
        dst.unsafe_origin_cast[MutExternalOrigin](),
        src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(ret, 0)
    assert_equal(dst[].pts, 42)
    assert_equal(dst[].flags, 1)
    _ = avutil


def test_av_frame_get_plane_buffer():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    frame[].width = 64
    frame[].height = 64
    frame[].format = 0  # AV_PIX_FMT_YUV420P
    _ = avutil.av_frame_get_buffer(
        frame.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    var buf = avutil.av_frame_get_plane_buffer(
        frame.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](), 0
    )
    assert_true(Bool(buf))
    _ = avutil


def test_av_frame_new_side_data():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    var sd = avutil.av_frame_new_side_data(
        frame.unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        128,
    )
    assert_true(Bool(sd))
    assert_equal(frame[].nb_side_data, 1)
    _ = avutil


def test_av_frame_new_side_data_from_buf():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    var buf = avutil._av_buffer_alloc(128)
    var sd = avutil.av_frame_new_side_data_from_buf(
        frame.unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        buf,
    )
    assert_true(Bool(sd))
    assert_equal(frame[].nb_side_data, 1)
    _ = avutil


def test_av_frame_get_side_data():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    _ = avutil.av_frame_new_side_data(
        frame.unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        128,
    )
    var sd = avutil.av_frame_get_side_data(
        frame.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
    )
    assert_true(Bool(sd))
    _ = avutil


def test_av_frame_remove_side_data():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    _ = avutil.av_frame_new_side_data(
        frame.unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        128,
    )
    assert_equal(frame[].nb_side_data, 1)
    avutil.av_frame_remove_side_data(
        frame.unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
    )
    assert_equal(frame[].nb_side_data, 0)
    _ = avutil


def test_av_frame_apply_cropping():
    var avutil = Avutil()
    var frame = avutil.av_frame_alloc()
    frame[].width = 64
    frame[].height = 64
    frame[].format = 0  # AV_PIX_FMT_YUV420P
    _ = avutil.av_frame_get_buffer(
        frame.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    frame[].crop_top = 8
    frame[].crop_bottom = 8
    frame[].crop_left = 8
    frame[].crop_right = 8
    var ret = avutil.av_frame_apply_cropping(
        frame.unsafe_origin_cast[MutExternalOrigin](), 0
    )
    if ret != 0:
        print(
            "av_frame_apply_cropping error: {}".format(avutil.av_err2str(ret))
        )
    assert_equal(ret, 0)
    _ = avutil


def test_av_frame_side_data_name():
    var avutil = Avutil()
    var name = avutil.av_frame_side_data_name(
        AVFrameSideDataType.AV_FRAME_DATA_PANSCAN._value
    )
    assert_true(Bool(name))
    _ = avutil


def test_av_frame_side_data_desc():
    var avutil = Avutil()
    var desc = avutil.av_frame_side_data_desc(
        AVFrameSideDataType.AV_FRAME_DATA_PANSCAN._value
    )
    assert_true(Bool(desc))
    _ = avutil


def test_av_frame_side_data_free():
    var avutil = Avutil()
    var sd = alloc[AVFrameSideData](1)
    memset(sd, 0, 1)
    var nb_sd: c_int = 0
    var entry = avutil.av_frame_side_data_new(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        128,
        0,
    )
    assert_true(Bool(entry))
    assert_equal(nb_sd, 1)
    avutil.av_frame_side_data_free(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
    )
    assert_equal(nb_sd, 0)
    _ = avutil


def test_av_frame_side_data_new():
    var avutil = Avutil()
    var sd = alloc[AVFrameSideData](1)
    memset(sd, 0, 1)
    var nb_sd: c_int = 0
    var entry = avutil.av_frame_side_data_new(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        128,
        0,
    )
    assert_true(Bool(entry))
    assert_equal(nb_sd, 1)
    _ = avutil


def test_av_frame_side_data_add():
    var avutil = Avutil()
    var sd = alloc[AVFrameSideData](1)
    memset(sd, 0, 1)
    var nb_sd: c_int = 0
    var buf = avutil._av_buffer_alloc(128)
    var entry = avutil.av_frame_side_data_add(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        buf,
        0,
    )
    assert_true(Bool(entry))
    assert_equal(nb_sd, 1)
    _ = avutil


def test_av_frame_side_data_clone():
    var avutil = Avutil()
    var src_sd = alloc[AVFrameSideData](1)
    memset(src_sd, 0, 1)
    var src_nb_sd = alloc[c_int](1)
    memset(src_nb_sd, 0, 1)
    var src_entry = avutil.av_frame_side_data_new(
        src_sd,
        src_nb_sd,
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        128,
        0,
    )
    assert_true(Bool(src_entry))
    assert_equal(src_nb_sd[], 1)
    var dst_sd = alloc[AVFrameSideData](1)
    memset(dst_sd, 0, 1)
    var dst_nb_sd = alloc[c_int](1)
    memset(dst_nb_sd, 0, 1)
    var ret = avutil.av_frame_side_data_clone(
        dst_sd,
        dst_nb_sd,
        src_entry.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        0,
    )
    assert_equal(ret, 0)
    assert_equal(dst_nb_sd[], 1)
    _ = avutil


def test_av_frame_side_data_get_c():
    var avutil = Avutil()
    var sd = alloc[AVFrameSideData](1)
    memset(sd, 0, 1)
    var nb_sd: c_int = 0
    var entry = avutil.av_frame_side_data_new(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        128,
        0,
    )
    assert_true(Bool(entry))
    assert_equal(nb_sd, 1)
    # After av_frame_side_data_new, first 8 bytes of sd hold the AVFrameSideData**
    # array pointer. Extract it to pass to get_c (which takes AVFrameSideData**).
    var array_ptr = sd.bitcast[
        UnsafePointer[AVFrameSideData, ImmutExternalOrigin]
    ]()[]
    var found = avutil.av_frame_side_data_get(
        array_ptr,
        nb_sd,
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
    )
    assert_true(Bool(found))
    _ = avutil


def test_av_frame_side_data_remove():
    var avutil = Avutil()
    var sd = alloc[AVFrameSideData](1)
    memset(sd, 0, 1)
    var nb_sd: c_int = 0
    var entry = avutil.av_frame_side_data_new(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
        128,
        0,
    )
    assert_true(Bool(entry))
    assert_equal(nb_sd, 1)
    avutil.av_frame_side_data_remove(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
        AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value,
    )
    assert_equal(nb_sd, 0)
    _ = avutil


def test_av_frame_side_data_remove_by_props():
    var avutil = Avutil()
    var sd = alloc[AVFrameSideData](1)
    memset(sd, 0, 1)
    var nb_sd: c_int = 0
    var type = AVFrameSideDataType.AV_FRAME_DATA_REPLAYGAIN._value
    var entry = avutil.av_frame_side_data_new(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
        type,
        128,
        0,
    )
    assert_true(Bool(entry))
    assert_equal(nb_sd, 1)
    # AV_FRAME_DATA_REPLAYGAIN has AV_SIDE_DATA_PROP_GLOBAL; removing by its
    # own props should free the entry and reset nb_sd to 0.
    var desc = avutil.av_frame_side_data_desc(type)
    avutil.av_frame_side_data_remove_by_props(
        sd,
        UnsafePointer(to=nb_sd).unsafe_origin_cast[MutExternalOrigin](),
        desc[].props,
    )
    assert_equal(nb_sd, 0)
    _ = avutil


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()

    # test_av_frame_alloc()
    # test_av_frame_free()
    # test_av_frame_ref()
    # test_av_frame_replace()
    # test_av_frame_clone()
    # test_av_frame_unref()
    # test_av_frame_move_ref()
    # test_av_frame_get_buffer()
    # test_av_frame_is_writable()
    # test_av_frame_make_writable()
    # test_av_frame_copy()
    # test_av_frame_copy_props()
    # test_av_frame_get_plane_buffer()
    # test_av_frame_new_side_data()
    # test_av_frame_new_side_data_from_buf()
    # test_av_frame_get_side_data()
    # test_av_frame_remove_side_data()
    # test_av_frame_side_data_name()
    # test_av_frame_side_data_desc()
    # test_av_frame_apply_cropping()
    # test_av_frame_side_data_new()
    # test_av_frame_side_data_add()
    # test_av_frame_side_data_free()
    # test_av_frame_side_data_clone()
    # test_av_frame_side_data_get_c()
    # test_av_frame_side_data_remove()
    # test_av_frame_side_data_remove_by_props()
