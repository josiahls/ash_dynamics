"""

Symbols present can be listed via:

nm -D /home/mojo_user/ash_dynamics/third_party/ffmpeg/build/lib/libavcodec.so
"""

from sys.ffi import OwnedDLHandle, c_int
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket, _av_packet_alloc
from ash_dynamics.ffmpeg.avcodec.allcodecs import _avcodec_find_decoder
from ash_dynamics.ffmpeg.avcodec.av_codec_parser import _av_parser_init
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from os.env import setenv


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

    fn __init__(out self) raises:
        self.lib = OwnedDLHandle(
            "/home/mojo_user/ash_dynamics/third_party/ffmpeg/build/lib/libavcodec.so"
        )
        self.av_packet_alloc = _av_packet_alloc.load(self.lib)
        self.avcodec_find_decoder = _avcodec_find_decoder.load(self.lib)
        self.av_parser_init = _av_parser_init.load(self.lib)
