#!/bin/bash
# Follow how opencv links to ffmpeg: 
# https://github.com/opencv/opencv/blob/a08565253ee098eae55e893d3f8e5d9a011440a9/CMakeLists.txt#L1631
# and
# https://github.com/microsoft/vcpkg/issues/19334
# and guidance from:
# https://www.ffmpeg.org/legal.html
# Install / configure only these packages:
# "avcodec"
# "avformat"
# "swresample"
# "swscale"

cd ./third_party/ffmpeg

# For put the built dir in the same directory. Eventually change to the default
# location on linux.
./configure \
    --prefix=$(pwd)/build \
    --enable-shared \
    --disable-avdevice \
    --disable-avfilter \
    --disable-pthreads \
    --disable-w32threads \
    --disable-os2threads \
    --disable-network \
    --disable-dwt \
    --disable-error-resilience \
    --disable-lsp \
    --disable-faan \
    --disable-iamf \
    --disable-pixelutils \
    # We want to leave these enabled.
    # --disable-avcodec 
    # --disable-swresample
    # --disable-swscale
    # --disable-avformat

make
make install