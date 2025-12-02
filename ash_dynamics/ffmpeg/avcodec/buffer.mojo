"""Bindings for https://www.ffmpeg.org/doxygen/8.0/buffer_8h_source.html"""
from sys.ffi import c_uchar, c_uint, c_int
from os.atomic import Atomic
from ash_dynamics.ffmpeg.avcodec.buffer_internal import AVBuffer


struct AVBufferRef:
    """Represents a reference to a data buffer.

    References:
    - https://www.ffmpeg.org/doxygen/8.0/structAVBufferRef.html
    """

    var buffer: UnsafePointer[AVBuffer, origin = MutOrigin.external]
    "The buffer."
    var data: UnsafePointer[c_uchar, origin = MutOrigin.external]
    "The data buffer."
    var size: c_uint
    "Size of data in bytes."
