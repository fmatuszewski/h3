#!/bin/bash

cd ios || exit
git clone https://github.com/uber/h3

mkdir lib || echo "Build folder exists"
cd lib
cmake ..
make h3
