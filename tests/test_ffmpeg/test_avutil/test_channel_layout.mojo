from testing.testing import assert_true, assert_equal
from testing.suite import TestSuite
from memory import alloc, memset
from ffi import c_char, c_int, c_size_t, c_ulong_long
from ash_dynamics.ffmpeg.avutil.channel_layout import (
    AVChannel,
    AVChannelLayout,
    AVChannelOrder,
    AV_CH_LAYOUT_STEREO,
)
from ash_dynamics.ffmpeg.avutil import Avutil


def test_av_channel_name():
    var avutil = Avutil()
    var buf = alloc[c_char](64).unsafe_origin_cast[origin_of(avutil)]()
    var ret = avutil.av_channel_name(
        buf,
        64,
        AVChannel.AV_CHAN_FRONT_LEFT._value,
    )
    assert_true(ret >= 0)


def test_av_channel_description():
    var avutil = Avutil()
    var buf = alloc[c_char](64).unsafe_origin_cast[origin_of(avutil)]()
    var ret = avutil.av_channel_description(
        buf,
        64,
        AVChannel.AV_CHAN_FRONT_LEFT._value,
    )
    assert_true(ret >= 0)


def test_av_channel_from_string():
    var avutil = Avutil()
    var ch = avutil.av_channel_from_string(
        "FL".as_c_string_slice().unsafe_ptr().as_immutable()
    )
    assert_equal(Int(ch), Int(AVChannel.AV_CHAN_FRONT_LEFT._value))


def test_av_channel_layout_custom_init():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret = avutil.av_channel_layout_custom_init(
        layout,
        2,
    )
    assert_equal(ret, 0)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_from_mask():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret, 0)
    assert_equal(layout[].nb_channels, 2)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_from_string():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret = avutil.av_channel_layout_from_string(
        layout, "stereo".as_c_string_slice().unsafe_ptr().as_immutable()
    )
    assert_equal(ret, 0)
    assert_equal(layout[].nb_channels, 2)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_default():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    avutil.av_channel_layout_default(
        layout,
        2,
    )
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_standard():
    var avutil = Avutil()
    var opaque_ptr = alloc[OpaquePointer[MutAnyOrigin]](1)
    memset(opaque_ptr, 0, 1)
    var layout = avutil.av_channel_layout_standard(opaque_ptr)
    assert_true(Bool(layout))


def test_av_channel_layout_uninit():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret, 0)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_copy():
    var avutil = Avutil()
    var src = alloc[AVChannelLayout](1).unsafe_origin_cast[origin_of(avutil)]()
    memset(src, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        src,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var dst = alloc[AVChannelLayout](1).unsafe_origin_cast[origin_of(avutil)]()
    memset(dst, 0, 1)
    var ret2 = avutil.av_channel_layout_copy(
        dst,
        src.as_immutable(),
    )
    assert_equal(ret2, 0)
    assert_equal(dst[].nb_channels, 2)
    avutil.av_channel_layout_uninit(dst)
    avutil.av_channel_layout_uninit(src)


def test_av_channel_layout_describe():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var buf = alloc[c_char](64).unsafe_origin_cast[origin_of(avutil)]()
    var ret2 = avutil.av_channel_layout_describe(
        layout.as_immutable(),
        buf,
        64,
    )
    assert_true(ret2 >= 0)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_channel_from_index():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var ch = avutil.av_channel_layout_channel_from_index(
        layout.as_immutable(),
        0,
    )
    assert_equal(Int(ch), Int(AVChannel.AV_CHAN_FRONT_LEFT._value))
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_index_from_channel():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var idx = avutil.av_channel_layout_index_from_channel(
        layout.as_immutable(),
        AVChannel.AV_CHAN_FRONT_RIGHT._value,
    )
    assert_true(idx >= 0)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_index_from_string():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var idx = avutil.av_channel_layout_index_from_string(
        layout.as_immutable(),
        "FR".as_c_string_slice().unsafe_ptr().as_immutable(),
    )
    assert_equal(idx, 1)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_channel_from_string():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var ch = avutil.av_channel_layout_channel_from_string(
        layout.as_immutable(),
        "FR".as_c_string_slice().unsafe_ptr().as_immutable(),
    )
    assert_equal(Int(ch), Int(AVChannel.AV_CHAN_FRONT_RIGHT._value))
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_subset():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var mask = avutil.av_channel_layout_subset(
        layout.as_immutable(),
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(Int(mask), Int(AV_CH_LAYOUT_STEREO))
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_check():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var ret2 = avutil.av_channel_layout_check(
        layout.as_immutable(),
    )
    assert_true(ret2 >= 0)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_compare():
    var avutil = Avutil()
    var layout1 = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    var layout2 = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout1, 0, 1)
    memset(layout2, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout1,
        AV_CH_LAYOUT_STEREO,
    )
    var ret2 = avutil.av_channel_layout_from_mask(
        layout2,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    assert_equal(ret2, 0)
    var cmp_ret = avutil.av_channel_layout_compare(
        layout1.as_immutable(),
        layout2.as_immutable(),
    )
    assert_equal(cmp_ret, 0)
    avutil.av_channel_layout_uninit(layout1)
    avutil.av_channel_layout_uninit(layout2)


def test_av_channel_layout_ambisonic_order():
    var avutil = Avutil()
    # Stereo is not ambisonic; function returns negative AVERROR. Just check no crash.
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var order = avutil.av_channel_layout_ambisonic_order(
        layout.as_immutable(),
    )
    assert_true(order < 0)
    avutil.av_channel_layout_uninit(layout)


def test_av_channel_layout_retype():
    var avutil = Avutil()
    var layout = alloc[AVChannelLayout](1).unsafe_origin_cast[
        origin_of(avutil)
    ]()
    memset(layout, 0, 1)
    var ret1 = avutil.av_channel_layout_from_mask(
        layout,
        AV_CH_LAYOUT_STEREO,
    )
    assert_equal(ret1, 0)
    var ret2 = avutil.av_channel_layout_retype(
        layout,
        AVChannelOrder.AV_CHANNEL_ORDER_NATIVE._value,
        0,
    )
    assert_equal(ret2, 0)
    avutil.av_channel_layout_uninit(layout)


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
    # test_av_channel_name()
    # test_av_channel_description()
    # test_av_channel_from_string()
    # test_av_channel_layout_custom_init()
    # test_av_channel_layout_from_mask()
    # test_av_channel_layout_from_string()
    # test_av_channel_layout_default()
    # test_av_channel_layout_standard()
    # test_av_channel_layout_uninit()
    # test_av_channel_layout_describe()
    # test_av_channel_layout_channel_from_index()
    # test_av_channel_layout_index_from_channel()
    # test_av_channel_layout_index_from_string()
    # test_av_channel_layout_channel_from_string()
    # test_av_channel_layout_subset()
    # test_av_channel_layout_check()
    # test_av_channel_layout_compare()
    # test_av_channel_layout_ambisonic_order()
    # test_av_channel_layout_retype()
