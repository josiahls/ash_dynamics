"""Bindings for https://www.ffmpeg.org/doxygen/8.0/buffer_8h_source.html"""
from sys.ffi import c_uchar, c_uint, c_int
from os.atomic import Atomic
from ash_dynamics.ffmpeg.avutil.buffer_internal import AVBuffer
from ash_dynamics.primitives._clib import StructWritable, StructWriter


@fieldwise_init
@register_passable("trivial")
struct AVBufferRef(StructWritable):
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

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["buffer"](self.buffer)
        struct_writer.write_field["data"](self.data)
        struct_writer.write_field["size"](self.size)
