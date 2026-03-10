from ffi import c_uchar, c_char, c_int
from sys._libc_errno import ErrNo
from pathlib import Path
import sys
import os
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avformat import Avformat
from ash_dynamics.ffmpeg.avcodec import Avcodec
from ash_dynamics.ffmpeg.avutil import Avutil
from ash_dynamics.ffmpeg.swscale import Swscale
from ash_dynamics.ffmpeg.swrsample import Swrsample
from ash_dynamics.ffmpeg.avformat import AVFormatContext
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avcodec.defs import AV_INPUT_BUFFER_PADDING_SIZE
from ash_dynamics.ffmpeg.avutil.avutil import AV_NOPTS_VALUE
from memory import memset
from ash_dynamics.ffmpeg.avcodec.avcodec import AVCodecContext
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avutil.error import AVERROR, AVERROR_EOF
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat


from ash_dynamics.image.io import image_save, image_read, ImageData


@fieldwise_init
struct ImageInfo:
    var width: c_int
    var height: c_int
    var format: AVPixelFormat.ENUM_DTYPE
    var n_color_spaces: c_int

    fn __init__(out self):
        self.width = 0
        self.height = 0
        self.format = AVPixelFormat.AV_PIX_FMT_NONE._value
        self.n_color_spaces = 0


fn decode(
    mut avcodec: Avcodec,
    dec_ctx: UnsafePointer[AVCodecContext, origin=MutExternalOrigin],
    frame: UnsafePointer[AVFrame, origin=MutExternalOrigin],
    pkt: UnsafePointer[AVPacket, origin=MutExternalOrigin],
    filename: String,
    mut image_info: ImageInfo,
) raises -> UnsafePointer[c_uchar, MutExternalOrigin]:
    var ret: c_int = avcodec.avcodec_send_packet(dec_ctx, pkt)
    if ret < 0:
        os.abort("Error sending a packaet for decoding.")
    else:
        print("Packet sent successfully.")

    while ret >= 0:
        ret = avcodec.avcodec_receive_frame(dec_ctx, frame)
        if ret == AVERROR(ErrNo.EAGAIN.value) or ret == Int32(AVERROR_EOF):
            break
        elif ret < 0:
            os.abort("Error receiving frame.")
        else:
            print("Frame received successfully.")

        image_info.width = frame[].width
        image_info.height = frame[].height
        image_info.format = dec_ctx[].pix_fmt
        image_info.n_color_spaces = dec_ctx[].color_range

        out_data = alloc[c_uchar](
            Int(frame[].linesize[0]) * Int(frame[].height)
        )
        out_data[] = frame[].data[0][]

        return out_data

    raise Error("Error decoding image.")


struct Image(Movable, Writable):
    var _data: UnsafePointer[c_uchar, MutAnyOrigin]

    var width: c_int
    var height: c_int
    var format: AVPixelFormat.ENUM_DTYPE
    var n_color_spaces: c_int

    fn __init__(out self, var data: List[c_uchar]):
        self._data = data.unsafe_ptr()
        self.width = 0
        self.height = 0
        self.format = AVPixelFormat.AV_PIX_FMT_NONE._value
        self.n_color_spaces = 0

    fn __init__(
        out self,
        var data: UnsafePointer[c_uchar, MutAnyOrigin],
        width: c_int,
        height: c_int,
        format: AVPixelFormat.ENUM_DTYPE,
        n_color_spaces: c_int,
    ):
        self._data = data
        self.width = width
        self.height = height
        self.format = format
        self.n_color_spaces = n_color_spaces

    @staticmethod
    fn load(path: Path) raises -> Self:
        var image_data = image_read(path)
        return Self(
            data=image_data.data,
            width=image_data.width,
            height=image_data.height,
            format=image_data.format,
            n_color_spaces=image_data.n_color_spaces,
        )

    fn save(self, path: Path) raises:
        image_save(
            ImageData(
                data=self._data.unsafe_origin_cast[MutExternalOrigin](),
                width=self.width,
                height=self.height,
                format=self.format,
                n_color_spaces=self.n_color_spaces,
            ),
            path,
        )
