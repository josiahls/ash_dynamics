from sys.ffi import c_int, c_char, c_ulong_long
from ash_dynamics.primitives._clib import C_Union
from utils import StaticTuple
from ash_dynamics.primitives._clib import StructWritable, StructWriter

from compile.reflection import get_type_name


@register_passable("trivial")
@fieldwise_init("implicit")
struct AVChannel:
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVChannel.html
    """

    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    fn inc(self) -> Self:
        "Returns a copy of self but with +1 added."
        return Self(self._value + 1)

    comptime AV_CHAN_NONE = Self(-1)
    """Invalid channel index."""

    comptime AV_CHAN_FRONT_LEFT = Self(Self.AV_CHAN_NONE._value).inc()
    """Front left channel."""

    comptime AV_CHAN_FRONT_RIGHT = Self(Self.AV_CHAN_FRONT_LEFT._value).inc()
    """Front right channel."""

    comptime AV_CHAN_FRONT_CENTER = Self(Self.AV_CHAN_FRONT_RIGHT._value).inc()
    """Front center channel."""

    comptime AV_CHAN_LOW_FREQUENCY = Self(
        Self.AV_CHAN_FRONT_CENTER._value
    ).inc()
    """Low frequency channel."""

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
    """Stereo downmix."""
    comptime AV_CHAN_STEREO_RIGHT = Self(Self.AV_CHAN_STEREO_LEFT._value).inc()
    """See above."""
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
    """+90 degrees, Lss, SiL"""
    comptime AV_CHAN_SIDE_SURROUND_RIGHT = Self(
        Self.AV_CHAN_SIDE_SURROUND_LEFT._value
    ).inc()
    """-90 degrees, Rss, SiR"""
    comptime AV_CHAN_TOP_SURROUND_LEFT = Self(
        Self.AV_CHAN_SIDE_SURROUND_RIGHT._value
    ).inc()
    """+110 degrees, Lvs, TpLS"""
    comptime AV_CHAN_TOP_SURROUND_RIGHT = Self(
        Self.AV_CHAN_TOP_SURROUND_LEFT._value
    ).inc()
    """-110 degrees, Rvs, TpRS"""

    comptime AV_CHAN_BINAURAL_LEFT = Self(61)
    comptime AV_CHAN_BINAURAL_RIGHT = Self(
        Self.AV_CHAN_BINAURAL_LEFT._value
    ).inc()
    """Binaural left channel."""

    comptime AV_CHAN_UNUSED = Self(0x200)
    "Channel is empty can be safely skipped."

    comptime AV_CHAN_UNKNOWN = Self(0x300)
    "Channel contains data, but its position is unknown."

    comptime AV_CHAN_AMBISONIC_BASE = Self(0x400)
    """Range of channels between AV_CHAN_AMBISONIC_BASE and
    AV_CHAN_AMBISONIC_END represent Ambisonic components using the ACN system.

    Given a channel id `<i>` between AV_CHAN_AMBISONIC_BASE and
    AV_CHAN_AMBISONIC_END (inclusive), the ACN index of the channel `<n>` is
    `<n> = <i> - AV_CHAN_AMBISONIC_BASE`.

    @note these values are only used for AV_CHANNEL_ORDER_CUSTOM channel
    orderings, the AV_CHANNEL_ORDER_AMBISONIC ordering orders the channels
    implicitly by their position in the stream.
    """
    comptime AV_CHAN_AMBISONIC_END = Self(0x7FF)
    """Leave space for 1024 ids, which correspond to maximum order-32 harmonics,
    which should be enough for the foreseeable use cases."""


@register_passable("trivial")
@fieldwise_init
struct AVChannelLayout(StructWritable):
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVChannelLayout.html
    """

    var order: AVChannelOrder.ENUM_DTYPE
    "Channel order used in this layout."
    var nb_channels: c_int
    "Number of channels in this layout."

    var u: C_Union[
        c_ulong_long,
        # Mask of channels present in this layout.
        UnsafePointer[AVChannelCustom, ImmutOrigin.external]
        # Details about which channels are present in this layout.
    ]
    var opaque: OpaquePointer[MutOrigin.external]
    "For some private data of the user."

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["order"](self.order)
        struct_writer.write_field["nb_channels"](self.nb_channels)
        # self.field_write_to("u", self.u, writer, indent=indent)
        struct_writer.write_field["opaque"](self.opaque)


@register_passable("trivial")
@fieldwise_init("implicit")
struct AVChannelOrder:
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVChannelOrder.html
    """

    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    fn inc(self) -> Self:
        "Returns a copy of self but with +1 added."
        return Self(self._value + 1)

    comptime AV_CHANNEL_ORDER_UNSPEC = Self(0)
    """Only the channel count is specified, without any further information
     * about the channel order."""

    comptime AV_CHANNEL_ORDER_NATIVE = Self(
        Self.AV_CHANNEL_ORDER_UNSPEC._value
    ).inc()
    """The native channel order, i.e. the channels are in the same order in
    which they are defined in the AVChannel enum. This supports up to 63
    different channels."""

    comptime AV_CHANNEL_ORDER_CUSTOM = Self(
        Self.AV_CHANNEL_ORDER_NATIVE._value
    ).inc()
    """The channel order does not correspond to any other predefined order and
    is stored as an explicit map. For example, this could be used to support
    layouts with 64 or more channels, or with empty/skipped (AV_CHAN_UNUSED)
    channels at arbitrary positions.
    
    The channel order does not correspond to any other predefined order and
    is stored as an explicit map. For example, this could be used to support
    layouts with 64 or more channels, or with empty/skipped (AV_CHAN_UNUSED)
    channels at arbitrary positions.

    The audio is represented as the decomposition of the sound field into
    spherical harmonics. Each channel corresponds to a single expansion
    component. Channels are ordered according to ACN (Ambisonic Channel
    Number).

    The channel with the index n in the stream contains the spherical
    harmonic of degree l and order m given by
    @code{.unparsed}
    l   = floor(sqrt(n)),
    m   = n - l * (l + 1).
    @endcode

    Conversely given a spherical harmonic of degree l and order m, the
    corresponding channel index n is given by
    @code{.unparsed}
    n = l * (l + 1) + m.
    @endcode

    Normalization is assumed to be SN3D (Schmidt Semi-Normalization)
    as defined in AmbiX format $ 2.1.
    """

    comptime AV_CHANNEL_ORDER_AMBISONIC = Self(
        Self.AV_CHANNEL_ORDER_CUSTOM._value
    ).inc()
    """The audio is represented as the decomposition of the sound field into
    spherical harmonics. Each channel corresponds to a single expansion
    component. Channels are ordered according to ACN (Ambisonic Channel
    Number).

    The channel with the index n in the stream contains the spherical
    harmonic of degree l and order m given by
    @code{.unparsed}
    l   = floor(sqrt(n)),
    m   = n - l * (l + 1).
    @endcode

    Conversely given a spherical harmonic of degree l and order m, the
    corresponding channel index n is given by
    @code{.unparsed}
    n = l * (l + 1) + m.
    @endcode

    Normalization is assumed to be SN3D (Schmidt Semi-Normalization)
    as defined in AmbiX format $ 2.1.
    """

    comptime FF_CHANNEL_ORDER_NB = Self(
        Self.AV_CHANNEL_ORDER_AMBISONIC._value
    ).inc()
    """Number of channel orders, not part of ABI/API"""


@register_passable("trivial")
@fieldwise_init
struct AVChannelCustom:
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVChannelCustom.html
    """

    var id: AVChannel.ENUM_DTYPE
    "Channel ID."
    var name: StaticTuple[c_char, 16]
    "Channel name."
    var opaque: OpaquePointer[MutOrigin.external]
    "Opaque data."
