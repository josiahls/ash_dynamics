"https://www.ffmpeg.org/doxygen/8.0/mathematics_8h.html"
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ffi import c_long_long
from ash_dynamics.primitives._clib import ExternalFunction
from ash_dynamics.primitives._clib import Debug


@fieldwise_init
struct AVRounding(Debug, TrivialRegisterType):
    comptime ENUM_DTYPE = c_int

    var value: Self.ENUM_DTYPE
    comptime AV_ROUND_ZERO = Self(0)
    comptime AV_ROUND_INF = Self(1)
    comptime AV_ROUND_DOWN = Self(2)
    comptime AV_ROUND_UP = Self(3)
    comptime AV_ROUND_NEAR_INF = Self(5)

    comptime AV_ROUND_PASS_MINMAX = Self(8192)


comptime av_compare_ts = ExternalFunction[
    "av_compare_ts",
    fn(
        ts_a: c_long_long,
        tb_a: c_long_long,  # AVRational,
        ts_b: c_long_long,
        tb_b: c_long_long,  # AVRational,
    ) -> c_int,
]


comptime av_rescale_rnd = ExternalFunction[
    "av_rescale_rnd",
    fn(
        a: c_long_long,
        b: c_long_long,
        c: c_long_long,
        rnd: AVRounding.ENUM_DTYPE,
    ) -> c_long_long,
]


comptime av_rescale_q_rnd = ExternalFunction[
    "av_rescale_q_rnd",
    fn(
        a: c_long_long,
        bq: c_long_long,  # AVRational,
        cq: c_long_long,  # AVRational,
        rnd: AVRounding.ENUM_DTYPE,
    ) -> c_long_long,
]
