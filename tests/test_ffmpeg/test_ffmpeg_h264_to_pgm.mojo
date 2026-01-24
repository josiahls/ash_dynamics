from testing.suite import TestSuite
from testing.testing import assert_equal
from memory import memset
import sys
import os
from sys.ffi import c_uchar, c_int, c_char
from sys._libc_errno import ErrNo

from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avutil.avutil import AV_NOPTS_VALUE
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avutil.buffer_internal import AVBuffer
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.ffmpeg.avcodec.avcodec import AVCodecContext
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avcodec.packet import (
    AVPacketSideData,
    AVPacketSideDataType,
)
from ash_dynamics.ffmpeg.avcodec.defs import AV_INPUT_BUFFER_PADDING_SIZE
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec import Avcodec
from ash_dynamics.ffmpeg.avutil.error import AVERROR, AVERROR_EOF


def pgm_save(
    buf: UnsafePointer[c_uchar, origin=MutExternalOrigin],
    wrap: c_int,
    xsize: c_int,
    ysize: c_int,
    filename: String,
):
    with open(filename, "w") as f:
        f.write("P5\n{} {}\n255\n".format(xsize, ysize))
        for i in range(ysize):
            # Write one row of pixel data
            var row_ptr = buf + Int(i * wrap)
            f.write_bytes(Span(ptr=row_ptr, length=Int(xsize)))


fn decode(
    mut avcodec: Avcodec,
    dec_ctx: UnsafePointer[AVCodecContext, origin=MutExternalOrigin],
    frame: UnsafePointer[AVFrame, origin=MutExternalOrigin],
    pkt: UnsafePointer[AVPacket, origin=MutExternalOrigin],
    filename: String,
) raises:
    var ret = avcodec.avcodec_send_packet(dec_ctx, pkt)

    while ret >= 0:
        ret = avcodec.avcodec_receive_frame(dec_ctx, frame)
        if ret == AVERROR(ErrNo.EAGAIN.value) or ret == AVERROR_EOF:
            break
        elif ret < 0:
            os.abort("Error receiving frame.")
        else:
            print("Frame received successfully.")

        try:
            print("Saving frame {}".format(dec_ctx[].frame_num))
            # TODO: Nto quite sure why teh example.cpp prints sizeof(buf) when the
            # size is 1024. Unless pgm_save changes the buf size?
            out_filename = "{}-{}.pgm".format(filename, dec_ctx[].frame_num)
            pgm_save(
                frame[].data[0],
                frame[].linesize[0],
                frame[].width,
                frame[].height,
                out_filename,
            )

        except e:
            print("Error saving frame: ", e)


def test_av_decode_video_example():
    """From: https://www.ffmpeg.org/doxygen/8.0/decode_video_8c-example.html."""
    comptime INBUF_SIZE = c_int(4096)

    var input_buffer = alloc[c_uchar](
        Int(INBUF_SIZE + AV_INPUT_BUFFER_PADDING_SIZE)
    )

    var avcodec = Avcodec()

    # Set the padding portion of the input_buffer to zero.
    memset(
        input_buffer + INBUF_SIZE,
        0,
        Int(AV_INPUT_BUFFER_PADDING_SIZE),
    )
    var packet = avcodec.av_packet_alloc()
    print(packet[])

    var codec = avcodec.avcodec_find_decoder(AVCodecID.AV_CODEC_ID_H264._value)
    print(codec[])

    var parser = avcodec.av_parser_init(codec[].id)
    print(parser[])

    var context = avcodec.avcodec_alloc_context3(codec)
    print(context[])

    ptr = alloc[AVDictionary](0)
    avcodec.avcodec_open2(context, codec, ptr)
    print("Opened codec")

    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    var out_filename: String = (
        "{}/test_data/testsrc_320x180_30fps_2s_decoded".format(test_data_root)
    )

    var frame = avcodec.av_frame_alloc()

    with open(
        "{}/test_data/testsrc_320x180_30fps_2s.h264".format(test_data_root), "r"
    ) as f:
        while True:
            var data_size = c_int(
                f.read[c_uchar.dtype](
                    Span(ptr=input_buffer, length=Int(INBUF_SIZE))
                )
            )

            if data_size == 0:
                break

            var data = input_buffer
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
                    decode(avcodec, context, frame, packet, out_filename)

    _ = codec

    _ = avcodec  # Need this to keep the ffi bind alive


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
