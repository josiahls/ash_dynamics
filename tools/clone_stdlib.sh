#!/bin/bash
if [ ! -d third_party/modular ] && [ ! -L third_party/modular ]; then 
    git clone https://github.com/modular/modular.git third_party/modular
else 
    echo 'Modular directory already exists.'
fi