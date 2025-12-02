from sys.ffi import OwnedDLHandle
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket, _av_packet_alloc
from os.env import setenv


@fieldwise_init
struct avcodec:
    var lib: OwnedDLHandle

    # ===--------------------------------------------------===
    # ===                   Functions                      ===
    # ===--------------------------------------------------===
    var av_packet_alloc: _av_packet_alloc.type

    fn __init__(out self) raises:
        self.lib = OwnedDLHandle(
            "/home/mojo_user/ash_dynamics/third_party/ffmpeg/build/lib/libavcodec.so"
        )
        self.av_packet_alloc = _av_packet_alloc.load(self.lib)
