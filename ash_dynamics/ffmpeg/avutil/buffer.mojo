"""Bindings for https://www.ffmpeg.org/doxygen/8.0/buffer_8h_source.html

AVBuffer is an API for reference-counted data buffers.

There are two core objects in this API -- AVBuffer and AVBufferRef. AVBuffer
represents the data buffer itself; it is opaque and not meant to be accessed
by the caller directly, but only through AVBufferRef. However, the caller may
e.g. compare two AVBuffer pointers to check whether two different references
are describing the same data buffer. AVBufferRef represents a single
reference to an AVBuffer and it is the object that may be manipulated by the
caller directly.

There are two functions provided for creating a new AVBuffer with a single
reference -- av_buffer_alloc() to just allocate a new buffer, and
av_buffer_create() to wrap an existing array in an AVBuffer. From an existing
reference, additional references may be created with av_buffer_ref().
Use av_buffer_unref() to free a reference (this will automatically free the
data once all the references are freed).

The convention throughout this API and the rest of FFmpeg is such that the
buffer is considered writable if there exists only one reference to it (and
it has not been marked as read-only). The av_buffer_is_writable() function is
provided to check whether this is true and av_buffer_make_writable() will
automatically create a new writable buffer when necessary.
Of course nothing prevents the calling code from violating this convention,
however that is safe only when all the existing references are under its
control.

@note Referencing and unreferencing the buffers is thread-safe and thus
may be done from multiple threads simultaneously without any need for
additional locking.

@note Two different references to the same buffer can point to different
parts of the buffer (i.e. their AVBufferRef.data will not be equal).
"""
from sys.ffi import c_uchar, c_uint, c_int, c_size_t
from os.atomic import Atomic
from ash_dynamics.primitives._clib import (
    StructWritable,
    StructWriter,
    ExternalFunction,
    Debug,
)


@fieldwise_init
@register_passable("trivial")
struct AVBuffer:
    """A reference counted buffer type. It is opaque and is meant to be used through
    references (AVBufferRef).
    """

    pass


@fieldwise_init
@register_passable("trivial")
struct AVBufferRef(Debug):
    """Represents a reference to a data buffer.

    References:
    - https://www.ffmpeg.org/doxygen/8.0/structAVBufferRef.html
    """

    var buffer: UnsafePointer[AVBuffer, origin = MutOrigin.external]
    "The buffer."
    var data: UnsafePointer[c_uchar, origin = MutOrigin.external]
    """The data buffer. It is considered writable if and only if
    this is the only reference to the buffer, in which case
    av_buffer_is_writable() returns 1."""
    var size: c_uint
    "Size of data in bytes."


comptime av_buffer_alloc = ExternalFunction[
    "av_buffer_alloc",
    fn (size: c_size_t) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]
"""Allocate an AVBuffer of the given size using av_malloc().

Returns:
- An AVBufferRef of given size or NULL when out of memory.
"""

comptime av_buffer_allocz = ExternalFunction[
    "av_buffer_allocz",
    fn (size: c_size_t) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]
"""Same as av_buffer_alloc(), except the returned buffer will be initialized
to zero."""


comptime AV_BUFFER_FLAG_READONLY = c_int(1 << 0)
"""Always treat the buffer as read-only, even when it has only one
reference."""


comptime av_buffer_create = ExternalFunction[
    "av_buffer_create",
    fn (
        data: UnsafePointer[c_uchar, MutOrigin.external],
        size: c_size_t,
        free: UnsafePointer[
            ExternalFunction[
                "free",
                fn (
                    opaque: OpaquePointer[MutOrigin.external],
                    data: UnsafePointer[c_uchar, MutOrigin.external],
                ),
            ],
            ImmutOrigin.external,
        ],
        opaque: OpaquePointer[MutOrigin.external],
        flags: c_int,
    ) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]
"""Create an AVBuffer from an existing array.

If this function is successful, data is owned by the AVBuffer. The caller may
only access data through the returned AVBufferRef and references derived from
it.
If this function fails, data is left untouched.

Args:
- data: The data array.
- size: The size of the data in bytes.
- free: A callback for freeing this buffer's data.
- opaque: A parameter to be got for processing or passed to free.
- flags: A combination of AV_BUFFER_FLAG_*.

Returns:
- An AVBufferRef referring to data on success, NULL on failure.
"""

comptime av_buffer_default_free = ExternalFunction[
    "av_buffer_default_free",
    fn (
        opaque: OpaquePointer[MutOrigin.external],
        data: UnsafePointer[c_uchar, MutOrigin.external],
    ) -> NoneType,
]
"""Default free callback, which calls av_free() on the buffer data.

This function is meant to be passed to av_buffer_create(), not called
directly.
"""


comptime av_buffer_ref = ExternalFunction[
    "av_buffer_ref",
    fn (
        buf: UnsafePointer[AVBufferRef, ImmutOrigin.external]
    ) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]
"""Create a new reference to an AVBuffer.

Returns:
- A new AVBufferRef referring to the same AVBuffer as buf or NULL on failure.
"""

comptime av_buffer_unref = ExternalFunction[
    "av_buffer_unref",
    fn (buf: UnsafePointer[AVBufferRef, MutOrigin.external]) -> NoneType,
]
"""Free a given reference and automatically free the buffer if there are no more
references to it.

Args:
- buf: The reference to be freed. The pointer is set to NULL on return.
"""

comptime av_buffer_is_writable = ExternalFunction[
    "av_buffer_is_writable",
    fn (buf: UnsafePointer[AVBufferRef, ImmutOrigin.external]) -> c_int,
]
"""Check if the buffer is writable.

Returns:
- 1 if the caller may write to the data referred to by buf (which is
true if and only if buf is the only reference to the underlying AVBuffer).
Return 0 otherwise.
A positive answer is valid until av_buffer_ref() is called on buf.
"""

comptime av_buffer_get_opaque = ExternalFunction[
    "av_buffer_get_opaque",
    fn (
        buf: UnsafePointer[AVBufferRef, ImmutOrigin.external]
    ) -> OpaquePointer[MutOrigin.external],
]
"""Get the opaque parameter set by av_buffer_create().

Returns:
- The opaque parameter set by av_buffer_create().
"""

comptime av_buffer_get_ref_count = ExternalFunction[
    "av_buffer_get_ref_count",
    fn (buf: UnsafePointer[AVBufferRef, ImmutOrigin.external]) -> c_int,
]
"""Get the number of references to the AVBuffer.

Returns:
- The number of references to the AVBuffer.
"""

comptime av_buffer_make_writable = ExternalFunction[
    "av_buffer_make_writable",
    fn (
        buf: UnsafePointer[
            UnsafePointer[AVBufferRef, MutOrigin.external], MutOrigin.external
        ]
    ) -> c_int,
]
"""Create a writable reference from a given buffer reference, avoiding data copy
if possible.

Args:
- buf: The buffer reference to make writable.
On success, buf is either left untouched, or it is unreferenced and a new writable AVBufferRef is
written in its place. On failure, buf is left untouched.

Returns:
- 0 on success, a negative AVERROR on failure.
"""


comptime av_buffer_realloc = ExternalFunction[
    "av_buffer_realloc",
    fn (
        buf: UnsafePointer[
            UnsafePointer[AVBufferRef, MutOrigin.external], MutOrigin.external
        ],
        size: c_size_t,
    ) -> c_int,
]
"""Reallocate a given buffer.

Args:
- buf: The buffer reference to reallocate.
On success, buf will be unreferenced and a new reference with the required size will be
written in its place. On failure, buf will be left untouched.
*buf may be NULL, then a new buffer is allocated.
- size: The required new buffer size.

Returns:
- 0 on success, a negative AVERROR on failure.

@note the buffer is actually reallocated with av_realloc() only if it was
initially allocated through av_buffer_realloc(NULL) and there is only one
reference to it (i.e. the one passed to this function). In all other cases
a new buffer is allocated and the data is copied.
"""

comptime av_buffer_replace = ExternalFunction[
    "av_buffer_replace",
    fn (
        dst: UnsafePointer[
            UnsafePointer[AVBufferRef, MutOrigin.external], MutOrigin.external
        ],
        src: UnsafePointer[AVBufferRef, ImmutOrigin.external],
    ) -> c_int,
]
"""Ensure dst refers to the same data as src.

@note When *dst is already equivalent to src, do nothing. Otherwise unreference dst
and replace it with a new reference to src.

Args:
- dst: Pointer to either a valid buffer reference or NULL. On success,
this will point to a buffer reference equivalent to src. On failure, dst will be left untouched.
- src: A buffer reference to replace dst with. May be NULL, then this
function is equivalent to av_buffer_unref(dst).

Returns:
- 0 on success, a negative AVERROR on failure.
"""


@fieldwise_init
@register_passable("trivial")
struct AVBufferPool:
    """AVBufferPool is an API for a lock-free thread-safe pool of AVBuffers.

    Frequently allocating and freeing large buffers may be slow. AVBufferPool is
    meant to solve this in cases when the caller needs a set of buffers of the
    same size (the most obvious use case being buffers for raw video or audio
    frames).

    At the beginning, the user must call av_buffer_pool_init() to create the
    buffer pool. Then whenever a buffer is needed, call av_buffer_pool_get() to
    get a reference to a new buffer, similar to av_buffer_alloc(). This new
    reference works in all aspects the same way as the one created by
    av_buffer_alloc(). However, when the last reference to this buffer is
    unreferenced, it is returned to the pool instead of being freed and will be
    reused for subsequent av_buffer_pool_get() calls.

    When the caller is done with the pool and no longer needs to allocate any new
    buffers, av_buffer_pool_uninit() must be called to mark the pool as freeable.
    Once all the buffers are released, it will automatically be freed.

    Allocating and releasing buffers with this API is thread-safe as long as
    either the default alloc callback is used, or the user-supplied one is
    thread-safe.

    The buffer pool. This structure is opaque and not meant to be accessed
    directly. It is allocated with av_buffer_pool_init() and freed with
    av_buffer_pool_uninit().
    """

    pass


comptime av_buffer_pool_init = ExternalFunction[
    "av_buffer_pool_init",
    fn (
        size: c_size_t,
        alloc: UnsafePointer[
            ExternalFunction[
                "alloc",
                fn (
                    size: c_size_t,
                ) -> UnsafePointer[AVBufferRef, MutOrigin.external],
            ],
            MutOrigin.external,
        ],
    ) -> UnsafePointer[AVBufferPool, MutOrigin.external],
]
"""Allocate and initialize a buffer pool.

Args:
- size: The size of the buffers in the pool.
- alloc: A function that will be used to allocate new buffers when the
pool is empty. May be NULL, then the default allocator will be used
(av_buffer_alloc()).
Returns:
- A new AVBufferPool or NULL on failure.
"""

comptime av_buffer_pool_init2 = ExternalFunction[
    "av_buffer_pool_init2",
    fn (
        size: c_size_t,
        opaque: OpaquePointer[MutOrigin.external],
        alloc: UnsafePointer[
            ExternalFunction[
                "alloc",
                fn (
                    opaque: OpaquePointer[MutOrigin.external], size: c_size_t
                ) -> UnsafePointer[AVBufferRef, MutOrigin.external],
            ],
            MutOrigin.external,
        ],
        pool_free: UnsafePointer[
            ExternalFunction[
                "pool_free",
                fn (opaque: OpaquePointer[MutOrigin.external]) -> NoneType,
            ],
            MutOrigin.external,
        ],
    ) -> UnsafePointer[AVBufferPool, MutOrigin.external],
]
"""Allocate and initialize a buffer pool with a more complex allocator.

Args:
- size: The size of the buffers in the pool.
- opaque: Arbitrary user data used by the allocator.
- alloc: A function that will be used to allocate new buffers when the
pool is empty. May be NULL, then the default allocator will be used
(av_buffer_alloc()).
- pool_free: A function that will be called immediately before the pool
is freed. I.e. after av_buffer_pool_uninit() is called by the caller and all 
the frames are returned to the pool and freed. It is intended to uninitialize 
the user opaque data. May be NULL.

Returns:
- A new AVBufferPool or NULL on failure.
"""

comptime av_buffer_pool_uninit = ExternalFunction[
    "av_buffer_pool_uninit",
    fn (pool: UnsafePointer[AVBufferPool, MutOrigin.external]) -> NoneType,
]
"""Mark the pool as being available for freeing. It will actually be freed only
once all the allocated buffers associated with the pool are released. Thus it
is safe to call this function while some of the allocated buffers are still
in use.

Args:
- pool: Pointer to the pool to be freed. It will be set to NULL on return.
"""

comptime av_buffer_pool_get = ExternalFunction[
    "av_buffer_pool_get",
    fn (
        pool: UnsafePointer[AVBufferPool, ImmutOrigin.external]
    ) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]
"""Allocate a new AVBuffer, reusing an old buffer from the pool when available.
This function may be called simultaneously from multiple threads.

Returns:
- A new AVBufferRef or NULL on failure.
"""

comptime av_buffer_pool_buffer_get_opaque = ExternalFunction[
    "av_buffer_pool_buffer_get_opaque",
    fn (
        ref_: UnsafePointer[AVBufferRef, ImmutOrigin.external]
    ) -> OpaquePointer[MutOrigin.external],
]
"""Query the original opaque parameter of an allocated buffer in the pool.

Note: We use `ref_` instead of `ref` since in mojo `ref` is a keyword word.

Args:
- ref: A buffer reference to a buffer returned by av_buffer_pool_get.

Returns:
- The opaque parameter set by the buffer allocator function of the
buffer pool.

@note the opaque parameter of ref is used by the buffer pool implementation,
therefore you have to use this function to access the original opaque
parameter of an allocated buffer.
"""
