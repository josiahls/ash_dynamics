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
from ash_dynamics.primitives._clib import C_Union, ExternalFunction
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
"""Return the libswscale version.

Returns:
- Return the LIBSWSCALE_VERSION_INT constant.
"""

comptime swscale_configuration = ExternalFunction[
    "swscale_configuration",
    fn () -> UnsafePointer[c_char, ImmutOrigin.external],
]
"""Return the libswscale build-time configuration.

Returns:
- Return the FFMPEG_CONFIGURATION constant.
"""

comptime swscale_license = ExternalFunction[
    "swscale_license", fn () -> UnsafePointer[c_char, ImmutOrigin.external]
]
"""Return the libswscale license.

Returns:
- Return the FFMPEG_LICENSE constant.
"""

comptime sws_get_class = ExternalFunction[
    "sws_get_class", fn () -> UnsafePointer[AVClass, ImmutOrigin.external]
]
"""Get the AVClass for SwsContext. It can be used in combination with
AV_OPT_SEARCH_FAKE_OBJ for examining options.

Returns:
- Return the AVClass for SwsContext.
"""

#############################
# Flags and quality settings #
#############################


@fieldwise_init
@register_passable("trivial")
struct SwsDither:
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWS_DITHER_NONE = Self(0)
    """Disable dithering."""
    comptime SWS_DITHER_AUTO = Self(1)
    """Auto-select from preset."""
    comptime SWS_DITHER_BAYER = Self(2)
    """Ordered dither matrix."""
    comptime SWS_DITHER_ED = Self(3)
    """Error diffusion."""
    comptime SWS_DITHER_A_DITHER = Self(4)
    """Arithmetic addition."""
    comptime SWS_DITHER_X_DITHER = Self(5)
    """Arithmetic xor."""
    comptime SWS_DITHER_NB = Self(6)
    """Not part of the ABI."""


@fieldwise_init
@register_passable("trivial")
struct SwsAlphaBlend:
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWS_ALPHA_BLEND_NONE = Self(0)
    """No blending."""
    comptime SWS_ALPHA_BLEND_UNIFORM = Self(1)
    """Uniform blending."""
    comptime SWS_ALPHA_BLEND_CHECKERBOARD = Self(2)
    """Checkerboard blending."""
    comptime SWS_ALPHA_BLEND_NB = Self(3)
    """Not part of the ABI."""


@fieldwise_init
@register_passable("trivial")
struct SwsFlags:
    """Scaler selection options. Only one may be active at a time."""

    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWS_FAST_BILINEAR = Self(1 << 0)
    """Fast bilinear filtering."""
    comptime SWS_BILINEAR = Self(1 << 1)
    """Bilinear filtering."""
    comptime SWS_BICUBIC = Self(1 << 2)
    """2-tap cubic B-spline."""
    comptime SWS_X = Self(1 << 3)
    """Experimental scaling algorithm."""
    comptime SWS_POINT = Self(1 << 4)
    """Nearest neighbor rescaling algorithm."""
    comptime SWS_AREA = Self(1 << 5)
    """Averaging area rescaling algorithm."""
    comptime SWS_BICUBLIN = Self(1 << 6)
    """Bicubic luma, bilinear chroma."""
    comptime SWS_GAUSS = Self(1 << 7)
    """Gaussian approximation rescaling algorithm."""
    comptime SWS_SINC = Self(1 << 8)
    """Unwindowed sinc rescaling algorithm."""
    comptime SWS_LANCZOS = Self(1 << 9)
    """Lanczos rescaling algorithm."""
    comptime SWS_SPLINE = Self(1 << 10)
    """Cubic Keys spline rescaling algorithm."""

    comptime SWS_STRICT = Self(1 << 11)
    """Return an error on underspecified conversions. Without this flag,
    unspecified fields are defaulted to sensible values."""

    comptime SWS_PRINT_INFO = Self(1 << 12)
    """Emit verbose log of scaling parameters."""

    comptime SWS_FULL_CHR_H_INT = Self(1 << 13)
    """Perform full chroma upsampling when upscaling to RGB.
    
    For example, when converting 50x50 yuv420p to 100x100 rgba, setting this flag
    will scale the chroma plane from 25x25 to 100x100 (4:4:4), and then convert
    the 100x100 yuv444p image to rgba in the final output step.

    Without this flag, the chroma plane is instead scaled to 50x100 (4:2:2),
    with a single chroma sample being reused for both of the horizontally
    adjacent RGBA output pixels.
    """
    comptime SWS_FULL_CHR_H_INP = Self(1 << 14)
    """Perform full chroma interpolation when downscaling RGB sources.

    For example, when converting a 100x100 rgba source to 50x50 yuv444p, setting
    this flag will generate a 100x100 (4:4:4) chroma plane, which is then
    downscaled to the required 50x50.

    Without this flag, the chroma plane is instead generated at 50x100 (dropping
    every other pixel), before then being downscaled to the required 50x50 resolution.
    """
    comptime SWS_ACCURATE_RND = Self(1 << 18)
    """Force bit-exact output. This will prevent the use of platform-specific
    optimizations that may lead to slight difference in rounding, in favor
    of always maintaining exact bit output compatibility with the reference C code.
    
    Note: It is recommended to set both of these flags simultaneously."""

    comptime SWS_BITEXACT = Self(1 << 19)
    """Ref Self.SWS_ACCURATE_RND"""

    # Deprecated flags.
    comptime SWS_DIRECT_BGR = Self(1 << 15)
    """Deprecated. This flag has no effect."""
    comptime SWS_ERROR_DIFFUSION = Self(1 << 23)
    """Deprecated. Set `SwsContext.dither` instead."""


@fieldwise_init
@register_passable("trivial")
struct SwsIntent:
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SWS_INTENT_PERCEPTUAL = Self(0)
    """Perceptual tone mapping."""
    comptime SWS_INTENT_RELATIVE_COLORIMETRIC = Self(1)
    """Relative colorimetric clipping."""
    comptime SWS_INTENT_SATURATION = Self(2)
    """Saturation mapping."""
    comptime SWS_INTENT_ABSOLUTE_COLORIMETRIC = Self(3)
    """Absolute colorimetric clipping."""
    comptime SWS_INTENT_NB = Self(4)
    """Not part of the ABI."""


###################################
# Context creation and management #
###################################


@fieldwise_init
@register_passable("trivial")
struct SwsContext:
    """Main external API structure. New fields can be added to the end with
    minor version bumps. Removal, reordering and changes to existing fields
    require a major version bump. sizeof(SwsContext) is not part of the ABI."""

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var opaque: OpaquePointer[MutOrigin.external]
    """Private data of the user, can be used to carry app specific stuff."""
    var flags: SwsFlags.ENUM_DTYPE
    """Bitmask of SWS_*. See `SwsFlags` for details."""
    var scaler_params: StaticTuple[c_double, 2]
    """Extra parameters for fine-tuning certain scalers."""
    var threads: c_int
    """How many threads to use for processing, or 0 for automatic selection."""
    var dither: SwsDither.ENUM_DTYPE
    """Dither mode."""
    var alpha_blend: SwsAlphaBlend.ENUM_DTYPE
    """Alpha blending mode. See `SwsAlphaBlend` for details."""
    var gamma_flag: c_int
    """Use gamma correct scaling."""

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
    """Desired ICC intent for color space conversions."""

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
"""Test if a given pixel format is supported.

Arguments:
- format: The format to check.
- output: If 0, test if compatible with the source/input frame;
          otherwise, with the destination/output frame.

Returns:
- A positive integer if supported, 0 otherwise.
"""

comptime sws_test_colorspace = ExternalFunction[
    "sws_test_colorspace",
    fn (
        colorspace: AVColorSpace.ENUM_DTYPE,
        output: c_int,
    ) -> c_int,
]
"""Test if a given color space is supported.

Arguments:
- colorspace: The color space to check.
- output: If 0, test if compatible with the source/input frame;
          otherwise, with the destination/output frame.

Returns:
- A positive integer if supported, 0 otherwise.
"""

comptime sws_test_primaries = ExternalFunction[
    "sws_test_primaries",
    fn (
        primaries: AVColorPrimaries.ENUM_DTYPE,
        output: c_int,
    ) -> c_int,
]
"""Test if a given set of color primaries is supported.

Arguments:
- primaries: The color primaries to check.
- output: If 0, test if compatible with the source/input frame;
          otherwise, with the destination/output frame.

Returns:
- A positive integer if supported, 0 otherwise.
"""

comptime sws_test_transfer = ExternalFunction[
    "sws_test_transfer",
    fn (
        transfer: AVColorTransferCharacteristic.ENUM_DTYPE,
        output: c_int,
    ) -> c_int,
]
"""Test if a given color transfer function is supported.

Arguments:
- transfer: The color transfer function to check.
- output: If 0, test if compatible with the source/input frame;
          otherwise, with the destination/output frame.

Returns:
- A positive integer if supported, 0 otherwise.
"""

comptime sws_test_frame = ExternalFunction[
    "sws_test_frame",
    fn (
        frame: UnsafePointer[AVFrame, ImmutOrigin.external],
        output: c_int,
    ) -> c_int,
]
"""Helper function to run all sws_test_* against a frame, as well as testing
the basic frame properties for sanity. Ignores irrelevant properties - for
example, AVColorSpace is not checked for RGB frames.
"""

comptime sws_frame_setup = ExternalFunction[
    "sws_frame_setup",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        dst: UnsafePointer[AVFrame, ImmutOrigin.external],
        src: UnsafePointer[AVFrame, ImmutOrigin.external],
    ) -> c_int,
]
"""Like `sws_scale_frame`, but without actually scaling. It will instead
merely initialize internal state that *would* be required to perform the
operation, as well as returning the correct error code for unsupported
frame combinations.

Arguments:
- ctx: The scaling context.
- dst: The destination frame to consider.
- src: The source frame to consider.

Returns:
- 0 on success, a negative AVERROR code on failure.
"""

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
"""Check if a given conversion is a noop. Returns a positive integer if
no operation needs to be performed, 0 otherwise.
"""

comptime sws_scale_frame = ExternalFunction[
    "sws_scale_frame",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        dst: UnsafePointer[AVFrame, MutOrigin.external],
        src: UnsafePointer[AVFrame, ImmutOrigin.external],
    ) -> c_int,
]
"""Scale source data from `src` and write the output to `dst`.

This function can be used directly on an allocated context, without setting
up any frame properties or calling `sws_init_context()`. Such usage is fully
dynamic and does not require reallocation if the frame properties change.

Alternatively, this function can be called on a context that has been
explicitly initialized. However, this is provided only for backwards
compatibility. In this usage mode, all frame properties must be correctly
set at init time, and may no longer change after initialization.

Arguments:
- ctx: The scaling context.
- dst: The destination frame. The data buffers may either be already
       allocated by the caller or left clear, in which case they will
       be allocated by the scaler. The latter may have performance
       advantages - e.g. in certain cases some (or all) output planes
       may be references to input planes, rather than copies.
- src: The source frame. If the data buffers are set to NULL, then
       this function behaves identically to `sws_frame_setup`.

Returns:
- >= 0 on success, a negative AVERROR code on failure.
"""

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
"""Return a pointer to yuv<->rgb coefficients for the given colorspace
suitable for sws_setColorspaceDetails().

Arguments:
- colorspace: One of the SWS_CS_* macros. If invalid,
              SWS_CS_DEFAULT is used.

Returns:
- A pointer to the coefficients.
"""


@fieldwise_init
@register_passable("trivial")
struct SwsVector:
    """When used for filters they must have an odd number of elements
    coeffs cannot be shared between vectors."""

    var coeff: UnsafePointer[c_double, ImmutOrigin.external]
    """Pointer to the list of coefficients."""
    var length: c_int
    """Number of coefficients in the vector."""


@fieldwise_init
@register_passable("trivial")
struct SwsFilter:
    """Vectors can be shared."""

    var lumH: UnsafePointer[SwsVector, ImmutOrigin.external]
    var lumV: UnsafePointer[SwsVector, ImmutOrigin.external]
    var chrH: UnsafePointer[SwsVector, ImmutOrigin.external]
    var chrV: UnsafePointer[SwsVector, ImmutOrigin.external]


comptime sws_is_supported_input = ExternalFunction[
    "sws_is_supported_input", fn (pix_fmt: AVPixelFormat.ENUM_DTYPE,) -> c_int
]
"""Return a positive value if pix_fmt is a supported input format, 0
otherwise.
"""

comptime sws_is_supported_output = ExternalFunction[
    "sws_is_supported_output", fn (pix_fmt: AVPixelFormat.ENUM_DTYPE,) -> c_int
]
"""Return a positive value if pix_fmt is a supported output format, 0
otherwise.
"""

comptime sws_isSupportedEndiannessConversion = ExternalFunction[
    "sws_isSupportedEndiannessConversion",
    fn (pix_fmt: AVPixelFormat.ENUM_DTYPE,) -> c_int,
]
"""
Arguments:
- pix_fmt: The pixel format to check.

Returns:
- A positive integer if an endianness conversion for pix_fmt is supported, 0 otherwise.
"""

comptime sws_init_context = ExternalFunction[
    "sws_init_context",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        srcFilter: UnsafePointer[SwsFilter, MutOrigin.external],
        dstFilter: UnsafePointer[SwsFilter, MutOrigin.external],
    ) -> c_int,
]
"""Initialize the scaling context.

This function is considered deprecated, and provided only for backwards
compatibility with sws_scale() and sws_start_frame(). The preferred way to
use libswscale is to set all frame properties correctly and call
sws_scale_frame() directly, without explicitly initializing the context.

Arguments:
- ctx: The scaling context.
- srcFilter: The source filter.
- dstFilter: The destination filter.

Returns:
- 0 on success, a negative AVERROR code on failure.
"""

comptime sws_free_context = ExternalFunction[
    "sws_free_context", fn (ctx: UnsafePointer[SwsContext, MutOrigin.external],)
]
"""Free the scaling context.

If ctx is NULL, then does nothing.

Arguments:
- ctx: The scaling context.
"""

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
"""Allocate and return an SwsContext. You need it to perform
scaling/conversion operations using sws_scale().

Arguments:
- srcW: The width of the source image.
- srcH: The height of the source image.
- srcFormat: The source image format.
- dstW: The width of the destination image.
- dstH: The height of the destination image.
- dstFormat: The destination image format.
- flags: Specify which algorithm and options to use for rescaling.
- param: Extra parameters to tune the used scaler 
        For SWS_BICUBIC param[0] and [1] tune the shape of the basis
        function, param[0] tunes f(1) and param[1] f'(1)
        For SWS_GAUSS param[0] tunes the exponent and thus cutoff
        frequency
        For SWS_LANCZOS param[0] tunes the width of the window function

Returns:
- A pointer to an allocated context, or NULL in case of error
@note this function is to be removed after a saner alternative is
      written
"""

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
"""Scale the image slice in srcSlice and put the resulting scaled
slice in the image in dst. A slice is a sequence of consecutive
rows in an image. Requires a context that has been previously
been initialized with sws_init_context().

Slices have to be provided in sequential order, either in top-bottom or
bottom-top order. If slices are provided in non-sequential order the behavior
of the function is undefined.

Arguments:
- ctx: The scaling context previously created with sws_getContext().
- srcSlice: The array containing the pointers to the planes of the source slice.
- srcStride: The array containing the strides for each plane of the source image.
- srcSliceY: The position in the source image of the slice to process, that is the number (counted starting from zero) in the image of the first row of the slice.
- srcSliceH: The height of the source slice, that is the number of rows in the slice.
- dst: The array containing the pointers to the planes of the destination image.
- dstStride: The array containing the strides for each plane of the destination image.

Returns:
- The height of the output slice.
"""

comptime sws_frame_start = ExternalFunction[
    "sws_frame_start",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        dst: UnsafePointer[AVFrame, MutOrigin.external],
        src: UnsafePointer[AVFrame, ImmutOrigin.external],
    ) -> c_int,
]
"""Initialize the scaling process for a given pair of source/destination frames.
Must be called before any calls to sws_send_slice() and sws_receive_slice().
Requires a context that has been previously been initialized with
sws_init_context().

This function will retain references to src and dst, so they must both use
refcounted buffers (if allocated by the caller, in case of dst).

Arguments:
- ctx: The scaling context.
- dst: The destination frame.
    The data buffers may either be already allocated by the caller or left clear, in which case they will be allocated by the scaler. The latter may have performance advantages - e.g. in certain cases some (or all) output planes may be references to input planes, rather than copies.
    Output data will be written into this frame in successful sws_receive_slice() calls.
- src: The source frame. The data buffers must be allocated, but the frame data does not have to be ready at this point. Data availability is then signalled by sws_send_slice().

Returns:
- 0 on success, a negative AVERROR code on failure.

@see sws_frame_end()
"""

comptime sws_frame_end = ExternalFunction[
    "sws_frame_end", fn (ctx: UnsafePointer[SwsContext, MutOrigin.external],)
]
"""Finish the scaling process for a pair of source/destination frames previously
submitted with sws_frame_start(). Must be called after all sws_send_slice()
and sws_receive_slice() calls are done, before any new sws_frame_start()
calls.

Arguments:
- ctx: The scaling context.
"""

comptime sws_send_slice = ExternalFunction[
    "sws_send_slice",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        slice_start: c_uint,
        slice_height: c_uint,
    ) -> c_int,
]
"""Indicate that a horizontal slice of input data is available in the source
frame previously provided to sws_frame_start(). The slices may be provided in
any order, but may not overlap. For vertically subsampled pixel formats, the
slices must be aligned according to subsampling.

Arguments:
- ctx: The scaling context.
- slice_start: first row of the slice
- slice_height: number of rows in the slice

Returns:
- A non-negative number on success, a negative AVERROR code on failure.
"""

comptime sws_receive_slice = ExternalFunction[
    "sws_receive_slice",
    fn (
        ctx: UnsafePointer[SwsContext, MutOrigin.external],
        slice_start: c_uint,
        slice_height: c_uint,
    ) -> c_int,
]
"""Request a horizontal slice of the output data to be written into the frame
previously provided to sws_frame_start().

Arguments:
- ctx: The scaling context.
- slice_start: first row of the slice; must be a multiple of sws_receive_slice_alignment()
- slice_height: number of rows in the slice; must be a multiple of 
    sws_receive_slice_alignment(), except for the last slice (i.e. when 
    slice_start+slice_height is equal to output frame height)

Returns:
- A non-negative number if the data was successfully written into the output, 
  AVERROR(EAGAIN) if more input data needs to be provided before the output can be produced,
  a negative AVERROR code on other kinds of scaling failure.
"""

comptime sws_receive_slice_alignment = ExternalFunction[
    "sws_receive_slice_alignment",
    fn (ctx: UnsafePointer[SwsContext, ImmutOrigin.external],) -> c_uint,
]
"""Get the alignment required for slices. Requires a context that has been 
previously been initialized with sws_init_context().

Arguments:
- ctx: The scaling context.

Returns:
- The alignment required for slices requested with sws_receive_slice().
  Slice offsets and sizes passed to sws_receive_slice() must be
  multiples of the value returned from this function.
"""

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
"""Set the colorspace details for the scaling context.

Arguments:
- ctx: The scaling context.
- inv_table: The inverse table of yuv2rgb coefficients describing the input yuv
    space, normally ff_yuv2rgb_coeffs[x]
- srcRange: flag indicating the while-black range of the input (1=jpeg / 0=mpeg)
- table: the yuv2rgb coefficients describing the output yuv space, normally ff_yuv2rgb_coeffs[x]
- dstRange: flag indicating the while-black range of the output (1=jpeg / 0=mpeg)
- brightness: 16.16 fixed point brightness correction
- contrast: 16.16 fixed point contrast correction
- saturation: 16.16 fixed point saturation correction

Returns:
- A negative error code on error, non negative otherwise.
  If LIBSWSCALE_VERSION_MAJOR < 7, returns -1 if not supported.
"""


comptime sws_allocVec = ExternalFunction[
    "sws_allocVec",
    fn (length: c_int,) -> UnsafePointer[SwsVector, MutOrigin.external],
]
"""Allocate and return an uninitialized vector with length coefficients.
"""


comptime sws_getGaussianVec = ExternalFunction[
    "sws_getGaussianVec",
    fn (
        variance: c_double,
        quality: c_double,
    ) -> UnsafePointer[SwsVector, ImmutOrigin.external],
]
"""Return a normalized Gaussian curve used to filter stuff
quality = 3 is high quality, lower is lower quality.
"""


comptime sws_scaleVec = ExternalFunction[
    "sws_scaleVec",
    fn (
        a: UnsafePointer[SwsVector, MutOrigin.external],
        scalar: c_double,
    ),
]
"""Scale all the coefficients of a by the scalar value.
"""

comptime sws_normalizeVec = ExternalFunction[
    "sws_normalizeVec",
    fn (
        a: UnsafePointer[SwsVector, MutOrigin.external],
        height: c_double,
    ),
]
"""Scale all the coefficients of a so that their sum equals height.
"""

comptime sws_freeVec = ExternalFunction[
    "sws_freeVec", fn (a: UnsafePointer[SwsVector, MutOrigin.external],)
]
"""Free a vector."""


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
"""Return a default filter for the given parameters.
"""

comptime sws_freeFilter = ExternalFunction[
    "sws_freeFilter", fn (filter: UnsafePointer[SwsFilter, MutOrigin.external],)
]
"""Free a filter."""

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
"""Check if context can be reused, otherwise reallocate a new one.

If context is NULL, just calls sws_getContext() to get a new
context. Otherwise, checks if the parameters are the ones already
saved in context. If that is the case, returns the current
context. Otherwise, frees context and gets a new context with
the new parameters.

Be warned that srcFilter and dstFilter are not checked, they
are assumed to remain the same.

Arguments:
- ctx: The scaling context.
- srcW: The width of the source image.
- srcH: The height of the source image.
- srcFormat: The source image format.
- dstW: The width of the destination image.
- dstH: The height of the destination image.
- dstFormat: The destination image format.
- flags: Specify which algorithm and options to use for rescaling.
- srcFilter: The source filter.
- dstFilter: The destination filter.
- param: Extra parameters to tune the used scaler.

Returns:
- A pointer to an allocated context, or NULL in case of error
@note this function is to be removed after a saner alternative is written
"""


comptime sws_convertPalette8ToPacked32 = ExternalFunction[
    "sws_convertPalette8ToPacked32",
    fn (
        src: UnsafePointer[c_uchar, ImmutOrigin.external],
        dst: UnsafePointer[c_uchar, MutOrigin.external],
        num_pixels: c_int,
        palette: UnsafePointer[c_uchar, ImmutOrigin.external],
    ),
]
"""Convert an 8-bit paletted frame into a frame with a color depth of 32 bits.

The output frame will have the same packed format as the palette.

Arguments:
- src: The source frame buffer.
- dst: The destination frame buffer.
- num_pixels: The number of pixels to convert.
- palette: Array with [256] entries, which must match color arrangement (RGB or BGR) of src.
"""


comptime sws_convertPalette8ToPacked24 = ExternalFunction[
    "sws_convertPalette8ToPacked24",
    fn (
        src: UnsafePointer[c_uchar, ImmutOrigin.external],
        dst: UnsafePointer[c_uchar, MutOrigin.external],
        num_pixels: c_int,
        palette: UnsafePointer[c_uchar, ImmutOrigin.external],
    ),
]
"""Convert an 8-bit paletted frame into a frame with a color depth of 24 bits.

With the palette format "ABCD", the destination frame ends up with the format "ABC".

Arguments:
- src: The source frame buffer.
- dst: The destination frame buffer.
- num_pixels: The number of pixels to convert.
- palette: Array with [256] entries, which must match color arrangement (RGB or BGR) of src.
"""
