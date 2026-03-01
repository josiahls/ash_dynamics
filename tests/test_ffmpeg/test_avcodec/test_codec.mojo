from testing.suite import TestSuite
from testing.testing import assert_equal, assert_true

from memory import alloc, memset

from ash_dynamics.ffmpeg.avcodec import Avcodec
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID


def test_avcodec_find_encoder():
    var avcodec = Avcodec()
    var codec = avcodec.avcodec_find_encoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(codec))
    _ = avcodec


def test_av_codec_iterate():
    var avcodec = Avcodec()
    var opaque = alloc[OpaquePointer[MutExternalOrigin]](1)
    memset(opaque, 0, 1)
    var count = 0
    while True:
        var codec = avcodec.av_codec_iterate(
            opaque.unsafe_origin_cast[MutExternalOrigin](),
        )
        if not Bool(codec):
            break
        count += 1
    assert_true(count > 0)
    _ = avcodec


def test_avcodec_find_decoder_by_name():
    var avcodec = Avcodec()
    var name = String("h264")
    var codec = avcodec.avcodec_find_decoder_by_name(name)
    assert_true(Bool(codec))
    _ = avcodec


def test_avcodec_find_encoder_by_name():
    var avcodec = Avcodec()
    var name = String("mpeg4")
    var codec = avcodec.avcodec_find_encoder_by_name(name)
    assert_true(Bool(codec))
    _ = avcodec


def test_av_codec_is_encoder():
    var avcodec = Avcodec()
    var encoder = avcodec.avcodec_find_encoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(encoder))
    var is_enc = avcodec.av_codec_is_encoder(
        encoder.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(is_enc, 1)
    var decoder = avcodec.avcodec_find_decoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(decoder))
    is_enc = avcodec.av_codec_is_encoder(
        decoder.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(is_enc, 0)
    _ = avcodec


def test_av_codec_is_decoder():
    var avcodec = Avcodec()
    var decoder = avcodec.avcodec_find_decoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(decoder))
    var is_dec = avcodec.av_codec_is_decoder(
        decoder.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(is_dec, 1)
    var encoder = avcodec.avcodec_find_encoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(encoder))
    is_dec = avcodec.av_codec_is_decoder(
        encoder.unsafe_origin_cast[ImmutExternalOrigin](),
    )
    assert_equal(is_dec, 0)
    _ = avcodec


def test_av_get_profile_name():
    var avcodec = Avcodec()
    var codec = avcodec.avcodec_find_decoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(codec))
    var name = avcodec.av_get_profile_name(
        codec.unsafe_origin_cast[ImmutExternalOrigin](),
        -99,
    )
    var name_main = avcodec.av_get_profile_name(
        codec.unsafe_origin_cast[ImmutExternalOrigin](),
        66,
    )
    _ = name
    _ = name_main
    _ = avcodec


def test_avcodec_get_hw_config():
    var avcodec = Avcodec()
    var codec = avcodec.avcodec_find_decoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(codec))
    var config = avcodec.avcodec_get_hw_config(
        codec.unsafe_origin_cast[ImmutExternalOrigin](),
        0,
    )
    _ = config
    _ = avcodec


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
