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
"""Force resampling even if equal sample rate.

Mojo note: Todos belong, we aware of these.

//TODO use int resample ?
//long term TODO can we enable this dynamically?
"""


@fieldwise_init
@register_passable("trivial")
struct SwrDitherType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWR_DITHER_NONE = Self(0)
    """No dithering."""
    comptime SWR_DITHER_RECTANGULAR = Self(1)
    """Rectangular dithering."""
    comptime SWR_DITHER_TRIANGULAR = Self(2)
    """Triangular dithering."""
    comptime SWR_DITHER_TRIANGULAR_HIGHPASS = Self(3)
    """Triangular high pass dithering."""

    comptime SWR_DITHER_NS = Self(64)
    """Not part of the ABI."""
    comptime SWR_DITHER_NS_LIPSHITZ = Self(65)
    comptime SWR_DITHER_NS_F_WEIGHTED = Self(66)
    comptime SWR_DITHER_NS_MODIFIED_E_WEIGHTED = Self(67)
    comptime SWR_DITHER_NS_IMPROVED_E_WEIGHTED = Self(68)
    comptime SWR_DITHER_NS_SHIBATA = Self(69)
    comptime SWR_DITHER_NS_LOW_SHIBATA = Self(70)
    comptime SWR_DITHER_NS_HIGH_SHIBATA = Self(71)
    comptime SWR_DITHER_NB = Self(72)
    """Not part of the ABI."""


@fieldwise_init
@register_passable("trivial")
struct SwrEngine(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWR_ENGINE_SWR = Self(0)
    """SW Resampler."""
    comptime SWR_ENGINE_SOXR = Self(1)
    """SoX Resampler."""
    comptime SWR_ENGINE_NB = Self(2)
    """Not part of the ABI."""


@fieldwise_init
@register_passable("trivial")
struct SwrFilterType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWR_FILTER_TYPE_CUBIC = Self(0)
    """Cubic."""
    comptime SWR_FILTER_TYPE_BLACKMAN_NUTTALL = Self(1)
    """Blackman Nuttall windowed sinc."""
    comptime SWR_FILTER_TYPE_KAISER = Self(2)
    """Kaiser windowed sinc."""


@fieldwise_init
@register_passable("trivial")
struct SwrContext(Debug):
    """The libswresample context. Unlike libavcodec and libavformat, this structure
    is opaque. This means that if you would like to set options, you must use
    the @ref avoptions API and cannot directly set values to members of the
    structure."""

    pass


comptime swr_get_class = ExternalFunction[
    "swr_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]
"""Get the AVClass for SwrContext. It can be used in combination with
AV_OPT_SEARCH_FAKE_OBJ for examining options.

@see av_opt_find().
@return the AVClass of SwrContext
"""


comptime swr_alloc = ExternalFunction[
    "swr_alloc",
    fn () -> UnsafePointer[SwrContext, MutOrigin.external],
]
"""Allocate SwrContext.

If you use this function you will need to set the parameters (manually or
with swr_alloc_set_opts2()) before calling swr_init().

@see swr_alloc_set_opts2(), swr_init(), swr_free()
@return NULL on error, allocated context otherwise
"""

comptime swr_init = ExternalFunction[
    "swr_init",
    fn (context: UnsafePointer[SwrContext, MutOrigin.external]) -> c_int,
]
"""Initialize context after user parameters have been set.

@note The context must be configured using the AVOption API.

@see av_opt_set_int(), av_opt_set_dict()
@return AVERROR error code in case of failure.
"""

comptime swr_is_initialized = ExternalFunction[
    "swr_is_initialized",
    fn (context: UnsafePointer[SwrContext, ImmutOrigin.external]) -> c_int,
]
"""Check whether an swr context has been initialized or not.

@param context Swr context to check
@see swr_init()
@return positive if it has been initialized, 0 if not initialized
"""

comptime swr_alloc_set_opts2 = ExternalFunction[
    "swr_alloc_set_opts2",
    fn (
        context: UnsafePointer[SwrContext, MutOrigin.external],
        out_ch_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        out_sample_fmt: AVSampleFormat,
        out_sample_rate: c_int,
        in_ch_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        in_sample_fmt: AVSampleFormat,
        in_sample_rate: c_int,
        log_offset: c_int,
        log_ctx: UnsafePointer[AVClass, ImmutOrigin.external],
    ) -> c_int,
]
"""Allocate SwrContext if needed and set/reset common parameters.

This function does not require *ps to be allocated with swr_alloc(). On the
other hand, swr_alloc() can use swr_alloc_set_opts2() to set the parameters
on the allocated context.

@param ps Pointer to an existing Swr context if available, or to NULL if not.
On success, *ps will be set to the allocated context.
@param out_ch_layout output channel layout (e.g. AV_CHANNEL_LAYOUT_*)
@param out_sample_fmt output sample format (AV_SAMPLE_FMT_*).
@param out_sample_rate output sample rate (frequency in Hz)
@param in_ch_layout input channel layout (e.g. AV_CHANNEL_LAYOUT_*)
@param in_sample_fmt input sample format (AV_SAMPLE_FMT_*).
@param in_sample_rate input sample rate (frequency in Hz)
@param log_offset logging level offset
@param log_ctx parent logging context, can be NULL

@see swr_init(), swr_free()
@return 0 on success, a negative AVERROR code on error.
On error, the Swr context is freed and *ps set to NULL.
"""


comptime swr_free = ExternalFunction[
    "swr_free",
    fn (context: UnsafePointer[SwrContext, MutOrigin.external]),
]
"""Free the given SwrContext and set the pointer to NULL.

@param s a pointer to a pointer to Swr context
"""

comptime swr_close = ExternalFunction[
    "swr_close",
    fn (context: UnsafePointer[SwrContext, MutOrigin.external]),
]
"""Closes the context so that swr_is_initialized() returns 0.

The context can be brought back to life by running swr_init(),
swr_init() can also be used without swr_close().
This function is mainly provided for simplifying the usecase
where one tries to support libavresample and libswresample.

@param s Swr context to be closed
"""

comptime swr_convert = ExternalFunction[
    "swr_convert",
    fn (
        s: UnsafePointer[SwrContext, MutOrigin.external],
        out_: UnsafePointer[
            UnsafePointer[c_uchar, MutOrigin.external], ImmutOrigin.external
        ],
        out_count: c_int,
        in_: UnsafePointer[
            UnsafePointer[c_uchar, ImmutOrigin.external], ImmutOrigin.external
        ],
        in_count: c_int,
    ) -> c_int,
]
"""Convert audio.

in and in_count can be set to 0 to flush the last few samples out at the
end.

If more input is provided than output space, then the input will be buffered.
You can avoid this buffering by using swr_get_out_samples() to retrieve an
upper bound on the required number of output samples for the given number of
input samples. Conversion will run directly without copying whenever possible.

Mojo note: `out` and `in` are renamed to `out_` and `in_` since these are
keywords in Mojo.

@param s allocated Swr context, with parameters set
@param out output buffers, only the first one need be set in case of packed audio
@param out_count amount of space available for output in samples per channel
@param in input buffers, only the first one need to be set in case of packed audio
@param in_count number of input samples available in one channel

@return number of samples output per channel, negative value on error
"""

comptime swr_next_pts = ExternalFunction[
    "swr_next_pts",
    fn (
        s: UnsafePointer[SwrContext, MutOrigin.external],
        pts: c_long_long,
    ) -> c_long_long,
]
"""Convert the next timestamp from input to output.

timestamps are in 1/(in_sample_rate * out_sample_rate) units.

@note There are 2 slightly differently behaving modes.
       @li When automatic timestamp compensation is not used, (min_compensation >= FLT_MAX)
              in this case timestamps will be passed through with delays compensated
       @li When automatic timestamp compensation is used, (min_compensation < FLT_MAX)
              in this case the output timestamps will match output sample numbers.
              See ffmpeg-resampler(1) for the two modes of compensation.

@param s allocated Swr context, with parameters set
@param pts timestamp for the next input sample, INT64_MIN if unknown
@see swr_set_compensation(), swr_drop_output(), and swr_inject_silence() are
     function used internally for timestamp compensation.
@return the output timestamp for the next output sample
"""


comptime swr_set_compensation = ExternalFunction[
    "swr_set_compensation",
    fn (
        s: UnsafePointer[SwrContext, MutOrigin.external],
        sample_delta: c_int,
        compensation_distance: c_int,
    ) -> c_int,
]
"""Activate resampling compensation ("soft" compensation). This function is
internally called when needed in swr_next_pts().

@param s allocated Swr context, with parameters set
@param sample_delta delta in PTS per sample
@param compensation_distance number of samples to compensate for
@return >= 0 on success, AVERROR error codes if:
       @li @c s is NULL,
       @li @c compensation_distance is less than 0,
       @li @c compensation_distance is 0 but sample_delta is not,
       @li compensation unsupported by resampler, or
       @li swr_init() fails when called.
"""


comptime swr_set_channel_mapping = ExternalFunction[
    "swr_set_channel_mapping",
    fn (
        s: UnsafePointer[SwrContext, MutOrigin.external],
        channel_map: UnsafePointer[c_int, ImmutOrigin.external],
    ) -> c_int,
]
"""Set a customized input channel mapping.

@param s allocated Swr context, not yet initialized
@param channel_map customized input channel mapping (array of channel indexes, -1 for a muted channel)
@return >= 0 on success, or AVERROR error code in case of failure.
"""

comptime swr_build_matrix2 = ExternalFunction[
    "swr_build_matrix2",
    fn (
        in_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        out_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        center_mix_level: c_double,
        surround_mix_level: c_double,
        lfe_mix_level: c_double,
        rematrix_maxval: c_double,
        rematrix_volume: c_double,
        matrix: UnsafePointer[c_double, MutOrigin.external],
        stride: c_ptrdiff_t,
        matrix_encoding: AVMatrixEncoding,
        log_ctx: UnsafePointer[AVClass, ImmutOrigin.external],
    ) -> c_int,
]
"""Generate a channel mixing matrix.

This function is the one used internally by libswresample for building the
default mixing matrix. It is made public just as a utility function for
building custom matrices.

@param in_layout input channel layout
@param out_layout output channel layout
@param center_mix_level mix level for the center channel
@param surround_mix_level mix level for the surround channel(s)
@param lfe_mix_level mix level for the low-frequency effects channel
@param rematrix_maxval maximum rematrix value
@param rematrix_volume rematrix volume
@param matrix mixing coefficients; matrix[i + stride * o] is the weight of input channel i in output channel o
@param stride distance between adjacent input channels in the matrix array
@param matrix_encoding matrixed stereo downmix mode (e.g. dplii)
@param log_ctx parent logging context, can be NULL
@return 0 on success, negative AVERROR code on failure
"""
