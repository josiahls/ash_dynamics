"""Bindings for https://www.ffmpeg.org/doxygen/8.0/rational_8h_source.html"""
from sys.ffi import c_int


@fieldwise_init
@register_passable("trivial")
struct AVRational(Movable):
    """Represents a rational number.

    References:
    - https://www.ffmpeg.org/doxygen/8.0/structAVRational.html
    """

    var num: c_int
    "Numerator."
    var den: c_int
    "Denominator."
