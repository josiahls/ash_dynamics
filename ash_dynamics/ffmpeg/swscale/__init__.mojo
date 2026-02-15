"""https://www.ffmpeg.org/doxygen/8.0/swscale_8h_source.html"""

from ffi import OwnedDLHandle, c_int, c_float, c_char, c_double
from memory import UnsafePointer
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
    SwsContext,
    SwsVector,
)
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.pixfmt import AVPixelFormat
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
    var _swscale_configuration: swscale_configuration.type
    var _swscale_license: swscale_license.type
    var _sws_get_class: sws_get_class.type

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
    var _sws_getCoefficients: sws_getCoefficients.type

    # Support check functions
    var sws_isSupportedInput: sws_isSupportedInput.type
    var sws_isSupportedOutput: sws_isSupportedOutput.type
    var sws_isSupportedEndiannessConversion: sws_isSupportedEndiannessConversion.type

    # Context functions
    var sws_init_context: sws_init_context.type
    var sws_freeContext: sws_freeContext.type
    var _sws_getContext: sws_getContext.type
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
    var _sws_allocVec: sws_allocVec.type
    var _sws_getGaussianVec: sws_getGaussianVec.type
    var sws_scaleVec: sws_scaleVec.type
    var sws_normalizeVec: sws_normalizeVec.type
    var sws_freeVec: sws_freeVec.type

    # Filter functions
    var _sws_getDefaultFilter: sws_getDefaultFilter.type
    var sws_freeFilter: sws_freeFilter.type

    # Cache functions
    var _sws_getCachedContext: sws_getCachedContext.type

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
        self._swscale_configuration = swscale_configuration.load(self.lib)
        self._swscale_license = swscale_license.load(self.lib)
        self._sws_get_class = sws_get_class.load(self.lib)

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
        self._sws_getCoefficients = sws_getCoefficients.load(self.lib)

        # Support check functions
        self.sws_isSupportedInput = sws_isSupportedInput.load(self.lib)
        self.sws_isSupportedOutput = sws_isSupportedOutput.load(self.lib)
        self.sws_isSupportedEndiannessConversion = (
            sws_isSupportedEndiannessConversion.load(self.lib)
        )

        # Context functions
        self.sws_init_context = sws_init_context.load(self.lib)
        self.sws_freeContext = sws_freeContext.load(self.lib)
        self._sws_getContext = sws_getContext.load(self.lib)
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
        self._sws_allocVec = sws_allocVec.load(self.lib)
        self._sws_getGaussianVec = sws_getGaussianVec.load(self.lib)
        self.sws_scaleVec = sws_scaleVec.load(self.lib)
        self.sws_normalizeVec = sws_normalizeVec.load(self.lib)
        self.sws_freeVec = sws_freeVec.load(self.lib)

        # Filter functions
        self._sws_getDefaultFilter = sws_getDefaultFilter.load(self.lib)
        self.sws_freeFilter = sws_freeFilter.load(self.lib)

        # Cache functions
        self._sws_getCachedContext = sws_getCachedContext.load(self.lib)

        # Palette conversion functions
        self.sws_convertPalette8ToPacked32 = sws_convertPalette8ToPacked32.load(
            self.lib
        )
        self.sws_convertPalette8ToPacked24 = sws_convertPalette8ToPacked24.load(
            self.lib
        )

    fn swscale_configuration(self) -> UnsafePointer[c_char, ImmutAnyOrigin]:
        return self._swscale_configuration().unsafe_origin_cast[
            origin_of(self.lib)
        ]()

    fn swscale_license(self) -> UnsafePointer[c_char, ImmutAnyOrigin]:
        return self._swscale_license().unsafe_origin_cast[origin_of(self.lib)]()

    fn sws_get_class(self) -> UnsafePointer[AVClass, ImmutAnyOrigin]:
        return self._sws_get_class().unsafe_origin_cast[origin_of(self.lib)]()

    fn sws_getCoefficients(
        self,
        colorspace: c_int,
    ) -> UnsafePointer[c_int, ImmutAnyOrigin]:
        return self._sws_getCoefficients(colorspace).unsafe_origin_cast[
            origin_of(self.lib)
        ]()

    fn sws_getContext(
        mut self,
        srcW: c_int,
        srcH: c_int,
        srcFormat: AVPixelFormat.ENUM_DTYPE,
        dstW: c_int,
        dstH: c_int,
        dstFormat: AVPixelFormat.ENUM_DTYPE,
        flags: c_int,
        srcFilter: UnsafePointer[SwsFilter, MutAnyOrigin],
        dstFilter: UnsafePointer[SwsFilter, MutAnyOrigin],
        param: UnsafePointer[c_double, ImmutAnyOrigin],
    ) -> UnsafePointer[SwsContext, MutAnyOrigin]:
        return self._sws_getContext(
            srcW,
            srcH,
            srcFormat,
            dstW,
            dstH,
            dstFormat,
            flags,
            srcFilter,
            dstFilter,
            param,
        ).unsafe_origin_cast[origin_of(self.lib)]()

    fn sws_allocVec(
        mut self,
        length: c_int,
    ) -> UnsafePointer[SwsVector, MutAnyOrigin]:
        return self._sws_allocVec(length).unsafe_origin_cast[
            origin_of(self.lib)
        ]()

    fn sws_getGaussianVec(
        self,
        variance: c_double,
        quality: c_double,
    ) -> UnsafePointer[SwsVector, ImmutAnyOrigin]:
        return self._sws_getGaussianVec(variance, quality).unsafe_origin_cast[
            origin_of(self.lib)
        ]()

    fn sws_getDefaultFilter(
        mut self,
        lumaGBlur: c_float,
        chromaGBlur: c_float,
        lumaSharpen: c_float,
        chromaSharpen: c_float,
        chromaHShift: c_float,
        chromaVShift: c_float,
        verbose: c_int,
    ) -> UnsafePointer[SwsFilter, MutAnyOrigin]:
        return self._sws_getDefaultFilter(
            lumaGBlur,
            chromaGBlur,
            lumaSharpen,
            chromaSharpen,
            chromaHShift,
            chromaVShift,
            verbose,
        ).unsafe_origin_cast[origin_of(self.lib)]()

    fn sws_getCachedContext(
        mut self,
        ctx: UnsafePointer[SwsContext, MutAnyOrigin],
        srcW: c_int,
        srcH: c_int,
        srcFormat: AVPixelFormat.ENUM_DTYPE,
        dstW: c_int,
        dstH: c_int,
        dstFormat: AVPixelFormat.ENUM_DTYPE,
        flags: c_int,
        srcFilter: UnsafePointer[SwsFilter, MutAnyOrigin],
        dstFilter: UnsafePointer[SwsFilter, MutAnyOrigin],
        param: UnsafePointer[c_double, ImmutAnyOrigin],
    ) -> UnsafePointer[SwsContext, ImmutAnyOrigin]:
        return self._sws_getCachedContext(
            ctx,
            srcW,
            srcH,
            srcFormat,
            dstW,
            dstH,
            dstFormat,
            flags,
            srcFilter,
            dstFilter,
            param,
        ).unsafe_origin_cast[origin_of(self.lib)]()
