"""
Main libavformat public API header

Reference:
 - https://www.ffmpeg.org/doxygen/8.0/avformat_8h_source.html

I/O and Muxing/Demuxing Library

Libavformat (lavf) is a library for dealing with various media container
formats. Its main two purposes are demuxing - i.e. splitting a media file
into component streams, and the reverse process of muxing - writing supplied
data in a specified container format. It also has an @ref lavf_io
"I/O module" which supports a number of protocols for accessing the data (e.g.
file, tcp, http and others).
Unless you are absolutely sure you won't use libavformat's network
capabilities, you should also call avformat_network_init().
 
A supported input format is described by an AVInputFormat struct, conversely
an output format is described by AVOutputFormat. You can iterate over all
input/output formats using the  av_demuxer_iterate / av_muxer_iterate() functions.
The protocols layer is not part of the public API, so you can only get the names
of supported protocols with the avio_enum_protocols() function.
 
Main lavf structure used for both muxing and demuxing is AVFormatContext,
which exports all information about the file being read or written. As with
most Libavformat structures, its size is not part of public ABI, so it cannot be
allocated on stack or directly with av_malloc(). To create an
AVFormatContext, use avformat_alloc_context() (some functions, like
avformat_open_input() might do that for you).

Most importantly an AVFormatContext contains:
@li the @ref AVFormatContext.iformat "input" or @ref AVFormatContext.oformat
"output" format. It is either autodetected or set by user for input;
always set by user for output.
@li an @ref AVFormatContext.streams "array" of AVStreams, which describe all
elementary streams stored in the file. AVStreams are typically referred to
using their index in this array.
@li an @ref AVFormatContext.pb "I/O context". It is either opened by lavf or
set by user for input, always set by user for output (unless you are dealing
with an AVFMT_NOFILE format).

@section lavf_options Passing options to (de)muxers
It is possible to configure lavf muxers and demuxers using the @ref avoptions
mechanism. Generic (format-independent) libavformat options are provided by
AVFormatContext, they can be examined from a user program by calling
av_opt_next() / av_opt_find() on an allocated AVFormatContext (or its AVClass
from avformat_get_class()). Private (format-specific) options are provided by
AVFormatContext.priv_data if and only if AVInputFormat.priv_class /
AVOutputFormat.priv_class of the corresponding format struct is non-NULL.
Further options may be provided by the @ref AVFormatContext.pb "I/O context",
if its AVClass is non-NULL, and the protocols layer. See the discussion on
nesting in @ref avoptions documentation to learn how to access those.

@section urls
URL strings in libavformat are made of a scheme/protocol, a ':', and a
scheme specific string. URLs without a scheme and ':' used for local files
are supported but deprecated. "file:" should be used for local files.

It is important that the scheme string is not taken from untrusted
sources without checks.

Note that some schemes/protocols are quite powerful, allowing access to
both local and remote files, parts of them, concatenations of them, local
audio and video devices and so on.

Demuxers read a media file and split it into chunks of data (@em packets). A
@ref AVPacket "packet" contains one or more encoded frames which belongs to a
single elementary stream. In the lavf API this process is represented by the
avformat_open_input() function for opening a file, av_read_frame() for
reading a single packet and finally avformat_close_input(), which does the
cleanup.

@section lavf_decoding_open Opening a media file
The minimum information required to open a file is its URL, which
is passed to avformat_open_input(), as in the following code:
@code
const char    *url = "file:in.mp3";
AVFormatContext *s = NULL;
int ret = avformat_open_input(&s, url, NULL, NULL);
if (ret < 0)
	abort();
@endcode

The above code attempts to allocate an AVFormatContext, open the
specified file (autodetecting the format) and read the header, exporting the
information stored there into s. Some formats do not have a header or do not
store enough information there, so it is recommended that you call the
avformat_find_stream_info() function which tries to read and decode a few
frames to find missing information.

In some cases you might want to preallocate an AVFormatContext yourself with
avformat_alloc_context() and do some tweaking on it before passing it to
avformat_open_input(). One such case is when you want to use custom functions
for reading input data instead of lavf internal I/O layer.
To do that, create your own AVIOContext with avio_alloc_context(), passing
your reading callbacks to it. Then set the @em pb field of your
AVFormatContext to newly created AVIOContext.

Since the format of the opened file is in general not known until after
avformat_open_input() has returned, it is not possible to set demuxer private
options on a preallocated context. Instead, the options should be passed to
avformat_open_input() wrapped in an AVDictionary:
@code
AVDictionary *options = NULL;
av_dict_set(&options, "video_size", "640x480", 0);
av_dict_set(&options, "pixel_format", "rgb24", 0);

if (avformat_open_input(&s, url, NULL, &options) < 0)
	abort();
av_dict_free(&options);
@endcode
This code passes the private options 'video_size' and 'pixel_format' to the
demuxer. They would be necessary for e.g. the rawvideo demuxer, since it
cannot know how to interpret raw video data otherwise. If the format turns
out to be something different than raw video, those options will not be
recognized by the demuxer and therefore will not be applied. Such unrecognized
options are then returned in the options dictionary (recognized options are
consumed). The calling program can handle such unrecognized options as it
wishes, e.g.
@code
const AVDictionaryEntry *e;
if ((e = av_dict_iterate(options, NULL))) {
	fprintf(stderr, "Option %s not recognized by the demuxer.\n", e->key);
	abort();
}
@endcode

After you have finished reading the file, you must close it with
avformat_close_input(). It will free everything associated with the file.

@section lavf_decoding_read Reading from an opened file
Reading data from an opened AVFormatContext is done by repeatedly calling
av_read_frame() on it. Each call, if successful, will return an AVPacket
containing encoded data for one AVStream, identified by
AVPacket.stream_index. This packet may be passed straight into the libavcodec
decoding functions avcodec_send_packet() or avcodec_decode_subtitle2() if the
caller wishes to decode the data.

AVPacket.pts, AVPacket.dts and AVPacket.duration timing information will be
set if known. They may also be unset (i.e. AV_NOPTS_VALUE for
pts/dts, 0 for duration) if the stream does not provide them. The timing
information will be in AVStream.time_base units, i.e. it has to be
multiplied by the timebase to convert them to seconds.

A packet returned by av_read_frame() is always reference-counted,
i.e. AVPacket.buf is set and the user may keep it indefinitely.
The packet must be freed with av_packet_unref() when it is no
longer needed.

Muxers take encoded data in the form of @ref AVPacket "AVPackets" and write
it into files or other output bytestreams in the specified container format.

The main API functions for muxing are avformat_write_header() for writing the
file header, av_write_frame() / av_interleaved_write_frame() for writing the
packets and av_write_trailer() for finalizing the file.

At the beginning of the muxing process, the caller must first call
avformat_alloc_context() to create a muxing context. The caller then sets up
the muxer by filling the various fields in this context:

- The @ref AVFormatContext.oformat "oformat" field must be set to select the
  muxer that will be used.
- Unless the format is of the AVFMT_NOFILE type, the @ref AVFormatContext.pb
  "pb" field must be set to an opened IO context, either returned from
  avio_open2() or a custom one.
- Unless the format is of the AVFMT_NOSTREAMS type, at least one stream must
  be created with the avformat_new_stream() function. The caller should fill
  the @ref AVStream.codecpar "stream codec parameters" information, such as the
  codec @ref AVCodecParameters.codec_type "type", @ref AVCodecParameters.codec_id
  "id" and other parameters (e.g. width / height, the pixel or sample format,
  etc.) as known. The @ref AVStream.time_base "stream timebase" should
  be set to the timebase that the caller desires to use for this stream (note
  that the timebase actually used by the muxer can be different, as will be
  described later).
- It is advised to manually initialize only the relevant fields in
  AVCodecParameters, rather than using @ref avcodec_parameters_copy() during
  remuxing: there is no guarantee that the codec context values remain valid
  for both input and output format contexts.
- The caller may fill in additional information, such as @ref
  AVFormatContext.metadata "global" or @ref AVStream.metadata "per-stream"
  metadata, @ref AVFormatContext.chapters "chapters", @ref
  AVFormatContext.programs "programs", etc. as described in the
  AVFormatContext documentation. Whether such information will actually be
  stored in the output depends on what the container format and the muxer
  support.

When the muxing context is fully set up, the caller must call
avformat_write_header() to initialize the muxer internals and write the file
header. Whether anything actually is written to the IO context at this step
depends on the muxer, but this function must always be called. Any muxer
private options must be passed in the options parameter to this function.

The data is then sent to the muxer by repeatedly calling av_write_frame() or
av_interleaved_write_frame() (consult those functions' documentation for
discussion on the difference between them; only one of them may be used with
a single muxing context, they should not be mixed). Do note that the timing
information on the packets sent to the muxer must be in the corresponding
AVStream's timebase. That timebase is set by the muxer (in the
avformat_write_header() step) and may be different from the timebase
requested by the caller.

Once all the data has been written, the caller must call av_write_trailer()
to flush any buffered packets and finalize the output file, then close the IO
context (if any) and finally free the muxing context with
avformat_free_context().

@section lavf_io I/O Read/Write
The directory listing API makes it possible to list files on remote servers.

Some of possible use cases:
- an "open file" dialog to choose files from a remote location,
- a recursive media finder providing a player with an ability to play all
files from a given directory.

@subsection lavf_io_dirlist_open Opening a directory
At first, a directory needs to be opened by calling avio_open_dir()
supplied with a URL and, optionally, ::AVDictionary containing
protocol-specific parameters. The function returns zero or positive
integer and allocates AVIODirContext on success.

@code
AVIODirContext *ctx = NULL;
if (avio_open_dir(&ctx, "smb://example.com/some_dir", NULL) < 0) {
	fprintf(stderr, "Cannot open directory.\n");
	abort();
}
@endcode

This code tries to open a sample directory using smb protocol without
any additional parameters.

@subsection lavf_io_dirlist_read Reading entries
Each directory's entry (i.e. file, another directory, anything else
within ::AVIODirEntryType) is represented by AVIODirEntry.
Reading consecutive entries from an opened AVIODirContext is done by
repeatedly calling avio_read_dir() on it. Each call returns zero or
positive integer if successful. Reading can be stopped right after the
NULL entry has been read -- it means there are no entries left to be
read. The following code reads all entries from a directory associated
with ctx and prints their names to standard output.
@code
AVIODirEntry *entry = NULL;
for (;;) {
	if (avio_read_dir(ctx, &entry) < 0) {
		fprintf(stderr, "Cannot list directory.\n");
		abort();
	}
	if (!entry)
		break;
	printf("%s\n", entry->name);
	avio_free_directory_entry(&entry);
}
@endcode

Symbols present can be listed via:

nm -D $ASH_DYNAMICS_SO_INSTALL_PREFIX/libavformat.so
"""

from sys.ffi import OwnedDLHandle, c_int, c_float, c_char, c_long_long
from os.env import getenv
import os
from ash_dynamics.ffmpeg.avutil.channel_layout import av_channel_layout_copy
from ash_dynamics.ffmpeg.avutil.frame import (
    av_frame_alloc,
    av_frame_get_buffer,
    av_frame_make_writable,
)
from ash_dynamics.ffmpeg.avutil.mathematics import (
    av_compare_ts,
    av_rescale_rnd,
    av_rescale_q_rnd,
)
from ash_dynamics.ffmpeg.avutil.mathematics import AVRounding
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.error import (
    av_strerror,
    AV_ERROR_MAX_STRING_SIZE,
)
from logger import Logger


comptime _logger = Logger()


@fieldwise_init
struct Avutil:
    var lib: OwnedDLHandle

    # ===--------------------------------------------------===
    # ===                   Functions                      ===
    # ===--------------------------------------------------===
    var av_channel_layout_copy: av_channel_layout_copy.type
    "Shadows av_channel_layout_copy."
    var av_frame_alloc: av_frame_alloc.type
    "Shadows av_frame_alloc."
    var av_frame_get_buffer: av_frame_get_buffer.type
    "Shadows av_frame_get_buffer."
    var _av_compare_ts: av_compare_ts.type
    "Shadows av_compare_ts."
    var av_frame_make_writable: av_frame_make_writable.type
    "Shadows av_frame_make_writable."
    var av_rescale_rnd: av_rescale_rnd.type
    "Shadows av_rescale_rnd."
    var _av_rescale_q_rnd: av_rescale_q_rnd.type
    "Shadows av_rescale_q_rnd."
    var av_strerror: av_strerror.type

    fn __init__(out self) raises:
        var so_install_prefix = getenv("ASH_DYNAMICS_SO_INSTALL_PREFIX")
        if so_install_prefix == "":
            os.abort(
                "ASH_DYNAMICS_SO_INSTALL_PREFIX env var is not set. "
                "Expecting a path like:\n"
                "$PIXI_PROJECT_ROOT/third_party/ffmpeg/build/lib\n"
                "Where `libavutil.so` is expected to exist."
            )
        self.lib = OwnedDLHandle("{}/libavutil.so".format(so_install_prefix))
        self.av_channel_layout_copy = av_channel_layout_copy.load(self.lib)
        self.av_frame_alloc = av_frame_alloc.load(self.lib)
        self.av_frame_get_buffer = av_frame_get_buffer.load(self.lib)
        self._av_compare_ts = av_compare_ts.load(self.lib)
        self.av_frame_make_writable = av_frame_make_writable.load(self.lib)
        self.av_rescale_rnd = av_rescale_rnd.load(self.lib)
        self._av_rescale_q_rnd = av_rescale_q_rnd.load(self.lib)
        self.av_strerror = av_strerror.load(self.lib)

    fn av_compare_ts(
        self,
        ts_a: c_long_long,
        tb_a: AVRational,
        ts_b: c_long_long,
        tb_b: AVRational,
    ) -> c_int:
        return self._av_compare_ts(
            ts_a, tb_a.as_long_long(), ts_b, tb_b.as_long_long()
        )

    fn av_rescale_q_rnd(
        self,
        a: c_long_long,
        b: AVRational,
        c: AVRational,
        rnd: AVRounding.ENUM_DTYPE,
    ) -> c_long_long:
        return self._av_rescale_q_rnd(
            a, b.as_long_long(), c.as_long_long(), rnd
        )

    fn av_err2str(
        self,
        err: c_int,
    ) -> String:
        var s = alloc[c_char](AV_ERROR_MAX_STRING_SIZE)
        var ret = self.av_strerror(
            err,
            s,
            AV_ERROR_MAX_STRING_SIZE,
        )
        if ret < 0:
            os.abort(
                "Failed to get error string for error code: {}".format(err)
            )
        return String(unsafe_from_utf8_ptr=s)
