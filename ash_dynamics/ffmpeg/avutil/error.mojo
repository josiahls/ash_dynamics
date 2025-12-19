from sys.ffi import c_int
from ash_dynamics.ffmpeg.avutil import avconfig
from ash_dynamics.ffmpeg.avutil.macros import MKTAG
from utils import Variant


# NOTE: There is a macro conditional: EDOM > 0. Not sure if we need to do this.
fn AVERROR(err: c_int) -> c_int:
    return -err


comptime IntOrStr = Variant[Int, c_int, String, StaticString]


__extension Variant:
    fn get_int(self) -> Int:
        if self.isa[Int]():
            return self[Int]
        elif self.isa[c_int]():
            return Int(self[c_int])
        elif self.isa[String]():
            return ord(self[String])
        else:
            return ord(self[StaticString])


@always_inline
fn FFERRTAG(a: IntOrStr, b: IntOrStr, c: IntOrStr, d: IntOrStr) -> Int:
    return -MKTAG(a.get_int(), b.get_int(), d.get_int(), c.get_int())


comptime AVERROR_BSF_NOT_FOUND = FFERRTAG(0xF8, "B", "S", "F")
"Bitstream filter not found"

comptime AVERROR_BUG = FFERRTAG("B", "U", "G", "!")
"Internal bug, also see AVERROR_BUG2"

comptime AVERROR_BUFFER_TOO_SMALL = FFERRTAG("B", "U", "F", "S")
"Buffer too small"

comptime AVERROR_DECODER_NOT_FOUND = FFERRTAG(0xF8, "D", "E", "C")
"Decoder not found"

comptime AVERROR_DEMUXER_NOT_FOUND = FFERRTAG(0xF8, "D", "E", "M")
"Demuxer not found"

comptime AVERROR_ENCODER_NOT_FOUND = FFERRTAG(0xF8, "E", "N", "C")
"Encoder not found"

comptime AVERROR_EOF = FFERRTAG("E", "O", "F", " ")
"End of file"

comptime AVERROR_EXIT = FFERRTAG("E", "X", "I", "T")
"Immediate exit was requested; the called function should not be restarted"

comptime AVERROR_EXTERNAL = FFERRTAG("E", "X", "T", " ")
"Generic error in an external library"

comptime AVERROR_FILTER_NOT_FOUND = FFERRTAG(0xF8, "F", "I", "L")
"Filter not found"

comptime AVERROR_INVALIDDATA = FFERRTAG("I", "N", "D", "A")
"Invalid data found when processing input"

comptime AVERROR_MUXER_NOT_FOUND = FFERRTAG(0xF8, "M", "U", "X")
"Muxer not found"

comptime AVERROR_OPTION_NOT_FOUND = FFERRTAG(0xF8, "O", "P", "T")
"Option not found"

comptime AVERROR_PATCHWELCOME = FFERRTAG("P", "A", "W", "E")
"Not yet implemented in FFmpeg, patches welcome"

comptime AVERROR_PROTOCOL_NOT_FOUND = FFERRTAG(0xF8, "P", "R", "O")
"Protocol not found"

comptime AVERROR_STREAM_NOT_FOUND = FFERRTAG(0xF8, "S", "T", "R")
"Stream not found"

comptime AVERROR_BUG2 = FFERRTAG("B", "U", "G", " ")
"""This is semantically identical to AVERROR_BUG it has been introduced in Libav 
after our AVERROR_BUG and with a modified value."""

comptime AVERROR_UNKNOWN = FFERRTAG("U", "N", "K", "N")
"Unknown error occurred"

comptime AVERROR_EXPERIMENTAL = -0x2BB2AFA8
"""Requested feature is flagged experimental. Set strict_std_compliance if you 
really want to use it."""

comptime AVERROR_INPUT_CHANGED = -0x636E6701
"""Input changed between calls. Reconfiguration is required. (can be OR-ed 
with AVERROR_OUTPUT_CHANGED)"""

comptime AVERROR_OUTPUT_CHANGED = -0x636E6702
"""Output changed between calls. Reconfiguration is required. (can be OR-ed 
with AVERROR_INPUT_CHANGED)"""

# HTTP and RTSP error
comptime AVERROR_HTTP_BAD_REQUEST = FFERRTAG(0xF8, "4", "0", "0")
"HTTP/1.1 400 Bad Request"

comptime AVERROR_HTTP_UNAUTHORIZED = FFERRTAG(0xF8, "4", "0", "1")
"HTTP/1.1 401 Unauthorized"

comptime AVERROR_HTTP_FORBIDDEN = FFERRTAG(0xF8, "4", "0", "3")
"HTTP/1.1 403 Forbidden"

comptime AVERROR_HTTP_NOT_FOUND = FFERRTAG(0xF8, "4", "0", "4")
"HTTP/1.1 404 Not Found"

comptime AVERROR_HTTP_TOO_MANY_REQUESTS = FFERRTAG(0xF8, "4", "2", "9")
"HTTP/1.1 429 Too Many Requests"

comptime AVERROR_HTTP_OTHER_4XX = FFERRTAG(0xF8, "4", "X", "X")
"HTTP/1.1 4XX Client Error, but not one of 40{0,1,3,4}"

comptime AVERROR_HTTP_SERVER_ERROR = FFERRTAG(0xF8, "5", "X", "X")
"HTTP/1.1 5XX Server Error reply"

comptime AV_ERROR_MAX_STRING_SIZE = 64
