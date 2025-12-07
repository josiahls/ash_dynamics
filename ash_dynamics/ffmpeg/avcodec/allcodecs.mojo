from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec

from ash_dynamics.primitives._clib import ExternalFunction


comptime _avcodec_find_decoder = ExternalFunction[
    "avcodec_find_decoder",
    fn (
        id: AVCodecID.ENUM_DTYPE,
    ) -> UnsafePointer[AVCodec, ImmutOrigin.external]
    # fn (id: AVCodecID.ENUM_DTYPE) -> OpaquePointer[ImmutOrigin.external]
]
"""Find a registered decoder with a matching codec ID.

Args:
- id: AVCodecID of the requested decoder.

Returns:
- A decoder if one was found, NULL otherwise.
"""
