"https://www.ffmpeg.org/doxygen/8.0/avutil_8h.html"
from sys.ffi import (
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
@register_passable("trivial")
struct AVIAMFAnimationType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_ANIMATION_TYPE_STEP = Self(0)
    comptime AV_IAMF_ANIMATION_TYPE_LINEAR = Self(1)
    comptime AV_IAMF_ANIMATION_TYPE_BEZIER = Self(2)


@fieldwise_init
@register_passable("trivial")
struct AVIAMFMixGain(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFMixGain.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var subblock_duration: c_uint
    var animation_type: AVIAMFAnimationType.ENUM_DTYPE
    var start_point_value: AVRational
    var end_point_value: AVRational
    var control_point_value: AVRational
    var control_point_relative_time: AVRational


@fieldwise_init
@register_passable("trivial")
struct AVIAMFReconGain(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFReconGain.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var subblock_duration: c_uint
    var recon_gain: StaticTuple[StaticTuple[c_uchar, 12], 6]


@fieldwise_init
@register_passable("trivial")
struct AVIAMFParamDefinitionType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_PARAMETER_DEFINITION_MIX_GAIN = Self(0)
    comptime AV_IAMF_PARAMETER_DEFINITION_DEMIXING = Self(1)
    comptime AV_IAMF_PARAMETER_DEFINITION_RECON_GAIN = Self(2)


@fieldwise_init
@register_passable("trivial")
struct AVIAMFParamDefinition(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFParamDefinition.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
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
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]


comptime av_iamf_param_definition_alloc = ExternalFunction[
    "av_iamf_param_definition_alloc",
    fn (
        type: AVIAMFParamDefinitionType.ENUM_DTYPE,
        nb_subblocks: c_uint,
        size: UnsafePointer[c_size_t, MutOrigin.external],
    ) -> UnsafePointer[AVIAMFParamDefinition, MutOrigin.external],
]

# TODO: This is an inline function in the iamf.h file. Not sure if we
# need to implement this.
# comptime av_iamf_param_definition_get_subblock = ExternalFunction[
#     "av_iamf_param_definition_get_subblock",
#     fn(par: UnsafePointer[AVIAMFParamDefinition, ImmutOrigin.external], idx: c_uint) -> UnsafePointer[c_void, ImmutOrigin.external],
# ]


@fieldwise_init
@register_passable("trivial")
struct AVIAMFAmbisonicsMode(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_AMBISONICS_MODE_MONO = Self(0)
    comptime AV_IAMF_AMBISONICS_MODE_PROJECTION = Self(1)


comptime AV_IAMF_LAYER_FLAG_RECON_GAIN = c_uint(1 << 0)


@fieldwise_init
@register_passable("trivial")
struct AVIAMFLayer(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFLayer.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var ch_layout: AVChannelLayout
    var flags: c_uint
    var output_gain_flags: c_uint
    var output_gain: AVRational

    var ambisonics_mode: AVIAMFAmbisonicsMode.ENUM_DTYPE
    var demixing_matrix: UnsafePointer[AVRational, MutOrigin.external]


@fieldwise_init
@register_passable("trivial")
struct AVIAMFAudioElementType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_AUDIO_ELEMENT_TYPE_CHANNEL = Self(0)
    comptime AV_IAMF_AUDIO_ELEMENT_TYPE_SCENE = Self(1)


@fieldwise_init
@register_passable("trivial")
struct AVIAMFAudioElement(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFAudioElement.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var layers: UnsafePointer[
        UnsafePointer[AVIAMFLayer, MutOrigin.external], MutOrigin.external
    ]
    var nb_layers: c_uint
    var demixing_info: UnsafePointer[AVIAMFParamDefinition, MutOrigin.external]
    var recon_gain_info: UnsafePointer[
        AVIAMFParamDefinition, MutOrigin.external
    ]
    var audio_element_type: AVIAMFAudioElementType.ENUM_DTYPE

    var default_w: c_uint


comptime av_iamf_audio_element_get_class = ExternalFunction[
    "av_iamf_audio_element_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]

comptime av_iamf_audio_element_alloc = ExternalFunction[
    "av_iamf_audio_element_alloc",
    fn () -> UnsafePointer[AVIAMFAudioElement, MutOrigin.external],
]

comptime av_iamf_audio_element_add_layer = ExternalFunction[
    "av_iamf_audio_element_add_layer",
    fn (
        audio_element: UnsafePointer[AVIAMFAudioElement, MutOrigin.external]
    ) -> UnsafePointer[AVIAMFLayer, MutOrigin.external],
]

comptime av_iamf_audio_element_free = ExternalFunction[
    "av_iamf_audio_element_free",
    fn (
        audio_element: UnsafePointer[
            UnsafePointer[AVIAMFAudioElement, MutOrigin.external],
            MutOrigin.external,
        ]
    ),
]


@fieldwise_init
@register_passable("trivial")
struct AVIAMFHeadphonesMode(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_HEADPHONES_MODE_STEREO = Self(0)
    comptime AV_IAMF_HEADPHONES_MODE_BINAURAL = Self(1)


@fieldwise_init
@register_passable("trivial")
struct AVIAMFSubmixElement(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFSubmixElement.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var audio_element_id: c_uint
    var element_mix_config: UnsafePointer[
        AVIAMFParamDefinition, MutOrigin.external
    ]
    var default_mix_gain: AVRational
    var headphones_rendering_mode: AVIAMFHeadphonesMode.ENUM_DTYPE
    var annotations: UnsafePointer[AVDictionary, MutOrigin.external]


@fieldwise_init
@register_passable("trivial")
struct AVIAMFSubmixLayoutType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_SUBMIX_LAYOUT_TYPE_LOUDSPEAKERS = Self(2)
    comptime AV_IAMF_SUBMIX_LAYOUT_TYPE_BINAURAL = Self(3)


@fieldwise_init
@register_passable("trivial")
struct AVIAMFSubmixLayout(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFSubmixLayout.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var layout_type: AVIAMFSubmixLayoutType.ENUM_DTYPE
    var sound_system: AVChannelLayout
    var integrated_loudness: AVRational
    var digital_peak: AVRational
    var true_peak: AVRational
    var dialogue_anchored_loudness: AVRational
    var album_anchored_loudness: AVRational


@fieldwise_init
@register_passable("trivial")
struct AVIAMFSubmix(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFSubmix.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var elements: UnsafePointer[
        UnsafePointer[AVIAMFSubmixElement, MutOrigin.external],
        MutOrigin.external,
    ]
    var nb_elements: c_uint
    var layouts: UnsafePointer[
        UnsafePointer[AVIAMFSubmixLayout, MutOrigin.external],
        MutOrigin.external,
    ]
    var nb_layouts: c_uint
    var output_mix_config: UnsafePointer[
        AVIAMFParamDefinition, MutOrigin.external
    ]
    var default_mix_gain: AVRational


@fieldwise_init
@register_passable("trivial")
struct AVIAMFMixPresentation(Debug):
    "https://www.ffmpeg.org/doxygen/8.0/structAVIAMFMixPresentation.html"
    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var submixes: UnsafePointer[
        UnsafePointer[AVIAMFSubmix, MutOrigin.external], MutOrigin.external
    ]
    var nb_submixes: c_uint
    var annotations: UnsafePointer[AVDictionary, MutOrigin.external]


comptime av_iamf_mix_presentation_get_class = ExternalFunction[
    "av_iamf_mix_presentation_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]

comptime av_iamf_mix_presentation_alloc = ExternalFunction[
    "av_iamf_mix_presentation_alloc",
    fn () -> UnsafePointer[AVIAMFMixPresentation, MutOrigin.external],
]

comptime av_iamf_mix_presentation_add_submix = ExternalFunction[
    "av_iamf_mix_presentation_add_submix",
    fn (
        mix_presentation: UnsafePointer[
            AVIAMFMixPresentation, MutOrigin.external
        ]
    ) -> UnsafePointer[AVIAMFSubmix, MutOrigin.external],
]

comptime av_iamf_submix_add_element = ExternalFunction[
    "av_iamf_submix_add_element",
    fn (
        submix: UnsafePointer[AVIAMFSubmix, MutOrigin.external]
    ) -> UnsafePointer[AVIAMFSubmixElement, MutOrigin.external],
]

comptime av_iamf_submix_add_layout = ExternalFunction[
    "av_iamf_submix_add_layout",
    fn (
        submix: UnsafePointer[AVIAMFSubmix, MutOrigin.external]
    ) -> UnsafePointer[AVIAMFSubmixLayout, MutOrigin.external],
]

comptime av_iamf_mix_presentation_free = ExternalFunction[
    "av_iamf_mix_presentation_free",
    fn (
        mix_presentation: UnsafePointer[
            UnsafePointer[AVIAMFMixPresentation, MutOrigin.external],
            MutOrigin.external,
        ]
    ),
]
