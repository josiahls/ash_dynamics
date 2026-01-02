"""https://www.ffmpeg.org/doxygen/8.0/swresample_8h_source.html"""
from sys.ffi import OwnedDLHandle, c_int, c_float, c_char
from os.env import getenv
import os
from ash_dynamics.ffmpeg.swrsample.swrsample import (
    swr_get_class,
    swr_alloc,
    swr_init,
    swr_is_initialized,
    swr_alloc_set_opts2,
    swr_free,
    swr_close,
    swr_convert,
    swr_next_pts,
    swr_set_compensation,
    swr_set_channel_mapping,
    swr_build_matrix2,
)
from logger import Logger


comptime _logger = Logger()


@fieldwise_init
struct Swrsample:
    var lib: OwnedDLHandle

    # ===--------------------------------------------------===
    # ===                   Functions                      ===
    # ===--------------------------------------------------===
    var swr_get_class: swr_get_class.type
    var swr_alloc: swr_alloc.type
    var swr_init: swr_init.type
    var swr_is_initialized: swr_is_initialized.type
    var swr_alloc_set_opts2: swr_alloc_set_opts2.type
    var swr_free: swr_free.type
    var swr_close: swr_close.type
    var swr_convert: swr_convert.type
    var swr_next_pts: swr_next_pts.type
    var swr_set_compensation: swr_set_compensation.type
    var swr_set_channel_mapping: swr_set_channel_mapping.type
    var swr_build_matrix2: swr_build_matrix2.type

    fn __init__(out self) raises:
        var so_install_prefix = getenv("ASH_DYNAMICS_SO_INSTALL_PREFIX")
        if so_install_prefix == "":
            os.abort(
                "ASH_DYNAMICS_SO_INSTALL_PREFIX env var is not set. "
                "Expecting a path like:\n"
                "$PIXI_PROJECT_ROOT/third_party/ffmpeg/build/lib\n"
                "Where `libswresample.so` is expected to exist."
            )
        self.lib = OwnedDLHandle(
            "{}/libswresample.so".format(so_install_prefix)
        )
        self.swr_get_class = swr_get_class.load(self.lib)
        self.swr_alloc = swr_alloc.load(self.lib)
        self.swr_init = swr_init.load(self.lib)
        self.swr_is_initialized = swr_is_initialized.load(self.lib)
        self.swr_alloc_set_opts2 = swr_alloc_set_opts2.load(self.lib)
        self.swr_free = swr_free.load(self.lib)
        self.swr_close = swr_close.load(self.lib)
        self.swr_convert = swr_convert.load(self.lib)
        self.swr_next_pts = swr_next_pts.load(self.lib)
        self.swr_set_compensation = swr_set_compensation.load(self.lib)
        self.swr_set_channel_mapping = swr_set_channel_mapping.load(self.lib)
        self.swr_build_matrix2 = swr_build_matrix2.load(self.lib)
