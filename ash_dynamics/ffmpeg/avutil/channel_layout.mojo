"https://www.ffmpeg.org/doxygen/8.0/channel__layout_8h.html"
from sys.ffi import c_int, c_char, c_ulong_long, c_size_t
from ash_dynamics.primitives._clib import C_Union, ExternalFunction
from utils import StaticTuple
from ash_dynamics.primitives._clib import Debug

from reflection import get_type_name


@register_passable("trivial")
@fieldwise_init("implicit")
struct AVChannel(Debug):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    fn ull(self) -> c_ulong_long:
        return c_ulong_long(self._value)

    fn inc(self) -> Self:
        return Self(self._value + 1)

    comptime AV_CHAN_NONE = Self(-1)

    comptime AV_CHAN_FRONT_LEFT = Self(Self.AV_CHAN_NONE._value).inc()

    comptime AV_CHAN_FRONT_RIGHT = Self(Self.AV_CHAN_FRONT_LEFT._value).inc()

    comptime AV_CHAN_FRONT_CENTER = Self(Self.AV_CHAN_FRONT_RIGHT._value).inc()

    comptime AV_CHAN_LOW_FREQUENCY = Self(
        Self.AV_CHAN_FRONT_CENTER._value
    ).inc()

    comptime AV_CHAN_BACK_LEFT = Self(Self.AV_CHAN_LOW_FREQUENCY._value).inc()
    comptime AV_CHAN_BACK_RIGHT = Self(Self.AV_CHAN_BACK_LEFT._value).inc()
    comptime AV_CHAN_FRONT_LEFT_OF_CENTER = Self(
        Self.AV_CHAN_BACK_RIGHT._value
    ).inc()
    comptime AV_CHAN_FRONT_RIGHT_OF_CENTER = Self(
        Self.AV_CHAN_FRONT_LEFT_OF_CENTER._value
    ).inc()
    comptime AV_CHAN_BACK_CENTER = Self(
        Self.AV_CHAN_FRONT_RIGHT_OF_CENTER._value
    ).inc()
    comptime AV_CHAN_SIDE_LEFT = Self(Self.AV_CHAN_BACK_CENTER._value).inc()
    comptime AV_CHAN_SIDE_RIGHT = Self(Self.AV_CHAN_SIDE_LEFT._value).inc()
    comptime AV_CHAN_TOP_CENTER = Self(Self.AV_CHAN_SIDE_RIGHT._value).inc()
    comptime AV_CHAN_TOP_FRONT_LEFT = Self(Self.AV_CHAN_TOP_CENTER._value).inc()
    comptime AV_CHAN_TOP_FRONT_CENTER = Self(
        Self.AV_CHAN_TOP_FRONT_LEFT._value
    ).inc()
    comptime AV_CHAN_TOP_FRONT_RIGHT = Self(
        Self.AV_CHAN_TOP_FRONT_CENTER._value
    ).inc()
    comptime AV_CHAN_TOP_BACK_LEFT = Self(
        Self.AV_CHAN_TOP_FRONT_RIGHT._value
    ).inc()
    comptime AV_CHAN_TOP_BACK_CENTER = Self(
        Self.AV_CHAN_TOP_BACK_LEFT._value
    ).inc()
    comptime AV_CHAN_TOP_BACK_RIGHT = Self(
        Self.AV_CHAN_TOP_BACK_CENTER._value
    ).inc()
    comptime AV_CHAN_STEREO_LEFT = Self(29)
    comptime AV_CHAN_STEREO_RIGHT = Self(Self.AV_CHAN_STEREO_LEFT._value).inc()
    comptime AV_CHAN_WIDE_LEFT = Self(Self.AV_CHAN_STEREO_RIGHT._value).inc()
    comptime AV_CHAN_WIDE_RIGHT = Self(Self.AV_CHAN_WIDE_LEFT._value).inc()
    comptime AV_CHAN_SURROUND_DIRECT_LEFT = Self(
        Self.AV_CHAN_WIDE_RIGHT._value
    ).inc()
    comptime AV_CHAN_SURROUND_DIRECT_RIGHT = Self(
        Self.AV_CHAN_SURROUND_DIRECT_LEFT._value
    ).inc()
    comptime AV_CHAN_LOW_FREQUENCY_2 = Self(
        Self.AV_CHAN_SURROUND_DIRECT_RIGHT._value
    ).inc()
    comptime AV_CHAN_TOP_SIDE_LEFT = Self(
        Self.AV_CHAN_LOW_FREQUENCY_2._value
    ).inc()
    comptime AV_CHAN_TOP_SIDE_RIGHT = Self(
        Self.AV_CHAN_TOP_SIDE_LEFT._value
    ).inc()
    comptime AV_CHAN_BOTTOM_FRONT_CENTER = Self(
        Self.AV_CHAN_TOP_SIDE_RIGHT._value
    ).inc()
    comptime AV_CHAN_BOTTOM_FRONT_LEFT = Self(
        Self.AV_CHAN_BOTTOM_FRONT_CENTER._value
    ).inc()
    comptime AV_CHAN_BOTTOM_FRONT_RIGHT = Self(
        Self.AV_CHAN_BOTTOM_FRONT_LEFT._value
    ).inc()
    comptime AV_CHAN_SIDE_SURROUND_LEFT = Self(
        Self.AV_CHAN_BOTTOM_FRONT_RIGHT._value
    ).inc()
    comptime AV_CHAN_SIDE_SURROUND_RIGHT = Self(
        Self.AV_CHAN_SIDE_SURROUND_LEFT._value
    ).inc()
    comptime AV_CHAN_TOP_SURROUND_LEFT = Self(
        Self.AV_CHAN_SIDE_SURROUND_RIGHT._value
    ).inc()
    comptime AV_CHAN_TOP_SURROUND_RIGHT = Self(
        Self.AV_CHAN_TOP_SURROUND_LEFT._value
    ).inc()

    comptime AV_CHAN_BINAURAL_LEFT = Self(61)
    comptime AV_CHAN_BINAURAL_RIGHT = Self(
        Self.AV_CHAN_BINAURAL_LEFT._value
    ).inc()

    comptime AV_CHAN_UNUSED = Self(0x200)

    comptime AV_CHAN_UNKNOWN = Self(0x300)

    comptime AV_CHAN_AMBISONIC_BASE = Self(0x400)
    comptime AV_CHAN_AMBISONIC_END = Self(0x7FF)


@register_passable("trivial")
@fieldwise_init("implicit")
struct AVChannelOrder(Debug):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    fn inc(self) -> Self:
        return Self(self._value + 1)

    comptime AV_CHANNEL_ORDER_UNSPEC = Self(0)

    comptime AV_CHANNEL_ORDER_NATIVE = Self(
        Self.AV_CHANNEL_ORDER_UNSPEC._value
    ).inc()

    comptime AV_CHANNEL_ORDER_CUSTOM = Self(
        Self.AV_CHANNEL_ORDER_NATIVE._value
    ).inc()

    comptime AV_CHANNEL_ORDER_AMBISONIC = Self(
        Self.AV_CHANNEL_ORDER_CUSTOM._value
    ).inc()

    comptime FF_CHANNEL_ORDER_NB = Self(
        Self.AV_CHANNEL_ORDER_AMBISONIC._value
    ).inc()


# A channel layout is a 64-bits integer with a bit set for every channel.
# The number of bits set must be equal to the number of channels.
# The value 0 means that the channel layout is not known.
# @note this data structure is not powerful enough to handle channels
# combinations that have the same channel multiple times, such as
# dual-mono.

comptime AV_CH_FRONT_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_FRONT_LEFT.ull()
)
comptime AV_CH_FRONT_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_FRONT_RIGHT.ull()
)
comptime AV_CH_FRONT_CENTER = (
    c_ulong_long(1) << AVChannel.AV_CHAN_FRONT_CENTER.ull()
)
comptime AV_CH_LOW_FREQUENCY = (
    c_ulong_long(1) << AVChannel.AV_CHAN_LOW_FREQUENCY.ull()
)
comptime AV_CH_BACK_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_BACK_LEFT.ull()
)
comptime AV_CH_BACK_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_BACK_RIGHT.ull()
)
comptime AV_CH_FRONT_LEFT_OF_CENTER = (
    c_ulong_long(1) << AVChannel.AV_CHAN_FRONT_LEFT_OF_CENTER.ull()
)
comptime AV_CH_FRONT_RIGHT_OF_CENTER = (
    c_ulong_long(1) << AVChannel.AV_CHAN_FRONT_RIGHT_OF_CENTER.ull()
)
comptime AV_CH_BACK_CENTER = (
    c_ulong_long(1) << AVChannel.AV_CHAN_BACK_CENTER.ull()
)
comptime AV_CH_SIDE_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_SIDE_LEFT.ull()
)
comptime AV_CH_SIDE_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_SIDE_RIGHT.ull()
)
comptime AV_CH_TOP_CENTER = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_CENTER.ull()
)
comptime AV_CH_TOP_FRONT_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_FRONT_LEFT.ull()
)
comptime AV_CH_TOP_FRONT_CENTER = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_FRONT_CENTER.ull()
)
comptime AV_CH_TOP_FRONT_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_FRONT_RIGHT.ull()
)
comptime AV_CH_TOP_BACK_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_BACK_LEFT.ull()
)
comptime AV_CH_TOP_BACK_CENTER = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_BACK_CENTER.ull()
)
comptime AV_CH_TOP_BACK_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_BACK_RIGHT.ull()
)
comptime AV_CH_STEREO_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_STEREO_LEFT.ull()
)
comptime AV_CH_STEREO_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_STEREO_RIGHT.ull()
)
comptime AV_CH_WIDE_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_WIDE_LEFT.ull()
)
comptime AV_CH_WIDE_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_WIDE_RIGHT.ull()
)
comptime AV_CH_SURROUND_DIRECT_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_SURROUND_DIRECT_LEFT.ull()
)
comptime AV_CH_SURROUND_DIRECT_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_SURROUND_DIRECT_RIGHT.ull()
)
comptime AV_CH_LOW_FREQUENCY_2 = (
    c_ulong_long(1) << AVChannel.AV_CHAN_LOW_FREQUENCY_2.ull()
)
comptime AV_CH_TOP_SIDE_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_SIDE_LEFT.ull()
)
comptime AV_CH_TOP_SIDE_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_SIDE_RIGHT.ull()
)
comptime AV_CH_BOTTOM_FRONT_CENTER = (
    c_ulong_long(1) << AVChannel.AV_CHAN_BOTTOM_FRONT_CENTER.ull()
)
comptime AV_CH_BOTTOM_FRONT_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_BOTTOM_FRONT_LEFT.ull()
)
comptime AV_CH_BOTTOM_FRONT_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_BOTTOM_FRONT_RIGHT.ull()
)
comptime AV_CH_SIDE_SURROUND_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_SIDE_SURROUND_LEFT.ull()
)
comptime AV_CH_SIDE_SURROUND_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_SIDE_SURROUND_RIGHT.ull()
)
comptime AV_CH_TOP_SURROUND_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_SURROUND_LEFT.ull()
)
comptime AV_CH_TOP_SURROUND_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_TOP_SURROUND_RIGHT.ull()
)
comptime AV_CH_BINAURAL_LEFT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_BINAURAL_LEFT.ull()
)
comptime AV_CH_BINAURAL_RIGHT = (
    c_ulong_long(1) << AVChannel.AV_CHAN_BINAURAL_RIGHT.ull()
)

# Audio channel layouts
comptime AV_CH_LAYOUT_MONO = (AV_CH_FRONT_CENTER)
comptime AV_CH_LAYOUT_STEREO = (AV_CH_FRONT_LEFT | AV_CH_FRONT_RIGHT)
comptime AV_CH_LAYOUT_2POINT1 = (AV_CH_LAYOUT_STEREO | AV_CH_LOW_FREQUENCY)
comptime AV_CH_LAYOUT_2_1 = (AV_CH_LAYOUT_STEREO | AV_CH_BACK_CENTER)
comptime AV_CH_LAYOUT_SURROUND = (AV_CH_LAYOUT_STEREO | AV_CH_FRONT_CENTER)
comptime AV_CH_LAYOUT_3POINT1 = (AV_CH_LAYOUT_SURROUND | AV_CH_LOW_FREQUENCY)
comptime AV_CH_LAYOUT_4POINT0 = (AV_CH_LAYOUT_SURROUND | AV_CH_BACK_CENTER)
comptime AV_CH_LAYOUT_4POINT1 = (AV_CH_LAYOUT_4POINT0 | AV_CH_LOW_FREQUENCY)
comptime AV_CH_LAYOUT_2_2 = (
    AV_CH_LAYOUT_STEREO | AV_CH_SIDE_LEFT | AV_CH_SIDE_RIGHT
)
comptime AV_CH_LAYOUT_QUAD = (
    AV_CH_LAYOUT_STEREO | AV_CH_BACK_LEFT | AV_CH_BACK_RIGHT
)
comptime AV_CH_LAYOUT_5POINT0 = (
    AV_CH_LAYOUT_SURROUND | AV_CH_SIDE_LEFT | AV_CH_SIDE_RIGHT
)
comptime AV_CH_LAYOUT_5POINT1 = (AV_CH_LAYOUT_5POINT0 | AV_CH_LOW_FREQUENCY)
comptime AV_CH_LAYOUT_5POINT0_BACK = (
    AV_CH_LAYOUT_SURROUND | AV_CH_BACK_LEFT | AV_CH_BACK_RIGHT
)
comptime AV_CH_LAYOUT_5POINT1_BACK = (
    AV_CH_LAYOUT_5POINT0_BACK | AV_CH_LOW_FREQUENCY
)
comptime AV_CH_LAYOUT_6POINT0 = (AV_CH_LAYOUT_5POINT0 | AV_CH_BACK_CENTER)
comptime AV_CH_LAYOUT_6POINT0_FRONT = (
    AV_CH_LAYOUT_2_2 | AV_CH_FRONT_LEFT_OF_CENTER | AV_CH_FRONT_RIGHT_OF_CENTER
)
comptime AV_CH_LAYOUT_HEXAGONAL = (
    AV_CH_LAYOUT_5POINT0_BACK | AV_CH_BACK_CENTER
)
comptime AV_CH_LAYOUT_3POINT1POINT2 = (
    AV_CH_LAYOUT_3POINT1 | AV_CH_TOP_FRONT_LEFT | AV_CH_TOP_FRONT_RIGHT
)
comptime AV_CH_LAYOUT_6POINT1 = (AV_CH_LAYOUT_5POINT1 | AV_CH_BACK_CENTER)
comptime AV_CH_LAYOUT_6POINT1_BACK = (
    AV_CH_LAYOUT_5POINT1_BACK | AV_CH_BACK_CENTER
)
comptime AV_CH_LAYOUT_6POINT1_FRONT = (
    AV_CH_LAYOUT_6POINT0_FRONT | AV_CH_LOW_FREQUENCY
)
comptime AV_CH_LAYOUT_7POINT0 = (
    AV_CH_LAYOUT_5POINT0 | AV_CH_BACK_LEFT | AV_CH_BACK_RIGHT
)
comptime AV_CH_LAYOUT_7POINT0_FRONT = (
    AV_CH_LAYOUT_5POINT0
    | AV_CH_FRONT_LEFT_OF_CENTER
    | AV_CH_FRONT_RIGHT_OF_CENTER
)
comptime AV_CH_LAYOUT_7POINT1 = (
    AV_CH_LAYOUT_5POINT1 | AV_CH_BACK_LEFT | AV_CH_BACK_RIGHT
)
comptime AV_CH_LAYOUT_7POINT1_WIDE = (
    AV_CH_LAYOUT_5POINT1
    | AV_CH_FRONT_LEFT_OF_CENTER
    | AV_CH_FRONT_RIGHT_OF_CENTER
)
comptime AV_CH_LAYOUT_7POINT1_WIDE_BACK = (
    AV_CH_LAYOUT_5POINT1_BACK
    | AV_CH_FRONT_LEFT_OF_CENTER
    | AV_CH_FRONT_RIGHT_OF_CENTER
)
comptime AV_CH_LAYOUT_5POINT1POINT2 = (
    AV_CH_LAYOUT_5POINT1 | AV_CH_TOP_FRONT_LEFT | AV_CH_TOP_FRONT_RIGHT
)
comptime AV_CH_LAYOUT_5POINT1POINT2_BACK = (
    AV_CH_LAYOUT_5POINT1_BACK | AV_CH_TOP_FRONT_LEFT | AV_CH_TOP_FRONT_RIGHT
)
comptime AV_CH_LAYOUT_OCTAGONAL = (
    AV_CH_LAYOUT_5POINT0
    | AV_CH_BACK_LEFT
    | AV_CH_BACK_CENTER
    | AV_CH_BACK_RIGHT
)
comptime AV_CH_LAYOUT_CUBE = (
    AV_CH_LAYOUT_QUAD
    | AV_CH_TOP_FRONT_LEFT
    | AV_CH_TOP_FRONT_RIGHT
    | AV_CH_TOP_BACK_LEFT
    | AV_CH_TOP_BACK_RIGHT
)
comptime AV_CH_LAYOUT_5POINT1POINT4_BACK = (
    AV_CH_LAYOUT_5POINT1POINT2 | AV_CH_TOP_BACK_LEFT | AV_CH_TOP_BACK_RIGHT
)
comptime AV_CH_LAYOUT_7POINT1POINT2 = (
    AV_CH_LAYOUT_7POINT1 | AV_CH_TOP_FRONT_LEFT | AV_CH_TOP_FRONT_RIGHT
)
comptime AV_CH_LAYOUT_7POINT1POINT4_BACK = (
    AV_CH_LAYOUT_7POINT1POINT2 | AV_CH_TOP_BACK_LEFT | AV_CH_TOP_BACK_RIGHT
)
comptime AV_CH_LAYOUT_7POINT2POINT3 = (
    AV_CH_LAYOUT_7POINT1POINT2 | AV_CH_TOP_BACK_CENTER | AV_CH_LOW_FREQUENCY_2
)
comptime AV_CH_LAYOUT_9POINT1POINT4_BACK = (
    AV_CH_LAYOUT_7POINT1POINT4_BACK
    | AV_CH_FRONT_LEFT_OF_CENTER
    | AV_CH_FRONT_RIGHT_OF_CENTER
)
comptime AV_CH_LAYOUT_9POINT1POINT6 = (
    AV_CH_LAYOUT_9POINT1POINT4_BACK | AV_CH_TOP_SIDE_LEFT | AV_CH_TOP_SIDE_RIGHT
)
comptime AV_CH_LAYOUT_HEXADECAGONAL = (
    AV_CH_LAYOUT_OCTAGONAL
    | AV_CH_WIDE_LEFT
    | AV_CH_WIDE_RIGHT
    | AV_CH_TOP_BACK_LEFT
    | AV_CH_TOP_BACK_RIGHT
    | AV_CH_TOP_BACK_CENTER
    | AV_CH_TOP_FRONT_CENTER
    | AV_CH_TOP_FRONT_LEFT
    | AV_CH_TOP_FRONT_RIGHT
)
comptime AV_CH_LAYOUT_BINAURAL = (AV_CH_BINAURAL_LEFT | AV_CH_BINAURAL_RIGHT)
comptime AV_CH_LAYOUT_STEREO_DOWNMIX = (AV_CH_STEREO_LEFT | AV_CH_STEREO_RIGHT)
comptime AV_CH_LAYOUT_22POINT2 = (
    AV_CH_LAYOUT_9POINT1POINT6
    | AV_CH_BACK_CENTER
    | AV_CH_LOW_FREQUENCY_2
    | AV_CH_TOP_FRONT_CENTER
    | AV_CH_TOP_CENTER
    | AV_CH_TOP_BACK_CENTER
    | AV_CH_BOTTOM_FRONT_CENTER
    | AV_CH_BOTTOM_FRONT_LEFT
    | AV_CH_BOTTOM_FRONT_RIGHT
)

comptime AV_CH_LAYOUT_7POINT1_TOP_BACK = AV_CH_LAYOUT_5POINT1POINT2_BACK


@fieldwise_init
@register_passable("trivial")
struct AVMatrixEncoding(Debug):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AV_MATRIX_ENCODING_NONE = Self(0)
    comptime AV_MATRIX_ENCODING_DOLBY = Self(1)
    comptime AV_MATRIX_ENCODING_DPLII = Self(2)
    comptime AV_MATRIX_ENCODING_DPLIIX = Self(3)
    comptime AV_MATRIX_ENCODING_DPLIIZ = Self(4)
    comptime AV_MATRIX_ENCODING_DOLBYEX = Self(5)
    comptime AV_MATRIX_ENCODING_DOLBYHEADPHONE = Self(6)
    comptime AV_MATRIX_ENCODING_NB = Self(7)


@register_passable("trivial")
@fieldwise_init
struct AVChannelCustom(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVChannelCustom.html"
    var id: AVChannel.ENUM_DTYPE
    var name: StaticTuple[c_char, 16]
    var opaque: OpaquePointer[MutOrigin.external]


@register_passable("trivial")
@fieldwise_init
struct AVChannelLayout(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVChannelLayout.html"
    var order: AVChannelOrder.ENUM_DTYPE
    var nb_channels: c_int

    var u: C_Union[
        c_ulong_long,
        # Mask of channels present in this layout.
        UnsafePointer[AVChannelCustom, ImmutOrigin.external]
        # Details about which channels are present in this layout.
    ]
    var opaque: OpaquePointer[MutOrigin.external]


fn AV_CHANNEL_LAYOUT_MASK(nb: c_int, m: c_ulong_long) -> AVChannelLayout:
    return AVChannelLayout(
        order=AVChannelOrder.AV_CHANNEL_ORDER_NATIVE._value,
        nb_channels=nb,
        u=m,
        opaque=OpaquePointer[MutOrigin.external](),
    )


# Common pre-defined channel layouts
comptime AV_CHANNEL_LAYOUT_MONO = AV_CHANNEL_LAYOUT_MASK(1, AV_CH_LAYOUT_MONO)
comptime AV_CHANNEL_LAYOUT_STEREO = AV_CHANNEL_LAYOUT_MASK(
    2, AV_CH_LAYOUT_STEREO
)
comptime AV_CHANNEL_LAYOUT_2POINT1 = AV_CHANNEL_LAYOUT_MASK(
    3, AV_CH_LAYOUT_2POINT1
)
comptime AV_CHANNEL_LAYOUT_2_1 = AV_CHANNEL_LAYOUT_MASK(3, AV_CH_LAYOUT_2_1)
comptime AV_CHANNEL_LAYOUT_SURROUND = AV_CHANNEL_LAYOUT_MASK(
    3, AV_CH_LAYOUT_SURROUND
)
comptime AV_CHANNEL_LAYOUT_3POINT1 = AV_CHANNEL_LAYOUT_MASK(
    4, AV_CH_LAYOUT_3POINT1
)
comptime AV_CHANNEL_LAYOUT_4POINT0 = AV_CHANNEL_LAYOUT_MASK(
    4, AV_CH_LAYOUT_4POINT0
)
comptime AV_CHANNEL_LAYOUT_4POINT1 = AV_CHANNEL_LAYOUT_MASK(
    5, AV_CH_LAYOUT_4POINT1
)
comptime AV_CHANNEL_LAYOUT_2_2 = AV_CHANNEL_LAYOUT_MASK(4, AV_CH_LAYOUT_2_2)
comptime AV_CHANNEL_LAYOUT_QUAD = AV_CHANNEL_LAYOUT_MASK(4, AV_CH_LAYOUT_QUAD)
comptime AV_CHANNEL_LAYOUT_5POINT0 = AV_CHANNEL_LAYOUT_MASK(
    5, AV_CH_LAYOUT_5POINT0
)
comptime AV_CHANNEL_LAYOUT_5POINT1 = AV_CHANNEL_LAYOUT_MASK(
    6, AV_CH_LAYOUT_5POINT1
)
comptime AV_CHANNEL_LAYOUT_5POINT0_BACK = AV_CHANNEL_LAYOUT_MASK(
    5, AV_CH_LAYOUT_5POINT0_BACK
)
comptime AV_CHANNEL_LAYOUT_5POINT1_BACK = AV_CHANNEL_LAYOUT_MASK(
    6, AV_CH_LAYOUT_5POINT1_BACK
)
comptime AV_CHANNEL_LAYOUT_6POINT0 = AV_CHANNEL_LAYOUT_MASK(
    6, AV_CH_LAYOUT_6POINT0
)
comptime AV_CHANNEL_LAYOUT_6POINT0_FRONT = AV_CHANNEL_LAYOUT_MASK(
    6, AV_CH_LAYOUT_6POINT0_FRONT
)
comptime AV_CHANNEL_LAYOUT_3POINT1POINT2 = AV_CHANNEL_LAYOUT_MASK(
    6, AV_CH_LAYOUT_3POINT1POINT2
)
comptime AV_CHANNEL_LAYOUT_HEXAGONAL = AV_CHANNEL_LAYOUT_MASK(
    6, AV_CH_LAYOUT_HEXAGONAL
)
comptime AV_CHANNEL_LAYOUT_6POINT1 = AV_CHANNEL_LAYOUT_MASK(
    7, AV_CH_LAYOUT_6POINT1
)
comptime AV_CHANNEL_LAYOUT_6POINT1_BACK = AV_CHANNEL_LAYOUT_MASK(
    7, AV_CH_LAYOUT_6POINT1_BACK
)
comptime AV_CHANNEL_LAYOUT_6POINT1_FRONT = AV_CHANNEL_LAYOUT_MASK(
    7, AV_CH_LAYOUT_6POINT1_FRONT
)
comptime AV_CHANNEL_LAYOUT_7POINT0 = AV_CHANNEL_LAYOUT_MASK(
    7, AV_CH_LAYOUT_7POINT0
)
comptime AV_CHANNEL_LAYOUT_7POINT0_FRONT = AV_CHANNEL_LAYOUT_MASK(
    7, AV_CH_LAYOUT_7POINT0_FRONT
)
comptime AV_CHANNEL_LAYOUT_7POINT1 = AV_CHANNEL_LAYOUT_MASK(
    8, AV_CH_LAYOUT_7POINT1
)
comptime AV_CHANNEL_LAYOUT_7POINT1_WIDE = AV_CHANNEL_LAYOUT_MASK(
    8, AV_CH_LAYOUT_7POINT1_WIDE
)
comptime AV_CHANNEL_LAYOUT_7POINT1_WIDE_BACK = AV_CHANNEL_LAYOUT_MASK(
    8, AV_CH_LAYOUT_7POINT1_WIDE_BACK
)
comptime AV_CHANNEL_LAYOUT_5POINT1POINT2 = AV_CHANNEL_LAYOUT_MASK(
    8, AV_CH_LAYOUT_5POINT1POINT2
)
comptime AV_CHANNEL_LAYOUT_5POINT1POINT2_BACK = AV_CHANNEL_LAYOUT_MASK(
    8, AV_CH_LAYOUT_5POINT1POINT2_BACK
)
comptime AV_CHANNEL_LAYOUT_OCTAGONAL = AV_CHANNEL_LAYOUT_MASK(
    8, AV_CH_LAYOUT_OCTAGONAL
)
comptime AV_CHANNEL_LAYOUT_CUBE = AV_CHANNEL_LAYOUT_MASK(8, AV_CH_LAYOUT_CUBE)
comptime AV_CHANNEL_LAYOUT_5POINT1POINT4_BACK = AV_CHANNEL_LAYOUT_MASK(
    10, AV_CH_LAYOUT_5POINT1POINT4_BACK
)
comptime AV_CHANNEL_LAYOUT_7POINT1POINT2 = AV_CHANNEL_LAYOUT_MASK(
    10, AV_CH_LAYOUT_7POINT1POINT2
)
comptime AV_CHANNEL_LAYOUT_7POINT1POINT4_BACK = AV_CHANNEL_LAYOUT_MASK(
    12, AV_CH_LAYOUT_7POINT1POINT4_BACK
)
comptime AV_CHANNEL_LAYOUT_7POINT2POINT3 = AV_CHANNEL_LAYOUT_MASK(
    12, AV_CH_LAYOUT_7POINT2POINT3
)
comptime AV_CHANNEL_LAYOUT_9POINT1POINT4_BACK = AV_CHANNEL_LAYOUT_MASK(
    14, AV_CH_LAYOUT_9POINT1POINT4_BACK
)
comptime AV_CHANNEL_LAYOUT_9POINT1POINT6 = AV_CHANNEL_LAYOUT_MASK(
    16, AV_CH_LAYOUT_9POINT1POINT6
)
comptime AV_CHANNEL_LAYOUT_HEXADECAGONAL = AV_CHANNEL_LAYOUT_MASK(
    16, AV_CH_LAYOUT_HEXADECAGONAL
)
comptime AV_CHANNEL_LAYOUT_BINAURAL = AV_CHANNEL_LAYOUT_MASK(
    2, AV_CH_LAYOUT_BINAURAL
)
comptime AV_CHANNEL_LAYOUT_STEREO_DOWNMIX = AV_CHANNEL_LAYOUT_MASK(
    2, AV_CH_LAYOUT_STEREO_DOWNMIX
)
comptime AV_CHANNEL_LAYOUT_22POINT2 = AV_CHANNEL_LAYOUT_MASK(
    24, AV_CH_LAYOUT_22POINT2
)

comptime AV_CHANNEL_LAYOUT_7POINT1_TOP_BACK = AV_CHANNEL_LAYOUT_5POINT1POINT2_BACK


fn AV_CHANNEL_LAYOUT_AMBISONIC_FIRST_ORDER() -> AVChannelLayout:
    return AVChannelLayout(
        order=AVChannelOrder.AV_CHANNEL_ORDER_AMBISONIC._value,
        nb_channels=4,
        u=0,
        opaque=OpaquePointer[MutOrigin.external](),
    )


comptime av_channel_name = ExternalFunction[
    "av_channel_name",
    fn (
        buf: UnsafePointer[c_char, MutOrigin.external],
        buf_size: c_size_t,
        channel: AVChannel.ENUM_DTYPE,
    ) -> c_int,
]

# bprint variant of av_channel_name().
# @note the string will be appended to the bprint buffer.
# void av_channel_name_bprint(struct AVBPrint *bp, enum AVChannel channel_id);


comptime av_channel_description = ExternalFunction[
    "av_channel_description",
    fn (
        buf: UnsafePointer[c_char, MutOrigin.external],
        buf_size: c_size_t,
        channel: AVChannel.ENUM_DTYPE,
    ) -> c_int,
]


# bprint variant of av_channel_description().
# @note the string will be appended to the bprint buffer.
# void av_channel_description_bprint(struct AVBPrint *bp, enum AVChannel channel_id);


comptime av_channel_from_string = ExternalFunction[
    "av_channel_from_string",
    fn (
        str: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> AVChannel.ENUM_DTYPE,
]

comptime av_channel_layout_custom_init = ExternalFunction[
    "av_channel_layout_custom_init",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        nb_channels: c_int,
    ) -> c_int,
]


comptime av_channel_layout_from_mask = ExternalFunction[
    "av_channel_layout_from_mask",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        mask: c_ulong_long,
    ) -> c_int,
]


comptime av_channel_layout_from_string = ExternalFunction[
    "av_channel_layout_from_string",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        str: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> c_int,
]

comptime av_channel_layout_default = ExternalFunction[
    "av_channel_layout_default",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        nb_channels: c_int,
    ),
]


comptime av_channel_layout_standard = ExternalFunction[
    "av_channel_layout_standard",
    fn (
        opaque: UnsafePointer[
            OpaquePointer[MutOrigin.external], MutOrigin.external
        ],
    ) -> UnsafePointer[AVChannelLayout, ImmutOrigin.external],
]


comptime av_channel_layout_uninit = ExternalFunction[
    "av_channel_layout_uninit",
    fn (channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],),
]


comptime av_channel_layout_copy = ExternalFunction[
    "av_channel_layout_copy",
    fn (
        dst: UnsafePointer[AVChannelLayout, MutOrigin.external],
        src: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
    ) -> c_int,
]


comptime av_channel_layout_describe = ExternalFunction[
    "av_channel_layout_describe",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        buf: UnsafePointer[c_char, MutOrigin.external],
        buf_size: c_size_t,
    ) -> c_int,
]


# bprint variant of av_channel_layout_describe().
#
# @note the string will be appended to the bprint buffer.
# @return 0 on success, or a negative AVERROR value on failure.
# int av_channel_layout_describe_bprint(const AVChannelLayout *channel_layout,
#   struct AVBPrint *bp);


comptime av_channel_layout_channel_from_index = ExternalFunction[
    "av_channel_layout_channel_from_index",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        idx: c_int,
    ) -> AVChannel.ENUM_DTYPE,
]


comptime av_channel_layout_index_from_channel = ExternalFunction[
    "av_channel_layout_index_from_channel",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        channel: AVChannel.ENUM_DTYPE,
    ) -> c_int,
]


comptime av_channel_layout_index_from_string = ExternalFunction[
    "av_channel_layout_index_from_string",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        str: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> c_int,
]


comptime av_channel_layout_channel_from_string = ExternalFunction[
    "av_channel_layout_channel_from_string",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        str: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> AVChannel.ENUM_DTYPE,
]


comptime av_channel_layout_subset = ExternalFunction[
    "av_channel_layout_subset",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        mask: c_ulong_long,
    ) -> c_ulong_long,
]


comptime av_channel_layout_check = ExternalFunction[
    "av_channel_layout_check",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
    ) -> c_int,
]


comptime av_channel_layout_compare = ExternalFunction[
    "av_channel_layout_compare",
    fn (
        chl: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        chl1: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
    ) -> c_int,
]


comptime av_channel_layout_ambisonic_order = ExternalFunction[
    "av_channel_layout_ambisonic_order",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
    ) -> c_int,
]


comptime AV_CHANNEL_LAYOUT_RETYPE_FLAG_LOSSLESS = (1 << 0)

comptime AV_CHANNEL_LAYOUT_RETYPE_FLAG_CANONICAL = (1 << 1)

comptime av_channel_layout_retype = ExternalFunction[
    "av_channel_layout_retype",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        order: AVChannelOrder.ENUM_DTYPE,
        flags: c_int,
    ) -> c_int,
]
