"""Minimal reproduction: struct disappears when a parameter references Self.T.

BUG: When a struct has a comptime parameter like `name: Self.T` that references
another Self parameter, the struct "disappears" from the compiler's view.
Calling non-existent methods produces no error, and the compiler claims the
variable is "never used".

Expected: `w.fake_method()` should produce an error like:
    'Wrapper[MyStruct]' value has no attribute 'fake_method'

Actual: No error. Compiler warns "variable 'w' was never used" despite being used.
"""


struct Wrapper[
    name: Self.T, //,
    T: AnyType,
]:
    fn __init__(out self):
        pass

    fn real_method(self):
        pass


struct MyStruct:
    fn __init__(out self):
        pass

    fn test(self):
        var w = Wrapper[Self]()
        w.real_method()  # Exists - should work
        w.fake_method()  # BUG: Should error but doesn't!


fn main():
    var s = MyStruct()
    s.test()
