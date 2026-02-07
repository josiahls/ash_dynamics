"https://www.ffmpeg.org/doxygen/8.0/codec__desc_8h.html"
from ffi import c_char, c_int
from ash_dynamics.primitives._clib import Debug
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avcodec.codec import AVProfile


@fieldwise_init
struct AVCodecDescriptor(Debug, TrivialRegisterType):
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecDescriptor.html"

    var id: AVCodecID.ENUM_DTYPE
    var type: AVMediaType.ENUM_DTYPE

    var name: UnsafePointer[c_char, ImmutExternalOrigin]
    var long_name: UnsafePointer[c_char, ImmutExternalOrigin]
    var props: c_int
    var mime_types: UnsafePointer[c_char, MutExternalOrigin]
    var profiles: UnsafePointer[AVProfile, MutExternalOrigin]
