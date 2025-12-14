# from ash_dynamics.primitives._clib import StructWritable, TrivialOptionalField
# from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
# from ash_dynamics.ffmpeg.avutil.refstruct import AVRefStructPool
# from ash_dynamics.ffmpeg.avcodec.get_buffer import FramePool
# from sys.ffi import c_int, c_ushort, c_uint, c_uchar
# from utils import StaticTuple


# comptime CONFIG_LCMS2 = False


# @fieldwise_init
# @register_passable("trivial")
# struct AVCodecInternal(StructWritable):

#     var is_copy: c_int
#     """When using frame-threaded decoding, this field is set for the first
#     worker thread (e.g. to decode extradata just once)."""
#     var is_frame_mt: c_int
#     """This field is set to 1 when frame threading is being used and the parent
#     AVCodecContext of this AVCodecInternal is a worker-thread context (i.e.
#     one of those actually doing the decoding), 0 otherwise."""
#     var pad_samples: c_int
#     """Audio encoders can set this flag during init to indicate that they
#     want the small last frame to be padded to a multiple of pad_samples."""
#     var pool: UnsafePointer[FramePool, origin = ImmutOrigin.external]
#     """Frame pool for the codec."""
#     var progress_frame_pool: UnsafePointer[AVRefStructPool, origin = ImmutOrigin.external]
#     """Progress frame pool for the codec."""
#     var thread_ctx: OpaquePointer[MutOrigin.external]
#     """Thread context for the codec."""
#     var in_pkt: UnsafePointer[AVPacket, origin = ImmutOrigin.external]
#     """This packet is used to hold the packet given to decoders
#     implementing the .decode API; it is unused by the generic
#     code for decoders implementing the .receive_frame API and
#     may be freely used (but not freed) by them with the caveat
#     that the packet will be unreferenced generically in
#     avcodec_flush_buffers()."""
#     var bsf: UnsafePointer[AVBSFContext, origin = ImmutOrigin.external]

#     var last_pkt_props: UnsafePointer[AVPacket, origin = ImmutOrigin.external]
#     """Properties (timestamps+side data) extracted from the last packet passed
#     for decoding."""
#     var byte_buffer: UnsafePointer[c_uchar, MutOrigin.external]
#     """Temporary buffer used for encoders to store their bitstream."""
#     var byte_buffer_size: c_uint
#     """Size of the temporary buffer used for encoders to store their bitstream."""

#     var frame_thread_encoder: OpaquePointer[MutOrigin.external]
#     """Frame thread encoder for the codec."""

#     var in_frame: UnsafePointer[AVFrame, origin = ImmutOrigin.external]
#     """Input frame is stored here for encoders implementing the simple
#     encode API. Not allocated in other cases."""

#     var recon_frame: UnsafePointer[AVFrame, origin = ImmutOrigin.external]
#     """When the AV_CODEC_FLAG_RECON_FRAME flag is used. the encoder should store
#     here the reconstructed frame corresponding to the last returned packet.
#     Not allocated in other cases."""

#     var needs_close: c_int
#     """If this is set, then FFCodec->close (if existing) needs to be called
#     for the parent AVCodecContext."""

#     var skip_samples: c_int
#     """Number of audio samples to skip at the start of the next decoded frame."""

#     var hwaccel_priv_data: OpaquePointer[MutOrigin.external]
#     """hwaccel-specific private data."""

#     var draining: c_int
#     """Decoding: AVERROR_EOF has been returned from ff_decode_get_packet(); must
#     not be used by decoders that use the decode() callback, as they
#     do not call ff_decode_get_packet() directly.
#     Encoding: a flush frame has been submitted to avcodec_send_frame()."""

#     var buffer_pkt: UnsafePointer[AVPacket, origin = ImmutOrigin.external]
#     """Temporary buffers for newly received or not yet output packets/frames."""
#     var buffer_frame: UnsafePointer[AVFrame, origin = ImmutOrigin.external]
#     var draining_done: c_int

#     var icc: TrivialOptionalField[
#         CONFIG_LCMS2,
#         TrivialOptionalField[FFIccContext, origin = ImmutOrigin.external]
#     ]
#     """Used to read and write embedded ICC profiles."""

#     var warned_on_failed_allocation_from_fixed_pool: c_int
#     """Set when the user has been warned about a failed allocation from
#     a fixed frame pool."""
