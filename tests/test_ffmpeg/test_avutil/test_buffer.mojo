from testing.testing import assert_true, assert_equal
from testing.suite import TestSuite
from memory import alloc, memset
from ffi import c_size_t, c_uint, c_int, c_uchar, external_call
from ash_dynamics.ffmpeg.avutil.buffer import (
    AVBuffer,
    AVBufferRef,
    AVBufferPool,
)
from ash_dynamics.ffmpeg import avutil


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


fn my_alloc2(
    opaque: OpaquePointer[MutExternalOrigin], size: c_size_t
) -> UnsafePointer[AVBufferRef, MutExternalOrigin]:
    return my_alloc(size)


fn my_pool_free(opaque: OpaquePointer[MutExternalOrigin]) -> NoneType:
    return


def testav_buffer_alloc():
    var buf = avutil.av_buffer_alloc(128)
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 128)


def testav_buffer_allocz():
    var buf = avutil.av_buffer_allocz(128)
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 128)
    # allocz zeroes the data
    assert_equal(Int(buf[].data[0]), 0)


def test_av_buffer_create():
    var data = alloc[c_uchar](128)
    var buf = avutil.av_buffer_create(
        data.unsafe_origin_cast[MutExternalOrigin](),
        128,
        my_free,
        OpaquePointer[MutExternalOrigin](unsafe_from_address=0),
        0,
    )
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 128)


def test_av_buffer_ref():
    var buf = avutil.av_buffer_alloc(128)
    assert_true(Bool(buf))
    var ref_ = avutil.av_buffer_ref(
        buf.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )
    assert_true(Bool(ref_))
    assert_equal(
        avutil.av_buffer_get_ref_count(
            buf.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
        ),
        2,
    )


def test_av_buffer_unref():
    var buf = avutil.av_buffer_alloc(128)
    assert_true(Bool(buf))
    var buf_ptr = alloc[UnsafePointer[AVBufferRef, MutExternalOrigin]](1)
    buf_ptr[] = buf
    avutil.av_buffer_unref(buf_ptr.unsafe_origin_cast[MutExternalOrigin]())


def test_av_buffer_is_writable():
    var buf = avutil.av_buffer_alloc(128)
    assert_equal(
        avutil.av_buffer_is_writable(
            buf.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
        ),
        1,
    )


def test_av_buffer_get_opaque():
    var buf = avutil.av_buffer_alloc(128)
    # Default alloc sets opaque to NULL -- just check it doesn't crash.
    _ = avutil.av_buffer_get_opaque(
        buf.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )


def test_av_buffer_get_ref_count():
    var buf = avutil.av_buffer_alloc(128)
    assert_equal(
        avutil.av_buffer_get_ref_count(
            buf.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
        ),
        1,
    )


def test_av_buffer_make_writable():
    var buf = avutil.av_buffer_alloc(128)
    var buf_ptr = alloc[UnsafePointer[AVBufferRef, MutExternalOrigin]](1)
    buf_ptr[] = buf
    # Single ref -- already writable, so this is a no-op returning 0.
    assert_equal(
        avutil.av_buffer_make_writable(
            buf_ptr.unsafe_origin_cast[MutExternalOrigin]()
        ),
        0,
    )


def test_av_buffer_realloc():
    var buf = avutil.av_buffer_alloc(128)
    var buf_ptr = alloc[UnsafePointer[AVBufferRef, MutExternalOrigin]](1)
    buf_ptr[] = buf
    assert_equal(
        avutil.av_buffer_realloc(
            buf_ptr.unsafe_origin_cast[MutExternalOrigin](), 256
        ),
        0,
    )
    assert_equal(Int(buf_ptr[][].size), 256)


def test_av_buffer_replace():
    var src = avutil.av_buffer_alloc(128)
    var dst = alloc[UnsafePointer[AVBufferRef, MutExternalOrigin]](1)
    memset(dst, 0, 1)
    assert_equal(
        avutil.av_buffer_replace(
            dst.unsafe_origin_cast[MutExternalOrigin](),
            src.as_immutable().unsafe_origin_cast[ImmutExternalOrigin](),
        ),
        0,
    )
    assert_equal(Int(dst[][].size), 128)


def test_av_buffer_pool_init():
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    assert_true(Bool(pool))
    var buf = avutil.av_buffer_pool_get(
        pool.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )
    assert_true(Bool(buf))
    # my_alloc doubled the size -- proves our fn was called, not FFmpeg's default.
    assert_equal(Int(buf[].size), 256)


def test_av_buffer_pool_init2():
    var pool = avutil.av_buffer_pool_init2(
        128,
        OpaquePointer[MutExternalOrigin](unsafe_from_address=0),
        my_alloc2,
        my_pool_free,
    )
    assert_true(Bool(pool))
    var buf = avutil.av_buffer_pool_get(
        pool.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )
    assert_true(Bool(buf))
    assert_equal(Int(buf[].size), 256)


def test_av_buffer_pool_uninit():
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    assert_true(Bool(pool))
    var pool_ptr = alloc[UnsafePointer[AVBufferPool, MutExternalOrigin]](1)
    pool_ptr[] = pool
    avutil.av_buffer_pool_uninit(
        pool_ptr.unsafe_origin_cast[MutExternalOrigin]()
    )


def test_av_buffer_pool_get():
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    var buf1 = avutil.av_buffer_pool_get(
        pool.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )
    var buf2 = avutil.av_buffer_pool_get(
        pool.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )
    assert_true(Bool(buf1))
    assert_true(Bool(buf2))


def test_av_buffer_pool_buffer_get_opaque():
    var pool = avutil.av_buffer_pool_init(128, my_alloc)
    var buf = avutil.av_buffer_pool_get(
        pool.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )
    assert_true(Bool(buf))
    # Just check it doesn't crash -- opaque is NULL for pools with no pool_free.
    _ = avutil.av_buffer_pool_buffer_get_opaque(
        buf.as_immutable().unsafe_origin_cast[ImmutExternalOrigin]()
    )


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
    # testav_buffer_alloc()
    # testav_buffer_allocz()
    # test_av_buffer_create()
    # test_av_buffer_ref()
    # test_av_buffer_unref()
    # test_av_buffer_is_writable()
    # test_av_buffer_get_opaque()
    # test_av_buffer_get_ref_count()
    # test_av_buffer_make_writable()
    # test_av_buffer_realloc()
    # test_av_buffer_replace()
    # test_av_buffer_pool_init()
    # test_av_buffer_pool_init2()
    # test_av_buffer_pool_uninit()
    # test_av_buffer_pool_get()
    # test_av_buffer_pool_buffer_get_opaque()
