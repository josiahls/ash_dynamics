from ash_dynamics.primitives._clib import StructWritable
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil import AVPictureType
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
from sys.ffi import c_uchar, c_int, c_long_long, c_ulong_long
from utils import StaticTuple
from ash_dynamics.primitives._clib import (
    StructWritable,
    StructWriter,
    ExternalFunction,
)


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVFrameSideDataType:
    """
    The data is the AVPanScan struct defined in libavcodec.
    """

    comptime ENUM_DTYPE = c_int

    var _value: Self.ENUM_DTYPE

    comptime AV_FRAME_DATA_PANSCAN = Self(0)

    """ATSC A53 Part 4 Closed Captions.
    A53 CC bitstream is stored as uint8_t in AVFrameSideData.data.
    The number of bytes of CC data is AVFrameSideData.size.
    """
    comptime AV_FRAME_DATA_A53_CC = Self(1)
    comptime AV_FRAME_DATA_STEREO3D = Self(2)
    """Stereoscopic 3d metadata.
    The data is the AVStereo3D struct defined in libavutil/stereo3d.h.
    """
    comptime AV_FRAME_DATA_MATRIXENCODING = Self(3)
    """The data is the AVMatrixEncoding enum defined in libavutil/channel_layout.h.
    """
    comptime AV_FRAME_DATA_DOWNMIX_INFO = Self(4)
    """Metadata relevant to a downmix procedure.
    The data is the AVDownmixInfo struct defined in libavutil/downmix_info.h.
    """
    comptime AV_FRAME_DATA_REPLAYGAIN = Self(5)
    """ReplayGain information in the form of the AVReplayGain struct.
    """
    comptime AV_FRAME_DATA_DISPLAYMATRIX = Self(6)
    """This side data contains a 3x3 transformation matrix describing an affine
    transformation that needs to be applied to the frame for correct
    presentation.
    See libavutil/display.h for a detailed description of the data.
    """
    comptime AV_FRAME_DATA_AFD = Self(7)
    """Active Format Description data consisting of a single byte as specified
    in ETSI TS 101 154 using AVActiveFormatDescription enum.
    """
    comptime AV_FRAME_DATA_MOTION_VECTORS = Self(8)
    """Motion vectors exported by some codecs (on demand through the export_mvs
    flag set in the libavcodec AVCodecContext flags2 option).
    The data is the AVMotionVector struct defined in
    libavutil/motion_vector.h.
    """
    comptime AV_FRAME_DATA_SKIP_SAMPLES = Self(9)
    """Recommends skipping the specified number of samples. This is exported
    only if the "skip_manual" AVOption is set in libavcodec.
    This has the same format as AV_PKT_DATA_SKIP_SAMPLES.
    @code
    u32le number of samples to skip from start of this packet
    u32le number of samples to skip from end of this packet
    u8    reason for start skip
    u8    reason for end   skip (0=padding silence, 1=convergence)
    @endcode
    """
    comptime AV_FRAME_DATA_AUDIO_SERVICE_TYPE = Self(10)
    """This side data must be associated with an audio frame and corresponds to
    enum AVAudioServiceType defined in avcodec.h.
    """
    comptime AV_FRAME_DATA_MASTERING_DISPLAY_METADATA = Self(11)
    """Mastering display metadata associated with a video frame. The payload is
    an AVMasteringDisplayMetadata type and contains information about the
    mastering display color volume.
    """
    comptime AV_FRAME_DATA_GOP_TIMECODE = Self(12)
    """The GOP timecode in 25 bit timecode format. Data format is 64-bit integer.
    This is set on the first frame of a GOP that has a temporal reference of 0.
    """

    comptime AV_FRAME_DATA_SPHERICAL = Self(13)
    """The data represents the AVSphericalMapping structure defined in
    libavutil/spherical.h.
    """

    comptime AV_FRAME_DATA_CONTENT_LIGHT_LEVEL = Self(14)
    """Content light level (based on CTA-861.3). This payload contains data in
    the form of the AVContentLightMetadata struct.
    """

    comptime AV_FRAME_DATA_ICC_PROFILE = Self(15)
    """The data contains an ICC profile as an opaque octet buffer following the
    format described by ISO 15076-1 with an optional name defined in the
    metadata key entry "name".
    """

    comptime AV_FRAME_DATA_S12M_TIMECODE = Self(16)
    """Timecode which conforms to SMPTE ST 12-1. The data is an array of 4 uint32_t
    where the first uint32_t describes how many (1-3) of the other timecodes are used.
    The timecode format is described in the documentation of av_timecode_get_smpte_from_framenum()
    function in libavutil/timecode.h.
    """

    comptime AV_FRAME_DATA_DYNAMIC_HDR_PLUS = Self(17)
    """HDR dynamic metadata associated with a video frame. The payload is
    an AVDynamicHDRPlus type and contains information for color
    volume transform - application 4 of SMPTE 2094-40:2016 standard.
    """

    comptime AV_FRAME_DATA_REGIONS_OF_INTEREST = Self(18)
    """Regions Of Interest, the data is an array of AVRegionOfInterest type, the number of
    array element is implied by AVFrameSideData.size / AVRegionOfInterest.self_size.
    """

    comptime AV_FRAME_DATA_VIDEO_ENC_PARAMS = Self(19)
    """Encoding parameters for a video frame, as described by AVVideoEncParams.
    """

    comptime AV_FRAME_DATA_SEI_UNREGISTERED = Self(20)
    """User data unregistered metadata associated with a video frame.
    This is the H.26[45] UDU SEI message, and shouldn't be used for any other purpose
    The data is stored as uint8_t in AVFrameSideData.data which is 16 bytes of
    uuid_iso_iec_11578 followed by AVFrameSideData.size - 16 bytes of user_data_payload_byte.
    """

    comptime AV_FRAME_DATA_FILM_GRAIN_PARAMS = Self(21)
    """Film grain parameters for a frame, described by AVFilmGrainParams.
    Must be present for every frame which should have film grain applied.

    May be present multiple times, for example when there are multiple
    alternative parameter sets for different video signal characteristics.
    The user should select the most appropriate set for the application.
    """

    comptime AV_FRAME_DATA_DETECTION_BBOXES = Self(22)
    """Bounding boxes for object detection and classification,
    as described by AVDetectionBBoxHeader.
    """

    comptime AV_FRAME_DATA_DOVI_RPU_BUFFER = Self(23)
    """Dolby Vision RPU raw data, suitable for passing to x265
    or other libraries. Array of uint8_t, with NAL emulation
    bytes intact.
    """

    comptime AV_FRAME_DATA_DOVI_METADATA = Self(24)
    """Parsed Dolby Vision metadata, suitable for passing to a software
    implementation. The payload is the AVDOVIMetadata struct defined in
    libavutil/dovi_meta.h.
    """

    comptime AV_FRAME_DATA_DYNAMIC_HDR_VIVID = Self(25)
    """HDR Vivid dynamic metadata associated with a video frame. The payload is
    an AVDynamicHDRVivid type and contains information for color
    volume transform - CUVA 005.1-2021.
    """

    comptime AV_FRAME_DATA_AMBIENT_VIEWING_ENVIRONMENT = Self(26)
    """Ambient viewing environment metadata, as defined by H.274.
    """

    comptime AV_FRAME_DATA_VIDEO_HINT = Self(27)
    """Provide encoder-specific hinting information about changed/unchanged
    portions of a frame.  It can be used to pass information about which
    macroblocks can be skipped because they didn't change from the
    corresponding ones in the previous frame. This could be useful for
    applications which know this information in advance to speed up
    encoding.
    """

    comptime AV_FRAME_DATA_LCEVC = Self(28)
    """Raw LCEVC payload data, as a uint8_t array, with NAL emulation
    bytes intact.
    """

    comptime AV_FRAME_DATA_VIEW_ID = Self(29)
    """This side data must be associated with a video frame.
    The presence of this side data indicates that the video stream is
    composed of multiple views (e.g. stereoscopic 3D content,
    cf. H.264 Annex H or H.265 Annex G).
    The data is an int storing the view ID.
    """

    comptime AV_FRAME_DATA_3D_REFERENCE_DISPLAYS = Self(30)
    """This side data contains information about the reference display width(s)
    and reference viewing distance(s) as well as information about the
    corresponding reference stereo pair(s), i.e., the pair(s) of views to be
    displayed for the viewer's left and right eyes on the reference display
    at the reference viewing distance.
    The payload is the AV3DReferenceDisplaysInfo struct defined in
    libavutil/tdrdi.h.
    """


@fieldwise_init
@register_passable("trivial")
struct AVFrame(StructWritable):
    """The frame structure.
    This structure describes decoded (raw) audio or video data.

    AVFrame must be allocated using av_frame_alloc(). Note that this only
    allocates the AVFrame itself, the buffers for the data must be managed
    through other means (see below).
    AVFrame must be freed with av_frame_free().

    AVFrame is typically allocated once and then reused multiple times to hold
    different data (e.g. a single AVFrame to hold frames received from a
    decoder). In such a case, av_frame_unref() will free any references held by
    the frame and reset it to its original clean state before it
    is reused again.

    The data described by an AVFrame is usually reference counted through the
    AVBuffer API. The underlying buffer references are stored in AVFrame.buf /
    AVFrame.extended_buf. An AVFrame is considered to be reference counted if at
    least one reference is set, i.e. if AVFrame.buf[0] != NULL. In such a case,
    every single data plane must be contained in one of the buffers in
    AVFrame.buf or AVFrame.extended_buf.
    There may be a single buffer for all the data, or one separate buffer for
    each plane, or anything in between.

    sizeof(AVFrame) is not a part of the public ABI, so new fields may be added
    to the end with a minor bump.

    Fields can be accessed through AVOptions, the name string used, matches the
    C structure field name for fields accessible through AVOptions.
    """

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["data"](
            "StaticTuple[c_uchar, Self.AV_NUM_DATA_POINTERS]"
        )
        struct_writer.write_field["extended_data"](self.extended_data)
        struct_writer.write_field["width"](self.width)
        struct_writer.write_field["height"](self.height)
        struct_writer.write_field["nb_samples"](self.nb_samples)
        struct_writer.write_field["format"](self.format)
        struct_writer.write_field["pict_type"](self.pict_type)
        struct_writer.write_field["sample_aspect_ratio"](
            self.sample_aspect_ratio
        )
        struct_writer.write_field["pts"](self.pts)
        struct_writer.write_field["pkt_dts"](self.pkt_dts)
        struct_writer.write_field["time_base"](self.time_base)
        struct_writer.write_field["quality"](self.quality)
        struct_writer.write_field["opaque"](self.opaque)
        struct_writer.write_field["repeat_pict"](self.repeat_pict)
        struct_writer.write_field["sample_rate"](self.sample_rate)
        struct_writer.write_field["buf"](
            "StaticTuple[AVBufferRef, Self.AV_NUM_DATA_POINTERS]"
        )
        struct_writer.write_field["extended_buf"](self.extended_buf)
        struct_writer.write_field["nb_extended_buf"](self.nb_extended_buf)
        struct_writer.write_field["side_data"](self.side_data)
        struct_writer.write_field["nb_side_data"](self.nb_side_data)
        struct_writer.write_field["flags"](self.flags)
        struct_writer.write_field["color_range"](self.color_range)
        struct_writer.write_field["color_primaries"](self.color_primaries)
        struct_writer.write_field["color_transfer_characteristic"](
            self.color_transfer_characteristic
        )
        struct_writer.write_field["colorspace"](self.colorspace)
        struct_writer.write_field["chroma_location"](self.chroma_location)
        struct_writer.write_field["best_effort_timestamp"](
            self.best_effort_timestamp
        )
        struct_writer.write_field["metadata"](self.metadata)
        struct_writer.write_field["decode_error_flags"](self.decode_error_flags)
        struct_writer.write_field["hw_frames_ctx"](self.hw_frames_ctx)
        struct_writer.write_field["opaque_ref"](self.opaque_ref)
        struct_writer.write_field["crop_top"](self.crop_top)
        struct_writer.write_field["crop_bottom"](self.crop_bottom)
        struct_writer.write_field["crop_left"](self.crop_left)
        struct_writer.write_field["crop_right"](self.crop_right)
        struct_writer.write_field["private_ref"](self.private_ref)
        struct_writer.write_field["ch_layout"](self.ch_layout)
        struct_writer.write_field["duration"](self.duration)

    comptime AV_NUM_DATA_POINTERS = Int(8)
    """Number of pointers in data and extended_data."""

    var data: StaticTuple[
        UnsafePointer[c_uchar, MutOrigin.external], Self.AV_NUM_DATA_POINTERS
    ]
    """Pointer to the picture/channel planes.

    This might be different from the first allocated byte. For video,
    it could even point to the end of the image data.

    All pointers in data and extended_data must point into one of the
    AVBufferRef in buf or extended_buf.

    Some decoders access areas outside 0,0 - width,height, please
    see avcodec_align_dimensions2(). Some filters and swscale can read
    up to 16 bytes beyond the planes, if these filters are to be used,
    then 16 extra bytes must be allocated.

    NOTE: Pointers not needed by the format MUST be set to NULL.

    @attention In case of video, the data[] pointers can point to the
    end of image data in order to reverse line order, when used in
    combination with negative values in the linesize[] array.
    """
    var linesize: StaticTuple[c_int, Self.AV_NUM_DATA_POINTERS]
    """For video, a positive or negative value, which is typically indicating
    the size in bytes of each picture line, but it can also be:
    - the negative byte size of lines for vertical flipping
    (with data[n] pointing to the end of the data
    - a positive or negative multiple of the byte size as for accessing
    even and odd fields of a frame (possibly flipped)

    For audio, only linesize[0] may be set. For planar audio, each channel
    plane must be the same size.

    For video the linesizes should be multiples of the CPUs alignment
    preference, this is 16 or 32 for modern desktop CPUs.
    Some code requires such alignment other code can be slower without
    correct alignment, for yet other it makes no difference.

    @note The linesize may be larger than the size of usable data -- there
    may be extra padding present for performance reasons.

    @attention In case of video, line size values can be negative to achieve
    a vertically inverted iteration over image lines.
    """

    var extended_data: UnsafePointer[
        UnsafePointer[c_uchar, origin = MutOrigin.external],
        origin = MutOrigin.external,
    ]
    """pointers to the data planes/channels.

    For video, this should simply point to data[].

    For planar audio, each channel has a separate data pointer, and
    linesize[0] contains the size of each channel buffer.
    For packed audio, there is just one data pointer, and linesize[0]
    contains the total size of the buffer for all channels.

    Note: Both data and extended_data should always be set in a valid frame,
    but for planar audio with more channels that can fit in data,
    extended_data must be used in order to access all channels.
    """

    var width: c_int
    """Video dimensions.
    Video frames only. The coded dimensions (in pixels) of the video frame,
    i.e. the size of the rectangle that contains some well-defined values.

    @note The part of the frame intended for display/presentation is further
    restricted by the @ref cropping "Cropping rectangle".
    """
    var height: c_int
    "Ref `self.width`"

    var nb_samples: c_int
    """Number of audio samples (per channel) described by this frame.
    """

    var format: c_int
    """format of the frame, -1 if unknown or unset
    Values correspond to enum AVPixelFormat for video frames,
    enum AVSampleFormat for audio)
    """

    var pict_type: AVPictureType.ENUM_DTYPE
    """Picture type of the frame.
    """

    var sample_aspect_ratio: AVRational
    """Sample aspect ratio for the video frame, 0/1 if unknown/unspecified.
    """

    var pts: c_ulong_long
    """Presentation timestamp in time_base units (time when frame should be shown to user).
    """

    var pkt_dts: c_ulong_long
    """DTS copied from the AVPacket that triggered returning this frame. (if frame threading isn't used)
    This is also the Presentation time of this AVFrame calculated from
    only AVPacket.dts values without pts values.
    """

    var time_base: AVRational
    """Time base for the timestamps in this frame.
    In the future, this field may be set on frames output by decoders or
    filters, but its value will be by default ignored on input to encoders
    or filters.
    """

    var quality: c_int
    """quality (between 1 (good) and FF_LAMBDA_MAX (bad))
    """

    var opaque: OpaquePointer[MutOrigin.external]
    """Frame owner's private data.
    This field may be set by the code that allocates/owns the frame data.
    It is then not touched by any library functions, except:
    - a new reference to the underlying buffer is propagated by
      av_frame_copy_props() (and hence by av_frame_ref());
    - it is unreferenced in av_frame_unref();
    - on the caller's explicit request. E.g. libavcodec encoders/decoders
      will propagate a new reference to/from AVPackets if the caller sets
      AV_CODEC_FLAG_COPY_OPAQUE.
    """

    var repeat_pict: c_int
    """Number of fields in this frame which should be repeated, i.e. the total
    duration of this frame should be repeat_pict + 2 normal field durations.

    For interlaced frames this field may be set to 1, which signals that this
    frame should be presented as 3 fields: beginning with the first field (as
    determined by AV_FRAME_FLAG_TOP_FIELD_FIRST being set or not), followed
    by the second field, and then the first field again.

    For progressive frames this field may be set to a multiple of 2, which
    signals that this frame's duration should be (repeat_pict + 2) / 2
    normal frame durations.

    @note This field is computed from MPEG2 repeat_first_field flag and its
    associated flags, H.264 pic_struct from picture timing SEI, and
    their analogues in other codecs. Typically it should only be used when
    higher-layer timing information is not available.
    """

    var sample_rate: c_int
    """Sample rate of the audio data.
    """

    var buf: StaticTuple[AVBufferRef, Self.AV_NUM_DATA_POINTERS]
    """AVBuffer references backing the data for this frame. All the pointers in
    data and extended_data must point inside one of the buffers in buf or
    extended_buf. This array must be filled contiguously -- if buf[i] is
    non-NULL then buf[j] must also be non-NULL for all j < i.

    There may be at most one AVBuffer per data plane, so for video this array
    always contains all the references. For planar audio with more than
    Self.AV_NUM_DATA_POINTERS channels, there may be more buffers than can fit in
    this array. Then the extra AVBufferRef pointers are stored in the
    extended_buf array.
    """

    var extended_buf: UnsafePointer[
        UnsafePointer[AVBufferRef, origin = MutOrigin.external],
        origin = MutOrigin.external,
    ]
    """For planar audio which requires more than Self.AV_NUM_DATA_POINTERS
    AVBufferRef pointers, this array will hold all the references which
    cannot fit into AVFrame.buf.

    Note that this is different from AVFrame.extended_data, which always
    contains all the pointers. This array only contains the extra pointers,
    which cannot fit into AVFrame.buf.

    This array is always allocated using av_malloc() by whoever constructs
    the frame. It is freed in av_frame_unref().
    """

    var nb_extended_buf: c_int
    """Number of elements in extended_buf."""

    var side_data: UnsafePointer[
        UnsafePointer[AVFrameSideData, origin = MutOrigin.external],
        origin = MutOrigin.external,
    ]
    var nb_side_data: c_int

    comptime AV_FRAME_FLAG_CORRUPT = Int(1 << 0)
    """The frame data may be corrupted, e.g. due to decoding errors."""
    comptime AV_FRAME_FLAG_KEY = Int(1 << 1)
    """A flag to mark frames that are keyframes."""
    comptime AV_FRAME_FLAG_DISCARD = Int(1 << 2)
    """A flag to mark frames whose content is interlaced."""
    comptime AV_FRAME_FLAG_INTERLACED = Int(1 << 3)
    """A flag to mark frames where the top field is displayed first if the content is interlaced."""
    comptime AV_FRAME_FLAG_TOP_FIELD_FIRST = Int(1 << 4)
    """A flag to mark frames which were originally encoded losslessly."""
    comptime AV_FRAME_FLAG_LOSSLESS = Int(1 << 5)
    """A decoder can use this flag to mark frames which were originally encoded losslessly.
    
    For coding bitstream formats which support both lossless and lossy
    encoding, it is sometimes possible for a decoder to determine which method
    was used when the bitsream was encoded.
    """

    var flags: c_int
    """Frame flags, a combination of @ref lavu_frame_flags"""

    var color_range: AVColorRange.ENUM_DTYPE
    """MPEG vs JPEG YUV range.
    
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """

    var color_primaries: AVColorPrimaries.ENUM_DTYPE
    """Color primaries for the video frame."""

    var color_transfer_characteristic: AVColorTransferCharacteristic.ENUM_DTYPE
    """Color transfer characteristic for the video frame."""

    var colorspace: AVColorSpace.ENUM_DTYPE
    """YUV colorspace type.
    
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """

    var chroma_location: AVChromaLocation.ENUM_DTYPE
    """Chroma location.
    
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """

    var best_effort_timestamp: c_long_long
    """frame timestamp estimated using various heuristics, in stream time base
    - encoding: unused
    - decoding: set by libavcodec, read by user.
    """

    var metadata: AVDictionary
    """metadata.
    
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """

    var decode_error_flags: c_int
    """decode error flags of the frame, set to a combination of
    FF_DECODE_ERROR_xxx flags if the decoder produced a frame, but there
    were errors during the decoding.
    - encoding: unused
    - decoding: set by libavcodec, read by user.
    """

    comptime FF_DECODE_ERROR_INVALID_BITSTREAM = Int(1)
    """Invalid bitstream."""
    comptime FF_DECODE_ERROR_MISSING_REFERENCE = Int(2)
    """Missing reference."""
    comptime FF_DECODE_ERROR_CONCEALMENT_ACTIVE = Int(4)
    """Concealment active."""
    comptime FF_DECODE_ERROR_DECODE_SLICES = Int(8)
    """Decode slices."""

    var hw_frames_ctx: UnsafePointer[AVBufferRef, origin = MutOrigin.external]
    """For hwaccel-format frames, this should be a reference to the
    AVHWFramesContext describing the frame.
    """

    var opaque_ref: AVBufferRef
    """Reference-counted frame owner's private data.

    This field may be set by the code that allocates/owns the frame data.
    It is then not touched by any library functions, except:
    - a new reference to the underlying buffer is propagated by
      av_frame_copy_props() (and hence by av_frame_ref());
    - it is unreferenced in av_frame_unref();
    - on the caller's explicit request. E.g. libavcodec encoders/decoders
      will propagate a new reference to/from AVPackets if the caller sets
      AV_CODEC_FLAG_COPY_OPAQUE.
    """

    var crop_top: c_int
    """Cropping
    Video frames only. The number of pixels to discard from the the
    top/bottom/left/right border of the frame to obtain the sub-rectangle of
    the frame intended for presentation.
    """

    var crop_bottom: c_int
    "Ref `self.crop_top`"

    var crop_left: c_int
    "Ref `self.crop_top`"

    var crop_right: c_int
    "Ref `self.crop_top`"

    var private_ref: OpaquePointer[MutOrigin.external]
    """RefStruct reference for internal use by a single libav* library.
    Must not be used to transfer data between libraries.
    Has to be NULL when ownership of the frame leaves the respective library.

    Code outside the FFmpeg libs must never check or change private_ref.
    """

    var ch_layout: AVChannelLayout
    """Channel layout of the audio data.
    """

    var duration: c_long_long
    """Duration of the frame, in the same units as pts. 0 if unknown.
    """


@fieldwise_init
@register_passable("trivial")
struct AVFrameSideData(StructWritable):
    """Structure to hold side data for an AVFrame.

    sizeof(AVFrameSideData) is not a part of the public ABI, so new fields may be added
    to the end with a minor bump.
    """

    var type: AVFrameSideDataType.ENUM_DTYPE
    "Type of the side data."
    var data: UnsafePointer[c_uchar, MutOrigin.external]
    "Data of the side data."
    var size: c_int
    "Size of the side data."
    var metadata: UnsafePointer[AVDictionary, MutOrigin.external]
    "Metadata of the side data."
    var buf: UnsafePointer[AVBufferRef, MutOrigin.external]
    "Buffer of the side data."

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["type"](self.type)
        struct_writer.write_field["data"](self.data)
        struct_writer.write_field["size"](self.size)
        struct_writer.write_field["metadata"](self.metadata)
        struct_writer.write_field["buf"](self.buf)


comptime _av_frame_alloc = ExternalFunction[
    "av_frame_alloc", fn () -> UnsafePointer[AVFrame, MutOrigin.external]
]
"""Allocate an AVFrame and set its fields to default values. The
resulting struct must be freed using av_frame_free().

@return An AVFrame filled with default values or NULL on failure.

@note this only allocates the AVFrame itself, not the data buffers. Those
must be allocated through other means, e.g. with av_frame_get_buffer() or
manually.
"""
