"""https://www.ffmpeg.org/doxygen/8.0/avutil_8h_source.html"""

from sys.ffi import OwnedDLHandle, c_int, c_float, c_char, c_long_long
from os.env import getenv
import os
from ash_dynamics.ffmpeg.avutil.buffer import (
    av_buffer_alloc,
    av_buffer_allocz,
    av_buffer_create,
    av_buffer_default_free,
    av_buffer_ref,
    av_buffer_unref,
    av_buffer_is_writable,
    av_buffer_get_opaque,
    av_buffer_get_ref_count,
    av_buffer_make_writable,
    av_buffer_realloc,
    av_buffer_replace,
    av_buffer_pool_init,
    av_buffer_pool_init2,
    av_buffer_pool_uninit,
    av_buffer_pool_get,
    av_buffer_pool_buffer_get_opaque,
)
from ash_dynamics.ffmpeg.avutil.channel_layout import (
    av_channel_layout_copy,
    av_channel_name,
    av_channel_description,
    av_channel_from_string,
    av_channel_layout_custom_init,
    av_channel_layout_from_mask,
    av_channel_layout_from_string,
    av_channel_layout_default,
    av_channel_layout_standard,
    av_channel_layout_uninit,
    av_channel_layout_describe,
    av_channel_layout_channel_from_index,
    av_channel_layout_index_from_channel,
    av_channel_layout_index_from_string,
    av_channel_layout_channel_from_string,
    av_channel_layout_subset,
    av_channel_layout_check,
    av_channel_layout_compare,
    av_channel_layout_ambisonic_order,
    av_channel_layout_retype,
)
from ash_dynamics.ffmpeg.avutil.frame import (
    av_frame_alloc,
    av_frame_free,
    av_frame_ref,
    av_frame_replace,
    av_frame_clone,
    av_frame_unref,
    av_frame_move_ref,
    av_frame_get_buffer,
    av_frame_is_writable,
    av_frame_make_writable,
    av_frame_copy,
    av_frame_copy_props,
    av_frame_get_plane_buffer,
    av_frame_new_side_data,
    av_frame_new_side_data_from_buf,
    av_frame_get_side_data,
    av_frame_remove_side_data,
    av_frame_apply_cropping,
    av_frame_side_data_name,
    av_frame_side_data_desc,
    av_frame_side_data_free,
    av_frame_side_data_new,
    av_frame_side_data_add,
    av_frame_side_data_clone,
    av_frame_side_data_get_c,
    # av_frame_side_data_get,
    av_frame_side_data_remove,
    av_frame_side_data_remove_by_props,
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
    # Buffer functions
    var av_buffer_alloc: av_buffer_alloc.type
    var av_buffer_allocz: av_buffer_allocz.type
    var av_buffer_create: av_buffer_create.type
    var av_buffer_default_free: av_buffer_default_free.type
    var av_buffer_ref: av_buffer_ref.type
    var av_buffer_unref: av_buffer_unref.type
    var av_buffer_is_writable: av_buffer_is_writable.type
    var av_buffer_get_opaque: av_buffer_get_opaque.type
    var av_buffer_get_ref_count: av_buffer_get_ref_count.type
    var av_buffer_make_writable: av_buffer_make_writable.type
    var av_buffer_realloc: av_buffer_realloc.type
    var av_buffer_replace: av_buffer_replace.type
    var av_buffer_pool_init: av_buffer_pool_init.type
    var av_buffer_pool_init2: av_buffer_pool_init2.type
    var av_buffer_pool_uninit: av_buffer_pool_uninit.type
    var av_buffer_pool_get: av_buffer_pool_get.type
    var av_buffer_pool_buffer_get_opaque: av_buffer_pool_buffer_get_opaque.type

    # Channel layout functions
    var av_channel_layout_copy: av_channel_layout_copy.type
    var av_channel_name: av_channel_name.type
    var av_channel_description: av_channel_description.type
    var av_channel_from_string: av_channel_from_string.type
    var av_channel_layout_custom_init: av_channel_layout_custom_init.type
    var av_channel_layout_from_mask: av_channel_layout_from_mask.type
    var av_channel_layout_from_string: av_channel_layout_from_string.type
    var av_channel_layout_default: av_channel_layout_default.type
    var av_channel_layout_standard: av_channel_layout_standard.type
    var av_channel_layout_uninit: av_channel_layout_uninit.type
    var av_channel_layout_describe: av_channel_layout_describe.type
    var av_channel_layout_channel_from_index: av_channel_layout_channel_from_index.type
    var av_channel_layout_index_from_channel: av_channel_layout_index_from_channel.type
    var av_channel_layout_index_from_string: av_channel_layout_index_from_string.type
    var av_channel_layout_channel_from_string: av_channel_layout_channel_from_string.type
    var av_channel_layout_subset: av_channel_layout_subset.type
    var av_channel_layout_check: av_channel_layout_check.type
    var av_channel_layout_compare: av_channel_layout_compare.type
    var av_channel_layout_ambisonic_order: av_channel_layout_ambisonic_order.type
    var av_channel_layout_retype: av_channel_layout_retype.type

    # Frame functions
    var av_frame_alloc: av_frame_alloc.type
    var av_frame_free: av_frame_free.type
    var av_frame_ref: av_frame_ref.type
    var av_frame_replace: av_frame_replace.type
    var av_frame_clone: av_frame_clone.type
    var av_frame_unref: av_frame_unref.type
    var av_frame_move_ref: av_frame_move_ref.type
    var av_frame_get_buffer: av_frame_get_buffer.type
    var av_frame_is_writable: av_frame_is_writable.type
    var av_frame_make_writable: av_frame_make_writable.type
    var av_frame_copy: av_frame_copy.type
    var av_frame_copy_props: av_frame_copy_props.type
    var av_frame_get_plane_buffer: av_frame_get_plane_buffer.type
    var av_frame_new_side_data: av_frame_new_side_data.type
    var av_frame_new_side_data_from_buf: av_frame_new_side_data_from_buf.type
    var av_frame_get_side_data: av_frame_get_side_data.type
    var av_frame_remove_side_data: av_frame_remove_side_data.type
    var av_frame_apply_cropping: av_frame_apply_cropping.type
    var av_frame_side_data_name: av_frame_side_data_name.type
    var av_frame_side_data_desc: av_frame_side_data_desc.type
    var av_frame_side_data_free: av_frame_side_data_free.type
    var av_frame_side_data_new: av_frame_side_data_new.type
    var av_frame_side_data_add: av_frame_side_data_add.type
    var av_frame_side_data_clone: av_frame_side_data_clone.type
    # NOTE: There are av_frame_side_data_get_c and av_frame_side_data_get.
    # av_frame_side_data_get is a inline function for av_frame_side_data_get_c
    # that handles an issue of const casting.
    # var av_frame_side_data_get_c: av_frame_side_data_get_c.type
    var av_frame_side_data_get: av_frame_side_data_get_c.type
    var av_frame_side_data_remove: av_frame_side_data_remove.type
    var av_frame_side_data_remove_by_props: av_frame_side_data_remove_by_props.type

    # Mathematics functions
    var _av_compare_ts: av_compare_ts.type
    var av_rescale_rnd: av_rescale_rnd.type
    var _av_rescale_q_rnd: av_rescale_q_rnd.type

    # Error functions
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

        # Buffer functions
        self.av_buffer_alloc = av_buffer_alloc.load(self.lib)
        self.av_buffer_allocz = av_buffer_allocz.load(self.lib)
        self.av_buffer_create = av_buffer_create.load(self.lib)
        self.av_buffer_default_free = av_buffer_default_free.load(self.lib)
        self.av_buffer_ref = av_buffer_ref.load(self.lib)
        self.av_buffer_unref = av_buffer_unref.load(self.lib)
        self.av_buffer_is_writable = av_buffer_is_writable.load(self.lib)
        self.av_buffer_get_opaque = av_buffer_get_opaque.load(self.lib)
        self.av_buffer_get_ref_count = av_buffer_get_ref_count.load(self.lib)
        self.av_buffer_make_writable = av_buffer_make_writable.load(self.lib)
        self.av_buffer_realloc = av_buffer_realloc.load(self.lib)
        self.av_buffer_replace = av_buffer_replace.load(self.lib)
        self.av_buffer_pool_init = av_buffer_pool_init.load(self.lib)
        self.av_buffer_pool_init2 = av_buffer_pool_init2.load(self.lib)
        self.av_buffer_pool_uninit = av_buffer_pool_uninit.load(self.lib)
        self.av_buffer_pool_get = av_buffer_pool_get.load(self.lib)
        self.av_buffer_pool_buffer_get_opaque = (
            av_buffer_pool_buffer_get_opaque.load(self.lib)
        )

        # Channel layout functions
        self.av_channel_layout_copy = av_channel_layout_copy.load(self.lib)
        self.av_channel_name = av_channel_name.load(self.lib)
        self.av_channel_description = av_channel_description.load(self.lib)
        self.av_channel_from_string = av_channel_from_string.load(self.lib)
        self.av_channel_layout_custom_init = av_channel_layout_custom_init.load(
            self.lib
        )
        self.av_channel_layout_from_mask = av_channel_layout_from_mask.load(
            self.lib
        )
        self.av_channel_layout_from_string = av_channel_layout_from_string.load(
            self.lib
        )
        self.av_channel_layout_default = av_channel_layout_default.load(
            self.lib
        )
        self.av_channel_layout_standard = av_channel_layout_standard.load(
            self.lib
        )
        self.av_channel_layout_uninit = av_channel_layout_uninit.load(self.lib)
        self.av_channel_layout_describe = av_channel_layout_describe.load(
            self.lib
        )
        self.av_channel_layout_channel_from_index = (
            av_channel_layout_channel_from_index.load(self.lib)
        )
        self.av_channel_layout_index_from_channel = (
            av_channel_layout_index_from_channel.load(self.lib)
        )
        self.av_channel_layout_index_from_string = (
            av_channel_layout_index_from_string.load(self.lib)
        )
        self.av_channel_layout_channel_from_string = (
            av_channel_layout_channel_from_string.load(self.lib)
        )
        self.av_channel_layout_subset = av_channel_layout_subset.load(self.lib)
        self.av_channel_layout_check = av_channel_layout_check.load(self.lib)
        self.av_channel_layout_compare = av_channel_layout_compare.load(
            self.lib
        )
        self.av_channel_layout_ambisonic_order = (
            av_channel_layout_ambisonic_order.load(self.lib)
        )
        self.av_channel_layout_retype = av_channel_layout_retype.load(self.lib)

        # Frame functions
        self.av_frame_alloc = av_frame_alloc.load(self.lib)
        self.av_frame_free = av_frame_free.load(self.lib)
        self.av_frame_ref = av_frame_ref.load(self.lib)
        self.av_frame_replace = av_frame_replace.load(self.lib)
        self.av_frame_clone = av_frame_clone.load(self.lib)
        self.av_frame_unref = av_frame_unref.load(self.lib)
        self.av_frame_move_ref = av_frame_move_ref.load(self.lib)
        self.av_frame_get_buffer = av_frame_get_buffer.load(self.lib)
        self.av_frame_is_writable = av_frame_is_writable.load(self.lib)
        self.av_frame_make_writable = av_frame_make_writable.load(self.lib)
        self.av_frame_copy = av_frame_copy.load(self.lib)
        self.av_frame_copy_props = av_frame_copy_props.load(self.lib)
        self.av_frame_get_plane_buffer = av_frame_get_plane_buffer.load(
            self.lib
        )
        self.av_frame_new_side_data = av_frame_new_side_data.load(self.lib)
        self.av_frame_new_side_data_from_buf = (
            av_frame_new_side_data_from_buf.load(self.lib)
        )
        self.av_frame_get_side_data = av_frame_get_side_data.load(self.lib)
        self.av_frame_remove_side_data = av_frame_remove_side_data.load(
            self.lib
        )
        self.av_frame_apply_cropping = av_frame_apply_cropping.load(self.lib)
        self.av_frame_side_data_name = av_frame_side_data_name.load(self.lib)
        self.av_frame_side_data_desc = av_frame_side_data_desc.load(self.lib)
        self.av_frame_side_data_free = av_frame_side_data_free.load(self.lib)
        self.av_frame_side_data_new = av_frame_side_data_new.load(self.lib)
        self.av_frame_side_data_add = av_frame_side_data_add.load(self.lib)
        self.av_frame_side_data_clone = av_frame_side_data_clone.load(self.lib)
        self.av_frame_side_data_get = av_frame_side_data_get_c.load(self.lib)
        self.av_frame_side_data_remove = av_frame_side_data_remove.load(
            self.lib
        )
        self.av_frame_side_data_remove_by_props = (
            av_frame_side_data_remove_by_props.load(self.lib)
        )

        # Mathematics functions
        self._av_compare_ts = av_compare_ts.load(self.lib)
        self.av_rescale_rnd = av_rescale_rnd.load(self.lib)
        self._av_rescale_q_rnd = av_rescale_q_rnd.load(self.lib)

        # Error functions
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
