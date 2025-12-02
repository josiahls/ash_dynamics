from sys.ffi import OwnedDLHandle


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
