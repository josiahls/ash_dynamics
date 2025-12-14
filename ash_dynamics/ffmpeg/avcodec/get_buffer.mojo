"""
This file declares private structs found in `get_buffer.c`.

These are opaque by nature and private to libraries dynamically linking against FFmpeg.
"""


comptime FramePool = OpaquePointer[MutOrigin.external]
"""Frame pool for the codec. Is an opaque pointer to a private struct."""
