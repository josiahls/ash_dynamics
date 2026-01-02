from reflection import struct_field_types, struct_field_names, struct_field_count, get_type_name


# fn struct_field_ref[idx: Int, T: AnyType & ImplicitlyCopyable](ref s: T) -> ref [MutAnyOrigin] T:
#     # would be nice to build a is_struct to comptime_assert on T here, we can add that later.

#     # 1. Cast lit.ref<T> to kgen.ptr<kgen.struct>
#     addr = UnsafePointer(to=s).address
#     var ptr = __mlir_op.`lit.ref.to_pointer`(addr)

#     # 2. Use kgen.struct.gep with parametric index
#     var field_ptr = __mlir_op.`kgen.struct.gep`(ptr, idx)

#     # 3. Cast back to lit.ref with proper origin
#     return __mlir_op.`lit.ref.from_kgen_ptr`(field_ptr, origin_of(s))



trait Debug(ImplicitlyCopyable):
    fn debug(self):
        print(get_type_name[Self]() + ":")
        @parameter
        for i in range(struct_field_count[Self]()):
            comptime field_type = struct_field_types[Self]()[i]
            comptime field_name = struct_field_names[Self]()[i]
            if conforms_to(field_type, Stringable):
                ref field_ref = __struct_field_ref(i, Self)
                print("\t" + field_name + ": " + trait_downcast[Stringable](field_ref).__str__())



@fieldwise_init
@register_passable("trivial")
struct Test(Debug):
    var a: Int
    var b: Float16


fn main():
    var test = Test(a=1, b=Float16(1.0))
    test.debug()