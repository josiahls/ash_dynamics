"https://www.ffmpeg.org/doxygen/8.0/swscale_8h.html"
from sys.ffi import (
    c_int,
    c_char,
    c_uchar,
    c_long_long,
    c_uint,
    c_size_t,
    c_double,
    c_float,
)
from sys._libc import dup, fclose, fdopen, fflush, FILE_ptr
from utils import StaticTuple
from ash_dynamics.primitives._clib import C_Union, ExternalFunction, Debug
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket, AVPacketSideData
from ash_dynamics.ffmpeg.avcodec.codec_par import AVCodecParameters
from ash_dynamics.ffmpeg.avcodec.defs import AVDiscard
from ash_dynamics.ffmpeg.avcodec.avcodec import AVCodecParserContext

from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avutil.pixfmt import (
    AVPixelFormat,
    AVColorSpace,
    AVColorPrimaries,
    AVColorTransferCharacteristic,
)
from ash_dynamics.ffmpeg.avformat.internal import AVCodecTag
from ash_dynamics.ffmpeg.avformat.avio import AVIOContext, AVIOInterruptCB

from ash_dynamics.ffmpeg.avutil.iamf import (
    AVIAMFMixPresentation,
    AVIAMFSubmix,
    AVIAMFSubmixElement,
    AVIAMFSubmixLayout,
    AVIAMFAudioElement,
    AVIAMFLayer,
    AVIAMFParamDefinition,
    AVIAMFAudioElementType,
    AVIAMFHeadphonesMode,
    AVIAMFSubmixLayoutType,
)


comptime swscale_version = ExternalFunction["swscale_version", fn () -> c_uint]

comptime swscale_configuration = ExternalFunction[
    "swscale_configuration",
    fn () -> UnsafePointer[c_char, ImmutOrigin.external],
]

comptime swscale_license = ExternalFunction[
    "swscale_license", fn () -> UnsafePointer[c_char, ImmutOrigin.external]
]

comptime sws_get_class = ExternalFunction[
    "sws_get_class", fn () -> UnsafePointer[AVClass, ImmutOrigin.external]
]

#############################
# Flags and quality settings #
#############################


@fieldwise_init
@register_passable("trivial")
struct SwsDither(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWS_DITHER_NONE = Self(0)
    comptime SWS_DITHER_AUTO = Self(1)
    comptime SWS_DITHER_BAYER = Self(2)
    comptime SWS_DITHER_ED = Self(3)
    comptime SWS_DITHER_A_DITHER = Self(4)
    comptime SWS_DITHER_X_DITHER = Self(5)
    comptime SWS_DITHER_NB = Self(6)


@fieldwise_init
@register_passable("trivial")
struct SwsAlphaBlend(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWS_ALPHA_BLEND_NONE = Self(0)
    comptime SWS_ALPHA_BLEND_UNIFORM = Self(1)
    comptime SWS_ALPHA_BLEND_CHECKERBOARD = Self(2)
    comptime SWS_ALPHA_BLEND_NB = Self(3)


@fieldwise_init
@register_passable("trivial")
struct SwsFlags(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWS_FAST_BILINEAR = Self(1 << 0)
    comptime SWS_BILINEAR = Self(1 << 1)
    comptime SWS_BICUBIC = Self(1 << 2)
    comptime SWS_X = Self(1 << 3)
    comptime SWS_POINT = Self(1 << 4)
    comptime SWS_AREA = Self(1 << 5)
    comptime SWS_BICUBLIN = Self(1 << 6)
    comptime SWS_GAUSS = Self(1 << 7)
    comptime SWS_SINC = Self(1 << 8)
    comptime SWS_LANCZOS = Self(1 << 9)
    comptime SWS_SPLINE = Self(1 << 10)

    comptime SWS_STRICT = Self(1 << 11)

    comptime SWS_PRINT_INFO = Self(1 << 12)

    comptime SWS_FULL_CHR_H_INT = Self(1 << 13)
    comptime SWS_FULL_CHR_H_INP = Self(1 << 14)
    comptime SWS_ACCURATE_RND = Self(1 << 18)

    comptime SWS_BITEXACT = Self(1 << 19)

    # Deprecated flags.
    comptime SWS_DIRECT_BGR = Self(1 << 15)
    comptime SWS_ERROR_DIFFUSION = Self(1 << 23)


@fieldwise_init
@register_passable("trivial")
struct SwsIntent(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWS_INTENT_PERCEPTUAL = Self(0)
    comptime SWS_INTENT_RELATIVE_COLORIMETRIC = Self(1)
    comptime SWS_INTENT_SATURATION = Self(2)
    comptime SWS_INTENT_ABSOLUTE_COLORIMETRIC = Self(3)
    comptime SWS_INTENT_NB = Self(4)


###################################
# Context creation and management #
###################################


@fieldwise_init
@register_passable("trivial")
struct SwsContext(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structSwsContext.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var opaque: OpaquePointer[MutOrigin.external]
    var flags: SwsFlags.ENUM_DTYPE
    var scaler_params: StaticTuple[c_double, 2]
    var threads: c_int
    var dither: SwsDither.ENUM_DTYPE
    var alpha_blend: SwsAlphaBlend.ENUM_DTYPE
    var gamma_flag: c_int

    # Deprecated frame property overrides, for the legacy API only.
    # Ignored by sws_scale_frame() when used in dynamic mode, in which
    # case all properties are instead taken from the frame directly.
    var src_w: c_int
    var src_h: c_int
    var src_format: c_int
    var dst_format: c_int
    var src_range: c_int
    var dst_range: c_int
    var src_v_chr_pos: c_int
    var src_h_chr_pos: c_int
    var dst_v_chr_pos: c_int
    var dst_h_chr_pos: c_int

    var intent: c_int

    # Remember to add new fields to graph.c:opts_equal()


####################################################
# Supported frame formats #
####################################################


comptime sws_test_format = ExternalFunction[
    "sws_test_format",
    fn (
        format: AVPixelFormat.ENUM_DTYPE,
        output: c_int,
    ) -> c_int,
]

comptime sws_test_colorspace = ExternalFunction[
    "sws_test_colorspace",
    fn (
        colorspace: AVColorSpace.ENUM_DTYPE,
        output: c_int,
    ) -> c_int,
]

comptime sws_test_primaries = ExternalFunction[
    "sws_test_primaries",
    fn (
        primaries: AVColorPrimaries.ENUM_DTYPE,
        output: c_int,
    ) -> c_int,
]

comptime sws_test_transfer = ExternalFunction[
    "sws_test_transfer",
    fn (
        transfer: AVColorTransferCharacteristic.ENUM_DTYPE,
        output: c_int,
    ) -> c_int,
]

comptime sws_test_frame = ExternalFunction[
    "sws_test_frame",
    fn (
        frame: UnsafePointer[AVFrame, ImmutOrigin.external],
        output: c_int,
    ) -> c_int,
]

comptime sws_frame_setup = ExternalFunction[
    "sws_frame_setup",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        dst: UnsafePointer[AVFrame, ImmutOrigin.external],
        src: UnsafePointer[AVFrame, ImmutOrigin.external],
    ) -> c_int,
]

####################################################
# Main scaling API #
####################################################

comptime sws_is_noop = ExternalFunction[
    "sws_is_noop",
    fn (
        dst: UnsafePointer[AVFrame, ImmutOrigin.external],
        src: UnsafePointer[AVFrame, ImmutOrigin.external],
    ) -> c_int,
]

comptime sws_scale_frame = ExternalFunction[
    "sws_scale_frame",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        dst: UnsafePointer[AVFrame, MutOrigin.external],
        src: UnsafePointer[AVFrame, ImmutOrigin.external],
    ) -> c_int,
]

####################################################
# Legacy (stateful) API #
####################################################

comptime SWS_SRC_V_CHR_DROP_MASK = 0x30000
comptime SWS_SRC_V_CHR_DROP_SHIFT = 16

comptime SWS_PARAM_DEFAULT = 123456
comptime SWS_MAX_REDUCE_CUTOFF = 0.002

comptime SWS_CS_ITU709 = 1
comptime SWS_CS_FCC = 4
comptime SWS_CS_ITU601 = 5
comptime SWS_CS_ITU624 = 5
comptime SWS_CS_SMPTE170M = 5
comptime SWS_CS_SMPTE240M = 7
comptime SWS_CS_DEFAULT = 5
comptime SWS_CS_BT2020 = 9

comptime sws_get_coefficients = ExternalFunction[
    "sws_get_coefficients",
    fn (colorspace: c_int,) -> UnsafePointer[c_int, ImmutOrigin.external],
]


@fieldwise_init
@register_passable("trivial")
struct SwsVector:
    "https://www.ffmpeg.org/doxygen/8.0/structSwsVector.html"
    var coeff: UnsafePointer[c_double, ImmutOrigin.external]
    var length: c_int


@fieldwise_init
@register_passable("trivial")
struct SwsFilter:
    "https://www.ffmpeg.org/doxygen/8.0/structSwsFilter.html"
    var lumH: UnsafePointer[SwsVector, ImmutOrigin.external]
    var lumV: UnsafePointer[SwsVector, ImmutOrigin.external]
    var chrH: UnsafePointer[SwsVector, ImmutOrigin.external]
    var chrV: UnsafePointer[SwsVector, ImmutOrigin.external]


comptime sws_is_supported_input = ExternalFunction[
    "sws_is_supported_input", fn (pix_fmt: AVPixelFormat.ENUM_DTYPE,) -> c_int
]

comptime sws_is_supported_output = ExternalFunction[
    "sws_is_supported_output", fn (pix_fmt: AVPixelFormat.ENUM_DTYPE,) -> c_int
]

comptime sws_isSupportedEndiannessConversion = ExternalFunction[
    "sws_isSupportedEndiannessConversion",
    fn (pix_fmt: AVPixelFormat.ENUM_DTYPE,) -> c_int,
]

comptime sws_init_context = ExternalFunction[
    "sws_init_context",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        srcFilter: UnsafePointer[SwsFilter, MutOrigin.external],
        dstFilter: UnsafePointer[SwsFilter, MutOrigin.external],
    ) -> c_int,
]

comptime sws_free_context = ExternalFunction[
    "sws_free_context", fn (ctx: UnsafePointer[SwsContext, MutOrigin.external],)
]

comptime sws_getContext = ExternalFunction[
    "sws_getContext",
    fn (
        srcW: c_int,
        srcH: c_int,
        srcFormat: AVPixelFormat.ENUM_DTYPE,
        dstW: c_int,
        dstH: c_int,
        dstFormat: AVPixelFormat.ENUM_DTYPE,
        flags: c_int,
        srcFilter: UnsafePointer[SwsFilter, MutOrigin.external],
        dstFilter: UnsafePointer[SwsFilter, MutOrigin.external],
        param: UnsafePointer[c_double, ImmutOrigin.external],
    ) -> UnsafePointer[SwsContext, MutOrigin.external],
]

comptime sws_scale = ExternalFunction[
    "sws_scale",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        # NOTE: This is a const pointer to an array. I think this is "ok"
        srcSlice: UnsafePointer[
            UnsafePointer[c_uchar, ImmutOrigin.external], ImmutOrigin.external
        ],
        # NOTE: This is a const pointer to an array. I think this is "ok"
        srcStride: UnsafePointer[c_int, ImmutOrigin.external],
        srcSliceY: c_int,
        srcSliceH: c_int,
        # NOTE: This is a pointer to an array. I think this is "ok"
        dst: UnsafePointer[
            UnsafePointer[c_uchar, MutOrigin.external], MutOrigin.external
        ],
        # NOTE: This is a const pointer to an array. I think this is "ok"
        dstStride: UnsafePointer[c_int, ImmutOrigin.external],
    ) -> c_int,
]

comptime sws_frame_start = ExternalFunction[
    "sws_frame_start",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        dst: UnsafePointer[AVFrame, MutOrigin.external],
        src: UnsafePointer[AVFrame, ImmutOrigin.external],
    ) -> c_int,
]

comptime sws_frame_end = ExternalFunction[
    "sws_frame_end", fn (ctx: UnsafePointer[SwsContext, MutOrigin.external],)
]

comptime sws_send_slice = ExternalFunction[
    "sws_send_slice",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        slice_start: c_uint,
        slice_height: c_uint,
    ) -> c_int,
]

comptime sws_receive_slice = ExternalFunction[
    "sws_receive_slice",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        slice_start: c_uint,
        slice_height: c_uint,
    ) -> c_int,
]

comptime sws_receive_slice_alignment = ExternalFunction[
    "sws_receive_slice_alignment",
    fn (ctx: UnsafePointer[SwsContext, ImmutOrigin.external],) -> c_uint,
]

comptime sws_setColorspaceDetails = ExternalFunction[
    "sws_setColorspaceDetails",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        inv_table: UnsafePointer[c_int, ImmutOrigin.external],
        srcRange: c_int,
        table: UnsafePointer[c_int, ImmutOrigin.external],
        dstRange: c_int,
        brightness: c_int,
        contrast: c_int,
        saturation: c_int,
    ) -> c_int,
]


comptime sws_allocVec = ExternalFunction[
    "sws_allocVec",
    fn (length: c_int,) -> UnsafePointer[SwsVector, MutOrigin.external],
]


comptime sws_getGaussianVec = ExternalFunction[
    "sws_getGaussianVec",
    fn (
        variance: c_double,
        quality: c_double,
    ) -> UnsafePointer[SwsVector, ImmutOrigin.external],
]


comptime sws_scaleVec = ExternalFunction[
    "sws_scaleVec",
    fn (
        a: UnsafePointer[SwsVector, MutOrigin.external],
        scalar: c_double,
    ),
]

comptime sws_normalizeVec = ExternalFunction[
    "sws_normalizeVec",
    fn (
        a: UnsafePointer[SwsVector, MutOrigin.external],
        height: c_double,
    ),
]

comptime sws_freeVec = ExternalFunction[
    "sws_freeVec", fn (a: UnsafePointer[SwsVector, MutOrigin.external],)
]


comptime sws_getDefaultFilter = ExternalFunction[
    "sws_getDefaultFilter",
    fn (
        lumaGBlur: c_float,
        chromaGBlur: c_float,
        lumaSharpen: c_float,
        chromaSharpen: c_float,
        chromaHShift: c_float,
        chromaVShift: c_float,
        verbose: c_int,
    ) -> UnsafePointer[SwsFilter, MutOrigin.external],
]

comptime sws_freeFilter = ExternalFunction[
    "sws_freeFilter", fn (filter: UnsafePointer[SwsFilter, MutOrigin.external],)
]

comptime sws_getCachedContext = ExternalFunction[
    "sws_getCachedContext",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        srcW: c_int,
        srcH: c_int,
        srcFormat: AVPixelFormat.ENUM_DTYPE,
        dstW: c_int,
        dstH: c_int,
        dstFormat: AVPixelFormat.ENUM_DTYPE,
        flags: c_int,
        srcFilter: UnsafePointer[SwsFilter, MutOrigin.external],
        dstFilter: UnsafePointer[SwsFilter, MutOrigin.external],
        param: UnsafePointer[c_double, ImmutOrigin.external],
    ) -> UnsafePointer[SwsContext, ImmutOrigin.external],
]


comptime sws_convertPalette8ToPacked32 = ExternalFunction[
    "sws_convertPalette8ToPacked32",
    fn (
        src: UnsafePointer[c_uchar, ImmutOrigin.external],
        dst: UnsafePointer[c_uchar, MutOrigin.external],
        num_pixels: c_int,
        palette: UnsafePointer[c_uchar, ImmutOrigin.external],
    ),
]


comptime sws_convertPalette8ToPacked24 = ExternalFunction[
    "sws_convertPalette8ToPacked24",
    fn (
        src: UnsafePointer[c_uchar, ImmutOrigin.external],
        dst: UnsafePointer[c_uchar, MutOrigin.external],
        num_pixels: c_int,
        palette: UnsafePointer[c_uchar, ImmutOrigin.external],
    ),
]
