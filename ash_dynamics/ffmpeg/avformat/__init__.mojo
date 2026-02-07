"""https://www.ffmpeg.org/doxygen/8.0/avformat_8h_source.html

Symbols present can be listed via:

nm -D $ASH_DYNAMICS_SO_INSTALL_PREFIX/libavformat.so
"""

from ffi import OwnedDLHandle, c_int, c_float, c_char
from os.env import getenv
import os
from ash_dynamics.ffmpeg.avformat.avformat import (
    av_get_packet,
    av_append_packet,
    av_disposition_from_string,
    av_disposition_to_string,
    av_stream_get_parser,
    avformat_version,
    avformat_configuration,
    avformat_license,
    avformat_network_init,
    avformat_network_deinit,
    av_muxer_iterate,
    av_demuxer_iterate,
    avformat_alloc_context,
    avformat_free_context,
    avformat_get_class,
    av_stream_get_class,
    av_stream_group_get_class,
    avformat_stream_group_name,
    avformat_stream_group_create,
    avformat_new_stream,
    avformat_stream_group_add_stream,
    av_new_program,
    avformat_alloc_output_context2,
    av_find_input_format,
    av_probe_input_format,
    av_probe_input_format2,
    av_probe_input_format3,
    av_probe_input_buffer2,
    av_probe_input_buffer,
    avformat_open_input,
    avformat_find_stream_info,
    av_find_program_from_stream,
    av_program_add_stream_index,
    av_find_best_stream,
    av_read_frame,
    av_seek_frame,
    avformat_seek_file,
    avformat_flush,
    av_read_play,
    av_read_pause,
    avformat_close_input,
    avformat_write_header,
    avformat_init_output,
    av_write_frame,
    av_interleaved_write_frame,
    av_write_uncoded_frame,
    av_interleaved_write_uncoded_frame,
    av_write_uncoded_frame_query,
    av_write_trailer,
    av_guess_format,
    av_guess_codec,
    av_get_output_timestamp,
    av_hex_dump,
    av_hex_dump_log,
    av_pkt_dump2,
    av_pkt_dump_log2,
    av_codec_get_id,
    av_codec_get_tag,
    av_codec_get_tag2,
    av_find_default_stream_index,
    av_index_search_timestamp,
    avformat_index_get_entries_count,
    avformat_index_get_entry,
    avformat_index_get_entry_from_timestamp,
    av_add_index_entry,
    av_url_split,
    av_dump_format,
    av_get_frame_filename2,
    av_get_frame_filename,
    av_filename_number_test,
    av_sdp_create,
    av_match_ext,
    avformat_query_codec,
    avformat_get_riff_video_tags,
    avformat_get_riff_audio_tags,
    avformat_get_mov_video_tags,
    avformat_get_mov_audio_tags,
    av_guess_sample_aspect_ratio,
    av_guess_frame_rate,
    avformat_match_stream_specifier,
    avformat_queue_attached_pictures,
    AVOutputFormat,
    AVFormatContext,
)
from ash_dynamics.ffmpeg.avformat.avio import avio_open, AVIO_FLAG_WRITE

from logger import Logger


comptime _logger = Logger()


@fieldwise_init
struct Avformat:
    var lib: OwnedDLHandle

    # ===--------------------------------------------------===
    # ===                   Functions                      ===
    # ===--------------------------------------------------===
    # Packet functions
    var av_get_packet: av_get_packet.type
    var av_append_packet: av_append_packet.type

    # Disposition functions
    var av_disposition_from_string: av_disposition_from_string.type
    var av_disposition_to_string: av_disposition_to_string.type

    # Stream functions
    var av_stream_get_parser: av_stream_get_parser.type

    # Version/info functions
    var avformat_version: avformat_version.type
    var avformat_configuration: avformat_configuration.type
    var avformat_license: avformat_license.type

    # Network functions
    var avformat_network_init: avformat_network_init.type
    var avformat_network_deinit: avformat_network_deinit.type

    # Iterator functions
    var av_muxer_iterate: av_muxer_iterate.type
    var av_demuxer_iterate: av_demuxer_iterate.type

    # Context functions
    var avformat_alloc_context: avformat_alloc_context.type
    var avformat_free_context: avformat_free_context.type
    var avformat_get_class: avformat_get_class.type
    var av_stream_get_class: av_stream_get_class.type
    var av_stream_group_get_class: av_stream_group_get_class.type

    # Stream group functions
    var avformat_stream_group_name: avformat_stream_group_name.type
    var avformat_stream_group_create: avformat_stream_group_create.type
    var avformat_new_stream: avformat_new_stream.type
    var avformat_stream_group_add_stream: avformat_stream_group_add_stream.type

    # Program functions
    var av_new_program: av_new_program.type

    # Output context functions
    var _alloc_output_context: avformat_alloc_output_context2.type

    # Input format functions
    var av_find_input_format: av_find_input_format.type
    var av_probe_input_format: av_probe_input_format.type
    var av_probe_input_format2: av_probe_input_format2.type
    var av_probe_input_format3: av_probe_input_format3.type
    var av_probe_input_buffer2: av_probe_input_buffer2.type
    var av_probe_input_buffer: av_probe_input_buffer.type

    # Input/output functions
    var avformat_open_input: avformat_open_input.type
    var avformat_find_stream_info: avformat_find_stream_info.type
    var av_find_program_from_stream: av_find_program_from_stream.type
    var av_program_add_stream_index: av_program_add_stream_index.type
    var av_find_best_stream: av_find_best_stream.type
    var av_read_frame: av_read_frame.type
    var av_seek_frame: av_seek_frame.type
    var avformat_seek_file: avformat_seek_file.type
    var avformat_flush: avformat_flush.type
    var av_read_play: av_read_play.type
    var av_read_pause: av_read_pause.type
    var avformat_close_input: avformat_close_input.type

    # Output functions
    var avformat_write_header: avformat_write_header.type
    var avformat_init_output: avformat_init_output.type
    var av_write_frame: av_write_frame.type
    var av_interleaved_write_frame: av_interleaved_write_frame.type
    var av_write_uncoded_frame: av_write_uncoded_frame.type
    var av_interleaved_write_uncoded_frame: av_interleaved_write_uncoded_frame.type
    var av_write_uncoded_frame_query: av_write_uncoded_frame_query.type
    var av_write_trailer: av_write_trailer.type

    # Format/codec functions
    var av_guess_format: av_guess_format.type
    var av_guess_codec: av_guess_codec.type
    var av_get_output_timestamp: av_get_output_timestamp.type

    # Debug/dump functions
    var av_hex_dump: av_hex_dump.type
    var av_hex_dump_log: av_hex_dump_log.type
    var av_pkt_dump2: av_pkt_dump2.type
    var av_pkt_dump_log2: av_pkt_dump_log2.type
    var av_dump_format: av_dump_format.type

    # Codec tag functions
    var av_codec_get_id: av_codec_get_id.type
    var av_codec_get_tag: av_codec_get_tag.type
    var av_codec_get_tag2: av_codec_get_tag2.type

    # Index functions
    var av_find_default_stream_index: av_find_default_stream_index.type
    var av_index_search_timestamp: av_index_search_timestamp.type
    var avformat_index_get_entries_count: avformat_index_get_entries_count.type
    var avformat_index_get_entry: avformat_index_get_entry.type
    var avformat_index_get_entry_from_timestamp: avformat_index_get_entry_from_timestamp.type
    var av_add_index_entry: av_add_index_entry.type

    # URL functions
    var av_url_split: av_url_split.type

    # Filename functions
    var av_get_frame_filename2: av_get_frame_filename2.type
    var av_get_frame_filename: av_get_frame_filename.type
    var av_filename_number_test: av_filename_number_test.type

    # SDP functions
    var av_sdp_create: av_sdp_create.type

    # Utility functions
    var av_match_ext: av_match_ext.type
    var avformat_query_codec: avformat_query_codec.type

    # Tag functions
    var avformat_get_riff_video_tags: avformat_get_riff_video_tags.type
    var avformat_get_riff_audio_tags: avformat_get_riff_audio_tags.type
    var avformat_get_mov_video_tags: avformat_get_mov_video_tags.type
    var avformat_get_mov_audio_tags: avformat_get_mov_audio_tags.type

    # Guess functions
    var av_guess_sample_aspect_ratio: av_guess_sample_aspect_ratio.type
    var av_guess_frame_rate: av_guess_frame_rate.type

    # Stream specifier functions
    var avformat_match_stream_specifier: avformat_match_stream_specifier.type
    var avformat_queue_attached_pictures: avformat_queue_attached_pictures.type

    # I/O functions
    var avio_open: avio_open.type

    fn __init__(out self) raises:
        var so_install_prefix = getenv("ASH_DYNAMICS_SO_INSTALL_PREFIX")
        if so_install_prefix == "":
            os.abort(
                "ASH_DYNAMICS_SO_INSTALL_PREFIX env var is not set. "
                "Expecting a path like:\n"
                "$PIXI_PROJECT_ROOT/third_party/ffmpeg/build/lib\n"
                "Where `libavformat.so` is expected to exist."
            )
        self.lib = OwnedDLHandle("{}/libavformat.so".format(so_install_prefix))

        # Packet functions
        self.av_get_packet = av_get_packet.load(self.lib)
        self.av_append_packet = av_append_packet.load(self.lib)

        # Disposition functions
        self.av_disposition_from_string = av_disposition_from_string.load(
            self.lib
        )
        self.av_disposition_to_string = av_disposition_to_string.load(self.lib)

        # Stream functions
        self.av_stream_get_parser = av_stream_get_parser.load(self.lib)

        # Version/info functions
        self.avformat_version = avformat_version.load(self.lib)
        self.avformat_configuration = avformat_configuration.load(self.lib)
        self.avformat_license = avformat_license.load(self.lib)

        # Network functions
        self.avformat_network_init = avformat_network_init.load(self.lib)
        self.avformat_network_deinit = avformat_network_deinit.load(self.lib)

        # Iterator functions
        self.av_muxer_iterate = av_muxer_iterate.load(self.lib)
        self.av_demuxer_iterate = av_demuxer_iterate.load(self.lib)

        # Context functions
        self.avformat_alloc_context = avformat_alloc_context.load(self.lib)
        self.avformat_free_context = avformat_free_context.load(self.lib)
        self.avformat_get_class = avformat_get_class.load(self.lib)
        self.av_stream_get_class = av_stream_get_class.load(self.lib)
        self.av_stream_group_get_class = av_stream_group_get_class.load(
            self.lib
        )

        # Stream group functions
        self.avformat_stream_group_name = avformat_stream_group_name.load(
            self.lib
        )
        self.avformat_stream_group_create = avformat_stream_group_create.load(
            self.lib
        )
        self.avformat_new_stream = avformat_new_stream.load(self.lib)
        self.avformat_stream_group_add_stream = (
            avformat_stream_group_add_stream.load(self.lib)
        )

        # Program functions
        self.av_new_program = av_new_program.load(self.lib)

        # Output context functions
        self._alloc_output_context = avformat_alloc_output_context2.load(
            self.lib
        )

        # Input format functions
        self.av_find_input_format = av_find_input_format.load(self.lib)
        self.av_probe_input_format = av_probe_input_format.load(self.lib)
        self.av_probe_input_format2 = av_probe_input_format2.load(self.lib)
        self.av_probe_input_format3 = av_probe_input_format3.load(self.lib)
        self.av_probe_input_buffer2 = av_probe_input_buffer2.load(self.lib)
        self.av_probe_input_buffer = av_probe_input_buffer.load(self.lib)

        # Input/output functions
        self.avformat_open_input = avformat_open_input.load(self.lib)
        self.avformat_find_stream_info = avformat_find_stream_info.load(
            self.lib
        )
        self.av_find_program_from_stream = av_find_program_from_stream.load(
            self.lib
        )
        self.av_program_add_stream_index = av_program_add_stream_index.load(
            self.lib
        )
        self.av_find_best_stream = av_find_best_stream.load(self.lib)
        self.av_read_frame = av_read_frame.load(self.lib)
        self.av_seek_frame = av_seek_frame.load(self.lib)
        self.avformat_seek_file = avformat_seek_file.load(self.lib)
        self.avformat_flush = avformat_flush.load(self.lib)
        self.av_read_play = av_read_play.load(self.lib)
        self.av_read_pause = av_read_pause.load(self.lib)
        self.avformat_close_input = avformat_close_input.load(self.lib)

        # Output functions
        self.avformat_write_header = avformat_write_header.load(self.lib)
        self.avformat_init_output = avformat_init_output.load(self.lib)
        self.av_write_frame = av_write_frame.load(self.lib)
        self.av_interleaved_write_frame = av_interleaved_write_frame.load(
            self.lib
        )
        self.av_write_uncoded_frame = av_write_uncoded_frame.load(self.lib)
        self.av_interleaved_write_uncoded_frame = (
            av_interleaved_write_uncoded_frame.load(self.lib)
        )
        self.av_write_uncoded_frame_query = av_write_uncoded_frame_query.load(
            self.lib
        )
        self.av_write_trailer = av_write_trailer.load(self.lib)

        # Format/codec functions
        self.av_guess_format = av_guess_format.load(self.lib)
        self.av_guess_codec = av_guess_codec.load(self.lib)
        self.av_get_output_timestamp = av_get_output_timestamp.load(self.lib)

        # Debug/dump functions
        self.av_hex_dump = av_hex_dump.load(self.lib)
        self.av_hex_dump_log = av_hex_dump_log.load(self.lib)
        self.av_pkt_dump2 = av_pkt_dump2.load(self.lib)
        self.av_pkt_dump_log2 = av_pkt_dump_log2.load(self.lib)
        self.av_dump_format = av_dump_format.load(self.lib)

        # Codec tag functions
        self.av_codec_get_id = av_codec_get_id.load(self.lib)
        self.av_codec_get_tag = av_codec_get_tag.load(self.lib)
        self.av_codec_get_tag2 = av_codec_get_tag2.load(self.lib)

        # Index functions
        self.av_find_default_stream_index = av_find_default_stream_index.load(
            self.lib
        )
        self.av_index_search_timestamp = av_index_search_timestamp.load(
            self.lib
        )
        self.avformat_index_get_entries_count = (
            avformat_index_get_entries_count.load(self.lib)
        )
        self.avformat_index_get_entry = avformat_index_get_entry.load(self.lib)
        self.avformat_index_get_entry_from_timestamp = (
            avformat_index_get_entry_from_timestamp.load(self.lib)
        )
        self.av_add_index_entry = av_add_index_entry.load(self.lib)

        # URL functions
        self.av_url_split = av_url_split.load(self.lib)

        # Filename functions
        self.av_get_frame_filename2 = av_get_frame_filename2.load(self.lib)
        self.av_get_frame_filename = av_get_frame_filename.load(self.lib)
        self.av_filename_number_test = av_filename_number_test.load(self.lib)

        # SDP functions
        self.av_sdp_create = av_sdp_create.load(self.lib)

        # Utility functions
        self.av_match_ext = av_match_ext.load(self.lib)
        self.avformat_query_codec = avformat_query_codec.load(self.lib)

        # Tag functions
        self.avformat_get_riff_video_tags = avformat_get_riff_video_tags.load(
            self.lib
        )
        self.avformat_get_riff_audio_tags = avformat_get_riff_audio_tags.load(
            self.lib
        )
        self.avformat_get_mov_video_tags = avformat_get_mov_video_tags.load(
            self.lib
        )
        self.avformat_get_mov_audio_tags = avformat_get_mov_audio_tags.load(
            self.lib
        )

        # Guess functions
        self.av_guess_sample_aspect_ratio = av_guess_sample_aspect_ratio.load(
            self.lib
        )
        self.av_guess_frame_rate = av_guess_frame_rate.load(self.lib)

        # Stream specifier functions
        self.avformat_match_stream_specifier = (
            avformat_match_stream_specifier.load(self.lib)
        )
        self.avformat_queue_attached_pictures = (
            avformat_queue_attached_pictures.load(self.lib)
        )

        # I/O functions
        self.avio_open = avio_open.load(self.lib)

    fn alloc_output_context(
        self,
        ctx: UnsafePointer[
            UnsafePointer[AVFormatContext, MutExternalOrigin], MutAnyOrigin
        ],
        oformat: UnsafePointer[AVOutputFormat, ImmutExternalOrigin],
        format_name: UnsafePointer[c_char, ImmutExternalOrigin],
        mut filename: String,
    ) -> c_int:
        return self._alloc_output_context(
            ctx=ctx,
            oformat=oformat,
            format_name=format_name,
            filename=filename.as_c_string_slice().unsafe_ptr().as_immutable(),
        )

    fn alloc_output_context(
        self,
        ctx: UnsafePointer[
            UnsafePointer[AVFormatContext, MutExternalOrigin], MutAnyOrigin
        ],
        mut filename: String,
    ) -> c_int:
        """Allocate an AVFormatContext for an output format.

        Note: Null pointers for oformat and format_name will use the filename to guess the format.

        Args:
                ctx: Pointee is set to the created format context, or to NULL in case of failure.
                filename: The name of the filename to use for allocating the context, may be NULL.

        Returns:
                >= 0 in case of success, a negative AVERROR code in case of failure.
        """
        return self._alloc_output_context(
            ctx=ctx,
            oformat=UnsafePointer[AVOutputFormat, ImmutExternalOrigin](),
            format_name=UnsafePointer[c_char, ImmutExternalOrigin](),
            filename=filename.as_c_string_slice().unsafe_ptr().as_immutable(),
        )
