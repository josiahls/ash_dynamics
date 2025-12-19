from testing.suite import TestSuite
from testing.testing import assert_equal
from ash_dynamics.primitives._clib import C_Union, TrivialOptionalField
from sys import size_of


def test_c_union():
    # Test a single type union's size against its MLIR type
    comptime UInt8Union = C_Union[UInt8]
    var single_type_union_instance: UInt8Union = UInt8(4)
    assert_equal(size_of[UInt8Union](), size_of[UInt8]())
    _ = single_type_union_instance

    # Test 3 int type unions size against the largest one
    comptime ThreeIntUnion = C_Union[Int8, Int16, Int32]
    var int_type_union_instance: ThreeIntUnion = Int32(4)
    assert_equal(size_of[ThreeIntUnion](), size_of[Int32]())
    _ = int_type_union_instance

    # Test against the variant mlir size
    comptime VariantUnion = C_Union[UInt8, UInt16]
    comptime UInt8AndUInt16Variant = __mlir_type[
        `!kgen.variant<`, `ui8`, `,`, `ui16`, `>`
    ]
    var variant_union_instance: VariantUnion = UInt16(4)
    # NOTE: variant has an additional 2 bytes for the discriminant
    assert_equal(size_of[VariantUnion](), size_of[UInt8AndUInt16Variant]() - 2)
    _ = variant_union_instance

    # Test against the union mlir size
    comptime UnionUnion = C_Union[UInt8, UInt16]
    comptime UInt32MLIRUnion = __mlir_type[`!pop.union<`, `ui32`, `>`]
    var union_union_instance: UnionUnion = UInt16(4)
    # NOTE: MLIR union is bugged. It takes 8 bytes regardless of
    # what is contained in it.
    assert_equal(size_of[UnionUnion](), size_of[UInt32MLIRUnion]() - 6)
    _ = union_union_instance


@fieldwise_init
struct ContainsActiveField:
    var active_field: TrivialOptionalField[True, Int64]


@fieldwise_init
struct ContainsInactiveField:
    var inactive_field: TrivialOptionalField[False, Int64]


def test_trivial_optional_field():
    # Test it can be used as a field and value can be accessed when active
    var with_active = ContainsActiveField(TrivialOptionalField[True, Int64](42))
    assert_equal(with_active.active_field[], 42)

    # Test inactive field struct has smaller size than active field struct
    assert_equal(size_of[ContainsActiveField](), size_of[Int64]())
    assert_equal(size_of[ContainsInactiveField](), 0)


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
