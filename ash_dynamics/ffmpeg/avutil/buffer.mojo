"https://www.ffmpeg.org/doxygen/8.0/buffer_8h.html"
from ffi import c_uchar, c_uint, c_int, c_size_t
from os.atomic import Atomic
from ash_dynamics.primitives._clib import (
    ExternalFunction,
    MutOriginCastExternalFunction,
    ImmutOriginCastExternalFunction,
)


struct AVBuffer(Movable):
    pass


@fieldwise_init
struct AVBufferRef(TrivialRegisterPassable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVBufferRef.html"
    var buffer: UnsafePointer[AVBuffer, origin=MutAnyOrigin]
    var data: UnsafePointer[c_uchar, origin=MutAnyOrigin]
    var size: c_uint


comptime av_buffer_alloc = MutOriginCastExternalFunction[
    "av_buffer_alloc",
    fn(size: c_size_t) -> UnsafePointer[AVBufferRef, MutAnyOrigin],
    AVBufferRef,
]

comptime av_buffer_allocz = MutOriginCastExternalFunction[
    "av_buffer_allocz",
    fn(size: c_size_t) -> UnsafePointer[AVBufferRef, MutAnyOrigin],
    AVBufferRef,
]


comptime AV_BUFFER_FLAG_READONLY = c_int(1 << 0)


comptime av_buffer_create = MutOriginCastExternalFunction[
    "av_buffer_create",
    fn(
        data: UnsafePointer[c_uchar, MutAnyOrigin],
        size: c_size_t,
        free: fn(
            opaque: OpaquePointer[MutExternalOrigin],
            data: UnsafePointer[c_uchar, MutExternalOrigin],
        ) -> NoneType,
        opaque: OpaquePointer[MutExternalOrigin],
        flags: c_int,
    ) -> UnsafePointer[AVBufferRef, MutAnyOrigin],
    AVBufferRef,
]

comptime av_buffer_default_free = ExternalFunction[
    "av_buffer_default_free",
    fn(
        opaque: OpaquePointer[MutAnyOrigin],
        data: UnsafePointer[c_uchar, MutAnyOrigin],
    ) -> NoneType,
]


comptime av_buffer_ref = MutOriginCastExternalFunction[
    "av_buffer_ref",
    fn(
        buf: UnsafePointer[AVBufferRef, ImmutAnyOrigin]
    ) -> UnsafePointer[AVBufferRef, MutAnyOrigin],
    AVBufferRef,
]

comptime av_buffer_is_writable = ExternalFunction[
    "av_buffer_is_writable",
    fn(buf: UnsafePointer[AVBufferRef, ImmutAnyOrigin]) -> c_int,
]

comptime av_buffer_get_opaque = MutOriginCastExternalFunction[
    "av_buffer_get_opaque",
    fn(
        buf: UnsafePointer[AVBufferRef, ImmutAnyOrigin]
    ) -> OpaquePointer[MutAnyOrigin],
    AVBufferRef,
]

comptime av_buffer_get_ref_count = ExternalFunction[
    "av_buffer_get_ref_count",
    fn(buf: UnsafePointer[AVBufferRef, ImmutAnyOrigin]) -> c_int,
]

comptime av_buffer_make_writable = ExternalFunction[
    "av_buffer_make_writable",
    fn(
        buf: UnsafePointer[
            UnsafePointer[AVBufferRef, MutAnyOrigin], MutAnyOrigin
        ]
    ) -> c_int,
]


comptime av_buffer_realloc = ExternalFunction[
    "av_buffer_realloc",
    fn(
        buf: UnsafePointer[
            UnsafePointer[AVBufferRef, MutAnyOrigin], MutAnyOrigin
        ],
        size: c_size_t,
    ) -> c_int,
]

comptime av_buffer_replace = ExternalFunction[
    "av_buffer_replace",
    fn(
        dst: UnsafePointer[
            UnsafePointer[AVBufferRef, MutAnyOrigin], MutAnyOrigin
        ],
        src: UnsafePointer[AVBufferRef, ImmutAnyOrigin],
    ) -> c_int,
]


@fieldwise_init
struct AVBufferPool(Movable):
    pass


comptime av_buffer_pool_init = MutOriginCastExternalFunction[
    "av_buffer_pool_init",
    fn(
        size: c_size_t,
        alloc: fn(size: c_size_t) -> UnsafePointer[AVBufferRef, MutAnyOrigin],
    ) -> UnsafePointer[AVBufferPool, MutAnyOrigin],
    AVBufferPool,
]

comptime av_buffer_pool_init2 = MutOriginCastExternalFunction[
    "av_buffer_pool_init2",
    fn(
        size: c_size_t,
        opaque: OpaquePointer[MutAnyOrigin],
        alloc: fn(
            opaque: OpaquePointer[MutAnyOrigin], size: c_size_t
        ) -> UnsafePointer[AVBufferRef, MutAnyOrigin],
        pool_free: fn(opaque: OpaquePointer[MutAnyOrigin]) -> NoneType,
    ) -> UnsafePointer[AVBufferPool, MutAnyOrigin],
    AVBufferPool,
]

comptime av_buffer_pool_uninit = ExternalFunction[
    "av_buffer_pool_uninit",
    fn(
        pool: UnsafePointer[
            UnsafePointer[AVBufferPool, MutAnyOrigin], MutAnyOrigin
        ]
    ) -> NoneType,
]

comptime av_buffer_pool_get = MutOriginCastExternalFunction[
    "av_buffer_pool_get",
    fn(
        pool: UnsafePointer[AVBufferPool, ImmutAnyOrigin]
    ) -> UnsafePointer[AVBufferRef, MutAnyOrigin],
    AVBufferRef,
]

comptime av_buffer_pool_buffer_get_opaque = MutOriginCastExternalFunction[
    "av_buffer_pool_buffer_get_opaque",
    fn(
        ref_: UnsafePointer[AVBufferRef, ImmutAnyOrigin]
    ) -> OpaquePointer[MutAnyOrigin],
    AVBufferRef,
]
