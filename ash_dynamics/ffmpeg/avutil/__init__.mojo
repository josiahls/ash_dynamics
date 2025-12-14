from sys.ffi import c_int


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVPictureType:
    comptime ENUM_DTYPE = c_int

    var _value: Self.ENUM_DTYPE

    comptime AV_PICTURE_TYPE_NONE = Self(0)
    "Undefined"
    comptime AV_PICTURE_TYPE_I = Self(1)
    "Intra"
    comptime AV_PICTURE_TYPE_P = Self(2)
    "Predicted"
    comptime AV_PICTURE_TYPE_B = Self(3)
    "Bi-dir predicted"
    comptime AV_PICTURE_TYPE_S = Self(4)
    "S(GMC)-VOP MPEG-4"
    comptime AV_PICTURE_TYPE_SI = Self(5)
    "Switching Intra"
    comptime AV_PICTURE_TYPE_SP = Self(6)
    "Switching Predicted"
    comptime AV_PICTURE_TYPE_BI = Self(7)
    "BI type"
