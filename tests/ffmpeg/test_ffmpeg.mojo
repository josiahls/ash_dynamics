from ash_dynamics.ffmpeg.avcodec.packet import AVPacket
from ash_dynamics.ffmpeg.avcodec.rational import AVRational
from ash_dynamics.ffmpeg.avcodec.buffer import AVBufferRef
from ash_dynamics.ffmpeg.avcodec.buffer_internal import AVBuffer
from sys.ffi import c_uchar
from ash_dynamics.ffmpeg.avcodec.packet import (
    AVPacketSideData,
    AVPacketSideDataType,
)


def main():
    var data = InlineArray[c_uchar, 4](uninitialized=True)
    data[0] = 104
    data[1] = 101
    data[2] = 108
    data[3] = 10

    var side_data_data = InlineArray[c_uchar, 4](uninitialized=True)
    side_data_data[0] = 104
    side_data_data[1] = 101
    side_data_data[2] = 108
    side_data_data[3] = 10

    var side_data = AVPacketSideData(
        data=side_data_data.unsafe_ptr().unsafe_origin_cast[
            MutOrigin.external
        ](),
        size=4,
        type=AVPacketSideDataType.AV_PKT_DATA_PALETTE._value,
    )

    fn free_ptr(
        opaque: OpaquePointer[MutOrigin.external],
        data: UnsafePointer[c_uchar, origin = MutOrigin.external],
    ):
        print("freeing pointer")

    var buffer = AVBuffer(
        data=data.unsafe_ptr().unsafe_origin_cast[MutOrigin.external](),
        size=4,
        refcount=1,
        free=free_ptr,
        opaque=OpaquePointer[MutOrigin.external](),
        flags=0,
        flags_internal=0,
    )
    var buffer_ref = AVBufferRef(
        buffer=UnsafePointer(to=buffer).unsafe_origin_cast[
            MutOrigin.external
        ](),
        data=buffer.data,
        size=buffer.size,
    )
    var packet = AVPacket(
        buf=UnsafePointer(to=buffer_ref).unsafe_origin_cast[
            MutOrigin.external
        ](),
        pts=1000,
        dts=1000,
        data=data.unsafe_ptr().unsafe_origin_cast[MutOrigin.external](),
        size=4,
        stream_index=0,
        flags=0,
        side_data=UnsafePointer(to=side_data).unsafe_origin_cast[
            MutOrigin.external
        ](),
        side_data_elems=1,
        duration=0,
        pos=-1,
        opaque=OpaquePointer[MutOrigin.external](),
        opaque_ref=UnsafePointer(to=buffer_ref).unsafe_origin_cast[
            MutOrigin.external
        ](),
        time_base=AVRational(num=1, den=1),
    )
