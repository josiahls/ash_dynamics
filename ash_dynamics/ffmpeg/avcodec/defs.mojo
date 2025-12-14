"""Bindings for https://www.ffmpeg.org/doxygen/8.0/defs_8h_source.html"""
from sys.ffi import c_int
from ash_dynamics.primitives._clib import StructWritable, StructWriter

comptime AV_INPUT_BUFFER_PADDING_SIZE = c_int(64)
"""
Required number of additionally allocated bytes at the end of the input bitstream for decoding.
This is mainly needed because some optimized bitstream readers read
32 or 64 bit at once and could read over the end.<br>
Note: If the first 23 bits of the additional bytes are not 0, then damaged
MPEG bitstreams could cause overread and segfault.
"""


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVFieldOrder(StructWritable):
    """The order of the fields in interlaced video."""

    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AV_FIELD_UNKNOWN = Self(0)
    comptime AV_FIELD_PROGRESSIVE = Self(1)
    comptime AV_FIELD_TT = Self(2)
    """Top coded_first, top displayed first"""
    comptime AV_FIELD_BB = Self(3)
    """Bottom coded_first, bottom displayed first"""
    comptime AV_FIELD_TB = Self(4)
    """Top coded_first, bottom displayed first"""
    comptime AV_FIELD_BT = Self(5)
    """Bottom coded_first, top displayed first"""

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["value"](self._value)


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVAudioServiceType(StructWritable):
    """Audio service type"""

    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AV_AUDIO_SERVICE_TYPE_MAIN = Self(0)
    comptime AV_AUDIO_SERVICE_TYPE_EFFECTS = Self(1)
    comptime AV_AUDIO_SERVICE_TYPE_VISUALLY_IMPAIRED = Self(2)
    comptime AV_AUDIO_SERVICE_TYPE_HEARING_IMPAIRED = Self(3)
    comptime AV_AUDIO_SERVICE_TYPE_DIALOGUE = Self(4)
    comptime AV_AUDIO_SERVICE_TYPE_COMMENTARY = Self(5)
    comptime AV_AUDIO_SERVICE_TYPE_EMERGENCY = Self(6)
    comptime AV_AUDIO_SERVICE_TYPE_VOICE_OVER = Self(7)
    comptime AV_AUDIO_SERVICE_TYPE_KARAOKE = Self(8)
    comptime AV_AUDIO_SERVICE_TYPE_NB = Self(9)
    """Not part of ABI"""

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["value"](self._value)


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVDiscard(StructWritable):
    """Discard frames.

    We leave some space between them for extensions (drop some
    keyframes for intra-only or drop just some bidir frames).
    """

    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AVDISCARD_NONE = -16
    "discard nothing"
    comptime AVDISCARD_DEFAULT = 0
    "discard useless packets like 0 size packets in avi"
    comptime AVDISCARD_NONREF = 8
    "discard all non reference"
    comptime AVDISCARD_BIDIR = 16
    "discard all bidirectional frames"
    comptime AVDISCARD_NONINTRA = 24
    "discard all non intra frames"
    comptime AVDISCARD_NONKEY = 32
    "discard all frames except keyframes"
    comptime AVDISCARD_ALL = 48
    "discard all"

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["value"](self._value)
