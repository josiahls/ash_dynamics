from ash_dynamics.primitives._clib import StructWritable
from ash_dynamics.ffmpeg.avcodec.defs import AVFieldOrder
from ash_dynamics.ffmpeg.avutil.pixfmt import (
    AVColorRange,
    AVColorPrimaries,
    AVColorTransferCharacteristic,
    AVColorSpace,
    AVChromaLocation,
)
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType

from sys.ffi import c_uint, c_uchar, c_long_long, c_int
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout
from ash_dynamics.ffmpeg.avcodec.packet import AVPacketSideData


@fieldwise_init
@register_passable("trivial")
struct AVCodecParameters(StructWritable):
    """This struct describes the properties of an encoded stream."""

    var codec_type: AVMediaType.ENUM_DTYPE
    """General type of the encoded data."""
    var codec_id: AVCodecID.ENUM_DTYPE
    """Specific type of the encoded data (the codec used)."""
    var codec_tag: c_uint
    """Additional information about the codec (corresponds to the AVI FOURCC)."""
    var extradata: UnsafePointer[c_uchar, MutOrigin.external]
    """Extra binary data needed for initializing the decoder, codec-dependent.

    Must be allocated with av_malloc() and will be freed by
    avcodec_parameters_free(). The allocated size of extradata must be at
    least extradata_size + AV_INPUT_BUFFER_PADDING_SIZE, with the padding
    bytes zeroed.
    """
    var extradata_size: c_int
    """Size of the extradata content in bytes."""
    var coded_side_data: UnsafePointer[AVPacketSideData, MutOrigin.external]
    """Additional data associated with the entire stream.

    Should be allocated with av_packet_side_data_new() or
    av_packet_side_data_add(), and will be freed by avcodec_parameters_free().
    """
    var nb_coded_side_data: c_int
    """Amount of entries in @ref coded_side_data."""
    var format: c_int
    """- video: the pixel format, the value corresponds to enum AVPixelFormat.
    - audio: the sample format, the value corresponds to enum AVSampleFormat."""
    var bit_rate: c_long_long
    """The average bitrate of the encoded data (in bits per second)."""
    var bits_per_coded_sample: c_int
    """The number of bits per sample in the codedwords.

    Basically the bitrate per sample. It is mandatory for a bunch of
    formats to actually decode them. It's the number of bits for one sample in
    the actual coded bitstream.

    This could be for example 4 for ADPCM
    For PCM formats this matches bits_per_raw_sample
    Can be 0
    """
    var bits_per_raw_sample: c_int
    """The number of bits per sample in the raw data.
    If the sample format has more bits, the least significant bits are additional
    padding bits, which are always 0. Use right shifts to reduce the sample
    to its actual size. For example, audio formats with 24 bit samples will
    have bits_per_raw_sample set to 24, and format set to AV_SAMPLE_FMT_S32.
    To get the original sample use "(int32_t)sample >> 8"."

    For ADPCM this might be 12 or 16 or similar
    Can be 0
    """

    var profile: c_int
    """Codec-specific bitstream restrictions that the stream conforms to."""
    var level: c_int

    var width: c_int
    """Video only. The dimensions of the video frame in pixels."""
    var height: c_int
    """Video only. The dimensions of the video frame in pixels."""
    var sample_aspect_ratio: AVRational
    """Video only. The aspect ratio (width / height) which a single pixel
    should have when displayed.
    When the aspect ratio is unknown / undefined, the numerator should be
    set to 0 (the denominator may have any value).
    """
    var framerate: AVRational
    """Video only. Number of frames per second, for streams with constant frame
    durations. Should be set to { 0, 1 } when some frames have differing
    durations or if the value is not known.
    
    @note This field corresponds to values that are stored in codec-level
    headers and is typically overridden by container/transport-layer
    timestamps, when available. It should thus be used only as a last resort,
    when no higher-level timing information is available.
    """
    var field_order: AVFieldOrder.ENUM_DTYPE
    """Video only. The order of the fields in interlaced video."""
    var color_range: AVColorRange.ENUM_DTYPE
    """Video only. Additional colorspace characteristics."""
    var color_primaries: AVColorPrimaries.ENUM_DTYPE
    """Video only. Additional colorspace characteristics."""
    var color_trc: AVColorTransferCharacteristic.ENUM_DTYPE
    """Video only. Additional colorspace characteristics."""
    var colorspace: AVColorSpace.ENUM_DTYPE
    """Video only. Additional colorspace characteristics."""
    var chroma_location: AVChromaLocation.ENUM_DTYPE
    """Video only. Additional colorspace characteristics."""

    var video_delay: c_int
    """Video only. Number of delayed frames."""
    var ch_layout: AVChannelLayout
    """Audio only. The channel layout and number of channels."""
    var sample_rate: c_int
    """Audio only. The number of audio samples per second.
    """
    var block_align: c_int
    """Audio only. The number of bytes per coded audio frame, required by some
    formats.
    
    Corresponds to nBlockAlign in WAVEFORMATEX.
    """
    var frame_size: c_int
    """Audio only. Audio frame size, if known. Required by some formats to be static.
    """
    var initial_padding: c_int
    """Audio only. The amount of padding (in samples) inserted by the encoder at
    the beginning of the audio. I.e. this number of leading decoded samples
    must be discarded by the caller to get the original audio without leading
    padding.
    """
    var trailing_padding: c_int
    """Audio only. The amount of padding (in samples) appended by the encoder to
    the end of the audio. I.e. this number of decoded samples must be
    discarded by the caller from the end of the stream to get the original audio 
    without any trailing padding.
    """
    var seek_preroll: c_int
    """Audio only. Number of samples to skip after a discontinuity."""
