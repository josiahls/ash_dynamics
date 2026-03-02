"https://www.ffmpeg.org/doxygen/8.0/log_8h.html"
from ffi import c_char, c_int
from ash_dynamics.ffmpeg.avutil.opt import AVOption, AVOptionRanges


from reflection import get_type_name


comptime AVClass_item_name_fn = fn(
    ctx: OpaquePointer[MutAnyOrigin]
) -> UnsafePointer[c_char, ImmutAnyOrigin]


comptime AVClass_get_category_fn = fn(
    ctx: OpaquePointer[MutAnyOrigin]
) -> AVClassCategory.ENUM_DTYPE

comptime AVClass_query_ranges_fn = fn(
    ranges: UnsafePointer[AVOptionRanges, MutAnyOrigin],
    obj: OpaquePointer[MutAnyOrigin],
    key: UnsafePointer[c_char, ImmutAnyOrigin],
    flags: c_int,
) -> c_int

comptime AVClass_child_next_fn = fn(
    obj: OpaquePointer[MutAnyOrigin],
    prev: OpaquePointer[MutAnyOrigin],
) -> OpaquePointer[MutAnyOrigin]


comptime AVClass_child_class_iterate_fn[T: AnyType] = fn(
    iter: UnsafePointer[OpaquePointer[MutAnyOrigin], MutAnyOrigin]
) -> UnsafePointer[T, ImmutAnyOrigin]


struct AVClass(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVClass.html"
    var class_name: UnsafePointer[c_char, ImmutAnyOrigin]

    # TODO: Is this correct or do we need to additionally wrap item_name in a
    # unsafe pointer?
    var item_name: AVClass_item_name_fn

    var option: UnsafePointer[AVOption, ImmutAnyOrigin]
    var version: c_int
    var log_level_offset_offset: c_int
    var parent_log_context_offset: c_int
    var category: AVClassCategory.ENUM_DTYPE
    var get_category: AVClass_get_category_fn
    var query_ranges: AVClass_query_ranges_fn
    var child_next: AVClass_child_next_fn
    var child_class_iterate: AVClass_child_class_iterate_fn[Self]
    var state_flags_offset: c_int


@fieldwise_init("implicit")
struct AVClassCategory(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    fn inc(self) -> Self:
        return Self(self._value + 1)

    comptime AV_CLASS_CATEGORY_NA = Self(0)
    comptime AV_CLASS_CATEGORY_INPUT = Self(
        Self.AV_CLASS_CATEGORY_NA._value
    ).inc()
    comptime AV_CLASS_CATEGORY_OUTPUT = Self(
        Self.AV_CLASS_CATEGORY_INPUT._value
    ).inc()
    comptime AV_CLASS_CATEGORY_MUXER = Self(
        Self.AV_CLASS_CATEGORY_OUTPUT._value
    ).inc()
    comptime AV_CLASS_CATEGORY_DEMUXER = Self(
        Self.AV_CLASS_CATEGORY_MUXER._value
    ).inc()
    comptime AV_CLASS_CATEGORY_ENCODER = Self(
        Self.AV_CLASS_CATEGORY_DEMUXER._value
    ).inc()
    comptime AV_CLASS_CATEGORY_DECODER = Self(
        Self.AV_CLASS_CATEGORY_ENCODER._value
    ).inc()
    comptime AV_CLASS_CATEGORY_FILTER = Self(
        Self.AV_CLASS_CATEGORY_DECODER._value
    ).inc()
    comptime AV_CLASS_CATEGORY_BITSTREAM_FILTER = Self(
        Self.AV_CLASS_CATEGORY_FILTER._value
    ).inc()
    comptime AV_CLASS_CATEGORY_SWSCALER = Self(
        Self.AV_CLASS_CATEGORY_BITSTREAM_FILTER._value
    ).inc()
    comptime AV_CLASS_CATEGORY_SWRESAMPLER = Self(
        Self.AV_CLASS_CATEGORY_SWSCALER._value
    ).inc()
    comptime AV_CLASS_CATEGORY_HWDEVICE = Self(
        Self.AV_CLASS_CATEGORY_SWRESAMPLER._value
    ).inc()

    comptime AV_CLASS_CATEGORY_DEVICE_VIDEO_OUTPUT = Self(40)
    comptime AV_CLASS_CATEGORY_DEVICE_VIDEO_INPUT = Self(
        Self.AV_CLASS_CATEGORY_DEVICE_VIDEO_OUTPUT._value
    ).inc()
    comptime AV_CLASS_CATEGORY_DEVICE_AUDIO_OUTPUT = Self(
        Self.AV_CLASS_CATEGORY_DEVICE_VIDEO_INPUT._value
    ).inc()
    comptime AV_CLASS_CATEGORY_DEVICE_AUDIO_INPUT = Self(
        Self.AV_CLASS_CATEGORY_DEVICE_AUDIO_OUTPUT._value
    ).inc()
    comptime AV_CLASS_CATEGORY_DEVICE_OUTPUT = Self(
        Self.AV_CLASS_CATEGORY_DEVICE_AUDIO_INPUT._value
    ).inc()
    comptime AV_CLASS_CATEGORY_DEVICE_INPUT = Self(
        Self.AV_CLASS_CATEGORY_DEVICE_OUTPUT._value
    ).inc()
    comptime AV_CLASS_CATEGORY_NB = Self(
        Self.AV_CLASS_CATEGORY_DEVICE_INPUT._value
    ).inc()
