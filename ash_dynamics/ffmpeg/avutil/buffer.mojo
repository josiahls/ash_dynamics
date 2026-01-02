"https://www.ffmpeg.org/doxygen/8.0/buffer_8h.html"
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
    pass


@fieldwise_init
@register_passable("trivial")
struct AVBufferRef(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVBufferRef.html"
    var buffer: UnsafePointer[AVBuffer, origin = MutOrigin.external]
    var data: UnsafePointer[c_uchar, origin = MutOrigin.external]
    var size: c_uint


comptime av_buffer_alloc = ExternalFunction[
    "av_buffer_alloc",
    fn (size: c_size_t) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]

comptime av_buffer_allocz = ExternalFunction[
    "av_buffer_allocz",
    fn (size: c_size_t) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]


comptime AV_BUFFER_FLAG_READONLY = c_int(1 << 0)


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

comptime av_buffer_default_free = ExternalFunction[
    "av_buffer_default_free",
    fn (
        opaque: OpaquePointer[MutOrigin.external],
        data: UnsafePointer[c_uchar, MutOrigin.external],
    ) -> NoneType,
]


comptime av_buffer_ref = ExternalFunction[
    "av_buffer_ref",
    fn (
        buf: UnsafePointer[AVBufferRef, ImmutOrigin.external]
    ) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]

comptime av_buffer_unref = ExternalFunction[
    "av_buffer_unref",
    fn (buf: UnsafePointer[AVBufferRef, MutOrigin.external]) -> NoneType,
]

comptime av_buffer_is_writable = ExternalFunction[
    "av_buffer_is_writable",
    fn (buf: UnsafePointer[AVBufferRef, ImmutOrigin.external]) -> c_int,
]

comptime av_buffer_get_opaque = ExternalFunction[
    "av_buffer_get_opaque",
    fn (
        buf: UnsafePointer[AVBufferRef, ImmutOrigin.external]
    ) -> OpaquePointer[MutOrigin.external],
]

comptime av_buffer_get_ref_count = ExternalFunction[
    "av_buffer_get_ref_count",
    fn (buf: UnsafePointer[AVBufferRef, ImmutOrigin.external]) -> c_int,
]

comptime av_buffer_make_writable = ExternalFunction[
    "av_buffer_make_writable",
    fn (
        buf: UnsafePointer[
            UnsafePointer[AVBufferRef, MutOrigin.external], MutOrigin.external
        ]
    ) -> c_int,
]


comptime av_buffer_realloc = ExternalFunction[
    "av_buffer_realloc",
    fn (
        buf: UnsafePointer[
            UnsafePointer[AVBufferRef, MutOrigin.external], MutOrigin.external
        ],
        size: c_size_t,
    ) -> c_int,
]

comptime av_buffer_replace = ExternalFunction[
    "av_buffer_replace",
    fn (
        dst: UnsafePointer[
            UnsafePointer[AVBufferRef, MutOrigin.external], MutOrigin.external
        ],
        src: UnsafePointer[AVBufferRef, ImmutOrigin.external],
    ) -> c_int,
]


@fieldwise_init
@register_passable("trivial")
struct AVBufferPool:
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

comptime av_buffer_pool_uninit = ExternalFunction[
    "av_buffer_pool_uninit",
    fn (pool: UnsafePointer[AVBufferPool, MutOrigin.external]) -> NoneType,
]

comptime av_buffer_pool_get = ExternalFunction[
    "av_buffer_pool_get",
    fn (
        pool: UnsafePointer[AVBufferPool, ImmutOrigin.external]
    ) -> UnsafePointer[AVBufferRef, MutOrigin.external],
]

comptime av_buffer_pool_buffer_get_opaque = ExternalFunction[
    "av_buffer_pool_buffer_get_opaque",
    fn (
        ref_: UnsafePointer[AVBufferRef, ImmutOrigin.external]
    ) -> OpaquePointer[MutOrigin.external],
]
