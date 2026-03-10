from std.testing import TestSuite, assert_equal, assert_true
from std.memory import alloc, memset

from ash_dynamics.ffmpeg import avcodec
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID


def test_avcodec_find_encoder():
    var codec = avcodec.avcodec_find_encoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(codec))


def test_av_codec_iterate():
    var opaque = alloc[OpaquePointer[MutExternalOrigin]](1)
    memset(opaque, 0, 1)
    var count = 0
    while True:
        var codec = avcodec.av_codec_iterate(
            opaque,
        )
        if not Bool(codec):
            break
        count += 1
    assert_true(count > 0)


def test_avcodec_find_decoder_by_name():
    var name = String("h264")
    var codec = avcodec.avcodec_find_decoder_by_name(name)
    assert_true(Bool(codec))


def test_avcodec_find_encoder_by_name():
    var name = String("mpeg4")
    var codec = avcodec.avcodec_find_encoder_by_name(name)
    assert_true(Bool(codec))


def test_av_codec_is_encoder():
    var encoder = avcodec.avcodec_find_encoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(encoder))
    var is_enc = avcodec.av_codec_is_encoder(
        encoder.as_immutable(),
    )
    assert_equal(is_enc, 1)
    var decoder = avcodec.avcodec_find_decoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(decoder))
    is_enc = avcodec.av_codec_is_encoder(
        decoder.as_immutable(),
    )
    assert_equal(is_enc, 0)


def test_av_codec_is_decoder():
    var decoder = avcodec.avcodec_find_decoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(decoder))
    var is_dec = avcodec.av_codec_is_decoder(
        decoder.as_immutable(),
    )
    assert_equal(is_dec, 1)
    var encoder = avcodec.avcodec_find_encoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(encoder))
    is_dec = avcodec.av_codec_is_decoder(
        encoder.as_immutable(),
    )
    assert_equal(is_dec, 0)


def test_av_get_profile_name():
    var codec = avcodec.avcodec_find_decoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(codec))
    var name = avcodec.av_get_profile_name(
        codec.as_immutable(),
        -99,
    )
    var name_main = avcodec.av_get_profile_name(
        codec.as_immutable(),
        66,
    )
    _ = name
    _ = name_main


def test_avcodec_get_hw_config():
    var codec = avcodec.avcodec_find_decoder(
        AVCodecID.AV_CODEC_ID_H264._value,
    )
    assert_true(Bool(codec))
    var config = avcodec.avcodec_get_hw_config(
        codec.as_immutable(),
        0,
    )
    _ = config


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
