"""https://www.ffmpeg.org/doxygen/8.0/swscale_8h_source.html"""

from ffi import OwnedDLHandle, c_int, c_float, c_char
from os.env import getenv
import os
from ash_dynamics.ffmpeg.swscale.swscale import (
    swscale_version,
    swscale_configuration,
    swscale_license,
    sws_get_class,
    sws_test_format,
    sws_test_colorspace,
    sws_test_primaries,
    sws_test_transfer,
    sws_test_frame,
    sws_frame_setup,
    sws_is_noop,
    sws_scale_frame,
    sws_getCoefficients,
    sws_isSupportedInput,
    sws_isSupportedOutput,
    sws_isSupportedEndiannessConversion,
    sws_init_context,
    sws_freeContext,
    sws_getContext,
    sws_scale,
    sws_frame_start,
    sws_frame_end,
    sws_send_slice,
    sws_receive_slice,
    sws_receive_slice_alignment,
    sws_setColorspaceDetails,
    sws_allocVec,
    sws_getGaussianVec,
    sws_scaleVec,
    sws_normalizeVec,
    sws_freeVec,
    sws_getDefaultFilter,
    sws_freeFilter,
    sws_getCachedContext,
    sws_convertPalette8ToPacked32,
    sws_convertPalette8ToPacked24,
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
    # Version/info functions
    var swscale_version: swscale_version.type
    var swscale_configuration: swscale_configuration.type
    var swscale_license: swscale_license.type
    var sws_get_class: sws_get_class.type

    # Test functions
    var sws_test_format: sws_test_format.type
    var sws_test_colorspace: sws_test_colorspace.type
    var sws_test_primaries: sws_test_primaries.type
    var sws_test_transfer: sws_test_transfer.type
    var sws_test_frame: sws_test_frame.type
    var sws_frame_setup: sws_frame_setup.type
    var sws_is_noop: sws_is_noop.type

    # Scale functions
    var sws_scale_frame: sws_scale_frame.type
    var sws_getCoefficients: sws_getCoefficients.type

    # Support check functions
    var sws_isSupportedInput: sws_isSupportedInput.type
    var sws_isSupportedOutput: sws_isSupportedOutput.type
    var sws_isSupportedEndiannessConversion: sws_isSupportedEndiannessConversion.type

    # Context functions
    var sws_init_context: sws_init_context.type
    var sws_freeContext: sws_freeContext.type
    var sws_getContext: sws_getContext.type
    var sws_scale: sws_scale.type

    # Frame functions
    var sws_frame_start: sws_frame_start.type
    var sws_frame_end: sws_frame_end.type

    # Slice functions
    var sws_send_slice: sws_send_slice.type
    var sws_receive_slice: sws_receive_slice.type
    var sws_receive_slice_alignment: sws_receive_slice_alignment.type

    # Colorspace functions
    var sws_setColorspaceDetails: sws_setColorspaceDetails.type

    # Vector functions
    var sws_allocVec: sws_allocVec.type
    var sws_getGaussianVec: sws_getGaussianVec.type
    var sws_scaleVec: sws_scaleVec.type
    var sws_normalizeVec: sws_normalizeVec.type
    var sws_freeVec: sws_freeVec.type

    # Filter functions
    var sws_getDefaultFilter: sws_getDefaultFilter.type
    var sws_freeFilter: sws_freeFilter.type

    # Cache functions
    var sws_getCachedContext: sws_getCachedContext.type

    # Palette conversion functions
    var sws_convertPalette8ToPacked32: sws_convertPalette8ToPacked32.type
    var sws_convertPalette8ToPacked24: sws_convertPalette8ToPacked24.type

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

        # Version/info functions
        self.swscale_version = swscale_version.load(self.lib)
        self.swscale_configuration = swscale_configuration.load(self.lib)
        self.swscale_license = swscale_license.load(self.lib)
        self.sws_get_class = sws_get_class.load(self.lib)

        # Test functions
        self.sws_test_format = sws_test_format.load(self.lib)
        self.sws_test_colorspace = sws_test_colorspace.load(self.lib)
        self.sws_test_primaries = sws_test_primaries.load(self.lib)
        self.sws_test_transfer = sws_test_transfer.load(self.lib)
        self.sws_test_frame = sws_test_frame.load(self.lib)
        self.sws_frame_setup = sws_frame_setup.load(self.lib)
        self.sws_is_noop = sws_is_noop.load(self.lib)

        # Scale functions
        self.sws_scale_frame = sws_scale_frame.load(self.lib)
        self.sws_getCoefficients = sws_getCoefficients.load(self.lib)

        # Support check functions
        self.sws_isSupportedInput = sws_isSupportedInput.load(self.lib)
        self.sws_isSupportedOutput = sws_isSupportedOutput.load(self.lib)
        self.sws_isSupportedEndiannessConversion = (
            sws_isSupportedEndiannessConversion.load(self.lib)
        )

        # Context functions
        self.sws_init_context = sws_init_context.load(self.lib)
        self.sws_freeContext = sws_freeContext.load(self.lib)
        self.sws_getContext = sws_getContext.load(self.lib)
        self.sws_scale = sws_scale.load(self.lib)

        # Frame functions
        self.sws_frame_start = sws_frame_start.load(self.lib)
        self.sws_frame_end = sws_frame_end.load(self.lib)

        # Slice functions
        self.sws_send_slice = sws_send_slice.load(self.lib)
        self.sws_receive_slice = sws_receive_slice.load(self.lib)
        self.sws_receive_slice_alignment = sws_receive_slice_alignment.load(
            self.lib
        )

        # Colorspace functions
        self.sws_setColorspaceDetails = sws_setColorspaceDetails.load(self.lib)

        # Vector functions
        self.sws_allocVec = sws_allocVec.load(self.lib)
        self.sws_getGaussianVec = sws_getGaussianVec.load(self.lib)
        self.sws_scaleVec = sws_scaleVec.load(self.lib)
        self.sws_normalizeVec = sws_normalizeVec.load(self.lib)
        self.sws_freeVec = sws_freeVec.load(self.lib)

        # Filter functions
        self.sws_getDefaultFilter = sws_getDefaultFilter.load(self.lib)
        self.sws_freeFilter = sws_freeFilter.load(self.lib)

        # Cache functions
        self.sws_getCachedContext = sws_getCachedContext.load(self.lib)

        # Palette conversion functions
        self.sws_convertPalette8ToPacked32 = sws_convertPalette8ToPacked32.load(
            self.lib
        )
        self.sws_convertPalette8ToPacked24 = sws_convertPalette8ToPacked24.load(
            self.lib
        )
