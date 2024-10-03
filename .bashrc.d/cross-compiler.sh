#!/bin/bash

# arm32 cross compiler
PATH="~/cross-compilers/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-linux-gnueabihf/bin:$PATH"

# arm64 cross compiler
PATH="cross-compilers/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin:$PATH"

export PATH
