#!/bin/bash

rm -rf assimp
git clone https://github.com/assimp/assimp.git assimp
cd assimp
git checkout -b tags/v5.0.0
