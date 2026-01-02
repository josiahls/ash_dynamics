#!/bin/bash
if [ ! -d third_party/NuMojo ]; then 
    git clone https://github.com/josiahls/NuMojo.git third_party/NuMojo
else 
    echo 'NuMojo directory already exists.'
fi