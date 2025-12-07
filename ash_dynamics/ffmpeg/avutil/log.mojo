from sys.ffi import c_char, c_int
from ash_dynamics.ffmpeg.avutil.opt import AVOption, AVOptionRanges
from ash_dynamics.primitives._clib import StructWritable, StructWriter

from compile.reflection import get_type_name


comptime AVClass_item_name_fn = fn (
    ctx: OpaquePointer[MutOrigin.external]
) -> UnsafePointer[c_char, ImmutOrigin.external]


comptime AVClass_get_category_fn = fn (
    ctx: OpaquePointer[MutOrigin.external]
) -> AVClassCategory.ENUM_DTYPE

comptime AVClass_query_ranges_fn = fn (
    ranges: UnsafePointer[AVOptionRanges, MutOrigin.external],
    obj: OpaquePointer[MutOrigin.external],
    key: UnsafePointer[c_char, ImmutOrigin.external],
    flags: c_int,
) -> c_int

comptime AVClass_child_next_fn = fn (
    obj: OpaquePointer[MutOrigin.external],
    prev: OpaquePointer[MutOrigin.external],
) -> OpaquePointer[MutOrigin.external]


comptime AVClass_child_class_iterate_fn[T: Copyable] = fn (
    iter: UnsafePointer[OpaquePointer[MutOrigin.external], MutOrigin.external]
) -> UnsafePointer[T, ImmutOrigin.external]


@register_passable("trivial")
struct AVClass(StructWritable):
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVClass.html
    """

    var class_name: UnsafePointer[c_char, ImmutOrigin.external]
    """The name of the class; usually it is the same name as the context 
    structure type to which the AVClass is associated."""

    # TODO: Is this correct or do we need to additionally wrap item_name in a
    # unsafe pointer?
    var item_name: AVClass_item_name_fn
    """A pointer to a function which returns the name of a context instance ctx 
    associated with the class."""

    var option: UnsafePointer[AVOption, ImmutOrigin.external]
    var version: c_int
    """LIBAVUTIL_VERSION with which this structure was created."""
    var log_level_offset_offset: c_int
    """Offset in the structure where the log level offset is stored."""
    var parent_log_context_offset: c_int
    """Offset in the structure where a pointer to the parent context for logging 
    is stored."""
    var category: AVClassCategory.ENUM_DTYPE
    """Category used for visualization (like color).

    Only used when get_category() is NULL. Use this field when all instances 
    of this class have the same category, use get_category() otherwise.
    """
    var get_category: AVClass_get_category_fn
    """Callback to return the instance category. Use this callback when 
    different instances of this class may have different categories, category 
    otherwise."""
    var query_ranges: AVClass_query_ranges_fn
    """Callback to return the supported/allowed ranges."""
    var child_next: AVClass_child_next_fn
    """Return next AVOptions-enabled child or NULL."""
    var child_class_iterate: AVClass_child_class_iterate_fn[Self]
    """Iterate over the AVClasses corresponding to potential AVOptions-enabled children."""
    var state_flags_offset: c_int
    """When non-zero, offset in the object to an unsigned int holding object 
    state flags, a combination of AVClassStateFlags values. The flags are 
    updated by the object to signal its state to the generic code."""

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["class_name"](
            StringSlice(unsafe_from_utf8_ptr=self.class_name)
        )
        struct_writer.write_field["item_name"]("AVClass_item_name_fn")
        struct_writer.write_field["option"](self.option)
        struct_writer.write_field["version"](self.version)
        struct_writer.write_field["log_level_offset_offset"](
            self.log_level_offset_offset
        )
        struct_writer.write_field["parent_log_context_offset"](
            self.parent_log_context_offset
        )
        struct_writer.write_field["category"](self.category)

        struct_writer.write_field["get_category"]("AVClass_get_category_fn")
        struct_writer.write_field["query_ranges"]("AVClass_query_ranges_fn")
        struct_writer.write_field["child_next"]("AVClass_child_next_fn")
        struct_writer.write_field["child_class_iterate"](
            "AVClass_child_class_iterate_fn[Self]"
        )
        struct_writer.write_field["state_flags_offset"](self.state_flags_offset)


@register_passable("trivial")
@fieldwise_init("implicit")
struct AVClassCategory:
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVClassCategory.html
    """

    comptime ENUM_DTYPE = c_int
    var _value: Self.ENUM_DTYPE

    fn inc(self) -> Self:
        "Returns a copy of self but with +1 added."
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
