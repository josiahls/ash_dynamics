from sys.ffi import c_int
from ash_dynamics.primitives._clib import Debug


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVSampleFormat(Debug):
    """Audio sample formats

    - The data described by the sample format is always in native-endian order.
    Sample values can be expressed by native C types, hence the lack of a signed
    24-bit sample format even though it is a common raw audio data format.

    - The floating-point formats are based on full volume being in the range
    [-1.0, 1.0]. Any values outside this range are beyond full volume level.

    - The data layout as used in av_samples_fill_arrays() and elsewhere in FFmpeg
    (such as AVFrame in libavcodec) is as follows:

    For planar sample formats, each audio channel is in a separate data plane,
    and linesize is the buffer size, in bytes, for a single plane. All data
    planes must be the same size. For packed sample formats, only the first data
    plane is used, and samples for each channel are interleaved. In this case,
    linesize is the buffer size, in bytes, for the 1 plane.

    Reference [0] for enum details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/samplefmt_8h_source.html
    """

    comptime ENUM_DTYPE = c_int

    var _value: Self.ENUM_DTYPE

    fn inc(self) -> Self:
        "Returns a copy of self but with +1 added."
        return Self(self._value + 1)

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["value"](self._value)

    comptime AV_SAMPLE_FMT_NONE = Self(-1)
    comptime AV_SAMPLE_FMT_U8 = Self(
        Self.AV_SAMPLE_FMT_NONE._value
    ).inc()  # unsigned 8 bits
    comptime AV_SAMPLE_FMT_S16 = Self(
        Self.AV_SAMPLE_FMT_U8._value
    ).inc()  # signed 16 bits
    comptime AV_SAMPLE_FMT_S32 = Self(
        Self.AV_SAMPLE_FMT_S16._value
    ).inc()  # signed 32 bits
    comptime AV_SAMPLE_FMT_FLT = Self(
        Self.AV_SAMPLE_FMT_S32._value
    ).inc()  # float
    comptime AV_SAMPLE_FMT_DBL = Self(
        Self.AV_SAMPLE_FMT_FLT._value
    ).inc()  # double
    comptime AV_SAMPLE_FMT_U8P = Self(
        Self.AV_SAMPLE_FMT_DBL._value
    ).inc()  # unsigned 8 bits, planar
    comptime AV_SAMPLE_FMT_S16P = Self(
        Self.AV_SAMPLE_FMT_U8P._value
    ).inc()  # signed 16 bits, planar
    comptime AV_SAMPLE_FMT_S32P = Self(
        Self.AV_SAMPLE_FMT_S16P._value
    ).inc()  # signed 32 bits, planar
    comptime AV_SAMPLE_FMT_FLTP = Self(
        Self.AV_SAMPLE_FMT_S32P._value
    ).inc()  # float, planar
    comptime AV_SAMPLE_FMT_DBLP = Self(
        Self.AV_SAMPLE_FMT_FLTP._value
    ).inc()  # double, planar
    comptime AV_SAMPLE_FMT_S64 = Self(
        Self.AV_SAMPLE_FMT_DBLP._value
    ).inc()  # signed 64 bits
    comptime AV_SAMPLE_FMT_S64P = Self(
        Self.AV_SAMPLE_FMT_S64._value
    ).inc()  # signed 64 bits, planar
    comptime AV_SAMPLE_FMT_NB = Self(
        Self.AV_SAMPLE_FMT_S64P._value
    ).inc()  # Number of sample formats. DO NOT USE if linking dynamically
