from sys.ffi import c_int, c_char, c_ulong_long, c_size_t
from ash_dynamics.primitives._clib import C_Union, ExternalFunction
from utils import StaticTuple
from ash_dynamics.primitives._clib import StructWritable, StructWriter

from reflection import get_type_name


@register_passable("trivial")
@fieldwise_init("implicit")
struct AVChannel:
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVChannel.html
    """

    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    fn ull(self) -> c_ulong_long:
        return c_ulong_long(self._value)

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
struct AVMatrixEncoding:
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
struct AVChannelCustom:
    """An AVChannelCustom defines a single channel within a custom order layout

    Unlike most structures in FFmpeg, sizeof(AVChannelCustom) is a part of the
    public ABI. No new fields may be added to it without a major version bump.

    No new fields may be added to it without a major version bump.

    Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVChannelCustom.html
    """

    var id: AVChannel.ENUM_DTYPE
    "Channel ID."
    var name: StaticTuple[c_char, 16]
    "Channel name."
    var opaque: OpaquePointer[MutOrigin.external]
    "Opaque data."


@register_passable("trivial")
@fieldwise_init
struct AVChannelLayout(StructWritable):
    """An AVChannelLayout holds information about the channel layout of audio data.

    A channel layout here is defined as a set of channels ordered in a specific
    way (unless the channel order is AV_CHANNEL_ORDER_UNSPEC, in which case an
    AVChannelLayout carries only the channel count).
    All orders may be treated as if they were AV_CHANNEL_ORDER_UNSPEC by
    ignoring everything but the channel count, as long as av_channel_layout_check()
    considers they are valid.

    Unlike most structures in FFmpeg, sizeof(AVChannelLayout) is a part of the
    public ABI and may be used by the caller. E.g. it may be allocated on stack
    or embedded in caller-defined structs.

    AVChannelLayout can be initialized as follows:
    - default initialization with {0}, followed by setting all used fields
        correctly;
    - by assigning one of the predefined AV_CHANNEL_LAYOUT_* initializers;
    - with a constructor function, such as av_channel_layout_default(),
        av_channel_layout_from_mask() or av_channel_layout_from_string().

    The channel layout must be uninitialized with av_channel_layout_uninit()

    Copying an AVChannelLayout via assigning is forbidden,
    av_channel_layout_copy() must be used instead (and its return value should
    be checked)

    No new fields may be added to it without a major version bump, except for
    new elements of the union fitting in sizeof(uint64_t).

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


fn AV_CHANNEL_LAYOUT_MASK(nb: c_int, m: c_ulong_long) -> AVChannelLayout:
    """Macro to define native channel layouts

    Mojo note:
    - In the channel_layout.h this is originally a macro.

    @note This doesn't use designated initializers for compatibility with C++ 17 and older.
    """
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
"""
Get a human readable string in an abbreviated form describing a given channel.
This is the inverse function of @ref av_channel_from_string().

@param buf pre-allocated buffer where to put the generated string
@param buf_size size in bytes of the buffer.
@param channel the AVChannel whose name to get
@return amount of bytes needed to hold the output string, or a negative AVERROR
        on failure. If the returned value is bigger than buf_size, then the
        string was truncated.
"""

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
"""
Get a human readable string describing a given channel.

Args:
- buf: pre-allocated buffer where to put the generated string
- buf_size: size in bytes of the buffer.
- channel: the AVChannel whose description to get
@return amount of bytes needed to hold the output string, or a negative AVERROR
        on failure. If the returned value is bigger than buf_size, then the
        string was truncated.
"""


# bprint variant of av_channel_description().
# @note the string will be appended to the bprint buffer.
# void av_channel_description_bprint(struct AVBPrint *bp, enum AVChannel channel_id);


comptime av_channel_from_string = ExternalFunction[
    "av_channel_from_string",
    fn (
        str: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> AVChannel.ENUM_DTYPE,
]
"""
This is the inverse function of @ref av_channel_name().

@return the channel with the given name
        AV_CHAN_NONE when name does not identify a known channel
"""

comptime av_channel_layout_custom_init = ExternalFunction[
    "av_channel_layout_custom_init",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        nb_channels: c_int,
    ) -> c_int,
]
"""
Initialize a custom channel layout with the specified number of channels.
The channel map will be allocated and the designation of all channels will
be set to AV_CHAN_UNKNOWN.

This is only a convenience helper function, a custom channel layout can also
be constructed without using this.

Args:
- channel_layout: the layout structure to be initialized
- nb_channels: the number of channels
@return 0 on success
        AVERROR(EINVAL) if the number of channels <= 0
        AVERROR(ENOMEM) if the channel map could not be allocated
"""


comptime av_channel_layout_from_mask = ExternalFunction[
    "av_channel_layout_from_mask",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        mask: c_ulong_long,
    ) -> c_int,
]
"""
Initialize a native channel layout from a bitmask indicating which channels
are present.

Args:
- channel_layout: the layout structure to be initialized
- mask: bitmask describing the channel layout
@return 0 on success
        AVERROR(EINVAL) for invalid mask values
"""


comptime av_channel_layout_from_string = ExternalFunction[
    "av_channel_layout_from_string",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        str: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> c_int,
]
"""
Initialize a channel layout from a given string description.
The input string can be represented by:
- the formal channel layout name (returned by av_channel_layout_describe())
- single or multiple channel names (returned by av_channel_name(), eg. "FL",
  or concatenated with "+", each optionally containing a custom name after
  a "@", eg. "FL@Left+FR@Right+LFE")
- a decimal or hexadecimal value of a native channel layout (eg. "4" or "0x4")
- the number of channels with default layout (eg. "4c")
- the number of unordered channels (eg. "4C" or "4 channels")
- the ambisonic order followed by optional non-diegetic channels (eg.
  "ambisonic 2+stereo")
On error, the channel layout will remain uninitialized, but not necessarily
untouched.

Args:
- channel_layout: the layout structure to be initialized
- str: string describing the channel layout
@return 0 on success parsing the channel layout
        AVERROR(EINVAL) if an invalid channel layout string was provided
        AVERROR(ENOMEM) if there was not enough memory
"""

comptime av_channel_layout_default = ExternalFunction[
    "av_channel_layout_default",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        nb_channels: c_int,
    ),
]
"""
Get the default channel layout for a given number of channels.

Args:
- channel_layout: the layout structure to be initialized
- nb_channels: number of channels
"""


comptime av_channel_layout_standard = ExternalFunction[
    "av_channel_layout_standard",
    fn (
        opaque: UnsafePointer[
            OpaquePointer[MutOrigin.external], MutOrigin.external
        ],
    ) -> UnsafePointer[AVChannelLayout, ImmutOrigin.external],
]
"""
Iterate over all standard channel layouts.

Args:
- opaque: a pointer where libavutil will store the iteration state. Must
          point to NULL to start the iteration.
@return the standard channel layout or NULL when the iteration is finished
"""


comptime av_channel_layout_uninit = ExternalFunction[
    "av_channel_layout_uninit",
    fn (channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],),
]
"""
Free any allocated data in the channel layout and reset the channel
count to 0.

Args:
- channel_layout: the layout structure to be uninitialized
"""


comptime av_channel_layout_copy = ExternalFunction[
    "av_channel_layout_copy",
    fn (
        dst: UnsafePointer[AVChannelLayout, MutOrigin.external],
        src: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
    ) -> c_int,
]
"""
Make a copy of a channel layout. This differs from just assigning src to dst
in that it allocates and copies the map for AV_CHANNEL_ORDER_CUSTOM.

Args:
- dst: destination channel layout
- src: source channel layout
@return 0 on success, a negative AVERROR on error.
"""


comptime av_channel_layout_describe = ExternalFunction[
    "av_channel_layout_describe",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        buf: UnsafePointer[c_char, MutOrigin.external],
        buf_size: c_size_t,
    ) -> c_int,
]
"""
Get a human-readable string describing the channel layout properties.
The string will be in the same format that is accepted by
@ref av_channel_layout_from_string(), allowing to rebuild the same
channel layout, except for opaque pointers.

Args:
- channel_layout: channel layout to be described
- buf: pre-allocated buffer where to put the generated string
- buf_size: size in bytes of the buffer.
@return amount of bytes needed to hold the output string, or a negative AVERROR
        on failure. If the returned value is bigger than buf_size, then the
        string was truncated.
"""


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
"""
Get the channel with the given index in a channel layout.

Args:
- channel_layout: input channel layout
- idx index of the channel
@return channel with the index idx in channel_layout on success or
        AV_CHAN_NONE on failure (if idx is not valid or the channel order is
        unspecified)
"""


comptime av_channel_layout_index_from_channel = ExternalFunction[
    "av_channel_layout_index_from_channel",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        channel: AVChannel.ENUM_DTYPE,
    ) -> c_int,
]
"""
Get the index of a given channel in a channel layout. In case multiple
channels are found, only the first match will be returned.

Args:
- channel_layout: input channel layout
- channel: the channel whose index to obtain
@return index of channel in channel_layout on success or a negative number if
        channel is not present in channel_layout.
"""


comptime av_channel_layout_index_from_string = ExternalFunction[
    "av_channel_layout_index_from_string",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        str: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> c_int,
]
"""
Get the index in a channel layout of a channel described by the given string.
In case multiple channels are found, only the first match will be returned.

This function accepts channel names in the same format as
@ref av_channel_from_string().

Args:
- channel_layout: input channel layout
- str: string describing the channel whose index to obtain
@return a channel index described by the given string, or a negative AVERROR
        value.
"""


comptime av_channel_layout_channel_from_string = ExternalFunction[
    "av_channel_layout_channel_from_string",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        str: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> AVChannel.ENUM_DTYPE,
]
"""
Get a channel described by the given string.

This function accepts channel names in the same format as
@ref av_channel_from_string().

Args:
- channel_layout: input channel layout
- str: string describing the channel to obtain
@return a channel described by the given string in channel_layout on success
        or AV_CHAN_NONE on failure (if the string is not valid or the channel
        order is unspecified)
"""


comptime av_channel_layout_subset = ExternalFunction[
    "av_channel_layout_subset",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        mask: c_ulong_long,
    ) -> c_ulong_long,
]
"""
Find out what channels from a given set are present in a channel layout,
without regard for their positions.

Args:
- channel_layout: input channel layout
- mask: a combination of AV_CH_* representing a set of channels
@return a bitfield representing all the channels from mask that are present
        in channel_layout
"""


comptime av_channel_layout_check = ExternalFunction[
    "av_channel_layout_check",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
    ) -> c_int,
]
"""
Check whether a channel layout is valid, i.e. can possibly describe audio
data.

Args:
- channel_layout: input channel layout
@return 1 if channel_layout is valid, 0 otherwise.
"""


comptime av_channel_layout_compare = ExternalFunction[
    "av_channel_layout_compare",
    fn (
        chl: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
        chl1: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
    ) -> c_int,
]
"""
Check whether two channel layouts are semantically the same, i.e. the same
channels are present on the same positions in both.

If one of the channel layouts is AV_CHANNEL_ORDER_UNSPEC, while the other is
not, they are considered to be unequal. If both are AV_CHANNEL_ORDER_UNSPEC,
they are considered equal iff the channel counts are the same in both.

Args:
- chl: input channel layout
- chl1: input channel layout
@return 0 if chl and chl1 are equal, 1 if they are not equal. A negative
        AVERROR code if one or both are invalid.
"""


comptime av_channel_layout_ambisonic_order = ExternalFunction[
    "av_channel_layout_ambisonic_order",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, ImmutOrigin.external],
    ) -> c_int,
]
"""
Return the order if the layout is n-th order standard-order ambisonic.
The presence of optional extra non-diegetic channels at the end is not taken
into account.

Args:
- channel_layout: input channel layout
@return the order of the layout, a negative error code otherwise.
"""


comptime AV_CHANNEL_LAYOUT_RETYPE_FLAG_LOSSLESS = (1 << 0)
"The conversion must be lossless."

comptime AV_CHANNEL_LAYOUT_RETYPE_FLAG_CANONICAL = (1 << 1)
"""The specified retype target order is ignored and the simplest possible
(canonical) order is used for which the input layout can be losslessy
represented."""

comptime av_channel_layout_retype = ExternalFunction[
    "av_channel_layout_retype",
    fn (
        channel_layout: UnsafePointer[AVChannelLayout, MutOrigin.external],
        order: AVChannelOrder.ENUM_DTYPE,
        flags: c_int,
    ) -> c_int,
]
"""
Change the AVChannelOrder of a channel layout.

Change of AVChannelOrder can be either lossless or lossy. In case of a
lossless conversion all the channel designations and the associated channel
names (if any) are kept. On a lossy conversion the channel names and channel
designations might be lost depending on the capabilities of the desired
AVChannelOrder. Note that some conversions are simply not possible in which
case this function returns AVERROR(ENOSYS).

The following conversions are supported:
- Any       -> Custom     : Always possible, always lossless.
- Any       -> Unspecified: Always possible, lossless if channel designations
  are all unknown and channel names are not used, lossy otherwise.
- Custom    -> Ambisonic  : Possible if it contains ambisonic channels with
  optional non-diegetic channels in the end. Lossy if the channels have
  custom names, lossless otherwise.
- Custom    -> Native     : Possible if it contains native channels in native
  order. Lossy if the channels have custom names, lossless otherwise.

On error this function keeps the original channel layout untouched.

Args:
- channel_layout: channel layout which will be changed
- order: the desired channel layout order
- flags: a combination of AV_CHANNEL_LAYOUT_RETYPE_FLAG_* constants
@return 0 if the conversion was successful and lossless or if the channel
        layout was already in the desired order
        >0 if the conversion was successful but lossy
        AVERROR(ENOSYS) if the conversion was not possible (or would be
        lossy and AV_CHANNEL_LAYOUT_RETYPE_FLAG_LOSSLESS was specified)
        AVERROR(EINVAL), AVERROR(ENOMEM) on error
"""
