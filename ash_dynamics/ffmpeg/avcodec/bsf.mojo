"https://www.ffmpeg.org/doxygen/8.0/bsf_8h.html"
from ash_dynamics.primitives._clib import Debug
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avcodec.codec_par import AVCodecParameters
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from sys.ffi import c_int, c_char
from utils import StaticTuple


@fieldwise_init
@register_passable("trivial")
struct AVBSFContext(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVBSFContext.html"

    var av_class: UnsafePointer[AVClass, origin = ImmutOrigin.external]
    var filter: UnsafePointer[AVBitStreamFilter, origin = ImmutOrigin.external]
    var priv_data: OpaquePointer[MutOrigin.external]
    var par_in: UnsafePointer[AVCodecParameters, origin = ImmutOrigin.external]
    var par_out: UnsafePointer[AVCodecParameters, origin = ImmutOrigin.external]
    var time_base_in: AVRational
    var time_base_out: AVRational


@fieldwise_init
@register_passable("trivial")
struct AVBitStreamFilter(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVBitStreamFilter.html"
    var name: UnsafePointer[c_char, origin = ImmutOrigin.external]

    var codec_ids: UnsafePointer[
        AVCodecID.ENUM_DTYPE, origin = ImmutOrigin.external
    ]
    var priv_class: UnsafePointer[AVClass, origin = ImmutOrigin.external]
