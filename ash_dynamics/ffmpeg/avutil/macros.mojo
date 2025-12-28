from sys.ffi import c_int
from ash_dynamics.ffmpeg.avutil import avconfig


fn AV_NE[T: ImplicitlyCopyable](be: T, le: T) -> T:
    @parameter
    if avconfig.AV_HAVE_BIGENDIAN:
        return be
    return le


@always_inline
fn FFDIFFSIGN[T: Comparable](x: T, y: T) -> Bool:
    """Comparator.

    For two numerical expressions x and y, gives 1 if x > y, -1 if x < y, and 0
    if x == y. This is useful for instance in a qsort comparator callback.
    Furthermore, compilers are able to optimize this to branchless code, and
    there is no risk of overflow with signed types.
    As with many macros, this evaluates its argument multiple times, it thus
    must not have a side-effect.
    """
    return Bool(Int(x > y) - Int(x < y))


# define FFMAX(a,b) ((a) > (b) ? (a) : (b))
# define FFMAX3(a,b,c) FFMAX(FFMAX(a,b),c)
# define FFMIN(a,b) ((a) > (b) ? (b) : (a))
# define FFMIN3(a,b,c) FFMIN(FFMIN(a,b),c)

# define FFSWAP(type,a,b) do{type SWAP_tmp= b; b= a; a= SWAP_tmp;}while(0)
# define FF_ARRAY_ELEMS(a) (sizeof(a) / sizeof((a)[0]))


@always_inline
fn MKTAG(a: Int, b: Int, c: Int, d: Int) -> Int:
    """Note: Handles MKTAG and MKBETAG."""

    @parameter
    if avconfig.AV_HAVE_BIGENDIAN:
        return (d) | ((c) << 8) | ((b) << 16) | Int(UInt(a) << 24)

    return Int((UInt(a) | (UInt(b) << 8) | (UInt(c) << 16) | UInt(d) << 24))


# String manipulation macros

# define AV_STRINGIFY(s)         AV_TOSTRING(s)
# define AV_TOSTRING(s) #s

# define AV_GLUE(a, b) a ## b
# define AV_JOIN(a, b) AV_GLUE(a, b)


# define AV_PRAGMA(s) _Pragma(#s)

# define FFALIGN(x, a) (((x)+(a)-1)&~((a)-1))
