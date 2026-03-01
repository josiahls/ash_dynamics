"""https://www.ffmpeg.org/doxygen/8.0/avformat_8h.html

Main libavformat public API header

I/O and Muxing/Demuxing Library
"""
from ffi import c_int, c_char, c_uchar, c_long_long, c_uint, c_size_t
from sys._libc import dup, fclose, fdopen, fflush, FILE_ptr
from utils import StaticTuple
from ash_dynamics.primitives._clib import C_Union, ExternalFunction, Debug
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket, AVPacketSideData
from ash_dynamics.ffmpeg.avcodec.codec_par import AVCodecParameters
from ash_dynamics.ffmpeg.avcodec.defs import AVDiscard
from ash_dynamics.ffmpeg.avcodec.avcodec import AVCodecParserContext

from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType

from ash_dynamics.ffmpeg.avformat.internal import AVCodecTag
from ash_dynamics.ffmpeg.avformat.avio import AVIOContext, AVIOInterruptCB

from ash_dynamics.ffmpeg.avutil.iamf import (
    AVIAMFMixPresentation,
    AVIAMFSubmix,
    AVIAMFSubmixElement,
    AVIAMFSubmixLayout,
    AVIAMFAudioElement,
    AVIAMFLayer,
    AVIAMFParamDefinition,
    AVIAMFAudioElementType,
    AVIAMFHeadphonesMode,
    AVIAMFSubmixLayoutType,
)


comptime av_get_packet = ExternalFunction[
    "av_get_packet",
    fn(
        s: UnsafePointer[AVIOContext, origin=MutExternalOrigin],
        pkt: UnsafePointer[AVPacket, origin=MutExternalOrigin],
        size: c_int,
    ) -> c_int,
]

comptime av_append_packet = ExternalFunction[
    "av_append_packet",
    fn(
        s: UnsafePointer[AVIOContext, origin=MutExternalOrigin],
        pkt: UnsafePointer[AVPacket, origin=MutExternalOrigin],
        size: c_int,
    ) -> c_int,
]

########################## input / output formats ##############################

# TODO: Is this a forward declaration?
# struct AVCodecTag;


@fieldwise_init
struct AVProbeData(Movable, Writable):
    """https://www.ffmpeg.org/doxygen/8.0/structAVProbeData.html"""

    var filename: UnsafePointer[c_char, origin=ImmutExternalOrigin]
    var buf: UnsafePointer[c_uchar, origin=MutExternalOrigin]
    var buf_size: c_int
    var mime_type: UnsafePointer[c_char, origin=ImmutExternalOrigin]

    comptime AVPROBE_SCORE_MAX = 100
    comptime AVPROBE_SCORE_RETRY = Self.AVPROBE_SCORE_MAX / 4
    comptime AVPROBE_SCORE_STREAM_RETRY = Self.AVPROBE_SCORE_MAX / 4 - 1

    comptime AVPROBE_SCORE_EXTENSION = 50
    comptime AVPROBE_SCORE_MIME_BONUS = 30

    comptime AVPROBE_PADDING_SIZE = 32


comptime AVFMT_NOFILE = 0x0001
comptime AVFMT_NEEDNUMBER = 0x0002

# The muxer/demuxer is experimental and should be used with caution.
# It will not be selected automatically, and must be specified explicitly.
comptime AVFMT_EXPERIMENTAL = 0x0004
comptime AVFMT_SHOW_IDS = 0x0008
comptime AVFMT_GLOBALHEADER = 0x0040
comptime AVFMT_NOTIMESTAMPS = 0x0080
comptime AVFMT_GENERIC_INDEX = 0x0100
comptime AVFMT_TS_DISCONT = 0x0200
comptime AVFMT_VARIABLE_FPS = 0x0400
comptime AVFMT_NODIMENSIONS = 0x0800
comptime AVFMT_NOSTREAMS = 0x1000
comptime AVFMT_NOBINSEARCH = 0x2000
comptime AVFMT_NOGENSEARCH = 0x4000
comptime AVFMT_NO_BYTE_SEEK = 0x8000
comptime AVFMT_TS_NONSTRICT = 0x20000
comptime AVFMT_TS_NEGATIVE = 0x40000
comptime AVFMT_SEEK_TO_PTS = 0x4000000


@fieldwise_init
struct AVOutputFormat(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVOutputFormat.html"
    var name: UnsafePointer[c_char, origin=ImmutExternalOrigin]
    var long_name: UnsafePointer[c_char, origin=ImmutExternalOrigin]
    var mime_type: UnsafePointer[c_char, origin=ImmutExternalOrigin]
    var extensions: UnsafePointer[c_char, origin=ImmutExternalOrigin]

    var audio_codec: AVCodecID.ENUM_DTYPE
    var video_codec: AVCodecID.ENUM_DTYPE
    var subtitle_codec: AVCodecID.ENUM_DTYPE

    var flags: c_int

    var codec_tag: UnsafePointer[
        UnsafePointer[AVCodecTag, ImmutExternalOrigin], ImmutExternalOrigin
    ]
    var priv_class: UnsafePointer[AVClass, ImmutExternalOrigin]


@fieldwise_init
struct AVInputFormat(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVInputFormat.html"
    var name: UnsafePointer[c_char, origin=ImmutExternalOrigin]
    var long_name: UnsafePointer[c_char, origin=ImmutExternalOrigin]
    var flags: c_int
    var extensions: UnsafePointer[c_char, origin=ImmutExternalOrigin]
    var codec_tag: UnsafePointer[
        UnsafePointer[AVCodecTag, ImmutExternalOrigin], ImmutExternalOrigin
    ]
    var priv_class: UnsafePointer[AVClass, ImmutExternalOrigin]
    var mime_type: UnsafePointer[c_char, origin=ImmutExternalOrigin]


@fieldwise_init
struct AVStreamParseType(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AVSTREAM_PARSE_NONE = Self(0)
    comptime AVSTREAM_PARSE_FULL = Self(1)
    comptime AVSTREAM_PARSE_HEADERS = Self(2)
    comptime AVSTREAM_PARSE_TIMESTAMPS = Self(3)
    comptime AVSTREAM_PARSE_FULL_ONCE = Self(4)
    comptime AVSTREAM_PARSE_FULL_RAW = Self(5)


@fieldwise_init
struct AVIndexEntry(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIndexEntry.html"
    var pos: c_long_long
    var timestamp: c_long_long

    comptime AVINDEX_KEYFRAME = 0x0001
    comptime AVINDEX_DISCARD_FRAME = 0x0002

    var flags_size: c_int
    var min_distance: c_int


comptime AV_DISPOSITION_DEFAULT = 1 << 0
comptime AV_DISPOSITION_DUB = 1 << 1
comptime AV_DISPOSITION_ORIGINAL = 1 << 2
comptime AV_DISPOSITION_COMMENT = 1 << 3
comptime AV_DISPOSITION_LYRICS = 1 << 4
comptime AV_DISPOSITION_KARAOKE = 1 << 5
comptime AV_DISPOSITION_FORCED = 1 << 6
comptime AV_DISPOSITION_HEARING_IMPAIRED = 1 << 7
comptime AV_DISPOSITION_VISUAL_IMPAIRED = 1 << 8
comptime AV_DISPOSITION_CLEAN_EFFECTS = 1 << 9
comptime AV_DISPOSITION_ATTACHED_PIC = 1 << 10
comptime AV_DISPOSITION_TIMED_THUMBNAILS = 1 << 11
comptime AV_DISPOSITION_NON_DIEGETIC = 1 << 12
comptime AV_DISPOSITION_CAPTIONS = 1 << 16
comptime AV_DISPOSITION_DESCRIPTIONS = 1 << 17
comptime AV_DISPOSITION_METADATA = 1 << 18
comptime AV_DISPOSITION_DEPENDENT = 1 << 19
comptime AV_DISPOSITION_STILL_IMAGE = 1 << 20
comptime AV_DISPOSITION_MULTILAYER = 1 << 21

comptime av_disposition_from_string = ExternalFunction[
    "av_disposition_from_string",
    fn(disp: UnsafePointer[c_char, origin=ImmutExternalOrigin]) -> c_int,
]

comptime av_disposition_to_string = ExternalFunction[
    "av_disposition_to_string",
    fn(
        disposition: c_int,
    ) -> UnsafePointer[c_char, origin=ImmutExternalOrigin],
]

# Options for behavior on timestamp wrap detection.
comptime AV_PTS_WRAP_IGNORE = 0
comptime AV_PTS_WRAP_ADD_OFFSET = 1
comptime AV_PTS_WRAP_SUB_OFFSET = -1


@fieldwise_init
struct AVStream(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVStream.html"

    var av_class: UnsafePointer[AVClass, ImmutExternalOrigin]
    var index: c_int
    var id: c_int
    var codecpar: UnsafePointer[AVCodecParameters, MutExternalOrigin]
    var priv_data: OpaquePointer[MutExternalOrigin]
    var time_base: AVRational

    var start_time: c_long_long
    var duration: c_long_long

    var nb_frames: c_long_long

    var disposition: c_int

    var discard: AVDiscard.ENUM_DTYPE

    var sample_aspect_ratio: AVRational

    var metadata: UnsafePointer[AVDictionary, MutExternalOrigin]

    var avg_frame_rate: AVRational

    var attached_pic: AVPacket

    var event_flags: c_int

    comptime AVSTREAM_EVENT_FLAG_METADATA_UPDATED = 0x0001
    comptime AVSTREAM_EVENT_FLAG_NEW_PACKETS = 1 << 1

    var r_frame_rate: AVRational

    var pts_wrap_bits: c_int


@fieldwise_init
struct _AVStreamGroupTileGrid_offsets(Movable, Writable):
    """Binding note: In the original header this is a anonymous struct.
    Mojo does not support this, so we define this as a private, name spaced
    struct outside of AVStreamGroupTileGrid.
    """

    var idx: c_uint
    var horizontal: c_int
    var vertical: c_int


@fieldwise_init
struct AVStreamGroupTileGrid(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVStreamGroupTileGrid.html"

    var av_class: UnsafePointer[AVClass, ImmutExternalOrigin]
    var nb_tiles: c_uint
    var coded_width: c_int
    var coded_height: c_int
    var offsets: UnsafePointer[
        _AVStreamGroupTileGrid_offsets, MutExternalOrigin
    ]

    var background: StaticTuple[c_uchar, 4]
    var horizontal_offset: c_int
    var vertical_offset: c_int
    var width: c_int
    var height: c_int
    var coded_side_data: UnsafePointer[AVPacketSideData, MutExternalOrigin]
    var nb_coded_side_data: c_int


@fieldwise_init
struct AVStreamGroupLCEVC(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVStreamGroupLCEVC.html"

    var av_class: UnsafePointer[AVClass, ImmutExternalOrigin]
    var lcevc_index: c_uint
    var width: c_int
    var height: c_int


@fieldwise_init
struct AVStreamGroupParamsType(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_STREAM_GROUP_PARAMS_NONE = Self(0)
    comptime AV_STREAM_GROUP_PARAMS_IAMF_AUDIO_ELEMENT = Self(1)
    comptime AV_STREAM_GROUP_PARAMS_IAMF_MIX_PRESENTATION = Self(2)
    comptime AV_STREAM_GROUP_PARAMS_TILE_GRID = Self(3)
    comptime AV_STREAM_GROUP_PARAMS_LCEVC = Self(4)


# TODO: Are these forward declaraions?
# struct AVIAMFAudioElement;
# struct AVIAMFMixPresentation;


@fieldwise_init
struct AVStreamGroup(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVStreamGroup.html"

    var av_class: UnsafePointer[AVClass, ImmutExternalOrigin]
    var priv_data: OpaquePointer[MutExternalOrigin]
    var index: c_uint
    var id: c_long_long
    var type: AVStreamGroupParamsType.ENUM_DTYPE
    var params: C_Union[
        UnsafePointer[AVIAMFAudioElement, MutExternalOrigin],
        UnsafePointer[AVIAMFMixPresentation, MutExternalOrigin],
        UnsafePointer[AVStreamGroupTileGrid, MutExternalOrigin],
        UnsafePointer[AVStreamGroupLCEVC, MutExternalOrigin],
    ]
    var metadata: UnsafePointer[AVDictionary, MutExternalOrigin]
    var nb_streams: c_uint
    var streams: UnsafePointer[
        UnsafePointer[AVStream, MutExternalOrigin], MutExternalOrigin
    ]
    var disposition: c_int


comptime av_stream_get_parser = ExternalFunction[
    "av_stream_get_parser",
    fn(
        s: UnsafePointer[AVStream, ImmutExternalOrigin],
    ) -> UnsafePointer[AVCodecParserContext, ImmutExternalOrigin],
]

comptime AV_PROGRAM_RUNNING = 1


@fieldwise_init
struct AVProgram(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVProgram.html"

    var id: c_int
    var flags: c_int
    var discard: AVDiscard.ENUM_DTYPE
    var stream_index: UnsafePointer[c_uint, MutExternalOrigin]
    var nb_stream_indexes: c_uint
    var metadata: UnsafePointer[AVDictionary, MutExternalOrigin]

    var program_num: c_int
    var pmt_pid: c_int
    var pcr_pid: c_int
    var pmt_version: c_int

    # All fields below this line are not part of the public API. They
    # may not be used outside of libavformat and can be changed and
    # removed at will.
    # New public fields should be added right above.

    var start_time: c_long_long
    var end_time: c_long_long

    var pts_wrap_reference: c_long_long
    var pts_wrap_behavior: c_int


comptime AVFMTCTX_NOHEADER = 0x0001
comptime AVFMTCTX_UNSEEKABLE = 0x0002


@fieldwise_init
struct AVChapter(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVChapter.html"
    var id: c_long_long
    var time_base: AVRational
    var start: c_long_long
    var end: c_long_long
    var metadata: UnsafePointer[AVDictionary, MutExternalOrigin]


# TODO: This is not a real function. This is a prototype used by AVFormatContext.control_message_cb.
# comptime av_format_control_message = ExternalFunction[
#     "av_format_control_message",
#     fn (
#         s: UnsafePointer[AVFormatContext, MutExternalOrigin],
#         type: c_int,
#         data: OpaquePointer[MutExternalOrigin],
#         data_size: c_size_t,
#     ) -> c_int,
# ]


comptime AVOpenCallback = fn(
    s: UnsafePointer[AVFormatContext, MutExternalOrigin],
    pb: UnsafePointer[
        UnsafePointer[AVIOContext, MutExternalOrigin], MutExternalOrigin
    ],
    url: UnsafePointer[c_char, ImmutExternalOrigin],
    flags: c_int,
    int_cb: UnsafePointer[AVIOInterruptCB, ImmutExternalOrigin],
    options: UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int


@fieldwise_init
struct AVDurationEstimationMethod(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AVFMT_DURATION_FROM_PTS = Self(0)
    comptime AVFMT_DURATION_FROM_STREAM = Self(1)
    comptime AVFMT_DURATION_FROM_BITRATE = Self(2)


# @register_passable("trivial")
@fieldwise_init
struct AVFormatContext(Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVFormatContext.html"

    var av_class: UnsafePointer[AVClass, ImmutExternalOrigin]
    var iformat: UnsafePointer[AVInputFormat, ImmutExternalOrigin]
    var oformat: UnsafePointer[AVOutputFormat, ImmutExternalOrigin]
    var priv_data: OpaquePointer[MutExternalOrigin]
    var pb: UnsafePointer[AVIOContext, MutExternalOrigin]
    # Stream info
    var ctx_flags: c_int
    var nb_streams: c_uint
    var streams: UnsafePointer[
        UnsafePointer[AVStream, MutExternalOrigin], MutExternalOrigin
    ]
    var nb_stream_groups: c_uint
    var stream_groups: UnsafePointer[
        UnsafePointer[AVStreamGroup, MutExternalOrigin], MutExternalOrigin
    ]

    var nb_chapters: c_uint

    var chapters: UnsafePointer[
        UnsafePointer[AVChapter, MutExternalOrigin], MutExternalOrigin
    ]

    var url: UnsafePointer[c_char, MutExternalOrigin]
    var start_time: c_long_long
    var duration: c_long_long
    var bit_rate: c_long_long
    var packet_size: c_uint
    var max_delay: c_int

    var flags: c_int
    comptime AVFMT_FLAG_GENPTS = 0x0001
    comptime AVFMT_FLAG_IGNIDX = 0x0002
    comptime AVFMT_FLAG_NONBLOCK = 0x0004
    comptime AVFMT_FLAG_IGNDTS = 0x0008
    comptime AVFMT_FLAG_NOFILLIN = 0x0010
    comptime AVFMT_FLAG_NOPARSE = 0x0020
    comptime AVFMT_FLAG_NOBUFFER = 0x0040
    comptime AVFMT_FLAG_CUSTOM_IO = 0x0080
    comptime AVFMT_FLAG_DISCARD_CORRUPT = 0x0100
    comptime AVFMT_FLAG_FLUSH_PACKETS = 0x0200

    comptime AVFMT_FLAG_BITEXACT = 0x0400
    comptime AVFMT_FLAG_SORT_DTS = 0x10000
    comptime AVFMT_FLAG_FAST_SEEK = 0x80000
    comptime AVFMT_FLAG_AUTO_BSF = 0x200000

    var probesize: c_long_long
    var max_analyze_duration: c_long_long

    var key: UnsafePointer[c_uchar, ImmutExternalOrigin]
    var keylen: c_int

    var nb_programs: c_uint
    var programs: UnsafePointer[
        UnsafePointer[AVProgram, MutExternalOrigin], MutExternalOrigin
    ]

    var video_codec_id: AVCodecID.ENUM_DTYPE
    var audio_codec_id: AVCodecID.ENUM_DTYPE
    var subtitle_codec_id: AVCodecID.ENUM_DTYPE
    var data_codec_id: AVCodecID.ENUM_DTYPE
    var metadata: UnsafePointer[AVDictionary, MutExternalOrigin]
    var start_time_realtime: c_long_long
    var fps_probe_size: c_int
    var error_recognition: c_int
    var interrupt_callback: AVIOInterruptCB
    var debug: c_int
    comptime FF_FDEBUG_TS = 0x0001

    var max_streams: c_int
    var max_index_size: c_uint
    var max_picture_buffer: c_uint
    var max_interleave_delta: c_long_long

    var max_ts_probe: c_int
    var max_chunk_duration: c_int
    var max_chunk_size: c_int
    var max_probe_packets: c_int
    var strict_std_compliance: c_int
    var event_flags: c_int

    comptime AVFMT_EVENT_FLAG_METADATA_UPDATED = 0x0001

    var avoid_negative_ts: c_int
    comptime AVFMT_AVOID_NEG_TS_AUTO = -1
    comptime AVFMT_AVOID_NEG_TS_DISABLED = 0
    comptime AVFMT_AVOID_NEG_TS_MAKE_NON_NEGATIVE = 1
    comptime AVFMT_AVOID_NEG_TS_MAKE_ZERO = 2
    var audio_preload: c_int
    var use_wallclock_as_timestamps: c_int
    var skip_estimate_duration_from_pts: c_int
    var avio_flags: c_int
    var duration_estimation_method: AVDurationEstimationMethod.ENUM_DTYPE
    var skip_initial_bytes: c_long_long
    var correct_ts_overflow: c_uint
    var seek2any: c_int
    var flush_packets: c_int
    var probe_score: c_int
    var format_probesize: c_int
    var codec_whitelist: UnsafePointer[c_char, MutExternalOrigin]
    var format_whitelist: UnsafePointer[c_char, MutExternalOrigin]
    var protocol_whitelist: UnsafePointer[c_char, MutExternalOrigin]
    var protocol_blacklist: UnsafePointer[c_char, MutExternalOrigin]
    var io_repositioned: c_int
    var video_codec: UnsafePointer[AVCodec, ImmutExternalOrigin]
    var audio_codec: UnsafePointer[AVCodec, ImmutExternalOrigin]
    var subtitle_codec: UnsafePointer[AVCodec, ImmutExternalOrigin]
    var data_codec: UnsafePointer[AVCodec, ImmutExternalOrigin]
    var metadata_header_padding: c_int
    var opaque: OpaquePointer[MutExternalOrigin]

    # TODO: should these be pointers? How does this impact struct size?
    # For some reason I can't define this under: av_format_control_message
    # var control_message_cb: type_of(av_format_control_message)
    var control_message_cb: fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        type: c_int,
        data: OpaquePointer[MutExternalOrigin],
        data_size: c_size_t,
    ) -> c_int
    var output_ts_offset: c_long_long
    var dump_separator: UnsafePointer[c_uchar, MutExternalOrigin]
    var io_open: fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        pb: UnsafePointer[
            UnsafePointer[AVIOContext, MutExternalOrigin], MutExternalOrigin
        ],
        url: UnsafePointer[c_char, ImmutExternalOrigin],
        flags: c_int,
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ],
    ) -> c_int
    var io_close2: fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        pb: UnsafePointer[AVIOContext, MutExternalOrigin],
    ) -> c_int

    var duration_probesize: c_long_long


comptime avformat_version = ExternalFunction[
    "avformat_version",
    fn() -> c_int,
]

comptime avformat_configuration = ExternalFunction[
    "avformat_configuration",
    fn() -> UnsafePointer[c_char, ImmutExternalOrigin],
]

comptime avformat_license = ExternalFunction[
    "avformat_license",
    fn() -> UnsafePointer[c_char, ImmutExternalOrigin],
]

comptime avformat_network_init = ExternalFunction[
    "avformat_network_init",
    fn() -> c_int,
]

comptime avformat_network_deinit = ExternalFunction[
    "avformat_network_deinit",
    fn() -> c_int,
]

comptime av_muxer_iterate = ExternalFunction[
    "av_muxer_iterate",
    fn(
        opaque: UnsafePointer[
            OpaquePointer[MutExternalOrigin], MutExternalOrigin
        ],
    ) -> UnsafePointer[AVOutputFormat, ImmutExternalOrigin],
]

comptime av_demuxer_iterate = ExternalFunction[
    "av_demuxer_iterate",
    fn(
        opaque: UnsafePointer[
            OpaquePointer[MutExternalOrigin], MutExternalOrigin
        ],
    ) -> UnsafePointer[AVInputFormat, ImmutExternalOrigin],
]

comptime avformat_alloc_context = ExternalFunction[
    "avformat_alloc_context",
    fn() -> UnsafePointer[AVFormatContext, MutExternalOrigin],
]

comptime avformat_free_context = ExternalFunction[
    "avformat_free_context",
    fn(s: UnsafePointer[AVFormatContext, MutExternalOrigin],),
]

comptime avformat_get_class = ExternalFunction[
    "avformat_get_class",
    fn() -> UnsafePointer[AVClass, ImmutExternalOrigin],
]

comptime av_stream_get_class = ExternalFunction[
    "av_stream_get_class",
    fn() -> UnsafePointer[AVClass, ImmutExternalOrigin],
]

comptime av_stream_group_get_class = ExternalFunction[
    "av_stream_group_get_class",
    fn() -> UnsafePointer[AVClass, ImmutExternalOrigin],
]

comptime avformat_stream_group_name = ExternalFunction[
    "avformat_stream_group_name",
    fn(
        type: AVStreamGroupParamsType.ENUM_DTYPE,
    ) -> UnsafePointer[c_char, ImmutExternalOrigin],
]

comptime avformat_stream_group_create = ExternalFunction[
    "avformat_stream_group_create",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        type: AVStreamGroupParamsType.ENUM_DTYPE,
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ],
    ) -> UnsafePointer[AVStreamGroup, MutExternalOrigin],
]

comptime avformat_new_stream = ExternalFunction[
    "avformat_new_stream",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        c: UnsafePointer[AVCodec, ImmutExternalOrigin],
    ) -> UnsafePointer[AVStream, MutExternalOrigin],
]

comptime avformat_stream_group_add_stream = ExternalFunction[
    "avformat_stream_group_add_stream",
    fn(
        stg: UnsafePointer[AVStreamGroup, MutExternalOrigin],
        st: UnsafePointer[AVStream, MutExternalOrigin],
    ) -> c_int,
]

comptime av_new_program = ExternalFunction[
    "av_new_program",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        id: c_int,
    ) -> UnsafePointer[AVProgram, MutExternalOrigin],
]

comptime avformat_alloc_output_context2 = ExternalFunction[
    "avformat_alloc_output_context2",
    fn(
        ctx: UnsafePointer[
            UnsafePointer[AVFormatContext, MutExternalOrigin],
            MutAnyOrigin,
        ],
        oformat: UnsafePointer[AVOutputFormat, ImmutExternalOrigin],
        format_name: UnsafePointer[c_char, ImmutExternalOrigin],
        filename: UnsafePointer[c_char, ImmutAnyOrigin],
    ) -> c_int,
]
comptime av_find_input_format = ExternalFunction[
    "av_find_input_format",
    fn(
        short_name: UnsafePointer[c_char, ImmutExternalOrigin],
    ) -> UnsafePointer[AVInputFormat, ImmutExternalOrigin],
]

comptime av_probe_input_format = ExternalFunction[
    "av_probe_input_format",
    fn(
        pd: UnsafePointer[AVProbeData, ImmutExternalOrigin],
        is_opened: c_int,
    ) -> UnsafePointer[AVInputFormat, ImmutExternalOrigin],
]

comptime av_probe_input_format2 = ExternalFunction[
    "av_probe_input_format2",
    fn(
        pd: UnsafePointer[AVProbeData, ImmutExternalOrigin],
        is_opened: c_int,
        score_max: UnsafePointer[c_int, MutExternalOrigin],
    ) -> UnsafePointer[AVInputFormat, ImmutExternalOrigin],
]

comptime av_probe_input_format3 = ExternalFunction[
    "av_probe_input_format3",
    fn(
        pd: UnsafePointer[AVProbeData, ImmutExternalOrigin],
        is_opened: c_int,
        score_ret: UnsafePointer[c_int, MutExternalOrigin],
    ) -> UnsafePointer[AVInputFormat, ImmutExternalOrigin],
]

comptime av_probe_input_buffer2 = ExternalFunction[
    "av_probe_input_buffer2",
    fn(
        pb: UnsafePointer[AVIOContext, MutExternalOrigin],
        fmt: UnsafePointer[
            UnsafePointer[AVInputFormat, ImmutExternalOrigin],
            ImmutExternalOrigin,
        ],
        url: UnsafePointer[c_char, ImmutExternalOrigin],
        logctx: OpaquePointer[MutExternalOrigin],
        offset: c_uint,
        max_probe_size: c_uint,
    ) -> c_int,
]

comptime av_probe_input_buffer = ExternalFunction[
    "av_probe_input_buffer",
    fn(
        pb: UnsafePointer[AVIOContext, MutExternalOrigin],
        fmt: UnsafePointer[
            UnsafePointer[AVInputFormat, ImmutExternalOrigin],
            ImmutExternalOrigin,
        ],
        url: UnsafePointer[c_char, ImmutExternalOrigin],
        logctx: OpaquePointer[MutExternalOrigin],
        offset: c_uint,
        max_probe_size: c_uint,
    ) -> c_int,
]


comptime avformat_open_input = ExternalFunction[
    "avformat_open_input",
    fn(
        s: UnsafePointer[
            UnsafePointer[AVFormatContext, MutExternalOrigin],
            MutExternalOrigin,
        ],
        url: UnsafePointer[c_char, ImmutExternalOrigin],
        fmt: UnsafePointer[AVInputFormat, ImmutExternalOrigin],
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ],
    ) -> c_int,
]

comptime avformat_find_stream_info = ExternalFunction[
    "avformat_find_stream_info",
    fn(
        ic: UnsafePointer[AVFormatContext, MutExternalOrigin],
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ],
    ) -> c_int,
]

comptime av_find_program_from_stream = ExternalFunction[
    "av_find_program_from_stream",
    fn(
        ic: UnsafePointer[AVFormatContext, MutExternalOrigin],
        last: UnsafePointer[AVProgram, MutExternalOrigin],
        s: c_int,
    ) -> UnsafePointer[AVProgram, MutExternalOrigin],
]

comptime av_program_add_stream_index = ExternalFunction[
    "av_program_add_stream_index",
    fn(
        ac: UnsafePointer[AVFormatContext, MutExternalOrigin],
        progid: c_int,
        idx: c_uint,
    ),
]

comptime av_find_best_stream = ExternalFunction[
    "av_find_best_stream",
    fn(
        ic: UnsafePointer[AVFormatContext, MutExternalOrigin],
        type: AVMediaType.ENUM_DTYPE,
        wanted_stream_nb: c_int,
        related_stream: c_int,
        decoder_ret: UnsafePointer[
            UnsafePointer[AVCodec, ImmutExternalOrigin], ImmutExternalOrigin
        ],
        flags: c_int,
    ) -> c_int,
]

comptime av_read_frame = ExternalFunction[
    "av_read_frame",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        pkt: UnsafePointer[AVPacket, MutExternalOrigin],
    ) -> c_int,
]

comptime av_seek_frame = ExternalFunction[
    "av_seek_frame",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        stream_index: c_int,
        timestamp: c_long_long,
        flags: c_int,
    ) -> c_int,
]

comptime avformat_seek_file = ExternalFunction[
    "avformat_seek_file",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        stream_index: c_int,
        min_ts: c_long_long,
        ts: c_long_long,
        max_ts: c_long_long,
        flags: c_int,
    ) -> c_int,
]

comptime avformat_flush = ExternalFunction[
    "avformat_flush",
    fn(s: UnsafePointer[AVFormatContext, MutExternalOrigin],),
]
comptime av_read_play = ExternalFunction[
    "av_read_play",
    fn(s: UnsafePointer[AVFormatContext, MutExternalOrigin],),
]

comptime av_read_pause = ExternalFunction[
    "av_read_pause",
    fn(s: UnsafePointer[AVFormatContext, MutExternalOrigin],),
]

comptime avformat_close_input = ExternalFunction[
    "avformat_close_input",
    fn(
        s: UnsafePointer[
            UnsafePointer[AVFormatContext, MutExternalOrigin],
            MutExternalOrigin,
        ],
    ),
]

comptime AVSEEK_FLAG_BACKWARD = 1
comptime AVSEEK_FLAG_BYTE = 2
comptime AVSEEK_FLAG_ANY = 4
comptime AVSEEK_FLAG_FRAME = 8
comptime AVSTREAM_INIT_IN_WRITE_HEADER = 0
comptime AVSTREAM_INIT_IN_INIT_OUTPUT = 1

comptime avformat_write_header = ExternalFunction[
    "avformat_write_header",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ],
    ) -> c_int,
]

comptime avformat_init_output = ExternalFunction[
    "avformat_init_output",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
        ],
    ) -> c_int,
]

comptime av_write_frame = ExternalFunction[
    "av_write_frame",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        pkt: UnsafePointer[AVPacket, MutExternalOrigin],
    ) -> c_int,
]

comptime av_interleaved_write_frame = ExternalFunction[
    "av_interleaved_write_frame",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        pkt: UnsafePointer[AVPacket, MutExternalOrigin],
    ) -> c_int,
]

comptime av_write_uncoded_frame = ExternalFunction[
    "av_write_uncoded_frame",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        stream_index: c_int,
        frame: UnsafePointer[AVFrame, MutExternalOrigin],
    ) -> c_int,
]

comptime av_interleaved_write_uncoded_frame = ExternalFunction[
    "av_interleaved_write_uncoded_frame",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        stream_index: c_int,
        frame: UnsafePointer[AVFrame, MutExternalOrigin],
    ) -> c_int,
]

comptime av_write_uncoded_frame_query = ExternalFunction[
    "av_write_uncoded_frame_query",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        stream_index: c_int,
    ) -> c_int,
]
comptime av_write_trailer = ExternalFunction[
    "av_write_trailer",
    fn(s: UnsafePointer[AVFormatContext, MutExternalOrigin],) -> c_int,
]

comptime av_guess_format = ExternalFunction[
    "av_guess_format",
    fn(
        short_name: UnsafePointer[c_char, ImmutAnyOrigin],
        filename: UnsafePointer[c_char, ImmutAnyOrigin],
        mime_type: UnsafePointer[c_char, ImmutAnyOrigin],
    ) -> UnsafePointer[AVOutputFormat, ImmutExternalOrigin],
]

comptime av_guess_codec = ExternalFunction[
    "av_guess_codec",
    fn(
        fmt: UnsafePointer[AVOutputFormat, ImmutExternalOrigin],
        short_name: UnsafePointer[c_char, ImmutExternalOrigin],
        filename: UnsafePointer[c_char, ImmutExternalOrigin],
        mime_type: UnsafePointer[c_char, ImmutExternalOrigin],
        type: AVMediaType.ENUM_DTYPE,
    ) -> AVCodecID.ENUM_DTYPE,
]

comptime av_get_output_timestamp = ExternalFunction[
    "av_get_output_timestamp",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        stream: c_int,
        dts: UnsafePointer[c_long_long, MutExternalOrigin],
        wall: UnsafePointer[c_long_long, MutExternalOrigin],
    ) -> c_int,
]

comptime av_hex_dump = ExternalFunction[
    "av_hex_dump",
    fn(
        f: FILE_ptr,
        buf: UnsafePointer[c_uchar, ImmutExternalOrigin],
        size: c_int,
    ),
]

comptime av_hex_dump_log = ExternalFunction[
    "av_hex_dump_log",
    fn(
        avcl: OpaquePointer[MutExternalOrigin],
        level: c_int,
        buf: UnsafePointer[c_uchar, ImmutExternalOrigin],
        size: c_int,
    ),
]

comptime av_pkt_dump2 = ExternalFunction[
    "av_pkt_dump2",
    fn(
        f: FILE_ptr,
        pkt: UnsafePointer[AVPacket, ImmutExternalOrigin],
        dump_payload: c_int,
        st: UnsafePointer[AVStream, ImmutExternalOrigin],
    ),
]

comptime av_pkt_dump_log2 = ExternalFunction[
    "av_pkt_dump_log2",
    fn(
        avcl: OpaquePointer[MutExternalOrigin],
        level: c_int,
        pkt: UnsafePointer[AVPacket, ImmutExternalOrigin],
        dump_payload: c_int,
        st: UnsafePointer[AVStream, ImmutExternalOrigin],
    ),
]

comptime av_codec_get_id = ExternalFunction[
    "av_codec_get_id",
    fn(
        tags: UnsafePointer[
            UnsafePointer[AVCodecTag, ImmutExternalOrigin],
            ImmutExternalOrigin,
        ],
        tag: c_uint,
    ) -> AVCodecID.ENUM_DTYPE,
]

comptime av_codec_get_tag = ExternalFunction[
    "av_codec_get_tag",
    fn(
        tags: UnsafePointer[
            UnsafePointer[AVCodecTag, ImmutExternalOrigin],
            ImmutExternalOrigin,
        ],
        id: AVCodecID.ENUM_DTYPE,
    ) -> c_uint,
]

comptime av_codec_get_tag2 = ExternalFunction[
    "av_codec_get_tag2",
    fn(
        tags: UnsafePointer[
            UnsafePointer[AVCodecTag, ImmutExternalOrigin],
            ImmutExternalOrigin,
        ],
        id: AVCodecID.ENUM_DTYPE,
        tag: UnsafePointer[c_uint, MutExternalOrigin],
    ) -> c_int,
]

comptime av_find_default_stream_index = ExternalFunction[
    "av_find_default_stream_index",
    fn(s: UnsafePointer[AVFormatContext, MutExternalOrigin],) -> c_int,
]


comptime av_index_search_timestamp = ExternalFunction[
    "av_index_search_timestamp",
    fn(
        st: UnsafePointer[AVStream, MutExternalOrigin],
        timestamp: c_long_long,
        flags: c_int,
    ) -> c_int,
]

comptime avformat_index_get_entries_count = ExternalFunction[
    "avformat_index_get_entries_count",
    fn(st: UnsafePointer[AVStream, MutExternalOrigin],) -> c_int,
]

comptime avformat_index_get_entry = ExternalFunction[
    "avformat_index_get_entry",
    fn(
        st: UnsafePointer[AVStream, MutExternalOrigin],
        idx: c_int,
    ) -> UnsafePointer[AVIndexEntry, ImmutExternalOrigin],
]

comptime avformat_index_get_entry_from_timestamp = ExternalFunction[
    "avformat_index_get_entry_from_timestamp",
    fn(
        st: UnsafePointer[AVStream, MutExternalOrigin],
        timestamp: c_long_long,
        flags: c_int,
    ) -> UnsafePointer[AVIndexEntry, ImmutExternalOrigin],
]

comptime av_add_index_entry = ExternalFunction[
    "av_add_index_entry",
    fn(
        st: UnsafePointer[AVStream, MutExternalOrigin],
        pos: c_long_long,
        timestamp: c_long_long,
        size: c_int,
        distance: c_int,
        flags: c_int,
    ) -> c_int,
]

comptime av_url_split = ExternalFunction[
    "av_url_split",
    fn(
        proto: UnsafePointer[c_char, MutExternalOrigin],
        proto_size: c_int,
        authorization: UnsafePointer[c_char, MutExternalOrigin],
        authorization_size: c_int,
        hostname: UnsafePointer[c_char, MutExternalOrigin],
        hostname_size: c_int,
        port_ptr: UnsafePointer[c_int, MutExternalOrigin],
        path: UnsafePointer[c_char, MutExternalOrigin],
        path_size: c_int,
        url: UnsafePointer[c_char, ImmutExternalOrigin],
    ) -> c_int,
]

comptime av_dump_format = ExternalFunction[
    "av_dump_format",
    fn(
        ic: UnsafePointer[AVFormatContext, MutExternalOrigin],
        index: c_int,
        url: UnsafePointer[c_char, ImmutAnyOrigin],
        is_output: c_int,
    ),
]

comptime AV_FRAME_FILENAME_FLAGS_MULTIPLE = 1

comptime av_get_frame_filename2 = ExternalFunction[
    "av_get_frame_filename2",
    fn(
        buf: UnsafePointer[c_char, MutExternalOrigin],
        buf_size: c_int,
        path: UnsafePointer[c_char, ImmutExternalOrigin],
        number: c_int,
        flags: c_int,
    ) -> c_int,
]

comptime av_get_frame_filename = ExternalFunction[
    "av_get_frame_filename",
    fn(
        buf: UnsafePointer[c_char, MutExternalOrigin],
        buf_size: c_int,
        path: UnsafePointer[c_char, ImmutExternalOrigin],
        number: c_int,
    ) -> c_int,
]


comptime av_filename_number_test = ExternalFunction[
    "av_filename_number_test",
    fn(filename: UnsafePointer[c_char, ImmutExternalOrigin],) -> c_int,
]

comptime av_sdp_create = ExternalFunction[
    "av_sdp_create",
    fn(
        ac: UnsafePointer[
            UnsafePointer[AVFormatContext, MutExternalOrigin],
            MutExternalOrigin,
        ],
        n_files: c_int,
        buf: UnsafePointer[c_char, MutExternalOrigin],
        size: c_int,
    ) -> c_int,
]

comptime av_match_ext = ExternalFunction[
    "av_match_ext",
    fn(
        filename: UnsafePointer[c_char, ImmutExternalOrigin],
        extensions: UnsafePointer[c_char, ImmutExternalOrigin],
    ) -> c_int,
]


comptime avformat_query_codec = ExternalFunction[
    "avformat_query_codec",
    fn(
        ofmt: UnsafePointer[AVOutputFormat, ImmutExternalOrigin],
        codec_id: AVCodecID.ENUM_DTYPE,
        std_compliance: c_int,
    ) -> c_int,
]

# Get the tables mapping RIFF FourCCs for video to libavcodec AVCodecID. The
# tables are meant to be passed to av_codec_get_id()/av_codec_get_tag() as in the
# following code:
# @code
# uint32_t tag = MKTAG('H', '2', '6', '4');
# const struct AVCodecTag *table[] = { avformat_get_riff_video_tags(), 0 };
# enum AVCodecID id = av_codec_get_id(table, tag);
# @endcode
comptime avformat_get_riff_video_tags = ExternalFunction[
    "avformat_get_riff_video_tags",
    fn() -> UnsafePointer[AVCodecTag, ImmutExternalOrigin],
]

comptime avformat_get_riff_audio_tags = ExternalFunction[
    "avformat_get_riff_audio_tags",
    fn() -> UnsafePointer[AVCodecTag, ImmutExternalOrigin],
]

comptime avformat_get_mov_video_tags = ExternalFunction[
    "avformat_get_mov_video_tags",
    fn() -> UnsafePointer[AVCodecTag, ImmutExternalOrigin],
]

comptime avformat_get_mov_audio_tags = ExternalFunction[
    "avformat_get_mov_audio_tags",
    fn() -> UnsafePointer[AVCodecTag, ImmutExternalOrigin],
]

comptime av_guess_sample_aspect_ratio = ExternalFunction[
    "av_guess_sample_aspect_ratio",
    fn(
        format: UnsafePointer[AVFormatContext, MutExternalOrigin],
        stream: UnsafePointer[AVStream, MutExternalOrigin],
        frame: UnsafePointer[AVFrame, MutExternalOrigin],
    ) -> AVRational,
]

comptime av_guess_frame_rate = ExternalFunction[
    "av_guess_frame_rate",
    fn(
        ctx: UnsafePointer[AVFormatContext, MutExternalOrigin],
        stream: UnsafePointer[AVStream, MutExternalOrigin],
        frame: UnsafePointer[AVFrame, MutExternalOrigin],
    ) -> AVRational,
]

comptime avformat_match_stream_specifier = ExternalFunction[
    "avformat_match_stream_specifier",
    fn(
        s: UnsafePointer[AVFormatContext, MutExternalOrigin],
        st: UnsafePointer[AVStream, MutExternalOrigin],
        spec: UnsafePointer[c_char, ImmutExternalOrigin],
    ) -> c_int,
]

comptime avformat_queue_attached_pictures = ExternalFunction[
    "avformat_queue_attached_pictures",
    fn(s: UnsafePointer[AVFormatContext, MutExternalOrigin],) -> c_int,
]


# Note: this section is in the original header file, however is being deprecated.
# AVTimebaseSource
# avformat_transfer_internal_stream_timing_info
# av_stream_get_codec_timebase
# Are all behind a macro flag with APIs that are being deprecated.
