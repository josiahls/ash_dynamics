"""Bindings for https://www.ffmpeg.org/doxygen/8.0/rational_8h_source.html"""
from sys.ffi import c_int
from ash_dynamics.primitives._clib import StructWritable, StructWriter


@fieldwise_init
@register_passable("trivial")
struct AVRational(StructWritable):
    """Represents a rational number.

    References:
    - https://www.ffmpeg.org/doxygen/8.0/structAVRational.html
    """

    var num: c_int
    "Numerator."
    var den: c_int
    "Denominator."

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        print("indent: ", indent)
        struct_writer.write_field["num"](self.num)
        struct_writer.write_field["den"](self.den)
