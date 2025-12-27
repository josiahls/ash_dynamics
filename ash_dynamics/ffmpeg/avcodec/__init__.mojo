"""

Symbols present can be listed via:

nm -D $ASH_DYNAMICS_SO_INSTALL_PREFIX/libavcodec.so
"""

from sys.ffi import OwnedDLHandle, c_int, c_float
from os.env import getenv
import os
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket, _av_packet_alloc
from ash_dynamics.ffmpeg.avcodec.allcodecs import _avcodec_find_decoder
from ash_dynamics.ffmpeg.avutil.frame import _av_frame_alloc
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.avcodec import (
    avcodec_alloc_context3,
    av_parser_init,
    avcodec_open2,
    av_parser_parse2,
    avcodec_send_packet,
    avcodec_receive_frame,
)
from ash_dynamics.ffmpeg.avcodec.codec import avcodec_find_encoder
from os.env import setenv
from ash_dynamics.primitives._clib import StructWritable, StructWriter
from logger import Logger


comptime _logger = Logger()


@fieldwise_init
struct Avcodec:
    var lib: OwnedDLHandle

    # ===--------------------------------------------------===
    # ===                   Functions                      ===
    # ===--------------------------------------------------===
    var av_packet_alloc: _av_packet_alloc.type

    # TODO: This function returns null when it doesn't find a decoder.
    # We should change this from a filed to function that validates
    # and raises an error.
    var avcodec_find_decoder: _avcodec_find_decoder.type
    var av_parser_init: av_parser_init.type
    var avcodec_alloc_context3: avcodec_alloc_context3.type
    var avcodec_open2: avcodec_open2.type
    var av_parser_parse2: av_parser_parse2.type
    var avcodec_send_packet: avcodec_send_packet.type
    var av_frame_alloc: _av_frame_alloc.type
    var avcodec_receive_frame: avcodec_receive_frame.type
    var avcodec_find_encoder: avcodec_find_encoder.type

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
        self.av_packet_alloc = _av_packet_alloc.load(self.lib)
        self.avcodec_find_decoder = _avcodec_find_decoder.load(self.lib)
        self.av_parser_init = av_parser_init.load(self.lib)
        self.avcodec_alloc_context3 = avcodec_alloc_context3.load(self.lib)
        self.avcodec_open2 = avcodec_open2.load(self.lib)
        self.av_parser_parse2 = av_parser_parse2.load(self.lib)
        self.avcodec_send_packet = avcodec_send_packet.load(self.lib)
        self.av_frame_alloc = _av_frame_alloc.load(self.lib)
        self.avcodec_receive_frame = avcodec_receive_frame.load(self.lib)
        self.avcodec_find_encoder = avcodec_find_encoder.load(self.lib)
