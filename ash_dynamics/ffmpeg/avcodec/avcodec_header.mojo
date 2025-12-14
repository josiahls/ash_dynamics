from sys.ffi import c_int, c_float, c_char
from ash_dynamics.primitives._clib import StructWritable, StructWriter
from compile.reflection import get_type_name
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat


@fieldwise_init
@register_passable("trivial")
struct RcOverride(StructWritable):
    var start_frame: c_int
    var end_frame: c_int
    var qscale: c_int
    var quality_factor: c_float

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["start_frame"](self.start_frame)
        struct_writer.write_field["end_frame"](self.end_frame)
        struct_writer.write_field["qscale"](self.qscale)
        struct_writer.write_field["quality_factor"](self.quality_factor)


@fieldwise_init
@register_passable("trivial")
struct AVHWAccel(StructWritable):
    """Note: Nothing in this structure should be accessed by the user. At some
    point in future it will not be externally visible at all.
    """

    var name: UnsafePointer[c_char, ImmutOrigin.external]
    """Name of the hardware accelerated codec.
    The name is globally unique among encoders and among decoders (but an
    encoder and a decoder can share the same name).
    """

    var type: AVMediaType.ENUM_DTYPE
    """Type of codec implemented by the hardware accelerator.
    See AVMEDIA_TYPE_xxx.
    """

    var id: AVCodecID.ENUM_DTYPE
    """Codec implemented by the hardware accelerator.
    See AV_CODEC_ID_xxx.
    """

    var pix_fmt: AVPixelFormat.ENUM_DTYPE
    """Supported pixel format.
    Only hardware accelerated formats are supported here.
    """

    var capabilities: c_int
    """Hardware accelerated codec capabilities.
    see AV_HWACCEL_CODEC_CAP_*.
    """

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["name"](self.name)
        struct_writer.write_field["type"](self.type)
        struct_writer.write_field["id"](self.id)
        struct_writer.write_field["pix_fmt"](self.pix_fmt)
        struct_writer.write_field["capabilities"](self.capabilities)


@fieldwise_init
@register_passable("trivial")
struct AVPictureStructure(StructWritable):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AV_PICTURE_STRUCTURE_UNKNOWN = Self(0)
    "unknown"
    comptime AV_PICTURE_STRUCTURE_TOP_FIELD = Self(1)
    "coded as top field"
    comptime AV_PICTURE_STRUCTURE_BOTTOM_FIELD = Self(2)
    "coded as bottom field"
    comptime AV_PICTURE_STRUCTURE_FRAME = Self(3)
    "coded as frame"

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["value"](self._value)
