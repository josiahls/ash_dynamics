from sys.ffi import c_int, c_uint, c_long_long, c_ulong_long
from ash_dynamics.primitives._clib import Debug


comptime AV_NOPTS_VALUE = c_long_long(c_ulong_long(0x8000000000000000))
"""Undefined timestamp value

Usually reported by demuxer that work on containers that do not provide
either pts or dts.
"""


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVPictureType(Debug):
    comptime ENUM_DTYPE = c_int

    var _value: Self.ENUM_DTYPE

    comptime AV_PICTURE_TYPE_NONE = Self(0)
    "Undefined"
    comptime AV_PICTURE_TYPE_I = Self(1)
    "Intra"
    comptime AV_PICTURE_TYPE_P = Self(2)
    "Predicted"
    comptime AV_PICTURE_TYPE_B = Self(3)
    "Bi-dir predicted"
    comptime AV_PICTURE_TYPE_S = Self(4)
    "S(GMC)-VOP MPEG-4"
    comptime AV_PICTURE_TYPE_SI = Self(5)
    "Switching Intra"
    comptime AV_PICTURE_TYPE_SP = Self(6)
    "Switching Predicted"
    comptime AV_PICTURE_TYPE_BI = Self(7)
    "BI type"


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVMediaType(Debug):
    comptime ENUM_DTYPE = c_uint

    var _value: Self.ENUM_DTYPE

    fn inc(self) -> Self:
        "Returns a copy of self but with +1 added."
        return Self(self._value + 1)

    # < Usually treated as AVMEDIA_TYPE_DATA
    comptime AVMEDIA_TYPE_UNKNOWN = Self(-1)
    comptime AVMEDIA_TYPE_VIDEO = Self(Self.AVMEDIA_TYPE_UNKNOWN._value).inc()
    comptime AVMEDIA_TYPE_AUDIO = Self(Self.AVMEDIA_TYPE_VIDEO._value).inc()

    # < Opaque data information usually continuous
    comptime AVMEDIA_TYPE_DATA = Self(Self.AVMEDIA_TYPE_AUDIO._value).inc()
    comptime AVMEDIA_TYPE_SUBTITLE = Self(Self.AVMEDIA_TYPE_DATA._value).inc()

    # < Opaque data information usually sparse
    comptime AVMEDIA_TYPE_ATTACHMENT = Self(
        Self.AVMEDIA_TYPE_SUBTITLE._value
    ).inc()
    comptime AVMEDIA_TYPE_NB = Self(Self.AVMEDIA_TYPE_ATTACHMENT._value).inc()
