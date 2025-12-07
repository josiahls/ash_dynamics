from sys.ffi import c_char, c_int, c_double, c_long_long
from ash_dynamics.primitives._clib import C_Union
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.primitives._clib import StructWritable, StructWriter


@register_passable("trivial")
struct AVOption(StructWritable):
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVOption.html
    """

    var name: UnsafePointer[c_char, ImmutOrigin.external]
    "The name of the option."
    var help: UnsafePointer[c_char, ImmutOrigin.external]
    "Short english help text."
    var offset: c_int
    """Native access only.
    
    The offset relative to the context structure where the option value is 
    stored. It should be 0 for named constants.
    """
    var type: AVOptionType
    var default_val: C_Union[
        c_long_long,
        c_double,
        UnsafePointer[c_char, ImmutOrigin.external],
        AVRational,
        UnsafePointer[AVOptionArrayDef, ImmutOrigin.external],
    ]
    var min: c_double
    var max: c_double
    var flags: c_int
    var unit: UnsafePointer[c_char, ImmutOrigin.external]

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        var struct_writer = StructWriter[Self](writer, indent=indent)
        struct_writer.write_field["name"](
            StringSlice(unsafe_from_utf8_ptr=self.name)
        )
        struct_writer.write_field["help"](
            StringSlice(unsafe_from_utf8_ptr=self.help)
        )
        struct_writer.write_field["offset"](self.offset)
        struct_writer.write_field["type"](self.type)
        # TODO: figure out the union type later.
        # struct_writer.write_field["default_val"](self.default_val)
        struct_writer.write_field["min"](self.min)
        struct_writer.write_field["max"](self.max)


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVOptionType(Writable):
    """An option type determines:
    - for native access, the underlying C type of the field that an AVOption
      refers to;
    - for foreign access, the semantics of accessing the option through this API,
      e.g. which av_opt_get_*() and av_opt_set_*() functions can be called, or
      what format will av_opt_get()/av_opt_set() expect/produce.
    """

    comptime ENUM_DTYPE = c_int

    var _value: Self.ENUM_DTYPE

    fn inc(self) -> Self:
        "Returns a copy of self but with +1 added."
        return Self(self._value + 1)

    fn write_to(self, mut writer: Some[Writer]):
        writer.write(self._value)

    comptime AV_OPT_TYPE_FLAGS = Self(1)
    "Underlying C type is unsigned int."
    comptime AV_OPT_TYPE_INT = Self(Self.AV_OPT_TYPE_FLAGS._value).inc()
    "Underlying C type is int."
    comptime AV_OPT_TYPE_INT64 = Self(Self.AV_OPT_TYPE_INT._value).inc()
    "Underlying C type is int64_t."
    comptime AV_OPT_TYPE_DOUBLE = Self(Self.AV_OPT_TYPE_INT64._value).inc()
    "Underlying C type is double."
    comptime AV_OPT_TYPE_FLOAT = Self(Self.AV_OPT_TYPE_DOUBLE._value).inc()
    "Underlying C type is float."
    comptime AV_OPT_TYPE_STRING = Self(Self.AV_OPT_TYPE_FLOAT._value).inc()
    """Underlying C type is a uint8_t* that is either NULL or points to a C string 
    allocated with the av_malloc() family of functions."""
    comptime AV_OPT_TYPE_RATIONAL = Self(Self.AV_OPT_TYPE_STRING._value).inc()
    """Underlying C type is AVRational."""
    comptime AV_OPT_TYPE_BINARY = Self(Self.AV_OPT_TYPE_RATIONAL._value).inc()
    """Underlying C type is a uint8_t* that is either NULL or points to an array 
    allocated with the av_malloc() family of functions. The pointer is immediately 
    followed by an int containing the array length in bytes."""
    comptime AV_OPT_TYPE_DICT = Self(Self.AV_OPT_TYPE_BINARY._value).inc()
    """Underlying C type is AVDictionary*."""
    comptime AV_OPT_TYPE_UINT64 = Self(Self.AV_OPT_TYPE_DICT._value).inc()
    """Underlying C type is uint64_t."""
    comptime AV_OPT_TYPE_CONST = Self(Self.AV_OPT_TYPE_UINT64._value).inc()
    """Special option type for declaring named constants. Does not correspond to
    an actual field in the object, offset must be 0."""
    comptime AV_OPT_TYPE_IMAGE_SIZE = Self(Self.AV_OPT_TYPE_CONST._value).inc()
    """Underlying C type is two consecutive integers."""
    comptime AV_OPT_TYPE_PIXEL_FMT = Self(
        Self.AV_OPT_TYPE_IMAGE_SIZE._value
    ).inc()
    """Underlying C type is enum AVPixelFormat."""
    comptime AV_OPT_TYPE_SAMPLE_FMT = Self(
        Self.AV_OPT_TYPE_PIXEL_FMT._value
    ).inc()
    """Underlying C type is enum AVSampleFormat."""
    comptime AV_OPT_TYPE_VIDEO_RATE = Self(
        Self.AV_OPT_TYPE_SAMPLE_FMT._value
    ).inc()
    """Underlying C type is AVRational."""
    comptime AV_OPT_TYPE_DURATION = Self(
        Self.AV_OPT_TYPE_VIDEO_RATE._value
    ).inc()
    """Underlying C type is int64_t."""
    comptime AV_OPT_TYPE_COLOR = Self(Self.AV_OPT_TYPE_DURATION._value).inc()
    """Underlying C type is uint8_t[4]."""
    comptime AV_OPT_TYPE_BOOL = Self(Self.AV_OPT_TYPE_COLOR._value).inc()
    """Underlying C type is int."""
    comptime AV_OPT_TYPE_CHLAYOUT = Self(Self.AV_OPT_TYPE_BOOL._value).inc()
    """Underlying C type is AVChannelLayout."""
    comptime AV_OPT_TYPE_UINT = Self(Self.AV_OPT_TYPE_CHLAYOUT._value).inc()
    """Underlying C type is unsigned int."""
    comptime AV_OPT_TYPE_FLAG_ARRAY = Self(1 << 16)
    """May be combined with another regular option type to declare an array
    option.
    
    For array options, @ref AVOption.offset should refer to a pointer
    corresponding to the option type. The pointer should be immediately
    followed by an unsigned int that will store the number of elements in the
    array."""


@register_passable("trivial")
@fieldwise_init
struct AVOptionArrayDef:
    var def_: UnsafePointer[c_char, ImmutOrigin.external]
    """Native access only.

    NOTE: `opt.h` has this as `def` but this conflicts with mojo.
    
    Default value of the option, as would be serialized by av_opt_get() (i.e.
    using the value of sep as the separator).
    """
    var size_min: c_int
    """Minimum number of elements in the array. When this field is non-zero, def
    must be non-NULL and contain at least this number of elements."""
    var size_max: c_int
    """Maximum number of elements in the array, 0 when unlimited."""
    var sep: c_char
    """Separator between array elements in string representations of this
    option, used by av_opt_set() and av_opt_get(). It must be a printable
    ASCII character, excluding alphanumeric and the backslash. A comma is used when sep=0.
    
    The separator and the backslash must be backslash-escaped in order to
    appear in string representations of the option value.
    """


@register_passable("trivial")
struct AVOptionRanges:
    """Reference [0] for struct details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/structAVOptionRanges.html
    """

    var range: UnsafePointer[
        UnsafePointer[Self, MutOrigin.external], MutOrigin.external
    ]
    """Array of option ranges."""
    var nb_ranges: c_int
    """Number of ranges per component."""
    var nb_components: c_int
    """Number of components."""
