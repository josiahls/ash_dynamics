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

    var av_class: UnsafePointer[AVClass, origin=ImmutExternalOrigin]
    var filter: UnsafePointer[AVBitStreamFilter, origin=ImmutExternalOrigin]
    var priv_data: OpaquePointer[MutExternalOrigin]
    var par_in: UnsafePointer[AVCodecParameters, origin=ImmutExternalOrigin]
    var par_out: UnsafePointer[AVCodecParameters, origin=ImmutExternalOrigin]
    var time_base_in: AVRational
    var time_base_out: AVRational


@fieldwise_init
@register_passable("trivial")
struct AVBitStreamFilter(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVBitStreamFilter.html"
    var name: UnsafePointer[c_char, origin=ImmutExternalOrigin]

    var codec_ids: UnsafePointer[
        AVCodecID.ENUM_DTYPE, origin=ImmutExternalOrigin
    ]
    var priv_class: UnsafePointer[AVClass, origin=ImmutExternalOrigin]
