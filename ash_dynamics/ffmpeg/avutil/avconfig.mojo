"""
The FFmpeg avconfig.h file is generated from the `.configure` build step.
Mojo is more dynamic, so we can handle this dynamically.

"""
from sys.ffi import c_int

# TODO: Swap the asisgnments for parameterized functions once the need arises.
comptime AV_HAVE_BIGENDIAN: c_int = 0
comptime AV_HAVE_FAST_UNALIGNED: c_int = 1
