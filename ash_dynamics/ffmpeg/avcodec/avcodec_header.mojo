from sys.ffi import c_int, c_float, c_char, c_long_long, c_uchar
from ash_dynamics.primitives._clib import (
    StructWritable,
    StructWriter,
    ExternalFunction,
)
from compile.reflection import get_type_name
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avcodec.av_codec_parser import (
    AVCodecContext,
    AVCodecParserContext,
)


comptime _avcodec_alloc_context3 = ExternalFunction[
    "avcodec_alloc_context3",
    fn (
        codec: UnsafePointer[AVCodec, ImmutOrigin.external]
    ) -> UnsafePointer[AVCodecContext, MutOrigin.external],
]
"""
Allocate an AVCodecContext and set its fields to default values. The
resulting struct should be freed with avcodec_free_context().

@param codec if non-NULL, allocate private data and initialize defaults
for the given codec. It is illegal to then call avcodec_open2()
with a different codec.
If NULL, then the codec-specific defaults won't be initialized,
which may result in suboptimal default settings (this is
important mainly for encoders, e.g. libx264).

@return An AVCodecContext filled with default values or NULL on failure.
"""


comptime _avcodec_open2 = ExternalFunction[
    "avcodec_open2",
    fn (
        context: UnsafePointer[AVCodecContext, MutOrigin.external],
        codec: UnsafePointer[AVCodec, ImmutOrigin.external],
        options: UnsafePointer[AVDictionary, ImmutOrigin.external],
    ) -> c_int,
]
"""Initialize the AVCodecContext to use the given AVCodec. Prior to using this
function the context has to be allocated with avcodec_alloc_context3().

The functions avcodec_find_decoder_by_name(), avcodec_find_encoder_by_name(),
avcodec_find_decoder() and avcodec_find_encoder() provide an easy way for
retrieving a codec.

Depending on the codec, you might need to set options in the codec context
also for decoding (e.g. width, height, or the pixel or audio sample format in
the case the information is not available in the bitstream, as when decoding
raw audio or video).

Options in the codec context can be set either by setting them in the options
AVDictionary, or by setting the values in the context itself, directly or by
using the av_opt_set() API before calling this function.

Example:
@code
av_dict_set(&opts, "b", "2.5M", 0);
codec = avcodec_find_decoder(AV_CODEC_ID_H264);
if (!codec)
    exit(1);

context = avcodec_alloc_context3(codec);

if (avcodec_open2(context, codec, opts) < 0)
    exit(1);
@endcode

In the case AVCodecParameters are available (e.g. when demuxing a stream
using libavformat, and accessing the AVStream contained in the demuxer), the
codec parameters can be copied to the codec context using
avcodec_parameters_to_context(), as in the following example:

@code
AVStream *stream = ...;
context = avcodec_alloc_context3(codec);
if (avcodec_parameters_to_context(context, stream->codecpar) < 0)
    exit(1);
if (avcodec_open2(context, codec, NULL) < 0)
    exit(1);
@endcode

@note Always call this function before using decoding routines (such as
@ref avcodec_receive_frame()).

@param avctx The context to initialize.
@param codec The codec to open this context for. If a non-NULL codec has been
previously passed to avcodec_alloc_context3() or for this context, then this
parameter MUST be either NULL or equal to the previously passed codec.
@param options A dictionary filled with AVCodecContext and codec-private options,
which are set on top of the options already set in avctx, can be NULL. On return
this object will be filled with options that were not found in the avctx codec context.

@return zero on success, a negative value on error
@see avcodec_alloc_context3(), avcodec_find_decoder(), avcodec_find_encoder(),
av_dict_set(), av_opt_set(), av_opt_find(), avcodec_parameters_to_context()
"""


comptime av_parser_parse2 = ExternalFunction[
    "av_parser_parse2",
    fn (
        s: UnsafePointer[AVCodecParserContext, MutOrigin.external],
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        poutbuf: UnsafePointer[
            UnsafePointer[c_uchar, MutOrigin.external], MutOrigin.external
        ],
        poutbuf_size: UnsafePointer[c_int, MutOrigin.external],
        buf: UnsafePointer[c_uchar, ImmutOrigin.external],
        buf_size: c_int,
        pts: c_long_long,
        dts: c_long_long,
        pos: c_long_long,
    ) -> c_int,
]
"""
Parse a packet.

@param s             parser context.
@param avctx         codec context.
@param poutbuf       set to pointer to parsed buffer or NULL if not yet finished.
@param poutbuf_size  set to size of parsed buffer or zero if not yet finished.
@param buf           input buffer.
@param buf_size      buffer size in bytes without the padding. I.e. the full buffer
                    size is assumed to be buf_size + AV_INPUT_BUFFER_PADDING_SIZE.
                    To signal EOF, this should be 0 (so that the last frame
                    can be output).
@param pts           input presentation timestamp.
@param dts           input decoding timestamp.
@param pos           input byte position in stream.
@return the number of bytes of the input bitstream used.

Example:
@code
while(in_len){
    len = av_parser_parse2(myparser, AVCodecContext, &data, &size,
                                        in_data, in_len,
                                        pts, dts, pos);
    in_data += len;
    in_len  -= len;

    if(size)
        decode_frame(data, size);
}
@endcode
"""

comptime avcodec_send_packet = ExternalFunction[
    "avcodec_send_packet",
    fn (
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        avpkt: UnsafePointer[AVPacket, ImmutOrigin.external],
    ) -> c_int,
]
"""Supply raw packet data as input to a decoder.

Internally, this call will copy relevant AVCodecContext fields, which can
influence decoding per-packet, and apply them when the packet is actually
decoded. (For example AVCodecContext.skip_frame, which might direct the
decoder to drop the frame contained by the packet sent with this function.)

@warning The input buffer, avpkt->data must be AV_INPUT_BUFFER_PADDING_SIZE
         larger than the actual read bytes because some optimized bitstream
         readers read 32 or 64 bits at once and could read over the end.

@note The AVCodecContext MUST have been opened with @ref avcodec_open2()
      before packets may be fed to the decoder.

@param avctx codec context
@param[in] avpkt The input AVPacket. Usually, this will be a single video
                frame, or several complete audio frames.
                Ownership of the packet remains with the caller, and the
                decoder will not write to the packet. The decoder may create
                a reference to the packet data (or copy it if the packet is
                not reference-counted).
                Unlike with older APIs, the packet is always fully consumed,
                and if it contains multiple frames (e.g. some audio codecs),
                will require you to call avcodec_receive_frame() multiple
                times afterwards before you can send a new packet.
                It can be NULL (or an AVPacket with data set to NULL and
                size set to 0); in this case, it is considered a flush
                packet, which signals the end of the stream. Sending the
                first flush packet will return success. Subsequent ones are
                unnecessary and will return AVERROR_EOF. If the decoder
                still has frames buffered, it will return them after sending
                a flush packet.

@retval 0                 success
@retval AVERROR(EAGAIN)   input is not accepted in the current state - user
                          must read output with avcodec_receive_frame() (once
                          all output is read, the packet should be resent,
                          and the call will not fail with EAGAIN).
@retval AVERROR_EOF       the decoder has been flushed, and no new packets can be
                          sent to it (also returned if more than 1 flush
                          packet is sent)
@retval AVERROR(EINVAL)   codec not opened, it is an encoder, or requires flush
@retval AVERROR(ENOMEM)   failed to add packet to internal queue, or similar
@retval "another negative error code" legitimate decoding errors
"""


comptime avcodec_receive_frame = ExternalFunction[
    "avcodec_receive_frame",
    fn (
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        frame: UnsafePointer[AVFrame, MutOrigin.external],
    ) -> c_int,
]
"""Return decoded output data from a decoder or encoder (when the
@ref AV_CODEC_FLAG_RECON_FRAME flag is used).
 *
@param avctx codec context
@param frame This will be set to a reference-counted video or audio
            frame (depending on the decoder type) allocated by the
            codec. Note that the function will always call
            av_frame_unref(frame) before doing anything else.

@retval 0                success, a frame was returned
@retval AVERROR(EAGAIN)  output is not available in this state - user must
                        try to send new input
@retval AVERROR_EOF      the codec has been fully flushed, and there will be
                        no more output frames
@retval AVERROR(EINVAL)  codec not opened, or it is an encoder without the
                        @ref AV_CODEC_FLAG_RECON_FRAME flag enabled
@retval "other negative error code" legitimate decoding errors
"""


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
