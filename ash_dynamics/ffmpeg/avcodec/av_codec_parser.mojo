from ash_dynamics.primitives._clib import ExternalFunction
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.avcodec_header import (
    RcOverride,
    AVPictureStructure,
)
from ash_dynamics.primitives._clib import StructWritable, TrivialOptionalField
from ash_dynamics.ffmpeg.avutil.pixfmt import (
    AVPixelFormat,
    AVColorRange,
    AVColorPrimaries,
    AVColorTransferCharacteristic,
    AVColorSpace,
    AVChromaLocation,
)
from ash_dynamics.ffmpeg.avcodec.defs import (
    AVFieldOrder,
    AVAudioServiceType,
    AVDiscard,
)
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout

# from ash_dynamics.ffmpeg.avcodec.internal import AVCodecInternal
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket, AVPacketSideData
from ash_dynamics.ffmpeg.avutil.frame import AVFrameSideData
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avcodec.codec_desc import AVCodecDescriptor
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avcodec.avcodec_header import AVHWAccel
from sys.ffi import (
    c_char,
    c_long_long,
    c_float,
    c_ushort,
    c_uchar,
    c_uint,
    c_ulong_long,
)
from utils import StaticTuple


comptime FF_API_CODEC_PROPS = False


comptime AVCodecInternal = OpaquePointer[MutOrigin.external]
"""Private context used for internal data.

Unlike priv_data, this is not codec-specific. It is used in general
libavcodec functions.
"""


@fieldwise_init
@register_passable("trivial")
struct AVCodecContext(StructWritable):
    var av_class: UnsafePointer[AVClass, origin = ImmutOrigin.external]
    "Information for av_log(). Set by avcodec_alloc_context3()."
    var log_level_offset: c_int
    "Log level offset. For libav* bitstream readers."
    var codec_type: AVMediaType.ENUM_DTYPE
    "AVMediaType. See AVMEDIA_TYPE_xxx for the list of possible values."
    var codec: UnsafePointer[AVCodec, origin = ImmutOrigin.external]
    "AVCodec. See AV_CODEC_ID_xxx for the list of possible values."

    var codec_tag: c_ushort
    """FourCC (LSB first, so "ABCD" -> ('D'<<24) + ('C'<<16) + ('B'<<8) + 'A').
    This is used to work around some encoder bugs.

    A demuxer should set this to what is stored in the field used to identify the codec.

    If there are multiple such fields in a container then the demuxer should choose the one
    which maximizes the information about the used codec.

    If the codec tag field in a container is larger than 32 bits then the demuxer should
    remap the longer ID to 32 bits with a table or other structure. Alternatively a new
    extra_codec_tag + size could be added but for this a clear advantage must be demonstrated
    first.
    - encoding: Set by user, if not then the default based on codec_id will be used.
    - decoding: Set by user, will be converted to uppercase by libavcodec during init.
    """
    var priv_data: OpaquePointer[MutOrigin.external]
    "Private data for use by the codec."

    var internal: UnsafePointer[AVCodecInternal, origin = ImmutOrigin.external]
    """Internal data used for internal data.

    Unlike priv_data, this is not codec-specific. It is used in general
    libavcodec functions.
    """
    var opaque: OpaquePointer[MutOrigin.external]
    """Private data of the user, can be used to carry app specific stuff.

    - encoding: Set by user.
    - decoding: Set by user.
    """
    var bit_rate: c_long_long
    """The average bitrate (in bits per second).
    
    - encoding: Set by user; unused for constant quantizer encoding.
    - decoding: Set by user, may be overwritten by libavcodec
    if this info is available in the stream
    """
    var flags: c_int
    """AV_CODEC_FLAG_*.
    
    - encoding: Set by user.
    - decoding: Set by user.
    """
    var flags2: c_int
    """AV_CODEC_FLAG2_*.

    - encoding: Set by user.
    - decoding: Set by user.
    """

    var extradata: UnsafePointer[c_char, ImmutOrigin.external]
    """Out-of-band global headers that may be used by some codecs.
    
    - decoding: Should be set by the caller when available (typically from a
    demuxer) before opening the decoder; some decoders require this to be
    set and will fail to initialize otherwise.
    
    The array must be allocated with the av_malloc() family of functions;
    allocated size must be at least AV_INPUT_BUFFER_PADDING_SIZE bytes
    larger than extradata_size.
    
    - encoding: May be set by the encoder in avcodec_open2() (possibly
    depending on whether the AV_CODEC_FLAG_GLOBAL_HEADER flag is set).
    
    After being set, the array is owned by the codec and freed in
    avcodec_free_context().
    """
    var extradata_size: c_int
    "Size of the extradata."

    var time_base: AVRational
    """This is the fundamental unit of time (in seconds) in terms
    of which frame timestamps are represented. For fixed-fps content,
    timebase should be 1/framerate and timestamp increments should be
    identically 1.
    This often, but not always is the inverse of the frame rate or field rate
    for video. 1/time_base is not the average frame rate if the frame rate is not
    constant.
    Like containers, elementary streams also can store timestamps, 1/time_base
    is the unit in which these timestamps are specified.
    As example of such codec time base see ISO/IEC 14496-2:2001(E)
    vop_time_increment_resolution and fixed_vop_rate
    (fixed_vop_rate == 0 implies that it is different from the framerate)
    - encoding: MUST be set by user.
    - decoding: unused.
    """
    var pkt_timebase: AVRational
    """Timebase in which pkt_dts/pts and AVPacket.dts/pts are expressed.
    - encoding: unused.
    - decoding: set by user.
    """
    var framerate: AVRational
    """
    - decoding: For codecs that store a framerate value in the compressed
    bitstream, the decoder may export it here. { 0, 1} when
    unknown.
    - encoding: May be used to signal the framerate of CFR content to an
    encoder.
    """
    var delay: c_int
    """Codec delay.
    - Encoding: Number of frames delay there will be from the encoder input to
    the decoder output. (we assume the decoder matches the spec)
    - Decoding: Number of frames delay in addition to what a standard decoder
    as specified in the spec would produce.

    Video:
    Number of frames the decoded output will be delayed relative to the
    encoded input.

    Audio:
    For encoding, this field is unused (see initial_padding).

    For decoding, this is the number of samples the decoder needs to
    output before the decoder's output is valid. When seeking, you should
    start decoding this many samples prior to your desired seek point.

    - encoding: Set by libavcodec.
    - decoding: Set by libavcodec.
    """
    # Video only
    var width: c_int
    """Picture width / height.

    @note Those fields may not match the values of the last
    AVFrame output by avcodec_receive_frame() due frame
    reordering.

    - encoding: MUST be set by user.
    - decoding: May be set by the user before opening the decoder if known e.g.
    from the container. Some decoders will require the dimensions
    to be set by the caller. During decoding, the decoder may
    overwrite those values as required while parsing the data."""
    var height: c_int
    "Reference `Self.width` docs."

    var coded_width: c_int
    """Bitstream width / height, may be different from width/height e.g. when
    the decoded frame is cropped before being output or lowres is enabled.

    @note Those field may not match the value of the last
    AVFrame output by avcodec_receive_frame() due frame
    reordering.

    - encoding: unused
    - decoding: May be set by the user before opening the decoder if known e.g.
    from the container. During decoding, the decoder may
    overwrite those values as required while parsing the data.
    """
    var coded_height: c_int
    "Reference `Self.coded_width` docs."

    var sample_aspect_ratio: AVRational
    """Sample aspect ratio (0 if unknown)
    That is the width of a pixel divided by the height of the pixel.
    Numerator and denominator must be relatively prime and smaller than 256 for 
    some video standards.
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """
    var pix_fmt: AVPixelFormat.ENUM_DTYPE
    """Pixel format, see AV_PIX_FMT_xxx.
    May be set by the demuxer if known from headers.
    May be overridden by the decoder if it knows better.

    @note This field may not match the value of the last
    AVFrame output by avcodec_receive_frame() due frame
    reordering.

    - encoding: Set by user.
    - decoding: Set by user if known, overridden by libavcodec while
    parsing the data.
    """
    var sw_pix_fmt: AVPixelFormat.ENUM_DTYPE
    """Nominal unaccelerated pixel format, see AV_PIX_FMT_xxx.
    - encoding: unused.
    - decoding: Set by libavcodec before calling get_format().
    """
    var color_primaries: AVColorPrimaries.ENUM_DTYPE
    """Chromaticity coordinates of the source primaries.
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """
    var color_trc: AVColorTransferCharacteristic.ENUM_DTYPE
    """Color Transfer Characteristic.
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """
    var color_space: AVColorSpace.ENUM_DTYPE
    """YUV colorspace type.
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """
    var color_range: AVColorRange.ENUM_DTYPE
    """MPEG vs JPEG YUV range.
    - encoding: Set by user to override the default output color range value,
    If not specified, libavcodec sets the color range depending on the
    output format.
    - decoding: Set by libavcodec, can be set by the user to propagate the
    color range to components reading from the decoder context.
    """
    var chroma_sample_location: AVChromaLocation.ENUM_DTYPE
    """This defines the location of chroma samples.
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """
    var field_order: AVFieldOrder.ENUM_DTYPE
    """Field order
    - encoding: set by libavcodec.
    - decoding: Set by user.
    """
    var refs: c_int
    """Number of reference frames.
    - encoding: Set by user.
    - decoding: Set by lavc.
    """
    var has_b_frames: c_int
    """Size of the frame reordering buffer in the decoder.
    For MPEG-2 it is 1 IPB or 0 low delay IP.
    - encoding: Set by libavcodec.
    - decoding: Set by libavcodec.
    """
    var slice_flags: c_int
    """Slice flags.
    - encoding: unused
    - decoding: Set by user.
    """
    comptime SLICE_FLAG_CODED_ORDER = Int(0x0001)
    """Draw the slice in coded order instead of display order."""
    comptime SLICE_FLAG_ALLOW_FIELD = Int(0x0002)
    """Allow draw_horiz_band() with field slices (MPEG-2 field pics)."""
    comptime SLICE_FLAG_ALLOW_PLANE = Int(0x0004)
    """Allow draw_horiz_band() with 1 component at a time (SVQ1)."""
    var draw_horiz_band: fn (
        s: UnsafePointer[Self, MutOrigin.external],
        src: UnsafePointer[AVFrame, ImmutOrigin.external],
        offset: StaticTuple[c_int, AVFrame.AV_NUM_DATA_POINTERS],
        y: c_int,
        type: c_int,
        height: c_int,
    ) -> NoneType
    """If non NULL, 'draw_horiz_band' is called by the libavcodec
    decoder to draw a horizontal band. It improves cache usage. Not
    all codecs can do that. You must check the codec capabilities
    beforehand.

    When multithreading is used, it may be called from multiple threads
    at the same time; threads might draw different parts of the same AVFrame,
    or multiple AVFrames, and there is no guarantee that slices will be drawn
    in order.

    The function is also used by hardware acceleration APIs.
    It is called at least once during frame decoding to pass
    the data needed for hardware render.
    In that mode instead of pixel data, AVFrame points to
    a structure specific to the acceleration API. The application
    reads the structure and can change some fields to indicate progress
    or mark state.

    - encoding: unused
    - decoding: Set by user.

    Args:
        s: the codec context.
        src: the frame to draw the slice on.
        offset: the offset into the AVFrame.data from which the slice should be read.
        y: the y position of the slice.
        type: the type of the slice. type 1->top field, 2->bottom field, 3->frame
        height: the height of the slice.
    """
    var get_format: fn (
        s: UnsafePointer[Self, MutOrigin.external],
        fmt: UnsafePointer[AVPixelFormat.ENUM_DTYPE, ImmutOrigin.external],
    ) -> AVPixelFormat.ENUM_DTYPE
    """Callback to negotiate the pixel format. Decoding only, may be set by the
    caller before avcodec_open2().

    Called by some decoders to select the pixel format that will be used for
    the output frames. This is mainly used to set up hardware acceleration,
    then the provided format list contains the corresponding hwaccel pixel
    formats alongside the "software" one. The software pixel format may also
    be retrieved from sw_pix_fmt.

    This callback will be called when the coded frame properties (such as
    resolution, pixel format, etc.) change and more than one output format is
    supported for those new properties. If a hardware pixel format is chosen
    and initialization for it fails, the callback may be called again
    immediately.

    This callback may be called from different threads if the decoder is
    multi-threaded, but not from more than one thread simultaneously.
    The list of formats must be terminated by AV_PIX_FMT_NONE.
    The function must return AV_PIX_FMT_NONE if it cannot determine the
    pixel format to use or if its parameters do not match the pixel format to use.

    Warning: Behavior is undefined if the callback returns a value other
    than one of the formats in fmt or AV_PIX_FMT_NONE.

    Arguments:
        - fmt: list of formats which may be used in the current
    configuration, terminated by AV_PIX_FMT_NONE.
    Returns:
        - The chosen format or AV_PIX_FMT_NONE
    """
    var max_b_frames: c_int
    """Maximum number of B-frames between non-B-frames.
    Note: The output will be delayed by max_b_frames+1 relative to the input.
    - encoding: Set by user.
    - decoding: unused.
    """
    var b_quant_factor: c_float
    """Qscale factor between IP and B-frames
    If > 0 then the last P-frame quantizer will be used (q= lastp_q*factor+offset).
    If < 0 then normal ratecontrol will be done (q= -normal_q*factor+offset).
    - encoding: Set by user.
    - decoding: unused.
    """
    var b_quant_offset: c_float
    """Qscale offset between IP and B-frames
    - encoding: Set by user.
    - decoding: unused.
    """
    var i_quant_factor: c_float
    """Qscale factor between P- and I-frames
    If > 0 then the last P-frame quantizer will be used (q= lastp_q*factor+offset).
    If < 0 then normal ratecontrol will be done (q= -normal_q*factor+offset).
    - encoding: Set by user.
    - decoding: unused.
    """
    var i_quant_offset: c_float
    """Qscale offset between P and I-frames
    - encoding: Set by user.
    - decoding: unused.
    """
    var lumi_masking: c_float
    """Luminance masking (0-> disabled)
    - encoding: Set by user.
    - decoding: unused.
    """
    var temporal_cplx_masking: c_float
    """Temporary complexity masking (0-> disabled)
    - encoding: Set by user.
    - decoding: unused.
    """
    var spatial_cplx_masking: c_float
    """Spatial complexity masking (0-> disabled)
    - encoding: Set by user.
    - decoding: unused.
    """
    var p_masking: c_float
    """P block masking (0-> disabled)
    - encoding: Set by user.
    - decoding: unused.
    """
    var dark_masking: c_float
    """Darkness masking (0-> disabled)
    - encoding: Set by user.
    - decoding: unused.
    """
    var nsse_weight: c_int
    """Noise vs. SSE weight for the NSSE comparison function
    - encoding: Set by user.
    - decoding: unused.
    """
    var me_cmp: c_int
    """Motion estimation comparison function
    - encoding: Set by user.
    - decoding: unused.
    """
    var me_sub_cmp: c_int
    """Subpixel motion estimation comparison function
    - encoding: Set by user.
    - decoding: unused.
    """
    var mb_cmp: c_int
    """Macroblock comparison function (not supported yet)
    - encoding: Set by user.
    - decoding: unused.
    """
    var ildct_cmp: c_int
    """Interlaced DCT comparison function
    - encoding: Set by user.
    - decoding: unused.
    """
    # TODO: Actually source the definitions for this. The original header
    # didn't have any comments.
    comptime FF_CMP_SAD = Int(0)
    comptime FF_CMP_SSE = Int(1)
    comptime FF_CMP_SATD = Int(2)
    comptime FF_CMP_DCT = Int(3)
    comptime FF_CMP_PSNR = Int(4)
    comptime FF_CMP_BIT = Int(5)
    comptime FF_CMP_RD = Int(6)
    comptime FF_CMP_LUMA = Int(7)
    comptime FF_CMP_CHROMA = Int(256)

    var dia_size: c_int
    """ME diamond size & shape
    - encoding: Set by user.
    - decoding: unused.
    """
    var last_predictor_count: c_int
    """Amount of previous MV predictors (2a+1 x 2a+1 square)
    - encoding: Set by user.
    - decoding: unused.
    """
    var me_pre_cmp: c_int
    """Motion estimation prepass comparison function
    - encoding: Set by user.
    - decoding: unused.
    """
    var pre_dia_size: c_int
    """ME prepass diamond size & shape
    - encoding: Set by user.
    - decoding: unused.
    """
    var me_subpel_quality: c_int
    """Subpel ME quality
    - encoding: Set by user.
    - decoding: unused.
    """
    var me_range: c_int
    """Maximum motion estimation search range in subpel units
    If 0 then no limit.
    - encoding: Set by user.
    - decoding: unused.
    """
    var mb_decision: c_int
    """Macroblock decision mode
    - encoding: Set by user.
    - decoding: unused.
    """
    comptime FF_MB_DECISION_SIMPLE = Int(0)
    """Uses mb_cmp."""
    comptime FF_MB_DECISION_BITS = Int(1)
    """Chooses the one which needs the fewest bits."""
    comptime FF_MB_DECISION_RD = Int(2)
    """Rate distortion."""

    var intra_matrix: UnsafePointer[c_ushort, ImmutOrigin.external]
    """Custom intra quantization matrix.
    Must be allocated with the av_malloc() family of functions, and will be freed in
    avcodec_free_context().
    - encoding: Set/allocated by user, freed by libavcodec. Can be NULL.
    - decoding: Set/allocated/freed by libavcodec.
    """
    var inter_matrix: UnsafePointer[c_ushort, ImmutOrigin.external]
    """Custom inter quantization matrix.
    Must be allocated with the av_malloc() family of functions, and will be freed in
    avcodec_free_context().
    - encoding: Set/allocated by user, freed by libavcodec. Can be NULL.
    - decoding: Set/allocated/freed by libavcodec.
    """
    var chroma_intra_matrix: UnsafePointer[c_ushort, ImmutOrigin.external]
    """Custom intra quantization matrix.
    Must be allocated with the av_malloc() family of functions, and will be freed in
    avcodec_free_context().
    - encoding: Set/allocated by user, can be NULL.
    - decoding: unused.
    """
    var intra_dc_precision: c_int
    """Precision of the intra DC coefficient - 8
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """

    var mb_lmin: c_int
    """Minimum MB Lagrange multiplier
    - encoding: Set by user.
    - decoding: unused.
    """
    var mb_lmax: c_int
    """Maximum MB Lagrange multiplier
    - encoding: Set by user.
    - decoding: unused.
    """
    var bidir_refine: c_int
    """Bidir refine
    - encoding: Set by user.
    - decoding: unused.
    """

    var keyint_min: c_int
    """Minimum GOP size
    - encoding: Set by user.
    - decoding: unused.
    """
    var gop_size: c_int
    """The number of pictures in a group of pictures, or 0 for intra_only
    - encoding: Set by user.
    - decoding: unused.
    """
    var mv0_threshold: c_int
    """Note: Value depends upon the compare function used for fullpel ME.
    - encoding: Set by user.
    - decoding: unused.
    """
    var slices: c_int
    """Number of slices.
    Indicates number of picture subdivisions. Used for parallelized
    decoding.
    - encoding: Set by user.
    - decoding: unused.
    """
    # Audio only
    var sample_rate: c_int
    """Audio sampling rate. In samples per second.
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """
    var sample_fmt: AVSampleFormat.ENUM_DTYPE
    """Audio sample format.
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """
    var ch_layout: AVChannelLayout
    """Audio channel layout.
    - encoding: must be set by the caller, to one of AVCodec.ch_layouts.
    - decoding: may be set by the caller if known e.g. from the container.
    The decoder can then override during decoding as needed.
    """
    # The following data should not be initialized.
    var frame_size: c_int
    """Number of samples per channel in an audio frame.
    - encoding: set by libavcodec in avcodec_open2(). Each submitted frame
    except the last must contain exactly frame_size samples per channel.
    May be 0 when the codec has AV_CODEC_CAP_VARIABLE_FRAME_SIZE set, then the
    frame size is not restricted.
    - decoding: may be set by some decoders to indicate constant frame size.
    """
    var block_align: c_int
    """Number of bytes per packet if constant and known or 0
    Used by some WAV based audio codecs.
    """
    var cutoff: c_int
    """Audio cutoff bandwidth (0 means "automatic")
    - encoding: Set by user.
    - decoding: unused.
    """
    var audio_service_type: AVAudioServiceType.ENUM_DTYPE
    """Type of service that the audio stream conveys.
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    """
    var request_sample_fmt: AVSampleFormat.ENUM_DTYPE
    """Desired sample format.
    - encoding: Not used.
    - decoding: Set by user. Decoder will decode to this format if it can.
    """

    var initial_padding: c_int
    """Amount of padding (in samples) inserted by the encoder at the beginning 
    of the audio. I.e. this number of leading decoded samples must be discarded 
    by the caller to get the original audio without leading padding.
    - encoding: Set by libavcodec. The timestamps on the output packets are
    adjusted by the encoder so that they always refer to the
    first sample of the data actually contained in the packet,
    including any added padding.  E.g. if the timebase is
    1/samplerate and the timestamp of the first input sample is
    0, the timestamp of the first output packet will be
    -initial_padding.
    - decoding: unused.
    """
    var trailing_padding: c_int
    """Audio only. The amount of padding (in samples) appended by the encoder 
    to the end of the audio.
    I.e. this number of decoded samples must be discarded by the caller from 
    the end of the stream to get the original audio without any trailing padding.
    - encoding: unused.
    - decoding: unused.
    """
    var seek_preroll: c_int
    """Audio only. Number of samples to skip after a discontinuity.
    - encoding: set by libavcodec.
    - decoding: unused.
    """

    var get_buffer2: fn (
        s: UnsafePointer[Self, MutOrigin.external],
        frame: UnsafePointer[AVFrame, MutOrigin.external],
        flags: c_int,
    ) -> c_int
    """This callback is called at the beginning of each frame to get data
    buffer(s) for it. There may be one contiguous buffer for all the data or
    there may be a buffer per each data plane or anything in between. What
    this means is, you may set however many entries in buf[] you feel necessary.
    Each buffer must be reference-counted using the AVBuffer API (see description
    of buf[] below).

    The following fields will be set in the frame before this callback is
    called:
    - format
    - width, height (video only)
    - sample_rate, channel_layout, nb_samples (audio only)
    Their values may differ from the corresponding values in
    AVCodecContext. This callback must use the frame values, not the codec
    context values, to calculate the required buffer size.

    This callback must fill the following fields in the frame:
    - data[]
    - linesize[]
    - extended_data:
      * if the data is planar audio with more than 8 channels, then this
        callback must allocate and fill extended_data to contain all pointers
        to all data planes. data[] must hold as many pointers as it can.
        extended_data must be allocated with av_malloc() and will be freed in
        av_frame_unref().
      * otherwise extended_data must point to data
    - buf[] must contain one or more pointers to AVBufferRef structures. Each of
      the frame's data and extended_data pointers must be contained in these. That
      is, one AVBufferRef for each allocated chunk of memory, not necessarily one
      AVBufferRef per data[] entry. See: av_buffer_create(), av_buffer_alloc(),
      and av_buffer_ref().
    - extended_buf and nb_extended_buf must be allocated with av_malloc() by
      this callback and filled with the extra buffers if there are more
      buffers than buf[] can hold. extended_buf will be freed in
      av_frame_unref().
      Decoders will generally initialize the whole buffer before it is output
      but it can in rare error conditions happen that uninitialized data is passed
      through. Important: The buffers returned by get_buffer* should thus not contain sensitive
      data.

    If AV_CODEC_CAP_DR1 is not set then get_buffer2() must call
    avcodec_default_get_buffer2() instead of providing buffers allocated by
    some other means.

    Each data plane must be aligned to the maximum required by the target
    CPU.

    @see avcodec_default_get_buffer2()

    Video:

    If AV_GET_BUFFER_FLAG_REF is set in flags then the frame may be reused
    (read and/or written to if it is writable) later by libavcodec.

    avcodec_align_dimensions2() should be used to find the required width and
    height, as they normally need to be rounded up to the next multiple of 16.

    Some decoders do not support linesizes changing between frames.

    If frame multithreading is used, this callback may be called from a
    different thread, but not from more than one at once. Does not need to be
    reentrant.

    @see avcodec_align_dimensions2()

    Audio:

    Decoders request a buffer of a particular size by setting
    AVFrame.nb_samples prior to calling get_buffer2(). The decoder may,
    however, utilize only part of the buffer by setting AVFrame.nb_samples
    to a smaller value in the output frame.

    As a convenience, av_samples_get_buffer_size() and
    av_samples_fill_arrays() in libavutil may be used by custom get_buffer2()
    functions to find the required data size and to fill data pointers and
    linesize. In AVFrame.linesize, only linesize[0] may be set for audio
    since all planes must be the same size.

    @see av_samples_get_buffer_size(), av_samples_fill_arrays()

    - encoding: unused
    - decoding: Set by libavcodec, user can override.
    """

    # Encoding parameters
    var bit_rate_tolerance: c_int
    """Number of bits the bitstream is allowed to diverge from the reference.
    The reference can be CBR (for CBR pass1) or VBR (for pass2)
    - encoding: Set by user; unused for constant quantizer encoding.
    - decoding: unused.
    """
    var global_quality: c_int
    """Global quality for codecs which cannot change it per frame.
    This should be proportional to MPEG-1/2/4 qscale.
    - encoding: Set by user.
    - decoding: unused.
    """
    var compression_level: c_int
    """Compression level.
    - encoding: Set by user.
    - decoding: unused.
    """
    comptime FF_COMPRESSION_DEFAULT = Int(-1)
    var qcompress: c_float
    "Amount of qscale change between easy & hard scenes (0.0-1.0)."
    var qblur: c_float
    "Amount of qscale smoothing over time (0.0-1.0)."
    var qmin: c_int
    """Minimum quantizer
    - encoding: Set by user.
    - decoding: unused.
    """
    var qmax: c_int
    """Maximum quantizer
    - encoding: Set by user.
    - decoding: unused.
    """
    var max_qdiff: c_int
    """Maximum quantizer difference between frames
    - encoding: Set by user.
    - decoding: unused.
    """
    var rc_buffer_size: c_int
    """Decoder bitstream buffer size
    - encoding: Set by user.
    - decoding: May be set by libavcodec.
    """
    var rc_override_count: c_int
    """Number of ratecontrol overrides
    - encoding: Allocated/set/freed by user.
    - decoding: unused.
    """
    var rc_override: UnsafePointer[RcOverride, ImmutOrigin.external]
    """Ratecontrol overrides. See RcOverride.
    - encoding: Allocated/set/freed by user.
    - decoding: unused.
    """
    var rc_max_rate: c_long_long
    """Maximum bitrate
    - encoding: Set by user.
    - decoding: Set by user, may be overwritten by libavcodec.
    """
    var rc_min_rate: c_long_long
    """Minimum bitrate
    - encoding: Set by user.
    - decoding: unused.
    """
    var rc_max_available_vbv_use: c_float
    """Ratecontrol attempt to use, at maximum, <value> of what can be used without an underflow.
    - encoding: Set by user.
    - decoding: unused.
    """
    var rc_min_vbv_overflow_use: c_float
    """Ratecontrol attempt to use, at least, <value> times the amount needed to prevent a vbv overflow.
    - encoding: Set by user.
    - decoding: unused.
    """
    var rc_initial_buffer_occupancy: c_int
    """Number of bits which should be loaded into the rc buffer before decoding starts.
    - encoding: Set by user.
    - decoding: unused.
    """
    var trellis: c_int
    """Trellis RD quantization
    - encoding: Set by user.
    - decoding: unused.
    """
    var stats_out: UnsafePointer[c_char, MutOrigin.external]
    """Pass1 encoding statistics output buffer
    - encoding: Set by libavcodec.
    - decoding: unused.
    """
    var stats_in: UnsafePointer[c_char, MutOrigin.external]
    """Pass2 encoding statistics input buffer
    Concatenated stuff from stats_out of pass1 should be placed here.
    - encoding: Allocated/set/freed by user.
    - decoding: unused.
    """
    var workaround_bugs: c_int
    """Work around bugs in encoders which sometimes cannot be detected automatically.
    - encoding: Set by user.
    - decoding: Set by user.
    """
    comptime FF_BUG_AUTODETECT = Int(1)
    "Autodetection."
    comptime FF_BUG_XVID_ILACE = Int(4)
    comptime FF_BUG_UMP4 = Int(8)
    comptime FF_BUG_NO_PADDING = Int(16)
    comptime FF_BUG_AMV = Int(32)
    comptime FF_BUG_QPEL_CHROMA = Int(64)
    comptime FF_BUG_STD_QPEL = Int(128)
    comptime FF_BUG_QPEL_CHROMA2 = Int(256)
    comptime FF_BUG_DIRECT_BLOCKSIZE = Int(512)
    comptime FF_BUG_EDGE = Int(1024)
    comptime FF_BUG_HPEL_CHROMA = Int(2048)
    comptime FF_BUG_DC_CLIP = Int(4096)
    "Work around various bugs in Microsoft's broken decoders."
    comptime FF_BUG_MS = Int(8192)
    comptime FF_BUG_TRUNCATED = Int(16384)
    comptime FF_BUG_IEDGE = Int(32768)

    var strict_std_compliance: c_int
    """Strictly follow the standard (MPEG-4, ...).
    - encoding: Set by user.
    - decoding: Set by user.
    Setting this to STRICT or higher means the encoder and decoder will
    generally do stupid things, whereas setting it to unofficial or lower
    will mean the encoder might produce output that is not supported by all
    spec-compliant decoders. Decoders don't differentiate between normal,
    unofficial and experimental (that is, they always try to decode things
    when they can) unless they are explicitly asked to behave stupidly
    (=strictly conform to the specs)
    This may only be set to one of the FF_COMPLIANCE_* values in defs.h.
    """

    var error_concealment: c_int
    """Error concealment flags
    - encoding: unused
    - decoding: Set by user.
    """
    comptime FF_EC_GUESS_MVS = Int(1)
    comptime FF_EC_DEBLOCK = Int(2)
    comptime FF_EC_FAVOR_INTER = Int(256)

    var debug: c_int
    """Debug flags
    - encoding: Set by user.
    - decoding: Set by user.
    """
    comptime FF_DEBUG_PICT_INFO = Int(1)
    comptime FF_DEBUG_RC = Int(2)
    comptime FF_DEBUG_BITSTREAM = Int(4)
    comptime FF_DEBUG_MB_TYPE = Int(8)
    comptime FF_DEBUG_QP = Int(16)
    comptime FF_DEBUG_DCT_COEFF = Int(0x00000040)
    comptime FF_DEBUG_SKIP = Int(0x00000080)
    comptime FF_DEBUG_STARTCODE = Int(0x00000100)
    comptime FF_DEBUG_ER = Int(0x00000400)
    comptime FF_DEBUG_MMCO = Int(0x00000800)
    comptime FF_DEBUG_BUGS = Int(0x00001000)
    comptime FF_DEBUG_BUFFERS = Int(0x00008000)
    comptime FF_DEBUG_THREADS = Int(0x00010000)
    comptime FF_DEBUG_GREEN_MD = Int(0x00800000)
    comptime FF_DEBUG_NOMC = Int(0x01000000)

    var err_recognition: c_int
    """Error recognition; may misdetect some more or less valid parts as errors.
    This is a bitfield of the AV_EF_* values defined in defs.h.
    - encoding: Set by user.
    - decoding: Set by user.
    """

    var hwaccel: UnsafePointer[AVHWAccel, ImmutOrigin.external]
    """Hardware accelerator in use
    - encoding: unused.
    - decoding: Set by libavcodec.
    """

    var hwaccel_context: OpaquePointer[MutOrigin.external]
    """Legacy hardware accelerator context.
 
    For some hardware acceleration methods, the caller may use this field to
    signal hwaccel-specific data to the codec. The struct pointed to by this
    pointer is hwaccel-dependent and defined in the respective header. Please
    refer to the FFmpeg HW accelerator documentation to know how to fill
    this.
    
    In most cases this field is optional - the necessary information may also
    be provided to libavcodec through @ref hw_frames_ctx or @ref
    hw_device_ctx (see avcodec_get_hw_config()). However, in some cases it
    may be the only method of signalling some (optional) information.
    
    The struct and its contents are owned by the caller.
    
    - encoding: May be set by the caller before avcodec_open2(). Must remain
                valid until avcodec_free_context().
    - decoding: May be set by the caller in the get_format() callback.
                Must remain valid until the next get_format() call,
                or avcodec_free_context() (whichever comes first).
    """

    var hw_frames_ctx: UnsafePointer[AVBufferRef, MutOrigin.external]
    """A reference to the AVHWFramesContext describing the input (for encoding)
    or output (decoding) frames. The reference is set by the caller and
    afterwards owned (and freed) by libavcodec - it should never be read by
    the caller after being set.
        
    - decoding: This field should be set by the caller from the get_format()
                callback. The previous reference (if any) will always be
                unreffed by libavcodec before the get_format() call.

                If the default get_buffer2() is used with a hwaccel pixel
                format, then this AVHWFramesContext will be used for
                allocating the frame buffers.

    - encoding: For hardware encoders configured to use a hwaccel pixel
                format, this field should be set by the caller to a reference
                to the AVHWFramesContext describing input frames.
                AVHWFramesContext.format must be equal to
                AVCodecContext.pix_fmt.

                This field should be set before avcodec_open2() is called.
    """
    var hw_device_ctx: UnsafePointer[AVBufferRef, MutOrigin.external]
    """A reference to the AVHWDeviceContext describing the device which will
    be used by a hardware encoder/decoder.  The reference is set by the
    caller and afterwards owned (and freed) by libavcodec.

    This should be used if either the codec device does not require
    hardware frames or any that are used are to be allocated internally by
    libavcodec.  If the user wishes to supply any of the frames used as
    encoder input or decoder output then hw_frames_ctx should be used
    instead.  When hw_frames_ctx is set in get_format() for a decoder, this
    field will be ignored while decoding the associated stream segment, but
    may again be used on a following one after another get_format() call.

    For both encoders and decoders this field should be set before
    avcodec_open2() is called and must not be written to thereafter.

    Note that some decoders may require this field to be set initially in
    order to support hw_frames_ctx at all - in that case, all frames
    contexts used must be created on the same device.
    """
    var hwaccel_flags: c_int
    """Bit set of AV_HWACCEL_FLAG_* flags, which affect hardware accelerated
    decoding (if active).
    - encoding: unused
    - decoding: Set by user (either before avcodec_open2(), or in the
                AVCodecContext.get_format callback).
    """
    var extra_hw_frames: c_int
    """Video decoding only.  Sets the number of extra hardware frames which
    the decoder will allocate for use by the caller.  This must be set
    before avcodec_open2() is called.

    Some hardware decoders require all frames that they will use for
    output to be defined in advance before decoding starts.  For such
    decoders, the hardware frame pool must therefore be of a fixed size.
    The extra frames set here are on top of any number that the decoder
    needs internally in order to operate normally (for example, frames
    used as reference pictures).
    """
    var error: StaticTuple[c_ulong_long, AVFrame.AV_NUM_DATA_POINTERS]
    """Error.
    - encoding: Set by libavcodec if flags & AV_CODEC_FLAG_PSNR.
    - decoding: unused.
    """
    var dct_algo: c_int
    """DCT algorithm, see FF_DCT_* below.
    - encoding: Set by user.
    - decoding: unused.
    """
    comptime FF_DCT_AUTO = Int(0)
    comptime FF_DCT_FASTINT = Int(1)
    comptime FF_DCT_INT = Int(2)
    comptime FF_DCT_MMX = Int(3)
    comptime FF_DCT_ALTIVEC = Int(5)
    comptime FF_DCT_FAAN = Int(6)
    comptime FF_DCT_NEON = Int(7)

    var idct_algo: c_int
    """IDCT algorithm, see FF_IDCT_* below.
    - encoding: Set by user.
    - decoding: Set by user.
    """

    comptime FF_IDCT_AUTO = Int(0)
    comptime FF_IDCT_INT = Int(1)
    comptime FF_IDCT_SIMPLE = Int(2)
    comptime FF_IDCT_SIMPLEMMX = Int(3)
    comptime FF_IDCT_ARM = Int(7)
    comptime FF_IDCT_ALTIVEC = Int(8)
    comptime FF_IDCT_SIMPLEARM = Int(10)
    comptime FF_IDCT_XVID = Int(14)
    comptime FF_IDCT_SIMPLEARMV5TE = Int(16)
    comptime FF_IDCT_SIMPLEARMV6 = Int(17)
    comptime FF_IDCT_FAAN = Int(20)
    comptime FF_IDCT_SIMPLENEON = Int(22)
    comptime FF_IDCT_SIMPLEAUTO = Int(128)

    var bits_per_coded_sample: c_int
    """Bits per sample/pixel from the demuxer (needed for huffyuv).
    - encoding: Set by libavcodec.
    - decoding: Set by user.
    """

    var bits_per_raw_sample: c_int
    """Bits per sample/pixel of internal libavcodec pixel/sample format.
    - encoding: set by user.
    - decoding: set by libavcodec.
    """

    var thread_count: c_int
    """Thread count.
    - encoding: Set by user.
    - decoding: Set by user.
    """

    var thread_type: c_int
    """Which multithreading methods are in use by the codec.

    Use of FF_THREAD_FRAME will increase decoding delay by one frame per thread,
    so clients which cannot provide future frames should not use it.

    - encoding: Set by user, otherwise the default is used.
    - decoding: Set by user, otherwise the default is used.
    """
    comptime FF_THREAD_FRAME = Int(1)
    "Decode more than one frame at once."
    comptime FF_THREAD_SLICE = Int(2)
    "Decode more than one part of a single frame at once."

    var active_thread_type: c_int
    """Which multithreading methods are in use by the codec.
    - encoding: Set by libavcodec.
    - decoding: Set by libavcodec.
    """

    var execute: fn (
        c: UnsafePointer[AVCodecContext, MutOrigin.external],
        func: fn (
            c2: UnsafePointer[AVCodecContext, MutOrigin.external],
            arg: OpaquePointer[MutOrigin.external],
        ) -> c_int,
        arg2: OpaquePointer[MutOrigin.external],
        ret: UnsafePointer[c_int, MutOrigin.external],
        count: c_int,
        size: c_int,
    ) -> c_int
    """The codec may call this to execute several independent things.
    It will return only after finishing all tasks.
    The user may replace this with some multithreaded implementation,
    the default implementation will execute the parts serially.
    @param count the number of things to execute
    - encoding: Set by libavcodec, user can override.
    - decoding: Set by libavcodec, user can override.
    """

    var execute2: fn (
        c: UnsafePointer[AVCodecContext, MutOrigin.external],
        func2: fn (
            c2: UnsafePointer[AVCodecContext, MutOrigin.external],
            arg: OpaquePointer[MutOrigin.external],
            jobnr: c_int,
            threadnr: c_int,
        ) -> c_int,
        arg2: OpaquePointer[MutOrigin.external],
        ret: UnsafePointer[c_int, MutOrigin.external],
        count: c_int,
    ) -> c_int
    """The codec may call this to execute several independent things.
    It will return only after finishing all tasks.
    The user may replace this with some multithreaded implementation,
    the default implementation will execute the parts serially.
    @param c context passed also to func
    @param count the number of things to execute
    @param arg2 argument passed unchanged to func
    @param ret return values of executed functions, must have space for "count" values. May be NULL.
    @param func2 function that will be called count times, with jobnr from 0 to count-1.
    threadnr will be in the range 0 to c->thread_count-1 < MAX_THREADS and so that no
    two instances of func executing at the same time will have the same threadnr.
    @return always 0 currently, but code should handle a future improvement where when any call to func
    returns < 0 no further calls to func may be done and < 0 is returned.
    - encoding: Set by libavcodec, user can override.
    - decoding: Set by libavcodec, user can override.
    """

    var profile: c_int
    """Profile
    - encoding: Set by user.
    - decoding: Set by libavcodec.
    See the AV_PROFILE_* defines in defs.h.
    """

    var level: c_int
    """Encoding level descriptor.
    - encoding: Set by user, corresponds to a specific level defined by the
    codec, usually corresponding to the profile level, if not specified it
    is set to AV_LEVEL_UNKNOWN.
    - decoding: Set by libavcodec.
    See AV_LEVEL_* in defs.h.
    """

    var properties: TrivialOptionalField[FF_API_CODEC_PROPS, c_int]
    """Properties of the stream that gets decoded.

    Note: Deprecated.
    - encoding: unused.
    - decoding: set by libavcodec.
    """
    comptime FF_CODEC_PROPERTY_LOSSLESS = Int(1)
    comptime FF_CODEC_PROPERTY_CLOSED_CAPTIONS = Int(2)
    comptime FF_CODEC_PROPERTY_FILM_GRAIN = Int(4)

    var skip_loop_filter: AVDiscard.ENUM_DTYPE
    """Skip loop filtering for selected frames.
    - encoding: unused.
    - decoding: Set by user.
    """
    var skip_idct: AVDiscard.ENUM_DTYPE
    """Skip IDCT/dequantization for selected frames.
    - encoding: unused.
    - decoding: Set by user.
    """
    var skip_frame: AVDiscard.ENUM_DTYPE
    """Skip decoding for selected frames.
    - encoding: unused.
    - decoding: Set by user.
    """
    var skip_alpha: c_int
    """Skip processing alpha if supported by codec.
    Note that if the format uses pre-multiplied alpha (common with VP6,
    and recommended due to better video quality/compression)
    the image will look as if alpha-blended onto a black background.
    However for formats that do not use pre-multiplied alpha
    there might be serious artefacts (though e.g. libswscale currently
    assumes pre-multiplied alpha anyway).
    - decoding: set by user.
    - encoding: unused.
    """

    var skip_top: c_int
    """Number of macroblock rows at the top which are skipped.
    - encoding: unused.
    - decoding: Set by user.
    """
    var skip_bottom: c_int
    """Number of macroblock rows at the bottom which are skipped.
    - encoding: unused.
    - decoding: Set by user.
    """
    var lowres: c_int
    """Low resolution decoding, 1-> 1/2 size, 2->1/4 size
    - encoding: unused.
    - decoding: Set by user.
    """
    var codec_descriptor: UnsafePointer[AVCodecDescriptor, ImmutOrigin.external]
    """AVCodecDescriptor
    - encoding: unused.
    - decoding: set by libavcodec.
    """

    var sub_charenc: UnsafePointer[c_char, MutOrigin.external]
    """Character encoding of the input subtitles file.
    - decoding: set by user.
    - encoding: unused.
    """

    var sub_charenc_mode: c_int
    """Subtitles character encoding mode. Formats or codecs might be adjusting.
    this setting (if they are doing the conversion themselves for instance).
    - decoding: set by libavcodec.
    - encoding: unused.
    """
    comptime FF_SUB_CHARENC_MODE_DO_NOTHING = Int(-1)
    "do nothing (demuxer outputs a stream supposed to be already in UTF-8, or the codec is bitmap for instance)"
    comptime FF_SUB_CHARENC_MODE_AUTOMATIC = Int(0)
    "libavcodec will select the mode itself"
    comptime FF_SUB_CHARENC_MODE_PRE_DECODER = Int(1)
    "the AVPacket data needs to be recoded to UTF-8 before being fed to the decoder, requires iconv"
    comptime FF_SUB_CHARENC_MODE_IGNORE = Int(2)
    "neither convert the subtitles, nor check them for valid UTF-8"

    var subtitle_header_size: c_int
    """Header containing style information for text subtitles.
    For SUBTITLE_ASS subtitle type, it should contain the whole ASS
    [Script Info] and [V4+ Styles] section, plus the [Events] line and
    the Format line following. It shouldn't include any Dialogue line.

    - encoding: May be set by the caller before avcodec_open2() to an array
                allocated with the av_malloc() family of functions.
    - decoding: May be set by libavcodec in avcodec_open2().
    """
    var subtitle_header: UnsafePointer[c_uchar, MutOrigin.external]
    """Header containing style information for text subtitles."""

    var dump_separator: UnsafePointer[c_uchar, MutOrigin.external]
    """Dump format separator.
    can be ", " or "\n      " or anything else
    - encoding: Set by user.
    - decoding: Set by user.
    """
    var codec_whitelist: UnsafePointer[c_char, MutOrigin.external]
    """A comma (',') separated list of allowed decoders.
    If NULL then all are allowed
    - encoding: unused.
    - decoding: set by user.
    """

    var coded_side_data: UnsafePointer[AVPacketSideData, MutOrigin.external]
    """Additional data associated with the entire coded stream.
    - decoding: may be set by user before calling avcodec_open2().
    - encoding: may be set by libavcodec after avcodec_open2().
    """
    var nb_coded_side_data: c_int
    """Number of additional data associated with the entire coded stream."""

    var export_side_data: c_int
    """Bit set of AV_CODEC_EXPORT_DATA_* flags, which affects the kind of
    metadata exported in frame, packet, or coded stream side data by
    decoders and encoders.

    - decoding: set by user.
    - encoding: set by user.
    """

    var max_pixels: c_long_long
    """The number of pixels per image to maximally accept.
    - decoding: set by user.
    - encoding: set by user.
    """

    var apply_cropping: c_int
    """Video decoding only. Certain video codecs support cropping, meaning that
    only a sub-rectangle of the decoded frame is intended for display.  This
    option controls how cropping is handled by libavcodec.

    When set to 1 (the default), libavcodec will apply cropping internally.
    I.e. it will modify the output frame width/height fields and offset the
    data pointers (only by as much as possible while preserving alignment, or
    by the full amount if the AV_CODEC_FLAG_UNALIGNED flag is set) so that
    the frames output by the decoder refer only to the cropped area. The
    crop_* fields of the output frames will be zero.

    When set to 0, the width/height fields of the output frames will be set
    to the coded dimensions and the crop_* fields will describe the cropping
    rectangle. Applying the cropping is left to the caller.

    @warning When hardware acceleration with opaque output frames is used,
    libavcodec is unable to apply cropping from the top/left border.

    @note when this option is set to zero, the width/height fields of the
    AVCodecContext and output AVFrames have different meanings. The codec
    context fields store display dimensions (with the coded dimensions in
    coded_width/height), while the frame fields store the coded dimensions
    (with the display dimensions being determined by the crop_* fields).
    - decoding: set by user
    - encoding: unused
    """

    var discard_damaged_percentage: c_int
    """The percentage of damaged samples to discard a frame.
    - decoding: set by user.
    - encoding: unused.
    """

    var max_samples: c_long_long
    """The number of samples per frame to maximally accept.
    - decoding: set by user.
    - encoding: set by user.
    """

    var get_encode_buffer: fn (
        s: UnsafePointer[AVCodecContext, MutOrigin.external],
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        flags: c_int,
    ) -> c_int
    """This callback is called at the beginning of each packet to get a data
    buffer for it.

    The following field will be set in the packet before this callback is
    called:
    - size
    This callback must use the above value to calculate the required buffer size,
    which must padded by at least AV_INPUT_BUFFER_PADDING_SIZE bytes.

    In some specific cases, the encoder may not use the entire buffer allocated by this
    callback. This will be reflected in the size value in the packet once returned by
    avcodec_receive_packet().

    This callback must fill the following fields in the packet:
    - data: alignment requirements for AVPacket apply, if any. Some architectures and
    encoders may benefit from having aligned data.
    - buf: must contain a pointer to an AVBufferRef structure. The packet's
    data pointer must be contained in it. See: av_buffer_create(), av_buffer_alloc(),
    and av_buffer_ref().

    If AV_CODEC_CAP_DR1 is not set then get_encode_buffer() must call
    avcodec_default_get_encode_buffer() instead of providing a buffer allocated by
    some other means.

    The flags field may contain a combination of AV_GET_ENCODE_BUFFER_FLAG_ flags.
    They may be used for example to hint what use the buffer may get after being
    created.
    Implementations of this callback may ignore flags they don't understand.
    If AV_GET_ENCODE_BUFFER_FLAG_REF is set in flags then the packet may be reused
    (read and/or written to if it is writable) later by libavcodec.

    This callback must be thread-safe, as when frame threading is used, it may
    be called from multiple threads simultaneously.

    @see avcodec_default_get_encode_buffer()

    - encoding: Set by libavcodec, user can override.
    - decoding: unused
    """

    var frame_num: c_long_long
    """Frame counter, set by libavcodec.
    - decoding: total number of frames returned from the decoder so far.
    - encoding: total number of frames passed to the encoder so far.
    - note: the counter is not incremented if encoding/decoding resulted in
    an error.
    """

    var side_data_prefer_packet: UnsafePointer[c_int, MutOrigin.external]
    """
    Decoding only. May be set by the caller before avcodec_open2() to an
    av_malloc()'ed array (or via AVOptions). Owned and freed by the decoder
    afterwards.

    Side data attached to decoded frames may come from several sources:
    1. coded_side_data, which the decoder will for certain types translate
        from packet-type to frame-type and attach to frames;
    2. side data attached to an AVPacket sent for decoding (same
        considerations as above);
    3. extracted from the coded bytestream.
    The first two cases are supplied by the caller and typically come from a
    container.

    This array configures decoder behaviour in cases when side data of the
    same type is present both in the coded bytestream and in the
    user-supplied side data (items 1. and 2. above). In all cases, at most
    one instance of each side data type will be attached to output frames. By
    default it will be the bytestream side data. Adding an
    AVPacketSideDataType value to this array will flip the preference for
    this type, thus making the decoder prefer user-supplied side data over
    bytestream. In case side data of the same type is present both in
    coded_data and attacked to a packet, the packet instance always has
    priority.

    The array may also contain a single -1, in which case the preference is
    switched for all side data types.
    """

    var nb_side_data_prefer_packet: c_uint
    """Number of entries in side_data_prefer_packet."""

    var decoded_side_data: UnsafePointer[AVFrameSideData, MutOrigin.external]
    """Array containing static side data, such as HDR10 CLL / MDCV structures.
    Side data entries should be allocated by usage of helpers defined in
    libavutil/frame.h.

    - encoding: may be set by user before calling avcodec_open2() for
    encoder configuration. Afterwards owned and freed by the encoder.
    - decoding: may be set by libavcodec in avcodec_open2().
    """
    var nb_decoded_side_data: c_int
    """Number of entries in decoded_side_data."""

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["coded_side_data"](self.coded_side_data)
        struct_writer.write_field["nb_coded_side_data"](self.nb_coded_side_data)
        struct_writer.write_field["export_side_data"](self.export_side_data)
        struct_writer.write_field["max_pixels"](self.max_pixels)
        struct_writer.write_field["apply_cropping"](self.apply_cropping)
        struct_writer.write_field["discard_damaged_percentage"](
            self.discard_damaged_percentage
        )
        struct_writer.write_field["max_samples"](self.max_samples)
        struct_writer.write_field["get_encode_buffer"]("function pointer")
        struct_writer.write_field["frame_num"](self.frame_num)
        struct_writer.write_field["side_data_prefer_packet"](
            self.side_data_prefer_packet
        )
        struct_writer.write_field["nb_side_data_prefer_packet"](
            self.nb_side_data_prefer_packet
        )
        struct_writer.write_field["decoded_side_data"](self.decoded_side_data)
        struct_writer.write_field["nb_decoded_side_data"](
            self.nb_decoded_side_data
        )
        struct_writer.write_field["get_format"]("function pointer")
        struct_writer.write_field["qcompress"](self.qcompress)
        struct_writer.write_field["qblur"](self.qblur)
        struct_writer.write_field["qmin"](self.qmin)
        struct_writer.write_field["qmax"](self.qmax)
        struct_writer.write_field["qblur"](self.qblur)
        struct_writer.write_field["qmin"](self.qmin)
        struct_writer.write_field["qmax"](self.qmax)
        struct_writer.write_field["max_b_frames"](self.max_b_frames)
        struct_writer.write_field["b_quant_factor"](self.b_quant_factor)
        struct_writer.write_field["b_quant_offset"](self.b_quant_offset)
        struct_writer.write_field["i_quant_factor"](self.i_quant_factor)
        struct_writer.write_field["i_quant_offset"](self.i_quant_offset)
        struct_writer.write_field["lumi_masking"](self.lumi_masking)
        struct_writer.write_field["skip_idct"](self.skip_idct)
        struct_writer.write_field["skip_loop_filter"](self.skip_loop_filter)
        struct_writer.write_field["skip_frame"](self.skip_frame)
        struct_writer.write_field["skip_idct"](self.skip_idct)
        struct_writer.write_field["skip_loop_filter"](self.skip_loop_filter)
        struct_writer.write_field["temporal_cplx_masking"](
            self.temporal_cplx_masking
        )
        struct_writer.write_field["spatial_cplx_masking"](
            self.spatial_cplx_masking
        )
        struct_writer.write_field["p_masking"](self.p_masking)
        struct_writer.write_field["dark_masking"](self.dark_masking)
        struct_writer.write_field["nsse_weight"](self.nsse_weight)
        struct_writer.write_field["me_cmp"](self.me_cmp)
        struct_writer.write_field["me_sub_cmp"](self.me_sub_cmp)
        struct_writer.write_field["mb_cmp"](self.mb_cmp)
        struct_writer.write_field["ildct_cmp"](self.ildct_cmp)
        struct_writer.write_field["dia_size"](self.dia_size)
        struct_writer.write_field["last_predictor_count"](
            self.last_predictor_count
        )
        struct_writer.write_field["pre_dia_size"](self.pre_dia_size)
        struct_writer.write_field["me_subpel_quality"](self.me_subpel_quality)
        struct_writer.write_field["me_range"](self.me_range)
        struct_writer.write_field["mb_decision"](self.mb_decision)
        struct_writer.write_field["intra_matrix"](self.intra_matrix)
        struct_writer.write_field["inter_matrix"](self.inter_matrix)
        struct_writer.write_field["chroma_intra_matrix"](
            self.chroma_intra_matrix
        )
        struct_writer.write_field["intra_dc_precision"](self.intra_dc_precision)
        struct_writer.write_field["extra_hw_frames"](self.extra_hw_frames)
        struct_writer.write_field["error"](
            "StaticTuple[c_ulong_long, AVFrame.AV_NUM_DATA_POINTERS]"
        )
        struct_writer.write_field["dct_algo"](self.dct_algo)
        struct_writer.write_field["thread_count"](self.thread_count)
        struct_writer.write_field["idct_algo"](self.idct_algo)


@fieldwise_init
@register_passable("trivial")
struct AVCodecParserContext(StructWritable):
    comptime AV_PARSER_PTS_NB = Int(4)
    comptime PARSER_FLAG_COMPLETE_FRAMES = Int(0x0001)
    comptime PARSER_FLAG_ONCE = Int(0x0002)
    comptime PARSER_FLAG_FETCHED_OFFSET = Int(0x0004)
    comptime PARSER_FLAG_USE_CODEC_TS = Int(0x1000)

    var priv_data: OpaquePointer[MutOrigin.external]
    "Private data for use by the parser."
    var parser: UnsafePointer[AVCodecParser, origin = ImmutOrigin.external]
    "The parser."
    var frame_offset: c_long_long
    "Offset of the current frame."
    var cur_offset: c_long_long
    "Current offset. (incremented by each av_parser_parse())."
    var next_frame_offset: c_long_long
    "Offset of the next frame."
    # Video info

    # NOTE: This is a note in the original codebase taking about moving this
    # field back to AVCodecContext.
    #  XXX: Put it back in AVCodecContext
    var pict_type: c_int
    """This field is used for proper frame duration computation in lavf.
    It signals, how much longer the frame duration of the current frame
    is compared to normal frame duration.

    frame_duration = (1 + repeat_pict) * time_base

    It is used by codecs like H.264 to display telecined material.
    """
    # XXX: Put it back in AVCodecContext
    var repeat_pict: c_int
    "Unclear what this field is for."
    var pts: c_long_long
    "PTS of the current frame."
    var dts: c_long_long
    "DTS of the current frame."
    # Private data
    var last_pts: c_long_long
    "Last PTS."
    var last_dts: c_long_long
    "Last DTS."

    var cur_frame_start_index: c_int
    "Index of the current frame start."
    var cur_frame_offset: StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]
    "Offset of the current frame."
    var cur_frame_pts: StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]
    "PTS of the current frame."
    var cur_frame_dts: StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]
    "DTS of the current frame."
    var flags: c_int
    "Flags."
    var offset: c_long_long
    "Byte offset from starting packet start."
    var cur_frame_end: StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]
    "Byte position of currently parsed frame in stream."
    var key_frame: c_int
    """Set by parser to 1 for key frames and 0 for non-key frames.

    It is initialized to -1, so if the parser doesn't set this flag,
    old-style fallback using AV_PICTURE_TYPE_I picture type as key frames
    will be used.
    """
    # Timestamp generation support:
    var dts_sync_point: c_int
    """Synchronization point for start of timestamp generation.

    Set to >0 for sync point, 0 for no sync point and <0 for undefined
    (default).

    For example, this corresponds to presence of H.264 buffering period
    SEI message.
    """
    var dts_ref_dts_delta: c_int
    """Offset of the current timestamp against last timestamp sync point in
    units of AVCodecContext.time_base.

    Set to INT_MIN when dts_sync_point unused. Otherwise, it must
    contain a valid timestamp offset.

    Note that the timestamp of sync point has usually a nonzero
    dts_ref_dts_delta, which refers to the previous sync point. Offset of
    the next frame after timestamp sync point will be usually 1.

    For example, this corresponds to H.264 cpb_removal_delay.
    """
    var pts_dts_delta: c_int
    """Presentation delay of current frame in units of AVCodecContext.time_base.

    Set to INT_MIN when dts_sync_point unused. Otherwise, it must
    contain valid non-negative timestamp delta (presentation time of a frame
    must not lie in the past).

    This delay represents the difference between decoding and presentation
    time of the frame.

    For example, this corresponds to H.264 dpb_output_delay.
    """
    var cur_frame_pos: StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]
    """Position of the packet in file.

    Analogous to cur_frame_pts/dts
    """
    var pos: c_long_long
    """Byte position of currently parsed frame in stream."""
    var last_pos: c_long_long
    """Previous frame byte position."""
    var duration: c_int
    """Duration of the current frame.

    For audio, this is in units of 1 / AVCodecContext.sample_rate.
    For all other types, this is in units of AVCodecContext.time_base.
    """
    var field_order: AVFieldOrder.ENUM_DTYPE

    var picture_structure: AVPictureStructure.ENUM_DTYPE
    """Indicate whether a picture is coded as a frame, top field or bottom field.

    For example, H.264 field_pic_flag equal to 0 corresponds to
    AV_PICTURE_STRUCTURE_FRAME. An H.264 picture with field_pic_flag
    equal to 1 and bottom_field_flag equal to 0 corresponds to
    AV_PICTURE_STRUCTURE_TOP_FIELD.
    """
    var output_picture_number: c_int
    """Picture number incremented in presentation or output order.
    This field may be reinitialized at the first picture of a new sequence.

    For example, this corresponds to H.264 PicOrderCnt.
    """
    var width: c_int
    "Dimensions of the decoded video intended for presentation."
    var height: c_int
    "Dimensions of the decoded video intended for presentation."

    var coded_width: c_int
    "Dimensions of the coded video."
    var coded_height: c_int
    "Dimensions of the coded video."
    var format: c_int
    """The format of the coded data, corresponds to enum AVPixelFormat for video
    and for enum AVSampleFormat for audio.

    Note that a decoder can have considerable freedom in how exactly it
    decodes the data, so the format reported here might be different from the
    one returned by a decoder.
    """

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["priv_data"](self.priv_data)
        struct_writer.write_field["parser"](self.parser)
        struct_writer.write_field["frame_offset"](self.frame_offset)
        struct_writer.write_field["cur_offset"](self.cur_offset)
        struct_writer.write_field["next_frame_offset"](self.next_frame_offset)
        struct_writer.write_field["pict_type"](self.pict_type)
        struct_writer.write_field["repeat_pict"](self.repeat_pict)
        struct_writer.write_field["pts"](self.pts)
        struct_writer.write_field["dts"](self.dts)
        struct_writer.write_field["last_pts"](self.last_pts)
        struct_writer.write_field["last_dts"](self.last_dts)
        struct_writer.write_field["cur_frame_start_index"](
            self.cur_frame_start_index
        )
        struct_writer.write_field["cur_frame_offset"](
            "StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]"
        )
        struct_writer.write_field["cur_frame_pts"](
            "StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]"
        )
        struct_writer.write_field["cur_frame_dts"](
            "StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]"
        )
        struct_writer.write_field["flags"](self.flags)
        struct_writer.write_field["offset"](self.offset)
        struct_writer.write_field["cur_frame_end"](
            "StaticTuple[c_long_long, Self.AV_PARSER_PTS_NB]"
        )
        struct_writer.write_field["key_frame"](self.key_frame)
        struct_writer.write_field["dts_sync_point"](self.dts_sync_point)
        struct_writer.write_field["dts_ref_dts_delta"](self.dts_ref_dts_delta)


@fieldwise_init
@register_passable("trivial")
struct AVCodecParser(StructWritable):
    var codec_ids: StaticTuple[c_int, 7]
    "Several codec IDs are permitted."
    var priv_data_size: c_int
    "Size of the private data."
    var parser_init: fn (
        s: UnsafePointer[AVCodecParserContext, MutOrigin.external]
    ) -> c_int
    "Parser initialization function."
    var parser_parse: fn (
        s: UnsafePointer[AVCodecParserContext, MutOrigin.external],
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        poutbuf: UnsafePointer[
            UnsafePointer[c_char, ImmutOrigin.external], ImmutOrigin.external
        ],
        poutbuf_size: UnsafePointer[c_int, ImmutOrigin.external],
        buf: UnsafePointer[c_char, ImmutOrigin.external],
        buf_size: c_int,
    ) -> c_int
    """This callback never returns an error, a negative value means that
    the frame start was in a previous packet.
    """
    var parser_close: fn (
        s: UnsafePointer[AVCodecParserContext, MutOrigin.external]
    ) -> NoneType
    "Parser close function."
    var split: fn (
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        buf: UnsafePointer[c_char, ImmutOrigin.external],
        buf_size: c_int,
    ) -> c_int
    "Parser split function."

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["codec_ids"]("StaticTuple[c_int, 7]")
        struct_writer.write_field["priv_data_size"](self.priv_data_size)
        struct_writer.write_field["parser_init"]("function pointer")
        struct_writer.write_field["parser_parse"]("function pointer")
        struct_writer.write_field["parser_close"]("function pointer")
        struct_writer.write_field["split"]("function pointer")


comptime _av_parser_init = ExternalFunction[
    "av_parser_init",
    fn (
        codec_id: AVCodecID.ENUM_DTYPE,
    ) -> UnsafePointer[AVCodecParserContext, MutOrigin.external],
]
