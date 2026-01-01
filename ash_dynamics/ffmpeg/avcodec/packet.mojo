"""Bindings for https://www.ffmpeg.org/doxygen/8.0/packet_8h_source.html"""
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
    """Reference [0] for enum details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/group__lavc__packet__side__data.html
    """

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
    """
    This structure stores auxiliary information for decoding, presenting, or
    otherwise processing the coded stream. It is typically exported by demuxers
    and encoders and can be fed to decoders and muxers either in a per packet
    basis, or as global side data (applying to the entire coded stream).

    Global side data is handled as follows:
    - During demuxing, it may be exported through
    @ref AVCodecParameters.coded_side_data "AVStream's codec parameters", which can
    then be passed as input to decoders through the
    @ref AVCodecContext.coded_side_data "decoder context's side data", for
    initialization.
    - For muxing, it can be fed through @ref AVCodecParameters.coded_side_data
    "AVStream's codec parameters", typically  the output of encoders through
    the @ref AVCodecContext.coded_side_data "encoder context's side data", for
    initialization.

    Packet specific side data is handled as follows:
    - During demuxing, it may be exported through @ref AVPacket.side_data
    "AVPacket's side data", which can then be passed as input to decoders.
    - For muxing, it can be fed through @ref AVPacket.side_data "AVPacket's
    side data", typically the output of encoders.

    Different modules may accept or export different types of side data
    depending on media type and codec. Refer to @ref AVPacketSideDataType for a
    list of defined types and where they may be found or used.
    """

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
"""Allocate a new packet side data.

@param psd pointer to an array of side data to which the side data should be 
added. *sd may be NULL, in which case the array will be initialized.
@param pnb_sd pointer to an integer containing the number of entries in the 
array. The integer value will be increased by 1 on success.
@param type side data type
@param size desired side data size
@param flags currently unused. Must be zero
@return pointer to freshly allocated side data on success, or NULL otherwise.
"""


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
"""Wrap existing data as packet side data.

@param psd pointer to an array of side data to which the side data should be 
added. *sd may be NULL, in which case the array will be initialized
@param nb_sd pointer to an integer containing the number of entries in the array. 
The integer value will be increased by 1 on success.
@param type side data type
@param data a data array. It must be allocated with the av_malloc() family of 
functions. The ownership of the data is transferred to the side data array on 
success
@param size size of the data array
@param flags currently unused. Must be zero
@return pointer to freshly allocated side data on success, or NULL otherwise. 
On failure, the side data array is unchanged and the data remains owned by the 
caller.
"""


comptime av_packet_side_data_get = ExternalFunction[
    "av_packet_side_data_get",
    fn (
        sd: UnsafePointer[AVPacketSideData, ImmutOrigin.external],
        nb_sd: c_int,
        type: AVPacketSideDataType.ENUM_DTYPE,
    ) -> UnsafePointer[AVPacketSideData, ImmutOrigin.external],
]
"""Get side information from a side data array.

@param sd the array from which the side data should be fetched
@param nb_sd value containing the number of entries in the array.
@param type desired side information type
@return pointer to side data if present or NULL otherwise
"""


comptime av_packet_side_data_remove = ExternalFunction[
    "av_packet_side_data_remove",
    fn (
        psd: UnsafePointer[AVPacketSideData, MutOrigin.external],
        pnb_sd: UnsafePointer[c_int, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
    ),
]
"""Remove side data of the given type from a side data array.

@param sd the array from which the side data should be removed
@param nb_sd pointer to an integer containing the number of entries in the array. 
Will be reduced by the amount of entries removed upon return
@param type side information type
"""


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
"""Convenience function to free all the side data stored in an array, and the array itself.

@param sd pointer to array of side data to free. Will be set to NULL upon return
@param nb_sd pointer to an integer containing the number of entries in the 
array. Will be set to 0 upon return
"""


comptime av_packet_side_data_name = ExternalFunction[
    "av_packet_side_data_name",
    fn (
        type: AVPacketSideDataType.ENUM_DTYPE,
    ) -> UnsafePointer[c_char, ImmutOrigin.external],
]


@fieldwise_init
@register_passable("trivial")
struct AVPacket(StructWritable):
    """
    This structure stores compressed data. It is typically exported by demuxers
    and then passed as input to decoders, or received as output from encoders and
    then passed to muxers.

    For video, it should typically contain one compressed frame. For audio it may
    contain several compressed frames. Encoders are allowed to output empty
    packets, with no compressed data, containing only side data
    (e.g. to update some stream parameters at the end of encoding).

    The semantics of data ownership depends on the buf field.
    If it is set, the packet data is dynamically allocated and is
    valid indefinitely until a call to av_packet_unref() reduces the
    reference count to 0.

    If the buf field is not set av_packet_ref() would make a copy instead
    of increasing the reference count.

    The side data is always allocated with av_malloc(), copied by
    av_packet_ref() and freed by av_packet_unref().

    sizeof(AVPacket) being a part of the public ABI is deprecated. once
    av_init_packet() is removed, new packets will only be able to be allocated
    with av_packet_alloc(), and new fields may be added to the end of the struct
    with a minor bump.
    """

    var buf: UnsafePointer[AVBufferRef, origin = MutOrigin.external]
    """A reference to the reference-counted buffer where the packet data is stored.
    
    May be NULL, then the packet data is not reference-counted.
    """
    var pts: c_long_long
    """Presentation timestamp in AVStream->time_base units; the time at which 
    the decompressed packet will be presented to the user.
    
    Can be AV_NOPTS_VALUE if it is not stored in the file.
    pts MUST be larger or equal to dts as presentation cannot happen before 
    decompression, unless one wants to view hex dumps. Some formats misuse the 
    terms dts and pts/cts to mean something different. Such timestamps must be 
    converted to true pts/dts before they are stored in AVPacket.

    Note: Default values of -9223372036854775808 is expected.
    """
    var dts: c_long_long
    """Decompression timestamp in AVStream->time_base units; the time at which the packet is decompressed.
    
    Can be AV_NOPTS_VALUE if it is not stored in the file.

    Note: Default values of -9223372036854775808 is expected.
    """
    var data: UnsafePointer[c_uchar, origin = MutOrigin.external]
    "The data of the packet."
    var size: c_int
    "The size of the packet data."
    var stream_index: c_int

    comptime AV_PKT_FLAG_KEY: c_int = 0x0001
    "The packet contains a keyframe."
    comptime AV_PKT_FLAG_CORRUPT: c_int = 0x0002
    "The packet content is corrupted."
    comptime AV_PKT_FLAG_DISCARD: c_int = 0x0004
    """Flaf is used to discard packets which are required to maintain valid
    decoder state but are not required for output and should be dropped
    after decoding.
    """
    comptime AV_PKT_FLAG_TRUSTED: c_int = 0x0008
    """The packet comes from a trusted source.
    
    Otherwise-unsafe constructs such as arbitrary pointers to data
    outside the packet may be followed.
    """
    comptime AV_PKT_FLAG_DISPOSABLE: c_int = 0x0010
    """Flag is used to indicate packets that contain frames that can be 
    discarded by the decoder. I.e. Non-reference frames."""

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
"The packet contains a keyframe."
comptime AV_PKT_FLAG_CORRUPT = c_int(0x0002)
"The packet content is corrupted."
comptime AV_PKT_FLAG_DISCARD = c_int(0x0004)
"""Flag is used to discard packets which are required to maintain valid decoder 
state but are not required for output and should be dropped after decoding."""
comptime AV_PKT_FLAG_TRUSTED = c_int(0x0008)
"""The packet comes from a trusted source.

Otherwise-unsafe constructs such as arbitrary pointers to data outside the 
packet may be followed.
"""
comptime AV_PKT_FLAG_DISPOSABLE = c_int(0x0010)
"""Flag is used to indicate packets that contain frames that can be discarded 
by the decoder. I.e. Non-reference frames."""


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
"""Allocate an AVPacket and set its fields to default values. The resulting 
struct must be freed using av_packet_free().

@return An AVPacket filled with default values or NULL on failure.

@note this only allocates the AVPacket itself, not the data buffers. Those must 
be allocated through other means such as av_new_packet.

@see av_new_packet
"""


comptime av_packet_clone = ExternalFunction[
    "av_packet_clone",
    fn (
        src: UnsafePointer[AVPacket, ImmutOrigin.external],
    ) -> UnsafePointer[AVPacket, MutOrigin.external],
]
"""Create a new packet that references the same data as src.

This is a shortcut for av_packet_alloc()+av_packet_ref().

@return newly created AVPacket on success, NULL on error.

@see av_packet_alloc
@see av_packet_ref
"""

comptime av_packet_free = ExternalFunction[
    "av_packet_free",
    fn (
        pkt: UnsafePointer[
            UnsafePointer[AVPacket, MutOrigin.external], MutOrigin.external
        ],
    ),
]
"""Free the packet, if the packet is reference counted, it will be unreferenced first.

@param pkt packet to be freed. The pointer will be set to NULL.
@note passing NULL is a no-op.
"""

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
"""Allocate the payload of a packet and initialize its fields with default values.

@param pkt packet
@param size wanted payload size
@return 0 if OK, AVERROR_xxx otherwise
"""


comptime av_shrink_packet = ExternalFunction[
    "av_shrink_packet",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        size: c_int,
    ),
]
"""Reduce packet size, correctly zeroing padding

@param pkt packet
@param size new size
"""


comptime av_grow_packet = ExternalFunction[
    "av_grow_packet",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        grow_by: c_int,
    ) -> c_int,
]
"""Increase packet size, correctly zeroing padding

@param pkt packet
@param grow_by number of bytes by which to increase the size of the packet
@return 0 if OK, AVERROR_xxx otherwise
"""

comptime av_packet_from_data = ExternalFunction[
    "av_packet_from_data",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        data: UnsafePointer[c_uchar, MutOrigin.external],
        size: c_int,
    ) -> c_int,
]
"""Initialize a reference-counted packet from av_malloc()ed data.

@param pkt packet to be initialized. This function will set the data, size, and 
buf fields, all others are left untouched.
@param data Data allocated by av_malloc() to be used as packet data. If this 
function returns successfully, the data is owned by the underlying AVBuffer. 
The caller may not access the data through other means.
@param size size of data in bytes, without the padding. I.e. the full buffer 
size is assumed to be size + AV_INPUT_BUFFER_PADDING_SIZE.
@return 0 on success, a negative AVERROR on error
"""


comptime av_packet_new_side_data = ExternalFunction[
    "av_packet_new_side_data",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        size: c_size_t,
    ) -> UnsafePointer[c_uchar, MutOrigin.external],
]
"""Allocate new information of a packet.

@param pkt packet
@param type side information type
@param size side information size
@return pointer to fresh allocated data or NULL otherwise
"""


comptime av_packet_add_side_data = ExternalFunction[
    "av_packet_add_side_data",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        data: OpaquePointer[MutOrigin.external],
        size: c_size_t,
    ) -> c_int,
]
"""Wrap an existing array as a packet side data.

@param pkt packet
@param type side information type
@param data the side data array. It must be allocated with the av_malloc() 
family of functions. The ownership of the data is transferred to pkt.
@param size side information size
@return a non-negative number on success, a negative AVERROR code on failure. 
On failure, the packet is unchanged and the data remains owned by the caller.
"""


comptime av_packet_shrink_side_data = ExternalFunction[
    "av_packet_shrink_side_data",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        size: c_size_t,
    ) -> c_int,
]
"""Shrink the already allocated side data buffer

@param pkt packet
@param type side information type
@param size new side information size
@return 0 on success, < 0 on failure
"""


comptime av_packet_get_side_data = ExternalFunction[
    "av_packet_get_side_data",
    fn (
        pkt: UnsafePointer[AVPacket, ImmutOrigin.external],
        type: AVPacketSideDataType.ENUM_DTYPE,
        size: UnsafePointer[c_size_t, MutOrigin.external],
    ) -> UnsafePointer[c_uchar, ImmutOrigin.external],
]
"""Get side information from packet.

@param pkt packet
@param type desired side information type
@param size If supplied, *size will be set to the size of the side data or to 
zero if the desired side data is not present.
@return pointer to data if present or NULL otherwise
"""


comptime av_packet_pack_dictionary = ExternalFunction[
    "av_packet_pack_dictionary",
    fn (
        dict: UnsafePointer[AVDictionary, ImmutOrigin.external],
        size: UnsafePointer[c_size_t, MutOrigin.external],
    ) -> UnsafePointer[c_uchar, ImmutOrigin.external],
]
"""Pack a dictionary for use in side_data.

@param dict The dictionary to pack.
@param size pointer to store the size of the returned data
@return pointer to data if successful, NULL otherwise
"""


comptime av_packet_unpack_dictionary = ExternalFunction[
    "av_packet_unpack_dictionary",
    fn (
        data: UnsafePointer[c_uchar, ImmutOrigin.external],
        size: c_size_t,
        dict: UnsafePointer[AVDictionary, MutOrigin.external],
    ) -> c_int,
]
"""Unpack a dictionary from side_data.

@param data data from side_data
@param size size of the data
@param dict the metadata storage dictionary
@return 0 on success, < 0 on failure
"""


comptime av_packet_free_side_data = ExternalFunction[
    "av_packet_free_side_data",
    fn (pkt: UnsafePointer[AVPacket, MutOrigin.external],),
]
"""Convenience function to free all the side data stored. All the other fields stay untouched.

@param pkt packet
"""


comptime av_packet_ref = ExternalFunction[
    "av_packet_ref",
    fn (
        dst: UnsafePointer[AVPacket, MutOrigin.external],
        src: UnsafePointer[AVPacket, ImmutOrigin.external],
    ) -> c_int,
]
"""Setup a new reference to the data described by a given packet.

If src is reference-counted, setup dst as a new reference to the buffer in src. 
Otherwise allocate a new buffer in dst and copy the data from src into it.
All the other fields are copied from src.

All the other fields are copied from src.

@param dst Destination packet. Will be completely overwritten.
@param src Source packet
@return 0 on success, a negative AVERROR on error. On error, dst will be blank 
(as if returned by av_packet_alloc()).
"""

comptime av_packet_unref = ExternalFunction[
    "av_packet_unref",
    fn (pkt: UnsafePointer[AVPacket, MutOrigin.external],),
]
"""Wipe the packet.

Unreference the buffer referenced by the packet and reset the remaining packet fields to their default values.

@param pkt The packet to be unreferenced.
"""

comptime av_packet_move_ref = ExternalFunction[
    "av_packet_move_ref",
    fn (
        dst: UnsafePointer[AVPacket, MutOrigin.external],
        src: UnsafePointer[AVPacket, ImmutOrigin.external],
    ),
]
"""Move every field in src to dst and reset src.

@param src Source packet, will be reset
@param dst Destination packet
"""

comptime av_packet_copy_props = ExternalFunction[
    "av_packet_copy_props",
    fn (
        dst: UnsafePointer[AVPacket, MutOrigin.external],
        src: UnsafePointer[AVPacket, ImmutOrigin.external],
    ) -> c_int,
]
"""Copy only "properties" fields from src to dst.

Properties for the purpose of this function are all the fields beside those 
related to the packet data (buf, data, size)

@param dst Destination packet. Will be completely overwritten.
@param src Source packet
@return 0 on success, a negative AVERROR on error. On error, dst will be blank 
(as if returned by av_packet_alloc()).
"""

comptime av_packet_make_refcounted = ExternalFunction[
    "av_packet_make_refcounted",
    fn (pkt: UnsafePointer[AVPacket, MutOrigin.external],) -> c_int,
]
"""Ensure the data described by a given packet is reference counted.

@note This function does not ensure that the reference will be writable. 
Use av_packet_make_writable instead for that purpose.

@see av_packet_ref
@see av_packet_make_writable

@param pkt packet whose data should be made reference counted.

@return 0 on success, a negative AVERROR on error. On failure, the packet is unchanged.
"""

comptime av_packet_make_writable = ExternalFunction[
    "av_packet_make_writable",
    fn (pkt: UnsafePointer[AVPacket, MutOrigin.external],) -> c_int,
]
"""Create a writable reference for the data described by a given packet, 
avoiding data copy if possible.

@param pkt Packet whose data should be made writable.
@return 0 on success, a negative AVERROR on failure. On failure, the packet is unchanged.
"""

comptime av_packet_rescale_ts = ExternalFunction[
    "av_packet_rescale_ts",
    fn (
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        tb_src: c_long_long,  # AVRational,
        tb_dst: c_long_long,  # AVRational,
    ),
]
"""Convert valid timing fields (timestamps / durations) in a packet from one 
timebase to another. Timestamps with unknown values (AV_NOPTS_VALUE) will be ignored.

@param pkt packet on which the conversion will be performed
@param tb_src source timebase, in which the timing fields in pkt are expressed
@param tb_dst destination timebase, to which the timing fields will be converted
"""


@register_passable("trivial")
struct AVContainerFifo:
    """AVContainerFifo is a FIFO for "containers" - dynamically allocated
    reusable structs (e.g. AVFrame or AVPacket). AVContainerFifo uses an
    internal pool of such containers to avoid allocating and freeing them repeatedly.

    Mojo note: I think this is a private / internal struct that serves as an
    opaque interface with publicly facing code.
    """

    pass


comptime av_container_fifo_alloc_avpacket = ExternalFunction[
    "av_container_fifo_alloc_avpacket",
    fn (flags: c_int,) -> UnsafePointer[AVContainerFifo, MutOrigin.external],
]
"""Allocate an AVContainerFifo instance for AVPacket.

@param flags currently unused
@return pointer to the allocated AVContainerFifo instance or NULL on failure
"""
