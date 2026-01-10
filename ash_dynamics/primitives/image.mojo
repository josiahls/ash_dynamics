from sys.ffi import c_uchar, c_char, c_int
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
    mut out_data: UnsafePointer[c_uchar, MutExternalOrigin],
):
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

        out_data = alloc[c_uchar](Int(frame[].linesize[0]))
        out_data[] = frame[].data[0][]

        # try:
        #     print("Saving frame {}".format(dec_ctx[].frame_num))
        # TODO: Nto quite sure why teh example.cpp prints sizeof(buf) when the
        # size is 1024. Unless pgm_save changes the buf size?
        # out_filename = "{}-{}.pgm".format(filename, dec_ctx[].frame_num)
        # pgm_save(
        #     frame[].data[0],
        #     frame[].linesize[0],
        #     frame[].width,
        #     frame[].height,
        #     out_filename,
        # )

        # except e:
        #     print("Error saving frame: ", e)


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
        var avformat = Avformat()
        var avcodec = Avcodec()
        var avutil = Avutil()
        var swscale = Swscale()
        var swrsample = Swrsample()

        var oc = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
        var name = path.name().copy()
        var extension = String("png")

        comptime INBUF_SIZE = c_int(4096)

        var input_buffer = alloc[c_uchar](
            Int(INBUF_SIZE + AV_INPUT_BUFFER_PADDING_SIZE)
        )

        # Set the padding portion of the input_buffer to zero.
        memset(
            input_buffer + INBUF_SIZE,
            0,
            Int(AV_INPUT_BUFFER_PADDING_SIZE),
        )
        var packet = avcodec.av_packet_alloc()
        # print(packet[])

        var codec = avcodec.avcodec_find_decoder_by_name(
            extension.as_c_string_slice().unsafe_ptr().as_immutable()
        )
        # print(codec[])

        var parser = avcodec.av_parser_init(codec[].id)
        # print(parser[])

        var context = avcodec.avcodec_alloc_context3(codec)
        # print(context[])

        ptr = alloc[AVDictionary](0)
        try_open = avcodec.avcodec_open2(context, codec, ptr)
        if try_open < 0:
            print("Failed to open codec")
            sys.exit(1)
        else:
            print("Opened codec")

        var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
        var out_filename: String = (
            "{}/test_data/testsrc_320x180_30fps_2s_decoded".format(
                test_data_root
            )
        )

        var frame = avcodec.av_frame_alloc()
        var image_info = ImageInfo()

        var data_list = path.read_bytes()
        var data_size = c_int(len(data_list))
        var data = data_list.unsafe_ptr().unsafe_origin_cast[
            MutExternalOrigin
        ]()
        var out_data = UnsafePointer[c_uchar, MutExternalOrigin]()

        # with open(
        #     path,
        #     # "{}/test_data/testsrc_320x180_30fps_2s.h264".format(test_data_root),
        #     "r"
        # ) as f:
        while True:
            # var data_size = c_int(
            #     f.read[c_uchar.dtype](
            #         Span(ptr=input_buffer, length=Int(INBUF_SIZE))
            #     )
            # )

            if data_size == 0:
                break

            # var data = input_buffer
            while data_size > 0:
                var ret = avcodec.av_parser_parse2(
                    parser,
                    context,
                    UnsafePointer(to=packet[].data),
                    UnsafePointer(to=packet[].size),
                    data,
                    data_size,
                    AV_NOPTS_VALUE,
                    AV_NOPTS_VALUE,
                    0,
                )
                if ret < 0:
                    print("Failed to parse data")
                    sys.exit(1)
                elif parser[].flags & AVPacket.AV_PKT_FLAG_CORRUPT:
                    print("Parsed data is corrupted")
                else:
                    print("Parsed data is valid")
                data += ret
                data_size -= ret

                if packet[].size > 0:
                    print("Packet size: ", packet[].size)
                    decode(
                        avcodec,
                        context,
                        frame,
                        packet,
                        out_filename,
                        image_info,
                        out_data,
                    )

            data_size = 0

        _ = codec

        _ = avcodec  # Need this to keep the ffi bind alive

        return Self(
            data=out_data,
            width=image_info.width,
            height=image_info.height,
            format=image_info.format,
            n_color_spaces=image_info.n_color_spaces,
        )
