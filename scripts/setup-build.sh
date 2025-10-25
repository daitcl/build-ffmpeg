#!/bin/bash

set -e

echo "Setting up build environment for FFmpeg..."

if [[ "$RUNNER_OS" == "Linux" ]]; then
    # Ubuntu 24.04 环境设置
    sudo apt-get update
    sudo apt-get install -y \
        autoconf automake build-essential cmake git libtool \
        nasm yasm pkg-config texinfo wget \
        libass-dev libfdk-aac-dev libfontconfig1-dev \
        libfreetype6-dev libglib2.0-dev libmp3lame-dev \
        libopus-dev libsdl2-dev libspeexdsp-dev \
        libsrtp2-dev libtheora-dev libva-dev \
        libvpx-dev libx264-dev libx265-dev \
        libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev \
        zlib1g-dev libzmq-dev libzvbi-dev liblzma-dev \
        libsnappy-dev libsoxr-dev libssh-dev \
        libwebp-dev libxml2-dev libzimg-dev \
        libopenal-dev libomxil-bellagio-dev \
        libcdio-dev libchromaprint-dev \
        libbluray-dev libavc1394-dev \
        libcaca-dev libcelt0-dev libcodec2-dev \
        libdc1394-dev libdrm-dev libflite-dev \
        libgme-dev libgsm1-dev libjack-dev \
        libmodplug-dev libopencore-amrnb-dev \
        libopencore-amrwb-dev libopenjpeg-dev \
        libpulse-dev librubberband-dev \
        librtmp-dev libshine-dev libsmbclient-dev \
        libsnappy-dev libsndio-dev libtesseract-dev \
        libtwolame-dev libvdpau-dev libvo-amrwbenc-dev \
        libxvidcore-dev libopencl-dev libavcodec-extra

elif [[ "$RUNNER_OS" == "Windows" ]]; then
    # Windows 环境设置 (使用 MSYS2)
    pacman -Syu --noconfirm
    pacman -S --noconfirm --needed \
        git make pkg-config diffutils \
        nasm yasm \
        mingw-w64-x86_64-toolchain \
        mingw-w64-x86_64-cmake \
        mingw-w64-x86_64-libass \
        mingw-w64-x86_64-fdk-aac \
        mingw-w64-x86_64-fontconfig \
        mingw-w64-x86_64-freetype \
        mingw-w64-x86_64-lame \
        mingw-w64-x86_64-libogg \
        mingw-w64-x86_64-libopus \
        mingw-w64-x86_64-libtheora \
        mingw-w64-x86_64-libvorbis \
        mingw-w64-x86_64-libvpx \
        mingw-w64-x86_64-libwebp \
        mingw-w64-x86_64-libxml2 \
        mingw-w64-x86_64-x264 \
        mingw-w64-x86_64-x265 \
        mingw-w64-x86_64-zlib \
        mingw-w64-x86_64-zimg \
        mingw-w64-x86_64-sdl2 \
        mingw-w64-x86_64-openal \
        mingw-w64-x86_64-rubberband

else
    echo "Unsupported OS: $RUNNER_OS"
    exit 1
fi

echo "Build environment setup completed successfully!"