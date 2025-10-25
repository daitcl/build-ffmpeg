#!/bin/bash

set -e

echo "Setting up build environment for FFmpeg..."
echo "Current OS: $RUNNER_OS"

if [[ "$RUNNER_OS" == "Linux" ]]; then
    # Ubuntu 24.04 环境设置 - 完整编码器支持
    echo "Setting up for Ubuntu Linux with full codec support..."

    # 更新包列表
    sudo apt-get update

    # 安装基础编译工具
    sudo apt-get install -y \
        autoconf automake build-essential cmake git libtool \
        nasm yasm pkg-config texinfo wget curl \
        cargo rustc

    # 安装核心库依赖
    sudo apt-get install -y \
        libass-dev libfdk-aac-dev libfontconfig1-dev \
        libfreetype6-dev libglib2.0-dev libmp3lame-dev \
        libopus-dev libsdl2-dev libspeexdsp-dev \
        libsrtp2-dev libtheora-dev libva-dev \
        libvpx-dev libx264-dev libx265-dev \
        libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev

    # 安装其他重要依赖
    sudo apt-get install -y \
        zlib1g-dev liblzma-dev \
        libsnappy-dev libsoxr-dev libssh-dev \
        libwebp-dev libxml2-dev libzimg-dev

    # 安装专业视频编码格式依赖
    sudo apt-get install -y \
        libkvazaar-dev \
        librav1e-dev \
        libaom-dev \
        libdav1d-dev \
        libsvtav1-dev

    # 安装专业音频编码格式依赖
    sudo apt-get install -y \
        libtwolame-dev \
        libspeex-dev \
        libwavpack-dev \
        libvorbis-dev

    # 安装可选功能依赖
    sudo apt-get install -y \
        libopenal-dev libomxil-bellagio-dev \
        libcdio-dev libchromaprint-dev \
        libbluray-dev libavc1394-dev \
        libcaca-dev libcodec2-dev \
        libdc1394-dev libdrm-dev \
        libgme-dev libgsm1-dev libjack-dev \
        libmodplug-dev libopencore-amrnb-dev \
        libopencore-amrwb-dev \
        libpulse-dev librubberband-dev \
        librtmp-dev libshine-dev libsmbclient-dev \
        libsndio-dev libtesseract-dev \
        libvdpau-dev libvo-amrwbenc-dev \
        libxvidcore-dev ocl-icd-opencl-dev

    # 尝试安装可能存在于其他源的包
    sudo apt-get install -y libopenjp2-7-dev || echo "libopenjp2-7-dev not available, skipping"
    sudo apt-get install -y libzmq3-dev || echo "libzmq3-dev not available, skipping"
    sudo apt-get install -y libzvbi-dev || echo "libzvbi-dev not available, skipping"
    
    # 尝试安装xavs2（如果可用）
    sudo apt-get install -y libxavs2-dev || echo "libxavs2-dev not available, will skip in configuration"
    
    # 尝试安装openh264（如果可用）
    sudo apt-get install -y libopenh264-dev || echo "libopenh264-dev not available, will skip in configuration"

    # 如果某些包不可用，尝试从源码编译
    echo "Installing missing codecs from source if needed..."

elif [[ "$RUNNER_OS" == "Windows" ]]; then
    # Windows环境现在由setup-msys2 Action处理
    echo "MSYS2 environment already setup by GitHub Action with all codec dependencies"
    
else
    echo "Unsupported OS: $RUNNER_OS"
    exit 1
fi

echo "Build environment setup completed successfully!"