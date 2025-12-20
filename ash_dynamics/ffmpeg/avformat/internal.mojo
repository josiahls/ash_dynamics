from sys.ffi import c_uint, c_char, c_long_long, c_int
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avformat.avformat import AVFormatContext
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary

comptime MAX_URL_SIZE = 4096

comptime PROBE_BUF_MIN = 2048
"Size of the probe buffer, for guessing file type from file contents"
comptime PROBE_BUF_MAX = 1 << 20


@fieldwise_init
@register_passable("trivial")
struct AVCodecTag:
    """This structure contains a list of codec tags."""

    var id: AVCodecID.ENUM_DTYPE
    var tag: c_uint


@fieldwise_init
@register_passable("trivial")
struct CodecMime:
    """This structure contains a list of codec mime types."""

    var str: UnsafePointer[c_char, MutOrigin.external]
    var id: AVCodecID.ENUM_DTYPE


# Fractional numbers for exact pts handling.
@fieldwise_init
@register_passable("trivial")
struct FFFrac:
    """This structure contains a fractional number."""

    var val: c_long_long
    var num: c_long_long
    var den: c_long_long


# @fieldwise_init
# @register_passable("trivial")
# struct _FFFormatContext_avoid_negative_ts_status:
#     comptime ENUM_DTYPE = c_int
#     var value: Self.ENUM_DTYPE

#     comptime AVOID_NEGATIVE_TS_DISABLED = Self(-1)
#     """Disabled"""
#     comptime AVOID_NEGATIVE_TS_UNKNOWN = Self(0)
#     """Not yet determined"""
#     comptime AVOID_NEGATIVE_TS_KNOWN = Self(1)
#     """Determined"""


# @fieldwise_init
# @register_passable("trivial")
# struct FFFormatContext:
#     """This structure contains a format context."""
#     var pub: AVFormatContext
#     """The public context."""
#     var avoid_negative_ts_status: _FFFormatContext_avoid_negative_ts_status.ENUM_DTYPE
#     """Whether the timestamp shift offset has already been determined."""

#     @staticmethod
#     fn AVOID_NEGATIVE_TS_ENABLED(status: Int) -> Bool:
#         return status >= 0

#     var packet_buffer: PacketList
#     """This buffer is only needed when packets were already buffered but
#     not decoded, for example to get the codec parameters in MPEG
#     streams."""
#     # av_seek_frame() support
#     var data_offset: c_long_long
#     """The offset of the first packet."""
#     var parse_pkt: UnsafePointer[AVPacket, MutOrigin.external]
#     """The generic code uses this as a temporary packet
#     to parse packets or for muxing, especially flushing.
#     For demuxers, it may also be used for other means
#     for short periods that are guaranteed not to overlap
#     with calls to av_read_frame() (or ff_read_packet())
#     or with each other.

#     It may be used by demuxers as a replacement for
#     stack packets (unless they call one of the aforementioned
#     functions with their own AVFormatContext).
#     Every user has to ensure that this packet is blank
#     after using it.
#     """
#     var pkt: UnsafePointer[AVPacket, MutOrigin.external]
#     """Used to hold temporary packets for the generic demuxing code.
#     When muxing, it may be used by muxers to hold packets (even
#     permanent ones)."""
#     var avoid_negative_ts_use_pts: c_int
#     """Whether to use pts for negative timestamp shift offset determination."""
#     var id3v2_meta: UnsafePointer[AVDictionary, MutOrigin.external]
#     """ID3v2 tag useful for MP3 demuxing"""
#     var missing_streams: c_int
#     """Whether any streams are missing."""


# @always_inline
# fn ffformatcontext(
#     s: UnsafePointer[AVFormatContext, MutOrigin.external]
# ) -> UnsafePointer[FFFormatContext, MutOrigin.external]:
#     return rebind(s, FFFormatContext)
