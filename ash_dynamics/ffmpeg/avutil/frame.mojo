"https://www.ffmpeg.org/doxygen/8.0/frame_8h.html"

from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil.avutil import AVPictureType
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avutil.pixfmt import (
    AVPixelFormat,
    AVColorRange,
    AVColorPrimaries,
    AVColorTransferCharacteristic,
    AVColorSpace,
    AVChromaLocation,
)
from ffi import c_uchar, c_int, c_long_long, c_ulong_long, c_size_t, c_uint
from utils import StaticTuple
from ash_dynamics.primitives._clib import (
    ExternalFunction,
    MutOriginCastExternalFunction,
    ImmutOriginCastExternalFunction,
    OriginedExternalFunction,
)


# Until https://github.com/modular/modular/pull/5715 is merged, we need to
# extend the unsafe_ptr function to StaticTuple.
__extension StaticTuple:
    @always_inline("nodebug")
    fn unsafe_ptr(
        ref self,
    ) -> UnsafePointer[Self.element_type, origin_of(self)]:
        return (
            UnsafePointer(to=self._mlir_value)
            .bitcast[Self.element_type]()
            .unsafe_origin_cast[origin_of(self)]()
        )


@fieldwise_init("implicit")
struct AVFrameSideDataType(Movable, Writable):
    comptime ENUM_DTYPE = c_int

    var _value: Self.ENUM_DTYPE

    comptime AV_FRAME_DATA_PANSCAN = Self(0)

    comptime AV_FRAME_DATA_A53_CC = Self(1)
    comptime AV_FRAME_DATA_STEREO3D = Self(2)
    comptime AV_FRAME_DATA_MATRIXENCODING = Self(3)
    comptime AV_FRAME_DATA_DOWNMIX_INFO = Self(4)
    comptime AV_FRAME_DATA_REPLAYGAIN = Self(5)
    comptime AV_FRAME_DATA_DISPLAYMATRIX = Self(6)
    comptime AV_FRAME_DATA_AFD = Self(7)
    comptime AV_FRAME_DATA_MOTION_VECTORS = Self(8)
    comptime AV_FRAME_DATA_SKIP_SAMPLES = Self(9)
    comptime AV_FRAME_DATA_AUDIO_SERVICE_TYPE = Self(10)
    comptime AV_FRAME_DATA_MASTERING_DISPLAY_METADATA = Self(11)
    comptime AV_FRAME_DATA_GOP_TIMECODE = Self(12)

    comptime AV_FRAME_DATA_SPHERICAL = Self(13)

    comptime AV_FRAME_DATA_CONTENT_LIGHT_LEVEL = Self(14)

    comptime AV_FRAME_DATA_ICC_PROFILE = Self(15)

    comptime AV_FRAME_DATA_S12M_TIMECODE = Self(16)

    comptime AV_FRAME_DATA_DYNAMIC_HDR_PLUS = Self(17)

    comptime AV_FRAME_DATA_REGIONS_OF_INTEREST = Self(18)

    comptime AV_FRAME_DATA_VIDEO_ENC_PARAMS = Self(19)

    comptime AV_FRAME_DATA_SEI_UNREGISTERED = Self(20)

    comptime AV_FRAME_DATA_FILM_GRAIN_PARAMS = Self(21)

    comptime AV_FRAME_DATA_DETECTION_BBOXES = Self(22)

    comptime AV_FRAME_DATA_DOVI_RPU_BUFFER = Self(23)

    comptime AV_FRAME_DATA_DOVI_METADATA = Self(24)

    comptime AV_FRAME_DATA_DYNAMIC_HDR_VIVID = Self(25)

    comptime AV_FRAME_DATA_AMBIENT_VIEWING_ENVIRONMENT = Self(26)

    comptime AV_FRAME_DATA_VIDEO_HINT = Self(27)

    comptime AV_FRAME_DATA_LCEVC = Self(28)

    comptime AV_FRAME_DATA_VIEW_ID = Self(29)

    comptime AV_FRAME_DATA_3D_REFERENCE_DISPLAYS = Self(30)


@fieldwise_init
struct AVActiveFormatDescription(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AV_AFD_SAME = Self(8)
    comptime AV_AFD_4_3 = Self(9)
    comptime AV_AFD_16_9 = Self(10)
    comptime AV_AFD_14_9 = Self(11)
    comptime AV_AFD_4_3_SP_14_9 = Self(13)
    comptime AV_AFD_16_9_SP_14_9 = Self(14)
    comptime AV_AFD_SP_4_3 = Self(15)


@fieldwise_init
struct AVFrameSideData(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVFrameSideData.html"
    var type: AVFrameSideDataType.ENUM_DTYPE
    var data: UnsafePointer[c_uchar, MutAnyOrigin]
    var size: c_size_t
    var metadata: UnsafePointer[AVDictionary, MutAnyOrigin]
    var buf: UnsafePointer[AVBufferRef, MutAnyOrigin]


@fieldwise_init
struct AVSideDataProps(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AV_SIDE_DATA_PROP_GLOBAL = Self(1 << 0)
    comptime AV_SIDE_DATA_PROP_MULTI = Self(1 << 1)
    comptime AV_SIDE_DATA_PROP_SIZE_DEPENDENT = Self(1 << 2)
    comptime AV_SIDE_DATA_PROP_COLOR_DEPENDENT = Self(1 << 3)
    comptime AV_SIDE_DATA_PROP_CHANNEL_DEPENDENT = Self(1 << 4)


@fieldwise_init
struct AVSideDataDescriptor(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVSideDataDescriptor.html"
    var name: UnsafePointer[c_char, MutAnyOrigin]
    var props: AVSideDataProps.ENUM_DTYPE


@fieldwise_init
struct AVRegionOfInterest(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVRegionOfInterest.html"
    var self_size: c_uint
    var top: c_int
    var bottom: c_int
    var left: c_int
    var right: c_int

    var qoffset: AVRational


@fieldwise_init
struct AVFrame(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVFrame.html"
    comptime AV_NUM_DATA_POINTERS = Int(8)

    var data: StaticTuple[
        UnsafePointer[c_uchar, MutAnyOrigin], Self.AV_NUM_DATA_POINTERS
    ]
    var linesize: StaticTuple[c_int, Self.AV_NUM_DATA_POINTERS]

    var extended_data: UnsafePointer[
        UnsafePointer[c_uchar, origin=MutAnyOrigin],
        origin=MutAnyOrigin,
    ]

    var width: c_int
    var height: c_int

    var nb_samples: c_int

    var format: c_int

    var pict_type: AVPictureType.ENUM_DTYPE

    var sample_aspect_ratio: AVRational

    var pts: c_long_long

    var pkt_dts: c_long_long

    var time_base: AVRational

    var quality: c_int

    var opaque: OpaquePointer[MutAnyOrigin]

    var repeat_pict: c_int

    var sample_rate: c_int

    var buf: StaticTuple[
        UnsafePointer[AVBufferRef, origin=MutAnyOrigin],
        Self.AV_NUM_DATA_POINTERS,
    ]

    var extended_buf: UnsafePointer[
        UnsafePointer[AVBufferRef, origin=MutAnyOrigin],
        origin=MutAnyOrigin,
    ]

    var nb_extended_buf: c_int

    var side_data: UnsafePointer[
        UnsafePointer[AVFrameSideData, origin=MutAnyOrigin],
        origin=MutAnyOrigin,
    ]
    var nb_side_data: c_int

    comptime AV_FRAME_FLAG_CORRUPT = Int(1 << 0)
    comptime AV_FRAME_FLAG_KEY = Int(1 << 1)
    comptime AV_FRAME_FLAG_DISCARD = Int(1 << 2)
    comptime AV_FRAME_FLAG_INTERLACED = Int(1 << 3)
    comptime AV_FRAME_FLAG_TOP_FIELD_FIRST = Int(1 << 4)
    comptime AV_FRAME_FLAG_LOSSLESS = Int(1 << 5)

    var flags: c_int

    var color_range: AVColorRange.ENUM_DTYPE

    var color_primaries: AVColorPrimaries.ENUM_DTYPE

    var color_transfer_characteristic: AVColorTransferCharacteristic.ENUM_DTYPE

    var colorspace: AVColorSpace.ENUM_DTYPE

    var chroma_location: AVChromaLocation.ENUM_DTYPE

    var best_effort_timestamp: c_long_long

    var metadata: AVDictionary

    var decode_error_flags: c_int

    comptime FF_DECODE_ERROR_INVALID_BITSTREAM = Int(1)
    comptime FF_DECODE_ERROR_MISSING_REFERENCE = Int(2)
    comptime FF_DECODE_ERROR_CONCEALMENT_ACTIVE = Int(4)
    comptime FF_DECODE_ERROR_DECODE_SLICES = Int(8)

    var hw_frames_ctx: UnsafePointer[AVBufferRef, origin=MutAnyOrigin]

    var opaque_ref: UnsafePointer[AVBufferRef, origin=MutAnyOrigin]

    var crop_top: c_size_t

    var crop_bottom: c_size_t

    var crop_left: c_size_t

    var crop_right: c_size_t

    var private_ref: OpaquePointer[MutAnyOrigin]

    var ch_layout: AVChannelLayout

    var duration: c_long_long


comptime av_frame_alloc = MutOriginCastExternalFunction[
    "av_frame_alloc", fn() -> UnsafePointer[AVFrame, MutAnyOrigin], AVFrame
]


comptime av_frame_free = ExternalFunction[
    "av_frame_free",
    fn(
        frame: UnsafePointer[UnsafePointer[AVFrame, MutAnyOrigin], MutAnyOrigin]
    ),
]


comptime av_frame_ref = ExternalFunction[
    "av_frame_ref",
    fn(
        dst: UnsafePointer[AVFrame, MutAnyOrigin],
        src: UnsafePointer[AVFrame, ImmutAnyOrigin],
    ) -> c_int,
]


comptime av_frame_replace = ExternalFunction[
    "av_frame_replace",
    fn(
        dst: UnsafePointer[AVFrame, MutAnyOrigin],
        src: UnsafePointer[AVFrame, ImmutAnyOrigin],
    ) -> c_int,
]


comptime av_frame_clone = MutOriginCastExternalFunction[
    "av_frame_clone",
    fn(
        src: UnsafePointer[AVFrame, ImmutAnyOrigin]
    ) -> UnsafePointer[AVFrame, MutAnyOrigin],
    AVFrame,
]


comptime av_frame_unref = ExternalFunction[
    "av_frame_unref",
    fn(frame: UnsafePointer[AVFrame, MutAnyOrigin]),
]


comptime av_frame_move_ref = ExternalFunction[
    "av_frame_move_ref",
    fn(
        dst: UnsafePointer[AVFrame, MutAnyOrigin],
        src: UnsafePointer[AVFrame, ImmutAnyOrigin],
    ),
]


comptime av_frame_get_buffer = ExternalFunction[
    "av_frame_get_buffer",
    fn(frame: UnsafePointer[AVFrame, MutAnyOrigin], align: c_int) -> c_int,
]


comptime av_frame_is_writable = ExternalFunction[
    "av_frame_is_writable",
    fn(frame: UnsafePointer[AVFrame, MutAnyOrigin]) -> c_int,
]


comptime av_frame_make_writable = ExternalFunction[
    "av_frame_make_writable",
    fn(frame: UnsafePointer[AVFrame, MutAnyOrigin]) -> c_int,
]


comptime av_frame_copy = ExternalFunction[
    "av_frame_copy",
    fn(
        dst: UnsafePointer[AVFrame, MutAnyOrigin],
        src: UnsafePointer[AVFrame, ImmutAnyOrigin],
    ) -> c_int,
]


comptime av_frame_copy_props = ExternalFunction[
    "av_frame_copy_props",
    fn(
        dst: UnsafePointer[AVFrame, MutAnyOrigin],
        src: UnsafePointer[AVFrame, ImmutAnyOrigin],
    ) -> c_int,
]


comptime av_frame_get_plane_buffer = MutOriginCastExternalFunction[
    "av_frame_get_plane_buffer",
    fn(
        frame: UnsafePointer[AVFrame, ImmutAnyOrigin], plane: c_int
    ) -> UnsafePointer[AVBufferRef, MutAnyOrigin],
    AVBufferRef,
]


comptime av_frame_new_side_data = MutOriginCastExternalFunction[
    "av_frame_new_side_data",
    fn(
        frame: UnsafePointer[AVFrame, MutAnyOrigin],
        type: AVFrameSideDataType.ENUM_DTYPE,
        size: c_size_t,
    ) -> UnsafePointer[AVFrameSideData, MutAnyOrigin],
    AVFrameSideData,
]


comptime av_frame_new_side_data_from_buf = MutOriginCastExternalFunction[
    "av_frame_new_side_data_from_buf",
    fn(
        frame: UnsafePointer[AVFrame, MutAnyOrigin],
        type: AVFrameSideDataType.ENUM_DTYPE,
        buf: UnsafePointer[AVBufferRef, MutAnyOrigin],
    ) -> UnsafePointer[AVFrameSideData, MutAnyOrigin],
    AVFrameSideData,
]


comptime av_frame_get_side_data = MutOriginCastExternalFunction[
    "av_frame_get_side_data",
    fn(
        frame: UnsafePointer[AVFrame, ImmutAnyOrigin],
        type: AVFrameSideDataType.ENUM_DTYPE,
    ) -> UnsafePointer[AVFrameSideData, MutAnyOrigin],
    AVFrameSideData,
]


comptime av_frame_remove_side_data = ExternalFunction[
    "av_frame_remove_side_data",
    fn(
        frame: UnsafePointer[AVFrame, MutAnyOrigin],
        type: AVFrameSideDataType.ENUM_DTYPE,
    ),
]

########################################################
# ===             Flags for frame cropping           ===
########################################################

comptime AV_FRAME_CROP_UNALIGNED = Int(1 << 0)


comptime av_frame_apply_cropping = ExternalFunction[
    "av_frame_apply_cropping",
    fn(frame: UnsafePointer[AVFrame, MutAnyOrigin], flags: c_int) -> c_int,
]


comptime av_frame_side_data_name = ImmutOriginCastExternalFunction[
    "av_frame_side_data_name",
    fn(
        type: AVFrameSideDataType.ENUM_DTYPE,
    ) -> UnsafePointer[c_char, ImmutAnyOrigin],
    c_char,
]


comptime av_frame_side_data_desc = ImmutOriginCastExternalFunction[
    "av_frame_side_data_desc",
    fn(
        type: AVFrameSideDataType.ENUM_DTYPE,
    ) -> UnsafePointer[AVSideDataDescriptor, ImmutAnyOrigin],
    AVSideDataDescriptor,
]

comptime av_frame_side_data_free = ExternalFunction[
    "av_frame_side_data_free",
    fn(
        sd: UnsafePointer[UnsafePointer[UnsafePointer[AVFrameSideData,]]],
        nb_sd: UnsafePointer[c_int],
    ),
]


comptime AV_FRAME_SIDE_DATA_FLAG_UNIQUE = Int(1 << 0)


comptime AV_FRAME_SIDE_DATA_FLAG_REPLACE = Int(1 << 1)


comptime AV_FRAME_SIDE_DATA_FLAG_NEW_REF = Int(1 << 2)


comptime av_frame_side_data_new = MutOriginCastExternalFunction[
    "av_frame_side_data_new",
    fn(
        sd: UnsafePointer[
            UnsafePointer[
                UnsafePointer[AVFrameSideData, MutAnyOrigin], MutAnyOrigin
            ],
            MutAnyOrigin,
        ],
        nb_sd: UnsafePointer[c_int, MutAnyOrigin],
        type: AVFrameSideDataType.ENUM_DTYPE,
        size: c_size_t,
        flags: c_int,
    ) -> UnsafePointer[AVFrameSideData, MutAnyOrigin],
    AVFrameSideData,
]


comptime av_frame_side_data_add = MutOriginCastExternalFunction[
    "av_frame_side_data_add",
    fn(
        sd: UnsafePointer[
            UnsafePointer[
                UnsafePointer[AVFrameSideData, MutAnyOrigin], MutAnyOrigin
            ],
            MutAnyOrigin,
        ],
        nb_sd: UnsafePointer[c_int, MutAnyOrigin],
        type: AVFrameSideDataType.ENUM_DTYPE,
        buf: UnsafePointer[AVBufferRef, MutAnyOrigin],
        flags: c_int,
    ) -> UnsafePointer[AVFrameSideData, MutAnyOrigin],
    AVFrameSideData,
]


comptime av_frame_side_data_clone = ExternalFunction[
    "av_frame_side_data_clone",
    fn(
        sd: UnsafePointer[
            UnsafePointer[
                UnsafePointer[AVFrameSideData, MutAnyOrigin], MutAnyOrigin
            ],
            MutAnyOrigin,
        ],
        nb_sd: UnsafePointer[c_int, MutAnyOrigin],
        src: UnsafePointer[AVFrameSideData, ImmutAnyOrigin],
        flags: c_int,
    ) -> c_int,
]


# TODO: This is an inline function and probably shouldn't be a
# "external function". This needs to be handled in the dlhandle.
comptime av_frame_side_data_get_c = ImmutOriginCastExternalFunction[
    "av_frame_side_data_get_c",
    fn(
        sd: UnsafePointer[
            UnsafePointer[AVFrameSideData, ImmutAnyOrigin], ImmutAnyOrigin
        ],
        nb_sd: c_int,
        type: AVFrameSideDataType.ENUM_DTYPE,
    ) -> UnsafePointer[AVFrameSideData, ImmutAnyOrigin],
    AVFrameSideData,
]

# TODO: This is an inline function and probably shouldn't be a
# "external function". This needs to be handled in the dlhandle.
# comptime av_frame_side_data_get = ExternalFunction[
#     "av_frame_side_data_get",
#     fn (
#         sd: UnsafePointer[AVFrameSideData, ImmutAnyOrigin],
#         nb_sd: c_int,
#         type: AVFrameSideDataType.ENUM_DTYPE,
#     ) -> UnsafePointer[AVFrameSideData, ImmutAnyOrigin],
# ]


comptime av_frame_side_data_remove = ExternalFunction[
    "av_frame_side_data_remove",
    fn(
        sd: UnsafePointer[
            UnsafePointer[
                UnsafePointer[AVFrameSideData, MutAnyOrigin], MutAnyOrigin
            ],
            MutAnyOrigin,
        ],
        nb_sd: UnsafePointer[c_int, MutAnyOrigin],
        type: AVFrameSideDataType.ENUM_DTYPE,
    ),
]


comptime av_frame_side_data_remove_by_props = ExternalFunction[
    "av_frame_side_data_remove_by_props",
    fn(
        sd: UnsafePointer[
            UnsafePointer[
                UnsafePointer[AVFrameSideData, MutAnyOrigin], MutAnyOrigin
            ],
            MutAnyOrigin,
        ],
        nb_sd: UnsafePointer[c_int, MutAnyOrigin],
        props: c_int,
    ),
]
