"""
Reference: 
https://www.ffmpeg.org/doxygen/8.0/avcodec_8h.html
"""

from sys.ffi import (
    c_int,
    c_float,
    c_char,
    c_long_long,
    c_uchar,
    c_ushort,
    c_ulong_long,
    c_uint,
    c_size_t,
)
from ash_dynamics.primitives._clib import (
    StructWritable,
    StructWriter,
    ExternalFunction,
    TrivialOptionalField,
)
from reflection import get_type_name
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.rational import AVRational
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
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket, AVPacketSideData
from ash_dynamics.ffmpeg.avutil.frame import AVFrameSideData
from ash_dynamics.ffmpeg.avcodec.codec_desc import AVCodecDescriptor
from utils import StaticTuple
from ash_dynamics.ffmpeg.avcodec.codec_par import AVCodecParameters


@fieldwise_init
@register_passable("trivial")
struct RcOverride(StructWritable):
    var start_frame: c_int
    var end_frame: c_int
    var qscale: c_int
    "Quality_factor should be used if qscale is 0."
    var quality_factor: c_float

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["start_frame"](self.start_frame)
        struct_writer.write_field["end_frame"](self.end_frame)
        struct_writer.write_field["qscale"](self.qscale)
        struct_writer.write_field["quality_factor"](self.quality_factor)


########################################################
####### Encoding support section #######################
########################################################

comptime AV_CODEC_FLAG_UNALIGNED = c_int(1 << 0)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gaa52d62f5dbfc4529388f0454ae671359"
comptime AV_CODEC_FLAG_QSCALE = c_int(1 << 1)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga70edda5debd8433d29ec1b9eed57422b"
comptime AV_CODEC_FLAG_4MV = c_int(1 << 2)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gac66356d3e9a7ae8b2b29e14402367649"
comptime AV_CODEC_FLAG_OUTPUT_CORRUPT = c_int(1 << 3)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gad406c2774f1334e474256c7f04e1345e"
comptime AV_CODEC_FLAG_QPEL = c_int(1 << 4)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga0e51f9240c85bc00f9dd684f020e2150"
comptime AV_CODEC_FLAG_RECON_FRAME = c_int(1 << 6)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gaff2b2fa4b372eae1690a0258728ea84a"
comptime AV_CODEC_FLAG_COPY_OPAQUE = c_int(1 << 7)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gaf13081b482792279ac9d243c547baa76"

comptime AV_CODEC_FLAG_FRAME_DURATION = c_int(1 << 8)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga7909a428549f5770dfc42947f20d5c86"

comptime AV_CODEC_FLAG_PASS1 = c_int(1 << 9)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga81bc0a84e8866ecff68e6d8a82781936"
comptime AV_CODEC_FLAG_PASS2 = c_int(1 << 10)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga234d986d58043b694dd518e2312b4cbe"
comptime AV_CODEC_FLAG_LOOP_FILTER = c_int(1 << 11)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga8460d3e1778f861cfc074df91e7100b6"
comptime AV_CODEC_FLAG_GRAY = c_int(1 << 13)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga752fa4b8beeb25c9e8f0014a4aa622b4"
comptime AV_CODEC_FLAG_PSNR = c_int(1 << 15)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gac14e43b675c9a342f9c7275553d6f533"
comptime AV_CODEC_FLAG_INTERLACED_DCT = c_int(1 << 18)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga502225f65e2092fbc45945247892cb0f"
comptime AV_CODEC_FLAG_LOW_DELAY = c_int(1 << 19)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gaa90f89265adba401ebe80380517fe613"
comptime AV_CODEC_FLAG_GLOBAL_HEADER = c_int(1 << 22)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga9ed82634c59b339786575827c47a8f68"
comptime AV_CODEC_FLAG_BITEXACT = c_int(1 << 23)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga17ae68044f725fd5ba26c54162b96490"
# Fx: Flag for H.263+ extra options
comptime AV_CODEC_FLAG_AC_PRED = c_int(1 << 24)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga78187a415454abc849d4ca0682ab420a"
comptime AV_CODEC_FLAG_INTERLACED_ME = c_int(1 << 29)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga936c6ae1b3d24d7504f0a9aea1a24c74"
comptime AV_CODEC_FLAG_CLOSED_GOP = c_int(1 << 31)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga4444b40e467199423bba5cf5ac791c49"
comptime AV_CODEC_FLAG2_FAST = c_int(1 << 0)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga1a6a486e686ab6c581ffffcb88cb31b3"
comptime AV_CODEC_FLAG2_NO_OUTPUT = c_int(1 << 2)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gae85064498366d2dc5e86b0a4f3c64617"
comptime AV_CODEC_FLAG2_LOCAL_HEADER = c_int(1 << 3)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga39082b60bece88ef2fa64741aa2b5ff4"
comptime AV_CODEC_FLAG2_CHUNKS = c_int(1 << 15)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gabc5592664ff0686def0c2b41cfcc322d"
comptime AV_CODEC_FLAG2_IGNORE_CROP = c_int(1 << 16)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gaa4110d30a0542c7d0198c46ab87e7249"
comptime AV_CODEC_FLAG2_SHOW_ALL = c_int(1 << 22)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga2e513617bb427d5f6ed01f841cb807cf"
comptime AV_CODEC_FLAG2_EXPORT_MVS = c_int(1 << 28)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga33ff0b9183c222b2c509f34d1516969f"
comptime AV_CODEC_FLAG2_SKIP_MANUAL = c_int(1 << 29)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gaee0f0c90c93f0689a1e679cb6690a9e8"
comptime AV_CODEC_FLAG2_RO_FLUSH_NOOP = c_int(1 << 30)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga01e073f9e21f52cb1e0db1555e7c9263"

# TODO: The header has it as 1U << 31. Whats the difference?????
comptime AV_CODEC_FLAG2_ICC_PROFILES = c_int(1 << 31)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga244dfe37ae3271026fa741ef1ce198d6"

########################################################
# Before intializing AVCodecContext, these flags can be set in
# AVCodecContext.export_side_data.
########################################################

comptime AV_CODEC_EXPORT_DATA_MVS = c_int(1 << 0)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gace654396302da34e598d4192403326ea"
comptime AV_CODEC_EXPORT_DATA_PRFT = c_int(1 << 1)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga3f723db5c7db407c53a61ddfed1f55d8"
comptime AV_CODEC_EXPORT_DATA_VIDEO_ENC_PARAMS = c_int(1 << 2)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#gaf2ee3be17d31e2e6ef8b8096e7789ec5"
comptime AV_CODEC_EXPORT_DATA_FILM_GRAIN = c_int(1 << 3)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga8aeef83bf8b28d1e06d67b50c9d3a994"
comptime AV_CODEC_EXPORT_DATA_ENHANCEMENTS = c_int(1 << 4)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga4e1603e9861297330284d530796a14e1"

comptime AV_GET_BUFFER_FLAG_REF = c_int(1 << 0)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga6b4950dd3320e524f648799927f256a7"
comptime AV_GET_ENCODE_BUFFER_FLAG_REF = c_int(1 << 0)
"https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga6fd5dafb54fc47d56b12722ca848802f"

#########################################################
########## Main external API structure ##################
#########################################################

comptime FF_API_CODEC_PROPS = False


comptime AVCodecInternal = OpaquePointer[MutOrigin.external]
"A private non-codec-specific opaque context intended to contain internal data"


@register_passable("trivial")
@fieldwise_init
struct AVCodecContext(StructWritable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html"

    var av_class: UnsafePointer[AVClass, origin = ImmutOrigin.external]
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a90622d3af2a9abba986a1c9f7ca21b16"
    var log_level_offset: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a7f9e4467c3394228bc3c9f308a42303c"
    var codec_type: AVMediaType.ENUM_DTYPE
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a3f99ca3115c44e6d7772c9384faf15e6"
    var codec: UnsafePointer[AVCodec, origin = ImmutOrigin.external]
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a6e606effa68724cae2ef5cc05f7fd9cb"
    var codec_id: AVCodecID.ENUM_DTYPE
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#adc5f65d6099fd8339c1580c091777223"

    var codec_tag: c_ushort
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a2c974557671dd459674b170c5e64d79a"
    var priv_data: OpaquePointer[MutOrigin.external]
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#af3379123060ad8cc9c321c29af4f8360"

    var internal: UnsafePointer[AVCodecInternal, origin = ImmutOrigin.external]
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#aeffc0091dc3138015b53107c8ffb04af"
    var opaque: OpaquePointer[MutOrigin.external]
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#aab9c4495feeedde28c1e908d76b7b9f5"
    var bit_rate: c_long_long
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a6b53fda85ad61baa345edbd96cb8a33c"
    var flags: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#abb01e291550fa3fb96188af4d494587e"
    var flags2: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a1944f9a4f8f2e123c087e1fe7613d571"

    var extradata: UnsafePointer[c_char, ImmutOrigin.external]
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#abe964316aaaa61967b012efdcced79c4"
    var extradata_size: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#ae246ca7a1c72c151891ed0599e8dbfba"

    var time_base: AVRational
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#ab7bfeb9fa5840aac090e2b0bd0ef7589"
    var pkt_timebase: AVRational
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a33a289c990bc3fbcad01c4a09f34da38"
    var framerate: AVRational
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a4d08b297e97eefd66c714df4fff493c8"
    var delay: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a948993adfdfcd64b81dad1151fe50f33"
    # Video only
    var width: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a0d8f46461754e8abea0847dcbc41b956"
    var height: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a0449afd803eb107bd4dbc8b5ea22e363"

    var coded_width: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#ae3c157e97ff15d46e898a538c6bc7f09"
    var coded_height: c_int
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#ab2ebb76836ef4cd9822b5077c17b33d0"

    var sample_aspect_ratio: AVRational
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a5252d34fbce300228d4dbda19a8c3293"
    var pix_fmt: AVPixelFormat.ENUM_DTYPE
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a0425c77b3d06d71e5db88b1d7e1b37f2"
    var sw_pix_fmt: AVPixelFormat.ENUM_DTYPE
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a1ff9829b01eeb0063c21d039dcc5900d"
    var color_primaries: AVColorPrimaries.ENUM_DTYPE
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a3a41b3e5bde23b877799f6e72dac8ef3"
    var color_trc: AVColorTransferCharacteristic.ENUM_DTYPE
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#ab649e8c599f5a0e2a30448e67a36deb6"
    var color_space: AVColorSpace.ENUM_DTYPE
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a8cd8caa7d40319324ce3d879a2edbd9f"
    var color_range: AVColorRange.ENUM_DTYPE
    "https://www.ffmpeg.org/doxygen/8.0/structAVCodecContext.html#a255bf7100a4ba6dcb6ee5d87740a4f35"
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
    """Do nothing (demuxer outputs a stream supposed to be already in UTF-8, or 
    the codec is bitmap for instance)."""
    comptime FF_SUB_CHARENC_MODE_AUTOMATIC = Int(0)
    "Libavcodec will select the mode itself."
    comptime FF_SUB_CHARENC_MODE_PRE_DECODER = Int(1)
    """The AVPacket data needs to be recoded to UTF-8 before being fed to the 
    decoder, requires iconv."""
    comptime FF_SUB_CHARENC_MODE_IGNORE = Int(2)
    "Neither convert the subtitles, nor check them for valid UTF-8."

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
        var sw = StructWriter[Self](writer, indent=indent)
        sw.write_field["av_class"](self.av_class)
        sw.write_field["codec"](self.codec)
        sw.write_field["priv_data"](self.priv_data)
        sw.write_field["internal"](self.internal)
        sw.write_field["opaque"](self.opaque)
        sw.write_field["extradata"](self.extradata)
        sw.write_field["draw_horiz_band"](
            UnsafePointer(to=self.draw_horiz_band)
        )
        sw.write_field["intra_matrix"](self.intra_matrix)
        sw.write_field["inter_matrix"](self.inter_matrix)
        sw.write_field["chroma_intra_matrix"](self.chroma_intra_matrix)
        sw.write_field["rc_override"](self.rc_override)
        sw.write_field["stats_out"](self.stats_out)
        sw.write_field["stats_in"](self.stats_in)
        sw.write_field["hwaccel"](self.hwaccel)
        sw.write_field["hwaccel_context"](self.hwaccel_context)
        sw.write_field["hw_frames_ctx"](self.hw_frames_ctx)
        sw.write_field["hw_device_ctx"](self.hw_device_ctx)
        sw.write_field["execute"](UnsafePointer(to=self.execute))
        sw.write_field["execute2"](UnsafePointer(to=self.execute2))
        sw.write_field["codec_descriptor"](self.codec_descriptor)
        sw.write_field["sub_charenc"](self.sub_charenc)
        sw.write_field["sub_charenc_mode"](self.sub_charenc_mode)
        sw.write_field["subtitle_header_size"](self.subtitle_header_size)
        sw.write_field["subtitle_header"](self.subtitle_header)
        sw.write_field["dump_separator"](self.dump_separator)
        sw.write_field["codec_whitelist"](self.codec_whitelist)
        sw.write_field["coded_side_data"](self.coded_side_data)
        sw.write_field["nb_coded_side_data"](self.nb_coded_side_data)
        sw.write_field["export_side_data"](self.export_side_data)
        sw.write_field["max_pixels"](self.max_pixels)
        sw.write_field["apply_cropping"](self.apply_cropping)
        sw.write_field["discard_damaged_percentage"](
            self.discard_damaged_percentage
        )
        sw.write_field["max_samples"](self.max_samples)
        # sw.write_field["get_encode_buffer"](self.get_encode_buffer)
        sw.write_field["frame_num"](self.frame_num)
        sw.write_field["side_data_prefer_packet"](self.side_data_prefer_packet)
        sw.write_field["nb_side_data_prefer_packet"](
            self.nb_side_data_prefer_packet
        )
        sw.write_field["decoded_side_data"](self.decoded_side_data)
        sw.write_field["nb_decoded_side_data"](self.nb_decoded_side_data)
        sw.write_field["qcompress"](self.qcompress)
        sw.write_field["qblur"](self.qblur)
        sw.write_field["qmin"](self.qmin)
        sw.write_field["qmax"](self.qmax)
        sw.write_field["qblur"](self.qblur)
        sw.write_field["qmin"](self.qmin)
        sw.write_field["qmax"](self.qmax)
        sw.write_field["get_format"](UnsafePointer(to=self.get_format))
        sw.write_field["max_b_frames"](self.max_b_frames)
        sw.write_field["b_quant_factor"](self.b_quant_factor)
        sw.write_field["b_quant_offset"](self.b_quant_offset)
        sw.write_field["i_quant_factor"](self.i_quant_factor)
        sw.write_field["i_quant_offset"](self.i_quant_offset)
        sw.write_field["lumi_masking"](self.lumi_masking)
        sw.write_field["skip_idct"](self.skip_idct)
        sw.write_field["skip_loop_filter"](self.skip_loop_filter)
        sw.write_field["skip_frame"](self.skip_frame)
        sw.write_field["skip_idct"](self.skip_idct)
        sw.write_field["skip_loop_filter"](self.skip_loop_filter)
        sw.write_field["temporal_cplx_masking"](self.temporal_cplx_masking)
        sw.write_field["spatial_cplx_masking"](self.spatial_cplx_masking)
        sw.write_field["p_masking"](self.p_masking)
        sw.write_field["dark_masking"](self.dark_masking)
        sw.write_field["nsse_weight"](self.nsse_weight)
        sw.write_field["me_cmp"](self.me_cmp)
        sw.write_field["me_sub_cmp"](self.me_sub_cmp)
        sw.write_field["mb_cmp"](self.mb_cmp)
        sw.write_field["ildct_cmp"](self.ildct_cmp)
        sw.write_field["dia_size"](self.dia_size)
        sw.write_field["last_predictor_count"](self.last_predictor_count)
        sw.write_field["pre_dia_size"](self.pre_dia_size)
        sw.write_field["me_subpel_quality"](self.me_subpel_quality)
        sw.write_field["me_range"](self.me_range)
        sw.write_field["mb_decision"](self.mb_decision)
        sw.write_field["intra_matrix"](self.intra_matrix)
        sw.write_field["inter_matrix"](self.inter_matrix)
        sw.write_field["chroma_intra_matrix"](self.chroma_intra_matrix)
        sw.write_field["intra_dc_precision"](self.intra_dc_precision)
        sw.write_field["extra_hw_frames"](self.extra_hw_frames)
        sw.write_field["error"](
            "StaticTuple[c_ulong_long, AVFrame.AV_NUM_DATA_POINTERS]"
        )
        sw.write_field["dct_algo"](self.dct_algo)
        sw.write_field["thread_count"](self.thread_count)
        sw.write_field["idct_algo"](self.idct_algo)


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


comptime AV_HWACCEL_CODEC_CAP_EXPERIMENTAL = c_int(0x0200)
"""HWAccel is experimental and is thus avoided in favor of non experimental
codecs"""
comptime AV_HWACCEL_FLAG_IGNORE_LEVEL = c_int(1 << 0)
"""Hardware acceleration should be used for decoding even if the codec level
used is unknown or higher than the maximum supported level reported by the
hardware driver.

It's generally a good idea to pass this flag unless you have a specific
reason not to, as hardware tends to under-report supported levels.
"""

comptime AV_HWACCEL_FLAG_ALLOW_HIGH_DEPTH = c_int(1 << 1)
"""Hardware acceleration can output YUV pixel formats with a different chroma
sampling than 4:2:0 and/or other than 8 bits per component.
"""

comptime AV_HWACCEL_FLAG_ALLOW_PROFILE_MISMATCH = c_int(1 << 2)
"""Hardware acceleration should still be attempted for decoding when the
codec profile does not match the reported capabilities of the hardware.

For example, this can be used to try to decode baseline profile H.264
streams in hardware - it will often succeed, because many streams marked
as baseline profile actually conform to constrained baseline profile.

@warning If the stream is actually not supported then the behaviour is
          undefined, and may include returning entirely incorrect output
          while indicating success.
"""

comptime AV_HWACCEL_FLAG_UNSAFE_OUTPUT = c_int(1 << 3)
"""Some hardware decoders (namely nvdec) can either output direct decoder
surfaces, or make an on-device copy and return said copy.
There is a hard limit on how many decoder surfaces there can be, and it
cannot be accurately guessed ahead of time.
For some processing chains, this can be okay, but others will run into the
limit and in turn produce very confusing errors that require fine tuning of
more or less obscure options by the user, or in extreme cases cannot be
resolved at all without inserting an avfilter that forces a copy.

Thus, the hwaccel will by default make a copy for safety and resilience.
If a users really wants to minimize the amount of copies, they can set this
flag and ensure their processing chain does not exhaust the surface pool.
"""


@fieldwise_init
@register_passable("trivial")
struct AVSubtitleType(StructWritable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime SUBTITLE_NONE = Self(0)
    comptime SUBTITLE_BITMAP = Self(1)
    """A bitmap, pict will be set"""
    comptime SUBTITLE_TEXT = Self(2)
    """Plain text, the text field must be set by the decoder and is
    authoritative. ass and pict fields may contain approximations."""
    comptime SUBTITLE_ASS = Self(3)
    """Formatted text, the ass field must be set by the decoder and is
    authoritative. pict and text fields may contain approximations."""

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["value"](self.value)


comptime AV_SUBTITLE_FLAG_FORCED = c_int(0x00000001)


@fieldwise_init
@register_passable("trivial")
struct AVSubtitleRect(StructWritable):
    var x: c_int
    """Top left corner  of pict, undefined when pict is not set."""
    var y: c_int
    """Top left corner  of pict, undefined when pict is not set."""
    var w: c_int
    """Width            of pict, undefined when pict is not set."""
    var h: c_int
    """Height           of pict, undefined when pict is not set."""
    var nb_colors: c_int
    """Number of colors in pict, undefined when pict is not set."""
    var data: UnsafePointer[c_uchar, MutOrigin.external]
    """Data+linesize for the bitmap of this subtitle. Can be set for text/ass 
    as well once they are rendered."""
    var linesize: StaticTuple[c_int, 4]
    """Linesize for the bitmap of this subtitle."""
    var flags: c_int
    """Flags for the subtitle. See AV_SUBTITLE_FLAG_FORCED."""
    var type: AVSubtitleType.ENUM_DTYPE
    """Type of the subtitle. See AVSubtitleType."""

    var text: UnsafePointer[c_char, MutOrigin.external]
    """0 terminated plain UTF-8 text."""
    var ass: UnsafePointer[c_char, MutOrigin.external]
    """0 terminated ASS/SSA compatible event line. The presentation of this
    is unaffected by the other values in this struct."""

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["x"](self.x)
        struct_writer.write_field["y"](self.y)
        struct_writer.write_field["w"](self.w)
        struct_writer.write_field["h"](self.h)
        struct_writer.write_field["nb_colors"](self.nb_colors)
        struct_writer.write_field["data"](self.data)
        struct_writer.write_field["linesize"]("StaticTuple[c_int, 4]")
        struct_writer.write_field["flags"](self.flags)
        struct_writer.write_field["type"](self.type)
        struct_writer.write_field["text"](self.text)
        struct_writer.write_field["ass"](self.ass)


@fieldwise_init
@register_passable("trivial")
struct AVSubtitle(StructWritable):
    var format: c_ushort
    """0 = graphics."""
    var start_display_time: c_uint
    """Relative to packet pts, in ms."""
    var end_display_time: c_uint
    """Relative to packet pts, in ms."""
    var num_rects: c_uint
    """Number of rectangles in the subtitle."""
    var rects: UnsafePointer[
        UnsafePointer[AVSubtitleRect, MutOrigin.external], MutOrigin.external
    ]
    """Rectangles in the subtitle. Must be freed with avsubtitle_free() by the caller."""
    var pts: c_long_long
    """Same as packet pts, in AV_TIME_BASE."""

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["format"](self.format)
        struct_writer.write_field["start_display_time"](self.start_display_time)
        struct_writer.write_field["end_display_time"](self.end_display_time)
        struct_writer.write_field["num_rects"](self.num_rects)
        struct_writer.write_field["rects"](self.rects)
        struct_writer.write_field["pts"](self.pts)


comptime avcodec_version = ExternalFunction[
    "avcodec_version",
    fn () -> c_int,
]
"""Return the LIBAVCODEC_VERSION_INT constant."""

comptime avcodec_configuration = ExternalFunction[
    "avcodec_configuration",
    fn () -> UnsafePointer[c_char, ImmutOrigin.external],
]
"""Return the libavcodec build-time configuration."""

comptime avcodec_license = ExternalFunction[
    "avcodec_license",
    fn () -> UnsafePointer[c_char, ImmutOrigin.external],
]
"""Return the libavcodec license."""

comptime avcodec_alloc_context3 = ExternalFunction[
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


comptime avcodec_free_context = ExternalFunction[
    "avcodec_free_context",
    fn (
        avctx: UnsafePointer[
            UnsafePointer[AVCodecContext, MutOrigin.external],
            MutOrigin.external,
        ],
    ),
]
"""Free the codec context and everything associated with it and write NULL to
the provided pointer."""


comptime avcodec_get_class = ExternalFunction[
    "avcodec_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]
"""Get the AVClass for AVCodecContext. It can be used in combination with
AV_OPT_SEARCH_FAKE_OBJ for examining options.

@see av_opt_find().
"""

comptime avcodec_get_subtitle_rect_class = ExternalFunction[
    "avcodec_get_subtitle_rect_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]
"""Get the AVClass for AVSubtitleRect. It can be used in combination with
AV_OPT_SEARCH_FAKE_OBJ for examining options.

@see av_opt_find().
"""


comptime avcodec_parameters_from_context = ExternalFunction[
    "avcodec_parameters_from_context",
    fn (
        par: UnsafePointer[AVCodecParameters, MutOrigin.external],
        codec: UnsafePointer[AVCodecContext, ImmutOrigin.external],
    ) -> c_int,
]
"""Fill the parameters struct based on the values from the supplied codec 
context. Any allocated fields in par are freed and replaced with duplicates 
of the corresponding fields in codec.

@return >= 0 on success, a negative AVERROR code on failure.
@see avcodec_parameters_to_context()
"""

comptime avcodec_parameters_to_context = ExternalFunction[
    "avcodec_parameters_to_context",
    fn (
        codec: UnsafePointer[AVCodecContext, MutOrigin.external],
        par: UnsafePointer[AVCodecParameters, ImmutOrigin.external],
    ) -> c_int,
]
"""Fill the codec context based on the values from the supplied codec parameters. 
Any allocated fields in codec are freed and replaced with duplicates of the 
corresponding fields in par.

@return >= 0 on success, a negative AVERROR code on failure.
@see avcodec_parameters_from_context()
"""

comptime avcodec_open2 = ExternalFunction[
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


comptime avsubtitle_free = ExternalFunction[
    "avsubtitle_free",
    fn (sub: UnsafePointer[AVSubtitle, MutOrigin.external],),
]
"""Free all allocated data in the given subtitle struct."""


comptime avcodec_default_get_buffer2 = ExternalFunction[
    "avcodec_default_get_buffer2",
    fn (
        s: UnsafePointer[AVCodecContext, MutOrigin.external],
        frame: UnsafePointer[AVFrame, MutOrigin.external],
        flags: c_int,
    ) -> c_int,
]
"""The default callback for AVCodecContext.get_buffer2(). It is made public so
it can be called by custom get_buffer2() implementations for decoders without 
AV_CODEC_CAP_DR1 set."""


comptime avcodec_default_get_encode_buffer = ExternalFunction[
    "avcodec_default_get_encode_buffer",
    fn (
        s: UnsafePointer[AVCodecContext, MutOrigin.external],
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        flags: c_int,
    ) -> c_int,
]
"""The default callback for AVCodecContext.get_encode_buffer(). It is made public so
it can be called by custom get_encode_buffer() implementations for encoders without 
AV_CODEC_CAP_DR1 set."""


comptime avcodec_align_dimensions = ExternalFunction[
    "avcodec_align_dimensions",
    fn (
        s: UnsafePointer[AVCodecContext, MutOrigin.external],
        width: UnsafePointer[c_int, MutOrigin.external],
        height: UnsafePointer[c_int, MutOrigin.external],
    ) -> c_int,
]
"""Modify width and height values so that they will result in a memory buffer 
that is acceptable for the codec if you do not use any horizontal padding.

May only be used if a codec with AV_CODEC_CAP_DR1 has been opened.
"""


comptime avcodec_align_dimensions2 = ExternalFunction[
    "avcodec_align_dimensions2",
    fn (
        s: UnsafePointer[AVCodecContext, MutOrigin.external],
        width: UnsafePointer[c_int, MutOrigin.external],
        height: UnsafePointer[c_int, MutOrigin.external],
        # TODO: linesize_align should be a StaticTuple[AV_NUM_DATA_POINTERS]
        # I think? Not sure how this plays
        # with passed in parameters.
        linesize_align: UnsafePointer[c_int, MutOrigin.external],
    ) -> c_int,
]
"""Modify width and height values so that they will result in a memory buffer 
that is acceptable for the codec if you also ensure that all line sizes are a 
multiple of the respective linesize_align[i].

May only be used if a codec with AV_CODEC_CAP_DR1 has been opened.
"""


comptime avcodec_decode_subtitle2 = ExternalFunction[
    "avcodec_decode_subtitle2",
    fn (
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        sub: UnsafePointer[AVSubtitle, MutOrigin.external],
        got_sub_ptr: UnsafePointer[c_int, MutOrigin.external],
        avpkt: UnsafePointer[AVPacket, ImmutOrigin.external],
    ) -> c_int,
]
"""Decode a subtitle message.

Return a negative value on error, otherwise return the number of bytes used.
If no subtitle could be decompressed, got_sub_ptr is zero.
Otherwise, the subtitle is stored in *sub.

Note that AV_CODEC_CAP_DR1 is not available for subtitle codecs. This is for
simplicity, because the performance difference is expected to be negligible
and reusing a get_buffer written for video codecs would probably perform badly
due to a potentially very different allocation pattern.

Some decoders (those marked with AV_CODEC_CAP_DELAY) have a delay between input
and output. This means that for some packets they will not immediately
produce decoded output and need to be flushed at the end of decoding to get
all the decoded data. Flushing is done by calling this function with packets
with avpkt->data set to NULL and avpkt->size set to 0 until it stops
returning subtitles. It is safe to flush even those decoders that are not
marked with AV_CODEC_CAP_DELAY, then no subtitles will be returned.

@note The AVCodecContext MUST have been opened with @ref avcodec_open2()
before packets may be fed to the decoder.

@param avctx the codec context
@param[out] sub The preallocated AVSubtitle in which the decoded subtitle will be stored,
                 must be freed with avsubtitle_free if *got_sub_ptr is set.
@param[in,out] got_sub_ptr Zero if no subtitle could be decompressed, otherwise, it is nonzero.
@param[in] avpkt The input AVPacket containing the input buffer.
@return the number of bytes of the input bitstream used.
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


comptime avcodec_send_frame = ExternalFunction[
    "avcodec_send_frame",
    fn (
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        frame: UnsafePointer[AVFrame, ImmutOrigin.external],
    ) -> c_int,
]
"""Supply a raw video or audio frame to the encoder. Use avcodec_receive_packet()
to retrieve buffered output packets.

@param avctx codec context
@param frame AVFrame containing the raw audio or video frame to be encoded.
            Ownership of the frame remains with the caller, and the
            encoder will not write to the frame. The encoder may create
            a reference to the frame data (or copy it if the frame is
            not reference-counted).
            It can be NULL, in which case it is considered a flush
            packet.  This signals the end of the stream. If the encoder
            still has packets buffered, it will return them after this
            call. Once flushing mode has been entered, additional flush
            packets are ignored, and sending frames will return
            AVERROR_EOF.

@retval 0                 success
@retval AVERROR(EAGAIN)   input is not accepted in the current state - user must
                           read output with avcodec_receive_packet() (once all
                           output is read, the packet should be resent, and the
                           call will not fail with EAGAIN).
@retval AVERROR_EOF       the encoder has been flushed, and no new frames can
                           be sent to it
@retval AVERROR(EINVAL)   codec not opened, it is a decoder, or requires flush
@retval AVERROR(ENOMEM)   failed to add packet to internal queue, or similar
@retval "another negative error code" legitimate encoding errors
"""


comptime avcodec_receive_packet = ExternalFunction[
    "avcodec_receive_packet",
    fn (
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
    ) -> c_int,
]
"""Read encoded data from the encoder.

@param avctx codec context
@param pkt This will be set to a reference-counted packet allocated by the
            codec. Note that the function will always call
            av_packet_unref(pkt) before doing anything else.

@retval 0               success
@retval AVERROR(EAGAIN) output is not available in the current state - user must
                        try to send input
@retval AVERROR_EOF     the encoder has been fully flushed, and there will be no
                        more output packets
@retval AVERROR(EINVAL) codec not opened, or it is a decoder
@retval "another negative error code" legitimate encoding errors
"""


comptime avcodec_get_hw_frames_parameters = ExternalFunction[
    "avcodec_get_hw_frames_parameters",
    fn (
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        device_ref: UnsafePointer[AVBufferRef, ImmutOrigin.external],
        hw_pix_fmt: AVPixelFormat.ENUM_DTYPE,
        out_frames_ref: UnsafePointer[
            UnsafePointer[AVBufferRef, MutOrigin.external], MutOrigin.external
        ],
    ) -> c_int,
]
"""Create and return a AVHWFramesContext with values adequate for hardware
decoding. This is meant to get called from the get_format callback, and is
a helper for preparing a AVHWFramesContext for AVCodecContext.hw_frames_ctx.
This API is for decoding with certain hardware acceleration modes/APIs only.

The returned AVHWFramesContext is not initialized. The caller must do this
with av_hwframe_ctx_init().

Calling this function is not a requirement, but makes it simpler to avoid
codec or hardware API specific details when manually allocating frames.

Alternatively to this, an API user can set AVCodecContext.hw_device_ctx,
which sets up AVCodecContext.hw_frames_ctx fully automatically, and makes
it unnecessary to call this function or having to care about
AVHWFramesContext initialization at all.

There are a number of requirements for calling this function:

- It must be called from get_format with the same avctx parameter that was
passed to get_format. Calling it outside of get_format is not allowed, and
can trigger undefined behavior.
- The function is not always supported (see description of return values).
Even if this function returns successfully, hwaccel initialization could
fail later. (The degree to which implementations check whether the stream
is actually supported varies. Some do this check only after the user's
get_format callback returns.)
- The hw_pix_fmt must be one of the choices suggested by get_format. If the
user decides to use a AVHWFramesContext prepared with this API function,
the user must return the same hw_pix_fmt from get_format.
- The device_ref passed to this function must support the given hw_pix_fmt.
- After calling this API function, it is the user's responsibility to
initialize the AVHWFramesContext (returned by the out_frames_ref parameter),
and to set AVCodecContext.hw_frames_ctx to it. If done, this must be done
before returning from get_format (this is implied by the normal
AVCodecContext.hw_frames_ctx API rules).
- The AVHWFramesContext parameters may change every time time get_format is
called. Also, AVCodecContext.hw_frames_ctx is reset before get_format. So
you are inherently required to go through this process again on every
get_format call.
- It is perfectly possible to call this function without actually using
the resulting AVHWFramesContext. One use-case might be trying to reuse a
previously initialized AVHWFramesContext, and calling this API function
only to test whether the required frame parameters have changed.
- Fields that use dynamically allocated values of any kind must not be set
by the user unless setting them is explicitly allowed by the documentation.
If the user sets AVHWFramesContext.free and AVHWFramesContext.user_opaque,
the new free callback must call the potentially set previous free callback.
This API call may set any dynamically allocated fields, including the free
callback.

The function will set at least the following fields on AVHWFramesContext
(potentially more, depending on hwaccel API):

- All fields set by av_hwframe_ctx_alloc().
- Set the format field to hw_pix_fmt.
- Set the sw_format field to the most suited and most versatile format. (An
implication is that this will prefer generic formats over opaque formats
with arbitrary restrictions, if possible.)
- Set the width/height fields to the coded frame size, rounded up to the
API-specific minimum alignment.
- Only _if_ the hwaccel requires a pre-allocated pool: set the initial_pool_size
field to the number of maximum reference surfaces possible with the codec,
plus 1 surface for the user to work (meaning the user can safely reference
at most 1 decoded surface at a time), plus additional buffering introduced
by frame threading. If the hwaccel does not require pre-allocation, the
field is left to 0, and the decoder will allocate new surfaces on demand
during decoding.
- Possibly AVHWFramesContext.hwctx fields, depending on the underlying
hardware API.

Essentially, out_frames_ref returns the same as av_hwframe_ctx_alloc(), but
with basic frame parameters set.

The function is stateless, and does not change the AVCodecContext or the
device_ref AVHWDeviceContext.

@param avctx The context which is currently calling get_format, and which
            implicitly contains all state needed for filling the returned
            AVHWFramesContext properly.
@param device_ref A reference to the AVHWDeviceContext describing the device
                which will be used by the hardware decoder.
@param hw_pix_fmt The hwaccel format you are going to return from get_format.
@param out_frames_ref On success, set to a reference to an _uninitialized_
                    AVHWFramesContext, created from the given device_ref.
                    Fields will be set to values required for decoding.
                    Not changed if an error is returned.
@return zero on success, a negative value on error. The following error codes
        have special semantics:
    AVERROR(ENOENT): the decoder does not support this functionality. Setup
                    is always manual, or it is a decoder which does not
                    support setting AVCodecContext.hw_frames_ctx at all,
                    or it is a software format.
    AVERROR(EINVAL): it is known that hardware decoding is not supported for
                    this configuration, or the device_ref is not supported
                    for the hwaccel referenced by hw_pix_fmt.
"""


@fieldwise_init
@register_passable("trivial")
struct AVCodecConfig(StructWritable):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AV_CODEC_CONFIG_PIX_FORMAT = Self(0)
    """AVPixelFormat, terminated by AV_PIX_FMT_NONE."""
    comptime AV_CODEC_CONFIG_FRAME_RATE = Self(1)
    """AVRational, terminated by {0, 0}."""
    comptime AV_CODEC_CONFIG_SAMPLE_RATE = Self(2)
    """Int, terminated by 0."""
    comptime AV_CODEC_CONFIG_SAMPLE_FORMAT = Self(3)
    """AVSampleFormat, terminated by AV_SAMPLE_FMT_NONE."""
    comptime AV_CODEC_CONFIG_CHANNEL_LAYOUT = Self(4)
    """AVChannelLayout, terminated by {0}."""
    comptime AV_CODEC_CONFIG_COLOR_RANGE = Self(5)
    """AVColorRange, terminated by AVCOL_RANGE_UNSPECIFIED."""
    comptime AV_CODEC_CONFIG_COLOR_SPACE = Self(6)
    """AVColorSpace, terminated by AVCOL_SPC_UNSPECIFIED."""

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["value"](self._value)


comptime avcodec_get_supported_config = ExternalFunction[
    "avcodec_get_supported_config",
    fn (
        avctx: UnsafePointer[AVCodecContext, ImmutOrigin.external],
        codec: UnsafePointer[AVCodec, ImmutOrigin.external],
        config: AVCodecConfig.ENUM_DTYPE,
    ) -> c_int,
]
"""Retrieve a list of all supported values for a given configuration type.

@param avctx An optional context to use. Values such as
              `strict_std_compliance` may affect the result. If NULL,
              default values are used.
@param codec The codec to query, or NULL to use avctx->codec.
@param config The configuration to query.
@param flags Currently unused; should be set to zero.
@param out_configs On success, set to a list of configurations, terminated
                    by a config-specific terminator, or NULL if all
                    possible values are supported.


@param out_num_configs On success, set to the number of elements in
                          *out_configs, excluding the terminator. Optional.
@return >= 0 on success, a negative AVERROR code on failure.
"""


@fieldwise_init
@register_passable("trivial")
struct AVPictureStructure(StructWritable):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    comptime AV_PICTURE_STRUCTURE_UNKNOWN = Self(0)
    "Unknown."
    comptime AV_PICTURE_STRUCTURE_TOP_FIELD = Self(1)
    "Coded as top field."
    comptime AV_PICTURE_STRUCTURE_BOTTOM_FIELD = Self(2)
    "Coded as bottom field."
    comptime AV_PICTURE_STRUCTURE_FRAME = Self(3)
    "Coded as frame."

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["value"](self._value)


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


comptime av_parser_iterate = ExternalFunction[
    "av_parser_iterate",
    fn (
        opaque: OpaquePointer[MutOrigin.external],
    ) -> UnsafePointer[AVCodecParser, ImmutOrigin.external],
]
"""Iterate over all registered codec parsers.

@param opaque a pointer where libavcodec will store the iteration state. Must
              point to NULL to start the iteration.
@return the next registered codec parser or NULL when the iteration is
        finished
"""


comptime av_parser_init = ExternalFunction[
    "av_parser_init",
    fn (
        codec_id: AVCodecID.ENUM_DTYPE,
    ) -> UnsafePointer[AVCodecParserContext, MutOrigin.external],
]


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


comptime av_parser_close = ExternalFunction[
    "av_parser_close",
    fn (
        s: UnsafePointer[AVCodecParserContext, MutOrigin.external],
    ) -> NoneType,
]
"""Close a parser."""


comptime avcodec_encode_subtitle = ExternalFunction[
    "avcodec_encode_subtitle",
    fn (
        avctx: UnsafePointer[AVCodecContext, MutOrigin.external],
        buf: UnsafePointer[c_uchar, MutOrigin.external],
        buf_size: c_int,
        sub: UnsafePointer[AVSubtitle, ImmutOrigin.external],
    ) -> c_int,
]
"""Encode a subtitle message."""


comptime avcodec_pix_fmt_to_codec_tag = ExternalFunction[
    "avcodec_pix_fmt_to_codec_tag",
    fn (pix_fmt: AVPixelFormat.ENUM_DTYPE,) -> c_int,
]
"""Return a value representing the fourCC code associated to the
pixel format pix_fmt, or 0 if no associated fourCC code can be found."""


comptime avcodec_find_best_pix_fmt_of_list = ExternalFunction[
    "avcodec_find_best_pix_fmt_of_list",
    fn (
        pix_fmt_list: UnsafePointer[
            AVPixelFormat.ENUM_DTYPE, ImmutOrigin.external
        ],
        src_pix_fmt: AVPixelFormat.ENUM_DTYPE,
        has_alpha: c_int,
        loss_ptr: UnsafePointer[c_int, MutOrigin.external],
    ) -> AVPixelFormat.ENUM_DTYPE,
]
"""Find the best pixel format to convert to given a certain source pixel format.
When converting from one pixel format to another, information loss may occur.
For example, when converting from RGB24 to GRAY, the color information will
be lost. Similarly, other losses occur when converting from some formats to
other formats. This function finds which of the given pixel formats should be
used to suffer the least amount of loss.
The pixel formats from which it chooses one, are determined by the
pix_fmt_list parameter.

@param pix_fmt_list AV_PIX_FMT_NONE terminated array of pixel formats to choose from
@param src_pix_fmt source pixel format
@param has_alpha Whether the source pixel format alpha channel is used.
@param loss_ptr Combination of flags informing you what kind of losses will occur.
@return The best pixel format to convert to or -1 if none was found.
"""


comptime avcodec_default_get_format = ExternalFunction[
    "avcodec_default_get_format",
    fn (
        s: UnsafePointer[AVCodecContext, MutOrigin.external],
        fmt: UnsafePointer[AVPixelFormat.ENUM_DTYPE, ImmutOrigin.external],
    ) -> AVPixelFormat.ENUM_DTYPE,
]


comptime avcodec_string = ExternalFunction[
    "avcodec_string",
    fn (
        buf: UnsafePointer[c_char, MutOrigin.external],
        buf_size: c_int,
        enc: UnsafePointer[AVCodecContext, ImmutOrigin.external],
        encode: c_int,
    ),
]


comptime avcodec_default_execute = ExternalFunction[
    "avcodec_default_execute",
    fn (
        c: UnsafePointer[AVCodecContext, MutOrigin.external],
        func: fn (
            UnsafePointer[AVCodecContext, MutOrigin.external],
            OpaquePointer[MutOrigin.external],
        ) -> c_int,
        arg: OpaquePointer[MutOrigin.external],
        ret: UnsafePointer[c_int, MutOrigin.external],
        count: c_int,
        size: c_int,
    ) -> c_int,
]
comptime avcodec_default_execute2 = ExternalFunction[
    "avcodec_default_execute2",
    fn (
        c: UnsafePointer[AVCodecContext, MutOrigin.external],
        func: fn (
            UnsafePointer[AVCodecContext, MutOrigin.external],
            OpaquePointer[MutOrigin.external],
            c_int,
            c_int,
        ) -> c_int,
        arg: OpaquePointer[MutOrigin.external],
        ret: UnsafePointer[c_int, MutOrigin.external],
        count: c_int,
    ) -> c_int,
]


comptime avcodec_fill_audio_frame = ExternalFunction[
    "avcodec_fill_audio_frame",
    fn (
        frame: UnsafePointer[AVFrame, MutOrigin.external],
        nb_channels: c_int,
        sample_fmt: AVSampleFormat.ENUM_DTYPE,
        buf: UnsafePointer[c_uchar, MutOrigin.external],
        buf_size: c_int,
        align: c_int,
    ) -> c_int,
]
"""Fill audio frame data and linesize pointers.

The buffer buf must be a preallocated buffer with a size big enough
to contain the specified samples amount. The filled AVFrame data
pointers will point to this buffer.

AVFrame extended_data channel pointers are allocated if necessary for
planar audio.

@param frame       the AVFrame
                    frame->nb_samples must be set prior to calling the
                    function. This function fills in frame->data,
                    frame->extended_data, frame->linesize[0].
@param nb_channels channel count
@param sample_fmt  sample format
@param buf         buffer to use for frame data
@param buf_size    size of buffer
@param align       plane size sample alignment (0 = default)
@return            >=0 on success, negative error code on failure
@todo return the size in bytes required to store the samples in
case of success, at the next libavutil bump
"""


comptime avcodec_flush_buffers = ExternalFunction[
    "avcodec_flush_buffers",
    fn (avctx: UnsafePointer[AVCodecContext, MutOrigin.external],) -> NoneType,
]
"""Reset the internal codec state / flush internal buffers. Should be called
e.g. when seeking or when switching to a different stream.

@note for decoders, this function just releases any references the decoder
might keep internally, but the caller's references remain valid.

@note for encoders, this function will only do something if the encoder
declares support for AV_CODEC_CAP_ENCODER_FLUSH. When called, the encoder
will drain any remaining packets, and can then be reused for a different
stream (as opposed to sending a null frame which will leave the encoder
in a permanent EOF state after draining). This can be desirable if the
cost of tearing down and replacing the encoder instance is high.
"""

comptime av_get_audio_frame_duration = ExternalFunction[
    "av_get_audio_frame_duration",
    fn (
        avctx: UnsafePointer[AVCodecContext, ImmutOrigin.external],
        frame_bytes: c_int,
    ) -> c_int,
]
"""Return audio frame duration.

@param avctx        codec context
@param frame_bytes  size of the frame, or 0 if unknown
@return             frame duration, in samples, if known. 0 if not able to
                    determine.
"""


comptime av_fast_padded_malloc = ExternalFunction[
    "av_fast_padded_malloc",
    fn (
        ptr: OpaquePointer[MutOrigin.external],
        size: UnsafePointer[c_int, MutOrigin.external],
        min_size: c_size_t,
    ) -> NoneType,
]
"""Same behaviour av_fast_malloc but the buffer has additional 
AV_INPUT_BUFFER_PADDING_SIZE at the end which will always be 0.
In addition the whole buffer will initially and after resizes be 0-initialized 
so that no uninitialized data will ever appear.

@param ptr pointer to a pointer to allocate, may be NULL
@param size pointer to size of allocation, updated to reflect the size of the 
allocated buffer
@param min_size minimum size to allocate
@return 0 on success, a negative error code on failure
"""


comptime av_fast_padded_mallocz = ExternalFunction[
    "av_fast_padded_mallocz",
    fn (
        ptr: OpaquePointer[MutOrigin.external],
        size: UnsafePointer[c_int, MutOrigin.external],
        min_size: c_size_t,
    ) -> NoneType,
]
"""Same behaviour av_fast_padded_malloc except that buffer will always be 
0-initialized after call."""


comptime avcodec_is_open = ExternalFunction[
    "avcodec_is_open",
    fn (avctx: UnsafePointer[AVCodecContext, ImmutOrigin.external],) -> c_int,
]
"""Return a positive value if s is open (i.e. avcodec_open2() was called on it), 0 otherwise."""
