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
        if ret == AVERROR(ErrNo.EAGAIN.value) or ret == AVERROR_EOF:
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


@fieldwise_init
struct Image:
    var _data: UnsafePointer[c_uchar, MutAnyOrigin]

    var width: c_int
    var height: c_int
    var format: AVPixelFormat.ENUM_DTYPE
    var n_color_spaces: c_int

    fn __init__(out self, var data: List[c_uchar]):
        self._data = data.unsafe_ptr()

    fn __init__(
        out self,
        data: UnsafePointer[c_uchar, MutExternalOrigin],
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

    # @staticmethod
    # fn load(path: Path) raises -> Self:
    #     var avformat = Avformat()
    #     var avcodec = Avcodec()
    #     var avutil = Avutil()
    #     var swscale = Swscale()
    #     var swrsample = Swrsample()

    #     var oc = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    #     var name = path.name().copy()
    #     var extension = String("png")

    #     comptime INBUF_SIZE = c_int(4096)

    #     var input_buffer = alloc[c_uchar](
    #         Int(INBUF_SIZE + AV_INPUT_BUFFER_PADDING_SIZE)
    #     )

    #     # Set the padding portion of the input_buffer to zero.
    #     memset(
    #         input_buffer + INBUF_SIZE,
    #         0,
    #         Int(AV_INPUT_BUFFER_PADDING_SIZE),
    #     )
    #     var packet = avcodec.av_packet_alloc()
    #     # print(packet[])

    #     var codec = avcodec.avcodec_find_decoder_by_name(extension)
    #     # print(codec[])

    #     var parser = avcodec.av_parser_init(codec[].id)
    #     # print(parser[])

    #     var context = avcodec.avcodec_alloc_context3(codec)
    #     # print(context[])

    #     ptr = alloc[AVDictionary](0)
    #     avcodec.avcodec_open2(context, codec, ptr)
    #     print("Opened codec")

    #     var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    #     var out_filename: String = (
    #         "{}/test_data/testsrc_320x180_30fps_2s_decoded".format(
    #             test_data_root
    #         )
    #     )

    #     var frame = avcodec.av_frame_alloc()
    #     var image_info = ImageInfo()

    #     var data_list = path.read_bytes()
    #     var data_size = c_int(len(data_list))
    #     var data = data_list.unsafe_ptr().as_immutable()
    #     var out_data = UnsafePointer[c_uchar, MutExternalOrigin]()

    #     while True:
    #         if data_size == 0:
    #             break

    #         while data_size > 0:
    #             var ret = avcodec.av_parser_parse2(
    #                 parser,
    #                 context,
    #                 UnsafePointer(to=packet[].data),
    #                 UnsafePointer(to=packet[].size),
    #                 data,
    #                 data_size,
    #                 AV_NOPTS_VALUE,
    #                 AV_NOPTS_VALUE,
    #                 0,
    #             )
    #             if ret < 0:
    #                 print("Failed to parse data")
    #                 sys.exit(1)
    #             elif parser[].flags & AVPacket.AV_PKT_FLAG_CORRUPT:
    #                 print("Parsed data is corrupted")
    #             else:
    #                 print("Parsed data is valid")
    #             data += ret
    #             data_size -= ret

    #             if packet[].size > 0:
    #                 print("Packet size: ", packet[].size)
    #                 out_data = decode(
    #                     avcodec,
    #                     context,
    #                     frame,
    #                     packet,
    #                     out_filename,
    #                     image_info,
    #                 )
    #                 # for row in range(image_info.height):
    #                 #     for i in range(image_info.width):
    #                 #         if i % 3 == 0:
    #                 #             print()
    #                 #         print(out_data[Int(i + row * image_info.width)], end=" ")
    #                 #     print()

    #         data_size = 0

    #     _ = codec

    #     _ = avcodec  # Need this to keep the ffi bind alive

    #     return Self(
    #         data=out_data,
    #         width=image_info.width,
    #         height=image_info.height,
    #         format=image_info.format,
    #         n_color_spaces=image_info.n_color_spaces,
    #     )
