#!/bin/bash
if [ ! -d third_party/modular ] && [ ! -L third_party/modular ]; then 
    cd third_party
    git clone https://github.com/modular/modular.git third_party/
else 
    echo 'Modular directory already exists.'
fi