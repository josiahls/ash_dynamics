"https://www.ffmpeg.org/doxygen/8.0/buffer__internal_8h.html"
from ffi import c_uchar, c_uint, c_int
from os.atomic import Atomic, Consistency, fence
from ash_dynamics.primitives._clib import Debug


@fieldwise_init
struct AVBuffer(Debug, TrivialRegisterType):
    "https://www.ffmpeg.org/doxygen/8.0/structAVBuffer.html"
    var data: UnsafePointer[c_uchar, origin=MutExternalOrigin]
    var size: c_uint
    # TODO: Should this just be a c value?
    # var refcount: Atomic[c_uint.dtype]
    var refcount: c_uint
    var free: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        data: UnsafePointer[c_uchar, origin=MutExternalOrigin],
    ) -> NoneType
    var opaque: OpaquePointer[MutExternalOrigin]
    var flags: c_int
    var flags_internal: c_int
