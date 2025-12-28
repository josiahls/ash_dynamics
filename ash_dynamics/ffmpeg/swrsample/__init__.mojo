"""Audio resampling, sample format conversion and mixing library.

Interaction with lswr is done through SwrContext, which is
allocated with swr_alloc() or swr_alloc_set_opts2(). It is opaque, so all parameters
must be set with the @ref avoptions API.

The first thing you will need to do in order to use lswr is to allocate
SwrContext. This can be done with swr_alloc() or swr_alloc_set_opts2(). If you
are using the former, you must set options through the @ref avoptions API.
The latter function provides the same feature, but it allows you to set some
common options in the same statement.

For example the following code will setup conversion from planar float sample
format to interleaved signed 16-bit integer, downsampling from 48kHz to
44.1kHz and downmixing from 5.1 channels to stereo (using the default mixing
matrix). This is using the swr_alloc() function.
@code
SwrContext *swr = swr_alloc();
av_opt_set_chlayout(swr, "in_chlayout", &(AVChannelLayout)AV_CHANNEL_LAYOUT_5POINT1, 0);
av_opt_set_chlayout(swr, "out_chlayout", &(AVChannelLayout)AV_CHANNEL_LAYOUT_STEREO, 0);
av_opt_set_int(swr, "in_sample_rate",     48000,                0);
av_opt_set_int(swr, "out_sample_rate",    44100,                0);
av_opt_set_sample_fmt(swr, "in_sample_fmt",  AV_SAMPLE_FMT_FLTP, 0);
av_opt_set_sample_fmt(swr, "out_sample_fmt", AV_SAMPLE_FMT_S16,  0);
@endcode

The same job can be done using swr_alloc_set_opts2() as well:
@code
SwrContext *swr = NULL;
int ret = swr_alloc_set_opts2(&swr,         // we're allocating a new context
                    &(AVChannelLayout)AV_CHANNEL_LAYOUT_STEREO, // out_ch_layout
                    AV_SAMPLE_FMT_S16,    // out_sample_fmt
                    44100,                // out_sample_rate
                    &(AVChannelLayout)AV_CHANNEL_LAYOUT_5POINT1, // in_ch_layout
                    AV_SAMPLE_FMT_FLTP,   // in_sample_fmt
                    48000,                // in_sample_rate
                    0,                    // log_offset
                    NULL);                // log_ctx
@endcode

Once all values have been set, it must be initialized with swr_init(). If
you need to change the conversion parameters, you can change the parameters
using @ref avoptions, as described above in the first example; or by using
swr_alloc_set_opts2(), but with the first argument the allocated context.
You must then call swr_init() again.

The conversion itself is done by repeatedly calling swr_convert().
Note that the samples may get buffered in swr if you provide insufficient
output space or if sample rate conversion is done, which requires "future"
samples. Samples that do not require future input can be retrieved at any
time by using swr_convert() (in_count can be set to 0).
At the end of conversion the resampling buffer can be flushed by calling
swr_convert() with NULL in and 0 in_count.

The samples used in the conversion process can be managed with the libavutil
@ref lavu_sampmanip "samples manipulation" API, including av_samples_alloc()
function used in the following example.

The delay between input and output, can at any time be found by using
swr_get_delay().

The following code demonstrates the conversion loop assuming the parameters
from above and caller-defined functions get_input() and handle_output():
@code
uint8_t **input;
int in_samples;

while (get_input(&input, &in_samples)) {
    uint8_t *output;
    int out_samples = av_rescale_rnd(swr_get_delay(swr, 48000) +
                                    in_samples, 44100, 48000, AV_ROUND_UP);
    av_samples_alloc(&output, NULL, 2, out_samples,
                    AV_SAMPLE_FMT_S16, 0);
    out_samples = swr_convert(swr, &output, out_samples,
                                    input, in_samples);
    handle_output(output, out_samples);
    av_freep(&output);
}
@endcodeå

When the conversion is finished, the conversion
context and everything associated with it must be freed with swr_free().
A swr_close() function is also available, but it exists mainly for
compatibility with libavresample, and is not required to be called.

There will be no memory leak if the data is not completely flushed before
swr_free().
"""

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
