from ash_dynamics.ffmpeg.avutil.rational import AVRational
from sys.ffi import c_long_long
from ash_dynamics.primitives._clib import ExternalFunction


@fieldwise_init
@register_passable("trivial")
struct AVRounding:
    """Rounding methods."""

    comptime ENUM_DTYPE = c_int

    var value: Self.ENUM_DTYPE
    comptime AV_ROUND_ZERO = Self(0)
    "Round toward zero."
    comptime AV_ROUND_INF = Self(1)
    "Round away from zero."
    comptime AV_ROUND_DOWN = Self(2)
    "Round toward -infinity."
    comptime AV_ROUND_UP = Self(3)
    "Round toward +infinity."
    comptime AV_ROUND_NEAR_INF = Self(5)
    "Round to nearest and halfway cases away from zero."

    comptime AV_ROUND_PASS_MINMAX = Self(8192)
    """Flag telling rescaling functions to pass `INT64_MIN`/`MAX` through 
    unchanged, avoiding special cases for #AV_NOPTS_VALUE.

    Unlike other values of the enumeration AVRounding, this value is a bitmask 
    that must be used in conjunction with another value of the enumeration 
    through a bitwise OR, in order to set behavior for normal cases.

    @code{.c}
    av_rescale_rnd(3, 1, 2, AV_ROUND_UP | AV_ROUND_PASS_MINMAX);
    // Rescaling 3:
    //     Calculating 3 * 1 / 2
    //     3 / 2 is rounded up to 2
    //     => 2
    av_rescale_rnd(AV_NOPTS_VALUE, 1, 2, AV_ROUND_UP | AV_ROUND_PASS_MINMAX);
    // Rescaling AV_NOPTS_VALUE:
    //     AV_NOPTS_VALUE == INT64_MIN
    //     AV_NOPTS_VALUE is passed through
    //     => AV_NOPTS_VALUE
    @endcode
    """


comptime av_compare_ts = ExternalFunction[
    "av_compare_ts",
    fn (
        ts_a: c_long_long,
        tb_a: c_long_long,  # AVRational,
        ts_b: c_long_long,
        tb_b: c_long_long,  # AVRational,
    ) -> c_int,
]
"""Compare two timestamps each in its own time base.

@return One of the following values:
        - -1 if `ts_a` is before `ts_b`
        - 1 if `ts_a` is after `ts_b`
        - 0 if they represent the same position

@warning
The result of the function is undefined if one of the timestamps is outside
the `int64_t` range when represented in the other's timebase.
"""


comptime av_rescale_rnd = ExternalFunction[
    "av_rescale_rnd",
    fn (
        a: c_long_long,
        b: c_long_long,
        c: c_long_long,
        rnd: AVRounding.ENUM_DTYPE,
    ) -> c_long_long,
]
"""Rescale a 64-bit integer with specified rounding.

@param a 64-bit value to scale
@param b source integer
@param c destination integer
@param rnd rounding method
@return scaled value
"""


comptime av_rescale_q_rnd = ExternalFunction[
    "av_rescale_q_rnd",
    fn (
        a: c_long_long,
        bq: c_long_long,  # AVRational,
        cq: c_long_long,  # AVRational,
        rnd: AVRounding.ENUM_DTYPE,
    ) -> c_long_long,
]
"""Rescale a 64-bit integer by 2 rational numbers with specified rounding.

@param a 64-bit value to scale
@param bq source rational number
@param cq destination rational number
@param rnd rounding method
@return scaled value
"""
