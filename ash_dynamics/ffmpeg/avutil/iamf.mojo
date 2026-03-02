"https://www.ffmpeg.org/doxygen/8.0/avutil_8h.html"
from ffi import (
    c_int,
    c_char,
    c_long_long,
    c_uchar,
    c_ulong,
    c_ulong_long,
    c_uint,
    c_size_t,
)
import os
from utils import StaticTuple
from ash_dynamics.ffmpeg.avutil.log import AVClass
from ash_dynamics.ffmpeg.avutil.dict import AVDictionary
from ash_dynamics.primitives._clib import C_Union, ExternalFunction, Debug
from ash_dynamics.ffmpeg.avutil.rational import AVRational
from ash_dynamics.ffmpeg.avutil.channel_layout import AVChannelLayout


@fieldwise_init
struct AVIAMFAnimationType(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_ANIMATION_TYPE_STEP = Self(0)
    comptime AV_IAMF_ANIMATION_TYPE_LINEAR = Self(1)
    comptime AV_IAMF_ANIMATION_TYPE_BEZIER = Self(2)


@fieldwise_init
struct AVIAMFMixGain(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFMixGain.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var subblock_duration: c_uint
    var animation_type: AVIAMFAnimationType.ENUM_DTYPE
    var start_point_value: AVRational
    var end_point_value: AVRational
    var control_point_value: AVRational
    var control_point_relative_time: AVRational


@fieldwise_init
struct AVIAMFReconGain(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFReconGain.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var subblock_duration: c_uint
    var recon_gain: StaticTuple[StaticTuple[c_uchar, 12], 6]


@fieldwise_init
struct AVIAMFParamDefinitionType(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_PARAMETER_DEFINITION_MIX_GAIN = Self(0)
    comptime AV_IAMF_PARAMETER_DEFINITION_DEMIXING = Self(1)
    comptime AV_IAMF_PARAMETER_DEFINITION_RECON_GAIN = Self(2)


@fieldwise_init
struct AVIAMFParamDefinition(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFParamDefinition.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var subblocks_offset: c_size_t
    var subblock_size: c_size_t
    var nb_subblocks: c_uint
    var type: AVIAMFParamDefinitionType.ENUM_DTYPE
    var parameter_id: c_uint
    var parameter_rate: c_uint
    var duration: c_uint
    var constant_subblock_duration: c_uint


comptime av_iamf_param_definition_get_class = ExternalFunction[
    "av_iamf_param_definition_get_class",
    fn() -> UnsafePointer[AVClass, ImmutAnyOrigin],
]


comptime av_iamf_param_definition_alloc = ExternalFunction[
    "av_iamf_param_definition_alloc",
    fn(
        type: AVIAMFParamDefinitionType.ENUM_DTYPE,
        nb_subblocks: c_uint,
        size: UnsafePointer[c_size_t, MutAnyOrigin],
    ) -> UnsafePointer[AVIAMFParamDefinition, MutAnyOrigin],
]

# TODO: This is an inline function in the iamf.h file. Not sure if we
# need to implement this.
# comptime av_iamf_param_definition_get_subblock = ExternalFunction[
#     "av_iamf_param_definition_get_subblock",
#     fn(par: UnsafePointer[AVIAMFParamDefinition, ImmutAnyOrigin], idx: c_uint) -> UnsafePointer[c_void, ImmutAnyOrigin],
# ]


@fieldwise_init
struct AVIAMFAmbisonicsMode(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_AMBISONICS_MODE_MONO = Self(0)
    comptime AV_IAMF_AMBISONICS_MODE_PROJECTION = Self(1)


comptime AV_IAMF_LAYER_FLAG_RECON_GAIN = c_uint(1 << 0)


@fieldwise_init
struct AVIAMFLayer(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFLayer.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var ch_layout: AVChannelLayout
    var flags: c_uint
    var output_gain_flags: c_uint
    var output_gain: AVRational

    var ambisonics_mode: AVIAMFAmbisonicsMode.ENUM_DTYPE
    var demixing_matrix: UnsafePointer[AVRational, MutAnyOrigin]


@fieldwise_init
struct AVIAMFAudioElementType(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_AUDIO_ELEMENT_TYPE_CHANNEL = Self(0)
    comptime AV_IAMF_AUDIO_ELEMENT_TYPE_SCENE = Self(1)


@fieldwise_init
struct AVIAMFAudioElement(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFAudioElement.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var layers: UnsafePointer[
        UnsafePointer[AVIAMFLayer, MutAnyOrigin], MutAnyOrigin
    ]
    var nb_layers: c_uint
    var demixing_info: UnsafePointer[AVIAMFParamDefinition, MutAnyOrigin]
    var recon_gain_info: UnsafePointer[AVIAMFParamDefinition, MutAnyOrigin]
    var audio_element_type: AVIAMFAudioElementType.ENUM_DTYPE

    var default_w: c_uint


comptime av_iamf_audio_element_get_class = ExternalFunction[
    "av_iamf_audio_element_get_class",
    fn() -> UnsafePointer[AVClass, ImmutAnyOrigin],
]

comptime av_iamf_audio_element_alloc = ExternalFunction[
    "av_iamf_audio_element_alloc",
    fn() -> UnsafePointer[AVIAMFAudioElement, MutAnyOrigin],
]

comptime av_iamf_audio_element_add_layer = ExternalFunction[
    "av_iamf_audio_element_add_layer",
    fn(
        audio_element: UnsafePointer[AVIAMFAudioElement, MutAnyOrigin]
    ) -> UnsafePointer[AVIAMFLayer, MutAnyOrigin],
]

comptime av_iamf_audio_element_free = ExternalFunction[
    "av_iamf_audio_element_free",
    fn(
        audio_element: UnsafePointer[
            UnsafePointer[AVIAMFAudioElement, MutAnyOrigin],
            MutAnyOrigin,
        ]
    ),
]


@fieldwise_init
struct AVIAMFHeadphonesMode(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_HEADPHONES_MODE_STEREO = Self(0)
    comptime AV_IAMF_HEADPHONES_MODE_BINAURAL = Self(1)


@fieldwise_init
struct AVIAMFSubmixElement(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFSubmixElement.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var audio_element_id: c_uint
    var element_mix_config: UnsafePointer[AVIAMFParamDefinition, MutAnyOrigin]
    var default_mix_gain: AVRational
    var headphones_rendering_mode: AVIAMFHeadphonesMode.ENUM_DTYPE
    var annotations: UnsafePointer[AVDictionary, MutAnyOrigin]


@fieldwise_init
struct AVIAMFSubmixLayoutType(Movable, Writable):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_SUBMIX_LAYOUT_TYPE_LOUDSPEAKERS = Self(2)
    comptime AV_IAMF_SUBMIX_LAYOUT_TYPE_BINAURAL = Self(3)


@fieldwise_init
struct AVIAMFSubmixLayout(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFSubmixLayout.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var layout_type: AVIAMFSubmixLayoutType.ENUM_DTYPE
    var sound_system: AVChannelLayout
    var integrated_loudness: AVRational
    var digital_peak: AVRational
    var true_peak: AVRational
    var dialogue_anchored_loudness: AVRational
    var album_anchored_loudness: AVRational


@fieldwise_init
struct AVIAMFSubmix(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFSubmix.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var elements: UnsafePointer[
        UnsafePointer[AVIAMFSubmixElement, MutAnyOrigin],
        MutAnyOrigin,
    ]
    var nb_elements: c_uint
    var layouts: UnsafePointer[
        UnsafePointer[AVIAMFSubmixLayout, MutAnyOrigin],
        MutAnyOrigin,
    ]
    var nb_layouts: c_uint
    var output_mix_config: UnsafePointer[AVIAMFParamDefinition, MutAnyOrigin]
    var default_mix_gain: AVRational


@fieldwise_init
struct AVIAMFMixPresentation(Movable, Writable):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFMixPresentation.html"
    var av_class: UnsafePointer[AVClass, ImmutAnyOrigin]
    var submixes: UnsafePointer[
        UnsafePointer[AVIAMFSubmix, MutAnyOrigin], MutAnyOrigin
    ]
    var nb_submixes: c_uint
    var annotations: UnsafePointer[AVDictionary, MutAnyOrigin]


comptime av_iamf_mix_presentation_get_class = ExternalFunction[
    "av_iamf_mix_presentation_get_class",
    fn() -> UnsafePointer[AVClass, ImmutAnyOrigin],
]

comptime av_iamf_mix_presentation_alloc = ExternalFunction[
    "av_iamf_mix_presentation_alloc",
    fn() -> UnsafePointer[AVIAMFMixPresentation, MutAnyOrigin],
]

comptime av_iamf_mix_presentation_add_submix = ExternalFunction[
    "av_iamf_mix_presentation_add_submix",
    fn(
        mix_presentation: UnsafePointer[AVIAMFMixPresentation, MutAnyOrigin]
    ) -> UnsafePointer[AVIAMFSubmix, MutAnyOrigin],
]

comptime av_iamf_submix_add_element = ExternalFunction[
    "av_iamf_submix_add_element",
    fn(
        submix: UnsafePointer[AVIAMFSubmix, MutAnyOrigin]
    ) -> UnsafePointer[AVIAMFSubmixElement, MutAnyOrigin],
]

comptime av_iamf_submix_add_layout = ExternalFunction[
    "av_iamf_submix_add_layout",
    fn(
        submix: UnsafePointer[AVIAMFSubmix, MutAnyOrigin]
    ) -> UnsafePointer[AVIAMFSubmixLayout, MutAnyOrigin],
]

comptime av_iamf_mix_presentation_free = ExternalFunction[
    "av_iamf_mix_presentation_free",
    fn(
        mix_presentation: UnsafePointer[
            UnsafePointer[AVIAMFMixPresentation, MutAnyOrigin],
            MutAnyOrigin,
        ]
    ),
]
