from ffi import c_uchar, c_char, c_int, c_long_long
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
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from logger.logger import Logger, Level, DEFAULT_LEVEL


comptime _logger = Logger[level=DEFAULT_LEVEL]()


@fieldwise_init
struct ImageData:
    var data: UnsafePointer[c_uchar, MutExternalOrigin]
    var width: c_int
    var height: c_int
    var format: AVPixelFormat.ENUM_DTYPE
    var n_color_spaces: c_int

    fn __init__(out self):
        self.data = UnsafePointer[c_uchar, MutExternalOrigin]()
        self.width = 0
        self.height = 0
        self.format = AVPixelFormat.AV_PIX_FMT_NONE._value
        self.n_color_spaces = 0


@fieldwise_init
struct ImageInfo(Writable):
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
    mut image_info: ImageInfo,
    mut output_buffer: List[c_uchar],
) raises:
    var ret: c_int = avcodec.avcodec_send_packet(dec_ctx, pkt)
    _logger.debug("Packet sent successfully.")

    while ret >= 0:
        ret = avcodec.avcodec_receive_frame(dec_ctx, frame)
        if ret == AVERROR(ErrNo.EAGAIN.value) or ret == AVERROR_EOF:
            break
        _logger.debug("Frame received successfully.")

        image_info.width = frame[].width
        image_info.height = frame[].height
        image_info.format = dec_ctx[].pix_fmt
        image_info.n_color_spaces = dec_ctx[].color_range

        # TODO: We should instead extend via passing in a List, that way
        # we do a chunked move operation instead of a copy which is
        # what is happening here. (dont be fooled by the ptr pass)
        output_buffer.extend(
            Span(
                ptr=frame[].data[0],
                length=Int(frame[].linesize[0] * Int(frame[].height)),
            )
        )


fn image_read[in_buffer_size: c_int = 4096](path: Path) raises -> ImageData:
    """Reads an image file.

    Parameters:
        in_buffer_size: The number of bytes to read and load into memory at one time. Default is 4096.

    """
    _logger.info("Reading image from path: ", path)
    var avformat = Avformat()
    var avcodec = Avcodec()
    var avutil = Avutil()
    var swscale = Swscale()
    var swrsample = Swrsample()

    var oc = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    var dict = alloc[AVDictionary](0)
    var extension = path.suffix()

    var input_buffer = InlineArray[
        c_uchar, Int(in_buffer_size + AV_INPUT_BUFFER_PADDING_SIZE)
    ](uninitialized=True)
    var output_buffer = List[c_uchar](capacity=Int(in_buffer_size))

    # Set the AV_INPUT_BUFFER_PADDING_SIZE portion of the input_buffer to zero.
    memset(
        input_buffer.unsafe_ptr() + in_buffer_size,
        0,
        Int(AV_INPUT_BUFFER_PADDING_SIZE),
    )

    var packet = avcodec.av_packet_alloc()
    var codec = avcodec.avcodec_find_decoder_by_name(extension)
    var parser = avcodec.av_parser_init(codec[].id)
    var context = avcodec.avcodec_alloc_context3(codec)
    avcodec.avcodec_open2(context, codec, dict)
    var frame = avcodec.av_frame_alloc()
    var image_info = ImageInfo()

    with open(path, "r") as f:
        while True:
            var data = input_buffer.unsafe_ptr()
            var data_size = c_int(f.read(buffer=input_buffer))
            if data_size == 0:
                break

            while data_size > 0:
                _logger.debug("Data size: ", data_size)
                var size = avcodec.av_parser_parse2(
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

                _logger.debug("Parsed size: ", size)
                data += size
                data_size -= size

                if packet[].size > 0:
                    _logger.debug("Packet size is: ", packet[].size)
                    decode(
                        avcodec,
                        context,
                        frame,
                        packet,
                        image_info,
                        output_buffer,
                    )

    _logger.debug("Image info: ", image_info)
    _logger.debug("Output buffer: ", len(output_buffer))
    # _ = codec
    _ = context
    _ = avformat
    _ = avutil
    _ = swscale
    _ = swrsample
    _ = oc
    _ = input_buffer
    _ = packet
    _ = avcodec
    _ = parser
    var data = output_buffer.unsafe_ptr().unsafe_origin_cast[
        MutExternalOrigin
    ]()
    return ImageData(
        data=data,
        width=image_info.width,
        height=image_info.height,
        format=image_info.format,
        n_color_spaces=image_info.n_color_spaces,
    )


fn encode(
    mut avcodec: Avcodec,
    enc_ctx: UnsafePointer[AVCodecContext, origin=MutExternalOrigin],
    frame: UnsafePointer[AVFrame, origin=MutExternalOrigin],
    pkt: UnsafePointer[AVPacket, origin=MutExternalOrigin],
    mut outfile: FileHandle,
) raises:
    var ret = avcodec.avcodec_send_frame(enc_ctx, frame)
    if ret < 0:
        raise Error("Failed to send frame for encoding: ", ret)

    while ret >= 0:
        ret = avcodec.avcodec_receive_packet(enc_ctx, pkt)
        if ret == AVERROR(ErrNo.EAGAIN.value) or ret == AVERROR_EOF:
            break

        outfile.write_bytes(
            Span(
                ptr=pkt[].data,
                length=Int(pkt[].size),
            )
        )
        avcodec.av_packet_unref(pkt)


fn image_save(image: ImageData, path: Path) raises:
    """Saves an image to a file.

    Parameters:
        image: The image to save.
        path: The path to save the image to.
    """
    _logger.info("Saving image to path: ", path)
    var avformat = Avformat()
    var avcodec = Avcodec()
    var avutil = Avutil()
    var swscale = Swscale()
    var swrsample = Swrsample()

    var dict = alloc[AVDictionary](0)
    var extension = path.suffix()

    var codec = avcodec.avcodec_find_encoder_by_name(extension)
    print("Found codec: ", codec[])
    var context = avcodec.avcodec_alloc_context3(codec)
    context[].time_base = AVRational(num=1, den=25)
    context[].pix_fmt = image.format
    context[].width = image.width
    context[].height = image.height
    context[].color_range = image.n_color_spaces
    var packet = avcodec.av_packet_alloc()

    print("Opening codec")
    avcodec.avcodec_open2(context, codec, dict)

    print("Opened codec")
    var frame = avcodec.av_frame_alloc()
    print("Allocated frame")
    frame[].format = context[].pix_fmt
    frame[].width = context[].width
    frame[].height = context[].height
    frame[].color_range = context[].color_range

    print("Getting frame buffer")
    var ret = avutil.av_frame_get_buffer(frame, 0)
    if ret < 0:
        raise Error("Failed to allocate frame buffer: ", ret)

    with open(path, "w") as f:
        var i = c_int(0)
        # while True:
        print("Making frame writable")
        ret = avutil.av_frame_make_writable(frame)
        if ret < 0:
            raise Error("Failed to make frame writable: ", ret)

        # TODO: Remove the copy. We should be able to do a take or something.
        # Also we really need to factor in whether the pointer is
        # even the correct format.
        frame[].data[0] = image.data.copy()

        frame[].pts = c_long_long(i)
        i += 1

        encode(
            avcodec,
            context,
            frame,
            packet,
            f,
        )

        encode(
            avcodec,
            context,
            UnsafePointer[AVFrame, origin=MutExternalOrigin](),
            packet,
            f,
        )

        _ = avformat
        _ = avutil
        _ = swscale
        _ = swrsample
        _ = packet
        _ = avcodec
