from sys.ffi import (
    c_int,
    c_char,
    c_long_long,
    c_uchar,
    c_ulong,
    c_ulong_long,
    c_uint,
    c_size_t,
)
import os
from utils import StaticTuple
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.primitives._clib import C_Union, ExternalFunction, Debug


comptime AVIO_SEEKABLE_NORMAL = 1 << 0
"Seeking works like for a local file."
comptime AVIO_SEEKABLE_TIME = 1 << 1
"Seeking by timestamp with avio_seek_time() is possible."


@fieldwise_init
struct AVIOInterruptCB(Debug, TrivialRegisterType):
    """This structure contains a callback for checking whether to abort blocking functions.
    """

    var callback: fn(opaque: OpaquePointer[MutExternalOrigin]) -> c_int
    var opaque: OpaquePointer[MutExternalOrigin]


@fieldwise_init
struct AVIODirEntryType(Debug, TrivialRegisterType):
    """This structure contains a directory entry type."""

    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AVIO_ENTRY_UNKNOWN = Self(0)
    comptime AVIO_ENTRY_BLOCK_DEVICE = Self(1)
    comptime AVIO_ENTRY_CHARACTER_DEVICE = Self(2)
    comptime AVIO_ENTRY_DIRECTORY = Self(3)
    comptime AVIO_ENTRY_NAMED_PIPE = Self(4)
    comptime AVIO_ENTRY_SYMBOLIC_LINK = Self(5)
    comptime AVIO_ENTRY_SOCKET = Self(6)


@fieldwise_init
struct AVIODirEntry(Debug, TrivialRegisterType):
    """This structure contains a directory entry."""

    var name: UnsafePointer[c_char, MutExternalOrigin]
    """Filename"""
    var type: AVIODirEntryType.ENUM_DTYPE  # TODO: Is this right?
    """Type of the entry"""
    var utf8: c_int
    """Set to 1 when name is encoded with UTF-8, 0 otherwise.
    Name can be encoded with UTF-8 even though 0 is set."""
    var size: c_long_long
    """File size in bytes, -1 if unknown."""
    var modification_timestamp: c_long_long
    """Time of last modification in microseconds since unix epoch, -1 if unknown."""
    var access_timestamp: c_long_long
    """Time of last access in microseconds since unix epoch, -1 if unknown."""
    var status_change_timestamp: c_long_long
    """Time of last status change in microseconds since unix epoch, -1 if unknown."""
    var user_id: c_long_long
    """User ID of owner, -1 if unknown."""
    var group_id: c_long_long
    """Group ID of owner, -1 if unknown."""
    var filemode: c_long_long
    """Unix file mode, -1 if unknown."""


# TODO: Is this a forward declaration?
struct AVIODirContext(Debug, TrivialRegisterType):
    pass


@fieldwise_init
struct AVIODataMarkerType(Debug, TrivialRegisterType):
    """This structure contains a data marker type."""

    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AVIO_DATA_MARKER_HEADER = Self(0)
    """Header data; this needs to be present for the stream to be decodeable."""
    comptime AVIO_DATA_MARKER_SYNC_POINT = Self(1)
    """A point in the output bytestream where a decoder can start decoding
    (i.e. a keyframe). A demuxer/decoder given the data flagged with
    AVIO_DATA_MARKER_HEADER, followed by any AVIO_DATA_MARKER_SYNC_POINT,
    should give decodeable results."""
    comptime AVIO_DATA_MARKER_BOUNDARY_POINT = Self(2)
    """A point in the output bytestream where a demuxer can start parsing
    (for non self synchronizing bytestream formats). That is, any
    non-keyframe packet start point."""
    comptime AVIO_DATA_MARKER_UNKNOWN = Self(3)
    """This is any, unlabelled data. It can either be a muxer not marking
    any positions at all, it can be an actual boundary/sync point
    that the muxer chooses not to mark, or a later part of a packet/fragment
    that is cut into multiple write callbacks due to limited IO buffer size."""
    comptime AVIO_DATA_MARKER_TRAILER = Self(4)
    """Trailer data, which doesn't contain actual content, but only for
    finalizing the output file."""
    comptime AVIO_DATA_MARKER_FLUSH_POINT = Self(5)
    """A point in the output bytestream where the underlying AVIOContext might
    flush the buffer depending on latency or buffering requirements. Typically
    means the end of a packet."""


@fieldwise_init
struct AVIOContext(Debug, TrivialRegisterType):
    """Bytestream IO Context.

    New public fields can be added with minor version bumps.
    Removal, reordering and changes to existing public fields require
    a major version bump.
    sizeof(AVIOContext) must not be used outside libav*.

    @note None of the function pointers in AVIOContext should be called
    directly, they should only be set by the client application
    when implementing custom I/O. Normally these are set to the
    function pointers specified in avio_alloc_context()
    """

    var av_class: UnsafePointer[AVClass, MutExternalOrigin]
    """A class for private options.

    If this AVIOContext is created by avio_open2(), av_class is set and
    passes the options down to protocols.

    If this AVIOContext is manually allocated, then av_class may be set by
    the caller.

    warning -- this field can be NULL, be sure to not pass this AVIOContext
    to any av_opt_* functions in that case.
    """
    var buffer: UnsafePointer[c_uchar, MutExternalOrigin]
    """The following shows the relationship between buffer, buf_ptr,
    buf_ptr_max, buf_end, buf_size, and pos, when reading and when writing
    (since AVIOContext is used for both):
     
     *********************************************************************************
                                        READING
     *********************************************************************************
     
                                 |              buffer_size              |
                                 |---------------------------------------|
                                 |                                       |
     
                              buffer          buf_ptr       buf_end
                                 +---------------+-----------------------+
                                 |/ / / / / / / /|/ / / / / / /|         |
       read buffer:              |/ / consumed / | to be read /|         |
                                 |/ / / / / / / /|/ / / / / / /|         |
                                 +---------------+-----------------------+
     
                                                              pos
                   +-------------------------------------------+-----------------+
       input file: |                                           |                 |
                   +-------------------------------------------+-----------------+
     
     
     *********************************************************************************
                                        WRITING
     *********************************************************************************
     
                                  |          buffer_size                 |
                                  |--------------------------------------|
                                  |                                      |
     
                                                     buf_ptr_max
                               buffer                 (buf_ptr)       buf_end
                                  +-----------------------+--------------+
                                  |/ / / / / / / / / / / /|              |
       write buffer:              | / / to be flushed / / |              |
                                  |/ / / / / / / / / / / /|              |
                                  +-----------------------+--------------+
                                    buf_ptr can be in this
                                    due to a backward seek
     
                                 pos
                    +-------------+----------------------------------------------+
       output file: |             |                                              |
                    +-------------+----------------------------------------------+
     
    """
    var buffer_size: c_int
    """Maximum buffer size"""
    var buf_ptr: UnsafePointer[c_uchar, MutExternalOrigin]
    """Current position in the buffer"""
    var buf_end: UnsafePointer[c_uchar, MutExternalOrigin]
    """End of the data, may be less than buffer+buffer_size if the read function returned
    less data than requested, e.g. for streams where no more data has been received yet."""
    var opaque: OpaquePointer[MutExternalOrigin]
    """A private pointer, passed to the read/write/seek/... functions."""
    var read_packet: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        buf: UnsafePointer[c_uchar, MutExternalOrigin],
        buf_size: c_int,
    ) -> c_int
    """A function pointer to read data from the input stream."""
    var write_packet: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        buf: UnsafePointer[c_uchar, MutExternalOrigin],
        buf_size: c_int,
    ) -> c_int
    """A function pointer to write data to the output stream."""
    var seek: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        offset: c_long_long,
        whence: c_int,
    ) -> c_long_long
    """A function pointer to seek in the stream."""

    var pos: c_long_long
    """Position in the file of the current buffer"""
    var eof_reached: c_int
    """True if was unable to read due to error or eof"""
    var error: c_int
    """Contains the error code or 0 if no error happened"""
    var write_flag: c_int
    """True if open for writing"""
    var max_packet_size: c_int
    """Maximum packet size"""
    var min_packet_size: c_int
    """Try to buffer at least this amount of data before flushing it."""

    var checksum: c_ulong
    """Checksum of the data read so far"""
    var checksum_ptr: UnsafePointer[c_uchar, MutExternalOrigin]
    """Pointer to the checksum buffer"""
    var update_checksum: fn(
        checksum: c_ulong,
        buf: UnsafePointer[c_uchar, ImmutExternalOrigin],
        size: c_int,
    ) -> c_ulong
    """A function pointer to update the checksum"""
    var read_pause: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        pause: c_int,
    ) -> c_int
    """A function pointer to pause or resume playback for network streaming protocols - e.g. MMS."""
    var read_seek: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        stream_index: c_int,
        timestamp: c_long_long,
        flags: c_int,
    ) -> c_long_long
    """Seek to a given timestamp in stream with the specified stream_index.
    Needed for some network streaming protocols which don't support seeking
    to byte position."""
    var seekable: c_int
    """A combination of AVIO_SEEKABLE_ flags or 0 when the stream is not seekable."""
    var direct: c_int
    """avio_read and avio_write should if possible be satisfied directly
    instead of going through a buffer, and avio_seek will always
    call the underlying seek function directly."""
    var protocol_whitelist: UnsafePointer[c_char, ImmutExternalOrigin]
    """',' separated list of allowed protocols."""
    var protocol_blacklist: UnsafePointer[c_char, ImmutExternalOrigin]
    """',' separated list of disallowed protocols."""
    var write_data_type: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        buf: UnsafePointer[c_uchar, ImmutExternalOrigin],
        buf_size: c_int,
        type: AVIODataMarkerType.ENUM_DTYPE,
        time: c_long_long,
    ) -> c_int
    """A callback that is used instead of write_packet."""

    var ignore_boundary_point: c_int
    """If set, don't call write_data_type separately for AVIO_DATA_MARKER_BOUNDARY_POINT,
    but ignore them and treat them as AVIO_DATA_MARKER_UNKNOWN (to avoid needlessly
    small chunks of data returned from the callback)."""
    var buf_ptr_max: UnsafePointer[c_uchar, MutExternalOrigin]
    """Maximum reached position before a backward seek in the write buffer,
    used keeping track of already written data for a later flush."""
    var bytes_read: c_long_long
    """Read-only statistic of bytes read for this AVIOContext."""
    var bytes_written: c_long_long
    """Read-only statistic of bytes written for this AVIOContext."""


comptime avio_find_protocol_name = fn(
    url: UnsafePointer[c_char, ImmutExternalOrigin],
) -> UnsafePointer[c_char, ImmutExternalOrigin]
"""Return the name of the protocol that will handle the passed URL.

NULL is returned if no protocol could be found for the given URL.

@return Name of the protocol or NULL.
"""

comptime avio_check = fn(
    url: UnsafePointer[c_char, ImmutExternalOrigin],
    flags: c_int,
) -> c_int
"""Return AVIO_FLAG_* access flags corresponding to the access permissions
of the resource in url, or a negative value corresponding to an
AVERROR code in case of failure. The returned access flags are
masked by the value in flags.

@note This function is intrinsically unsafe, in the sense that the
checked resource may change its existence or permission status from
one call to another. Thus you should not trust the returned value,
unless you are sure that no other processes are accessing the
checked resource.
"""

comptime avio_open_dir = fn(
    s: UnsafePointer[
        UnsafePointer[AVIODirContext, MutExternalOrigin], MutExternalOrigin
    ],
    url: UnsafePointer[c_char, ImmutExternalOrigin],
    options: UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Open directory for reading.

Arguments:
- s: directory read context. Pointer to a NULL pointer must be passed.
- url: directory to be listed.
- options: A dictionary filled with protocol-private options. On return
  this parameter will be destroyed and replaced with a dictionary
  containing options that were not found. May be NULL.

Returns:
- >=0 on success or negative on error.
"""

comptime avio_read_dir = fn(
    s: UnsafePointer[AVIODirContext, MutExternalOrigin],
    next: UnsafePointer[
        UnsafePointer[AVIODirEntry, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Get next directory entry.

Arguments:
- s: directory read context.
- next: next entry or NULL when no more entries.

Returns:
- >=0 on success or negative on error. End of list is not considered an
  error.
"""

comptime avio_close_dir = fn(
    s: UnsafePointer[
        UnsafePointer[AVIODirContext, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Close directory.

@note Entries created using avio_read_dir() are not deleted and must be
freeded with avio_free_directory_entry().

Arguments:
- s: directory read context.

Returns:
- >=0 on success or negative on error.
"""

comptime avio_free_directory_entry = fn(
    entry: UnsafePointer[
        UnsafePointer[AVIODirEntry, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Free entry allocated by avio_read_dir().

Arguments:
- entry: entry to be freed.

Returns:
- >=0 on success or negative on error.
"""

comptime avio_alloc_context = fn(
    buffer: UnsafePointer[c_uchar, MutExternalOrigin],
    buffer_size: c_int,
    write_flag: c_int,
    opaque: OpaquePointer[MutExternalOrigin],
    read_packet: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        buf: UnsafePointer[c_uchar, MutExternalOrigin],
        buf_size: c_int,
    ) -> c_int,
    write_packet: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        buf: UnsafePointer[c_uchar, MutExternalOrigin],
        buf_size: c_int,
    ) -> c_int,
    seek: fn(
        opaque: OpaquePointer[MutExternalOrigin],
        offset: c_long_long,
        whence: c_int,
    ) -> c_long_long,
) -> UnsafePointer[AVIOContext, MutExternalOrigin]
"""Allocate and initialize an AVIOContext for buffered I/O. It must be later
freed with avio_context_free().

Arguments:
- buffer: Memory block for input/output operations via AVIOContext.
  The buffer must be allocated with av_malloc() and friends.
  It may be freed and replaced with a new buffer by libavformat.
  AVIOContext.buffer holds the buffer currently in use,
  which must be later freed with av_free().
- buffer_size: The buffer size is very important for performance.
  For protocols with fixed blocksize it should be set to this blocksize.
  For others a typical size is a cache page, e.g. 4kb.
- write_flag: Set to 1 if the buffer should be writable, 0 otherwise.
- opaque: An opaque pointer to user-specific data.
- read_packet: A function for refilling the buffer, may be NULL.
  For stream protocols, must never return 0 but rather a proper AVERROR code.
- write_packet: A function for writing the buffer contents, may be NULL.
  The function may not change the input buffers content.
- seek: A function for seeking to specified byte position, may be NULL.

Returns:
- Allocated AVIOContext or NULL on failure.
"""

comptime avio_context_free = fn(
    s: UnsafePointer[
        UnsafePointer[AVIOContext, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Free the supplied IO context and everything associated with it.

Arguments:
- s: Double pointer to the IO context. This function will write NULL
  into s.

Returns:
- >=0 on success or negative on error.
"""


comptime avio_w8 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    b: c_int,
) -> c_int
comptime avio_write = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    buf: UnsafePointer[c_uchar, ImmutExternalOrigin],
    size: c_int,
) -> c_int
comptime avio_wl64 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    val: c_ulong_long,
) -> c_int
comptime avio_wb64 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    val: c_ulong_long,
) -> c_int
comptime avio_wl32 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    val: c_uint,
) -> c_int
comptime avio_wb32 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    val: c_uint,
) -> c_int
comptime avio_wl24 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    val: c_uint,
) -> c_int
comptime avio_wb24 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    val: c_uint,
) -> c_int
comptime avio_wl16 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    val: c_uint,
) -> c_int
comptime avio_wb16 = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    val: c_uint,
) -> c_int

comptime avio_put_str = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    str: UnsafePointer[c_char, ImmutExternalOrigin],
) -> c_int
"""Write a NULL-terminated string.

Returns:
- number of bytes written.
"""

comptime avio_put_str16le = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    str: UnsafePointer[c_char, ImmutExternalOrigin],
) -> c_int
"""Convert an UTF-8 string to UTF-16LE and write it.

Arguments:
- s: the AVIOContext
- str: NULL-terminated UTF-8 string

Returns:
- number of bytes written.
"""

comptime avio_put_str16be = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    str: UnsafePointer[c_char, ImmutExternalOrigin],
) -> c_int
"""Convert an UTF-8 string to UTF-16BE and write it.

Arguments:
- s: the AVIOContext
- str: NULL-terminated UTF-8 string

Returns:
- number of bytes written.
"""

comptime avio_write_marker = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    time: c_long_long,
    type: AVIODataMarkerType.ENUM_DTYPE,
) -> c_int
"""Mark the written bytestream as a specific type.

Zero-length ranges are omitted from the output.

Arguments:
- s: the AVIOContext
- time: the stream time the current bytestream pos corresponds to
- type: the kind of data written starting at the current pos
"""

comptime AVSEEK_SIZE = 0x10000
"""ORing this as the "whence" parameter to a seek function causes it to
return the filesize without seeking anywhere. Supporting this is optional.
If it is not supported then the seek function will return <0."""

comptime AVSEEK_FORCE = 0x20000
"""Passing this flag as the "whence" parameter to a seek function causes it to
seek by any means (like reopening and linear reading) or other normally unreasonable
means that can be extremely slow. This may be ignored by the seek code."""

comptime avio_seek = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    offset: c_long_long,
    whence: c_int,
) -> c_long_long
"""fseek() equivalent for AVIOContext.

Returns:
- the new position or AVERROR.
"""

comptime avio_skip = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    offset: c_long_long,
) -> c_long_long
"""Skip given number of bytes forward.

Returns:
- the new position or AVERROR.
"""

# TODO: Reimplement in the DLHandle
# @always_inline
# fn avio_tell(s: UnsafePointer[AVIOContext, MutExternalOrigin]) -> c_long_long:
#     """ftell() equivalent for AVIOContext.

#     Returns:
#     - the current position or AVERROR.
#     """
#     return avio_seek(s, 0, os.SEEK_CUR)


comptime avio_size = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
) -> c_long_long
"""Get the filesize.

Returns:
- the filesize or AVERROR.
"""

comptime avio_feof = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
) -> c_int
"""Similar to feof() but also returns nonzero on read errors.

Returns:
- non zero if and only if at end of file or a read error happened when reading.
"""

# Note: without a helper.c if some kind, we cannot support functions like this,
# since we will not have access to the `va_list` type.
# int avio_vprintf(AVIOContext *s, const char *fmt, va_list ap);

comptime avio_printf = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    fmt: UnsafePointer[c_char, ImmutExternalOrigin]
    # ...: Any, TODO: Not sure if we can support this.
) -> c_int
"""Writes a formatted string to the context.

Returns:
- number of bytes written, < 0 on error.
"""

comptime avio_print_string_array = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    strings: UnsafePointer[
        UnsafePointer[c_char, ImmutExternalOrigin], ImmutExternalOrigin
    ],
) -> c_int
"""Write a NULL terminated array of strings to the context.

Usually you don't need to use this function directly but its macro wrapper,
avio_print.

Returns:
- number of bytes written, < 0 on error.
"""

# TODO: Not sure if we can support this.
# Mojo has no way of accessing the __VA_ARGS__ or va_lists.
# #define avio_print(s, ...) \
#     avio_print_string_array(s, (const char*[]){__VA_ARGS__, NULL})

comptime avio_flush = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
) -> c_int
"""Force flushing of buffered data.

For write streams, force the buffered data to be immediately written to the output,
without to wait to fill the internal buffer.

Returns:
- >=0 on success or negative on error.
"""

comptime avio_read = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    buf: UnsafePointer[c_uchar, MutExternalOrigin],
    size: c_int,
) -> c_int
"""Read size bytes from AVIOContext into buf.

Returns:
- number of bytes read or AVERROR.
"""

comptime avio_read_partial = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    buf: UnsafePointer[c_uchar, MutExternalOrigin],
    size: c_int,
) -> c_int
"""Read size bytes from AVIOContext into buf. Unlike avio_read(), this is allowed
to read fewer bytes than requested. The missing bytes can be read in the next
call. This always tries to read at least 1 byte.

Useful to reduce latency in certain cases.

Returns:
- number of bytes read or AVERROR.
"""

# Functions for reading from AVIOContext
comptime AVIOContextMutPtr = UnsafePointer[AVIOContext, MutExternalOrigin]
comptime avio_r8 = fn(s: AVIOContextMutPtr) -> c_int
comptime avio_rl16 = fn(s: AVIOContextMutPtr) -> c_uint
comptime avio_rl24 = fn(s: AVIOContextMutPtr) -> c_uint
comptime avio_rl32 = fn(s: AVIOContextMutPtr) -> c_uint
comptime avio_rl64 = fn(s: AVIOContextMutPtr) -> c_ulong_long
comptime avio_rb16 = fn(s: AVIOContextMutPtr) -> c_uint
comptime avio_rb24 = fn(s: AVIOContextMutPtr) -> c_uint
comptime avio_rb32 = fn(s: AVIOContextMutPtr) -> c_uint
comptime avio_rb64 = fn(s: AVIOContextMutPtr) -> c_ulong_long


comptime avio_get_str = fn(
    s: AVIOContextMutPtr,
    maxlen: c_int,
    buf: UnsafePointer[c_char, MutExternalOrigin],
    buflen: c_int,
) -> c_int
"""Read a string from AVIOContext into buf. The reading will terminate when either
a NULL character was encountered, maxlen bytes have been read, or nothing
more can be read from pb. The result is guaranteed to be NULL-terminated, it
will be truncated if buf is too small.

Note that the string is not interpreted or validated in any way, it
might get truncated in the middle of a sequence for multi-byte encodings.

Returns:
- number of bytes read or AVERROR.
"""

comptime avio_get_str16le = fn(
    s: AVIOContextMutPtr,
    maxlen: c_int,
    buf: UnsafePointer[c_char, MutExternalOrigin],
    buflen: c_int,
) -> c_int
"""Read a UTF-16 string from AVIOContext into buf. The reading will terminate when either
a NULL character was encountered, maxlen bytes have been read, or nothing
more can be read from pb. The result is guaranteed to be NULL-terminated, it
will be truncated if buf is too small.
"""
comptime avio_get_str16be = fn(
    s: AVIOContextMutPtr,
    maxlen: c_int,
    buf: UnsafePointer[c_char, MutExternalOrigin],
    buflen: c_int,
) -> c_int
"""@Ref avio_get_str16le"""

comptime AVIO_FLAG_READ = 1
"""URL open modes

The flags argument to avio_open must be one of the following
constants, optionally ORed with other flags.
@{
"""
comptime AVIO_FLAG_WRITE = 2
"""Ref AVIO_FLAG_READ
"""
comptime AVIO_FLAG_READ_WRITE = AVIO_FLAG_READ | AVIO_FLAG_WRITE
"""Ref AVIO_FLAG_READ
"""
comptime AVIO_FLAG_NONBLOCK = 8
"""Using non-blocking mode.

If this flag is set, operations on the context will return
AVERROR(EAGAIN) if they can not be performed immediately.
If this flag is not set, operations on the context will never return
AVERROR(EAGAIN).
Note that this flag does not affect the opening/connecting of the
context. Connecting a protocol will always block if necessary (e.g. on
network protocols) but never hang (e.g. on busy devices).
Warning: non-blocking protocols is work-in-progress; this flag may be
silently ignored.
"""
comptime AVIO_FLAG_DIRECT = 0x8000
"""Use direct mode.

avio_read and avio_write should if possible be satisfied directly
instead of going through a buffer, and avio_seek will always
call the underlying seek function directly.
"""
comptime avio_open = ExternalFunction[
    "avio_open",
    fn(
        s: UnsafePointer[
            UnsafePointer[AVIOContext, MutExternalOrigin], MutExternalOrigin
        ],
        url: UnsafePointer[c_char, ImmutAnyOrigin],
        flags: c_int,
    ) -> c_int,
]
"""Create and initialize a AVIOContext for accessing the
resource indicated by url.

@note When the resource indicated by url has been opened in
read+write mode, the AVIOContext can be used only for writing.

Arguments:
- s: Used to return the pointer to the created AVIOContext.
In case of failure the pointed to value is set to NULL.
- url: resource to access
- flags: flags which control how the resource indicated by url
is to be opened

Returns:
- >=0 on success or negative on error.
"""

comptime avio_open2 = fn(
    s: UnsafePointer[
        UnsafePointer[AVIOContext, MutExternalOrigin], MutExternalOrigin
    ],
    url: UnsafePointer[c_char, ImmutExternalOrigin],
    flags: c_int,
    int_cb: UnsafePointer[AVIOInterruptCB, MutExternalOrigin],
    options: UnsafePointer[
        UnsafePointer[AVDictionary, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Create and initialize a AVIOContext for accessing the
resource indicated by url.

@note When the resource indicated by url has been opened in
read+write mode, the AVIOContext can be used only for writing.

Arguments:
- s: Used to return the pointer to the created AVIOContext.
In case of failure the pointed to value is set to NULL.
- url: resource to access
- flags: flags which control how the resource indicated by url
is to be opened
- int_cb: an interrupt callback to be used at the protocols level
- options: a dictionary filled with protocol-private options. On return
this parameter will be destroyed and replaced with a dict containing options
that were not found. May be NULL.

Returns:
- >=0 on success or negative on error.
"""

comptime avio_close = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
) -> c_int
"""Close the resource accessed by the AVIOContext s and free it.

The internal buffer is automatically flushed before closing the
resource.

Returns:
- 0 on success or negative on error.
"""

comptime avio_closep = fn(
    s: UnsafePointer[
        UnsafePointer[AVIOContext, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Close the resource accessed by the AVIOContext *s, free it
and set the pointer pointing to it to NULL.

This function can only be used if s was opened by avio_open().

Arguments:
- s: Double pointer to the IO context. This function will write NULL
into s.

Returns:
- 0 on success or negative on error.
"""

comptime avio_open_dyn_buf = fn(
    s: UnsafePointer[
        UnsafePointer[AVIOContext, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Open a write only memory stream.

Arguments:
- s: new IO context

Returns:
- zero if no error.
"""

comptime avio_get_dyn_buf = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    pbuffer: UnsafePointer[
        UnsafePointer[c_uchar, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Return the written size and a pointer to the buffer.

The AVIOContext stream is left intact.
The buffer must NOT be freed.
No padding is added to the buffer.

Arguments:
- s: IO context
- pbuffer: pointer to a byte buffer

Returns:
- the length of the byte buffer or AVERROR.
"""

comptime avio_close_dyn_buf = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    pbuffer: UnsafePointer[
        UnsafePointer[c_uchar, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Return the written size and a pointer to the buffer.

The AVIOContext stream is left intact.
The buffer must be freed with av_free().
Padding of AV_INPUT_BUFFER_PADDING_SIZE is added to the buffer.

Arguments:
- s: IO context
- pbuffer: pointer to a byte buffer

Returns:
- the length of the byte buffer or AVERROR.
"""

comptime avio_enum_protocols = fn(
    opaque: UnsafePointer[OpaquePointer[MutExternalOrigin], MutExternalOrigin],
    output: c_int,
) -> UnsafePointer[c_char, ImmutExternalOrigin]
"""Iterate through names of available protocols.

Arguments:
- opaque: A private pointer representing current protocol.
It must be a pointer to NULL on first iteration and will
be updated by successive calls to avio_enum_protocols.
- output: If set to 1, iterate over output protocols,
otherwise over input protocols.

Returns:
- A static string containing the name of current protocol or NULL
"""

comptime avio_protocol_get_class = fn(
    name: UnsafePointer[c_char, ImmutExternalOrigin],
) -> UnsafePointer[AVClass, ImmutExternalOrigin]
"""Get AVClass by names of available protocols.

Arguments:
- name: Name of the protocol

Returns:
- A AVClass of input protocol name or NULL.
"""

comptime avio_pause = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    pause: c_int,
) -> c_int
"""Pause and resume playing - only meaningful if using a network streaming
protocol (e.g. MMS).

Arguments:
- s: IO context from which to call the read_pause function pointer
- pause: 1 for pause, 0 for resume

Returns:
- >=0 on success or negative on error.
"""

comptime avio_seek_time = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    stream_index: c_int,
    timestamp: c_long_long,
    flags: c_int,
) -> c_long_long
"""Seek to a given timestamp relative to some component stream.
Only meaningful if using a network streaming protocol (e.g. MMS.).

Arguments:
- s: IO context from which to call the seek function pointers
- stream_index: The stream index that the timestamp is relative to.
- timestamp: timestamp in AVStream.time_base units
- flags: Optional combination of AVSEEK_FLAG_BACKWARD, AVSEEK_FLAG_BYTE

Returns:
- >=0 on success or negative on error.
"""


@fieldwise_init
@register_passable("trivial")
struct AVBPrint:
    "Avoid a warning. The header can not be included because it breaks c++."
    pass


comptime avio_read_to_bprint = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    pb: UnsafePointer[AVBPrint, MutExternalOrigin],
    max_size: c_size_t,
) -> c_int
"""Read contents of h into print buffer, up to max_size bytes, or up to EOF.

Returns:
- 0 for success (max_size bytes read or EOF reached), negative error code otherwise.
"""

comptime avio_accept = fn(
    s: UnsafePointer[AVIOContext, MutExternalOrigin],
    c: UnsafePointer[
        UnsafePointer[AVIOContext, MutExternalOrigin], MutExternalOrigin
    ],
) -> c_int
"""Accept and allocate a client context on a server context.

Returns:
- >=0 on success or a negative value corresponding to an AVERROR on failure.

Arguments:
- s: server context
- c: client context, must be unallocated
"""

comptime avio_handshake = fn(
    c: UnsafePointer[AVIOContext, MutExternalOrigin],
) -> c_int
"""Perform one step of the protocol handshake to accept a new client.

This function must be called on a client returned by avio_accept() before
using it as a read/write context.
It is separate from avio_accept() because it may block.
A step of the handshake is defined by places where the application may
decide to change the proceedings.
For example, on a protocol with a request header and a reply header, each
one can constitute a step because the application may use the parameters
from the request to change parameters in the reply; or each individual
chunk of the request can constitute a step.
If the handshake is already finished, avio_handshake() does nothing and
returns 0 immediately.

Arguments:
- c: client context to perform the handshake on

Returns:
- 0 on a complete and successful handshake
- > 0 if the handshake progressed, but is not complete
- < 0 for an AVERROR code
"""
