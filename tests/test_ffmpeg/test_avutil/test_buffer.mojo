from testing.testing import assert_true, assert_equal
from testing.suite import TestSuite
from memory import alloc, memset
from ffi import c_size_t, c_uint, c_int, c_uchar, external_call
from ash_dynamics.ffmpeg.avutil.buffer import (
    AVBuffer,
    AVBufferRef,
    AVBufferPool,
)
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
    var data: UnsafePointer[c_uchar, MutAnyOrigin]
    var size: c_size_t
    var refcount: c_uint
    var _pad: c_uint
    var free: fn(
        OpaquePointer[MutExternalOrigin],
        UnsafePointer[c_uchar, MutExternalOrigin],
    ) -> NoneType
    var opaque: OpaquePointer[MutAnyOrigin]
    var flags: c_int
    var flags_internal: c_int


fn my_alloc(size: c_size_t) -> UnsafePointer[AVBufferRef, MutAnyOrigin]:
    # Custom logic: allocate double the requested size.
    var n = size + size

    var data = alloc[c_uchar](Int(n))

    var buf = alloc[AVBufferLayout](1)
    memset(buf, 0, 1)
    buf[].data = data
    buf[].size = n
    buf[].refcount = 1
    buf[].free = my_free

    var ref_ = alloc[AVBufferRef](1)
    ref_[].buffer = buf.bitcast[AVBuffer]()
    ref_[].data = data
    ref_[].size = c_uint(Int(n))

    return ref_


fn my_alloc2(
    opaque: OpaquePointer[MutAnyOrigin], size: c_size_t
) -> UnsafePointer[AVBufferRef, MutAnyOrigin]:
    return my_alloc(size)


fn my_pool_free(opaque: OpaquePointer[MutAnyOrigin]) -> NoneType:
    return


def test_av_buffer_alloc():
    var avutil = Avutil()
    var buf = avutil.av_buffer_alloc(128)
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 128)
    # Assert buffer/data still valid while avutil in scope (lifetime check)
    assert_true(Bool(buf[].buffer))
    assert_true(Bool(buf[].data))


def test_av_buffer_allocz():
    var avutil = Avutil()
    var buf = avutil.av_buffer_allocz(128)
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 128)
    # allocz zeroes the data
    assert_equal(Int(buf[].data[0]), 0)


def test_av_buffer_create():
    var avutil = Avutil()
    var data = alloc[c_uchar](128).as_any_origin()
    var buf = avutil.av_buffer_create(
        data,
        128,
        my_free,
        OpaquePointer[MutAnyOrigin](unsafe_from_address=0),
        0,
    )
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 128)


def test_av_buffer_create_with_opaque():
    """Verify we can pass a valid opaque pointer and retrieve it via av_buffer_get_opaque.
    """
    var avutil = Avutil()
    var data = alloc[c_uchar](128).as_any_origin()
    var opaque_storage = alloc[Int](1)
    opaque_storage[0] = 0xDEADBEEF
    var opaque = opaque_storage.bitcast[NoneType]()
    var buf = avutil.av_buffer_create(
        data,
        128,
        my_free,
        opaque,
        0,
    )
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 128)
    var retrieved = avutil.av_buffer_get_opaque(buf.as_immutable())
    assert_true(Bool(retrieved))
    assert_equal(Int(opaque), Int(retrieved))
    # Cleanup: unref buf (calls my_free on data), then free our opaque storage
    # var buf_ptr = alloc[UnsafePointer[AVBufferRef, MutExternalOrigin]](1)
    # buf_ptr[0] = buf.unsafe_origin_cast[MutExternalOrigin]()
    # avutil.av_buffer_unref(buf_ptr)
    opaque_storage.free()


def test_av_buffer_ref():
    var avutil = Avutil()
    var buf = avutil.av_buffer_alloc(128)
    assert_true(Bool(buf))
    var ref_ = avutil.av_buffer_ref(buf.as_immutable())
    assert_true(Bool(ref_))
    assert_equal(
        avutil.av_buffer_get_ref_count(buf.as_immutable()),
        2,
    )
    var buffer_ptr = UnsafePointer(to=ref_[].buffer)
    var data_ptr = UnsafePointer(to=ref_[].data)
    # Assert buffer/data still valid while avutil in scope (lifetime check)
    assert_true(Bool(buffer_ptr))
    assert_true(Bool(data_ptr))


# def test_av_buffer_unref():
#     var avutil = Avutil()
#     var buf = avutil.av_buffer_alloc(128)
#     assert_true(Bool(buf))
#     var buf_ptr = alloc[UnsafePointer[AVBufferRef, MutExternalOrigin]](1)
#     buf_ptr[0] = buf.unsafe_origin_cast[MutExternalOrigin]()
#     avutil.av_buffer_unref(buf_ptr)

#     _ = avutil


def test_av_buffer_is_writable():
    var avutil = Avutil()
    var buf = avutil.av_buffer_alloc(128)
    assert_equal(
        avutil.av_buffer_is_writable(buf.as_immutable()),
        1,
    )


def test_av_buffer_get_opaque():
    var avutil = Avutil()
    var buf = avutil.av_buffer_alloc(128)
    # Default alloc sets opaque to NULL -- just check it doesn't crash.
    _ = avutil.av_buffer_get_opaque(buf.as_immutable())


def test_av_buffer_get_ref_count():
    var avutil = Avutil()
    var buf = avutil.av_buffer_alloc(128)
    assert_equal(
        avutil.av_buffer_get_ref_count(buf.as_immutable()),
        1,
    )


def test_av_buffer_make_writable():
    var avutil = Avutil()
    var buf = avutil.av_buffer_alloc(128)
    var buf_ptr = UnsafePointer(to=buf)
    # Single ref -- already writable, so this is a no-op returning 0.
    assert_equal(
        avutil.av_buffer_make_writable(buf_ptr),
        0,
    )


def test_av_buffer_realloc():
    var avutil = Avutil()
    var buf = avutil.av_buffer_alloc(128)
    var buf_ptr = UnsafePointer(to=buf)
    assert_equal(
        avutil.av_buffer_realloc(buf_ptr, 256),
        0,
    )
    assert_equal(Int(buf_ptr[][].size), 256)


def test_av_buffer_replace():
    var avutil = Avutil()
    var src = avutil.av_buffer_alloc(128)
    var dst = alloc[UnsafePointer[AVBufferRef, MutAnyOrigin]](
        1
    ).unsafe_origin_cast[origin_of(avutil.lib)]()
    memset(dst, 0, 1)
    assert_equal(
        avutil.av_buffer_replace(
            dst,
            src.as_immutable(),
        ),
        0,
    )
    assert_equal(Int(dst[][].size), 128)


def test_av_buffer_pool_init():
    var avutil = Avutil()
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    assert_true(Bool(pool))
    var buf = avutil.av_buffer_pool_get(pool.as_immutable())
    assert_true(Bool(buf))
    # my_alloc doubled the size -- proves our fn was called, not FFmpeg's default.
    assert_equal(Int(buf[].size), 256)


def test_av_buffer_pool_init2():
    var avutil = Avutil()
    var opaque = OpaquePointer[MutExternalOrigin](
        unsafe_from_address=0
    ).unsafe_origin_cast[origin_of(avutil.lib)]()
    var pool = avutil.av_buffer_pool_init2(
        128,
        opaque,
        my_alloc2,
        my_pool_free,
    )
    assert_true(Bool(pool))
    var buf = avutil.av_buffer_pool_get(pool.as_immutable())
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 256)


def test_av_buffer_pool_uninit():
    var avutil = Avutil()
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    assert_true(Bool(pool))
    var pool_ptr = UnsafePointer(to=pool)
    avutil.av_buffer_pool_uninit(pool_ptr)


def test_av_buffer_pool_get():
    var avutil = Avutil()
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    var buf1 = avutil.av_buffer_pool_get(pool.as_immutable())
    var buf2 = avutil.av_buffer_pool_get(pool.as_immutable())
    assert_true(Bool(buf1))
    assert_true(Bool(buf2))
    assert_equal(buf1[].size, 128 * 2)  # Custom alloc doubles the size
    assert_equal(buf2[].size, 128 * 2)  # Custom alloc doubles the size


def test_av_buffer_pool_buffer_get_opaque():
    var avutil = Avutil()
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    var buf = avutil.av_buffer_pool_get(pool.as_immutable())
    assert_true(Bool(buf))
    # Just check it doesn't crash -- opaque is NULL for pools with no pool_free.
    _ = avutil.av_buffer_pool_buffer_get_opaque(buf.as_immutable())


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
