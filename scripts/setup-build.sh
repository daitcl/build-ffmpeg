#!/bin/bash

set -e

echo "Setting up build environment for FFmpeg..."
echo "Current OS: $RUNNER_OS"

if [[ "$RUNNER_OS" == "Linux" ]]; then
    # Ubuntu 24.04 环境设置
    echo "Setting up for Ubuntu Linux..."

    # 可选：如果需要，可以替换为国内镜像源以加速下载
    # 关于替换Ubuntu镜像源的具体操作，可参考[citation:3]
    # sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    # sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
    # sudo sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

    sudo apt-get update

    # 安装基础编译工具
    sudo apt-get install -y \
        autoconf automake build-essential cmake git libtool \
        nasm yasm pkg-config texinfo wget

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

    # 安装可选功能依赖（已移除有问题的包）
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
        libtwolame-dev libvdpau-dev libvo-amrwbenc-dev \
        libxvidcore-dev ocl-icd-opencl-dev

    # 尝试安装可能存在于其他源的包
    # 如果这些包非必需，可以考虑移除以简化依赖
    sudo apt-get install -y libopenjp2-7-dev || echo "libopenjp2-7-dev not available, skipping"
    sudo apt-get install -y libzmq3-dev || echo "libzmq3-dev not available, skipping" # 替代 libzmq-dev
    sudo apt-get install -y libzvbi-dev || echo "libzvbi-dev not available, skipping"

elif [[ "$RUNNER_OS" == "Windows" ]]; then
    # Windows 环境设置 (使用 MSYS2)
    echo "Setting up for Windows MSYS2 environment..."
    
    # 更新系统并安装必要工具
    pacman -Syu --noconfirm
    pacman -S --noconfirm --needed \
        git make pkg-config diffutils \
        nasm yasm \
        mingw-w64-x86_64-toolchain \
        mingw-w64-x86_64-cmake

    # 安装多媒体库依赖
    pacman -S --noconfirm --needed \
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
        mingw-w64-x86_64-x265

    # 安装其他依赖
    pacman -S --noconfirm --needed \
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