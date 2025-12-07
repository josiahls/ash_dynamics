"""Bindings for https://www.ffmpeg.org/doxygen/8.0/buffer__internal_8h_source.html"""
from sys.ffi import c_uchar, c_uint, c_int
from os.atomic import Atomic, Consistency, fence


@register_passable("trivial")
@fieldwise_init
struct AVBuffer:
    """Represents a buffer.

    References:
    - https://www.ffmpeg.org/doxygen/8.0/structAVBuffer.html
    """

    var data: UnsafePointer[c_uchar, origin = MutOrigin.external]
    "Data described by this buffer."
    var size: c_uint
    "Size of data in bytes."
    # TODO: Should this just be a c value?
    # var refcount: Atomic[c_uint.dtype]
    var refcount: c_uint
    "Number of existing AVBufferRef instances referring to this buffer."
    var free: fn (
        opaque: OpaquePointer[MutOrigin.external],
        data: UnsafePointer[c_uchar, origin = MutOrigin.external],
    ) -> NoneType
    "Callback for freeing the data."
    var opaque: OpaquePointer[MutOrigin.external]
    "Opaque pointer, to be used by the freeing callback."
    var flags: c_int
    "A combination of AV_BUFFER_FLAG_*."
    var flags_internal: c_int
    "A combination of BUFFER_FLAG_*."
