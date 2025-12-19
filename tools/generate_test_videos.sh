#!/bin/bash


TEST_DATA_ROOT="test_data"
mkdir -p ${TEST_DATA_ROOT}

OUTPUT_FILE_1="${TEST_DATA_ROOT}/testsrc_320x180_30fps_2s.h264"
if [ ! -f ${OUTPUT_FILE_1} ]; then
    echo "Generating ${OUTPUT_FILE_1}"
    ffmpeg -y \
        -f lavfi -i "testsrc2=size=320x180:rate=30" \
        -t 2 \
        -c:v libx264 \
        -pix_fmt yuv420p \
        -preset veryfast \
        -crf 23 \
        ${OUTPUT_FILE_1}
fi