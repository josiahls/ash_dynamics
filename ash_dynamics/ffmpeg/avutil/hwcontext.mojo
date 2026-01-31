"https://www.ffmpeg.org/doxygen/8.0/hwcontext_8h.html"
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
struct AVHWDeviceType(Debug, TrivialRegisterType):
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


@fieldwise_init
struct AVHWDeviceContext(Debug, TrivialRegisterType):
    "https://www.ffmpeg.org/doxygen/8.0/structAVHWDeviceContext.html"
    var av_class: UnsafePointer[AVClass, ImmutExternalOrigin]
    var type: AVHWDeviceType.ENUM_DTYPE
    var hwctx: UnsafePointer[
        OpaquePointer[MutExternalOrigin], MutExternalOrigin
    ]
    var free: UnsafePointer[
        ExternalFunction[
            "free",
            fn(ctx: UnsafePointer[AVHWDeviceContext, MutExternalOrigin]),
        ],
        ImmutExternalOrigin,
    ]
    var user_opaque: UnsafePointer[
        OpaquePointer[MutExternalOrigin], MutExternalOrigin
    ]


@fieldwise_init
struct AVHWFramesContext(Debug, TrivialRegisterType):
    "https://www.ffmpeg.org/doxygen/8.0/structAVHWFramesContext.html"
    var av_class: UnsafePointer[AVClass, ImmutExternalOrigin]
    var device_ref: UnsafePointer[AVBufferRef, MutExternalOrigin]
    var device_ctx: UnsafePointer[AVHWDeviceContext, MutExternalOrigin]
    var hwctx: OpaquePointer[MutExternalOrigin]
    var free: UnsafePointer[
        ExternalFunction[
            "free",
            fn(ctx: UnsafePointer[AVHWFramesContext, MutExternalOrigin]),
        ],
        ImmutExternalOrigin,
    ]
    var user_opaque: UnsafePointer[
        OpaquePointer[MutExternalOrigin], MutExternalOrigin
    ]
    var pool: UnsafePointer[AVBufferPool, MutExternalOrigin]
    var initial_pool_size: c_int
