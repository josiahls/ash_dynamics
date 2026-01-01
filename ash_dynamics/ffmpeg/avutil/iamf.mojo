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
    """Mix Gain Parameter Data as defined in section 3.8.1 of IAMF.

    @note This struct's size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var subblock_duration: c_uint
    """Duration for the given subblock, in units of
    1 / @ref AVIAMFParamDefinition.parameter_rate "parameter_rate".
    It must not be 0.
    """
    var animation_type: AVIAMFAnimationType.ENUM_DTYPE
    """The type of animation applied to the parameter values."""
    var start_point_value: AVRational
    """Parameter value that is applied at the start of the subblock.
    Applies to all defined Animation Types.

    Valid range of values is -128.0 to 128.0
    """
    var end_point_value: AVRational
    """Parameter value that is applied at the end of the subblock.
    Applies only to AV_IAMF_ANIMATION_TYPE_LINEAR and
    AV_IAMF_ANIMATION_TYPE_BEZIER Animation Types.

    Valid range of values is -128.0 to 128.0
    """
    var control_point_value: AVRational
    """Parameter value of the middle control point of a quadratic Bezier
    curve, i.e., its y-axis value.
    Applies only to AV_IAMF_ANIMATION_TYPE_BEZIER Animation Type.

    Valid range of values is -128.0 to 128.0
    """
    var control_point_relative_time: AVRational
    """Parameter value of the time of the middle control point of a
    quadratic Bezier curve, i.e., its x-axis value.
    Applies only to AV_IAMF_ANIMATION_TYPE_BEZIER Animation Type.

    Valid range of values is 0.0 to 1.0
    """


@fieldwise_init
@register_passable("trivial")
struct AVIAMFReconGain(Debug):
    """Recon Gain Parameter Data as defined in section 3.8.3 of IAMF.

    @note This struct's size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var subblock_duration: c_uint
    """Duration for the given subblock, in units of
    1 / @ref AVIAMFParamDefinition.parameter_rate "parameter_rate".

    It must not be 0.
    """
    var recon_gain: StaticTuple[StaticTuple[c_uchar, 12], 6]
    """Array of gain values to be applied to each channel for each layer
    defined in the Audio Element referencing the parent Parameter Definition.
    Values for layers where the AV_IAMF_LAYER_FLAG_RECON_GAIN flag is not set
    are undefined.

    Channel order is: FL, C, FR, SL, SR, TFL, TFR, BL, BR, TBL, TBR, LFE
    """


@fieldwise_init
@register_passable("trivial")
struct AVIAMFParamDefinitionType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_PARAMETER_DEFINITION_MIX_GAIN = Self(0)
    """Subblocks are of struct type AVIAMFMixGain"""
    comptime AV_IAMF_PARAMETER_DEFINITION_DEMIXING = Self(1)
    """Subblocks are of struct type AVIAMFDemixingInfo"""
    comptime AV_IAMF_PARAMETER_DEFINITION_RECON_GAIN = Self(2)
    """Subblocks are of struct type AVIAMFReconGain"""


@fieldwise_init
@register_passable("trivial")
struct AVIAMFParamDefinition(Debug):
    """Parameters as defined in section 3.6.1 of IAMF.

    The struct is allocated by av_iamf_param_definition_alloc() along with an
    array of subblocks, its type depending on the value of type.
    This array is placed subblocks_offset bytes after the start of this struct.

    @note This struct's size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var subblocks_offset: c_size_t
    """Offset in bytes from the start of this struct, at which the subblocks
    array is located."""
    var subblock_size: c_size_t
    """Size in bytes of each element in the subblocks array."""
    var nb_subblocks: c_uint
    """Number of subblocks in the array."""
    var type: AVIAMFParamDefinitionType.ENUM_DTYPE
    """Parameters type. Determines the type of the subblock elements."""
    var parameter_id: c_uint
    """Identifier for the parameter substream."""
    var parameter_rate: c_uint
    """Sample rate for the parameter substream. It must not be 0."""
    var duration: c_uint
    """The accumulated duration of all blocks in this parameter definition,
    in units of 1 / @ref parameter_rate "parameter_rate".
    
    May be 0, in which case all duration values should be specified in
    another parameter definition referencing the same parameter_id.
    """
    var constant_subblock_duration: c_uint
    """The duration of every subblock in the case where all subblocks, with
    the optional exception of the last subblock, have equal durations.

    Must be 0 if subblocks have different durations.
    """


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
"""Allocates memory for AVIAMFParamDefinition, plus an array of nb_subblocks
amount of subblocks of the given type and initializes the variables. Can be
freed with a normal av_free() call.

@param size if non-NULL, the size in bytes of the resulting data array is written here.
"""

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
    """A layer defining a Channel Layout in the Audio Element.

    When @ref AVIAMFAudioElement.audio_element_type "the parent's Audio Element type"
    is AV_IAMF_AUDIO_ELEMENT_TYPE_CHANNEL, this corresponds to an Scalable Channel
    Layout layer as defined in section 3.6.2 of IAMF.
    For AV_IAMF_AUDIO_ELEMENT_TYPE_SCENE, it is an Ambisonics channel
    layout as defined in section 3.6.3 of IAMF.

    @note The struct should be allocated with av_iamf_audio_element_add_layer()
    and its size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var ch_layout: AVChannelLayout
    """The channel layout of the layer."""
    var flags: c_uint
    """A bitmask which may contain a combination of AV_IAMF_LAYER_FLAG_* flags."""
    var output_gain_flags: c_uint
    """Output gain channel flags as defined in section 3.6.2 of IAMF.

    This field is defined only if @ref AVIAMFAudioElement.audio_element_type
    "the parent's Audio Element type" is AV_IAMF_AUDIO_ELEMENT_TYPE_CHANNEL,
    must be 0 otherwise."""
    var output_gain: AVRational
    """Output gain as defined in section 3.6.2 of IAMF.

    Must be 0 if @ref output_gain_flags is 0."""

    var ambisonics_mode: AVIAMFAmbisonicsMode.ENUM_DTYPE
    """Ambisonics mode as defined in section 3.6.3 of IAMF.

    This field is defined only if @ref AVIAMFAudioElement.audio_element_type
    "the parent's Audio Element type" is AV_IAMF_AUDIO_ELEMENT_TYPE_SCENE.

    If AV_IAMF_AMBISONICS_MODE_MONO, channel_mapping is defined implicitly
    (Ambisonic Order) or explicitly (Custom Order with ambi channels) in
    @ref ch_layout.
    If AV_IAMF_AMBISONICS_MODE_PROJECTION, @ref demixing_matrix must be set.
    """
    var demixing_matrix: UnsafePointer[AVRational, MutOrigin.external]
    """Demixing matrix as defined in section 3.6.3 of IAMF.

    The length of the array is ch_layout.nb_channels multiplied by the sum of
    the amount of streams in the group plus the amount of streams in the group
    that are stereo.

    May be set only if @ref ambisonics_mode == AV_IAMF_AMBISONICS_MODE_PROJECTION,
    must be NULL otherwise."""


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
    """Information on how to combine one or more audio streams, as defined in
    section 3.6 of IAMF.

    @note The struct should be allocated with av_iamf_audio_element_alloc()
    and its size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var layers: UnsafePointer[
        UnsafePointer[AVIAMFLayer, MutOrigin.external], MutOrigin.external
    ]
    """Array of layers in the Audio Element."""
    var nb_layers: c_uint
    """Number of layers in the Audio Element.
    
    There may be 6 layers at most, and for @ref audio_element_type
    AV_IAMF_AUDIO_ELEMENT_TYPE_SCENE, there may be exactly 1.

    Set by av_iamf_audio_element_add_layer(), must not be
    modified by any other code.
    """
    var demixing_info: UnsafePointer[AVIAMFParamDefinition, MutOrigin.external]
    """Demixing information used to reconstruct a scalable channel audio
    representation. 
    The @ref AVIAMFParamDefinition.type "type" must be
    AV_IAMF_PARAMETER_DEFINITION_DEMIXING."""
    var recon_gain_info: UnsafePointer[
        AVIAMFParamDefinition, MutOrigin.external
    ]
    """Recon gain information used to reconstruct a scalable channel audio
    representation. 
    The @ref AVIAMFParamDefinition.type "type" must be
    AV_IAMF_PARAMETER_DEFINITION_RECON_GAIN."""
    var audio_element_type: AVIAMFAudioElementType.ENUM_DTYPE
    """Audio element type as defined in section 3.6 of IAMF."""

    var default_w: c_uint
    """Default weight value as defined in section 3.6 of IAMF."""


comptime av_iamf_audio_element_get_class = ExternalFunction[
    "av_iamf_audio_element_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]

comptime av_iamf_audio_element_alloc = ExternalFunction[
    "av_iamf_audio_element_alloc",
    fn () -> UnsafePointer[AVIAMFAudioElement, MutOrigin.external],
]
"""Allocates a AVIAMFAudioElement, and initializes its fields with default values.
No layers are allocated. Must be freed with av_iamf_audio_element_free().

@see av_iamf_audio_element_add_layer()
"""

comptime av_iamf_audio_element_add_layer = ExternalFunction[
    "av_iamf_audio_element_add_layer",
    fn (
        audio_element: UnsafePointer[AVIAMFAudioElement, MutOrigin.external]
    ) -> UnsafePointer[AVIAMFLayer, MutOrigin.external],
]
"""Allocates a layer and add it to a given AVIAMFAudioElement.
It is freed by av_iamf_audio_element_free() alongside the rest of the parent
AVIAMFAudioElement.

@return a pointer to the allocated layer.
"""

comptime av_iamf_audio_element_free = ExternalFunction[
    "av_iamf_audio_element_free",
    fn (
        audio_element: UnsafePointer[
            UnsafePointer[AVIAMFAudioElement, MutOrigin.external],
            MutOrigin.external,
        ]
    ),
]
"""Free an AVIAMFAudioElement and all its contents.

@param audio_element pointer to pointer to an allocated AVIAMFAudioElement.
upon return, *audio_element will be set to NULL.
"""


@fieldwise_init
@register_passable("trivial")
struct AVIAMFHeadphonesMode(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_HEADPHONES_MODE_STEREO = Self(0)
    """The referenced Audio Element shall be rendered to stereo loudspeakers."""
    comptime AV_IAMF_HEADPHONES_MODE_BINAURAL = Self(1)
    """The referenced Audio Element shall be rendered with a binaural renderer."""


@fieldwise_init
@register_passable("trivial")
struct AVIAMFSubmixElement(Debug):
    """Submix element as defined in section 3.7 of IAMF.

    @note The struct should be allocated with av_iamf_submix_add_element()
    and its size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var audio_element_id: c_uint
    """The id of the Audio Element this submix element references."""
    var element_mix_config: UnsafePointer[
        AVIAMFParamDefinition, MutOrigin.external
    ]
    """Information required required for applying any processing to the
    referenced and rendered Audio Element before being summed with other
    processed Audio Elements. 
    
    The @ref AVIAMFParamDefinition.type "type" must be
    AV_IAMF_PARAMETER_DEFINITION_MIX_GAIN."""
    var default_mix_gain: AVRational
    """Default mix gain value to apply when there are no AVIAMFParamDefinition
    with @ref element_mix_config "element_mix_config's" 
    @ref AVIAMFParamDefinition.parameter_id "parameter_id" available for a
    given audio frame.
    """
    var headphones_rendering_mode: AVIAMFHeadphonesMode.ENUM_DTYPE
    """A value that indicates whether the referenced channel-based Audio Element
    shall be rendered to stereo loudspeakers or spatialized with a binaural
    renderer when played back on headphones.

    If the Audio Element is not of @ref AVIAMFAudioElement.audio_element_type
    "type" AV_IAMF_AUDIO_ELEMENT_TYPE_CHANNEL, then this field is undefined."""
    var annotations: UnsafePointer[AVDictionary, MutOrigin.external]
    """A dictionary of strings describing the submix in different languages.
    Must have the same amount of entries as @ref AVIAMFMixPresentation.annotations "the mix's annotations", stored
    in the same order, and with the same key strings.
    
    @ref AVDictionaryEntry.key "key" is a string conforming to BCP-47 that
    specifies the language for the string stored in
    @ref AVDictionaryEntry.value "value".
    """


@fieldwise_init
@register_passable("trivial")
struct AVIAMFSubmixLayoutType(Debug):
    comptime ENUM_DTYPE = c_int
    var value: Self.ENUM_DTYPE

    comptime AV_IAMF_SUBMIX_LAYOUT_TYPE_LOUDSPEAKERS = Self(2)
    """The layout follows the loudspeaker sound system convention of ITU-2051-3.
    @ref AVIAMFSubmixLayout.sound_system must be set."""
    comptime AV_IAMF_SUBMIX_LAYOUT_TYPE_BINAURAL = Self(3)
    """The layout is binaural.
    @note @ref AVIAMFSubmixLayout.sound_system may be set to
    AV_CHANNEL_LAYOUT_BINAURAL to simplify API usage, but it's not mandatory."""


@fieldwise_init
@register_passable("trivial")
struct AVIAMFSubmixLayout(Debug):
    """Submix layout as defined in section 3.7.6 of IAMF.

    @note The struct should be allocated with av_iamf_submix_add_layout()
    and its size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var layout_type: AVIAMFSubmixLayoutType.ENUM_DTYPE
    """Layout type as defined in section 3.7.6 of IAMF."""
    var sound_system: AVChannelLayout
    """Channel layout matching one of Sound Systems A to J of ITU-2051-3, plus
    7.1.2ch, 3.1.2ch, and binaural.

    If layout_type is not AV_IAMF_SUBMIX_LAYOUT_TYPE_LOUDSPEAKERS or
    AV_IAMF_SUBMIX_LAYOUT_TYPE_BINAURAL, this field is undefined."""
    var integrated_loudness: AVRational
    """The program integrated loudness information, as defined in
    ITU-1770-4."""
    var digital_peak: AVRational
    """The digital (sampled) peak value of the audio signal, as defined
    in ITU-1770-4."""
    var true_peak: AVRational
    """The true peak of the audio signal, as defined in ITU-1770-4."""
    var dialogue_anchored_loudness: AVRational
    """The Dialogue loudness information, as defined in ITU-1770-4."""
    var album_anchored_loudness: AVRational
    """The Album loudness information, as defined in ITU-1770-4."""


@fieldwise_init
@register_passable("trivial")
struct AVIAMFSubmix(Debug):
    """Submix as defined in section 3.7 of IAMF.

    @note The struct should be allocated with av_iamf_submix_alloc()
    and its size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var elements: UnsafePointer[
        UnsafePointer[AVIAMFSubmixElement, MutOrigin.external],
        MutOrigin.external,
    ]
    """Array of submix elements."""
    var nb_elements: c_uint
    """Number of elements in the submix.
    
    Set by av_iamf_submix_add_element(), must not be
    modified by any other code.
    """
    var layouts: UnsafePointer[
        UnsafePointer[AVIAMFSubmixLayout, MutOrigin.external],
        MutOrigin.external,
    ]
    """Array of submix layouts.
    
    Set by av_iamf_submix_add_layout(), must not be
    modified by any other code.
    """
    var nb_layouts: c_uint
    """Number of layouts in the submix.
    
    Set by av_iamf_submix_add_layout(), must not be
    modified by any other code.
    """
    var output_mix_config: UnsafePointer[
        AVIAMFParamDefinition, MutOrigin.external
    ]
    """Information required for post-processing the mixed audio signal to
    generate the audio signal for playback.

    The @ref AVIAMFParamDefinition.type "type" must be
    AV_IAMF_PARAMETER_DEFINITION_MIX_GAIN."""
    var default_mix_gain: AVRational
    """Default mix gain value to apply when there are no AVIAMFParamDefinition
    with @ref output_mix_config "output_mix_config's"

    @ref AVIAMFParamDefinition.parameter_id "parameter_id" available for a
    given audio frame.
    """


@fieldwise_init
@register_passable("trivial")
struct AVIAMFMixPresentation(Debug):
    """Information on how to render and mix one or more AVIAMFAudioElement to generate
    the final audio output, as defined in section 3.7 of IAMF.

    @note The struct should be allocated with av_iamf_mix_presentation_alloc()
    and its size is not a part of the public ABI.
    """

    var av_class: UnsafePointer[AVClass, ImmutOrigin.external]
    var submixes: UnsafePointer[
        UnsafePointer[AVIAMFSubmix, MutOrigin.external], MutOrigin.external
    ]
    """Array of submixes.
    
    Set by av_iamf_mix_presentation_add_submix(), must not be
    modified by any other code.
    """
    var nb_submixes: c_uint
    """Number of submixes in the mix presentation.
    
    Set by av_iamf_mix_presentation_add_submix(), must not be
    modified by any other code.
    """
    var annotations: UnsafePointer[AVDictionary, MutOrigin.external]
    """A dictionary of strings describing the mix in different languages.
    Must have the same amount of entries as every
    @ref AVIAMFSubmixElement.annotations "Submix element annotations", stored
    in the same order, and with the same key strings.
    
    @ref AVDictionaryEntry.key "key" is a string conforming to BCP-47 that
    specifies the language for the string stored in
    @ref AVDictionaryEntry.value "value".
    """


comptime av_iamf_mix_presentation_get_class = ExternalFunction[
    "av_iamf_mix_presentation_get_class",
    fn () -> UnsafePointer[AVClass, ImmutOrigin.external],
]

comptime av_iamf_mix_presentation_alloc = ExternalFunction[
    "av_iamf_mix_presentation_alloc",
    fn () -> UnsafePointer[AVIAMFMixPresentation, MutOrigin.external],
]
"""Allocates a AVIAMFMixPresentation, and initializes its fields with default values.
No submixes are allocated. Must be freed with av_iamf_mix_presentation_free().

@see av_iamf_mix_presentation_add_submix()
"""

comptime av_iamf_mix_presentation_add_submix = ExternalFunction[
    "av_iamf_mix_presentation_add_submix",
    fn (
        mix_presentation: UnsafePointer[
            AVIAMFMixPresentation, MutOrigin.external
        ]
    ) -> UnsafePointer[AVIAMFSubmix, MutOrigin.external],
]
"""Allocates a submix and add it to a given AVIAMFMixPresentation.
It is freed by av_iamf_mix_presentation_free() alongside the rest of the parent
AVIAMFMixPresentation.

@return a pointer to the allocated submix.
"""

comptime av_iamf_submix_add_element = ExternalFunction[
    "av_iamf_submix_add_element",
    fn (
        submix: UnsafePointer[AVIAMFSubmix, MutOrigin.external]
    ) -> UnsafePointer[AVIAMFSubmixElement, MutOrigin.external],
]
"""Allocates a submix element and add it to a given AVIAMFSubmix.
It is freed by av_iamf_mix_presentation_free() alongside the rest of the parent
AVIAMFSubmix.

@return a pointer to the allocated submix element.
"""

comptime av_iamf_submix_add_layout = ExternalFunction[
    "av_iamf_submix_add_layout",
    fn (
        submix: UnsafePointer[AVIAMFSubmix, MutOrigin.external]
    ) -> UnsafePointer[AVIAMFSubmixLayout, MutOrigin.external],
]
"""Allocates a submix layout and add it to a given AVIAMFSubmix.
It is freed by av_iamf_mix_presentation_free() alongside the rest of the parent
AVIAMFSubmix.

@return a pointer to the allocated submix layout.
"""

comptime av_iamf_mix_presentation_free = ExternalFunction[
    "av_iamf_mix_presentation_free",
    fn (
        mix_presentation: UnsafePointer[
            UnsafePointer[AVIAMFMixPresentation, MutOrigin.external],
            MutOrigin.external,
        ]
    ),
]
"""Free an AVIAMFMixPresentation and all its contents.

@param mix_presentation pointer to pointer to an allocated AVIAMFMixPresentation.
upon return, *mix_presentation will be set to NULL.
"""
