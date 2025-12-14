comptime AVRefStructPool = OpaquePointer[MutOrigin.external]
"""The buffer pool. This structure is opaque and not meant to be accessed
directly. It is allocated with the allocators below and freed with
av_refstruct_pool_uninit()."""
