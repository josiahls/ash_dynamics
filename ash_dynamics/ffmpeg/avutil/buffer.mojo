"https://www.ffmpeg.org/doxygen/8.0/buffer_8h.html"
from sys.ffi import c_uchar, c_uint, c_int, c_size_t
from os.atomic import Atomic
from ash_dynamics.primitives._clib import (
    ExternalFunction,
    Debug,
)


struct AVBuffer(TrivialRegisterType):
    pass


@fieldwise_init
struct AVBufferRef(Debug, TrivialRegisterType):
    "https://www.ffmpeg.org/doxygen/8.0/structAVBufferRef.html"
    var buffer: UnsafePointer[AVBuffer, origin=MutExternalOrigin]
    var data: UnsafePointer[c_uchar, origin=MutExternalOrigin]
    var size: c_uint


comptime av_buffer_alloc = ExternalFunction[
    "av_buffer_alloc",
    fn(size: c_size_t) -> UnsafePointer[AVBufferRef, MutExternalOrigin],
]

comptime av_buffer_allocz = ExternalFunction[
    "av_buffer_allocz",
    fn(size: c_size_t) -> UnsafePointer[AVBufferRef, MutExternalOrigin],
]


comptime AV_BUFFER_FLAG_READONLY = c_int(1 << 0)


comptime av_buffer_create = ExternalFunction[
    "av_buffer_create",
    fn(
        data: UnsafePointer[c_uchar, MutAnyOrigin],
        size: c_size_t,
        free: UnsafePointer[
            ExternalFunction[
                "free",
                fn(
                    opaque: OpaquePointer[MutAnyOrigin],
                    data: UnsafePointer[c_uchar, MutAnyOrigin],
                ),
            ],
            ImmutAnyOrigin,
        ],
        opaque: OpaquePointer[MutAnyOrigin],
        flags: c_int,
    ) -> UnsafePointer[AVBufferRef, MutExternalOrigin],
]

comptime av_buffer_default_free = ExternalFunction[
    "av_buffer_default_free",
    fn(
        opaque: OpaquePointer[MutAnyOrigin],
        data: UnsafePointer[c_uchar, MutAnyOrigin],
    ) -> NoneType,
]


comptime av_buffer_ref = ExternalFunction[
    "av_buffer_ref",
    fn(
        buf: UnsafePointer[AVBufferRef, ImmutAnyOrigin]
    ) -> UnsafePointer[AVBufferRef, MutExternalOrigin],
]

comptime av_buffer_unref = ExternalFunction[
    "av_buffer_unref",
    fn(buf: UnsafePointer[AVBufferRef, MutAnyOrigin]) -> NoneType,
]

comptime av_buffer_is_writable = ExternalFunction[
    "av_buffer_is_writable",
    fn(buf: UnsafePointer[AVBufferRef, ImmutAnyOrigin]) -> c_int,
]

comptime av_buffer_get_opaque = ExternalFunction[
    "av_buffer_get_opaque",
    fn(
        buf: UnsafePointer[AVBufferRef, ImmutAnyOrigin]
    ) -> OpaquePointer[MutExternalOrigin],
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
struct AVBufferPool(TrivialRegisterType):
    pass


comptime av_buffer_pool_init = ExternalFunction[
    "av_buffer_pool_init",
    fn(
        size: c_size_t,
        alloc: UnsafePointer[
            ExternalFunction[
                "alloc",
                fn(
                    size: c_size_t,
                ) -> UnsafePointer[AVBufferRef, MutExternalOrigin],
            ],
            MutAnyOrigin,
        ],
    ) -> UnsafePointer[AVBufferPool, MutExternalOrigin],
]

comptime av_buffer_pool_init2 = ExternalFunction[
    "av_buffer_pool_init2",
    fn(
        size: c_size_t,
        opaque: OpaquePointer[MutAnyOrigin],
        alloc: UnsafePointer[
            ExternalFunction[
                "alloc",
                fn(
                    opaque: OpaquePointer[MutAnyOrigin], size: c_size_t
                ) -> UnsafePointer[AVBufferRef, MutExternalOrigin],
            ],
            MutAnyOrigin,
        ],
        pool_free: UnsafePointer[
            ExternalFunction[
                "pool_free",
                fn(opaque: OpaquePointer[MutAnyOrigin]) -> NoneType,
            ],
            MutAnyOrigin,
        ],
    ) -> UnsafePointer[AVBufferPool, MutExternalOrigin],
]

comptime av_buffer_pool_uninit = ExternalFunction[
    "av_buffer_pool_uninit",
    fn(pool: UnsafePointer[AVBufferPool, MutAnyOrigin]) -> NoneType,
]

comptime av_buffer_pool_get = ExternalFunction[
    "av_buffer_pool_get",
    fn(
        pool: UnsafePointer[AVBufferPool, ImmutAnyOrigin]
    ) -> UnsafePointer[AVBufferRef, MutExternalOrigin],
]

comptime av_buffer_pool_buffer_get_opaque = ExternalFunction[
    "av_buffer_pool_buffer_get_opaque",
    fn(
        ref_: UnsafePointer[AVBufferRef, ImmutAnyOrigin]
    ) -> OpaquePointer[MutExternalOrigin],
]
