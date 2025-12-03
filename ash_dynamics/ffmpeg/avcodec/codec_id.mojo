from sys.ffi import c_int
from ash_dynamics.ffmpeg.avcodec.version_major import (
    FF_API_V408_CODECID,
    FF_API_INIT_PACKET,
    FF_API_CODEC_PROPS,
    FF_API_EXR_GAMMA,
    FF_API_NVDEC_OLD_PIX_FMTS,
    FF_CODEC_OMX,
    FF_CODEC_SONIC_ENC,
    FF_CODEC_SONIC_DEC,
)


@fieldwise_init("implicit")
@register_passable("trivial")
struct AVCodecID:
    """Reference [0] for enum details.

    Reference:
     - https://www.ffmpeg.org/doxygen/8.0/group__lavc__core.html
    """

    var _value: c_int

    @staticmethod
    fn xor(
        value_if_true: c_int, value_if_false: c_int, condition: Bool
    ) -> Self:
        return Self(value_if_true if condition else value_if_false)

    comptime AV_CODEC_ID_NONE = Self(0)

    # video codecs
    comptime AV_CODEC_ID_MPEG1VIDEO = Self(Self.AV_CODEC_ID_NONE._value + 1)
    comptime AV_CODEC_ID_MPEG2VIDEO = Self(
        Self.AV_CODEC_ID_MPEG1VIDEO._value + 1
    )  # < preferred ID for MPEG-1/2 video decoding
    comptime AV_CODEC_ID_H261 = Self(Self.AV_CODEC_ID_MPEG2VIDEO._value + 1)
    comptime AV_CODEC_ID_H263 = Self(Self.AV_CODEC_ID_H261._value + 1)
    comptime AV_CODEC_ID_RV10 = Self(Self.AV_CODEC_ID_H263._value + 1)
    comptime AV_CODEC_ID_RV20 = Self(Self.AV_CODEC_ID_RV10._value + 1)
    comptime AV_CODEC_ID_MJPEG = Self(Self.AV_CODEC_ID_RV20._value + 1)
    comptime AV_CODEC_ID_MJPEGB = Self(Self.AV_CODEC_ID_MJPEG._value + 1)
    comptime AV_CODEC_ID_LJPEG = Self(Self.AV_CODEC_ID_MJPEGB._value + 1)
    comptime AV_CODEC_ID_SP5X = Self(Self.AV_CODEC_ID_LJPEG._value + 1)
    comptime AV_CODEC_ID_JPEGLS = Self(Self.AV_CODEC_ID_SP5X._value + 1)
    comptime AV_CODEC_ID_MPEG4 = Self(Self.AV_CODEC_ID_JPEGLS._value + 1)
    comptime AV_CODEC_ID_RAWVIDEO = Self(Self.AV_CODEC_ID_MPEG4._value + 1)
    comptime AV_CODEC_ID_MSMPEG4V1 = Self(Self.AV_CODEC_ID_RAWVIDEO._value + 1)
    comptime AV_CODEC_ID_MSMPEG4V2 = Self(Self.AV_CODEC_ID_MSMPEG4V1._value + 1)
    comptime AV_CODEC_ID_MSMPEG4V3 = Self(Self.AV_CODEC_ID_MSMPEG4V2._value + 1)
    comptime AV_CODEC_ID_WMV1 = Self(Self.AV_CODEC_ID_MSMPEG4V3._value + 1)
    comptime AV_CODEC_ID_WMV2 = Self(Self.AV_CODEC_ID_WMV1._value + 1)
    comptime AV_CODEC_ID_H263P = Self(Self.AV_CODEC_ID_WMV2._value + 1)
    comptime AV_CODEC_ID_H263I = Self(Self.AV_CODEC_ID_H263P._value + 1)
    comptime AV_CODEC_ID_FLV1 = Self(Self.AV_CODEC_ID_H263I._value + 1)
    comptime AV_CODEC_ID_SVQ1 = Self(Self.AV_CODEC_ID_FLV1._value + 1)
    comptime AV_CODEC_ID_SVQ3 = Self(Self.AV_CODEC_ID_SVQ1._value + 1)
    comptime AV_CODEC_ID_DVVIDEO = Self(Self.AV_CODEC_ID_SVQ3._value + 1)
    comptime AV_CODEC_ID_HUFFYUV = Self(Self.AV_CODEC_ID_DVVIDEO._value + 1)
    comptime AV_CODEC_ID_CYUV = Self(Self.AV_CODEC_ID_HUFFYUV._value + 1)
    comptime AV_CODEC_ID_H264 = Self(Self.AV_CODEC_ID_CYUV._value + 1)
    comptime AV_CODEC_ID_INDEO3 = Self(Self.AV_CODEC_ID_H264._value + 1)
    comptime AV_CODEC_ID_VP3 = Self(Self.AV_CODEC_ID_INDEO3._value + 1)
    comptime AV_CODEC_ID_THEORA = Self(Self.AV_CODEC_ID_VP3._value + 1)
    comptime AV_CODEC_ID_ASV1 = Self(Self.AV_CODEC_ID_THEORA._value + 1)
    comptime AV_CODEC_ID_ASV2 = Self(Self.AV_CODEC_ID_ASV1._value + 1)
    comptime AV_CODEC_ID_FFV1 = Self(Self.AV_CODEC_ID_ASV2._value + 1)
    comptime AV_CODEC_ID_4XM = Self(Self.AV_CODEC_ID_FFV1._value + 1)
    comptime AV_CODEC_ID_VCR1 = Self(Self.AV_CODEC_ID_4XM._value + 1)
    comptime AV_CODEC_ID_CLJR = Self(Self.AV_CODEC_ID_VCR1._value + 1)
    comptime AV_CODEC_ID_MDEC = Self(Self.AV_CODEC_ID_CLJR._value + 1)
    comptime AV_CODEC_ID_ROQ = Self(Self.AV_CODEC_ID_MDEC._value + 1)
    comptime AV_CODEC_ID_INTERPLAY_VIDEO = Self(Self.AV_CODEC_ID_ROQ._value + 1)
    comptime AV_CODEC_ID_XAN_WC3 = Self(
        Self.AV_CODEC_ID_INTERPLAY_VIDEO._value + 1
    )
    comptime AV_CODEC_ID_XAN_WC4 = Self(Self.AV_CODEC_ID_XAN_WC3._value + 1)
    comptime AV_CODEC_ID_RPZA = Self(Self.AV_CODEC_ID_XAN_WC4._value + 1)
    comptime AV_CODEC_ID_CINEPAK = Self(Self.AV_CODEC_ID_RPZA._value + 1)
    comptime AV_CODEC_ID_WS_VQA = Self(Self.AV_CODEC_ID_CINEPAK._value + 1)
    comptime AV_CODEC_ID_MSRLE = Self(Self.AV_CODEC_ID_WS_VQA._value + 1)
    comptime AV_CODEC_ID_MSVIDEO1 = Self(Self.AV_CODEC_ID_MSRLE._value + 1)
    comptime AV_CODEC_ID_IDCIN = Self(Self.AV_CODEC_ID_MSVIDEO1._value + 1)
    comptime AV_CODEC_ID_8BPS = Self(Self.AV_CODEC_ID_IDCIN._value + 1)
    comptime AV_CODEC_ID_SMC = Self(Self.AV_CODEC_ID_8BPS._value + 1)
    comptime AV_CODEC_ID_FLIC = Self(Self.AV_CODEC_ID_SMC._value + 1)
    comptime AV_CODEC_ID_TRUEMOTION1 = Self(Self.AV_CODEC_ID_FLIC._value + 1)
    comptime AV_CODEC_ID_VMDVIDEO = Self(
        Self.AV_CODEC_ID_TRUEMOTION1._value + 1
    )
    comptime AV_CODEC_ID_MSZH = Self(Self.AV_CODEC_ID_VMDVIDEO._value + 1)
    comptime AV_CODEC_ID_ZLIB = Self(Self.AV_CODEC_ID_MSZH._value + 1)
    comptime AV_CODEC_ID_QTRLE = Self(Self.AV_CODEC_ID_ZLIB._value + 1)
    comptime AV_CODEC_ID_TSCC = Self(Self.AV_CODEC_ID_QTRLE._value + 1)
    comptime AV_CODEC_ID_ULTI = Self(Self.AV_CODEC_ID_TSCC._value + 1)
    comptime AV_CODEC_ID_QDRAW = Self(Self.AV_CODEC_ID_ULTI._value + 1)
    comptime AV_CODEC_ID_VIXL = Self(Self.AV_CODEC_ID_QDRAW._value + 1)
    comptime AV_CODEC_ID_QPEG = Self(Self.AV_CODEC_ID_VIXL._value + 1)
    comptime AV_CODEC_ID_PNG = Self(Self.AV_CODEC_ID_QPEG._value + 1)
    comptime AV_CODEC_ID_PPM = Self(Self.AV_CODEC_ID_PNG._value + 1)
    comptime AV_CODEC_ID_PBM = Self(Self.AV_CODEC_ID_PPM._value + 1)
    comptime AV_CODEC_ID_PGM = Self(Self.AV_CODEC_ID_PBM._value + 1)
    comptime AV_CODEC_ID_PGMYUV = Self(Self.AV_CODEC_ID_PGM._value + 1)
    comptime AV_CODEC_ID_PAM = Self(Self.AV_CODEC_ID_PGMYUV._value + 1)
    comptime AV_CODEC_ID_FFVHUFF = Self(Self.AV_CODEC_ID_PAM._value + 1)
    comptime AV_CODEC_ID_RV30 = Self(Self.AV_CODEC_ID_FFVHUFF._value + 1)
    comptime AV_CODEC_ID_RV40 = Self(Self.AV_CODEC_ID_RV30._value + 1)
    comptime AV_CODEC_ID_VC1 = Self(Self.AV_CODEC_ID_RV40._value + 1)
    comptime AV_CODEC_ID_WMV3 = Self(Self.AV_CODEC_ID_VC1._value + 1)
    comptime AV_CODEC_ID_LOCO = Self(Self.AV_CODEC_ID_WMV3._value + 1)
    comptime AV_CODEC_ID_WNV1 = Self(Self.AV_CODEC_ID_LOCO._value + 1)
    comptime AV_CODEC_ID_AASC = Self(Self.AV_CODEC_ID_WNV1._value + 1)
    comptime AV_CODEC_ID_INDEO2 = Self(Self.AV_CODEC_ID_AASC._value + 1)
    comptime AV_CODEC_ID_FRAPS = Self(Self.AV_CODEC_ID_INDEO2._value + 1)
    comptime AV_CODEC_ID_TRUEMOTION2 = Self(Self.AV_CODEC_ID_FRAPS._value + 1)
    comptime AV_CODEC_ID_BMP = Self(Self.AV_CODEC_ID_TRUEMOTION2._value + 1)
    comptime AV_CODEC_ID_CSCD = Self(Self.AV_CODEC_ID_BMP._value + 1)
    comptime AV_CODEC_ID_MMVIDEO = Self(Self.AV_CODEC_ID_CSCD._value + 1)
    comptime AV_CODEC_ID_ZMBV = Self(Self.AV_CODEC_ID_MMVIDEO._value + 1)
    comptime AV_CODEC_ID_AVS = Self(Self.AV_CODEC_ID_ZMBV._value + 1)
    comptime AV_CODEC_ID_SMACKVIDEO = Self(Self.AV_CODEC_ID_AVS._value + 1)
    comptime AV_CODEC_ID_NUV = Self(Self.AV_CODEC_ID_SMACKVIDEO._value + 1)
    comptime AV_CODEC_ID_KMVC = Self(Self.AV_CODEC_ID_NUV._value + 1)
    comptime AV_CODEC_ID_FLASHSV = Self(Self.AV_CODEC_ID_KMVC._value + 1)
    comptime AV_CODEC_ID_CAVS = Self(Self.AV_CODEC_ID_FLASHSV._value + 1)
    comptime AV_CODEC_ID_JPEG2000 = Self(Self.AV_CODEC_ID_CAVS._value + 1)
    comptime AV_CODEC_ID_VMNC = Self(Self.AV_CODEC_ID_JPEG2000._value + 1)
    comptime AV_CODEC_ID_VP5 = Self(Self.AV_CODEC_ID_VMNC._value + 1)
    comptime AV_CODEC_ID_VP6 = Self(Self.AV_CODEC_ID_VP5._value + 1)
    comptime AV_CODEC_ID_VP6F = Self(Self.AV_CODEC_ID_VP6._value + 1)
    comptime AV_CODEC_ID_TARGA = Self(Self.AV_CODEC_ID_VP6F._value + 1)
    comptime AV_CODEC_ID_DSICINVIDEO = Self(Self.AV_CODEC_ID_TARGA._value + 1)
    comptime AV_CODEC_ID_TIERTEXSEQVIDEO = Self(
        Self.AV_CODEC_ID_DSICINVIDEO._value + 1
    )
    comptime AV_CODEC_ID_TIFF = Self(
        Self.AV_CODEC_ID_TIERTEXSEQVIDEO._value + 1
    )
    comptime AV_CODEC_ID_GIF = Self(Self.AV_CODEC_ID_TIFF._value + 1)
    comptime AV_CODEC_ID_DXA = Self(Self.AV_CODEC_ID_GIF._value + 1)
    comptime AV_CODEC_ID_DNXHD = Self(Self.AV_CODEC_ID_DXA._value + 1)
    comptime AV_CODEC_ID_THP = Self(Self.AV_CODEC_ID_DNXHD._value + 1)
    comptime AV_CODEC_ID_SGI = Self(Self.AV_CODEC_ID_THP._value + 1)
    comptime AV_CODEC_ID_C93 = Self(Self.AV_CODEC_ID_SGI._value + 1)
    comptime AV_CODEC_ID_BETHSOFTVID = Self(Self.AV_CODEC_ID_C93._value + 1)
    comptime AV_CODEC_ID_PTX = Self(Self.AV_CODEC_ID_BETHSOFTVID._value + 1)
    comptime AV_CODEC_ID_TXD = Self(Self.AV_CODEC_ID_PTX._value + 1)
    comptime AV_CODEC_ID_VP6A = Self(Self.AV_CODEC_ID_TXD._value + 1)
    comptime AV_CODEC_ID_AMV = Self(Self.AV_CODEC_ID_VP6A._value + 1)
    comptime AV_CODEC_ID_VB = Self(Self.AV_CODEC_ID_AMV._value + 1)
    comptime AV_CODEC_ID_PCX = Self(Self.AV_CODEC_ID_VB._value + 1)
    comptime AV_CODEC_ID_SUNRAST = Self(Self.AV_CODEC_ID_PCX._value + 1)
    comptime AV_CODEC_ID_INDEO4 = Self(Self.AV_CODEC_ID_SUNRAST._value + 1)
    comptime AV_CODEC_ID_INDEO5 = Self(Self.AV_CODEC_ID_INDEO4._value + 1)
    comptime AV_CODEC_ID_MIMIC = Self(Self.AV_CODEC_ID_INDEO5._value + 1)
    comptime AV_CODEC_ID_RL2 = Self(Self.AV_CODEC_ID_MIMIC._value + 1)
    comptime AV_CODEC_ID_ESCAPE124 = Self(Self.AV_CODEC_ID_RL2._value + 1)
    comptime AV_CODEC_ID_DIRAC = Self(Self.AV_CODEC_ID_ESCAPE124._value + 1)
    comptime AV_CODEC_ID_BFI = Self(Self.AV_CODEC_ID_DIRAC._value + 1)
    comptime AV_CODEC_ID_CMV = Self(Self.AV_CODEC_ID_BFI._value + 1)
    comptime AV_CODEC_ID_MOTIONPIXELS = Self(Self.AV_CODEC_ID_CMV._value + 1)
    comptime AV_CODEC_ID_TGV = Self(Self.AV_CODEC_ID_MOTIONPIXELS._value + 1)
    comptime AV_CODEC_ID_TGQ = Self(Self.AV_CODEC_ID_TGV._value + 1)
    comptime AV_CODEC_ID_TQI = Self(Self.AV_CODEC_ID_TGQ._value + 1)
    comptime AV_CODEC_ID_AURA = Self(Self.AV_CODEC_ID_TQI._value + 1)
    comptime AV_CODEC_ID_AURA2 = Self(Self.AV_CODEC_ID_AURA._value + 1)
    comptime AV_CODEC_ID_V210X = Self(Self.AV_CODEC_ID_AURA2._value + 1)
    comptime AV_CODEC_ID_TMV = Self(Self.AV_CODEC_ID_V210X._value + 1)
    comptime AV_CODEC_ID_V210 = Self(Self.AV_CODEC_ID_TMV._value + 1)
    comptime AV_CODEC_ID_DPX = Self(Self.AV_CODEC_ID_V210._value + 1)
    comptime AV_CODEC_ID_MAD = Self(Self.AV_CODEC_ID_DPX._value + 1)
    comptime AV_CODEC_ID_FRWU = Self(Self.AV_CODEC_ID_MAD._value + 1)
    comptime AV_CODEC_ID_FLASHSV2 = Self(Self.AV_CODEC_ID_FRWU._value + 1)
    comptime AV_CODEC_ID_CDGRAPHICS = Self(Self.AV_CODEC_ID_FLASHSV2._value + 1)
    comptime AV_CODEC_ID_R210 = Self(Self.AV_CODEC_ID_CDGRAPHICS._value + 1)
    comptime AV_CODEC_ID_ANM = Self(Self.AV_CODEC_ID_R210._value + 1)
    comptime AV_CODEC_ID_BINKVIDEO = Self(Self.AV_CODEC_ID_ANM._value + 1)
    comptime AV_CODEC_ID_IFF_ILBM = Self(Self.AV_CODEC_ID_BINKVIDEO._value + 1)
    # Was a macro:
    # define AV_CODEC_ID_IFF_BYTERUN1 AV_CODEC_ID_IFF_ILBM
    comptime AV_CODEC_ID_IFF_BYTERUN1 = Self(Self.AV_CODEC_ID_IFF_ILBM._value)

    comptime AV_CODEC_ID_KGV1 = Self(Self.AV_CODEC_ID_IFF_BYTERUN1._value + 1)
    comptime AV_CODEC_ID_YOP = Self(Self.AV_CODEC_ID_KGV1._value + 1)
    comptime AV_CODEC_ID_VP8 = Self(Self.AV_CODEC_ID_YOP._value + 1)
    comptime AV_CODEC_ID_PICTOR = Self(Self.AV_CODEC_ID_VP8._value + 1)
    comptime AV_CODEC_ID_ANSI = Self(Self.AV_CODEC_ID_PICTOR._value + 1)
    comptime AV_CODEC_ID_A64_MULTI = Self(Self.AV_CODEC_ID_ANSI._value + 1)
    comptime AV_CODEC_ID_A64_MULTI5 = Self(
        Self.AV_CODEC_ID_A64_MULTI._value + 1
    )
    comptime AV_CODEC_ID_R10K = Self(Self.AV_CODEC_ID_A64_MULTI5._value + 1)
    comptime AV_CODEC_ID_MXPEG = Self(Self.AV_CODEC_ID_R10K._value + 1)
    comptime AV_CODEC_ID_LAGARITH = Self(Self.AV_CODEC_ID_MXPEG._value + 1)
    comptime AV_CODEC_ID_PRORES = Self(Self.AV_CODEC_ID_LAGARITH._value + 1)
    comptime AV_CODEC_ID_JV = Self(Self.AV_CODEC_ID_PRORES._value + 1)
    comptime AV_CODEC_ID_DFA = Self(Self.AV_CODEC_ID_JV._value + 1)
    comptime AV_CODEC_ID_WMV3IMAGE = Self(Self.AV_CODEC_ID_DFA._value + 1)
    comptime AV_CODEC_ID_VC1IMAGE = Self(Self.AV_CODEC_ID_WMV3IMAGE._value + 1)
    comptime AV_CODEC_ID_UTVIDEO = Self(Self.AV_CODEC_ID_VC1IMAGE._value + 1)
    comptime AV_CODEC_ID_BMV_VIDEO = Self(Self.AV_CODEC_ID_UTVIDEO._value + 1)
    comptime AV_CODEC_ID_VBLE = Self(Self.AV_CODEC_ID_BMV_VIDEO._value + 1)
    comptime AV_CODEC_ID_DXTORY = Self(Self.AV_CODEC_ID_VBLE._value + 1)

    # Handles macro inclusion of FF_API_V408_CODECID
    # if FF_API_V408_CODECID
    comptime AV_CODEC_ID_V410 = Self.xor(
        Self.AV_CODEC_ID_DXTORY._value + 1, 0, FF_API_V408_CODECID
    )

    comptime AV_CODEC_ID_XWD = Self.xor(
        Self.AV_CODEC_ID_V410._value + 1,
        Self.AV_CODEC_ID_DXTORY._value + 1,
        FF_API_V408_CODECID,
    )
    comptime AV_CODEC_ID_CDXL = Self(Self.AV_CODEC_ID_XWD._value + 1)
    comptime AV_CODEC_ID_XBM = Self(Self.AV_CODEC_ID_CDXL._value + 1)
    comptime AV_CODEC_ID_ZEROCODEC = Self(Self.AV_CODEC_ID_XBM._value + 1)
    comptime AV_CODEC_ID_MSS1 = Self(Self.AV_CODEC_ID_ZEROCODEC._value + 1)
    comptime AV_CODEC_ID_MSA1 = Self(Self.AV_CODEC_ID_MSS1._value + 1)
    comptime AV_CODEC_ID_TSCC2 = Self(Self.AV_CODEC_ID_MSA1._value + 1)
    comptime AV_CODEC_ID_MTS2 = Self(Self.AV_CODEC_ID_TSCC2._value + 1)
    comptime AV_CODEC_ID_CLLC = Self(Self.AV_CODEC_ID_MTS2._value + 1)
    comptime AV_CODEC_ID_MSS2 = Self(Self.AV_CODEC_ID_CLLC._value + 1)
    comptime AV_CODEC_ID_VP9 = Self(Self.AV_CODEC_ID_MSS2._value + 1)
    comptime AV_CODEC_ID_AIC = Self(Self.AV_CODEC_ID_VP9._value + 1)
    comptime AV_CODEC_ID_ESCAPE130 = Self(Self.AV_CODEC_ID_AIC._value + 1)
    comptime AV_CODEC_ID_G2M = Self(Self.AV_CODEC_ID_ESCAPE130._value + 1)
    comptime AV_CODEC_ID_WEBP = Self(Self.AV_CODEC_ID_G2M._value + 1)
    comptime AV_CODEC_ID_HNM4_VIDEO = Self(Self.AV_CODEC_ID_WEBP._value + 1)
    comptime AV_CODEC_ID_HEVC = Self(Self.AV_CODEC_ID_HNM4_VIDEO._value + 1)
    # Was a macro:
    # define AV_CODEC_ID_H265 AV_CODEC_ID_HEVC
    comptime AV_CODEC_ID_H265 = Self(Self.AV_CODEC_ID_HEVC._value)

    comptime AV_CODEC_ID_FIC = Self(Self.AV_CODEC_ID_H265._value + 1)
    comptime AV_CODEC_ID_ALIAS_PIX = Self(Self.AV_CODEC_ID_FIC._value + 1)
    comptime AV_CODEC_ID_BRENDER_PIX = Self(
        Self.AV_CODEC_ID_ALIAS_PIX._value + 1
    )
    comptime AV_CODEC_ID_PAF_VIDEO = Self(
        Self.AV_CODEC_ID_BRENDER_PIX._value + 1
    )
    comptime AV_CODEC_ID_EXR = Self(Self.AV_CODEC_ID_PAF_VIDEO._value + 1)
    comptime AV_CODEC_ID_VP7 = Self(Self.AV_CODEC_ID_EXR._value + 1)
    comptime AV_CODEC_ID_SANM = Self(Self.AV_CODEC_ID_VP7._value + 1)
    comptime AV_CODEC_ID_SGIRLE = Self(Self.AV_CODEC_ID_SANM._value + 1)
    comptime AV_CODEC_ID_MVC1 = Self(Self.AV_CODEC_ID_SGIRLE._value + 1)
    comptime AV_CODEC_ID_MVC2 = Self(Self.AV_CODEC_ID_MVC1._value + 1)
    comptime AV_CODEC_ID_HQX = Self(Self.AV_CODEC_ID_MVC2._value + 1)
    comptime AV_CODEC_ID_TDSC = Self(Self.AV_CODEC_ID_HQX._value + 1)
    comptime AV_CODEC_ID_HQ_HQA = Self(Self.AV_CODEC_ID_TDSC._value + 1)
    comptime AV_CODEC_ID_HAP = Self(Self.AV_CODEC_ID_HQ_HQA._value + 1)
    comptime AV_CODEC_ID_DDS = Self(Self.AV_CODEC_ID_HAP._value + 1)
    comptime AV_CODEC_ID_DXV = Self(Self.AV_CODEC_ID_DDS._value + 1)
    comptime AV_CODEC_ID_SCREENPRESSO = Self(Self.AV_CODEC_ID_DXV._value + 1)
    comptime AV_CODEC_ID_RSCC = Self(Self.AV_CODEC_ID_SCREENPRESSO._value + 1)
    comptime AV_CODEC_ID_AVS2 = Self(Self.AV_CODEC_ID_RSCC._value + 1)
    comptime AV_CODEC_ID_PGX = Self(Self.AV_CODEC_ID_AVS2._value + 1)
    comptime AV_CODEC_ID_AVS3 = Self(Self.AV_CODEC_ID_PGX._value + 1)
    comptime AV_CODEC_ID_MSP2 = Self(Self.AV_CODEC_ID_AVS3._value + 1)
    comptime AV_CODEC_ID_VVC = Self(Self.AV_CODEC_ID_MSP2._value + 1)

    # Was macro
    # define AV_CODEC_ID_H266 AV_CODEC_ID_VVC
    comptime AV_CODEC_ID_H266 = Self(Self.AV_CODEC_ID_VVC._value)

    comptime AV_CODEC_ID_Y41P = Self(Self.AV_CODEC_ID_H266._value + 1)
    comptime AV_CODEC_ID_AVRP = Self(Self.AV_CODEC_ID_Y41P._value + 1)
    comptime AV_CODEC_ID_012V = Self(Self.AV_CODEC_ID_AVRP._value + 1)
    comptime AV_CODEC_ID_AVUI = Self(Self.AV_CODEC_ID_012V._value + 1)
    comptime AV_CODEC_ID_TARGA_Y216 = Self(Self.AV_CODEC_ID_AVUI._value + 1)

    # Was macro for these 2 fields being toggled on and off.
    # if FF_API_V408_CODECID
    comptime AV_CODEC_ID_V308 = Self.xor(
        Self.AV_CODEC_ID_TARGA_Y216._value + 1, 0, FF_API_V408_CODECID
    )
    comptime AV_CODEC_ID_V408 = Self.xor(
        Self.AV_CODEC_ID_V308._value + 1, 0, FF_API_V408_CODECID
    )

    comptime AV_CODEC_ID_YUV4 = Self.xor(
        Self.AV_CODEC_ID_V408._value + 1,
        Self.AV_CODEC_ID_TARGA_Y216._value + 1,
        FF_API_V408_CODECID,
    )
    comptime AV_CODEC_ID_AVRN = Self(Self.AV_CODEC_ID_YUV4._value + 1)
    comptime AV_CODEC_ID_CPIA = Self(Self.AV_CODEC_ID_AVRN._value + 1)
    comptime AV_CODEC_ID_XFACE = Self(Self.AV_CODEC_ID_CPIA._value + 1)
    comptime AV_CODEC_ID_SNOW = Self(Self.AV_CODEC_ID_XFACE._value + 1)
    comptime AV_CODEC_ID_SMVJPEG = Self(Self.AV_CODEC_ID_SNOW._value + 1)
    comptime AV_CODEC_ID_APNG = Self(Self.AV_CODEC_ID_SMVJPEG._value + 1)
    comptime AV_CODEC_ID_DAALA = Self(Self.AV_CODEC_ID_APNG._value + 1)
    comptime AV_CODEC_ID_CFHD = Self(Self.AV_CODEC_ID_DAALA._value + 1)
    comptime AV_CODEC_ID_TRUEMOTION2RT = Self(Self.AV_CODEC_ID_CFHD._value + 1)
    comptime AV_CODEC_ID_M101 = Self(Self.AV_CODEC_ID_TRUEMOTION2RT._value + 1)
    comptime AV_CODEC_ID_MAGICYUV = Self(Self.AV_CODEC_ID_M101._value + 1)
    comptime AV_CODEC_ID_SHEERVIDEO = Self(Self.AV_CODEC_ID_MAGICYUV._value + 1)
    comptime AV_CODEC_ID_YLC = Self(Self.AV_CODEC_ID_SHEERVIDEO._value + 1)
    comptime AV_CODEC_ID_PSD = Self(Self.AV_CODEC_ID_YLC._value + 1)
    comptime AV_CODEC_ID_PIXLET = Self(Self.AV_CODEC_ID_PSD._value + 1)
    comptime AV_CODEC_ID_SPEEDHQ = Self(Self.AV_CODEC_ID_PIXLET._value + 1)
    comptime AV_CODEC_ID_FMVC = Self(Self.AV_CODEC_ID_SPEEDHQ._value + 1)
    comptime AV_CODEC_ID_SCPR = Self(Self.AV_CODEC_ID_FMVC._value + 1)
    comptime AV_CODEC_ID_CLEARVIDEO = Self(Self.AV_CODEC_ID_SCPR._value + 1)
    comptime AV_CODEC_ID_XPM = Self(Self.AV_CODEC_ID_CLEARVIDEO._value + 1)
    comptime AV_CODEC_ID_AV1 = Self(Self.AV_CODEC_ID_XPM._value + 1)
    comptime AV_CODEC_ID_BITPACKED = Self(Self.AV_CODEC_ID_AV1._value + 1)
    comptime AV_CODEC_ID_MSCC = Self(Self.AV_CODEC_ID_BITPACKED._value + 1)
    comptime AV_CODEC_ID_SRGC = Self(Self.AV_CODEC_ID_MSCC._value + 1)
    comptime AV_CODEC_ID_SVG = Self(Self.AV_CODEC_ID_SRGC._value + 1)
    comptime AV_CODEC_ID_GDV = Self(Self.AV_CODEC_ID_SVG._value + 1)
    comptime AV_CODEC_ID_FITS = Self(Self.AV_CODEC_ID_GDV._value + 1)
    comptime AV_CODEC_ID_IMM4 = Self(Self.AV_CODEC_ID_FITS._value + 1)
    comptime AV_CODEC_ID_PROSUMER = Self(Self.AV_CODEC_ID_IMM4._value + 1)
    comptime AV_CODEC_ID_MWSC = Self(Self.AV_CODEC_ID_PROSUMER._value + 1)
    comptime AV_CODEC_ID_WCMV = Self(Self.AV_CODEC_ID_MWSC._value + 1)
    comptime AV_CODEC_ID_RASC = Self(Self.AV_CODEC_ID_WCMV._value + 1)
    comptime AV_CODEC_ID_HYMT = Self(Self.AV_CODEC_ID_RASC._value + 1)
    comptime AV_CODEC_ID_ARBC = Self(Self.AV_CODEC_ID_HYMT._value + 1)
    comptime AV_CODEC_ID_AGM = Self(Self.AV_CODEC_ID_ARBC._value + 1)
    comptime AV_CODEC_ID_LSCR = Self(Self.AV_CODEC_ID_AGM._value + 1)
    comptime AV_CODEC_ID_VP4 = Self(Self.AV_CODEC_ID_LSCR._value + 1)
    comptime AV_CODEC_ID_IMM5 = Self(Self.AV_CODEC_ID_VP4._value + 1)
    comptime AV_CODEC_ID_MVDV = Self(Self.AV_CODEC_ID_IMM5._value + 1)
    comptime AV_CODEC_ID_MVHA = Self(Self.AV_CODEC_ID_MVDV._value + 1)
    comptime AV_CODEC_ID_CDTOONS = Self(Self.AV_CODEC_ID_MVHA._value + 1)
    comptime AV_CODEC_ID_MV30 = Self(Self.AV_CODEC_ID_CDTOONS._value + 1)
    comptime AV_CODEC_ID_NOTCHLC = Self(Self.AV_CODEC_ID_MV30._value + 1)
    comptime AV_CODEC_ID_PFM = Self(Self.AV_CODEC_ID_NOTCHLC._value + 1)
    comptime AV_CODEC_ID_MOBICLIP = Self(Self.AV_CODEC_ID_PFM._value + 1)
    comptime AV_CODEC_ID_PHOTOCD = Self(Self.AV_CODEC_ID_MOBICLIP._value + 1)
    comptime AV_CODEC_ID_IPU = Self(Self.AV_CODEC_ID_PHOTOCD._value + 1)
    comptime AV_CODEC_ID_ARGO = Self(Self.AV_CODEC_ID_IPU._value + 1)
    comptime AV_CODEC_ID_CRI = Self(Self.AV_CODEC_ID_ARGO._value + 1)
    comptime AV_CODEC_ID_SIMBIOSIS_IMX = Self(Self.AV_CODEC_ID_CRI._value + 1)
    comptime AV_CODEC_ID_SGA_VIDEO = Self(
        Self.AV_CODEC_ID_SIMBIOSIS_IMX._value + 1
    )
    comptime AV_CODEC_ID_GEM = Self(Self.AV_CODEC_ID_SGA_VIDEO._value + 1)
    comptime AV_CODEC_ID_VBN = Self(Self.AV_CODEC_ID_GEM._value + 1)
    comptime AV_CODEC_ID_JPEGXL = Self(Self.AV_CODEC_ID_VBN._value + 1)
    comptime AV_CODEC_ID_QOI = Self(Self.AV_CODEC_ID_JPEGXL._value + 1)
    comptime AV_CODEC_ID_PHM = Self(Self.AV_CODEC_ID_QOI._value + 1)
    comptime AV_CODEC_ID_RADIANCE_HDR = Self(Self.AV_CODEC_ID_PHM._value + 1)
    comptime AV_CODEC_ID_WBMP = Self(Self.AV_CODEC_ID_RADIANCE_HDR._value + 1)
    comptime AV_CODEC_ID_MEDIA100 = Self(Self.AV_CODEC_ID_WBMP._value + 1)
    comptime AV_CODEC_ID_VQC = Self(Self.AV_CODEC_ID_MEDIA100._value + 1)
    comptime AV_CODEC_ID_PDV = Self(Self.AV_CODEC_ID_VQC._value + 1)
    comptime AV_CODEC_ID_EVC = Self(Self.AV_CODEC_ID_PDV._value + 1)
    comptime AV_CODEC_ID_RTV1 = Self(Self.AV_CODEC_ID_EVC._value + 1)
    comptime AV_CODEC_ID_VMIX = Self(Self.AV_CODEC_ID_RTV1._value + 1)
    comptime AV_CODEC_ID_LEAD = Self(Self.AV_CODEC_ID_VMIX._value + 1)
    comptime AV_CODEC_ID_DNXUC = Self(Self.AV_CODEC_ID_LEAD._value + 1)
    comptime AV_CODEC_ID_RV60 = Self(Self.AV_CODEC_ID_DNXUC._value + 1)
    comptime AV_CODEC_ID_JPEGXL_ANIM = Self(Self.AV_CODEC_ID_RV60._value + 1)
    comptime AV_CODEC_ID_APV = Self(Self.AV_CODEC_ID_JPEGXL_ANIM._value + 1)
    comptime AV_CODEC_ID_PRORES_RAW = Self(Self.AV_CODEC_ID_APV._value + 1)

    #     # various PCM "codecs"
    # These start at 65536.
    comptime AV_CODEC_ID_FIRST_AUDIO = Self(
        0x10000
    )  # < A dummy id pointing at the start of audio codecs
    comptime AV_CODEC_ID_PCM_S16LE = Self(0x10000)
    comptime AV_CODEC_ID_PCM_S16BE = Self(Self.AV_CODEC_ID_PCM_S16LE._value + 1)
    comptime AV_CODEC_ID_PCM_U16LE = Self(Self.AV_CODEC_ID_PCM_S16BE._value + 1)
    comptime AV_CODEC_ID_PCM_U16BE = Self(Self.AV_CODEC_ID_PCM_U16LE._value + 1)
    comptime AV_CODEC_ID_PCM_S8 = Self(Self.AV_CODEC_ID_PCM_U16BE._value + 1)
    comptime AV_CODEC_ID_PCM_U8 = Self(Self.AV_CODEC_ID_PCM_S8._value + 1)
    comptime AV_CODEC_ID_PCM_MULAW = Self(Self.AV_CODEC_ID_PCM_U8._value + 1)
    comptime AV_CODEC_ID_PCM_ALAW = Self(Self.AV_CODEC_ID_PCM_MULAW._value + 1)
    comptime AV_CODEC_ID_PCM_S32LE = Self(Self.AV_CODEC_ID_PCM_ALAW._value + 1)
    comptime AV_CODEC_ID_PCM_S32BE = Self(Self.AV_CODEC_ID_PCM_S32LE._value + 1)
    comptime AV_CODEC_ID_PCM_U32LE = Self(Self.AV_CODEC_ID_PCM_S32BE._value + 1)
    comptime AV_CODEC_ID_PCM_U32BE = Self(Self.AV_CODEC_ID_PCM_U32LE._value + 1)
    comptime AV_CODEC_ID_PCM_S24LE = Self(Self.AV_CODEC_ID_PCM_U32BE._value + 1)
    comptime AV_CODEC_ID_PCM_S24BE = Self(Self.AV_CODEC_ID_PCM_S24LE._value + 1)
    comptime AV_CODEC_ID_PCM_U24LE = Self(Self.AV_CODEC_ID_PCM_S24BE._value + 1)
    comptime AV_CODEC_ID_PCM_U24BE = Self(Self.AV_CODEC_ID_PCM_U24LE._value + 1)
    comptime AV_CODEC_ID_PCM_S24DAUD = Self(
        Self.AV_CODEC_ID_PCM_U24BE._value + 1
    )
    comptime AV_CODEC_ID_PCM_ZORK = Self(
        Self.AV_CODEC_ID_PCM_S24DAUD._value + 1
    )
    comptime AV_CODEC_ID_PCM_S16LE_PLANAR = Self(
        Self.AV_CODEC_ID_PCM_ZORK._value + 1
    )
    comptime AV_CODEC_ID_PCM_DVD = Self(
        Self.AV_CODEC_ID_PCM_S16LE_PLANAR._value + 1
    )
    comptime AV_CODEC_ID_PCM_F32BE = Self(Self.AV_CODEC_ID_PCM_DVD._value + 1)
    comptime AV_CODEC_ID_PCM_F32LE = Self(Self.AV_CODEC_ID_PCM_F32BE._value + 1)
    comptime AV_CODEC_ID_PCM_F64BE = Self(Self.AV_CODEC_ID_PCM_F32LE._value + 1)
    comptime AV_CODEC_ID_PCM_F64LE = Self(Self.AV_CODEC_ID_PCM_F64BE._value + 1)
    comptime AV_CODEC_ID_PCM_BLURAY = Self(
        Self.AV_CODEC_ID_PCM_F64LE._value + 1
    )
    comptime AV_CODEC_ID_PCM_LXF = Self(Self.AV_CODEC_ID_PCM_BLURAY._value + 1)
    comptime AV_CODEC_ID_S302M = Self(Self.AV_CODEC_ID_PCM_LXF._value + 1)
    comptime AV_CODEC_ID_PCM_S8_PLANAR = Self(Self.AV_CODEC_ID_S302M._value + 1)
    comptime AV_CODEC_ID_PCM_S24LE_PLANAR = Self(
        Self.AV_CODEC_ID_PCM_S8_PLANAR._value + 1
    )
    comptime AV_CODEC_ID_PCM_S32LE_PLANAR = Self(
        Self.AV_CODEC_ID_PCM_S24LE_PLANAR._value + 1
    )
    comptime AV_CODEC_ID_PCM_S16BE_PLANAR = Self(
        Self.AV_CODEC_ID_PCM_S32LE_PLANAR._value + 1
    )
    comptime AV_CODEC_ID_PCM_S64LE = Self(
        Self.AV_CODEC_ID_PCM_S16BE_PLANAR._value + 1
    )
    comptime AV_CODEC_ID_PCM_S64BE = Self(Self.AV_CODEC_ID_PCM_S64LE._value + 1)
    comptime AV_CODEC_ID_PCM_F16LE = Self(Self.AV_CODEC_ID_PCM_S64BE._value + 1)
    comptime AV_CODEC_ID_PCM_F24LE = Self(Self.AV_CODEC_ID_PCM_F16LE._value + 1)
    comptime AV_CODEC_ID_PCM_VIDC = Self(Self.AV_CODEC_ID_PCM_F24LE._value + 1)
    comptime AV_CODEC_ID_PCM_SGA = Self(Self.AV_CODEC_ID_PCM_VIDC._value + 1)

    # various ADPCM codecs
    # Starts at 69632
    comptime AV_CODEC_ID_ADPCM_IMA_QT = Self(0x11000)
    comptime AV_CODEC_ID_ADPCM_IMA_WAV = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_QT._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_DK3 = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_WAV._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_DK4 = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_DK3._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_WS = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_DK4._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_SMJPEG = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_WS._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_MS = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_SMJPEG._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_4XM = Self(Self.AV_CODEC_ID_ADPCM_MS._value + 1)
    comptime AV_CODEC_ID_ADPCM_XA = Self(Self.AV_CODEC_ID_ADPCM_4XM._value + 1)
    comptime AV_CODEC_ID_ADPCM_ADX = Self(Self.AV_CODEC_ID_ADPCM_XA._value + 1)
    comptime AV_CODEC_ID_ADPCM_EA = Self(Self.AV_CODEC_ID_ADPCM_ADX._value + 1)
    comptime AV_CODEC_ID_ADPCM_G726 = Self(Self.AV_CODEC_ID_ADPCM_EA._value + 1)
    comptime AV_CODEC_ID_ADPCM_CT = Self(Self.AV_CODEC_ID_ADPCM_G726._value + 1)
    comptime AV_CODEC_ID_ADPCM_SWF = Self(Self.AV_CODEC_ID_ADPCM_CT._value + 1)
    comptime AV_CODEC_ID_ADPCM_YAMAHA = Self(
        Self.AV_CODEC_ID_ADPCM_SWF._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_SBPRO_4 = Self(
        Self.AV_CODEC_ID_ADPCM_YAMAHA._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_SBPRO_3 = Self(
        Self.AV_CODEC_ID_ADPCM_SBPRO_4._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_SBPRO_2 = Self(
        Self.AV_CODEC_ID_ADPCM_SBPRO_3._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_THP = Self(
        Self.AV_CODEC_ID_ADPCM_SBPRO_2._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_AMV = Self(
        Self.AV_CODEC_ID_ADPCM_THP._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_EA_R1 = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_AMV._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_EA_R3 = Self(
        Self.AV_CODEC_ID_ADPCM_EA_R1._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_EA_R2 = Self(
        Self.AV_CODEC_ID_ADPCM_EA_R3._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_EA_SEAD = Self(
        Self.AV_CODEC_ID_ADPCM_EA_R2._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_EA_EACS = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_EA_SEAD._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_EA_XAS = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_EA_EACS._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_EA_MAXIS_XA = Self(
        Self.AV_CODEC_ID_ADPCM_EA_XAS._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_ISS = Self(
        Self.AV_CODEC_ID_ADPCM_EA_MAXIS_XA._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_G722 = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_ISS._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_APC = Self(
        Self.AV_CODEC_ID_ADPCM_G722._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_VIMA = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_APC._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_AFC = Self(
        Self.AV_CODEC_ID_ADPCM_VIMA._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_OKI = Self(
        Self.AV_CODEC_ID_ADPCM_AFC._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_DTK = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_OKI._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_RAD = Self(
        Self.AV_CODEC_ID_ADPCM_DTK._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_G726LE = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_RAD._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_THP_LE = Self(
        Self.AV_CODEC_ID_ADPCM_G726LE._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_PSX = Self(
        Self.AV_CODEC_ID_ADPCM_THP_LE._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_AICA = Self(
        Self.AV_CODEC_ID_ADPCM_PSX._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_DAT4 = Self(
        Self.AV_CODEC_ID_ADPCM_AICA._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_MTAF = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_DAT4._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_AGM = Self(
        Self.AV_CODEC_ID_ADPCM_MTAF._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_ARGO = Self(
        Self.AV_CODEC_ID_ADPCM_AGM._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_SSI = Self(
        Self.AV_CODEC_ID_ADPCM_ARGO._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_ZORK = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_SSI._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_APM = Self(
        Self.AV_CODEC_ID_ADPCM_ZORK._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_ALP = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_APM._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_MTF = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_ALP._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_CUNNING = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_MTF._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_MOFLEX = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_CUNNING._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_ACORN = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_MOFLEX._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_XMD = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_ACORN._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_IMA_XBOX = Self(
        Self.AV_CODEC_ID_ADPCM_XMD._value + 1
    )
    comptime AV_CODEC_ID_ADPCM_SANYO = Self(
        Self.AV_CODEC_ID_ADPCM_IMA_XBOX._value + 1
    )

    # AMR
    comptime AV_CODEC_ID_AMR_NB = Self(0x12000)
    comptime AV_CODEC_ID_AMR_WB = Self(Self.AV_CODEC_ID_AMR_NB._value + 1)

    # RealAudio codecs
    comptime AV_CODEC_ID_RA_144 = Self(0x13000)
    comptime AV_CODEC_ID_RA_288 = Self(Self.AV_CODEC_ID_RA_144._value + 1)

    # various DPCM codecs
    comptime AV_CODEC_ID_ROQ_DPCM = Self(0x14000)
    comptime AV_CODEC_ID_INTERPLAY_DPCM = Self(
        Self.AV_CODEC_ID_ROQ_DPCM._value + 1
    )
    comptime AV_CODEC_ID_XAN_DPCM = Self(
        Self.AV_CODEC_ID_INTERPLAY_DPCM._value + 1
    )
    comptime AV_CODEC_ID_SOL_DPCM = Self(Self.AV_CODEC_ID_XAN_DPCM._value + 1)
    comptime AV_CODEC_ID_SDX2_DPCM = Self(Self.AV_CODEC_ID_SOL_DPCM._value + 1)
    comptime AV_CODEC_ID_GREMLIN_DPCM = Self(
        Self.AV_CODEC_ID_SDX2_DPCM._value + 1
    )
    comptime AV_CODEC_ID_DERF_DPCM = Self(
        Self.AV_CODEC_ID_GREMLIN_DPCM._value + 1
    )
    comptime AV_CODEC_ID_WADY_DPCM = Self(Self.AV_CODEC_ID_DERF_DPCM._value + 1)
    comptime AV_CODEC_ID_CBD2_DPCM = Self(Self.AV_CODEC_ID_WADY_DPCM._value + 1)

    # audio codecs
    comptime AV_CODEC_ID_MP2 = Self(0x15000)
    comptime AV_CODEC_ID_MP3 = Self(
        Self.AV_CODEC_ID_MP2._value + 1
    )  # < preferred ID for decoding MPEG audio layer 1, 2 or 3
    comptime AV_CODEC_ID_AAC = Self(Self.AV_CODEC_ID_MP3._value + 1)
    comptime AV_CODEC_ID_AC3 = Self(Self.AV_CODEC_ID_AAC._value + 1)
    comptime AV_CODEC_ID_DTS = Self(Self.AV_CODEC_ID_AC3._value + 1)
    comptime AV_CODEC_ID_VORBIS = Self(Self.AV_CODEC_ID_DTS._value + 1)
    comptime AV_CODEC_ID_DVAUDIO = Self(Self.AV_CODEC_ID_VORBIS._value + 1)
    comptime AV_CODEC_ID_WMAV1 = Self(Self.AV_CODEC_ID_DVAUDIO._value + 1)
    comptime AV_CODEC_ID_WMAV2 = Self(Self.AV_CODEC_ID_WMAV1._value + 1)
    comptime AV_CODEC_ID_MACE3 = Self(Self.AV_CODEC_ID_WMAV2._value + 1)
    comptime AV_CODEC_ID_MACE6 = Self(Self.AV_CODEC_ID_MACE3._value + 1)
    comptime AV_CODEC_ID_VMDAUDIO = Self(Self.AV_CODEC_ID_MACE6._value + 1)
    comptime AV_CODEC_ID_FLAC = Self(Self.AV_CODEC_ID_VMDAUDIO._value + 1)
    comptime AV_CODEC_ID_MP3ADU = Self(Self.AV_CODEC_ID_FLAC._value + 1)
    comptime AV_CODEC_ID_MP3ON4 = Self(Self.AV_CODEC_ID_MP3ADU._value + 1)
    comptime AV_CODEC_ID_SHORTEN = Self(Self.AV_CODEC_ID_MP3ON4._value + 1)
    comptime AV_CODEC_ID_ALAC = Self(Self.AV_CODEC_ID_SHORTEN._value + 1)
    comptime AV_CODEC_ID_WESTWOOD_SND1 = Self(Self.AV_CODEC_ID_ALAC._value + 1)
    comptime AV_CODEC_ID_GSM = Self(
        Self.AV_CODEC_ID_WESTWOOD_SND1._value + 1
    )  # < as in Berlin toast format
    comptime AV_CODEC_ID_QDM2 = Self(Self.AV_CODEC_ID_GSM._value + 1)
    comptime AV_CODEC_ID_COOK = Self(Self.AV_CODEC_ID_QDM2._value + 1)
    comptime AV_CODEC_ID_TRUESPEECH = Self(Self.AV_CODEC_ID_COOK._value + 1)
    comptime AV_CODEC_ID_TTA = Self(Self.AV_CODEC_ID_TRUESPEECH._value + 1)
    comptime AV_CODEC_ID_SMACKAUDIO = Self(Self.AV_CODEC_ID_TTA._value + 1)
    comptime AV_CODEC_ID_QCELP = Self(Self.AV_CODEC_ID_SMACKAUDIO._value + 1)
    comptime AV_CODEC_ID_WAVPACK = Self(Self.AV_CODEC_ID_QCELP._value + 1)
    comptime AV_CODEC_ID_DSICINAUDIO = Self(Self.AV_CODEC_ID_WAVPACK._value + 1)
    comptime AV_CODEC_ID_IMC = Self(Self.AV_CODEC_ID_DSICINAUDIO._value + 1)
    comptime AV_CODEC_ID_MUSEPACK7 = Self(Self.AV_CODEC_ID_IMC._value + 1)
    comptime AV_CODEC_ID_MLP = Self(Self.AV_CODEC_ID_MUSEPACK7._value + 1)
    comptime AV_CODEC_ID_GSM_MS = Self(
        Self.AV_CODEC_ID_MLP._value + 1
    )  # as found in WAV
    comptime AV_CODEC_ID_ATRAC3 = Self(Self.AV_CODEC_ID_GSM_MS._value + 1)
    comptime AV_CODEC_ID_APE = Self(Self.AV_CODEC_ID_ATRAC3._value + 1)
    comptime AV_CODEC_ID_NELLYMOSER = Self(Self.AV_CODEC_ID_APE._value + 1)
    comptime AV_CODEC_ID_MUSEPACK8 = Self(
        Self.AV_CODEC_ID_NELLYMOSER._value + 1
    )
    comptime AV_CODEC_ID_SPEEX = Self(Self.AV_CODEC_ID_MUSEPACK8._value + 1)
    comptime AV_CODEC_ID_WMAVOICE = Self(Self.AV_CODEC_ID_SPEEX._value + 1)
    comptime AV_CODEC_ID_WMAPRO = Self(Self.AV_CODEC_ID_WMAVOICE._value + 1)
    comptime AV_CODEC_ID_WMALOSSLESS = Self(Self.AV_CODEC_ID_WMAPRO._value + 1)
    comptime AV_CODEC_ID_ATRAC3P = Self(Self.AV_CODEC_ID_WMALOSSLESS._value + 1)
    comptime AV_CODEC_ID_EAC3 = Self(Self.AV_CODEC_ID_ATRAC3P._value + 1)
    comptime AV_CODEC_ID_SIPR = Self(Self.AV_CODEC_ID_EAC3._value + 1)
    comptime AV_CODEC_ID_MP1 = Self(Self.AV_CODEC_ID_SIPR._value + 1)
    comptime AV_CODEC_ID_TWINVQ = Self(Self.AV_CODEC_ID_MP1._value + 1)
    comptime AV_CODEC_ID_TRUEHD = Self(Self.AV_CODEC_ID_TWINVQ._value + 1)
    comptime AV_CODEC_ID_MP4ALS = Self(Self.AV_CODEC_ID_TRUEHD._value + 1)
    comptime AV_CODEC_ID_ATRAC1 = Self(Self.AV_CODEC_ID_MP4ALS._value + 1)
    comptime AV_CODEC_ID_BINKAUDIO_RDFT = Self(
        Self.AV_CODEC_ID_ATRAC1._value + 1
    )
    comptime AV_CODEC_ID_BINKAUDIO_DCT = Self(
        Self.AV_CODEC_ID_BINKAUDIO_RDFT._value + 1
    )
    comptime AV_CODEC_ID_AAC_LATM = Self(
        Self.AV_CODEC_ID_BINKAUDIO_DCT._value + 1
    )
    comptime AV_CODEC_ID_QDMC = Self(Self.AV_CODEC_ID_AAC_LATM._value + 1)
    comptime AV_CODEC_ID_CELT = Self(Self.AV_CODEC_ID_QDMC._value + 1)
    comptime AV_CODEC_ID_G723_1 = Self(Self.AV_CODEC_ID_CELT._value + 1)
    comptime AV_CODEC_ID_G729 = Self(Self.AV_CODEC_ID_G723_1._value + 1)
    comptime AV_CODEC_ID_8SVX_EXP = Self(Self.AV_CODEC_ID_G729._value + 1)
    comptime AV_CODEC_ID_8SVX_FIB = Self(Self.AV_CODEC_ID_8SVX_EXP._value + 1)
    comptime AV_CODEC_ID_BMV_AUDIO = Self(Self.AV_CODEC_ID_8SVX_FIB._value + 1)
    comptime AV_CODEC_ID_RALF = Self(Self.AV_CODEC_ID_BMV_AUDIO._value + 1)
    comptime AV_CODEC_ID_IAC = Self(Self.AV_CODEC_ID_RALF._value + 1)
    comptime AV_CODEC_ID_ILBC = Self(Self.AV_CODEC_ID_IAC._value + 1)
    comptime AV_CODEC_ID_OPUS = Self(Self.AV_CODEC_ID_ILBC._value + 1)
    comptime AV_CODEC_ID_COMFORT_NOISE = Self(Self.AV_CODEC_ID_OPUS._value + 1)
    comptime AV_CODEC_ID_TAK = Self(Self.AV_CODEC_ID_COMFORT_NOISE._value + 1)
    comptime AV_CODEC_ID_METASOUND = Self(Self.AV_CODEC_ID_TAK._value + 1)
    comptime AV_CODEC_ID_PAF_AUDIO = Self(Self.AV_CODEC_ID_METASOUND._value + 1)
    comptime AV_CODEC_ID_ON2AVC = Self(Self.AV_CODEC_ID_PAF_AUDIO._value + 1)
    comptime AV_CODEC_ID_DSS_SP = Self(Self.AV_CODEC_ID_ON2AVC._value + 1)
    comptime AV_CODEC_ID_CODEC2 = Self(Self.AV_CODEC_ID_DSS_SP._value + 1)
    comptime AV_CODEC_ID_FFWAVESYNTH = Self(Self.AV_CODEC_ID_CODEC2._value + 1)
    comptime AV_CODEC_ID_SONIC = Self(Self.AV_CODEC_ID_FFWAVESYNTH._value + 1)
    comptime AV_CODEC_ID_SONIC_LS = Self(Self.AV_CODEC_ID_SONIC._value + 1)
    comptime AV_CODEC_ID_EVRC = Self(Self.AV_CODEC_ID_SONIC_LS._value + 1)
    comptime AV_CODEC_ID_SMV = Self(Self.AV_CODEC_ID_EVRC._value + 1)
    comptime AV_CODEC_ID_DSD_LSBF = Self(Self.AV_CODEC_ID_SMV._value + 1)
    comptime AV_CODEC_ID_DSD_MSBF = Self(Self.AV_CODEC_ID_DSD_LSBF._value + 1)
    comptime AV_CODEC_ID_DSD_LSBF_PLANAR = Self(
        Self.AV_CODEC_ID_DSD_MSBF._value + 1
    )
    comptime AV_CODEC_ID_DSD_MSBF_PLANAR = Self(
        Self.AV_CODEC_ID_DSD_LSBF_PLANAR._value + 1
    )
    comptime AV_CODEC_ID_4GV = Self(Self.AV_CODEC_ID_DSD_MSBF_PLANAR._value + 1)
    comptime AV_CODEC_ID_INTERPLAY_ACM = Self(Self.AV_CODEC_ID_4GV._value + 1)
    comptime AV_CODEC_ID_XMA1 = Self(Self.AV_CODEC_ID_INTERPLAY_ACM._value + 1)
    comptime AV_CODEC_ID_XMA2 = Self(Self.AV_CODEC_ID_XMA1._value + 1)
    comptime AV_CODEC_ID_DST = Self(Self.AV_CODEC_ID_XMA2._value + 1)
    comptime AV_CODEC_ID_ATRAC3AL = Self(Self.AV_CODEC_ID_DST._value + 1)
    comptime AV_CODEC_ID_ATRAC3PAL = Self(Self.AV_CODEC_ID_ATRAC3AL._value + 1)
    comptime AV_CODEC_ID_DOLBY_E = Self(Self.AV_CODEC_ID_ATRAC3PAL._value + 1)
    comptime AV_CODEC_ID_APTX = Self(Self.AV_CODEC_ID_DOLBY_E._value + 1)
    comptime AV_CODEC_ID_APTX_HD = Self(Self.AV_CODEC_ID_APTX._value + 1)
    comptime AV_CODEC_ID_SBC = Self(Self.AV_CODEC_ID_APTX_HD._value + 1)
    comptime AV_CODEC_ID_ATRAC9 = Self(Self.AV_CODEC_ID_SBC._value + 1)
    comptime AV_CODEC_ID_HCOM = Self(Self.AV_CODEC_ID_ATRAC9._value + 1)
    comptime AV_CODEC_ID_ACELP_KELVIN = Self(Self.AV_CODEC_ID_HCOM._value + 1)
    comptime AV_CODEC_ID_MPEGH_3D_AUDIO = Self(
        Self.AV_CODEC_ID_ACELP_KELVIN._value + 1
    )
    comptime AV_CODEC_ID_SIREN = Self(
        Self.AV_CODEC_ID_MPEGH_3D_AUDIO._value + 1
    )
    comptime AV_CODEC_ID_HCA = Self(Self.AV_CODEC_ID_SIREN._value + 1)
    comptime AV_CODEC_ID_FASTAUDIO = Self(Self.AV_CODEC_ID_HCA._value + 1)
    comptime AV_CODEC_ID_MSNSIREN = Self(Self.AV_CODEC_ID_FASTAUDIO._value + 1)
    comptime AV_CODEC_ID_DFPWM = Self(Self.AV_CODEC_ID_MSNSIREN._value + 1)
    comptime AV_CODEC_ID_BONK = Self(Self.AV_CODEC_ID_DFPWM._value + 1)
    comptime AV_CODEC_ID_MISC4 = Self(Self.AV_CODEC_ID_BONK._value + 1)
    comptime AV_CODEC_ID_APAC = Self(Self.AV_CODEC_ID_MISC4._value + 1)
    comptime AV_CODEC_ID_FTR = Self(Self.AV_CODEC_ID_APAC._value + 1)
    comptime AV_CODEC_ID_WAVARC = Self(Self.AV_CODEC_ID_FTR._value + 1)
    comptime AV_CODEC_ID_RKA = Self(Self.AV_CODEC_ID_WAVARC._value + 1)
    comptime AV_CODEC_ID_AC4 = Self(Self.AV_CODEC_ID_RKA._value + 1)
    comptime AV_CODEC_ID_OSQ = Self(Self.AV_CODEC_ID_AC4._value + 1)
    comptime AV_CODEC_ID_QOA = Self(Self.AV_CODEC_ID_OSQ._value + 1)
    comptime AV_CODEC_ID_LC3 = Self(Self.AV_CODEC_ID_QOA._value + 1)
    comptime AV_CODEC_ID_G728 = Self(Self.AV_CODEC_ID_LC3._value + 1)

    # subtitle codecs
    comptime AV_CODEC_ID_FIRST_SUBTITLE = Self(
        0x17000
    )  # < A dummy ID pointing at the start of subtitle codecs.
    comptime AV_CODEC_ID_DVD_SUBTITLE = Self(0x17000)
    comptime AV_CODEC_ID_DVB_SUBTITLE = Self(
        Self.AV_CODEC_ID_DVD_SUBTITLE._value + 1
    )
    comptime AV_CODEC_ID_TEXT = Self(
        Self.AV_CODEC_ID_DVB_SUBTITLE._value + 1
    )  # < raw UTF-8 text
    comptime AV_CODEC_ID_XSUB = Self(Self.AV_CODEC_ID_TEXT._value + 1)
    comptime AV_CODEC_ID_SSA = Self(Self.AV_CODEC_ID_XSUB._value + 1)
    comptime AV_CODEC_ID_MOV_TEXT = Self(Self.AV_CODEC_ID_SSA._value + 1)
    comptime AV_CODEC_ID_HDMV_PGS_SUBTITLE = Self(
        Self.AV_CODEC_ID_MOV_TEXT._value + 1
    )
    comptime AV_CODEC_ID_DVB_TELETEXT = Self(
        Self.AV_CODEC_ID_HDMV_PGS_SUBTITLE._value + 1
    )
    comptime AV_CODEC_ID_SRT = Self(Self.AV_CODEC_ID_DVB_TELETEXT._value + 1)
    comptime AV_CODEC_ID_MICRODVD = Self(Self.AV_CODEC_ID_SRT._value + 1)
    comptime AV_CODEC_ID_EIA_608 = Self(Self.AV_CODEC_ID_MICRODVD._value + 1)
    comptime AV_CODEC_ID_JACOSUB = Self(Self.AV_CODEC_ID_EIA_608._value + 1)
    comptime AV_CODEC_ID_SAMI = Self(Self.AV_CODEC_ID_JACOSUB._value + 1)
    comptime AV_CODEC_ID_REALTEXT = Self(Self.AV_CODEC_ID_SAMI._value + 1)
    comptime AV_CODEC_ID_STL = Self(Self.AV_CODEC_ID_REALTEXT._value + 1)
    comptime AV_CODEC_ID_SUBVIEWER1 = Self(Self.AV_CODEC_ID_STL._value + 1)
    comptime AV_CODEC_ID_SUBVIEWER = Self(
        Self.AV_CODEC_ID_SUBVIEWER1._value + 1
    )
    comptime AV_CODEC_ID_SUBRIP = Self(Self.AV_CODEC_ID_SUBVIEWER._value + 1)
    comptime AV_CODEC_ID_WEBVTT = Self(Self.AV_CODEC_ID_SUBRIP._value + 1)
    comptime AV_CODEC_ID_MPL2 = Self(Self.AV_CODEC_ID_WEBVTT._value + 1)
    comptime AV_CODEC_ID_VPLAYER = Self(Self.AV_CODEC_ID_MPL2._value + 1)
    comptime AV_CODEC_ID_PJS = Self(Self.AV_CODEC_ID_VPLAYER._value + 1)
    comptime AV_CODEC_ID_ASS = Self(Self.AV_CODEC_ID_PJS._value + 1)
    comptime AV_CODEC_ID_HDMV_TEXT_SUBTITLE = Self(
        Self.AV_CODEC_ID_ASS._value + 1
    )
    comptime AV_CODEC_ID_TTML = Self(
        Self.AV_CODEC_ID_HDMV_TEXT_SUBTITLE._value + 1
    )
    comptime AV_CODEC_ID_ARIB_CAPTION = Self(Self.AV_CODEC_ID_TTML._value + 1)
    comptime AV_CODEC_ID_IVTV_VBI = Self(
        Self.AV_CODEC_ID_ARIB_CAPTION._value + 1
    )

    # other specific kind of codecs (generally used for attachments)
    comptime AV_CODEC_ID_FIRST_UNKNOWN = Self(
        0x18000
    )  # < A dummy ID pointing at the start of various fake codecs.
    comptime AV_CODEC_ID_TTF = Self(0x18000)
    comptime AV_CODEC_ID_SCTE_35 = Self(
        Self.AV_CODEC_ID_TTF._value + 1
    )  # < Contain timestamp estimated through PCR of program stream.
    comptime AV_CODEC_ID_EPG = Self(Self.AV_CODEC_ID_SCTE_35._value + 1)
    comptime AV_CODEC_ID_BINTEXT = Self(Self.AV_CODEC_ID_EPG._value + 1)
    comptime AV_CODEC_ID_XBIN = Self(Self.AV_CODEC_ID_BINTEXT._value + 1)
    comptime AV_CODEC_ID_IDF = Self(Self.AV_CODEC_ID_XBIN._value + 1)
    comptime AV_CODEC_ID_OTF = Self(Self.AV_CODEC_ID_IDF._value + 1)
    comptime AV_CODEC_ID_SMPTE_KLV = Self(Self.AV_CODEC_ID_OTF._value + 1)
    comptime AV_CODEC_ID_DVD_NAV = Self(Self.AV_CODEC_ID_SMPTE_KLV._value + 1)
    comptime AV_CODEC_ID_TIMED_ID3 = Self(Self.AV_CODEC_ID_DVD_NAV._value + 1)
    comptime AV_CODEC_ID_BIN_DATA = Self(Self.AV_CODEC_ID_TIMED_ID3._value + 1)
    comptime AV_CODEC_ID_SMPTE_2038 = Self(Self.AV_CODEC_ID_BIN_DATA._value + 1)
    comptime AV_CODEC_ID_LCEVC = Self(Self.AV_CODEC_ID_SMPTE_2038._value + 1)
    comptime AV_CODEC_ID_SMPTE_436M_ANC = Self(
        Self.AV_CODEC_ID_LCEVC._value + 1
    )

    comptime AV_CODEC_ID_PROBE = Self(
        0x19000
    )  # < codec_id is not known (like AV_CODEC_ID_NONE) but lavf should attempt to identify it

    comptime AV_CODEC_ID_MPEG2TS = Self(
        0x20000
    )  # < _FAKE_ codec to indicate a raw MPEG-2 TS
    # * stream (only used by libavformat) */
    comptime AV_CODEC_ID_MPEG4SYSTEMS = Self(
        0x20001
    )  # < _FAKE_ codec to indicate a MPEG-4 Systems stream (only used by libavformat)
    comptime AV_CODEC_ID_FFMETADATA = Self(
        0x21000
    )  # < Dummy codec for streams containing only metadata information.
    comptime AV_CODEC_ID_WRAPPED_AVFRAME = Self(
        0x21001
    )  # < Passthrough codec, AVFrames wrapped in AVPacket

    # Dummy null video codec, useful mainly for development and debugging.
    # Null encoder/decoder discard all input and never return any output.

    comptime AV_CODEC_ID_VNULL = Self(
        Self.AV_CODEC_ID_WRAPPED_AVFRAME._value + 1
    )

    # Dummy null audio codec, useful mainly for development and debugging.
    # Null encoder/decoder discard all input and never return any output.

    comptime AV_CODEC_ID_ANULL = Self(Self.AV_CODEC_ID_VNULL._value + 1)
