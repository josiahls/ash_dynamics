"""

Symbols present can be listed via:

nm -D $ASH_DYNAMICS_SO_INSTALL_PREFIX/libavcodec.so
"""

from sys.ffi import OwnedDLHandle, c_int, c_float
from os.env import getenv
import os
from ash_dynamics.ffmpeg.avcodec.packet import (
    AVPacket,
    av_packet_alloc,
    av_packet_clone,
    av_packet_free,
    av_new_packet,
    av_shrink_packet,
    av_grow_packet,
    av_packet_from_data,
    av_packet_new_side_data,
    av_packet_add_side_data,
    av_packet_shrink_side_data,
    av_packet_get_side_data,
    av_packet_pack_dictionary,
    av_packet_unpack_dictionary,
    av_packet_free_side_data,
    av_packet_ref,
    av_packet_unref,
    av_packet_move_ref,
    av_packet_copy_props,
    av_packet_make_refcounted,
    av_packet_make_writable,
    av_packet_rescale_ts,
    av_container_fifo_alloc_avpacket,
)
from ash_dynamics.ffmpeg.avcodec.allcodecs import avcodec_find_decoder
from ash_dynamics.ffmpeg.avutil.frame import av_frame_alloc
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.avcodec import (
    avcodec_version,
    avcodec_configuration,
    avcodec_license,
    avcodec_alloc_context3,
    avcodec_free_context,
    avcodec_get_class,
    avcodec_get_subtitle_rect_class,
    avcodec_parameters_from_context,
    avcodec_parameters_to_context,
    avcodec_open2,
    avsubtitle_free,
    avcodec_default_get_buffer2,
    avcodec_default_get_encode_buffer,
    avcodec_align_dimensions,
    avcodec_align_dimensions2,
    avcodec_decode_subtitle2,
    avcodec_send_packet,
    avcodec_receive_frame,
    avcodec_send_frame,
    avcodec_receive_packet,
    avcodec_get_hw_frames_parameters,
    avcodec_get_supported_config,
    av_parser_iterate,
    av_parser_init,
    av_parser_parse2,
    av_parser_close,
    avcodec_encode_subtitle,
    avcodec_pix_fmt_to_codec_tag,
    avcodec_find_best_pix_fmt_of_list,
    avcodec_default_get_format,
    avcodec_string,
    avcodec_default_execute,
    avcodec_default_execute2,
    avcodec_fill_audio_frame,
    avcodec_flush_buffers,
    av_get_audio_frame_duration,
    av_fast_padded_malloc,
    av_fast_padded_mallocz,
    avcodec_is_open,
)
from ash_dynamics.ffmpeg.avutil.buffer import av_buffer_alloc
from ash_dynamics.ffmpeg.avcodec.codec import (
    avcodec_find_encoder,
    av_codec_iterate,
    avcodec_find_decoder_by_name,
    avcodec_find_encoder_by_name,
    av_codec_is_encoder,
    av_codec_is_decoder,
    av_get_profile_name,
    avcodec_get_hw_config,
)
from os.env import setenv
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.primitives._clib import StructWritable, StructWriter
from logger import Logger


comptime _logger = Logger()


@fieldwise_init
struct Avcodec:
    var lib: OwnedDLHandle

    # ===--------------------------------------------------===
    # ===                   Functions                      ===
    # ===--------------------------------------------------===
    # Packet functions
    var av_packet_alloc: av_packet_alloc.type
    var av_packet_clone: av_packet_clone.type
    var av_packet_free: av_packet_free.type
    var av_new_packet: av_new_packet.type
    var av_shrink_packet: av_shrink_packet.type
    var av_grow_packet: av_grow_packet.type
    var av_packet_from_data: av_packet_from_data.type
    var av_packet_new_side_data: av_packet_new_side_data.type
    var av_packet_add_side_data: av_packet_add_side_data.type
    var av_packet_shrink_side_data: av_packet_shrink_side_data.type
    var av_packet_get_side_data: av_packet_get_side_data.type
    var av_packet_pack_dictionary: av_packet_pack_dictionary.type
    var av_packet_unpack_dictionary: av_packet_unpack_dictionary.type
    var av_packet_free_side_data: av_packet_free_side_data.type
    var av_packet_ref: av_packet_ref.type
    var av_packet_unref: av_packet_unref.type
    var av_packet_move_ref: av_packet_move_ref.type
    var av_packet_copy_props: av_packet_copy_props.type
    var av_packet_make_refcounted: av_packet_make_refcounted.type
    var av_packet_make_writable: av_packet_make_writable.type
    var _av_packet_rescale_ts: av_packet_rescale_ts.type
    var av_container_fifo_alloc_avpacket: av_container_fifo_alloc_avpacket.type

    # Codec functions
    var avcodec_version: avcodec_version.type
    var avcodec_configuration: avcodec_configuration.type
    var avcodec_license: avcodec_license.type
    var avcodec_alloc_context3: avcodec_alloc_context3.type
    var avcodec_free_context: avcodec_free_context.type
    var avcodec_get_class: avcodec_get_class.type
    var avcodec_get_subtitle_rect_class: avcodec_get_subtitle_rect_class.type
    var avcodec_parameters_from_context: avcodec_parameters_from_context.type
    var avcodec_parameters_to_context: avcodec_parameters_to_context.type
    var avcodec_open2: avcodec_open2.type
    var avsubtitle_free: avsubtitle_free.type
    var avcodec_default_get_buffer2: avcodec_default_get_buffer2.type
    var avcodec_default_get_encode_buffer: avcodec_default_get_encode_buffer.type
    var avcodec_align_dimensions: avcodec_align_dimensions.type
    var avcodec_align_dimensions2: avcodec_align_dimensions2.type
    var avcodec_decode_subtitle2: avcodec_decode_subtitle2.type
    var avcodec_send_packet: avcodec_send_packet.type
    var avcodec_receive_frame: avcodec_receive_frame.type
    var avcodec_send_frame: avcodec_send_frame.type
    var avcodec_receive_packet: avcodec_receive_packet.type
    var avcodec_get_hw_frames_parameters: avcodec_get_hw_frames_parameters.type
    var avcodec_get_supported_config: avcodec_get_supported_config.type
    var avcodec_encode_subtitle: avcodec_encode_subtitle.type
    var avcodec_pix_fmt_to_codec_tag: avcodec_pix_fmt_to_codec_tag.type
    var avcodec_find_best_pix_fmt_of_list: avcodec_find_best_pix_fmt_of_list.type
    var avcodec_default_get_format: avcodec_default_get_format.type
    var avcodec_string: avcodec_string.type
    var avcodec_default_execute: avcodec_default_execute.type
    var avcodec_default_execute2: avcodec_default_execute2.type
    var avcodec_fill_audio_frame: avcodec_fill_audio_frame.type
    var avcodec_flush_buffers: avcodec_flush_buffers.type
    var av_get_audio_frame_duration: av_get_audio_frame_duration.type
    var av_fast_padded_malloc: av_fast_padded_malloc.type
    var av_fast_padded_mallocz: av_fast_padded_mallocz.type
    var avcodec_is_open: avcodec_is_open.type

    # Parser functions
    var av_parser_iterate: av_parser_iterate.type
    var av_parser_init: av_parser_init.type
    var av_parser_parse2: av_parser_parse2.type
    var av_parser_close: av_parser_close.type

    # Codec finder functions
    var avcodec_find_decoder: avcodec_find_decoder.type
    var avcodec_find_encoder: avcodec_find_encoder.type
    var av_codec_iterate: av_codec_iterate.type
    var avcodec_find_decoder_by_name: avcodec_find_decoder_by_name.type
    var avcodec_find_encoder_by_name: avcodec_find_encoder_by_name.type
    var av_codec_is_encoder: av_codec_is_encoder.type
    var av_codec_is_decoder: av_codec_is_decoder.type
    var av_get_profile_name: av_get_profile_name.type
    var avcodec_get_hw_config: avcodec_get_hw_config.type

    # Frame functions
    var av_frame_alloc: av_frame_alloc.type

    # Buffer functions
    var av_buffer_alloc: av_buffer_alloc.type

    fn __init__(out self) raises:
        var so_install_prefix = getenv("ASH_DYNAMICS_SO_INSTALL_PREFIX")
        if so_install_prefix == "":
            os.abort(
                "ASH_DYNAMICS_SO_INSTALL_PREFIX env var is not set. "
                "Expecting a path like:\n"
                "$PIXI_PROJECT_ROOT/third_party/ffmpeg/build/lib\n"
                "Where `libavcodec.so` is expected to exist."
            )
        self.lib = OwnedDLHandle("{}/libavcodec.so".format(so_install_prefix))

        # Packet functions
        self.av_packet_alloc = av_packet_alloc.load(self.lib)
        self.av_packet_clone = av_packet_clone.load(self.lib)
        self.av_packet_free = av_packet_free.load(self.lib)
        self.av_new_packet = av_new_packet.load(self.lib)
        self.av_shrink_packet = av_shrink_packet.load(self.lib)
        self.av_grow_packet = av_grow_packet.load(self.lib)
        self.av_packet_from_data = av_packet_from_data.load(self.lib)
        self.av_packet_new_side_data = av_packet_new_side_data.load(self.lib)
        self.av_packet_add_side_data = av_packet_add_side_data.load(self.lib)
        self.av_packet_shrink_side_data = av_packet_shrink_side_data.load(
            self.lib
        )
        self.av_packet_get_side_data = av_packet_get_side_data.load(self.lib)
        self.av_packet_pack_dictionary = av_packet_pack_dictionary.load(
            self.lib
        )
        self.av_packet_unpack_dictionary = av_packet_unpack_dictionary.load(
            self.lib
        )
        self.av_packet_free_side_data = av_packet_free_side_data.load(self.lib)
        self.av_packet_ref = av_packet_ref.load(self.lib)
        self.av_packet_unref = av_packet_unref.load(self.lib)
        self.av_packet_move_ref = av_packet_move_ref.load(self.lib)
        self.av_packet_copy_props = av_packet_copy_props.load(self.lib)
        self.av_packet_make_refcounted = av_packet_make_refcounted.load(
            self.lib
        )
        self.av_packet_make_writable = av_packet_make_writable.load(self.lib)
        self._av_packet_rescale_ts = av_packet_rescale_ts.load(self.lib)
        self.av_container_fifo_alloc_avpacket = (
            av_container_fifo_alloc_avpacket.load(self.lib)
        )

        # Codec functions
        self.avcodec_version = avcodec_version.load(self.lib)
        self.avcodec_configuration = avcodec_configuration.load(self.lib)
        self.avcodec_license = avcodec_license.load(self.lib)
        self.avcodec_alloc_context3 = avcodec_alloc_context3.load(self.lib)
        self.avcodec_free_context = avcodec_free_context.load(self.lib)
        self.avcodec_get_class = avcodec_get_class.load(self.lib)
        self.avcodec_get_subtitle_rect_class = (
            avcodec_get_subtitle_rect_class.load(self.lib)
        )
        self.avcodec_parameters_from_context = (
            avcodec_parameters_from_context.load(self.lib)
        )
        self.avcodec_parameters_to_context = avcodec_parameters_to_context.load(
            self.lib
        )
        self.avcodec_open2 = avcodec_open2.load(self.lib)
        self.avsubtitle_free = avsubtitle_free.load(self.lib)
        self.avcodec_default_get_buffer2 = avcodec_default_get_buffer2.load(
            self.lib
        )
        self.avcodec_default_get_encode_buffer = (
            avcodec_default_get_encode_buffer.load(self.lib)
        )
        self.avcodec_align_dimensions = avcodec_align_dimensions.load(self.lib)
        self.avcodec_align_dimensions2 = avcodec_align_dimensions2.load(
            self.lib
        )
        self.avcodec_decode_subtitle2 = avcodec_decode_subtitle2.load(self.lib)
        self.avcodec_send_packet = avcodec_send_packet.load(self.lib)
        self.avcodec_receive_frame = avcodec_receive_frame.load(self.lib)
        self.avcodec_send_frame = avcodec_send_frame.load(self.lib)
        self.avcodec_receive_packet = avcodec_receive_packet.load(self.lib)
        self.avcodec_get_hw_frames_parameters = (
            avcodec_get_hw_frames_parameters.load(self.lib)
        )
        self.avcodec_get_supported_config = avcodec_get_supported_config.load(
            self.lib
        )
        self.avcodec_encode_subtitle = avcodec_encode_subtitle.load(self.lib)
        self.avcodec_pix_fmt_to_codec_tag = avcodec_pix_fmt_to_codec_tag.load(
            self.lib
        )
        self.avcodec_find_best_pix_fmt_of_list = (
            avcodec_find_best_pix_fmt_of_list.load(self.lib)
        )
        self.avcodec_default_get_format = avcodec_default_get_format.load(
            self.lib
        )
        self.avcodec_string = avcodec_string.load(self.lib)
        self.avcodec_default_execute = avcodec_default_execute.load(self.lib)
        self.avcodec_default_execute2 = avcodec_default_execute2.load(self.lib)
        self.avcodec_fill_audio_frame = avcodec_fill_audio_frame.load(self.lib)
        self.avcodec_flush_buffers = avcodec_flush_buffers.load(self.lib)
        self.av_get_audio_frame_duration = av_get_audio_frame_duration.load(
            self.lib
        )
        self.av_fast_padded_malloc = av_fast_padded_malloc.load(self.lib)
        self.av_fast_padded_mallocz = av_fast_padded_mallocz.load(self.lib)
        self.avcodec_is_open = avcodec_is_open.load(self.lib)

        # Parser functions
        self.av_parser_iterate = av_parser_iterate.load(self.lib)
        self.av_parser_init = av_parser_init.load(self.lib)
        self.av_parser_parse2 = av_parser_parse2.load(self.lib)
        self.av_parser_close = av_parser_close.load(self.lib)

        # Codec finder functions
        self.avcodec_find_decoder = avcodec_find_decoder.load(self.lib)
        self.avcodec_find_encoder = avcodec_find_encoder.load(self.lib)
        self.av_codec_iterate = av_codec_iterate.load(self.lib)
        self.avcodec_find_decoder_by_name = avcodec_find_decoder_by_name.load(
            self.lib
        )
        self.avcodec_find_encoder_by_name = avcodec_find_encoder_by_name.load(
            self.lib
        )
        self.av_codec_is_encoder = av_codec_is_encoder.load(self.lib)
        self.av_codec_is_decoder = av_codec_is_decoder.load(self.lib)
        self.av_get_profile_name = av_get_profile_name.load(self.lib)
        self.avcodec_get_hw_config = avcodec_get_hw_config.load(self.lib)

        # Frame functions
        self.av_frame_alloc = av_frame_alloc.load(self.lib)

        # Buffer functions
        self.av_buffer_alloc = av_buffer_alloc.load(self.lib)

    fn av_packet_rescale_ts(
        self,
        pkt: UnsafePointer[AVPacket, MutOrigin.external],
        tb_a: AVRational,
        tb_b: AVRational,
    ):
        return self._av_packet_rescale_ts(
            pkt, tb_a.as_long_long(), tb_b.as_long_long()
        )
