from sys.ffi import (
    OwnedDLHandle,
    c_char,
    c_int,
    c_long_long,
    c_uchar,
    c_uint,
    c_ushort,
)
from sys.info import size_of
from utils import StaticTuple
from sys.intrinsics import _type_is_eq
from builtin.rebind import downcast
from reflection import (
    struct_field_count,
    struct_field_names,
    struct_field_types,
    get_type_name,
)


comptime c_ptrdiff_t = c_long_long


struct ExternalFunction[
    name: StaticString,
    type: AnyTrivialRegType,
]:
    """

    References:
    - https://github.com/modular/modular/blob/d2dadf1a723d7e341f84d34e93223517b23bfca3/mojo/stdlib/stdlib/python/_cpython.mojo#L756

    """

    @staticmethod
    @always_inline
    fn load(lib: OwnedDLHandle) -> Self.type:
        """Loads this external function from an opened dynamic library."""
        return lib._get_function[Self.name, Self.type]()


@always_inline("nodebug")
fn build_union_mlir_type[*Ts: Copyable & Movable]() -> Int:
    var max_size: Int = 0

    @parameter
    for i in range(len(VariadicList(Ts))):
        comptime current_size = size_of[Ts[i]]()
        if current_size > max_size:
            max_size = current_size
    return max_size


# TODO(josiahls): We absolutely can't do it this way as a long term thing.
@fieldwise_init("implicit")
@register_passable("trivial")
struct C_Union[*Ts: Copyable & Movable](Copyable, Copyable, Movable):
    """
    A union that can hold a runtime-variant value from a set of predefined
    types.

    Reference: https://en.cppreference.com/w/c/language/union.html

    `C_Union` expects the types to overlap in storage. It is only as big as its
    largest member. It provides no additional tracking or memory management unlike
    `Variant` which is a discriminated union type that maintains a tracking discriminant.
    """

    comptime max_size = build_union_mlir_type[*Self.Ts]()
    var _impl: StaticTuple[UInt8, Self.max_size]

    @implicit
    fn __init__[T: Movable](out self, var value: T):
        """Create a c union with one of the types.

        Parameters:
            T: The type to initialize the variant to. Generally this should
                be able to be inferred from the call type, eg. `C_Union[Int, String](4)`.

        Args:
            value: The value to initialize the variant with.
        """
        __mlir_op.`lit.ownership.mark_initialized`(__get_mvalue_as_litref(self))
        self._get_ptr[T]().init_pointee_move(value^)

    @staticmethod
    fn _check[T: AnyType]() -> Bool:
        @parameter
        for i in range(len(VariadicList(Self.Ts))):
            if _type_is_eq[Self.Ts[i], T]():
                return True
        return False

    @always_inline("nodebug")
    fn _get_ptr[
        T: AnyType
    ](mut self) -> UnsafePointer[T, origin_of(self._impl)]:
        comptime is_supported = Self._check[T]()
        constrained[is_supported, "not a union element type"]()
        var ptr = UnsafePointer(to=self._impl).bitcast[T]()
        return ptr


trait StructWritable(Writable):
    """Handles writing a c-style struct. Intended to be used with the `Writable`
    trait.
    """

    fn write_to(self, mut writer: Some[Writer], indent: Int):
        ...

    fn write_to(self, mut writer: Some[Writer]):
        self.write_to(writer, indent=0)


struct StructWriter[
    wrapping_struct: AnyType,
    W: Writer,
](Copyable, Movable):
    var writer: UnsafePointer[Self.W, MutAnyOrigin]
    var indent: Int

    fn __init__(out self, mut writer: Self.W, indent: Int = 0):
        self.writer = UnsafePointer(to=writer)
        self.indent = indent

    fn write_to[T: Writable](self, value: T):
        self.writer[].write(value)

    fn write_field[
        name: StaticString,
        T: Writable,
        deprecated: Bool = False,
    ](mut self, value: UnsafePointer[T, _]):
        comptime not_conform_message: StaticString = name + " does not conform to StructWritable"

        comptime null_pointer_message: StaticString = "Null Ptr"
        if value:

            @parameter
            if conforms_to(T, StructWritable):
                comptime struct_message: StaticString = name + " (struct)"
                self._fmt(StringSlice(struct_message), String(value))
                trait_downcast[StructWritable](value[]).write_to(
                    self.writer[], indent=self.indent + 1
                )
            else:
                self._fmt(not_conform_message, value[])
        else:
            if deprecated:
                self._fmt(name, null_pointer_message + " (deprecated)")
            else:
                self._fmt(name, null_pointer_message)

    fn write_field[name: StaticString, T: Writable](mut self, value: T):
        @parameter
        if conforms_to(T, StructWritable):
            comptime msg: StaticString = name + " (struct)"
            self._fmt(StringSlice(msg), "")
            trait_downcast[StructWritable](value).write_to(
                self.writer[], indent=self.indent + 1
            )
        else:
            self._fmt(name, value)

    fn _fmt(
        ref [MutAnyOrigin]self,
        name: StaticString,
        value: Some[Writable],
        newline: Bool = True,
    ):
        comptime class_name = get_type_name[
            Self.wrapping_struct, qualified_builtins=True
        ]()
        for _ in range(self.indent):
            self.writer[].write("\t")
        self.writer[].write(class_name, ".", name, ": ", value, "\n")


@register_passable("trivial")
struct TrivialOptionalField[active: Bool, ElementType: AnyTrivialRegType](
    Copyable, Movable
):
    comptime OptionalElementType = StaticTuple[
        Self.ElementType, 1 if Self.active else 0
    ]
    var field: Self.OptionalElementType

    fn __init__(out self):
        constrained[
            not Self.active, "Constructor only available with no active field"
        ]()
        self.field = Self.OptionalElementType()

    fn __init__(out self, var value: Self.ElementType):
        constrained[
            Self.active, "Constructor only available with active field"
        ]()
        self.field = Self.OptionalElementType(value)

    fn __init__(out self, var value: Optional[Self.ElementType]):
        @parameter
        if Self.active:
            self.field = Self.OptionalElementType(value.take())
        else:
            self.field = Self.OptionalElementType()

    @always_inline
    fn __getitem__(ref self) -> Self.ElementType:
        constrained[
            Self.active, "Field is not active, you should not access it."
        ]()
        return self.field[0]


# NOTE: Not working at the moment. Gets:
# failed to locate witness entry for std::builtin::simd::SIMD, std::builtin::str::Stringable, __str__($0)
trait Debug(Writable):
    fn write_to(self, mut w: Some[Writer]):
        self.write_to(w, indent=0)

    fn write_to(self, mut w: Some[Writer], indent: Int):
        # TODO: Implement: https://github.com/modular/modular/issues/5720
        # once solved.
        w.write(get_type_name[Self]() + ":\n")

        @parameter
        for i in range(struct_field_count[Self]()):
            comptime field_type = struct_field_types[Self]()[i]
            comptime field_name = struct_field_names[Self]()[i]
            # if conforms_to(field_type, Stringable):

            var field = UnsafePointer(to=__struct_field_ref(i, self))
            w.write("    " * (indent + 1), field_name, ": ")

            print("Type name: ", get_type_name[field_type]())

            @parameter
            if get_type_name[field_type]() == get_type_name[Int8]():
                w.write(field.bitcast[Int8]()[])
            elif get_type_name[field_type]() == get_type_name[Int16]():
                w.write(field.bitcast[Int16]()[])
            elif get_type_name[field_type]() == get_type_name[Int]():
                w.write(field.bitcast[Int]()[])
            elif get_type_name[field_type]() == get_type_name[Int32]():
                w.write(field.bitcast[Int32]()[])
            elif get_type_name[field_type]() == get_type_name[Int64]():
                w.write(field.bitcast[Int64]()[])
            elif get_type_name[field_type]() == get_type_name[UInt8]():
                w.write(field.bitcast[UInt8]()[])
            elif get_type_name[field_type]() == get_type_name[UInt16]():
                w.write(field.bitcast[UInt16]()[])
            elif get_type_name[field_type]() == get_type_name[UInt]():
                w.write(field.bitcast[UInt]()[])
            elif get_type_name[field_type]() == get_type_name[UInt32]():
                w.write(field.bitcast[UInt32]()[])
            elif get_type_name[field_type]() == get_type_name[UInt64]():
                w.write(field.bitcast[UInt64]()[])
            elif get_type_name[field_type]() == get_type_name[Float32]():
                w.write(field.bitcast[Float32]()[])
            elif get_type_name[field_type]() == get_type_name[Float64]():
                w.write(field.bitcast[Float64]()[])
            elif get_type_name[field_type]() == get_type_name[Bool]():
                w.write(field.bitcast[Bool]()[])
            elif "UnsafePointer[UInt8]" in get_type_name[field_type]():
                w.write(field.bitcast[OpaquePointer[MutAnyOrigin]]()[])
            elif "UnsafePointer" in get_type_name[field_type]():
                w.write(field.bitcast[OpaquePointer[MutAnyOrigin]]()[])
            else:
                w.write(
                    "Unable to handle type name: ", get_type_name[field_type]()
                )

            w.write("\n")
