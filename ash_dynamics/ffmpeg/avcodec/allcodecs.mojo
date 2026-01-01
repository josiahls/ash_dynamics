"""
Reference: 
https://www.ffmpeg.org/doxygen/8.0/allcodecs_8c.html
"""

from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec

from ash_dynamics.primitives._clib import ExternalFunction


comptime avcodec_find_decoder = ExternalFunction[
    "avcodec_find_decoder",
    fn (
        id: AVCodecID.ENUM_DTYPE,
    ) -> UnsafePointer[AVCodec, ImmutOrigin.external]
    # fn (id: AVCodecID.ENUM_DTYPE) -> OpaquePointer[ImmutOrigin.external]
]
"""Reference: 
https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html#ga51e35d01da2b3833b3afa839212c58fa.
"""
