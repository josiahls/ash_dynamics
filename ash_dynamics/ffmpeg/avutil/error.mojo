"https://www.ffmpeg.org/doxygen/8.0/error_8h.html"
from ffi import c_int
from ash_dynamics.ffmpeg.avutil import avconfig
from ash_dynamics.ffmpeg.avutil.macros import MKTAG
from utils import Variant
from ash_dynamics.primitives._clib import ExternalFunction


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
    return -MKTAG(a.get_int(), b.get_int(), c.get_int(), d.get_int())


comptime AVERROR_BSF_NOT_FOUND = FFERRTAG(0xF8, "B", "S", "F")

comptime AVERROR_BUG = FFERRTAG("B", "U", "G", "!")

comptime AVERROR_BUFFER_TOO_SMALL = FFERRTAG("B", "U", "F", "S")

comptime AVERROR_DECODER_NOT_FOUND = FFERRTAG(0xF8, "D", "E", "C")

comptime AVERROR_DEMUXER_NOT_FOUND = FFERRTAG(0xF8, "D", "E", "M")

comptime AVERROR_ENCODER_NOT_FOUND = FFERRTAG(0xF8, "E", "N", "C")

comptime AVERROR_EOF = FFERRTAG("E", "O", "F", " ")

comptime AVERROR_EXIT = FFERRTAG("E", "X", "I", "T")

comptime AVERROR_EXTERNAL = FFERRTAG("E", "X", "T", " ")

comptime AVERROR_FILTER_NOT_FOUND = FFERRTAG(0xF8, "F", "I", "L")

comptime AVERROR_INVALIDDATA = FFERRTAG("I", "N", "D", "A")

comptime AVERROR_MUXER_NOT_FOUND = FFERRTAG(0xF8, "M", "U", "X")

comptime AVERROR_OPTION_NOT_FOUND = FFERRTAG(0xF8, "O", "P", "T")

comptime AVERROR_PATCHWELCOME = FFERRTAG("P", "A", "W", "E")

comptime AVERROR_PROTOCOL_NOT_FOUND = FFERRTAG(0xF8, "P", "R", "O")

comptime AVERROR_STREAM_NOT_FOUND = FFERRTAG(0xF8, "S", "T", "R")

comptime AVERROR_BUG2 = FFERRTAG("B", "U", "G", " ")

comptime AVERROR_UNKNOWN = FFERRTAG("U", "N", "K", "N")

comptime AVERROR_EXPERIMENTAL = -0x2BB2AFA8

comptime AVERROR_INPUT_CHANGED = -0x636E6701

comptime AVERROR_OUTPUT_CHANGED = -0x636E6702

# HTTP and RTSP error
comptime AVERROR_HTTP_BAD_REQUEST = FFERRTAG(0xF8, "4", "0", "0")

comptime AVERROR_HTTP_UNAUTHORIZED = FFERRTAG(0xF8, "4", "0", "1")

comptime AVERROR_HTTP_FORBIDDEN = FFERRTAG(0xF8, "4", "0", "3")

comptime AVERROR_HTTP_NOT_FOUND = FFERRTAG(0xF8, "4", "0", "4")

comptime AVERROR_HTTP_TOO_MANY_REQUESTS = FFERRTAG(0xF8, "4", "2", "9")

comptime AVERROR_HTTP_OTHER_4XX = FFERRTAG(0xF8, "4", "X", "X")

comptime AVERROR_HTTP_SERVER_ERROR = FFERRTAG(0xF8, "5", "X", "X")

comptime AV_ERROR_MAX_STRING_SIZE = 64


comptime av_strerror = ExternalFunction[
    "av_strerror",
    fn(
        err: c_int,
        errbuf: UnsafePointer[c_char, MutAnyOrigin],
        errbuf_size: c_int,
    ) -> c_int,
]
