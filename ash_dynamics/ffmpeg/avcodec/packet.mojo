"https://www.ffmpeg.org/doxygen/8.0/packet_8h.html"
from sys.ffi import c_uchar, c_uint, c_int, c_long_long, c_size_t, c_char
from os.atomic import Atomic
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.primitives._clib import ExternalFunction
from ash_dynamics.primitives._clib import Debug
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVPacketSideDataType(Debug):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

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
struct AVPacketSideData(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVPacketSideData.html"

    var data: UnsafePointer[c_uchar, MutAnyOrigin]
    var size: c_uint
    var type: AVPacketSideDataType.ENUM_DTYPE


comptime av_packet_side_data_new = ExternalFunction[
    "av_packet_side_data_new",
    fn (
        psd: UnsafePointer[
            UnsafePointer[AVPacketSideData, MutOrigin.external],
            MutOrigin.external,
        ],
        pnb_sd: UnsafePointer[c_int, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        size: c_size_t,
        flags: c_int,
    ) -> UnsafePointer[AVPacketSideData, MutOrigin.external],
]


comptime av_packet_side_data_add = ExternalFunction[
    "av_packet_side_data_add",
    fn (
        psd: UnsafePointer[
            UnsafePointer[AVPacketSideData, MutOrigin.external],
            MutOrigin.external,
        ],
        pnb_sd: UnsafePointer[c_int, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        data: OpaquePointer[MutOrigin.external],
        size: c_size_t,
        flags: c_int,
    ) -> UnsafePointer[AVPacketSideData, MutOrigin.external],
]


comptime av_packet_side_data_get = ExternalFunction[
    "av_packet_side_data_get",
    fn (
        sd: UnsafePointer[AVPacketSideData, ImmutOrigin.external],
        nb_sd: c_int,
        type: AVPacketSideDataType.ENUM_DTYPE,
    ) -> UnsafePointer[AVPacketSideData, ImmutOrigin.external],
]


comptime av_packet_side_data_remove = ExternalFunction[
    "av_packet_side_data_remove",
    fn (
        psd: UnsafePointer[AVPacketSideData, MutOrigin.external],
        pnb_sd: UnsafePointer[c_int, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
    ),
]


comptime av_packet_side_data_free = ExternalFunction[
    "av_packet_side_data_free",
    fn (
        psd: UnsafePointer[
            UnsafePointer[AVPacketSideData, MutOrigin.external],
            MutOrigin.external,
        ],
        pnb_sd: UnsafePointer[c_int, MutOrigin.external],
    ),
]


comptime av_packet_side_data_name = ExternalFunction[
    "av_packet_side_data_name",
    fn (
        type: AVPacketSideDataType.ENUM_DTYPE,
    ) -> UnsafePointer[c_char, ImmutOrigin.external],
]


@fieldwise_init
@register_passable("trivial")
struct AVPacket(StructWritable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVPacket.html"

    var buf: UnsafePointer[AVBufferRef, origin = MutOrigin.external]
    var pts: c_long_long
    var dts: c_long_long
    var data: UnsafePointer[c_uchar, origin = MutOrigin.external]
    var size: c_int
    var stream_index: c_int

    comptime AV_PKT_FLAG_KEY: c_int = 0x0001
    comptime AV_PKT_FLAG_CORRUPT: c_int = 0x0002
    comptime AV_PKT_FLAG_DISCARD: c_int = 0x0004
    comptime AV_PKT_FLAG_TRUSTED: c_int = 0x0008
    comptime AV_PKT_FLAG_DISPOSABLE: c_int = 0x0010

    var flags: c_int
    var side_data: UnsafePointer[AVPacketSideData, origin = MutOrigin.external]
    var side_data_elems: c_int
    var duration: c_long_long
    var pos: c_long_long
    var opaque: OpaquePointer[MutOrigin.external]
    var opaque_ref: UnsafePointer[AVBufferRef, origin = MutOrigin.external]
    var time_base: AVRational

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["buf"](self.buf)
        struct_writer.write_field["pts"](self.pts)
        struct_writer.write_field["dts"](self.dts)
        struct_writer.write_field["data"](self.data)
        struct_writer.write_field["size"](self.size)
        struct_writer.write_field["stream_index"](self.stream_index)
        struct_writer.write_field["flags"](self.flags)
        struct_writer.write_field["side_data"](self.side_data)
        struct_writer.write_field["side_data_elems"](self.side_data_elems)
        struct_writer.write_field["duration"](self.duration)
        struct_writer.write_field["pos"](self.pos)
        struct_writer.write_field["opaque"](self.opaque)
        struct_writer.write_field["opaque_ref"](self.opaque_ref)
        struct_writer.write_field["time_base"](self.time_base)


# NOTE: AVPacketList is an optional struct that is being deprecated.
# I don't think we need to implement this, but leaving this here as a reference.
# #if FF_API_INIT_PACKET
# attribute_deprecated
# typedef struct AVPacketList {
#     AVPacket pkt;
#     struct AVPacketList *next;
# } AVPacketList;
# #endif


comptime AV_PKT_FLAG_KEY = c_int(0x0001)
comptime AV_PKT_FLAG_CORRUPT = c_int(0x0002)
comptime AV_PKT_FLAG_DISCARD = c_int(0x0004)
comptime AV_PKT_FLAG_TRUSTED = c_int(0x0008)
comptime AV_PKT_FLAG_DISPOSABLE = c_int(0x0010)


@fieldwise_init
@register_passable("trivial")
struct AVSideDataParamChangeFlags:
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE
    comptime AV_SIDE_DATA_PARAM_CHANGE_SAMPLE_RATE = Self(0x0004)
    comptime AV_SIDE_DATA_PARAM_CHANGE_DIMENSIONS = Self(0x0008)


comptime av_packet_alloc = ExternalFunction[
    "av_packet_alloc", fn () -> UnsafePointer[AVPacket, MutOrigin.external]
]


comptime av_packet_clone = ExternalFunction[
    "av_packet_clone",
    fn (
        src: UnsafePointer[AVPacket, ImmutOrigin.external],
    ) -> UnsafePointer[AVPacket, MutOrigin.external],
]

comptime av_packet_free = ExternalFunction[
    "av_packet_free",
    fn (
        pkt: UnsafePointer[
            UnsafePointer[AVPacket, MutOrigin.external], MutOrigin.external
        ],
    ),
]

# NOTE: av_init_packet is an optional function that is being deprecated.
# I don't think we need to implement this, but leaving this here as a reference.
# #if FF_API_INIT_PACKET
# /**
#  * Initialize optional fields of a packet with default values.
#  *
#  * Note, this does not touch the data and size members, which have to be
#  * initialized separately.
#  *
#  * @param pkt packet
#  *
#  * @see av_packet_alloc
#  * @see av_packet_unref
#  *
#  * @deprecated This function is deprecated. Once it's removed,
#                sizeof(AVPacket) will not be a part of the ABI anymore.
#  */
# attribute_deprecated
# void av_init_packet(AVPacket *pkt);
# #endif


comptime av_new_packet = ExternalFunction[
    "av_new_packet",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        size: c_int,
    ) -> c_int,
]


comptime av_shrink_packet = ExternalFunction[
    "av_shrink_packet",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        size: c_int,
    ),
]


comptime av_grow_packet = ExternalFunction[
    "av_grow_packet",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        grow_by: c_int,
    ) -> c_int,
]

comptime av_packet_from_data = ExternalFunction[
    "av_packet_from_data",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        data: UnsafePointer[c_uchar, MutOrigin.external],
        size: c_int,
    ) -> c_int,
]


comptime av_packet_new_side_data = ExternalFunction[
    "av_packet_new_side_data",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        size: c_size_t,
    ) -> UnsafePointer[c_uchar, MutOrigin.external],
]


comptime av_packet_add_side_data = ExternalFunction[
    "av_packet_add_side_data",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        data: OpaquePointer[MutOrigin.external],
        size: c_size_t,
    ) -> c_int,
]


comptime av_packet_shrink_side_data = ExternalFunction[
    "av_packet_shrink_side_data",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        size: c_size_t,
    ) -> c_int,
]


comptime av_packet_get_side_data = ExternalFunction[
    "av_packet_get_side_data",
    fn (
        pkt: UnsafePointer[AVPacket, ImmutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        size: UnsafePointer[c_size_t, MutOrigin.external],
    ) -> UnsafePointer[c_uchar, ImmutOrigin.external],
]


comptime av_packet_pack_dictionary = ExternalFunction[
    "av_packet_pack_dictionary",
    fn (
        dict: UnsafePointer[AVDictionary, ImmutOrigin.external],
        size: UnsafePointer[c_size_t, MutOrigin.external],
    ) -> UnsafePointer[c_uchar, ImmutOrigin.external],
]


comptime av_packet_unpack_dictionary = ExternalFunction[
    "av_packet_unpack_dictionary",
    fn (
        data: UnsafePointer[c_uchar, ImmutOrigin.external],
        size: c_size_t,
        dict: UnsafePointer[AVDictionary, MutOrigin.external],
    ) -> c_int,
]


comptime av_packet_free_side_data = ExternalFunction[
    "av_packet_free_side_data",
    fn (pkt: UnsafePointer[AVPacket, MutOrigin.external],),
]


comptime av_packet_ref = ExternalFunction[
    "av_packet_ref",
    fn (
        dst: UnsafePointer[AVPacket, MutOrigin.external],
        src: UnsafePointer[AVPacket, ImmutOrigin.external],
    ) -> c_int,
]

comptime av_packet_unref = ExternalFunction[
    "av_packet_unref",
    fn (pkt: UnsafePointer[AVPacket, MutOrigin.external],),
]

comptime av_packet_move_ref = ExternalFunction[
    "av_packet_move_ref",
    fn (
        dst: UnsafePointer[AVPacket, MutOrigin.external],
        src: UnsafePointer[AVPacket, ImmutOrigin.external],
    ),
]

comptime av_packet_copy_props = ExternalFunction[
    "av_packet_copy_props",
    fn (
        dst: UnsafePointer[AVPacket, MutOrigin.external],
        src: UnsafePointer[AVPacket, ImmutOrigin.external],
    ) -> c_int,
]

comptime av_packet_make_refcounted = ExternalFunction[
    "av_packet_make_refcounted",
    fn (pkt: UnsafePointer[AVPacket, MutOrigin.external],) -> c_int,
]

comptime av_packet_make_writable = ExternalFunction[
    "av_packet_make_writable",
    fn (pkt: UnsafePointer[AVPacket, MutOrigin.external],) -> c_int,
]

comptime av_packet_rescale_ts = ExternalFunction[
    "av_packet_rescale_ts",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        tb_src: c_long_long,  # AVRational,
        tb_dst: c_long_long,  # AVRational,
    ),
]


@register_passable("trivial")
struct AVContainerFifo:
    "https://www.ffmpeg.org/doxygen/8.0/structAVContainerFifo.html"

    pass


comptime av_container_fifo_alloc_avpacket = ExternalFunction[
    "av_container_fifo_alloc_avpacket",
    fn (flags: c_int,) -> UnsafePointer[AVContainerFifo, MutOrigin.external],
]
