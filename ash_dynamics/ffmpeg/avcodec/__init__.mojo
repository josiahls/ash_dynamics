"""

Symbols present can be listed via:

nm -D /home/mojo_user/ash_dynamics/third_party/ffmpeg/build/lib/libavcodec.so
"""

from sys.ffi import OwnedDLHandle, c_int, c_float
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket, _av_packet_alloc
from ash_dynamics.ffmpeg.avcodec.allcodecs import _avcodec_find_decoder
from ash_dynamics.ffmpeg.avcodec.av_codec_parser import _av_parser_init
from ash_dynamics.ffmpeg.avutil.frame import _av_frame_alloc
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.avcodec_header import (
    _avcodec_alloc_context3,
    _avcodec_open2,
    av_parser_parse2,
    avcodec_send_packet,
    avcodec_receive_frame,
)
from os.env import setenv
from ash_dynamics.primitives._clib import StructWritable, StructWriter


@fieldwise_init
struct avcodec:
    var lib: OwnedDLHandle

    # ===--------------------------------------------------===
    # ===                   Functions                      ===
    # ===--------------------------------------------------===
    var av_packet_alloc: _av_packet_alloc.type

    # TODO: This function returns null when it doesn't find a decoder.
    # We should change this from a filed to function that validates
    # and raises an error.
    var avcodec_find_decoder: _avcodec_find_decoder.type

    var av_parser_init: _av_parser_init.type

    var avcodec_alloc_context3: _avcodec_alloc_context3.type

    var avcodec_open2: _avcodec_open2.type

    var av_parser_parse2: av_parser_parse2.type

    var avcodec_send_packet: avcodec_send_packet.type

    var av_frame_alloc: _av_frame_alloc.type

    var avcodec_receive_frame: avcodec_receive_frame.type

    fn __init__(out self) raises:
        self.lib = OwnedDLHandle(
            "/home/mojo_user/ash_dynamics/third_party/ffmpeg/build/lib/libavcodec.so"
        )
        self.av_packet_alloc = _av_packet_alloc.load(self.lib)
        self.avcodec_find_decoder = _avcodec_find_decoder.load(self.lib)
        self.av_parser_init = _av_parser_init.load(self.lib)
        self.avcodec_alloc_context3 = _avcodec_alloc_context3.load(self.lib)
        self.avcodec_open2 = _avcodec_open2.load(self.lib)
        self.av_parser_parse2 = av_parser_parse2.load(self.lib)
        self.avcodec_send_packet = avcodec_send_packet.load(self.lib)
        self.av_frame_alloc = _av_frame_alloc.load(self.lib)
        self.avcodec_receive_frame = avcodec_receive_frame.load(self.lib)
