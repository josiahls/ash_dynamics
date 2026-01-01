from sys.ffi import c_char, c_int, c_uchar
from ash_dynamics.primitives._clib import (
    ExternalFunction,
    Debug,
)

from reflection import get_type_name
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef, AVBufferPool
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout


@fieldwise_init
@register_passable("trivial")
struct AVHWDeviceType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_HWDEVICE_TYPE_NONE = c_int(0)
    comptime AV_HWDEVICE_TYPE_VDPAU = c_int(1)
    comptime AV_HWDEVICE_TYPE_CUDA = c_int(2)
    comptime AV_HWDEVICE_TYPE_VAAPI = c_int(3)
    comptime AV_HWDEVICE_TYPE_DXVA2 = c_int(4)
    comptime AV_HWDEVICE_TYPE_QSV = c_int(5)
    comptime AV_HWDEVICE_TYPE_VIDEOTOOLBOX = c_int(6)
    comptime AV_HWDEVICE_TYPE_D3D11VA = c_int(7)
    comptime AV_HWDEVICE_TYPE_DRM = c_int(8)
    comptime AV_HWDEVICE_TYPE_OPENCL = c_int(9)
    comptime AV_HWDEVICE_TYPE_MEDIACODEC = c_int(10)
    comptime AV_HWDEVICE_TYPE_VULKAN = c_int(11)
    comptime AV_HWDEVICE_TYPE_D3D12VA = c_int(12)
    comptime AV_HWDEVICE_TYPE_AMF = c_int(13)
    comptime AV_HWDEVICE_TYPE_OHCODEC = c_int(14)
    """OpenHarmony Codec device."""


@fieldwise_init
@register_passable("trivial")
struct AVHWDeviceContext(Debug):
    """This struct aggregates all the (hardware/vendor-specific) "high-level" state,
    i.e. state that is not tied to a concrete processing configuration.
    E.g., in an API that supports hardware-accelerated encoding and decoding,
    this struct will (if possible) wrap the state that is common to both encoding
    and decoding and from which specific instances of encoders or decoders can be
    derived.

    This struct is reference-counted with the AVBuffer mechanism. The
    av_hwdevice_ctx_alloc() constructor yields a reference, whose data field
    points to the actual AVHWDeviceContext. Further objects derived from
    AVHWDeviceContext (such as AVHWFramesContext, describing a frame pool with
    specific properties) will hold an internal reference to it. After all the
    references are released, the AVHWDeviceContext itself will be freed,
    optionally invoking a user-specified callback for uninitializing the hardware
    state.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    """A class for logging. Set by av_hwdevice_ctx_alloc()."""
    var type: AVHWDeviceType.ENUM_DTYPE
    """This field identifies the underlying API used for hardware access.
    
    This field is set when this struct is allocated and never changed
    afterwards.
    """
    var hwctx: UnsafePointer[
        OpaquePointer[MutOrigin.external], MutOrigin.external
    ]
    """The format-specific data, allocated and freed by libavutil along with
    this context.
    
    Should be cast by the user to the format-specific context defined in the
    corresponding header (hwcontext_*.h) and filled as described in the
    documentation before calling av_hwdevice_ctx_init().

    After calling av_hwdevice_ctx_init() this struct should not be modified
    by the caller.
    """
    var free: UnsafePointer[
        ExternalFunction[
            "free",
            fn (ctx: UnsafePointer[AVHWDeviceContext, MutOrigin.external]),
        ],
        ImmutOrigin.external,
    ]
    """This field may be set by the caller before calling av_hwdevice_ctx_init().
    
    If non-NULL, this callback will be called when the last reference to
    this context is unreferenced, immediately before it is freed.

    @note when other objects (e.g an AVHWFramesContext) are derived from this
    struct, this callback will be invoked after all such child objects
    are fully uninitialized and their respective destructors invoked.
    """
    var user_opaque: UnsafePointer[
        OpaquePointer[MutOrigin.external], MutOrigin.external
    ]
    """Arbitrary user data, to be used e.g. by the free() callback."""


@fieldwise_init
@register_passable("trivial")
struct AVHWFramesContext(Debug):
    """This struct describes a set or pool of "hardware" frames (i.e. those with
    data not located in normal system memory). All the frames in the pool are
    assumed to be allocated in the same way and interchangeable.

    This struct is reference-counted with the AVBuffer mechanism and tied to a
    given AVHWDeviceContext instance. The av_hwframe_ctx_alloc() constructor
    yields a reference, whose data field points to the actual AVHWFramesContext.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    """A class for logging. Set by av_hwframe_ctx_alloc()."""
    var device_ref: UnsafePointer[AVBufferRef, MutOrigin.external]
    """A reference to the parent AVHWDeviceContext. This reference is owned and
    managed by the enclosing AVHWFramesContext, but the caller may derive
    additional references from it."""
    var device_ctx: UnsafePointer[AVHWDeviceContext, MutOrigin.external]
    """The parent AVHWDeviceContext. This is simply a pointer to
    device_ref->data provided for convenience."""
    var hwctx: OpaquePointer[MutOrigin.external]
    """The format-specific data, allocated and freed automatically along with
    this context."""
    var free: UnsafePointer[
        ExternalFunction[
            "free",
            fn (ctx: UnsafePointer[AVHWFramesContext, MutOrigin.external]),
        ],
        ImmutOrigin.external,
    ]
    """This field may be set by the caller before calling av_hwframe_ctx_init().
    If non-NULL, this callback will be called when the last reference to
    this context is unreferenced, immediately before it is freed."""
    var user_opaque: UnsafePointer[
        OpaquePointer[MutOrigin.external], MutOrigin.external
    ]
    """Arbitrary user data, to be used e.g. by the free() callback."""
    var pool: UnsafePointer[AVBufferPool, MutOrigin.external]
    """A pool from which the frames are allocated by av_hwframe_get_buffer()."""
    var initial_pool_size: c_int
    """Initial size of the frame pool. If a device type does not support dynamically resizing the pool, then this is also the maximum pool size."""
