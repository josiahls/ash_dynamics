"""Bindings for https://www.ffmpeg.org/doxygen/8.0/defs_8h_source.html"""
from sys.ffi import c_int

comptime AV_INPUT_BUFFER_PADDING_SIZE = c_int(64)
"""
Required number of additionally allocated bytes at the end of the input bitstream for decoding.
This is mainly needed because some optimized bitstream readers read
32 or 64 bit at once and could read over the end.<br>
Note: If the first 23 bits of the additional bytes are not 0, then damaged
MPEG bitstreams could cause overread and segfault.
"""
