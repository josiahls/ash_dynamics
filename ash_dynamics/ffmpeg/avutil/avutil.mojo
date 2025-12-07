from sys.ffi import c_int, c_uint


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVMediaType:
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
