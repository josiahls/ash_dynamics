from ash_dynamics.primitives._clib import Debug
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avcodec.codec_par import AVCodecParameters
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from sys.ffi import c_int, c_char
from utils import StaticTuple


@fieldwise_init
@register_passable("trivial")
struct AVBSFContext(Debug):
    """The bitstream filter state.

    This struct must be allocated with av_bsf_alloc() and freed with
    av_bsf_free().

    The fields in the struct will only be changed (by the caller or by the
    filter) as described in their documentation, and are to be considered
    immutable otherwise.
    """

    var av_class: UnsafePointer[AVClass, origin = ImmutOrigin.external]
    """A class for logging and AVOptions."""
    var filter: UnsafePointer[AVBitStreamFilter, origin = ImmutOrigin.external]
    """The bitstream filter this context is an instance of."""
    var priv_data: OpaquePointer[MutOrigin.external]
    """Opaque filter-specific private data. If filter->priv_class is non-NULL,
    this is an AVOptions-enabled struct."""
    var par_in: UnsafePointer[AVCodecParameters, origin = ImmutOrigin.external]
    """Parameters of the input stream. This field is allocated in
    av_bsf_alloc(), it needs to be filled by the caller before
    av_bsf_init()."""
    var par_out: UnsafePointer[AVCodecParameters, origin = ImmutOrigin.external]
    """Parameters of the output stream. This field is allocated in
    av_bsf_alloc(), it is set by the filter in av_bsf_init()."""
    var time_base_in: AVRational
    """The timebase used for the timestamps of the input packets. Set by the
    caller before av_bsf_init()."""
    var time_base_out: AVRational
    """The timebase used for the timestamps of the output packets. Set by the
    filter in av_bsf_init()."""


@fieldwise_init
@register_passable("trivial")
struct AVBitStreamFilter(Debug):
    var name: UnsafePointer[c_char, origin = ImmutOrigin.external]

    var codec_ids: UnsafePointer[
        AVCodecID.ENUM_DTYPE, origin = ImmutOrigin.external
    ]
    """A list of codec ids supported by the filter, terminated by
    AV_CODEC_ID_NONE.
    May be NULL, in that case the bitstream filter works with any codec id."""
    var priv_class: UnsafePointer[AVClass, origin = ImmutOrigin.external]
    """A class for the private data, used to declare bitstream filter private
    AVOptions. This field is NULL for bitstream filters that do not declare
    any options.
    
    If this field is non-NULL, the first member of the filter private data
    must be a pointer to AVClass, which will be set by libavcodec generic
    code to this class.
    """
