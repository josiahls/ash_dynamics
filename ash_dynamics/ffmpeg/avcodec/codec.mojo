from sys.ffi import c_char, c_int, c_uchar
from ash_dynamics.primitives._clib import (
    StructWritable,
    StructWriter,
    ExternalFunction,
)

from reflection import get_type_name
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.hwcontext import AVHWDeviceType
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout


comptime AV_CODEC_CAP_DRAW_HORIZ_BAND = c_int(1 << 0)
"Decoder can use draw_horiz_band callback."

comptime AV_CODEC_CAP_DR1 = c_int(1 << 1)
"""Codec uses get_buffer() or get_encode_buffer() for allocating buffers and 
supports custom allocators.

If not set, it might not use get_buffer() or get_encode_buffer() at all, or use 
operations that assume the buffer was allocated by avcodec_default_get_buffer2 
or avcodec_default_get_encode_buffer."""

comptime AV_CODEC_CAP_DELAY = c_int(1 << 5)
"""Encoder or decoder requires flushing with NULL input at the end in order to 
give the complete and correct output.

NOTE: If this flag is not set, the codec is guaranteed to never be fed with
with NULL data. The user can still send NULL data to the public encode
or decode function, but libavcodec will not pass it along to the codec
unless this flag is set.

Decoders:
The decoder has a non-zero delay and needs to be fed with avpkt->data=NULL,
avpkt->size=0 at the end to get the delayed data until the decoder no longer
returns frames.

Encoders:
The encoder needs to be fed with NULL data at end of encoding until the encoder no longer returns data.

NOTE: For encoders implementing the AVCodec.encode2() function, setting this
flag also means that the encoder must set the pts and duration for
each output packet. If this flag is not set, the pts and duration will
be determined by libavcodec from the input frame.
"""

comptime AV_CODEC_CAP_SMALL_LAST_FRAME = c_int(1 << 6)
"""Encoder or decoder can output a small number of output frames before any 
given frame.

This can be used to prevent truncation of the last audio samples."""

comptime AV_CODEC_CAP_EXPERIMENTAL = c_int(1 << 9)
"""Codec is experimental and is thus avoided in favor of non experimental
encoders"""

comptime AV_CODEC_CAP_CHANNEL_CONF = c_int(1 << 10)
"""Codec should fill in channel configuration and samplerate instead of container"""

comptime AV_CODEC_CAP_FRAME_THREADS = c_int(1 << 12)
"""Codec supports frame-level multithreading."""

comptime AV_CODEC_CAP_SLICE_THREADS = c_int(1 << 13)
"""Codec supports slice-based (or partition-based) multithreading."""

comptime AV_CODEC_CAP_PARAM_CHANGE = c_int(1 << 14)
"""Codec supports changed parameters at any point."""

comptime AV_CODEC_CAP_OTHER_THREADS = c_int(1 << 15)
"""Codec supports multithreading through a method other than slice- or
frame-level multithreading. Typically this marks wrappers around
multithreading-capable external libraries."""

comptime AV_CODEC_CAP_VARIABLE_FRAME_SIZE = c_int(1 << 16)
"""Audio encoder supports receiving a different number of samples in each call."""

comptime AV_CODEC_CAP_AVOID_PROBING = c_int(1 << 17)
"""Decoder is not a preferred choice for probing.
This indicates that the decoder is not a good choice for probing.
It could for example be an expensive to spin up hardware decoder,
or it could simply not provide a lot of useful information about
the stream.

A decoder marked with this flag should only be used as last resort
choice for probing.
"""

comptime AV_CODEC_CAP_HARDWARE = c_int(1 << 18)
"""Codec is backed by a hardware implementation. Typically used to
identify a non-hwaccel hardware decoder. For information about hwaccels, use
avcodec_get_hw_config() instead."""

comptime AV_CODEC_CAP_HYBRID = c_int(1 << 19)
"""Codec is potentially backed by a hardware implementation, but not
necessarily. This is used instead of AV_CODEC_CAP_HARDWARE, if the
implementation provides some sort of internal fallback."""

comptime AV_CODEC_CAP_ENCODER_REORDERED_OPAQUE = c_int(1 << 20)
"""This encoder can reorder user opaque values from input AVFrames and return
them with corresponding output packets.
@see AV_CODEC_FLAG_COPY_OPAQUE"""

comptime AV_CODEC_CAP_ENCODER_FLUSH = c_int(1 << 21)
"""This encoder can be flushed using avcodec_flush_buffers(). If this flag is
not set, the encoder must be closed and reopened to ensure that no frames
remain pending."""

comptime AV_CODEC_CAP_ENCODER_RECON_FRAME = c_int(1 << 22)
"""The encoder is able to output reconstructed frame data, i.e. raw frames that
would be produced by decoding the encoded bitstream.
Reconstructed frame output is enabled by the AV_CODEC_FLAG_RECON_FRAME flag."""


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

    var pix_fmts: UnsafePointer[AVPixelFormat.ENUM_DTYPE, MutOrigin.external]
    "Supported pixel formats. Note: This field is deprecated. Use avcodec_get_supported_config() instead."

    var supported_samplerates: UnsafePointer[c_int, ImmutOrigin.external]
    "Supported sample rates. Note: This field is deprecated. Use avcodec_get_supported_config() instead."

    var sample_fmts: UnsafePointer[
        AVSampleFormat.ENUM_DTYPE, MutOrigin.external
    ]
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


comptime av_codec_iterate = ExternalFunction[
    "av_codec_iterate",
    fn (
        opaque: UnsafePointer[
            OpaquePointer[MutOrigin.external], MutOrigin.external
        ],
    ) -> UnsafePointer[AVCodec, ImmutOrigin.external],
]
"""Iterate over all registered codecs.

Args:
- opaque: A pointer where libavcodec will store the iteration state. Must point 
to NULL to start the iteration.

Returns:
- The next registered codec or NULL when the iteration is finished.
"""


comptime avcodec_find_decoder = ExternalFunction[
    "avcodec_find_decoder",
    fn (
        id: AVCodecID.ENUM_DTYPE,
    ) -> UnsafePointer[AVCodec, ImmutOrigin.external],
]
"""Find a registered decoder with a matching codec ID.

Args:
- id: AVCodecID of the requested decoder.

Returns:
- A decoder if one was found, NULL otherwise.
"""

comptime avcodec_find_decoder_by_name = ExternalFunction[
    "avcodec_find_decoder_by_name",
    fn (
        name: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> UnsafePointer[AVCodec, ImmutOrigin.external],
]
"""Find a registered decoder with the specified name.

Args:
- name: Name of the requested decoder.

Returns:
- A decoder if one was found, NULL otherwise.
"""

comptime avcodec_find_encoder = ExternalFunction[
    "avcodec_find_encoder",
    fn (
        id: AVCodecID.ENUM_DTYPE,
    ) -> UnsafePointer[AVCodec, ImmutOrigin.external],
]
"""Find a registered encoder with a matching codec ID.

Args:
- id: AVCodecID of the requested encoder.

Returns:
- An encoder if one was found, NULL otherwise.
"""

comptime avcodec_find_encoder_by_name = ExternalFunction[
    "avcodec_find_encoder_by_name",
    fn (
        name: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> UnsafePointer[AVCodec, ImmutOrigin.external],
]
"""Find a registered encoder with the specified name.

Args:
- name: Name of the requested encoder.

Returns:
- An encoder if one was found, NULL otherwise.
"""

comptime av_codec_is_encoder = ExternalFunction[
    "av_codec_is_encoder",
    fn (codec: UnsafePointer[AVCodec, ImmutOrigin.external],) -> c_int,
]
"""Return a non-zero number if codec is an encoder, zero otherwise.

Args:
- codec: The codec to check.

Returns:
- A non-zero number if codec is an encoder, zero otherwise.
"""

comptime av_codec_is_decoder = ExternalFunction[
    "av_codec_is_decoder",
    fn (codec: UnsafePointer[AVCodec, ImmutOrigin.external],) -> c_int,
]
"""Return a non-zero number if codec is a decoder, zero otherwise.

Args:
- codec: The codec to check.

Returns:
- A non-zero number if codec is a decoder, zero otherwise.
"""

comptime av_get_profile_name = ExternalFunction[
    "av_get_profile_name",
    fn (
        codec: UnsafePointer[AVCodec, ImmutOrigin.external],
        profile: c_int,
    ) -> UnsafePointer[c_char, ImmutOrigin.external],
]
"""Return a name for the specified profile, if available.

Args:
- codec: The codec that is searched for the given profile.
- profile: The profile value for which a name is requested.

Returns:
- A name for the profile if found, NULL otherwise.
"""


comptime AV_CODEC_HW_CONFIG_METHOD_HW_DEVICE_CTX = c_int(0x01)
"""The codec supports this format via the hw_device_ctx interface.

When selecting this format, AVCodecContext.hw_device_ctx should
have been set to a device of the specified type before calling
avcodec_open2().
"""

comptime AV_CODEC_HW_CONFIG_METHOD_HW_FRAMES_CTX = c_int(0x02)
"""The codec supports this format via the hw_frames_ctx interface.

When selecting this format for a decoder,
AVCodecContext.hw_frames_ctx should be set to a suitable frames
context inside the get_format() callback. The frames context
must have been created on a device of the specified type.

When selecting this format for an encoder,
AVCodecContext.hw_frames_ctx should be set to the context which
will be used for the input frames before calling avcodec_open2().
"""

comptime AV_CODEC_HW_CONFIG_METHOD_INTERNAL = c_int(0x04)
"""The codec supports this format by some internal method.

This format can be selected without any additional configuration -
no device or frames context is required.
"""

comptime AV_CODEC_HW_CONFIG_METHOD_AD_HOC = c_int(0x08)
"""The codec supports this format by some ad-hoc method.

Additional settings and/or function calls are required. See the
codec-specific documentation for details. (Methods requiring this sort of 
configuration are deprecated and others should be used in preference.)
"""


@register_passable("trivial")
@fieldwise_init
struct AVCodecHWConfig(StructWritable):
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVCodecHWConfig.html
    """

    var pix_fmt: AVPixelFormat.ENUM_DTYPE
    """For decoders, a hardware pixel format which that decoder may be able to 
    decode to if suitable hardware is available.
    
    For encoders, a pixel format which the encoder may be able to accept. 
    If set to AV_PIX_FMT_NONE, this applies to all pixel formats supported by the codec.
    """
    var methods: c_int
    """Bit set of AV_CODEC_HW_CONFIG_METHOD_* flags, describing the possible 
    setup methods which can be used with this configuration.
    """

    var device_type: AVHWDeviceType.ENUM_DTYPE
    """The device type associated with the configuration.

    Must be set for AV_CODEC_HW_CONFIG_METHOD_HW_DEVICE_CTX and 
    AV_CODEC_HW_CONFIG_METHOD_HW_FRAMES_CTX, otherwise unused.
    """

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["pix_fmt"](self.pix_fmt)
        struct_writer.write_field["methods"](self.methods)
        struct_writer.write_field["device_type"](self.device_type)


comptime avcodec_get_hw_config = ExternalFunction[
    "avcodec_get_hw_config",
    fn (
        codec: UnsafePointer[AVCodec, ImmutOrigin.external],
        index: c_int,
    ) -> UnsafePointer[AVCodecHWConfig, ImmutOrigin.external],
]
"""Retrieve supported hardware configurations for a codec.

Values of index from zero to some maximum return the indexed configuration 
descriptor; all other values return NULL. If the codec does not support any 
hardware configurations then it will always return NULL.
"""
