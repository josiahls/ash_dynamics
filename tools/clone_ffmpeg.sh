#!/bin/bash
if [ ! -d third_party/ffmpeg ]; then 
    git clone https://github.com/FFmpeg/FFmpeg.git third_party/ffmpeg -b release/8.0
else 
    echo 'FFmpeg directory already exists.'
fi