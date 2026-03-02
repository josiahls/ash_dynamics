"https://www.ffmpeg.org/doxygen/8.0/buffer__internal_8h.html"
from ffi import c_uchar, c_uint, c_int
from os.atomic import Atomic, Consistency, fence


@fieldwise_init
struct AVBuffer(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVBuffer.html"
    var data: UnsafePointer[c_uchar, origin=MutAnyOrigin]
    var size: c_uint
    # TODO: Should this just be a c value?
    # var refcount: Atomic[c_uint.dtype]
    var refcount: c_uint
    var free: fn(
        opaque: OpaquePointer[MutAnyOrigin],
        data: UnsafePointer[c_uchar, origin=MutAnyOrigin],
    ) -> NoneType
    var opaque: OpaquePointer[MutAnyOrigin]
    var flags: c_int
    var flags_internal: c_int
