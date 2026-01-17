"https://www.ffmpeg.org/doxygen/8.0/codec_8h.html"
from sys.ffi import c_char, c_int, c_uchar
from ash_dynamics.primitives._clib import (
    Debug,
    ExternalFunction,
)

from reflection import get_type_name
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.hwcontext import AVHWDeviceType
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout


comptime AV_CODEC_CAP_DRAW_HORIZ_BAND = c_int(1 << 0)

comptime AV_CODEC_CAP_DR1 = c_int(1 << 1)

comptime AV_CODEC_CAP_DELAY = c_int(1 << 5)

comptime AV_CODEC_CAP_SMALL_LAST_FRAME = c_int(1 << 6)

comptime AV_CODEC_CAP_EXPERIMENTAL = c_int(1 << 9)

comptime AV_CODEC_CAP_CHANNEL_CONF = c_int(1 << 10)

comptime AV_CODEC_CAP_FRAME_THREADS = c_int(1 << 12)

comptime AV_CODEC_CAP_SLICE_THREADS = c_int(1 << 13)

comptime AV_CODEC_CAP_PARAM_CHANGE = c_int(1 << 14)

comptime AV_CODEC_CAP_OTHER_THREADS = c_int(1 << 15)

comptime AV_CODEC_CAP_VARIABLE_FRAME_SIZE = c_int(1 << 16)

comptime AV_CODEC_CAP_AVOID_PROBING = c_int(1 << 17)

comptime AV_CODEC_CAP_HARDWARE = c_int(1 << 18)

comptime AV_CODEC_CAP_HYBRID = c_int(1 << 19)

comptime AV_CODEC_CAP_ENCODER_REORDERED_OPAQUE = c_int(1 << 20)

comptime AV_CODEC_CAP_ENCODER_FLUSH = c_int(1 << 21)

comptime AV_CODEC_CAP_ENCODER_RECON_FRAME = c_int(1 << 22)


@register_passable("trivial")
struct AVProfile(Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVProfile.html"

    var profile: c_int
    var name: UnsafePointer[c_char, ImmutExternalOrigin]


@register_passable("trivial")
@fieldwise_init
struct AVCodec(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodec.html"

    var name: UnsafePointer[c_char, ImmutExternalOrigin]
    var long_name: UnsafePointer[c_char, ImmutExternalOrigin]

    var type: AVMediaType.ENUM_DTYPE
    var id: AVCodecID.ENUM_DTYPE

    var capabilities: c_int
    var max_lowres: c_uchar

    var supported_framerates: UnsafePointer[AVRational, ImmutExternalOrigin]

    var pix_fmts: UnsafePointer[AVPixelFormat.ENUM_DTYPE, MutExternalOrigin]

    var supported_samplerates: UnsafePointer[c_int, ImmutExternalOrigin]

    var sample_fmts: UnsafePointer[AVSampleFormat.ENUM_DTYPE, MutExternalOrigin]

    var priv_class: UnsafePointer[AVClass, ImmutExternalOrigin]

    var profiles: UnsafePointer[AVProfile, ImmutExternalOrigin]

    var wrapper_name: UnsafePointer[c_char, ImmutExternalOrigin]

    var ch_layouts: UnsafePointer[AVChannelLayout, ImmutExternalOrigin]


comptime av_codec_iterate = ExternalFunction[
    "av_codec_iterate",
    fn (
        opaque: UnsafePointer[
            OpaquePointer[MutExternalOrigin], MutExternalOrigin
        ],
    ) -> UnsafePointer[AVCodec, ImmutExternalOrigin],
]


comptime avcodec_find_decoder = ExternalFunction[
    "avcodec_find_decoder",
    fn (
        id: AVCodecID.ENUM_DTYPE,
    ) -> UnsafePointer[AVCodec, ImmutExternalOrigin],
]

comptime avcodec_find_decoder_by_name = ExternalFunction[
    "avcodec_find_decoder_by_name",
    fn (
        name: UnsafePointer[c_char, ImmutAnyOrigin],
    ) -> UnsafePointer[AVCodec, ImmutExternalOrigin],
]

comptime avcodec_find_encoder = ExternalFunction[
    "avcodec_find_encoder",
    fn (
        id: AVCodecID.ENUM_DTYPE,
    ) -> UnsafePointer[AVCodec, ImmutExternalOrigin],
]

comptime avcodec_find_encoder_by_name = ExternalFunction[
    "avcodec_find_encoder_by_name",
    fn (
        name: UnsafePointer[c_char, ImmutExternalOrigin],
    ) -> UnsafePointer[AVCodec, ImmutExternalOrigin],
]

comptime av_codec_is_encoder = ExternalFunction[
    "av_codec_is_encoder",
    fn (codec: UnsafePointer[AVCodec, ImmutExternalOrigin],) -> c_int,
]

comptime av_codec_is_decoder = ExternalFunction[
    "av_codec_is_decoder",
    fn (codec: UnsafePointer[AVCodec, ImmutExternalOrigin],) -> c_int,
]

comptime av_get_profile_name = ExternalFunction[
    "av_get_profile_name",
    fn (
        codec: UnsafePointer[AVCodec, ImmutExternalOrigin],
        profile: c_int,
    ) -> UnsafePointer[c_char, ImmutExternalOrigin],
]


comptime AV_CODEC_HW_CONFIG_METHOD_HW_DEVICE_CTX = c_int(0x01)

comptime AV_CODEC_HW_CONFIG_METHOD_HW_FRAMES_CTX = c_int(0x02)

comptime AV_CODEC_HW_CONFIG_METHOD_INTERNAL = c_int(0x04)

comptime AV_CODEC_HW_CONFIG_METHOD_AD_HOC = c_int(0x08)


@register_passable("trivial")
@fieldwise_init
struct AVCodecHWConfig(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecHWConfig.html"

    var pix_fmt: AVPixelFormat.ENUM_DTYPE
    var methods: c_int

    var device_type: AVHWDeviceType.ENUM_DTYPE


comptime avcodec_get_hw_config = ExternalFunction[
    "avcodec_get_hw_config",
    fn (
        codec: UnsafePointer[AVCodec, ImmutExternalOrigin],
        index: c_int,
    ) -> UnsafePointer[AVCodecHWConfig, ImmutExternalOrigin],
]
