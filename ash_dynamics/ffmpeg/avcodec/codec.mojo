from sys.ffi import c_char, c_int, c_uchar
from ash_dynamics.primitives._clib import StructWritable, StructWriter

from compile.reflection import get_type_name
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout


@register_passable("trivial")
@fieldwise_init
struct AVCodec(StructWritable):
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVCodec.html
    """

    var name: UnsafePointer[c_char, ImmutOrigin.external]
    var long_name: UnsafePointer[c_char, ImmutOrigin.external]

    var type: AVMediaType.ENUM_DTYPE
    var id: AVCodecID.ENUM_DTYPE

    var capabilities: c_int
    "Codec capabilities. See AV_CODEC_CAP_*."
    var max_lowres: c_uchar
    "Maximum value for lowres supported by the decoder."

    var supported_framerates: UnsafePointer[AVRational, ImmutOrigin.external]
    "Supported framerates. Note: This field is deprecated. Use avcodec_get_supported_config() instead."

    var pix_fmts: UnsafePointer[AVPixelFormat, MutOrigin.external]
    "Supported pixel formats. Note: This field is deprecated. Use avcodec_get_supported_config() instead."

    var supported_samplerates: UnsafePointer[c_int, ImmutOrigin.external]
    "Supported sample rates. Note: This field is deprecated. Use avcodec_get_supported_config() instead."

    var sample_fmts: UnsafePointer[AVSampleFormat, MutOrigin.external]
    "Supported sample formats. Note: This field is deprecated. Use avcodec_get_supported_config() instead."

    var priv_class: UnsafePointer[AVClass, ImmutOrigin.external]
    "Private class for codec-specific defaults."

    var profiles: UnsafePointer[AVProfile, ImmutOrigin.external]
    """Array of recognized profiles, or NULL if unknown, array is terminated by 
    AV_PROFILE_UNKNOWN."""

    var wrapper_name: UnsafePointer[c_char, ImmutOrigin.external]
    "Group name of the codec implementation."

    var ch_layouts: UnsafePointer[AVChannelLayout, ImmutOrigin.external]
    """Array of supported channel layouts, terminated with a zeroed layout.
    
    Note: This field is deprecated. Use avcodec_get_supported_config() instead.
    """

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["name"](
            StringSlice(unsafe_from_utf8_ptr=self.name)
        )
        struct_writer.write_field["long_name"](
            StringSlice(unsafe_from_utf8_ptr=self.long_name)
        )
        struct_writer.write_field["type"](self.type)
        struct_writer.write_field["id"](self.id)
        struct_writer.write_field["capabilities"](self.capabilities)
        struct_writer.write_field["max_lowres"](self.max_lowres)
        struct_writer.write_field["supported_framerates", deprecated=True](
            self.supported_framerates
        )
        struct_writer.write_field["pix_fmts", deprecated=True](self.pix_fmts)
        struct_writer.write_field["supported_samplerates", deprecated=True](
            self.supported_samplerates
        )
        struct_writer.write_field["sample_fmts", deprecated=True](
            self.sample_fmts
        )
        struct_writer.write_field["priv_class"](self.priv_class)
        struct_writer.write_field["profiles"](self.profiles)
        struct_writer.write_field["wrapper_name"](self.wrapper_name)
        struct_writer.write_field["ch_layouts", deprecated=True](
            self.ch_layouts
        )


@register_passable("trivial")
struct AVProfile(StructWritable):
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVProfile.html
    """

    var profile: c_int
    "Profile value."
    var name: UnsafePointer[c_char, ImmutOrigin.external]
    "Short name for the profile."

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["profile"](self.profile)
        struct_writer.write_field["name"](
            StringSlice(unsafe_from_utf8_ptr=self.name)
        )
