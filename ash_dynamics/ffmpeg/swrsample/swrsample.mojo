"https://www.ffmpeg.org/doxygen/8.0/swresample_8h.html"
from sys.ffi import c_int, c_uchar, c_long_long, c_double, c_size_t
from ash_dynamics.primitives._clib import ExternalFunction, c_ptrdiff_t, Debug
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.channel_layout import (
    AVChannelLayout,
    AVMatrixEncoding,
)
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat


########################################################
# ===                Option constants                ===
########################################################
#
# These constants are used for the ref avoptions interface for lswr.
########################################################

comptime SWR_FLAG_RESAMPLE = Int(1)


@fieldwise_init
@register_passable("trivial")
struct SwrDitherType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWR_DITHER_NONE = Self(0)
    comptime SWR_DITHER_RECTANGULAR = Self(1)
    comptime SWR_DITHER_TRIANGULAR = Self(2)
    comptime SWR_DITHER_TRIANGULAR_HIGHPASS = Self(3)

    comptime SWR_DITHER_NS = Self(64)
    comptime SWR_DITHER_NS_LIPSHITZ = Self(65)
    comptime SWR_DITHER_NS_F_WEIGHTED = Self(66)
    comptime SWR_DITHER_NS_MODIFIED_E_WEIGHTED = Self(67)
    comptime SWR_DITHER_NS_IMPROVED_E_WEIGHTED = Self(68)
    comptime SWR_DITHER_NS_SHIBATA = Self(69)
    comptime SWR_DITHER_NS_LOW_SHIBATA = Self(70)
    comptime SWR_DITHER_NS_HIGH_SHIBATA = Self(71)
    comptime SWR_DITHER_NB = Self(72)


@fieldwise_init
@register_passable("trivial")
struct SwrEngine(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWR_ENGINE_SWR = Self(0)
    comptime SWR_ENGINE_SOXR = Self(1)
    comptime SWR_ENGINE_NB = Self(2)


@fieldwise_init
@register_passable("trivial")
struct SwrFilterType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWR_FILTER_TYPE_CUBIC = Self(0)
    comptime SWR_FILTER_TYPE_BLACKMAN_NUTTALL = Self(1)
    comptime SWR_FILTER_TYPE_KAISER = Self(2)


@fieldwise_init
@register_passable("trivial")
struct SwrContext(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structSwrContext.html"
    pass


comptime swr_get_class = ExternalFunction[
    "swr_get_class",
    fn () -> UnsafePointer[AVClass, ImmutExternalOrigin],
]


comptime swr_alloc = ExternalFunction[
    "swr_alloc",
    fn () -> UnsafePointer[SwrContext, MutExternalOrigin],
]

comptime swr_init = ExternalFunction[
    "swr_init",
    fn (context: UnsafePointer[SwrContext, MutExternalOrigin]) -> c_int,
]

comptime swr_is_initialized = ExternalFunction[
    "swr_is_initialized",
    fn (context: UnsafePointer[SwrContext, ImmutExternalOrigin]) -> c_int,
]

comptime swr_alloc_set_opts2 = ExternalFunction[
    "swr_alloc_set_opts2",
    fn (
        context: UnsafePointer[SwrContext, MutExternalOrigin],
        out_ch_layout: UnsafePointer[AVChannelLayout, ImmutExternalOrigin],
        out_sample_fmt: AVSampleFormat,
        out_sample_rate: c_int,
        in_ch_layout: UnsafePointer[AVChannelLayout, ImmutExternalOrigin],
        in_sample_fmt: AVSampleFormat,
        in_sample_rate: c_int,
        log_offset: c_int,
        log_ctx: UnsafePointer[AVClass, ImmutExternalOrigin],
    ) -> c_int,
]


comptime swr_free = ExternalFunction[
    "swr_free",
    fn (context: UnsafePointer[SwrContext, MutExternalOrigin]),
]

comptime swr_close = ExternalFunction[
    "swr_close",
    fn (context: UnsafePointer[SwrContext, MutExternalOrigin]),
]

comptime swr_convert = ExternalFunction[
    "swr_convert",
    fn (
        s: UnsafePointer[SwrContext, MutExternalOrigin],
        out_: UnsafePointer[
            UnsafePointer[c_uchar, MutExternalOrigin], ImmutExternalOrigin
        ],
        out_count: c_int,
        in_: UnsafePointer[
            UnsafePointer[c_uchar, ImmutExternalOrigin], ImmutExternalOrigin
        ],
        in_count: c_int,
    ) -> c_int,
]

comptime swr_next_pts = ExternalFunction[
    "swr_next_pts",
    fn (
        s: UnsafePointer[SwrContext, MutExternalOrigin],
        pts: c_long_long,
    ) -> c_long_long,
]


comptime swr_set_compensation = ExternalFunction[
    "swr_set_compensation",
    fn (
        s: UnsafePointer[SwrContext, MutExternalOrigin],
        sample_delta: c_int,
        compensation_distance: c_int,
    ) -> c_int,
]


comptime swr_set_channel_mapping = ExternalFunction[
    "swr_set_channel_mapping",
    fn (
        s: UnsafePointer[SwrContext, MutExternalOrigin],
        channel_map: UnsafePointer[c_int, ImmutExternalOrigin],
    ) -> c_int,
]

comptime swr_build_matrix2 = ExternalFunction[
    "swr_build_matrix2",
    fn (
        in_layout: UnsafePointer[AVChannelLayout, ImmutExternalOrigin],
        out_layout: UnsafePointer[AVChannelLayout, ImmutExternalOrigin],
        center_mix_level: c_double,
        surround_mix_level: c_double,
        lfe_mix_level: c_double,
        rematrix_maxval: c_double,
        rematrix_volume: c_double,
        matrix: UnsafePointer[c_double, MutExternalOrigin],
        stride: c_ptrdiff_t,
        matrix_encoding: AVMatrixEncoding,
        log_ctx: UnsafePointer[AVClass, ImmutExternalOrigin],
    ) -> c_int,
]
