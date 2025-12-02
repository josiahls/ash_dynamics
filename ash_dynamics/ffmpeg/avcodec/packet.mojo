"""Bindings for https://www.ffmpeg.org/doxygen/8.0/packet_8h_source.html"""
from sys.ffi import c_uchar, c_uint, c_int, c_long_long
from os.atomic import Atomic
from ash_dynamics.ffmpeg.avcodec.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avcodec.rational import AVRational
from ash_dynamics.ffmpeg._clib import ExternalFunction


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVPacketSideDataType:
    """Reference [0] for enum details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/group__lavc__packet__side__data.html
    """

    var _value: c_int

    comptime AV_PKT_DATA_PALETTE = Self(0)
    comptime AV_PKT_DATA_NEW_EXTRADATA = Self(1)
    comptime AV_PKT_DATA_PARAM_CHANGE = Self(2)
    comptime AV_PKT_DATA_H263_MB_INFO = Self(3)
    comptime AV_PKT_DATA_REPLAYGAIN = Self(4)
    comptime AV_PKT_DATA_DISPLAYMATRIX = Self(5)
    comptime AV_PKT_DATA_STEREO3D = Self(6)
    comptime AV_PKT_DATA_AUDIO_SERVICE_TYPE = Self(7)
    comptime AV_PKT_DATA_QUALITY_STATS = Self(8)
    comptime AV_PKT_DATA_FALLBACK_TRACK = Self(9)
    comptime AV_PKT_DATA_CPB_PROPERTIES = Self(10)
    comptime AV_PKT_DATA_SKIP_SAMPLES = Self(11)
    comptime AV_PKT_DATA_JP_DUALMONO = Self(12)
    comptime AV_PKT_DATA_STRINGS_METADATA = Self(13)
    comptime AV_PKT_DATA_SUBTITLE_POSITION = Self(14)
    comptime AV_PKT_DATA_MATROSKA_BLOCKADDITIONAL = Self(15)
    comptime AV_PKT_DATA_WEBVTT_IDENTIFIER = Self(16)

    comptime AV_PKT_DATA_WEBVTT_SETTINGS = Self(17)

    comptime AV_PKT_DATA_METADATA_UPDATE = Self(18)

    comptime AV_PKT_DATA_MPEGTS_STREAM_ID = Self(19)

    comptime AV_PKT_DATA_MASTERING_DISPLAY_METADATA = Self(20)

    comptime AV_PKT_DATA_SPHERICAL = Self(21)

    comptime AV_PKT_DATA_CONTENT_LIGHT_LEVEL = Self(22)

    comptime AV_PKT_DATA_A53_CC = Self(23)

    comptime AV_PKT_DATA_ENCRYPTION_INIT_INFO = Self(24)

    comptime AV_PKT_DATA_ENCRYPTION_INFO = Self(25)

    comptime AV_PKT_DATA_AFD = Self(26)

    comptime AV_PKT_DATA_PRFT = Self(27)

    comptime AV_PKT_DATA_ICC_PROFILE = Self(28)

    comptime AV_PKT_DATA_DOVI_CONF = Self(29)

    comptime AV_PKT_DATA_S12M_TIMECODE = Self(30)

    comptime AV_PKT_DATA_DYNAMIC_HDR10_PLUS = Self(31)

    comptime AV_PKT_DATA_IAMF_MIX_GAIN_PARAM = Self(32)

    comptime AV_PKT_DATA_IAMF_DEMIXING_INFO_PARAM = Self(33)

    comptime AV_PKT_DATA_IAMF_RECON_GAIN_INFO_PARAM = Self(34)

    comptime AV_PKT_DATA_AMBIENT_VIEWING_ENVIRONMENT = Self(35)

    comptime AV_PKT_DATA_FRAME_CROPPING = Self(36)

    comptime AV_PKT_DATA_LCEVC = Self(37)

    comptime AV_PKT_DATA_3D_REFERENCE_DISPLAYS = Self(38)

    comptime AV_PKT_DATA_RTCP_SR = Self(39)

    comptime AV_PKT_DATA_NB = Self(40)


@fieldwise_init
@register_passable("trivial")
struct AVPacketSideData:
    var data: UnsafePointer[c_uchar, MutAnyOrigin]
    var size: c_uint
    var type: c_int  # AVPacketSideDataType


@fieldwise_init
@register_passable("trivial")
struct AVPacket:
    var buf: UnsafePointer[AVBufferRef, origin = MutOrigin.external]
    "A reference to the reference-counted buffer where the packet data is stored."
    var pts: c_long_long
    "Presentation timestamp in AVStream->time_base units; the time at which the decompressed packet will be presented to the user."
    var dts: c_long_long
    "Decompression timestamp in AVStream->time_base units; the time at which the packet is decompressed."
    var data: UnsafePointer[c_uchar, origin = MutOrigin.external]
    "The data of the packet."
    var size: c_int
    "The size of the packet data."
    var stream_index: c_int
    var flags: c_int
    "A combination of AV_PKT_FLAG values."
    var side_data: UnsafePointer[AVPacketSideData, origin = MutOrigin.external]
    "Additional packet data that can be provided by the container."
    var side_data_elems: c_int
    var duration: c_long_long
    "Duration of this packet in AVStream->time_base units, 0 if unknown."
    var pos: c_long_long
    "Byte position in stream, -1 if unknown."
    var opaque: OpaquePointer[MutOrigin.external]
    "For some private data of the user."
    var opaque_ref: UnsafePointer[AVBufferRef, origin = MutOrigin.external]
    "AVBufferRef for free use by the API user. FFmpeg will never check the contents of the buffer ref. FFmpeg calls av_buffer_unref() on it when the packet is unreferenced. av_packet_copy_props() calls create a new reference with av_buffer_ref() for the target packet's opaque_ref field."
    var time_base: AVRational
    "Time base of the packet's timestamps."


comptime _av_packet_alloc = ExternalFunction[
    "av_packet_alloc", fn () -> UnsafePointer[AVPacket, MutOrigin.external]
]
