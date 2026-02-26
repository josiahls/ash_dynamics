from testing.testing import assert_true, assert_equal
from memory import alloc, memset
from ffi import c_size_t, c_uint, c_int, c_uchar, external_call
from ash_dynamics.ffmpeg.avutil.buffer import AVBuffer, AVBufferRef
from ash_dynamics.ffmpeg.avutil import Avutil


fn my_free(
    opaque: OpaquePointer[MutExternalOrigin],
    data: UnsafePointer[c_uchar, MutExternalOrigin],
):
    # free() from libc is always globally visible, unlike FFmpeg symbols.
    external_call["free", NoneType](data)


# Mirrors AVBuffer's actual C layout (libavutil/buffer_internal.h):
#   uint8_t    *data;                  // offset  0, 8 bytes
#   size_t      size;                  // offset  8, 8 bytes
#   atomic_uint refcount;              // offset 16, 4 bytes (unsigned int in memory)
#   <padding>                          // offset 20, 4 bytes
#   void (*free)(void*, uint8_t*);     // offset 24, 8 bytes
#   void       *opaque;                // offset 32, 8 bytes
#   int         flags;                 // offset 40, 4 bytes
#   int         flags_internal;        // offset 44, 4 bytes
struct AVBufferLayout:
    var data: UnsafePointer[c_uchar, MutExternalOrigin]
    var size: c_size_t
    var refcount: c_uint
    var _pad: c_uint
    var free: fn(
        OpaquePointer[MutExternalOrigin],
        UnsafePointer[c_uchar, MutExternalOrigin],
    ) -> NoneType
    var opaque: OpaquePointer[MutExternalOrigin]
    var flags: c_int
    var flags_internal: c_int


fn my_alloc(size: c_size_t) -> UnsafePointer[AVBufferRef, MutExternalOrigin]:
    # Custom logic: allocate double the requested size.
    var n = size + size

    var data = alloc[c_uchar](Int(n))

    var buf = alloc[AVBufferLayout](1)
    memset(buf, 0, 1)
    buf[].data = data.unsafe_origin_cast[MutExternalOrigin]()
    buf[].size = n
    buf[].refcount = 1
    buf[].free = my_free

    var ref_ = alloc[AVBufferRef](1)
    ref_[].buffer = buf.unsafe_origin_cast[MutExternalOrigin]().bitcast[
        AVBuffer
    ]()
    ref_[].data = data.unsafe_origin_cast[MutExternalOrigin]()
    ref_[].size = c_uint(Int(n))

    return ref_.unsafe_origin_cast[MutExternalOrigin]()


def test_av_buffer_pool_init():
    var avutil = Avutil()
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    assert_true(Bool(pool))
    var buf = avutil.av_buffer_pool_get(
        pool.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )
    assert_true(Bool(buf))
    # my_alloc doubled the size -- proves our fn was called, not FFmpeg's default.
    assert_equal(Int(buf[].size), 256)
    _ = avutil


def main():
    test_av_buffer_pool_init()
