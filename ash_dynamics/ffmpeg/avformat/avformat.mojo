"""
Main libavformat public API header

Reference:
 - https://www.ffmpeg.org/doxygen/8.0/avformat_8h_source.html

I/O and Muxing/Demuxing Library
"""
from sys.ffi import c_int, c_char, c_uchar, c_long_long, c_uint, c_size_t
from sys._libc import dup, fclose, fdopen, fflush, FILE_ptr
from utils import StaticTuple
from ash_dynamics.primitives._clib import C_Union, ExternalFunction
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
    fn (
        s: UnsafePointer[AVIOContext, origin = MutOrigin.external],
        pkt: UnsafePointer[AVPacket, origin = MutOrigin.external],
        size: c_int,
    ) -> c_int,
]
"""
Allocate and read the payload of a packet and initialize its
fields with default values.

Arguments:
    s: associated IO context
    pkt: packet
    size: desired payload size

Returns:
    >0 (read size) if OK, AVERROR_xxx otherwise
"""

comptime av_append_packet = ExternalFunction[
    "av_append_packet",
    fn (
        s: UnsafePointer[AVIOContext, origin = MutOrigin.external],
        pkt: UnsafePointer[AVPacket, origin = MutOrigin.external],
        size: c_int,
    ) -> c_int,
]
"""
Read data and append it to the current content of the AVPacket.

If pkt->size is 0 this is identical to av_get_packet.
Note that this uses av_grow_packet and thus involves a realloc
which is inefficient. Thus this function should only be used
when there is no reasonable way to know (an upper bound of)
the final size.

Arguments:
    s: associated IO context
    pkt: packet
    size: amount of data to read

Returns:
    >0 (read size) if OK, AVERROR_xxx otherwise, previous data
    will not be lost even if an error occurs.
"""

########################## input / output formats ##############################

# TODO: Is this a forward declaration?
# struct AVCodecTag;


@register_passable("trivial")
@fieldwise_init
struct AVProbeData:
    """This structure contains the data a format has to probe a file."""

    var filename: UnsafePointer[c_char, origin = ImmutOrigin.external]
    var buf: UnsafePointer[c_uchar, origin = MutOrigin.external]
    "Buffer must have AVPROBE_PADDING_SIZE of extra allocated bytes filled with zero."
    var buf_size: c_int
    "Size of buf except extra allocated bytes."
    var mime_type: UnsafePointer[c_char, origin = ImmutOrigin.external]
    "A mime_type, when known."

    comptime AVPROBE_SCORE_MAX = 100
    "The maximum score."
    comptime AVPROBE_SCORE_RETRY = Self.AVPROBE_SCORE_MAX / 4
    comptime AVPROBE_SCORE_STREAM_RETRY = Self.AVPROBE_SCORE_MAX / 4 - 1

    comptime AVPROBE_SCORE_EXTENSION = 50
    "The score for file extension."
    comptime AVPROBE_SCORE_MIME_BONUS = 30
    "The score added for matching mime type."

    comptime AVPROBE_PADDING_SIZE = 32
    "The extra allocated bytes at the end of the probe buffer."


comptime AVFMT_NOFILE = 0x0001
"Demuxer will use avio_open, no opened file should be provided by the caller."
comptime AVFMT_NEEDNUMBER = 0x0002
"Needs '%d' in filename."

# The muxer/demuxer is experimental and should be used with caution.
# It will not be selected automatically, and must be specified explicitly.
comptime AVFMT_EXPERIMENTAL = 0x0004
"The muxer/demuxer is experimental and should be used with caution."
comptime AVFMT_SHOW_IDS = 0x0008
"Show format stream IDs numbers."
comptime AVFMT_GLOBALHEADER = 0x0040
"Format wants global header."
comptime AVFMT_NOTIMESTAMPS = 0x0080
"Format does not need / have any timestamps."
comptime AVFMT_GENERIC_INDEX = 0x0100
"Use generic index building code."
comptime AVFMT_TS_DISCONT = 0x0200
"""Format allows timestamp discontinuities. Note, muxers always require 
valid (monotone) timestamps."""
comptime AVFMT_VARIABLE_FPS = 0x0400
"Format allows variable FPS."
comptime AVFMT_NODIMENSIONS = 0x0800
"Format does not need width/height."
comptime AVFMT_NOSTREAMS = 0x1000
"Format does not require any streams."
comptime AVFMT_NOBINSEARCH = 0x2000
"Format does not allow to fall back on binary search via read_timestamp."
comptime AVFMT_NOGENSEARCH = 0x4000
"Format does not allow to fall back on generic search."
comptime AVFMT_NO_BYTE_SEEK = 0x8000
"Format does not allow seeking by bytes."
comptime AVFMT_TS_NONSTRICT = 0x20000
"""Format does not require strictly increasing timestamps, but they must 
still be monotonic."""
comptime AVFMT_TS_NEGATIVE = 0x40000
"""Format allows muxing negative timestamps. If not set the timestamp will 
be shifted in av_write_frame and av_interleaved_write_frame so they start 
from 0. The user or muxer can override this through 
AVFormatContext.avoid_negative_ts."""
comptime AVFMT_SEEK_TO_PTS = 0x4000000
"Seeking is based on PTS."


@register_passable("trivial")
@fieldwise_init
struct AVOutputFormat:
    var name: UnsafePointer[c_char, origin = ImmutOrigin.external]
    "Short name for the format."
    var long_name: UnsafePointer[c_char, origin = ImmutOrigin.external]
    """Descriptive name for the format, meant to be more human-readable
    than name. You should use the NULL_IF_CONFIG_SMALL() macro
    to define it."""
    var mime_type: UnsafePointer[c_char, origin = ImmutOrigin.external]
    "MIME type."
    var extensions: UnsafePointer[c_char, origin = ImmutOrigin.external]
    "Comma-separated filename extensions."

    # output support
    var audio_codec: AVCodecID.ENUM_DTYPE
    "Default audio codec."
    var video_codec: AVCodecID.ENUM_DTYPE
    "Default video codec."
    var subtitle_codec: AVCodecID.ENUM_DTYPE
    "Default subtitle codec."

    var flags: c_int
    """Can use flags: AVFMT_NOFILE, AVFMT_NEEDNUMBER,
    AVFMT_GLOBALHEADER, AVFMT_NOTIMESTAMPS, AVFMT_VARIABLE_FPS,
    AVFMT_NODIMENSIONS, AVFMT_NOSTREAMS,
    AVFMT_TS_NONSTRICT, AVFMT_TS_NEGATIVE."""

    var codec_tag: UnsafePointer[
        UnsafePointer[AVCodecTag, ImmutOrigin.external], ImmutOrigin.external
    ]
    """List of supported codec_id-codec_tag pairs, ordered by "better
    choice first". The arrays are all terminated by AV_CODEC_ID_NONE."""
    var priv_class: UnsafePointer[AVClass, ImmutOrigin.external]
    "Private class for the private context."


@register_passable("trivial")
@fieldwise_init
struct AVInputFormat:
    var name: UnsafePointer[c_char, origin = ImmutOrigin.external]
    """A comma separated list of short names for the format. New names
    may be appended with a minor bump."""
    var long_name: UnsafePointer[c_char, origin = ImmutOrigin.external]
    """Descriptive name for the format, meant to be more human-readable
    than name. You should use the NULL_IF_CONFIG_SMALL() macro
    to define it."""
    var flags: c_int
    """Can use flags: AVFMT_NOFILE, AVFMT_NEEDNUMBER, AVFMT_SHOW_IDS,
    AVFMT_NOTIMESTAMPS, AVFMT_GENERIC_INDEX, AVFMT_TS_DISCONT, AVFMT_NOBINSEARCH,
    AVFMT_NOGENSEARCH, AVFMT_NO_BYTE_SEEK, AVFMT_SEEK_TO_PTS."""
    var extensions: UnsafePointer[c_char, origin = ImmutOrigin.external]
    """If extensions are defined, then no probe is done. You should
    usually not use extension format guessing because it is not
    reliable enough."""
    var codec_tag: UnsafePointer[
        UnsafePointer[AVCodecTag, ImmutOrigin.external], ImmutOrigin.external
    ]
    """List of supported codec_id-codec_tag pairs, ordered by "better
    choice first". The arrays are all terminated by AV_CODEC_ID_NONE."""
    var priv_class: UnsafePointer[AVClass, ImmutOrigin.external]
    "Private class for the private context."
    var mime_type: UnsafePointer[c_char, origin = ImmutOrigin.external]
    """Comma-separated list of mime types.
    It is used check for matching mime types while probing.
    @see av_probe_input_format2."""


@register_passable("trivial")
@fieldwise_init
struct AVStreamParseType:
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AVSTREAM_PARSE_NONE = Self(0)
    "None."
    comptime AVSTREAM_PARSE_FULL = Self(1)
    "Full pasing and repack."
    comptime AVSTREAM_PARSE_HEADERS = Self(2)
    "Only parse headers, do not repack."
    comptime AVSTREAM_PARSE_TIMESTAMPS = Self(3)
    "Full parsing and interpolation of timestamps for frames not starting on a packet boundary."
    comptime AVSTREAM_PARSE_FULL_ONCE = Self(4)
    "Full parsing and repack of the first frame only, only implemented for H.264 currently."
    comptime AVSTREAM_PARSE_FULL_RAW = Self(5)
    """Full parsing and repack with timestamp and position generation by parser for raw
    this assumes that each packet in the file contains no demuxer level headers and
    just codec level data, otherwise position generation would fail."""


@register_passable("trivial")
@fieldwise_init
struct AVIndexEntry:
    var pos: c_long_long
    "Position of the index entry in the stream."
    var timestamp: c_long_long
    """Timestamp in AVStream.time_base units, preferably the time from which on 
    correctly decoded frames are available
    when seeking to this entry. That means preferable PTS on keyframe based 
    formats.
    But demuxers can choose to store a different timestamp, if it is more 
    convenient for the implementation or nothing better
    is known."""

    comptime AVINDEX_KEYFRAME = 0x0001
    "Flag is used to indicate which frame should be discarded after decoding."
    comptime AVINDEX_DISCARD_FRAME = 0x0002
    "Flag is used to indicate which frame should be discarded after decoding."

    var flags_size: c_int
    """These are 2 bit-fields merged together.
    
    int flags:2
    int size:30

    In the original header. Mojo doesn't support bit fields, so we just combine 
    these into a single field. Be aware that the first 2 bits are for the flag,
    and the remaining 30 are for the size.
    """
    var min_distance: c_int
    "Minimum distance between this and the previous keyframe, used to avoid unneeded searching."


comptime AV_DISPOSITION_DEFAULT = 1 << 0
"""The steam should be chosen by default among other streams of the same type,
unless the user has explicitly specified otherwise."""
comptime AV_DISPOSITION_DUB = 1 << 1
"""The stream is not in original language.

@note AV_DISPOSITION_ORIGINAL is the inverse of this disposition. At most
    one of them should be set in properly tagged streams.
@note This disposition may apply to any stream type, not just audio.    
"""
comptime AV_DISPOSITION_ORIGINAL = 1 << 2
"""The stream is in original language.

@see the notes for AV_DISPOSITION_DUB
"""
comptime AV_DISPOSITION_COMMENT = 1 << 3
"""The stream is a commentary track."""
comptime AV_DISPOSITION_LYRICS = 1 << 4
"""The stream contains song lyrics."""
comptime AV_DISPOSITION_KARAOKE = 1 << 5
"""The stream contains karaoke audio."""

comptime AV_DISPOSITION_FORCED = 1 << 6
"""The stream should be used during playback by default.

Useful for subtitle track that should be displayed even when user did not explicitly ask for subtitles."""
comptime AV_DISPOSITION_HEARING_IMPAIRED = 1 << 7
"""The stream is intended for hearing impaired audiences."""
comptime AV_DISPOSITION_VISUAL_IMPAIRED = 1 << 8
"""The stream is intended for visually impaired audiences."""
comptime AV_DISPOSITION_CLEAN_EFFECTS = 1 << 9
"""The audio stream contains music and sound effects without voice."""
comptime AV_DISPOSITION_ATTACHED_PIC = 1 << 10
"""The stream is stored in the file as an attached picture/"cover art" (e.g.
APIC frame in ID3v2). The first (usually only) packet associated with it
will be returned among the first few packets read from the file unless
seeking takes place. It can also be accessed at any time in
AVStream.attached_pic."""
comptime AV_DISPOSITION_TIMED_THUMBNAILS = 1 << 11
"""The stream is sparse, and contains thumbnail images, often corresponding
to chapter markers. Only ever used with AV_DISPOSITION_ATTACHED_PIC."""
comptime AV_DISPOSITION_NON_DIEGETIC = 1 << 12
"""The stream is intended to be mixed with a spatial audio track. For example,
it could be used for narration or stereo music, and may remain unchanged by
listener head rotation."""
comptime AV_DISPOSITION_CAPTIONS = 1 << 16
"""The subtitle stream contains captions, providing a transcription and possibly
a translation of audio. Typically intended for hearing-impaired audiences."""
comptime AV_DISPOSITION_DESCRIPTIONS = 1 << 17
"""The subtitle stream contains a textual description of the video content.
Typically intended for visually-impaired audiences or for the cases where the
video cannot be seen."""
comptime AV_DISPOSITION_METADATA = 1 << 18
"""The subtitle stream contains time-aligned metadata that is not intended to be
directly presented to the user."""
comptime AV_DISPOSITION_DEPENDENT = 1 << 19
"""The stream is intended to be mixed with another stream before presentation.
Used for example to signal the stream contains an image part of a HEIF grid,
or for mix_type=0 in mpegts."""
comptime AV_DISPOSITION_STILL_IMAGE = 1 << 20
"""The video stream contains still images."""
comptime AV_DISPOSITION_MULTILAYER = 1 << 21
"""The video stream contains multiple layers, e.g. stereoscopic views (cf. H.264
Annex G/H, or HEVC Annex F)."""

comptime av_disposition_from_string = ExternalFunction[
    "av_disposition_from_string",
    fn (disp: UnsafePointer[c_char, origin = ImmutOrigin.external]) -> c_int,
]
"""
Return the AV_DISPOSITION_* flag corresponding to disp or a negative error
code if disp does not correspond to a known stream disposition.
"""

comptime av_disposition_to_string = ExternalFunction[
    "av_disposition_to_string",
    fn (
        disposition: c_int,
    ) -> UnsafePointer[c_char, origin = ImmutOrigin.external],
]
"""Converts a disposition flag to a string description.
Arguments:
    disposition: a combination of AV_DISPOSITION_* values.

Returns:
    The string description corresponding to the lowest set bit in
    disposition. NULL when the lowest set bit does not correspond
    to a known disposition or when disposition is 0.
"""

# Options for behavior on timestamp wrap detection.
comptime AV_PTS_WRAP_IGNORE = 0
"""Ignore the wrap."""
comptime AV_PTS_WRAP_ADD_OFFSET = 1
"""Add the format specific offset on wrap detection."""
comptime AV_PTS_WRAP_SUB_OFFSET = -1
"""Subtract the format specific offset on wrap detection."""


@register_passable("trivial")
@fieldwise_init
struct AVStream:
    """Stream structure.

    New fields can be added to the end with minor version bumps.
    Removal, reordering and changes to existing fields require a major
    version bump.
    sizeof(AVStream) must not be used outside libav*.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    "A class for @ref avoptions. Set on stream creation."
    var index: c_int
    "Stream index in AVFormatContext."
    var id: c_int
    """Format-specific stream ID.
    
    decoding: set by libavformat
    encoding: set by the user, replaced by libavformat if left unset
    """
    var codecpar: UnsafePointer[AVCodecParameters, MutOrigin.external]
    """Codec parameters associated with this stream. Allocated and freed by
    libavformat in avformat_new_stream() and avformat_free_context()
    respectively.
    
    - demuxing: filled by libavformat on stream creation or in
    avformat_find_stream_info()
    - muxing: filled by the caller before avformat_write_header()
    """
    var priv_data: OpaquePointer[MutOrigin.external]
    """Private data for use by the user.
    """
    var time_base: AVRational
    """Time base in AVStream.time_base units.
    
    decoding: set by libavformat
    encoding: May be set by the caller before avformat_write_header() to
    provide a hint to the muxer about the desired timebase. In
    avformat_write_header(), the muxer will overwrite this field
    with the timebase that will actually be used for the timestamps
    written into the file (which may or may not be related to the
    user-provided one, depending on the format)."""

    var start_time: c_long_long
    """Decoding: pts of the first frame of the stream in presentation order, in stream time base.
    Only set this if you are absolutely 100% sure that the value you set
    it to really is the pts of the first frame.
    This may be undefined (AV_NOPTS_VALUE).
    @note The ASF header does NOT contain a correct start_time the ASF
    demuxer must NOT set this.
    """

    var duration: c_long_long
    """Decoding: duration of the stream, in stream time base.
    If a source file does not specify a duration, but does specify
    a bitrate, this value will be estimated from bitrate and file size.

    Encoding: May be set by the caller before avformat_write_header() to
    provide a hint to the muxer about the estimated duration.
    """

    var nb_frames: c_long_long
    "Number of frames in this stream if known or 0."

    var disposition: c_int
    """Stream disposition - a combination of AV_DISPOSITION_* flags.
    - demuxing: set by libavformat when creating the stream or in
    avformat_find_stream_info().
    - muxing: may be set by the caller before avformat_write_header().
    """

    var discard: AVDiscard.ENUM_DTYPE
    """Selects which packets can be discarded at will and do not need to be demuxed.
    """

    var sample_aspect_ratio: AVRational
    """Sample aspect ratio (0 if unknown)
    - encoding: Set by user.
    - decoding: Set by libavformat.
    """

    var metadata: UnsafePointer[AVDictionary, MutOrigin.external]
    """Metadata
    - decoding: Set by libavformat.
    - encoding: Set by the caller before avformat_write_header().
    """

    var avg_frame_rate: AVRational
    """Average framerate
    - demuxing: May be set by libavformat when creating the stream or in
    avformat_find_stream_info().
    - muxing: May be set by the caller before avformat_write_header().
    """

    var attached_pic: AVPacket
    """For streams with AV_DISPOSITION_ATTACHED_PIC disposition, this packet
    will contain the attached picture.
    - decoding: set by libavformat, must not be modified by the caller.
    - encoding: unused."""

    var event_flags: c_int
    """Flags indicating events happening on the stream, a combination of
    AVSTREAM_EVENT_FLAG_*.
    - demuxing: may be set by the demuxer in avformat_open_input(),
    avformat_find_stream_info() and av_read_frame(). Flags must be cleared
    by the user once the event has been handled.
    - muxing: may be set by the user after avformat_write_header(). to
    indicate a user-triggered event. The muxer will clear the flags for
    events it has handled in av_[interleaved]_write_frame().
    """

    comptime AVSTREAM_EVENT_FLAG_METADATA_UPDATED = 0x0001
    """- demuxing: the demuxer read new metadata from the file and updated
    AVStream.metadata accordingly.
    - muxing: the user updated AVStream.metadata and wishes the muxer to write
    it into the file."""
    comptime AVSTREAM_EVENT_FLAG_NEW_PACKETS = 1 << 1
    """- demuxing: new packets for this stream were read from the file. This
    event is informational only and does not guarantee that new packets for this stream will necessarily be returned from av_read_frame()."""

    var r_frame_rate: AVRational
    """Real base framerate of the stream.
    This is the lowest framerate with which all timestamps can be
    represented accurately (it is the least common multiple of all
    framerates in the stream). Note, this value is just a guess!
    For example, if the time base is 1/90000 and all frames have either
    approximately 3600 or 1800 timer ticks, then r_frame_rate will be 50/1."""

    var pts_wrap_bits: c_int
    """Number of bits in timestamps. Used for wrapping control.
    - demuxing: set by libavformat
    - muxing: set by libavformat.
    """


@register_passable("trivial")
@fieldwise_init
struct _AVStreamGroupTileGrid_offsets:
    """Binding note: In the original header this is a anonymous struct.
    Mojo does not support this, so we define this as a private, name spaced
    struct outside of AVStreamGroupTileGrid.

    An @ref nb_tiles sized array of offsets in pixels from the topleft edge
    of the canvas, indicating where each stream should be placed.
    It must be allocated with the av_malloc() family of functions.

    - demuxing: set by libavformat, must not be modified by the caller.
    - muxing: set by the caller before avformat_write_header().

    Freed by libavformat in avformat_free_context().
    """

    var idx: c_uint
    """Index of the stream in the group this tile references.
    Must be < @ref AVStreamGroup.nb_streams "nb_streams".
    """
    var horizontal: c_int
    """Offset in pixels from the left edge of the canvas where the tile should be placed.
    """
    var vertical: c_int
    """Offset in pixels from the top edge of the canvas where the tile should be placed.
    """


@register_passable("trivial")
@fieldwise_init
struct AVStreamGroupTileGrid:
    """
    AVStreamGroupTileGrid holds information on how to combine several
    independent images on a single canvas for presentation.

    The output should be a @ref AVStreamGroupTileGrid.background "background"
    colored @ref AVStreamGroupTileGrid.coded_width "coded_width" x
    @ref AVStreamGroupTileGrid.coded_height "coded_height" canvas where a
    @ref AVStreamGroupTileGrid.nb_tiles "nb_tiles" amount of tiles are placed in
    the order they appear in the @ref AVStreamGroupTileGrid.offsets "offsets"
    array, at the exact offset described for them. In particular, if two or more
    tiles overlap, the image with higher index in the
    @ref AVStreamGroupTileGrid.offsets "offsets" array takes priority.
    Note that a single image may be used multiple times, i.e. multiple entries
    in @ref AVStreamGroupTileGrid.offsets "offsets" may have the same value of
    idx.

    The following is an example of a simple grid with 3 rows and 4 columns:

    +---+---+---+---+
    | 0 | 1 | 2 | 3 |
    +---+---+---+---+
    | 4 | 5 | 6 | 7 |
    +---+---+---+---+
    | 8 | 9 |10 |11 |
    +---+---+---+---+

    Assuming all tiles have a dimension of 512x512, the
    @ref AVStreamGroupTileGrid.offsets "offset" of the topleft pixel of
    the first @ref AVStreamGroup.streams "stream" in the group is "0,0", the
    @ref AVStreamGroupTileGrid.offsets "offset" of the topleft pixel of
    the second @ref AVStreamGroup.streams "stream" in the group is "512,0", the
    @ref AVStreamGroupTileGrid.offsets "offset" of the topleft pixel of
    the fifth @ref AVStreamGroup.streams "stream" in the group is "0,512", the
    @ref AVStreamGroupTileGrid.offsets "offset", of the topleft pixel of
    the sixth @ref AVStreamGroup.streams "stream" in the group is "512,512",
    etc.

    The following is an example of a canvas with overlapping tiles:

    +-----------+
    |   %%%%%   |
    |***%%3%%@@@|
    |**0%%%%%2@@|
    |***##1@@@@@|
    |   #####   |
    +-----------+

    Assuming a canvas with size 1024x1024 and all tiles with a dimension of
    512x512, a possible @ref AVStreamGroupTileGrid.offsets "offset" for the
    topleft pixel of the first @ref AVStreamGroup.streams "stream" in the group
    would be 0x256, the @ref AVStreamGroupTileGrid.offsets "offset" for the
    topleft pixel of the second @ref AVStreamGroup.streams "stream" in the group
    would be 256x512, the @ref AVStreamGroupTileGrid.offsets "offset" for the
    topleft pixel of the third @ref AVStreamGroup.streams "stream" in the group
    would be 512x256, and the @ref AVStreamGroupTileGrid.offsets "offset" for
    the topleft pixel of the fourth @ref AVStreamGroup.streams "stream" in the
    group would be 256x0.

    sizeof(AVStreamGroupTileGrid) is not a part of the ABI and may only be
    allocated by avformat_stream_group_create().
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    "A class for @ref avoptions. Set on stream creation."
    var nb_tiles: c_uint
    "Amount of tiles in the grid. Must be > 0."
    var coded_width: c_int
    "Width of the canvas. Must be > 0."
    var coded_height: c_int
    "Height of the canvas. Must be > 0."
    var offsets: UnsafePointer[
        _AVStreamGroupTileGrid_offsets, MutOrigin.external
    ]

    var background: StaticTuple[c_uchar, 4]
    """The pixel value per channel in RGBA format used if no pixel of any tile 
    is located at a particular pixel location.

    @see av_image_fill_color().
    @see av_parse_color().
    """
    var horizontal_offset: c_int
    """Offset in pixels from the left edge of the canvas where the actual image 
    meant for presentation starts.

    This field must be >= 0 and < @ref coded_width.
    """
    var vertical_offset: c_int
    """Offset in pixels from the top edge of the canvas where the actual image 
    meant for presentation starts.

    This field must be >= 0 and < @ref coded_height.
    """
    var width: c_int
    """Width of the final image for presentation.

    Must be > 0 and <= (@ref coded_width - @ref horizontal_offset).
    When it's not equal to (@ref coded_width - @ref horizontal_offset), the
    result of (@ref coded_width - width - @ref horizontal_offset) is the
    amount amount of pixels to be cropped from the right edge of the
    final image before presentation.
    """
    var height: c_int
    """Height of the final image for presentation.
    Must be > 0 and <= (@ref coded_height - @ref vertical_offset).
    When it's not equal to (@ref coded_height - @ref vertical_offset), the
    result of (@ref coded_height - height - @ref vertical_offset) is the
    amount amount of pixels to be cropped from the bottom edge of the
    final image before presentation.
    """
    var coded_side_data: UnsafePointer[AVPacketSideData, MutOrigin.external]
    """Additional data associated with the grid.

    Should be allocated with av_packet_side_data_new() or
    av_packet_side_data_add(), and will be freed by avformat_free_context().
    """
    var nb_coded_side_data: c_int
    """Amount of entries in @ref coded_side_data.
    """


@register_passable("trivial")
@fieldwise_init
struct AVStreamGroupLCEVC:
    """
    AVStreamGroupLCEVC is meant to define the relation between video streams
    and a data stream containing LCEVC enhancement layer NALUs.

    No more than one stream of @ref AVCodecParameters.codec_type "codec_type"
    AVMEDIA_TYPE_DATA shall be present, and it must be of
    @ref AVCodecParameters.codec_id "codec_id" AV_CODEC_ID_LCEVC.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    "A class for @ref avoptions. Set on stream creation."
    var lcevc_index: c_uint
    "Index of the LCEVC data stream in AVStreamGroup."
    var width: c_int
    "Width of the final stream for presentation."
    var height: c_int
    "Height of the final stream for presentation."


@register_passable("trivial")
@fieldwise_init
struct AVStreamGroupParamsType:
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


@register_passable("trivial")
@fieldwise_init
struct AVStreamGroup:
    """
    AVStreamGroup is a container for a group of streams.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    "A class for @ref avoptions. Set by avformat_stream_group_create()."
    var priv_data: OpaquePointer[MutOrigin.external]
    """Private data for use by the user.
    """
    var index: c_uint
    """Group index in AVFormatContext.
    """
    var id: c_long_long
    """Group type-specific group ID.

    - decoding: set by libavformat.
    - encoding: may set by the user.
    """
    var type: AVStreamGroupParamsType.ENUM_DTYPE
    """Group type.

    - decoding: set by libavformat on group creation.
    - encoding: set by avformat_stream_group_create().
    """
    var params: C_Union[
        UnsafePointer[AVIAMFAudioElement, MutOrigin.external],
        UnsafePointer[AVIAMFMixPresentation, MutOrigin.external],
        UnsafePointer[AVStreamGroupTileGrid, MutOrigin.external],
        UnsafePointer[AVStreamGroupLCEVC, MutOrigin.external],
    ]
    """Group type-specific parameters.
    """
    var metadata: UnsafePointer[AVDictionary, MutOrigin.external]
    """Metadata that applies to the whole group.
    - demuxing: set by libavformat on group creation.
    - muxing: may be set by the caller before avformat_write_header().
    Freed by libavformat in avformat_free_context().
    """
    var nb_streams: c_uint
    """Number of elements in AVStreamGroup.streams.
    Set by avformat_stream_group_add_stream().
    Must not be modified by any other code.
    """
    var streams: UnsafePointer[
        UnsafePointer[AVStream, MutOrigin.external], MutOrigin.external
    ]
    """A list of streams in the group. New entries are created with
    avformat_stream_group_add_stream().
    - demuxing: entries are created by libavformat on group creation.
    If AVFMTCTX_NOHEADER is set in ctx_flags, then new entries may also
    appear in av_read_frame().
    - muxing: entries are created by the user before avformat_write_header().
    Freed by libavformat in avformat_free_context().
    """
    var disposition: c_int
    """Stream group disposition - a combination of AV_DISPOSITION_* flags.
    This field currently applies to all defined AVStreamGroupParamsType.

    - demuxing: set by libavformat when creating the group or in
    avformat_find_stream_info().
    - muxing: may be set by the caller before avformat_write_header().
    """


comptime av_stream_get_parser = ExternalFunction[
    "av_stream_get_parser",
    fn (
        s: UnsafePointer[AVStream, ImmutOrigin.external],
    ) -> UnsafePointer[AVCodecParserContext, ImmutOrigin.external],
]
"""
Get the parser for the stream.
"""

comptime AV_PROGRAM_RUNNING = 1
"Program is running."


@register_passable("trivial")
@fieldwise_init
struct AVProgram:
    """
    AVProgram is a container for a program.

    New fields can be added to the end with minor version bumps.
    Removal, reordering and changes to existing fields require a major
    version bump.
    sizeof(AVProgram) must not be used outside libav*.
    """

    var id: c_int
    "Program ID."
    var flags: c_int
    "Program flags."
    var discard: AVDiscard.ENUM_DTYPE
    "Discard flag. Selects which program to discard and which to feed to the caller."
    var stream_index: UnsafePointer[c_uint, MutOrigin.external]
    var nb_stream_indexes: c_uint
    var metadata: UnsafePointer[AVDictionary, MutOrigin.external]

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
    "Reference dts for wrap detection."
    var pts_wrap_behavior: c_int
    "Behavior on wrap detection."


comptime AVFMTCTX_NOHEADER = 0x0001
"Signal that no header is present (streams are added dynamically)."
comptime AVFMTCTX_UNSEEKABLE = 0x0002
"""Signal that the stream is definitely not seekable, and attempts to call the
seek function will fail. For some network protocols (e.g. HLS), this can
change dynamically at runtime."""


@register_passable("trivial")
@fieldwise_init
struct AVChapter:
    var id: c_long_long
    "Unique ID to identify the chapter."
    var time_base: AVRational
    "Time base in which the start/end timestamps are specified."
    var start: c_long_long
    "Chapter start time in time_base units."
    var end: c_long_long
    "Chapter end time in time_base units."
    var metadata: UnsafePointer[AVDictionary, MutOrigin.external]


comptime av_format_control_message = ExternalFunction[
    "av_format_control_message",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        type: c_int,
        data: OpaquePointer[MutOrigin.external],
        data_size: c_size_t,
    ) -> c_int,
]
"""
Callback used by devices to communicate with application.
"""

comptime AVOpenCallback = fn (
    s: UnsafePointer[AVFormatContext, MutOrigin.external],
    pb: UnsafePointer[
        UnsafePointer[AVIOContext, MutOrigin.external], MutOrigin.external
    ],
    url: UnsafePointer[c_char, ImmutOrigin.external],
    flags: c_int,
    int_cb: UnsafePointer[AVIOInterruptCB, ImmutOrigin.external],
    options: UnsafePointer[
        UnsafePointer[AVDictionary, MutOrigin.external], MutOrigin.external
    ],
) -> c_int


@register_passable("trivial")
@fieldwise_init
struct AVDurationEstimationMethod:
    """The duration of a video can be estimated through various ways, and this
    enum can be used to know how the duration was estimated.
    """

    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AVFMT_DURATION_FROM_PTS = Self(0)
    """Duration accurately estimated from PTSes."""
    comptime AVFMT_DURATION_FROM_STREAM = Self(1)
    """Duration estimated from a stream with a known duration."""
    comptime AVFMT_DURATION_FROM_BITRATE = Self(2)
    """Duration estimated from bitrate (less accurate)."""


# @register_passable("trivial")
@fieldwise_init
struct AVFormatContext:
    """Format I/O context.
    New fields can be added to the end with minor version bumps.
    Removal, reordering and changes to existing fields require a major
    version bump.
    sizeof(AVFormatContext) must not be used outside libav*,
    use avformat_alloc_context() to create an AVFormatContext.

    Fields can be accessed through AVOptions (av_opt*),
    the name string used matches the associated command line parameter name and
    can be found in libavformat/options_table.h.
    The AVOption/command line parameter names differ in some cases from the C
    structure field names for historic reasons or brevity.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    """A class for logging and @ref avoptions. Set by avformat_alloc_context(). 
    Exports (de)muxer private options if they exist."""
    var iformat: UnsafePointer[AVInputFormat, ImmutOrigin.external]
    """The input container format.
    Demuxing only, set by avformat_open_input().
    """
    var oformat: UnsafePointer[AVOutputFormat, ImmutOrigin.external]
    """The output container format.
    Muxing only, must be set by the caller before avformat_write_header().
    """
    var priv_data: OpaquePointer[MutOrigin.external]
    """Format private data. This is an AVOptions-enabled struct
    if and only if iformat/oformat.priv_class is not NULL.
    - muxing: set by avformat_write_header()
    - demuxing: set by avformat_open_input().
    """
    var pb: UnsafePointer[AVIOContext, MutOrigin.external]
    """I/O context.

    - demuxing: either set by the user before avformat_open_input() (then
    the user must close it manually) or set by avformat_open_input().
    - muxing: set by the user before avformat_write_header(). The caller must
    take care of closing / freeing the IO context.

    Do NOT set this field if AVFMT_NOFILE flag is set in
    iformat/oformat.flags. In such a case, the (de)muxer will handle
    I/O in some other way and this field will be NULL.
    """
    # Stream info
    var ctx_flags: c_int
    """Flags signalling stream properties. A combination of AVFMTCTX_*.
    Set by libavformat."""
    var nb_streams: c_uint
    """Number of elements in AVFormatContext.streams.

    Set by avformat_new_stream(), must not be modified by any other code.
    """
    var streams: UnsafePointer[
        UnsafePointer[AVStream, MutOrigin.external], MutOrigin.external
    ]
    """A list of all streams in the file. New streams are created with
    avformat_new_stream().

    - demuxing: streams are created by libavformat in avformat_open_input().
    If AVFMTCTX_NOHEADER is set in ctx_flags, then new streams may also
    appear in av_read_frame().
    - muxing: streams are created by the user before avformat_write_header().

    Freed by libavformat in avformat_free_context().
    """
    var nb_stream_groups: c_uint
    """Number of elements in AVFormatContext.stream_groups.
    Set by avformat_stream_group_create(), must not be modified by any other code.
    """
    var stream_groups: UnsafePointer[
        UnsafePointer[AVStreamGroup, MutOrigin.external], MutOrigin.external
    ]
    """A list of all stream groups in the file. New groups are created with
    avformat_stream_group_create().

    - demuxing: groups are created by libavformat in avformat_open_input().
    If AVFMTCTX_NOHEADER is set in ctx_flags, then new groups may also
    appear in av_read_frame().
    - muxing: groups are created by the user before avformat_write_header().

    Freed by libavformat in avformat_free_context().
    """
    var nb_chapters: c_uint
    """Number of elements in AVFormatContext.chapters.
    Set by avformat_new_chapter(), must not be modified by any other code.

    When muxing, chapters are normally written in the file header,
    so nb_chapters should normally be initialized before write_header
    is called. Some muxers (e.g. mov and mkv) can also write chapters
    in the trailer.  To write chapters in the trailer, nb_chapters
    must be zero when write_header is called and non-zero when
    write_trailer is called.

    - muxing: set by user
    - demuxing: set by libavformat
    """
    var chapters: UnsafePointer[
        UnsafePointer[AVChapter, MutOrigin.external], MutOrigin.external
    ]

    var url: UnsafePointer[c_char, MutOrigin.external]
    """Input or output URL. Unlike the old filename field, this field has no
    length restriction.

    - demuxing: set by avformat_open_input(), initialized to an empty
    string if url parameter was NULL in avformat_open_input().
    - muxing: may be set by the caller before calling avformat_write_header()
    (or avformat_init_output() if that is called first) to a string
    which is freeable by av_free(). Set to an empty string if it
    was NULL in avformat_init_output().

    Freed by libavformat in avformat_free_context().
    """
    var start_time: c_long_long
    """Position of the first frame of the component, in
    AV_TIME_BASE fractional seconds. NEVER set this value directly:
    It is deduced from the AVStream values.

    Demuxing only, set by libavformat."""
    var duration: c_long_long
    """Duration of the stream, in AV_TIME_BASE fractional
    seconds. Only set this value if you know none of the individual stream
    durations and also do not set any of them. This is deduced from the
    AVStream values if not set.

    Demuxing only, set by libavformat."""

    var bit_rate: c_long_long
    """Total stream bitrate in bit/s, 0 if not
    available. Never set it directly if the file_size and the
    duration are known as FFmpeg can compute it automatically.
    Demuxing only, set by libavformat."""
    var packet_size: c_uint
    var max_delay: c_int

    var flags: c_int
    """Flags modifying the (de)muxer behaviour. A combination of AVFMT_FLAG_*.
    Set by the user before avformat_open_input() / avformat_write_header().
    """
    comptime AVFMT_FLAG_GENPTS = 0x0001
    """Generate missing pts even if it requires parsing future frames."""
    comptime AVFMT_FLAG_IGNIDX = 0x0002
    """Ignore index."""
    comptime AVFMT_FLAG_NONBLOCK = 0x0004
    """Do not block when reading packets from input."""
    comptime AVFMT_FLAG_IGNDTS = 0x0008
    """Ignore DTS on frames that contain both DTS & PTS."""
    comptime AVFMT_FLAG_NOFILLIN = 0x0010
    """Do not infer any values from other values, just return what is stored 
    in the container."""
    comptime AVFMT_FLAG_NOPARSE = 0x0020
    """Do not use AVParsers, you also must set AVFMT_FLAG_NOFILLIN as the 
    filling code works on frames and no parsing -> no frames. Also seeking to 
    frames can not work if parsing to find frame boundaries has been disabled."""
    comptime AVFMT_FLAG_NOBUFFER = 0x0040
    """Do not buffer frames when possible."""
    comptime AVFMT_FLAG_CUSTOM_IO = 0x0080
    """The caller has supplied a custom AVIOContext, don't avio_close() it."""
    comptime AVFMT_FLAG_DISCARD_CORRUPT = 0x0100
    """Discard frames marked corrupted."""
    comptime AVFMT_FLAG_FLUSH_PACKETS = 0x0200
    """Flush the AVIOContext every packet."""

    comptime AVFMT_FLAG_BITEXACT = 0x0400
    """When muxing, try to avoid writing any random/volatile data to the output.
    This includes any random IDs, real-time timestamps/dates, muxer version, etc.
    This flag is mainly intended for testing."""
    comptime AVFMT_FLAG_SORT_DTS = 0x10000
    """Try to interleave outputted packets by dts (using this flag can slow 
    demuxing down)."""
    comptime AVFMT_FLAG_FAST_SEEK = 0x80000
    """Enable fast, but inaccurate seeks for some formats."""
    comptime AVFMT_FLAG_AUTO_BSF = 0x200000
    """Add bitstream filters as requested by the muxer."""

    var probesize: c_long_long
    """Maximum number of bytes read from input in order to determine stream
    properties. Used when reading the global header and in
    avformat_find_stream_info().

    Demuxing only, set by the caller before avformat_open_input().

    @note this is not  used for determining the \ref AVInputFormat
    "input format"
    @see format_probesize
    """
    var max_analyze_duration: c_long_long
    """Maximum duration (in AV_TIME_BASE units) of the data read
    from input in avformat_find_stream_info().
    Demuxing only, set by the caller before avformat_find_stream_info().
    Can be set to 0 to let avformat choose using a heuristic."""

    var key: UnsafePointer[c_uchar, ImmutOrigin.external]
    var keylen: c_int

    var nb_programs: c_uint
    var programs: UnsafePointer[
        UnsafePointer[AVProgram, MutOrigin.external], MutOrigin.external
    ]

    var video_codec_id: AVCodecID.ENUM_DTYPE
    """Forced video code_id.
    Demuxing: Set by user."""
    var audio_codec_id: AVCodecID.ENUM_DTYPE
    """Forced audio code_id.
    Demuxing: Set by user."""
    var subtitle_codec_id: AVCodecID.ENUM_DTYPE
    """Forced subtitle code_id.
    Demuxing: Set by user."""
    var data_codec_id: AVCodecID.ENUM_DTYPE
    """Forced data code_id.
    Demuxing: Set by user."""
    var metadata: UnsafePointer[AVDictionary, MutOrigin.external]
    """Metadata that applies to the whole file.
    - demuxing: set by libavformat in avformat_open_input()
    - muxing: may be set by the caller before avformat_write_header()
    Freed by libavformat in avformat_free_context().
    """
    var start_time_realtime: c_long_long
    """Start time of the stream in real world time, in microseconds
    since the Unix epoch (00:00 1st January 1970). That is, pts=0 in the
    stream was captured at this real world time.
    - muxing: Set by the caller before avformat_write_header(). If set to
    either 0 or AV_NOPTS_VALUE, then the current wall-time will be used.
    - demuxing: Set by libavformat. AV_NOPTS_VALUE if unknown. Note that
    the value may become known after some number of frames have been received."""

    var fps_probe_size: c_int
    """The number of frames used for determining the framerate in
    avformat_find_stream_info().
    Demuxing only, set by the caller before avformat_find_stream_info()."""
    var error_recognition: c_int
    """Error recognition; higher values will detect more errors but may
    misdetect some more or less valid parts as errors.
    Demuxing only, set by the caller before avformat_open_input()."""

    var interrupt_callback: AVIOInterruptCB
    """Custom interrupt callbacks for the I/O layer.
    demuxing: set by the user before avformat_open_input().
    muxing: set by the user before avformat_write_header()
    (mainly useful for AVFMT_NOFILE formats). The callback
    should also be passed to avio_open2() if it's used to
    open the file.
    """
    var debug: c_int
    """Flags to enable debugging.
    """
    comptime FF_FDEBUG_TS = 0x0001

    var max_streams: c_int
    """Maximum number of streams.
    - encoding: unused
    - decoding: set by user.
    """
    var max_index_size: c_uint
    """Maximum amount of memory in bytes to use for the index of each stream.
    If the index exceeds this size, entries will be discarded as
    needed to maintain a smaller size. This can lead to slower or less
    accurate seeking (depends on demuxer).
    Demuxers for which a full in-memory index is mandatory will ignore
    this.
    - muxing: unused
    - demuxing: set by user.
    """
    var max_picture_buffer: c_uint
    """Maximum amount of memory in bytes to use for buffering frames
    obtained from realtime capture devices.
    """
    var max_interleave_delta: c_long_long
    """Maximum buffering duration for interleaving.

    To ensure all the streams are interleaved correctly,
    av_interleaved_write_frame() will wait until it has at least one packet
    for each stream before actually writing any packets to the output file.
    When some streams are "sparse" (i.e. there are large gaps between
    successive packets), this can result in excessive buffering.

    This field specifies the maximum difference between the timestamps of the
    first and the last packet in the muxing queue, above which libavformat
    will output a packet regardless of whether it has queued a packet for all
    the streams.

    Muxing only, set by the caller before avformat_write_header()."""

    var max_ts_probe: c_int
    """Maximum number of packets to read while waiting for the first timestamp.
    Decoding only.
    """
    var max_chunk_duration: c_int
    """Max chunk time in microseconds.
    Note, not all formats support this and unpredictable things may happen if it is used when not supported.
    - encoding: Set by user
    - decoding: unused.
    """
    var max_chunk_size: c_int
    """Max chunk size in bytes
    Note, not all formats support this and unpredictable things may happen if it is used when not supported.
    - encoding: Set by user
    - decoding: unused.
    """
    var max_probe_packets: c_int
    """Maximum number of packets that can be probed
    - encoding: unused
    - decoding: set by user.
    """
    var strict_std_compliance: c_int
    """Allow non-standard and experimental extension
    @see AVCodecContext.strict_std_compliance."""

    var event_flags: c_int
    """Flags indicating events happening on the file, a combination of
    AVFMT_EVENT_FLAG_*.

    - demuxing: may be set by the demuxer in avformat_open_input(),
    avformat_find_stream_info() and av_read_frame(). Flags must be cleared
    by the user once the event has been handled.
    - muxing: may be set by the user after avformat_write_header(). to
    indicate a user-triggered event. The muxer will clear the flags for
    events it has handled in av_[interleaved]_write_frame()."""

    comptime AVFMT_EVENT_FLAG_METADATA_UPDATED = 0x0001
    """- demuxing: the demuxer read new metadata from the file and updated
    AVFormatContext.metadata accordingly.
    - muxing: the user updated AVFormatContext.metadata and wishes the muxer to write
    it into the file."""

    var avoid_negative_ts: c_int
    """Avoid negative timestamps during muxing.
    Any value of the AVFMT_AVOID_NEG_TS_* constants.
    Note, this works better when using av_interleaved_write_frame().
    - muxing: Set by user
    - demuxing: unused."""

    comptime AVFMT_AVOID_NEG_TS_AUTO = -1
    """Enabled when required by target format."""
    comptime AVFMT_AVOID_NEG_TS_DISABLED = 0
    """Do not shift timestamps even when they are negative."""
    comptime AVFMT_AVOID_NEG_TS_MAKE_NON_NEGATIVE = 1
    """Shift timestamps so they are non negative."""
    comptime AVFMT_AVOID_NEG_TS_MAKE_ZERO = 2
    """Shift timestamps so they start at 0."""

    var audio_preload: c_int
    """Audio preload in microseconds.
    Note, not all formats support this and unpredictable things may happen if it is used when not supported.
    - encoding: Set by user
    - decoding: unused."""
    var use_wallclock_as_timestamps: c_int
    """Forces the use of wallclock timestamps as pts/dts of packets
    This has undefined results in the presence of B frames.
    - encoding: unused
    - decoding: Set by user."""
    var skip_estimate_duration_from_pts: c_int
    """Skip duration calculation in estimate_timings_from_pts.
    - encoding: unused
    - decoding: set by user
    @see duration_probesize."""
    var avio_flags: c_int
    """Avio flags, used to force AVIO_FLAG_DIRECT.
    - encoding: unused
    - decoding: Set by user."""
    var duration_estimation_method: AVDurationEstimationMethod.ENUM_DTYPE
    """The duration of a video can be estimated through various ways, and this field can be used
    to know how the duration was estimated.
    - encoding: unused
    - decoding: Read by user."""
    var skip_initial_bytes: c_long_long
    """Skip initial bytes when opening stream
    - encoding: unused
    - decoding: Set by user."""
    var correct_ts_overflow: c_uint
    """Correct single timestamp overflows
    - encoding: unused
    - decoding: Set by user."""
    var seek2any: c_int
    """Force seeking to any (also non key) frames.
    - encoding: unused
    - decoding: Set by user."""
    var flush_packets: c_int
    """Flush the I/O context after each packet.
    - encoding: Set by user
    - decoding: unused."""

    var probe_score: c_int
    """Format probing score.
    The maximal score is AVPROBE_SCORE_MAX, its set when the demuxer probes
    the format.
    - encoding: unused
    - decoding: set by avformat, read by user."""
    var format_probesize: c_int
    """Maximum number of bytes read from input in order to identify the
    AVInputFormat "input format". Only used when the format is not set
    explicitly by the caller.

    Demuxing only, set by the caller before avformat_open_input().
    @see probesize."""

    var codec_whitelist: UnsafePointer[c_char, MutOrigin.external]
    """',' separated list of allowed decoders.
    If NULL then all are allowed
    - encoding: unused
    - decoding: set by user."""
    var format_whitelist: UnsafePointer[c_char, MutOrigin.external]
    """',' separated list of allowed demuxers.
    If NULL then all are allowed
    - encoding: unused
    - decoding: set by user."""
    var protocol_whitelist: UnsafePointer[c_char, MutOrigin.external]
    """',' separated list of allowed protocols.
    - encoding: unused
    - decoding: set by user."""
    var protocol_blacklist: UnsafePointer[c_char, MutOrigin.external]
    """',' separated list of disallowed protocols.
    - encoding: unused
    - decoding: set by user."""
    var io_repositioned: c_int
    """IO repositioned flag.
    This is set by avformat when the underlying IO context read pointer
    is repositioned, for example when doing byte based seeking.
    Demuxers can use the flag to detect such changes."""
    var video_codec: UnsafePointer[AVCodec, ImmutOrigin.external]
    """Forced video codec.
    This allows forcing a specific decoder, even when there are multiple with
    the same codec_id.
    Demuxing: Set by user."""
    var audio_codec: UnsafePointer[AVCodec, ImmutOrigin.external]
    """Forced audio codec.
    This allows forcing a specific decoder, even when there are multiple with
    the same codec_id.
    Demuxing: Set by user."""
    var subtitle_codec: UnsafePointer[AVCodec, ImmutOrigin.external]
    """Forced subtitle codec.
    This allows forcing a specific decoder, even when there are multiple with
    the same codec_id.
    Demuxing: Set by user."""
    var data_codec: UnsafePointer[AVCodec, ImmutOrigin.external]
    """Forced data codec.
    This allows forcing a specific decoder, even when there are multiple with
    the same codec_id.
    Demuxing: Set by user."""
    var metadata_header_padding: c_int
    """Number of bytes to be written as padding in a metadata header.
    Demuxing: Unused.
    Muxing: Set by user."""
    var opaque: OpaquePointer[MutOrigin.external]
    """User data.
    This is a place for some private data of the user."""

    # TODO: should these be pointers? How does this impact struct size?
    # For some reason I can't define this under: av_format_control_message
    # var control_message_cb: type_of(av_format_control_message)
    var control_message_cb: fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        type: c_int,
        data: OpaquePointer[MutOrigin.external],
        data_size: c_size_t,
    ) -> c_int
    """Callback for control messages."""
    var output_ts_offset: c_long_long
    """Output timestamp offset, in microseconds.
    Muxing: set by user."""
    var dump_separator: UnsafePointer[c_uchar, MutOrigin.external]
    """Dump format separator.
    can be ", " or "\n      " or anything else
    - muxing: Set by user.
    - demuxing: Set by user.
    """
    var io_open: fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        pb: UnsafePointer[
            UnsafePointer[AVIOContext, MutOrigin.external], MutOrigin.external
        ],
        url: UnsafePointer[c_char, ImmutOrigin.external],
        flags: c_int,
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutOrigin.external], MutOrigin.external
        ],
    ) -> c_int
    """Callback for opening new IO streams.

    Whenever a muxer or a demuxer needs to open an IO stream (typically from
    avformat_open_input() for demuxers, but for certain formats can happen at
    other times as well), it will call this callback to obtain an IO context.

    Arguments:
    - s: the format context
    - pb: on success, the newly opened IO context should be returned here
    - url: the url to open
    - flags: a combination of AVIO_FLAG_*
    - options: a dictionary of additional options, with the same
    semantics as in avio_open2()
    - return: 0 on success, a negative AVERROR code on failure

    Note: Certain muxers and demuxers do nesting, i.e. they open one or more
    additional internal format contexts. Thus the AVFormatContext pointer
    passed to this callback may be different from the one facing the caller.
    It will, however, have the same 'opaque' field.
    """
    var io_close2: fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        pb: UnsafePointer[AVIOContext, MutOrigin.external],
    ) -> c_int
    """Callback for closing the streams opened with AVFormatContext.io_open().
    Arguments:
    - s: the format context
    - pb: the IO context to close
    - return: 0 on success, a negative AVERROR code on failure.
    """

    var duration_probesize: c_long_long
    """Maximum number of bytes read from input in order to determine stream durations
    when using estimate_timings_from_pts in avformat_find_stream_info().
    Demuxing only, set by the caller before avformat_find_stream_info().
    Can be set to 0 to let avformat choose using a heuristic.
    @see skip_estimate_duration_from_pts."""


comptime avformat_version = ExternalFunction[
    "avformat_version",
    fn () -> c_int,
]
"""Return the LIBAVFORMAT_VERSION_INT constant."""

comptime avformat_configuration = ExternalFunction[
    "avformat_configuration",
    fn () -> UnsafePointer[c_char, ImmutOrigin.external],
]
"""Return the libavformat build-time configuration."""

comptime avformat_license = ExternalFunction[
    "avformat_license",
    fn () -> UnsafePointer[c_char, ImmutOrigin.external],
]
"""Return the libavformat license."""

comptime avformat_network_init = ExternalFunction[
    "avformat_network_init",
    fn () -> c_int,
]
"""Do global initialization of network libraries. This is optional,
and not recommended anymore.

This functions only exists to work around thread-safety issues
with older GnuTLS or OpenSSL libraries. If libavformat is linked
to newer versions of those libraries, or if you do not use them,
calling this function is unnecessary. Otherwise, you need to call
this function before any other threads using them are started.

This function will be deprecated once support for older GnuTLS and
OpenSSL libraries is removed, and this function has no purpose
anymore.
"""

comptime avformat_network_deinit = ExternalFunction[
    "avformat_network_deinit",
    fn () -> c_int,
]
"""Undo the initialization done by avformat_network_init. Call it only
once for each time you called avformat_network_init."""

comptime av_muxer_iterate = ExternalFunction[
    "av_muxer_iterate",
    fn (
        opaque: UnsafePointer[
            OpaquePointer[MutOrigin.external], MutOrigin.external
        ],
    ) -> UnsafePointer[AVOutputFormat, ImmutOrigin.external],
]
"""Iterate over all registered muxers.
Arguments:
- opaque: a pointer where libavformat will store the iteration state. Must
point to NULL to start the iteration.
- return: the next registered muxer or NULL when the iteration is finished.

Returns:
- the next registered muxer or NULL when the iteration is finished.
"""

comptime av_demuxer_iterate = ExternalFunction[
    "av_demuxer_iterate",
    fn (
        opaque: UnsafePointer[
            OpaquePointer[MutOrigin.external], MutOrigin.external
        ],
    ) -> UnsafePointer[AVInputFormat, ImmutOrigin.external],
]
"""Iterate over all registered demuxers.
Arguments:
- opaque: a pointer where libavformat will store the iteration state. Must
point to NULL to start the iteration.

Returns:
- the next registered demuxer or NULL when the iteration is finished.
"""


comptime avformat_alloc_context = ExternalFunction[
    "avformat_alloc_context",
    fn () -> UnsafePointer[AVFormatContext, MutOrigin.external],
]
"""Allocate an AVFormatContext.
avformat_free_context() can be used to free the context and everything
allocated by the framework within it.
"""

comptime avformat_free_context = ExternalFunction[
    "avformat_free_context",
    fn (s: UnsafePointer[AVFormatContext, MutOrigin.external],),
]
"""Free an AVFormatContext and all its streams.
@param s context to free.
"""

comptime avformat_get_class = ExternalFunction[
    "avformat_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]
"""Get the AVClass for AVFormatContext. It can be used in combination with
AV_OPT_SEARCH_FAKE_OBJ for examining options.
@see av_opt_find().
"""

comptime av_stream_get_class = ExternalFunction[
    "av_stream_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]
"""Get the AVClass for AVStream. It can be used in combination with
AV_OPT_SEARCH_FAKE_OBJ for examining options.
@see av_opt_find().
"""

comptime av_stream_group_get_class = ExternalFunction[
    "av_stream_group_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]
"""Get the AVClass for AVStreamGroup. It can be used in combination with
AV_OPT_SEARCH_FAKE_OBJ for examining options.
@see av_opt_find().
"""

comptime avformat_stream_group_name = ExternalFunction[
    "avformat_stream_group_name",
    fn (
        type: AVStreamGroupParamsType.ENUM_DTYPE,
    ) -> UnsafePointer[c_char, ImmutOrigin.external],
]
"""Return a string identifying the stream group type, or NULL if unknown
@param type the stream group type
@return a string identifying the stream group type, or NULL if unknown.
"""

comptime avformat_stream_group_create = ExternalFunction[
    "avformat_stream_group_create",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        type: AVStreamGroupParamsType.ENUM_DTYPE,
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutOrigin.external], MutOrigin.external
        ],
    ) -> UnsafePointer[AVStreamGroup, MutOrigin.external],
]
"""Create a new empty stream group.

When demuxing, it may be called by the demuxer in read_header(). If the
flag AVFMTCTX_NOHEADER is set in s.ctx_flags, then it may also
be called in read_packet().

When muxing, may be called by the user before avformat_write_header().

User is required to call avformat_free_context() to clean up the allocation
by avformat_stream_group_create().

New streams can be added to the group with avformat_stream_group_add_stream().

@param s media file handle
@param type the stream group type
@param options additional options
@return the newly created stream group or NULL on error.
"""

comptime avformat_new_stream = ExternalFunction[
    "avformat_new_stream",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        c: UnsafePointer[AVCodec, ImmutOrigin.external],
    ) -> UnsafePointer[AVStream, MutOrigin.external],
]
"""Add a new stream to a media file.

When demuxing, it is called by the demuxer in read_header(). If the
flag AVFMTCTX_NOHEADER is set in s.ctx_flags, then it may also
be called in read_packet().

When muxing, should be called by the user before avformat_write_header().

User is required to call avformat_free_context() to clean up the allocation
by avformat_new_stream().

@param s media file handle
@param c codec to use for the stream
@return the newly created stream or NULL on error.
"""

comptime avformat_stream_group_add_stream = ExternalFunction[
    "avformat_stream_group_add_stream",
    fn (
        stg: UnsafePointer[AVStreamGroup, MutOrigin.external],
        st: UnsafePointer[AVStream, MutOrigin.external],
    ) -> c_int,
]
"""Add an already allocated stream to a stream group.

When demuxing, it may be called by the demuxer in read_header(). If the
flag AVFMTCTX_NOHEADER is set in s.ctx_flags, then it may also
be called in read_packet().

When muxing, may be called by the user before avformat_write_header() after
having allocated a new group with avformat_stream_group_create() and stream with
avformat_new_stream().

User is required to call avformat_free_context() to clean up the allocation
by avformat_stream_group_add_stream().

@param stg stream group belonging to a media file.
@param st stream in the media file to add to the group.

@retval 0                 success
@retval AVERROR(EEXIST)   the stream was already in the group
@retval "another negative error code" legitimate errors

@see avformat_new_stream, avformat_stream_group_create.
@return 0 on success, a negative AVERROR code on failure.
"""

comptime av_new_program = ExternalFunction[
    "av_new_program",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        id: c_int,
    ) -> UnsafePointer[AVProgram, MutOrigin.external],
]

comptime avformat_alloc_output_context2 = ExternalFunction[
    "avformat_alloc_output_context2",
    fn (
        ctx: UnsafePointer[
            UnsafePointer[AVFormatContext, MutOrigin.external],
            MutAnyOrigin,
        ],
        oformat: UnsafePointer[AVOutputFormat, ImmutOrigin.external],
        format_name: UnsafePointer[c_char, ImmutOrigin.external],
        filename: UnsafePointer[c_char, ImmutAnyOrigin],
    ) -> c_int,
]
"""Allocate an AVFormatContext for an output format.
avformat_free_context() can be used to free the context and everything
allocated by the framework within it.

Args:
    ctx: Pointee is set to the created format context, or to NULL in case of failure.
    oformat: format to use for allocating the context, if NULL format_name and filename are used instead.
    format_name: the name of output format to use for allocating the context, if NULL filename is used instead.
    filename: The name of the filename to use for allocating the context, may be NULL.

Returns: 
    >= 0 in case of success, a negative AVERROR code in case of failure.
"""

comptime av_find_input_format = ExternalFunction[
    "av_find_input_format",
    fn (
        short_name: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> UnsafePointer[AVInputFormat, ImmutOrigin.external],
]
"""Find AVInputFormat based on the short name of the input format.
@param short_name the short name of the input format
@return the AVInputFormat.
"""

comptime av_probe_input_format = ExternalFunction[
    "av_probe_input_format",
    fn (
        pd: UnsafePointer[AVProbeData, ImmutOrigin.external],
        is_opened: c_int,
    ) -> UnsafePointer[AVInputFormat, ImmutOrigin.external],
]
"""Probe the format of a given file.
@param pd data to be probed
@param is_opened whether the file is already opened
@return the AVInputFormat.
"""

comptime av_probe_input_format2 = ExternalFunction[
    "av_probe_input_format2",
    fn (
        pd: UnsafePointer[AVProbeData, ImmutOrigin.external],
        is_opened: c_int,
        score_max: UnsafePointer[c_int, MutOrigin.external],
    ) -> UnsafePointer[AVInputFormat, ImmutOrigin.external],
]
"""Probe the format of a given file.
@param pd data to be probed
@param is_opened whether the file is already opened
@param score_max the maximum score to return
@return the AVInputFormat.
"""

comptime av_probe_input_format3 = ExternalFunction[
    "av_probe_input_format3",
    fn (
        pd: UnsafePointer[AVProbeData, ImmutOrigin.external],
        is_opened: c_int,
        score_ret: UnsafePointer[c_int, MutOrigin.external],
    ) -> UnsafePointer[AVInputFormat, ImmutOrigin.external],
]
"""Guess the format of a given file.
Arguments:
- pd: data to be probed
- is_opened: whether the file is already opened
- score_ret: the score of the best detection
- return: the AVInputFormat.
"""

comptime av_probe_input_buffer2 = ExternalFunction[
    "av_probe_input_buffer2",
    fn (
        pb: UnsafePointer[AVIOContext, MutOrigin.external],
        fmt: UnsafePointer[
            UnsafePointer[AVInputFormat, ImmutOrigin.external],
            ImmutOrigin.external,
        ],
        url: UnsafePointer[c_char, ImmutOrigin.external],
        logctx: OpaquePointer[MutOrigin.external],
        offset: c_uint,
        max_probe_size: c_uint,
    ) -> c_int,
]
"""Probe the bytestream to determine the input format.

Each time a probe returns with a score that is too low, the probe buffer size is increased and another
attempt is made. When the maximum probe size is reached, the input format with the highest score is returned.

Arguments:
    pb: the bytestream to probe
    fmt: the input format is put here
    url: the url of the stream
    logctx: the log context
    offset: the offset within the bytestream to probe from
    max_probe_size: the maximum probe buffer size (zero for default)

Returns:
    the score in case of success, a negative value corresponding to an
    the maximal score is AVPROBE_SCORE_MAX
    AVERROR code otherwise.
"""

comptime av_probe_input_buffer = ExternalFunction[
    "av_probe_input_buffer",
    fn (
        pb: UnsafePointer[AVIOContext, MutOrigin.external],
        fmt: UnsafePointer[
            UnsafePointer[AVInputFormat, ImmutOrigin.external],
            ImmutOrigin.external,
        ],
        url: UnsafePointer[c_char, ImmutOrigin.external],
        logctx: OpaquePointer[MutOrigin.external],
        offset: c_uint,
        max_probe_size: c_uint,
    ) -> c_int,
]
"""Like av_probe_input_buffer2() but returns 0 on success."""


comptime avformat_open_input = ExternalFunction[
    "avformat_open_input",
    fn (
        s: UnsafePointer[
            UnsafePointer[AVFormatContext, MutOrigin.external],
            MutOrigin.external,
        ],
        url: UnsafePointer[c_char, ImmutOrigin.external],
        fmt: UnsafePointer[AVInputFormat, ImmutOrigin.external],
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutOrigin.external], MutOrigin.external
        ],
    ) -> c_int,
]
"""Open an input stream and read the header. The codecs are not opened.

The stream must be closed with avformat_close_input().

Arguments:
- s: pointer to user-supplied AVFormatContext (allocated by avformat_alloc_context()). 
May be a pointer to NULL, in which case an AVFormatContext is allocated by this 
function and written into s. Note that a user-supplied AVFormatContext will 
be freed on failure and its pointer set to NULL.
- url: URL of the stream to open.
- fmt: if non-NULL, this parameter forces a specific input format. Otherwise 
the format is autodetected.
- options: a dictionary filled with AVFormatContext and demuxer-private options. 
On return this parameter will be destroyed and replaced with a dict containing 
options that were not found. May be NULL.

Returns:
- 0 on success, a negative AVERROR code on failure.
"""

comptime avformat_find_stream_info = ExternalFunction[
    "avformat_find_stream_info",
    fn (
        ic: UnsafePointer[AVFormatContext, MutOrigin.external],
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutOrigin.external], MutOrigin.external
        ],
    ) -> c_int,
]
"""Read packets of a media file to get stream information. This is useful for 
file formats with no headers such as MPEG. This function also computes the real 
framerate in case of MPEG-2 repeat frame mode.
The logical file position is not changed by this function; examined packets may be buffered for later processing.

Arguments:
- ic: media file handle
- options: if non-NULL, an ic.nb_streams long array of pointers to dictionaries,
 where i-th member contains options for codec corresponding to i-th stream. 

Returns:
- >=0 if OK, AVERROR_xxx on error

Note: this function isn't guaranteed to open all the codecs, so options being 
non-empty at return is a perfectly normal behavior.

Todo: Let the user decide somehow what information is needed so that we do not 
waste time getting stuff the user does not need.
"""

comptime av_find_program_from_stream = ExternalFunction[
    "av_find_program_from_stream",
    fn (
        ic: UnsafePointer[AVFormatContext, MutOrigin.external],
        last: UnsafePointer[AVProgram, MutOrigin.external],
        s: c_int,
    ) -> UnsafePointer[AVProgram, MutOrigin.external],
]
"""Find the programs which belong to a given stream.

Arguments:
- ic: media file handle
- last: the last found program, the search will start after this program, or 
from the beginning if it is NULL
- s: stream index

Returns:
- the next program which belongs to s, NULL if no program is found or the last 
program is not among the programs of ic.
"""

comptime av_program_add_stream_index = ExternalFunction[
    "av_program_add_stream_index",
    fn (
        ac: UnsafePointer[AVFormatContext, MutOrigin.external],
        progid: c_int,
        idx: c_uint,
    ),
]

comptime av_find_best_stream = ExternalFunction[
    "av_find_best_stream",
    fn (
        ic: UnsafePointer[AVFormatContext, MutOrigin.external],
        type: AVMediaType.ENUM_DTYPE,
        wanted_stream_nb: c_int,
        related_stream: c_int,
        decoder_ret: UnsafePointer[
            UnsafePointer[AVCodec, ImmutOrigin.external], ImmutOrigin.external
        ],
        flags: c_int,
    ) -> c_int,
]
"""Find the "best" stream in the file.

The best stream is determined according to various heuristics as the most
likely to be what the user expects.

If the decoder parameter is non-NULL, av_find_best_stream will find the
default decoder for the stream's codec; streams for which no decoder can
be found are ignored.

Arguments:
- ic: media file handle
- type: stream type: video, audio, subtitles, etc.
- wanted_stream_nb: user-requested stream number, or -1 for automatic selection
- related_stream: try to find a stream related (eg. in the same program) to this
 one, or -1 if none
- decoder_ret: if non-NULL, returns the decoder for the selected stream
- flags: flags; none are currently defined
- return: the non-negative stream number in case of success, 
AVERROR_STREAM_NOT_FOUND if no stream with the requested type could be found, 
AVERROR_DECODER_NOT_FOUND if streams were found but no decoder

Note: If av_find_best_stream returns successfully and decoder_ret is not NULL, 
then *decoder_ret is guaranteed to be set to a valid AVCodec.
"""

comptime av_read_frame = ExternalFunction[
    "av_read_frame",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
    ) -> c_int,
]
"""Return the next frame of a stream.

This function returns what is stored in the file, and does not validate
that what is there are valid frames for the decoder. It will split what is
stored in the file into frames and return one for each call. It will not
omit invalid data between valid frames so as to give the decoder the maximum
information possible for decoding.

On success, the returned packet is reference-counted (pkt->buf is set) and
valid indefinitely. The packet must be freed with av_packet_unref() when
it is no longer needed. For video, the packet contains exactly one frame.
For audio, it contains an integer number of frames if each frame has
a known fixed size (e.g. PCM or ADPCM data). If the audio frames have
a variable size (e.g. MPEG audio), then it contains one frame.

pkt->pts, pkt->dts and pkt->duration are always set to correct
values in AVStream.time_base units (and guessed if the format cannot
provide them). pkt->pts can be AV_NOPTS_VALUE if the video format
has B-frames, so it is better to rely on pkt->dts if you do not
decompress the payload.

@returns:
- 0 if OK, < 0 on error or end of file. On error, pkt will be blank
(as if it came from av_packet_alloc()).

@note pkt will be initialized, so it may be uninitialized, but it must not
contain data that needs to be freed.
"""

comptime av_seek_frame = ExternalFunction[
    "av_seek_frame",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        stream_index: c_int,
        timestamp: c_long_long,
        flags: c_int,
    ) -> c_int,
]
"""Seek to the keyframe at timestamp. `timestamp` in `stream_index`.

Arguments:
- s: media file handle
- stream_index: If stream_index is (-1), a default stream is selected,
 and timestamp is automatically converted from AV_TIME_BASE units to the stream specific time_base.
- timestamp: Timestamp in AVStream.time_base units or, if no stream is specified, in AV_TIME_BASE units.
- flags: flags which select direction and seeking mode

Returns:
- >= 0 on success
"""

comptime avformat_seek_file = ExternalFunction[
    "avformat_seek_file",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        stream_index: c_int,
        min_ts: c_long_long,
        ts: c_long_long,
        max_ts: c_long_long,
        flags: c_int,
    ) -> c_int,
]
"""Seek to timestamp ts.

Seeking will be done so that the point from which all active streams
can be presented successfully will be closest to ts and within min/max_ts.
Active streams are all streams that have AVStream.discard < AVDISCARD_ALL.

If flags contain AVSEEK_FLAG_BYTE, then all timestamps are in bytes and
are the file position (this may not be supported by all demuxers).
If flags contain AVSEEK_FLAG_FRAME, then all timestamps are in frames
in the stream with stream_index (this may not be supported by all demuxers).

Otherwise all timestamps are in units of the stream selected by stream_index
or if stream_index is -1, in AV_TIME_BASE units.

If flags contain AVSEEK_FLAG_ANY, then non-keyframes are treated as
keyframes (this may not be supported by all demuxers).

If flags contain AVSEEK_FLAG_BACKWARD, it is ignored.

Arguments:
- s: media file handle
- stream_index: If stream_index is (-1), a default stream is selected,
 and timestamp is automatically converted from AV_TIME_BASE units to the stream specific time_base.
- min_ts: smallest acceptable timestamp
- ts: target timestamp
- max_ts: largest acceptable timestamp
- flags: flags which select direction and seeking mode

Returns:
- >= 0 on success, error code otherwise

Note: This is part of the new seek API which is still under construction.
"""


comptime avformat_flush = ExternalFunction[
    "avformat_flush",
    fn (s: UnsafePointer[AVFormatContext, MutOrigin.external],),
]
"""Discard all internally buffered data. This can be useful when dealing with
discontinuities in the byte stream. Generally works only with formats that
can resync. This includes headerless formats like MPEG-TS/TS but should also
work with NUT, Ogg and in a limited way AVI for example.

The set of streams, the detected duration, stream parameters and codecs do
not change when calling this function. If you want a complete reset, it's
better to open a new AVFormatContext.

This does not flush the AVIOContext (s->pb). If necessary, call
avio_flush(s->pb) before calling this function.

Arguments:
- s: media file handle

Returns:
- >= 0 on success, error code otherwise
"""

comptime av_read_play = ExternalFunction[
    "av_read_play",
    fn (s: UnsafePointer[AVFormatContext, MutOrigin.external],),
]
"""Start playing a network-based stream (e.g. RTSP stream) at the current position.
"""

comptime av_read_pause = ExternalFunction[
    "av_read_pause",
    fn (s: UnsafePointer[AVFormatContext, MutOrigin.external],),
]
"""Pause a network-based stream (e.g. RTSP stream).

Use av_read_play() to resume it.
"""

comptime avformat_close_input = ExternalFunction[
    "avformat_close_input",
    fn (
        s: UnsafePointer[
            UnsafePointer[AVFormatContext, MutOrigin.external],
            MutOrigin.external,
        ],
    ),
]
"""Close an opened input AVFormatContext. Free it and all its contents
and set *s to NULL.
"""

comptime AVSEEK_FLAG_BACKWARD = 1
"""Seek backward."""
comptime AVSEEK_FLAG_BYTE = 2
"""Seek based on position in bytes."""
comptime AVSEEK_FLAG_ANY = 4
"""Seek to any frame, even non-keyframes."""
comptime AVSEEK_FLAG_FRAME = 8
"""Seek based on frame number."""

comptime AVSTREAM_INIT_IN_WRITE_HEADER = 0
"""Stream parameters initialized in avformat_write_header."""
comptime AVSTREAM_INIT_IN_INIT_OUTPUT = 1
"""Stream parameters initialized in avformat_init_output."""


comptime avformat_write_header = ExternalFunction[
    "avformat_write_header",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutOrigin.external], MutOrigin.external
        ],
    ) -> c_int,
]
"""Allocate the stream private data and write the stream header to
an output media file.

Arguments:
- s: media file handle, must be allocated with avformat_alloc_context().
Its AVFormatContext.oformat field must be set to the desired output format;
Its AVFormatContext.pb field must be set to an already opened AVIOContext.
- options: An AVDictionary filled with AVFormatContext and muxer-private options.
On return this parameter will be destroyed and replaced with a dict containing 
options that were not found. May be NULL.

Returns:
- AVSTREAM_INIT_IN_WRITE_HEADER On success, if the codec had not already been
fully initialized in avformat_init_output().
- AVSTREAM_INIT_IN_INIT_OUTPUT On success, if the codec had already been fully
initialized in avformat_init_output().
- AVERROR A negative AVERROR on failure.

See: av_opt_find, av_dict_set, avio_open, av_oformat_next, avformat_init_output.
"""

comptime avformat_init_output = ExternalFunction[
    "avformat_init_output",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        options: UnsafePointer[
            UnsafePointer[AVDictionary, MutOrigin.external], MutOrigin.external
        ],
    ) -> c_int,
]
"""Allocate the stream private data and initialize the codec, but do not write the header.
May optionally be used before avformat_write_header() to initialize stream parameters
before actually writing the header.
If using this function, do not pass the same options to avformat_write_header().

Arguments:
- s: media file handle, must be allocated with avformat_alloc_context().
Its AVFormatContext.oformat field must be set to the desired output format;
Its AVFormatContext.pb field must be set to an already opened AVIOContext.
- options: An AVDictionary filled with AVFormatContext and muxer-private options.
On return this parameter will be destroyed and replaced with a dict containing options that were not found. May be NULL.

Returns:
- AVSTREAM_INIT_IN_WRITE_HEADER On success, if the codec requires avformat_write_header to fully initialize.
- AVSTREAM_INIT_IN_INIT_OUTPUT On success, if the codec has been fully initialized.
- AVERROR A negative AVERROR on failure.

See: av_opt_find, av_dict_set, avio_open, av_oformat_next, avformat_write_header.
"""

comptime av_write_frame = ExternalFunction[
    "av_write_frame",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
    ) -> c_int,
]
"""Write a packet to an output media file.

This function passes the packet directly to the muxer, without any buffering
or reordering. The caller is responsible for correctly interleaving the
packets if the format requires it. Callers that want libavformat to handle
the interleaving should call av_interleaved_write_frame() instead of this
function.

Arguments:
- s: media file handle
- pkt: The packet containing the data to be written. Note that unlike
              av_interleaved_write_frame(), this function does not take
              ownership of the packet passed to it (though some muxers may make
              an internal reference to the input packet).

              This parameter can be NULL (at any time, not just at the end), in
              order to immediately flush data buffered within the muxer, for
              muxers that buffer up data internally before writing it to the
              output.

             Packet's @ref AVPacket.stream_index "stream_index" field must be
             set to the index of the corresponding stream in @ref
             AVFormatContext.streams "s->streams".

             The timestamps (@ref AVPacket.pts "pts", @ref AVPacket.dts "dts")
             must be set to correct values in the stream's timebase (unless the
             output format is flagged with the AVFMT_NOTIMESTAMPS flag, then
             they can be set to AV_NOPTS_VALUE).
             The dts for subsequent packets passed to this function must be strictly
             increasing when compared in their respective timebases (unless the
             output format is flagged with the AVFMT_TS_NONSTRICT, then they
             merely have to be nondecreasing).  @ref AVPacket.duration
             "duration") should also be set if known.
  @return < 0 on error, = 0 if OK, 1 if flushed and there is no more data to flush
 
  @see av_interleaved_write_frame()
"""


comptime av_interleaved_write_frame = ExternalFunction[
    "av_interleaved_write_frame",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
    ) -> c_int,
]
"""Write a packet to an output media file ensuring correct interleaving.
This function will buffer the packets internally as needed to make sure the
packets in the output file are properly interleaved, usually ordered by
increasing dts. Callers doing their own interleaving should call
av_write_frame() instead of this function.

Using this function instead of av_write_frame() can give muxers advance
knowledge of future packets, improving e.g. the behaviour of the mp4
muxer for VFR content in fragmenting mode.

Arguments:
- s: media file handle
- pkt: The packet containing the data to be written.
  If the packet is reference-counted, this function will take
  ownership of this reference and unreference it later when it sees
  fit. If the packet is not reference-counted, libavformat will
  make a copy.
  The returned packet will be blank (as if returned from
  av_packet_alloc()), even on error.
  This parameter can be NULL (at any time, not just at the end), to
  flush the interleaving queues.
  Packet's @ref AVPacket.stream_index "stream_index" field must be
  set to the index of the corresponding stream in @ref
  AVFormatContext.streams "s->streams".
  The timestamps (@ref AVPacket.pts "pts", @ref AVPacket.dts "dts")
  must be set to correct values in the stream's timebase (unless the
  output format is flagged with the AVFMT_NOTIMESTAMPS flag, then
  they can be set to AV_NOPTS_VALUE).
  The dts for subsequent packets in one stream must be strictly
  increasing (unless the output format is flagged with the
  AVFMT_TS_NONSTRICT, then they merely have to be nondecreasing).
  @ref AVPacket.duration "duration" should also be set if known.

Returns:
- 0 on success, a negative AVERROR on error.

See: av_write_frame(), AVFormatContext.max_interleave_delta
"""

comptime av_write_uncoded_frame = ExternalFunction[
    "av_write_uncoded_frame",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        stream_index: c_int,
        frame: UnsafePointer[AVFrame, MutOrigin.external],
    ) -> c_int,
]
"""Write an uncoded frame to an output media file.

The frame must be correctly interleaved according to the container
specification; if not, av_interleaved_write_uncoded_frame() must be used.

Arguments:
- s: media file handle
- stream_index: index of the stream
- frame: the frame to be written

Returns:
- 0 on success, a negative AVERROR on error.

See: av_interleaved_write_uncoded_frame()
"""

comptime av_interleaved_write_uncoded_frame = ExternalFunction[
    "av_interleaved_write_uncoded_frame",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        stream_index: c_int,
        frame: UnsafePointer[AVFrame, MutOrigin.external],
    ) -> c_int,
]
"""Write an uncoded frame to an output media file.

If the muxer supports it, this function makes it possible to write an AVFrame
structure directly, without encoding it into a packet.
It is mostly useful for devices and similar special muxers that use raw
video or PCM data and will not serialize it into a byte stream.

To test whether it is possible to use it with a given muxer and stream,
use av_write_uncoded_frame_query().

The caller gives up ownership of the frame and must not access it
afterwards.

Arguments:
- s: media file handle
- stream_index: index of the stream
- frame: the frame to be written

Returns:
- 0 on success, a negative AVERROR on error.
"""

comptime av_write_uncoded_frame_query = ExternalFunction[
    "av_write_uncoded_frame_query",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        stream_index: c_int,
    ) -> c_int,
]
"""Test whether a muxer supports uncoded frame.

Arguments:
- s: media file handle
- stream_index: index of the stream

Returns:
- >= 0 if an uncoded frame can be written to that muxer and stream, <0 if not
"""

comptime av_write_trailer = ExternalFunction[
    "av_write_trailer",
    fn (s: UnsafePointer[AVFormatContext, MutOrigin.external],) -> c_int,
]
"""Write the stream trailer to an output media file and free the file private data.

May only be called after a successful call to avformat_write_header.

Arguments:
- s: media file handle

Returns:
- 0 on success, AVERROR_xxx on error
"""


comptime av_guess_format = ExternalFunction[
    "av_guess_format",
    fn (
        short_name: UnsafePointer[c_char, ImmutAnyOrigin],
        filename: UnsafePointer[c_char, ImmutAnyOrigin],
        mime_type: UnsafePointer[c_char, ImmutAnyOrigin],
    ) -> UnsafePointer[AVOutputFormat, ImmutOrigin.external],
]
"""Return the output format in the list of registered output formats which best 
matches the provided parameters, or return NULL if there is no match.

Arguments:
- short_name: if non-NULL checks if short_name matches with the names of the registered formats
- filename: if non-NULL checks if filename terminates with the extensions of the registered formats
- mime_type: if non-NULL checks if mime_type matches with the MIME type of the registered formats
"""

comptime av_guess_codec = ExternalFunction[
    "av_guess_codec",
    fn (
        fmt: UnsafePointer[AVOutputFormat, ImmutOrigin.external],
        short_name: UnsafePointer[c_char, ImmutOrigin.external],
        filename: UnsafePointer[c_char, ImmutOrigin.external],
        mime_type: UnsafePointer[c_char, ImmutOrigin.external],
        type: AVMediaType.ENUM_DTYPE,
    ) -> AVCodecID.ENUM_DTYPE,
]
"""Guess the codec ID based upon muxer and filename.
"""

comptime av_get_output_timestamp = ExternalFunction[
    "av_get_output_timestamp",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        stream: c_int,
        dts: UnsafePointer[c_long_long, MutOrigin.external],
        wall: UnsafePointer[c_long_long, MutOrigin.external],
    ) -> c_int,
]
"""Get timing information for the data currently output.

The exact meaning of "currently output" depends on the format.
It is mostly relevant for devices that have an internal buffer and/or
work in real time.

Arguments:
- s: media file handle
- stream: stream in the media file
- dts: DTS of the last packet output for the stream, in stream time_base units
- wall: absolute time when that packet whas output, in microsecond

Returns:
- 0 on success, AVERROR(ENOSYS) The format does not support it

Note: Some formats or devices may not allow to measure dts and wall atomically.
"""


comptime av_hex_dump = ExternalFunction[
    "av_hex_dump",
    fn (
        f: FILE_ptr,
        buf: UnsafePointer[c_uchar, ImmutOrigin.external],
        size: c_int,
    ),
]
"""Send a nice hexadecimal dump of a buffer to the specified file stream.

Arguments:
- f: file stream pointer where the dump should be sent to
- buf: buffer
- size: buffer size

@see av_hex_dump_log, av_pkt_dump2, av_pkt_dump_log2
"""

comptime av_hex_dump_log = ExternalFunction[
    "av_hex_dump_log",
    fn (
        avcl: OpaquePointer[MutOrigin.external],
        level: c_int,
        buf: UnsafePointer[c_uchar, ImmutOrigin.external],
        size: c_int,
    ),
]
"""Send a nice hexadecimal dump of a buffer to the log.

Arguments:
- avcl: pointer to an arbitrary struct of which the first field is a pointer to
 an AVClass struct.
- level: importance level of the message, lower values signifying higher importance
- buf: buffer
- size: buffer size

@see av_hex_dump, av_pkt_dump2, av_pkt_dump_log2
"""

comptime av_pkt_dump2 = ExternalFunction[
    "av_pkt_dump2",
    fn (
        f: FILE_ptr,
        pkt: UnsafePointer[AVPacket, ImmutOrigin.external],
        dump_payload: c_int,
        st: UnsafePointer[AVStream, ImmutOrigin.external],
    ),
]
"""Send a nice dump of a packet to the specified file stream.

Arguments:
- f: file stream pointer where the dump should be sent to
- pkt: packet to dump
- dump_payload: True if the payload must be displayed, too.
- st: AVStream that the packet belongs to

@see av_hex_dump, av_hex_dump_log, av_pkt_dump_log2
"""

comptime av_pkt_dump_log2 = ExternalFunction[
    "av_pkt_dump_log2",
    fn (
        avcl: OpaquePointer[MutOrigin.external],
        level: c_int,
        pkt: UnsafePointer[AVPacket, ImmutOrigin.external],
        dump_payload: c_int,
        st: UnsafePointer[AVStream, ImmutOrigin.external],
    ),
]
"""Send a nice dump of a packet to the log.

Arguments:
- avcl: pointer to an arbitrary struct of which the first field is a pointer to
 an AVClass struct.
- level: importance level of the message, lower values signifying higher importance
- pkt: packet to dump
- dump_payload: True if the payload must be displayed, too.
- st: AVStream that the packet belongs to

@see av_hex_dump, av_hex_dump_log, av_pkt_dump2
"""

comptime av_codec_get_id = ExternalFunction[
    "av_codec_get_id",
    fn (
        tags: UnsafePointer[
            UnsafePointer[AVCodecTag, ImmutOrigin.external],
            ImmutOrigin.external,
        ],
        tag: c_uint,
    ) -> AVCodecID.ENUM_DTYPE,
]
"""Get the AVCodecID for the given codec tag.
If no codec id is found returns AV_CODEC_ID_NONE.

Arguments:
- tags: list of supported codec_id-codec_tag pairs, as stored in AVInputFormat.codec_tag and AVOutputFormat.codec_tag
- tag: codec tag to match to a codec ID

Returns:
- AV_CODEC_ID_NONE if no codec id is found
- AVCodecID.ENUM_DTYPE if a codec id is found
"""

comptime av_codec_get_tag = ExternalFunction[
    "av_codec_get_tag",
    fn (
        tags: UnsafePointer[
            UnsafePointer[AVCodecTag, ImmutOrigin.external],
            ImmutOrigin.external,
        ],
        id: AVCodecID.ENUM_DTYPE,
    ) -> c_uint,
]
"""Get the codec tag for the given codec id.
If no codec tag is found returns 0.

Arguments:
- tags: list of supported codec_id-codec_tag pairs, as stored in AVInputFormat.codec_tag and AVOutputFormat.codec_tag
- id: codec id to match to a codec tag

Returns:
- 0 if no codec tag is found
"""

comptime av_codec_get_tag2 = ExternalFunction[
    "av_codec_get_tag2",
    fn (
        tags: UnsafePointer[
            UnsafePointer[AVCodecTag, ImmutOrigin.external],
            ImmutOrigin.external,
        ],
        id: AVCodecID.ENUM_DTYPE,
        tag: UnsafePointer[c_uint, MutOrigin.external],
    ) -> c_int,
]
"""Get the codec tag for the given codec id.

Arguments:
- tags: list of supported codec_id-codec_tag pairs, as stored in 
AVInputFormat.codec_tag and AVOutputFormat.codec_tag
- id: codec id that should be searched for in the list
- tag: A pointer to the found tag

Returns:
- 0 if id was not found in tags, > 0 if it was found
"""

comptime av_find_default_stream_index = ExternalFunction[
    "av_find_default_stream_index",
    fn (s: UnsafePointer[AVFormatContext, MutOrigin.external],) -> c_int,
]


comptime av_index_search_timestamp = ExternalFunction[
    "av_index_search_timestamp",
    fn (
        st: UnsafePointer[AVStream, MutOrigin.external],
        timestamp: c_long_long,
        flags: c_int,
    ) -> c_int,
]
"""Get the index for a specific timestamp.

Arguments:
- st: stream that the timestamp belongs to
- timestamp: timestamp to retrieve the index for
- flags: if AVSEEK_FLAG_BACKWARD then the returned index will correspond to the timestamp which is <= the requested one, if backward is 0, then it will be >=
- flags: if AVSEEK_FLAG_ANY seek to any frame, only keyframes otherwise

Returns:
- < 0 if no such timestamp could be found
"""

comptime avformat_index_get_entries_count = ExternalFunction[
    "avformat_index_get_entries_count",
    fn (st: UnsafePointer[AVStream, MutOrigin.external],) -> c_int,
]
"""Get the index entry count for the given AVStream.

Arguments:
- st: stream

Returns:
- the number of index entries in the stream
"""

comptime avformat_index_get_entry = ExternalFunction[
    "avformat_index_get_entry",
    fn (
        st: UnsafePointer[AVStream, MutOrigin.external],
        idx: c_int,
    ) -> UnsafePointer[AVIndexEntry, ImmutOrigin.external],
]
"""Get the AVIndexEntry corresponding to the given index.

Arguments:
- st: stream containing the requested AVIndexEntry.
- idx: the desired index

Returns:
- A pointer to the requested AVIndexEntry if it exists, NULL otherwise

The pointer returned by this function is only guaranteed to be valid
until any function that takes the stream or the parent AVFormatContext
as input argument is called.
"""

comptime avformat_index_get_entry_from_timestamp = ExternalFunction[
    "avformat_index_get_entry_from_timestamp",
    fn (
        st: UnsafePointer[AVStream, MutOrigin.external],
        timestamp: c_long_long,
        flags: c_int,
    ) -> UnsafePointer[AVIndexEntry, ImmutOrigin.external],
]
"""Get the AVIndexEntry corresponding to the given timestamp.

Arguments:
- st: stream containing the requested AVIndexEntry.
- timestamp: timestamp to retrieve the index entry for
- flags: if AVSEEK_FLAG_BACKWARD then the returned entry will correspond to the 
timestamp which is <= the requested one, if backward is 0, then it will be >=
if AVSEEK_FLAG_ANY seek to any frame, only keyframes otherwise

Returns:
- A pointer to the requested AVIndexEntry if it exists, NULL otherwise

The pointer returned by this function is only guaranteed to be valid
until any function that takes the stream or the parent AVFormatContext
as input argument is called.
"""

comptime av_add_index_entry = ExternalFunction[
    "av_add_index_entry",
    fn (
        st: UnsafePointer[AVStream, MutOrigin.external],
        pos: c_long_long,
        timestamp: c_long_long,
        size: c_int,
        distance: c_int,
        flags: c_int,
    ) -> c_int,
]
"""Add an index entry into a sorted list. Update the entry if the list already contains it.

Arguments:
- timestamp: timestamp of the index entry
"""

comptime av_url_split = ExternalFunction[
    "av_url_split",
    fn (
        proto: UnsafePointer[c_char, MutOrigin.external],
        proto_size: c_int,
        authorization: UnsafePointer[c_char, MutOrigin.external],
        authorization_size: c_int,
        hostname: UnsafePointer[c_char, MutOrigin.external],
        hostname_size: c_int,
        port_ptr: UnsafePointer[c_int, MutOrigin.external],
        path: UnsafePointer[c_char, MutOrigin.external],
        path_size: c_int,
        url: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> c_int,
]
"""Split a URL string into components.

The pointers to buffers for storing individual components may be null,
in order to ignore that component. Buffers for components not found are
set to empty strings. If the port is not found, it is set to a negative
value.

Arguments:
- proto: the buffer for the protocol
- proto_size: the size of the proto buffer
- authorization: the buffer for the authorization
- authorization_size: the size of the authorization buffer
- hostname: the buffer for the host name
- hostname_size: the size of the hostname buffer
- port_ptr: a pointer to store the port number in
- path: the buffer for the path
- path_size: the size of the path buffer
- url: the URL to split

Returns:
- 0 on success, a negative AVERROR on error
"""

comptime av_dump_format = ExternalFunction[
    "av_dump_format",
    fn (
        ic: UnsafePointer[AVFormatContext, MutOrigin.external],
        index: c_int,
        url: UnsafePointer[c_char, ImmutAnyOrigin],
        is_output: c_int,
    ),
]
"""Print detailed information about the input or output format, such as
duration, bitrate, streams, container, programs, metadata, side data,
codec and time base.

Arguments:
- ic: the context to analyze
- index: index of the stream to dump information about
- url: the URL to print, such as source or destination file
- is_output: Select whether the specified context is an input(0) or output(1)
"""

comptime AV_FRAME_FILENAME_FLAGS_MULTIPLE = 1
"""Allow multiple %d."""

comptime av_get_frame_filename2 = ExternalFunction[
    "av_get_frame_filename2",
    fn (
        buf: UnsafePointer[c_char, MutOrigin.external],
        buf_size: c_int,
        path: UnsafePointer[c_char, ImmutOrigin.external],
        number: c_int,
        flags: c_int,
    ) -> c_int,
]
"""Return in 'buf' the path with '%d' replaced by a number.

Also handles the '%0nd' format where 'n' is the total number
of digits and '%%'.

Arguments:
- buf: destination buffer
- buf_size: destination buffer size
- path: numbered sequence string
- number: frame number
- flags: AV_FRAME_FILENAME_FLAGS_*

Returns:
- 0 if OK, -1 on format error
"""

comptime av_get_frame_filename = ExternalFunction[
    "av_get_frame_filename",
    fn (
        buf: UnsafePointer[c_char, MutOrigin.external],
        buf_size: c_int,
        path: UnsafePointer[c_char, ImmutOrigin.external],
        number: c_int,
    ) -> c_int,
]


comptime av_filename_number_test = ExternalFunction[
    "av_filename_number_test",
    fn (filename: UnsafePointer[c_char, ImmutOrigin.external],) -> c_int,
]
"""Check whether filename actually is a numbered sequence generator.

Arguments:
- filename: possible numbered sequence string

Returns:
- 1 if a valid numbered sequence string, 0 otherwise
"""

comptime av_sdp_create = ExternalFunction[
    "av_sdp_create",
    fn (
        ac: UnsafePointer[
            UnsafePointer[AVFormatContext, MutOrigin.external],
            MutOrigin.external,
        ],
        n_files: c_int,
        buf: UnsafePointer[c_char, MutOrigin.external],
        size: c_int,
    ) -> c_int,
]
"""Generate an SDP for an RTP session.

Note, this overwrites the id values of AVStreams in the muxer contexts
for getting unique dynamic payload types.

Arguments:
- ac: array of AVFormatContexts describing the RTP streams. If the
array is composed by only one context, such context can contain
multiple AVStreams (one AVStream per RTP stream). Otherwise,
all the contexts in the array (an AVCodecContext per RTP stream)
must contain only one AVStream.
- n_files: number of AVCodecContexts contained in ac
- buf: buffer where the SDP will be stored (must be allocated by
the caller)
- size: the size of the buffer

Returns:
- 0 if OK, AVERROR_xxx on error
"""


comptime av_match_ext = ExternalFunction[
    "av_match_ext",
    fn (
        filename: UnsafePointer[c_char, ImmutOrigin.external],
        extensions: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> c_int,
]
"""Return a positive value if the given filename has one of the given
extensions, 0 otherwise.

Arguments:
- filename: file name to check against the given extensions
- extensions: a comma-separated list of filename extensions
"""


comptime avformat_query_codec = ExternalFunction[
    "avformat_query_codec",
    fn (
        ofmt: UnsafePointer[AVOutputFormat, ImmutOrigin.external],
        codec_id: AVCodecID.ENUM_DTYPE,
        std_compliance: c_int,
    ) -> c_int,
]
"""Test if the given container can store a codec.

Arguments:
- ofmt: container to check for compatibility
- codec_id: codec to potentially store in container
- std_compliance: standards compliance level, one of FF_COMPLIANCE_*

Returns:
- 1 if codec with ID codec_id can be stored in ofmt, 0 if it cannot.
- A negative number if this information is not available.
"""

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
    fn () -> UnsafePointer[AVCodecTag, ImmutOrigin.external],
]
"""Get the tables mapping RIFF FourCCs for video to libavcodec AVCodecID.

Returns:
- The table mapping RIFF FourCCs for video to libavcodec AVCodecID.
"""

comptime avformat_get_riff_audio_tags = ExternalFunction[
    "avformat_get_riff_audio_tags",
    fn () -> UnsafePointer[AVCodecTag, ImmutOrigin.external],
]
"""Get the tables mapping RIFF FourCCs for audio to AVCodecID.

Returns:
- The table mapping RIFF FourCCs for audio to AVCodecID.
"""

comptime avformat_get_mov_video_tags = ExternalFunction[
    "avformat_get_mov_video_tags",
    fn () -> UnsafePointer[AVCodecTag, ImmutOrigin.external],
]
"""Get the tables mapping MOV FourCCs for video to libavcodec AVCodecID.

Returns:
- The table mapping MOV FourCCs for video to libavcodec AVCodecID.
"""

comptime avformat_get_mov_audio_tags = ExternalFunction[
    "avformat_get_mov_audio_tags",
    fn () -> UnsafePointer[AVCodecTag, ImmutOrigin.external],
]
"""Get the tables mapping MOV FourCCs for audio to AVCodecID.

Returns:
- The table mapping MOV FourCCs for audio to AVCodecID.
"""


comptime av_guess_sample_aspect_ratio = ExternalFunction[
    "av_guess_sample_aspect_ratio",
    fn (
        format: UnsafePointer[AVFormatContext, MutOrigin.external],
        stream: UnsafePointer[AVStream, MutOrigin.external],
        frame: UnsafePointer[AVFrame, MutOrigin.external],
    ) -> AVRational,
]
"""Guess the sample aspect ratio of a frame, based on both the stream and the 
frame aspect ratio.

Since the frame aspect ratio is set by the codec but the stream aspect ratio
is set by the demuxer, these two may not be equal. This function tries to
return the value that you should use if you would like to display the frame.

Basic logic is to use the stream aspect ratio if it is set to something sane
otherwise use the frame aspect ratio. This way a container setting, which is
usually easy to modify can override the coded value in the frames.

Arguments:
- format: the format context which the stream is part of
- stream: the stream which the frame is part of
- frame: the frame with the aspect ratio to be determined

Returns:
- The guessed sample aspect ratio.
"""

comptime av_guess_frame_rate = ExternalFunction[
    "av_guess_frame_rate",
    fn (
        ctx: UnsafePointer[AVFormatContext, MutOrigin.external],
        stream: UnsafePointer[AVStream, MutOrigin.external],
        frame: UnsafePointer[AVFrame, MutOrigin.external],
    ) -> AVRational,
]
"""Guess the frame rate, based on both the container and codec information.

Arguments:
- ctx: the format context which the stream is part of
- stream: the stream which the frame is part of
- frame: the frame for which the frame rate should be determined, may be NULL

Returns:
- the guessed (valid) frame rate, 0/1 if no idea
"""

comptime avformat_match_stream_specifier = ExternalFunction[
    "avformat_match_stream_specifier",
    fn (
        s: UnsafePointer[AVFormatContext, MutOrigin.external],
        st: UnsafePointer[AVStream, MutOrigin.external],
        spec: UnsafePointer[c_char, ImmutOrigin.external],
    ) -> c_int,
]
"""Check if the stream st contained in s is matched by the stream specifier spec.

See the "stream specifiers" chapter in the documentation for the syntax
of spec.

Arguments:
- s: media file handle
- st: stream to check
- spec: stream specifier

Returns:
- >0 if st is matched by spec, 0 if it is not, <0 on error

Note: A stream specifier can match several streams in the format.
"""

comptime avformat_queue_attached_pictures = ExternalFunction[
    "avformat_queue_attached_pictures",
    fn (s: UnsafePointer[AVFormatContext, MutOrigin.external],) -> c_int,
]


# Note: this section is in the original header file, however is being deprecated.
# AVTimebaseSource
# avformat_transfer_internal_stream_timing_info
# av_stream_get_codec_timebase
# Are all behind a macro flag with APIs that are being deprecated.
