from testing.suite import TestSuite
from testing.testing import assert_equal
from pathlib import Path
from memory import memset
from itertools import count
import sys
import os
from sys.ffi import (
    c_uchar,
    c_int,
    c_char,
    c_long_long,
    c_float,
    c_uint,
    c_double,
    c_ulong_long,
)
from sys._libc_errno import ErrNo

from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avutil.avutil import AV_NOPTS_VALUE
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
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
from ash_dynamics.ffmpeg.avformat.avformat import AVFormatContext, AVStream
from ash_dynamics.ffmpeg.avformat.avio import AVIOContext
from ash_dynamics.ffmpeg.avutil.frame import AVFrame
from ash_dynamics.ffmpeg.avcodec.codec import AVCodec
from ash_dynamics.ffmpeg.avcodec.codec_id import AVCodecID
from ash_dynamics.ffmpeg.avcodec.codec_par import AVCodecParameters
from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.swscale.swscale import SwsContext
from ash_dynamics.ffmpeg.avformat.avformat import (
    AVOutputFormat,
    AVFormatContext,
    AVFMT_GLOBALHEADER,
    AVFMT_NOFILE,
)
from ash_dynamics.ffmpeg.avformat import Avformat, AVIO_FLAG_WRITE
from ash_dynamics.ffmpeg.avutil.avutil import AVMediaType
from ash_dynamics.ffmpeg.avutil.samplefmt import AVSampleFormat
from ash_dynamics.ffmpeg.avutil import Avutil
from ash_dynamics.ffmpeg.avutil.channel_layout import (
    AVChannelLayout,
    AV_CHANNEL_LAYOUT_STEREO,
)
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat
from ash_dynamics.ffmpeg.swscale.swscale import SwsFlags
from ash_dynamics.ffmpeg.avcodec.avcodec import AV_CODEC_FLAG_GLOBAL_HEADER
from ash_dynamics.ffmpeg.avutil.error import AVERROR, AVERROR_EOF
from ash_dynamics.ffmpeg.swscale import Swscale, SwsFilter
from ash_dynamics.ffmpeg.swrsample import Swrsample
from ash_dynamics.ffmpeg.swrsample.swrsample import SwrContext
from utils import StaticTuple
from ash_dynamics.primitives._clib import Debug


comptime STREAM_FRAME_RATE = 25
comptime STREAM_DURATION = 10.0
comptime STREAM_PIX_FMT = AVPixelFormat.AV_PIX_FMT_YUV420P._value

comptime SCALE_FLAGS = SwsFlags.SWS_BICUBIC


@fieldwise_init
struct OutputStream(Debug, TrivialRegisterType):
    var st: UnsafePointer[AVStream, origin=MutExternalOrigin]
    var enc: UnsafePointer[AVCodecContext, origin=MutExternalOrigin]
    var next_pts: c_long_long
    var samples_count: c_int
    var frame: UnsafePointer[AVFrame, origin=MutExternalOrigin]
    var tmp_frame: UnsafePointer[AVFrame, origin=MutExternalOrigin]
    var tmp_pkt: UnsafePointer[AVPacket, origin=MutExternalOrigin]
    var t: c_float
    var tincr: c_float
    var tincr2: c_float
    var sws_ctx: UnsafePointer[SwsContext, origin=MutExternalOrigin]
    var swr_ctx: UnsafePointer[SwrContext, origin=MutExternalOrigin]

    fn __init__(out self) raises:
        self.st = alloc[AVStream](1)
        self.enc = alloc[AVCodecContext](1)
        self.next_pts = c_long_long(0)
        self.samples_count = c_int(0)
        self.frame = alloc[AVFrame](1)
        self.tmp_frame = alloc[AVFrame](1)
        self.tmp_pkt = alloc[AVPacket](1)
        self.t = c_float(0)
        self.tincr = c_float(0)
        self.tincr2 = c_float(0)
        self.sws_ctx = alloc[SwsContext](1)
        self.swr_ctx = UnsafePointer[SwrContext, MutExternalOrigin]()


def dump_avformat_context(
    oc: UnsafePointer[AVFormatContext, MutExternalOrigin]
):
    """Dump all AVFormatContext fields for debugging."""
    if not oc:
        print("oc is NULL!")
        return

    print("=== AVFormatContext Dump ===")
    print("oc.ctx_flags:", oc[].ctx_flags)
    print("oc.nb_streams:", oc[].nb_streams)
    print("oc.nb_stream_groups:", oc[].nb_stream_groups)
    print("oc.packet_size:", oc[].packet_size)
    print("oc.max_delay:", oc[].max_delay)
    print("oc.flags:", oc[].flags)
    print("oc.probesize:", oc[].probesize)
    print("oc.max_analyze_duration:", oc[].max_analyze_duration)
    print("oc.keylen:", oc[].keylen)
    print("oc.nb_chapters:", oc[].nb_chapters)
    print("oc.nb_programs:", oc[].nb_programs)
    print("oc.start_time:", oc[].start_time)
    print("oc.duration:", oc[].duration)
    print("oc.bit_rate:", oc[].bit_rate)
    print("oc.video_codec_id:", oc[].video_codec_id)
    print("oc.audio_codec_id:", oc[].audio_codec_id)
    print("oc.subtitle_codec_id:", oc[].subtitle_codec_id)
    print("oc.data_codec_id:", oc[].data_codec_id)
    print("oc.start_time_realtime:", oc[].start_time_realtime)
    print("oc.fps_probe_size:", oc[].fps_probe_size)
    print("oc.error_recognition:", oc[].error_recognition)
    print("oc.debug:", oc[].debug)
    print("oc.max_streams:", oc[].max_streams)
    print("oc.max_index_size:", oc[].max_index_size)
    print("oc.max_picture_buffer:", oc[].max_picture_buffer)
    print("oc.max_interleave_delta:", oc[].max_interleave_delta)
    print("oc.max_ts_probe:", oc[].max_ts_probe)
    print("oc.max_chunk_duration:", oc[].max_chunk_duration)
    print("oc.max_chunk_size:", oc[].max_chunk_size)
    print("oc.max_probe_packets:", oc[].max_probe_packets)
    print("oc.strict_std_compliance:", oc[].strict_std_compliance)
    print("oc.event_flags:", oc[].event_flags)
    print("oc.avoid_negative_ts:", oc[].avoid_negative_ts)
    print("oc.audio_preload:", oc[].audio_preload)
    print("oc.use_wallclock_as_timestamps:", oc[].use_wallclock_as_timestamps)
    print(
        "oc.skip_estimate_duration_from_pts:",
        oc[].skip_estimate_duration_from_pts,
    )
    print("oc.avio_flags:", oc[].avio_flags)
    print("oc.duration_estimation_method:", oc[].duration_estimation_method)
    print("oc.skip_initial_bytes:", oc[].skip_initial_bytes)
    print("oc.correct_ts_overflow:", oc[].correct_ts_overflow)
    print("oc.seek2any:", oc[].seek2any)
    print("oc.flush_packets:", oc[].flush_packets)
    print("oc.probe_score:", oc[].probe_score)
    print("oc.format_probesize:", oc[].format_probesize)
    print("oc.io_repositioned:", oc[].io_repositioned)
    print("oc.metadata_header_padding:", oc[].metadata_header_padding)
    print("oc.output_ts_offset:", oc[].output_ts_offset)

    # Pointer fields - show addresses
    print("oc.av_class:", String(oc[].av_class))
    if oc[].av_class:
        print("  oc.av_class->category:", oc[].av_class[].category)
        print(
            "  oc.av_class->state_flags_offset:",
            oc[].av_class[].state_flags_offset,
        )

    print("oc.iformat:", String(oc[].iformat))
    print("oc.oformat:", String(oc[].oformat))
    if oc[].oformat:
        print("  oc.oformat->audio_codec:", oc[].oformat[].audio_codec)
        print("  oc.oformat->video_codec:", oc[].oformat[].video_codec)
        print("  oc.oformat->subtitle_codec:", oc[].oformat[].subtitle_codec)
        print("  oc.oformat->flags:", oc[].oformat[].flags)

    print("oc.priv_data:", String(oc[].priv_data))
    print("oc.pb:", String(oc[].pb))
    if oc[].pb:
        pb = oc[].pb[]
        print("  pb->av_class:", String(pb.av_class))
        print("  pb->buffer:", String(pb.buffer))
        print("  pb->buffer_size:", pb.buffer_size)
        print("  pb->buf_ptr:", String(pb.buf_ptr))
        print("  pb->buf_end:", String(pb.buf_end))
        print("  pb->opaque:", String(pb.opaque))
        print("  pb->pos:", pb.pos)
        print("  pb->eof_reached:", pb.eof_reached)
        print("  pb->error:", pb.error)
        print("  pb->write_flag:", pb.write_flag)
        print("  pb->max_packet_size:", pb.max_packet_size)
        print("  pb->min_packet_size:", pb.min_packet_size)
        print("  pb->checksum:", pb.checksum)
        print("  pb->checksum_ptr:", String(pb.checksum_ptr))
        print("  pb->seekable:", pb.seekable)
        print("  pb->direct:", pb.direct)
        print("  pb->protocol_whitelist:", String(pb.protocol_whitelist))
        print("  pb->protocol_blacklist:", String(pb.protocol_blacklist))
        print("  pb->ignore_boundary_point:", pb.ignore_boundary_point)
        print("  pb->buf_ptr_max:", String(pb.buf_ptr_max))
        print("  pb->bytes_read:", pb.bytes_read)
        print("  pb->bytes_written:", pb.bytes_written)
    print("oc.streams:", String(oc[].streams))
    print("oc.stream_groups:", String(oc[].stream_groups))
    print("oc.chapters:", String(oc[].chapters))
    print("oc.url:", String(oc[].url))
    print("oc.key:", String(oc[].key))
    print("oc.programs:", String(oc[].programs))
    print("oc.metadata:", String(oc[].metadata))
    print("oc.codec_whitelist:", String(oc[].codec_whitelist))
    print("oc.format_whitelist:", String(oc[].format_whitelist))
    print("oc.protocol_whitelist:", String(oc[].protocol_whitelist))
    print("oc.protocol_blacklist:", String(oc[].protocol_blacklist))
    print("oc.video_codec:", String(oc[].video_codec))
    print("oc.audio_codec:", String(oc[].audio_codec))
    print("oc.subtitle_codec:", String(oc[].subtitle_codec))
    print("oc.data_codec:", String(oc[].data_codec))
    print("oc.opaque:", String(oc[].opaque))
    print("oc.dump_separator:", String(oc[].dump_separator))

    # Dump streams
    if oc[].streams and oc[].nb_streams > 0:
        print("\n=== Streams ({} streams) ===".format(oc[].nb_streams))
        for i in range(oc[].nb_streams):
            st = oc[].streams[i]
            if st:
                print("\n--- Stream {} ---".format(i))
                print("  st.index:", st[].index)
                print("  st.id:", st[].id)
                print("  st.codecpar:", String(st[].codecpar))
                if st[].codecpar:
                    cp = st[].codecpar[]
                    print("    codecpar.codec_type:", cp.codec_type)
                    print("    codecpar.codec_id:", cp.codec_id)
                    print("    codecpar.format:", cp.format)
                    print("    codecpar.width:", cp.width)
                    print("    codecpar.height:", cp.height)
                    print("    codecpar.bit_rate:", cp.bit_rate)
                    print("    codecpar.sample_rate:", cp.sample_rate)
                    print("    codecpar.channels:", cp.ch_layout.nb_channels)
                print("  st.time_base.num:", st[].time_base.num)
                print("  st.time_base.den:", st[].time_base.den)
                print("  st.start_time:", st[].start_time)
                print("  st.duration:", st[].duration)
                print("  st.nb_frames:", st[].nb_frames)
                print("  st.disposition:", st[].disposition)
                print("  st.discard:", st[].discard)
                print(
                    "  st.sample_aspect_ratio.num:",
                    st[].sample_aspect_ratio.num,
                )
                print(
                    "  st.sample_aspect_ratio.den:",
                    st[].sample_aspect_ratio.den,
                )
                print("  st.metadata:", String(st[].metadata))
                print("  st.avg_frame_rate.num:", st[].avg_frame_rate.num)
                print("  st.avg_frame_rate.den:", st[].avg_frame_rate.den)
                print("  st.event_flags:", st[].event_flags)
                print("  st.r_frame_rate.num:", st[].r_frame_rate.num)
                print("  st.r_frame_rate.den:", st[].r_frame_rate.den)
                print("  st.pts_wrap_bits:", st[].pts_wrap_bits)

    print("\n=== End AVFormatContext Dump ===\n")


def alloc_frame(
    avutil: Avutil,
    pix_fmt: AVPixelFormat.ENUM_DTYPE,
    width: c_int,
    height: c_int,
) -> UnsafePointer[AVFrame, MutExternalOrigin]:
    var frame = alloc[AVFrame](1)

    frame = avutil.av_frame_alloc()

    frame[].format = pix_fmt
    frame[].width = width
    frame[].height = height

    ret = avutil.av_frame_get_buffer(frame, 0)
    if ret < 0:
        os.abort("Failed to allocate frame buffer")

    return frame


def open_video(
    avformat: Avformat,
    avcodec: Avcodec,
    oc: UnsafePointer[AVFormatContext, MutExternalOrigin],
    video_codec: UnsafePointer[AVCodec, ImmutExternalOrigin],
    mut ost: OutputStream,
    opt_arg: UnsafePointer[AVDictionary, ImmutExternalOrigin],
):
    var ret: c_int = 0
    var avutil = Avutil()
    var c = ost.enc
    # NOTE: We need to add an override to avcodec_open2 that makes
    # an internal null pointer. Debug mode otherwise fails on this.
    var opt = UnsafePointer[AVDictionary, MutExternalOrigin]()
    print("im opening a video")

    avcodec.avcodec_open2(c, video_codec, opt)
    # av_dict_free(&opt);

    ost.frame = alloc_frame(avutil, c[].pix_fmt, c[].width, c[].height)
    if not ost.frame:
        os.abort("Failed to allocate video frame")

    ost.tmp_frame = UnsafePointer[AVFrame, MutExternalOrigin]()
    if c[].pix_fmt != AVPixelFormat.AV_PIX_FMT_YUV420P._value:
        ost.tmp_frame = alloc_frame(
            avutil,
            AVPixelFormat.AV_PIX_FMT_YUV420P._value,
            c[].width,
            c[].height,
        )
        if not ost.tmp_frame:
            os.abort("Failed to allocate temporary video frame")

    ret = avcodec.avcodec_parameters_from_context(ost.st[].codecpar, c)
    if ret < 0:
        os.abort("Failed to copy the stream parameters")

    _ = c


def add_stream(
    avformat: Avformat,
    avcodec: Avcodec,
    mut ost: OutputStream,
    oc: UnsafePointer[AVFormatContext, MutExternalOrigin],
    codec: UnsafePointer[
        UnsafePointer[AVCodec, ImmutExternalOrigin], MutExternalOrigin
    ],
    codec_id: AVCodecID.ENUM_DTYPE,
):
    var i: c_int = 0
    var c = alloc[AVCodecContext](1)

    codec[] = avcodec.avcodec_find_encoder(codec_id)
    if not codec[]:
        os.abort("Failed to find encoder")

    ost.tmp_pkt = avcodec.av_packet_alloc()
    if not ost.tmp_pkt:
        os.abort("Failed to allocate AVPacket")

    ost.st = avformat.avformat_new_stream(
        oc,
        # Add a null pointer.
        UnsafePointer[AVCodec, ImmutExternalOrigin](),
    )
    if not ost.st:
        os.abort("Failed to allocate stream")

    ost.st[].id = c_int(oc[].nb_streams - 1)

    c = avcodec.avcodec_alloc_context3(codec[])
    if not c:
        os.abort("Failed to allocate encoding context")

    ost.enc = c

    avutil = Avutil()

    ref codec_type = codec[][].type
    if codec_type == AVMediaType.AVMEDIA_TYPE_AUDIO._value:
        if not codec[][].sample_fmts:
            c[].sample_fmt = AVSampleFormat.AV_SAMPLE_FMT_FLTP._value
        else:
            # FIXME: Note that sample_fmts is deprecated and we should be using
            # avcodec_get_supported_config
            c[].sample_fmt = codec[][].sample_fmts[]
        c[].bit_rate = 64000
        c[].sample_rate = 44100
        if codec[][].supported_samplerates:
            c[].sample_rate = codec[][].supported_samplerates[]
            for i in count():
                if not codec[][].supported_samplerates[i]:
                    break
                if codec[][].supported_samplerates[i] == 44100:
                    c[].sample_rate = 44100

        var layout = alloc[AVChannelLayout](1)
        layout[] = AV_CHANNEL_LAYOUT_STEREO
        var dst = UnsafePointer(to=c[].ch_layout)
        ret = avutil.av_channel_layout_copy(dst, layout)
        if ret < 0:
            os.abort("Failed to copy channel layout")

        ost.st[].time_base = AVRational(num=1, den=c[].sample_rate)

    elif codec_type == AVMediaType.AVMEDIA_TYPE_VIDEO._value:
        c[].codec_id = codec_id
        c[].bit_rate = 400000
        # Resolution must be multople of two
        c[].width = 352
        c[].height = 288

        # Timebase: This is the fundamental unit of time (in seconds) in terms
        # of which frame timestamps are represented. For fixed-gps content
        # timebase should be 1/framerate and timestamp increments should be identical
        # to 1.
        ost.st[].time_base = AVRational(num=1, den=STREAM_FRAME_RATE)
        c[].time_base = ost.st[].time_base

        c[].gop_size = 12  # Emit one intra frame every twelve frames at most
        c[].pix_fmt = STREAM_PIX_FMT
        if codec_id == AVCodecID.AV_CODEC_ID_MPEG2VIDEO._value:
            # Just for testing, we also add B-frames
            c[].max_b_frames = 2

        if codec_id == AVCodecID.AV_CODEC_ID_MPEG1VIDEO._value:
            # Needed to avoid using macroblocks in which some coeffs overflow.
            # This does not happen with normal video, it just happens here as
            # the motion of the chroma plane does not match the luma plane.
            c[].mb_decision = 2

        pass

    if oc[].oformat[].flags & AVFMT_GLOBALHEADER:
        c[].flags |= AV_CODEC_FLAG_GLOBAL_HEADER

    # ost.enc = ret


def log_packet(
    fmt_ctx: UnsafePointer[AVFormatContext, MutExternalOrigin],
    pkt: UnsafePointer[AVPacket, MutExternalOrigin],
):
    print(
        "pts:{} dts:{} duration:{} stream_index:{}".format(
            pkt[].pts,
            pkt[].dts,
            pkt[].duration,
            pkt[].stream_index,
        )
    )


def fill_yuv_image(
    frame: UnsafePointer[AVFrame, MutExternalOrigin],
    frame_index: c_int,
    width: c_int,
    height: c_int,
):
    var x: c_int = 0
    var y: c_int = 0
    var i: c_int = frame_index
    for y in range(height):
        for x in range(width):
            frame[].data[0][y * frame[].linesize[0] + x] = c_uchar(
                x + y + i * 3
            )
    for y in range(height / 2):
        for x in range(width / 2):
            frame[].data[1][y * frame[].linesize[1] + x] = c_uchar(
                128 + y + i * 2
            )
            frame[].data[2][y * frame[].linesize[2] + x] = c_uchar(
                64 + x + i * 5
            )


def get_video_frame(
    swrsample: Swrsample,
    swscale: Swscale,
    avutil: Avutil,
    avcodec: Avcodec,
    mut ost: OutputStream,
) -> UnsafePointer[AVFrame, MutExternalOrigin]:
    var c = ost.enc

    var comparison = avutil.av_compare_ts(
        ost.next_pts,
        c[].time_base,
        c_long_long(Int(STREAM_DURATION)),
        AVRational(num=1, den=1),
    )

    if comparison > 0:
        return UnsafePointer[AVFrame, MutExternalOrigin]()

    _ = comparison
    _ = c

    if avutil.av_frame_make_writable(ost.frame) < 0:
        os.abort("Failed to make frame writable")

    if c[].pix_fmt != AVPixelFormat.AV_PIX_FMT_YUV420P._value:
        if not ost.sws_ctx:
            ost.sws_ctx = swscale.sws_getContext(
                c[].width,
                c[].height,
                AVPixelFormat.AV_PIX_FMT_YUV420P._value,
                c[].width,
                c[].height,
                c[].pix_fmt,
                SCALE_FLAGS.value,
                UnsafePointer[SwsFilter, MutExternalOrigin](),
                UnsafePointer[SwsFilter, MutExternalOrigin](),
                UnsafePointer[c_double, ImmutExternalOrigin](),
            )
            if not ost.sws_ctx:
                os.abort("Failed to initialize conversion context")

            # API wise, this seems problematic no? These are all long longs
            # and we are converting to ints.
            fill_yuv_image(
                ost.tmp_frame,
                c_int(ost.next_pts),
                c_int(c[].width),
                c_int(c[].height),
            )

            # TODO: There has to be a better way to do this.
            # We should at least not be doing the allocations in a hot loop.
            var src_slice = alloc[UnsafePointer[c_uchar, ImmutExternalOrigin]](
                len(ost.tmp_frame[].data)
            )
            for i in range(len(ost.tmp_frame[].data)):
                src_slice[i] = ost.tmp_frame[].data[i].as_immutable()

            var dst = alloc[UnsafePointer[c_uchar, MutExternalOrigin]](
                len(ost.frame[].data)
            )
            for i in range(len(ost.frame[].data)):
                dst[i] = ost.frame[].data[i]

            # NOTE: https://github.com/modular/modular/pull/5715
            # adds unsafe_ptr to StaticTuple, which is needed for this.
            var res = swscale.sws_scale(
                ost.sws_ctx,
                src_slice,
                ost.tmp_frame[].linesize.unsafe_ptr(),
                0,
                c[].height,
                dst,
                ost.frame[].linesize.unsafe_ptr(),
            )
            if res < 0:
                os.abort("Failed to scale image")
    else:
        fill_yuv_image(
            ost.frame, c_int(ost.next_pts), c_int(c[].width), c_int(c[].height)
        )

    # NOTE They use ++ which I think increments the next ptr itself actually, but
    # assignes the previous value to pts.
    ost.frame[].pts = ost.next_pts
    ost.next_pts += 1

    return ost.frame


def write_frame(
    avformat: Avformat,
    avcodec: Avcodec,
    fmt_ctx: UnsafePointer[AVFormatContext, MutExternalOrigin],
    c: UnsafePointer[AVCodecContext, MutExternalOrigin],
    st: UnsafePointer[AVStream, MutExternalOrigin],
    frame: UnsafePointer[AVFrame, MutExternalOrigin],
    pkt: UnsafePointer[AVPacket, MutExternalOrigin],
) -> c_int:
    # TODO: Check pkt. It looks completely invalid.
    var ret = c_int(0)
    ret = avcodec.avcodec_send_frame(c, frame)
    if ret < 0:
        os.abort("Failed to send frame to encoder")
    _ = frame
    while ret >= 0:
        ret = avcodec.avcodec_receive_packet(c, pkt)

        if ret == AVERROR(ErrNo.EAGAIN.value) or ret == AVERROR_EOF:
            break
        elif ret < 0:
            var avutil = Avutil()
            print(avutil.av_err2str(ret))
            os.abort(
                "Failed to receive packet from encoder with ret val: {}".format(
                    ret
                )
            )

        avcodec.av_packet_rescale_ts(pkt, c[].time_base, st[].time_base)
        pkt[].stream_index = st[].index

        log_packet(fmt_ctx, pkt)
        ret = avformat.av_interleaved_write_frame(fmt_ctx, pkt)
        if ret < 0:
            os.abort("Failed to write output packet")

    # _ = avcodec
    # _ = avformat
    return c_int(ret == AVERROR_EOF)


def write_video_frame(
    avformat: Avformat,
    avcodec: Avcodec,
    avutil: Avutil,
    swrsample: Swrsample,
    swscale: Swscale,
    oc: UnsafePointer[AVFormatContext, MutExternalOrigin],
    mut ost: OutputStream,
) -> c_int:
    var ret = write_frame(
        avformat=avformat,
        avcodec=avcodec,
        fmt_ctx=oc,
        c=ost.enc,
        st=ost.st,
        frame=get_video_frame(swrsample, swscale, avutil, avcodec, ost),
        pkt=ost.tmp_pkt,
    )
    return ret


def test_av_mux_example():
    """From: https://www.ffmpeg.org/doxygen/8.0/mux_8c-example.html."""
    var video_st = OutputStream()
    # NOTE: Not interested in audio at the moment.
    # var audio_st = OutputStream()
    var fmt = alloc[UnsafePointer[AVOutputFormat, ImmutExternalOrigin]](1)
    var oc = alloc[UnsafePointer[AVFormatContext, MutExternalOrigin]](1)
    # var oc = UnsafePointer[AVFormatContext, MutAnyOrigin]()
    # NOTE: Not interested in audio at the moment.
    # var audio_codec = AVCodec()
    var video_codec = alloc[UnsafePointer[AVCodec, ImmutExternalOrigin]](1)
    var ret = c_int(0)
    var have_video = c_int(0)
    # NOTE: Not interested in audio at the moment.
    # var have_audio = c_int(0)
    var encode_video = c_int(0)
    # var encode_audio = c_int(0)
    var opt = alloc[UnsafePointer[AVDictionary, MutExternalOrigin]](1)
    opt[] = UnsafePointer[
        AVDictionary, MutExternalOrigin
    ]()  # NULL, let FFmpeg manage
    var opt2 = alloc[UnsafePointer[AVDictionary, MutExternalOrigin]](1)
    opt2[] = UnsafePointer[
        AVDictionary, MutExternalOrigin
    ]()  # NULL, let FFmpeg manage
    var i = c_int(0)

    var avformat = Avformat()
    var avcodec = Avcodec()
    var avutil = Avutil()
    var swscale = Swscale()
    var swrsample = Swrsample()

    var test_data_root = os.getenv("PIXI_PROJECT_ROOT")
    # Currently auto gens frames
    # var input_filename: String = (
    #     "{}/test_data/testsrc_320x180_30fps_2s.h264".format(test_data_root)
    # )
    var output_filename: String = (
        "{}/test_data/dash_mojo/testsrc_320x180_30fps_2s.mpd".format(
            test_data_root
        )
    )
    var parent_path_parts = Path(output_filename).parts()[:-1]
    var parent_path = Path(String(os.sep).join(parent_path_parts))
    os.makedirs(parent_path, exist_ok=True)

    # FIXME: Tryout without any flags, just h264 to mp4.
    # ret = avformat.alloc_output_context(oc, output_filename)

    ret = avformat.alloc_output_context(
        ctx=oc,
        filename=output_filename,
    )
    if not oc or ret < 0:
        os.abort("Failed to allocate output context")
        # Note: The example: mux.c will switch to 'mpeg' on failure. In our case
        # however, we want to be strict about the expected behavior.

    fmt = UnsafePointer(to=oc[][].oformat)
    video_codec = UnsafePointer(to=oc[][].video_codec)

    if fmt[][].video_codec != AVCodecID.AV_CODEC_ID_NONE._value:
        print("video codec is not none: ", fmt[][].video_codec)
        add_stream(
            avformat, avcodec, video_st, oc[], video_codec, fmt[][].video_codec
        )
        have_video = 1
        encode_video = 1
    else:
        print("video codec is none")
    # if fmt[].audio_codec != AV_CODEC_ID_NONE:
    #     print("audio codec is not none")
    # else:
    #     print("audio codec is none")

    if have_video:
        open_video(avformat, avcodec, oc[], video_codec[], video_st, opt[])

    # Not interested in audio at the moment.
    # if have_audio:
    #     open_audio(avformat, avcodec, oc[], audio_codec[], audio_st, opt[])

    avformat.av_dump_format(
        oc[], 0, output_filename.as_c_string_slice().unsafe_ptr(), 1
    )

    if not (fmt[][].flags & AVFMT_NOFILE):
        ret = avformat.avio_open(
            UnsafePointer(to=oc[][].pb),
            output_filename.as_c_string_slice().unsafe_ptr(),
            AVIO_FLAG_WRITE,
        )
        if ret < 0:
            os.abort("Failed to open output file: {}".format(ret))
            # TODO: Not sure if mojo can access stderror or not?
            # Would be ideal since that would surface the error message to the user.
            # fprintf(stderr, "Could not open '%s': %s\n", filename,
            #         av_err2str(ret));

    # Debug: Dump all AVFormatContext fields
    dump_avformat_context(oc[])

    print("writing header")
    ret = avformat.avformat_write_header(
        oc[],
        opt2,
    )
    print("dune writing")
    if ret < 0:
        os.abort("Failed to write header: {}".format(ret))
        # TODO: Not sure if mojo can access stderror or not?
        # Would be ideal since that would surface the error message to the user.
        # fprintf(stderr, "Error occurred when opening output file: %s\n",
        #         av_err2str(ret));

    while encode_video:
        # TODO: This if statement is only needed when using audio.
        # if encode_video and avutil.av_compare_ts(
        #     video_st.next_pts,
        #     video_st.enc->time_base,
        #     audio_st.next_pts,
        #     audio_st.enc->time_base
        # ) <= 0:
        if encode_video:
            var result = write_video_frame(
                avformat, avcodec, avutil, swrsample, swscale, oc[], video_st
            )
            # print("Result: {}".format(result))
            encode_video = c_int(result == 0)
        # else:
        #     encode_audio = !write_audio_frame(oc, &audio_st)

    ret = avformat.av_write_trailer(oc[])
    if ret < 0:
        os.abort("Failed to write trailer: {}".format(ret))

    _ = opt
    # _ = opt2
    _ = ret
    _ = fmt
    _ = oc
    _ = avformat
    _ = avcodec
    _ = swscale
    _ = swrsample
    _ = avutil


def main():
    TestSuite.discover_tests[__functions_in_module()]().run()
