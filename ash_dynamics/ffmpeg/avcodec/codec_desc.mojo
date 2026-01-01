from sys.ffi import c_char, c_int
from ash_dynamics.primitives._clib import Debug
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avcodec.codec import AVProfile


@fieldwise_init
@register_passable("trivial")
struct AVCodecDescriptor(Debug):
    """This struct describes the properties of a single codec described by an
    AVCodecID.
    """

    var id: AVCodecID.ENUM_DTYPE
    var type: AVMediaType.ENUM_DTYPE

    var name: UnsafePointer[c_char, ImmutOrigin.external]
    """name of the codec described by this descriptor. It is non-empty and
    unique for each codec descriptor. It should contain alphanumeric
    characters and '_' only.
    """
    var long_name: UnsafePointer[c_char, ImmutOrigin.external]
    """a more descriptive name for this codec. May be NULL.
    """
    var props: c_int
    """codec properties, a combination of AV_CODEC_PROP_* flags.
    """
    var mime_types: UnsafePointer[c_char, MutOrigin.external]
    """MIME type(s) associated with the codec. May be NULL; if not, a 
    NULL-terminated array of MIME types. The first item is always non-NULL and 
    is the preferred MIME type.
    """
    var profiles: UnsafePointer[AVProfile, MutOrigin.external]
    """If non-NULL, an array of profiles recognized for this codec.
    Terminated with AV_PROFILE_UNKNOWN.
    """
