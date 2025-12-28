"""Color conversion and scaling library."""

from sys.ffi import OwnedDLHandle, c_int, c_float, c_char
from os.env import getenv
import os
from ash_dynamics.ffmpeg.swscale.swscale import (
    sws_getContext,
    sws_scale,
    SwsFilter,
)
from logger import Logger


comptime _logger = Logger()


@fieldwise_init
struct Swscale:
    var lib: OwnedDLHandle

    # ===--------------------------------------------------===
    # ===                   Functions                      ===
    # ===--------------------------------------------------===
    var sws_getContext: sws_getContext.type
    "Shadows sws_getContext."
    var sws_scale: sws_scale.type
    "Shadows sws_scale."

    fn __init__(out self) raises:
        var so_install_prefix = getenv("ASH_DYNAMICS_SO_INSTALL_PREFIX")
        if so_install_prefix == "":
            os.abort(
                "ASH_DYNAMICS_SO_INSTALL_PREFIX env var is not set. "
                "Expecting a path like:\n"
                "$PIXI_PROJECT_ROOT/third_party/ffmpeg/build/lib\n"
                "Where `libswscale.so` is expected to exist."
            )
        self.lib = OwnedDLHandle("{}/libswscale.so".format(so_install_prefix))
        self.sws_getContext = sws_getContext.load(self.lib)
        self.sws_scale = sws_scale.load(self.lib)
