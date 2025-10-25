#!/bin/bash

set -e

cd ffmpeg-src

# 基础配置选项
CONFIGURE_FLAGS="--enable-gpl --enable-version3 --enable-nonfree"
CONFIGURE_FLAGS+=" --enable-shared --enable-static"

# 硬件加速支持
CONFIGURE_FLAGS+=" --enable-vdpau --enable-vaapi"
CONFIGURE_FLAGS+=" --enable-opencl --enable-libdrm"

# 主要编解码器支持 [citation:3][citation:4][citation:7]
CONFIGURE_FLAGS+=" --enable-libx264 --enable-libx265"
CONFIGURE_FLAGS+=" --enable-libvpx --enable-libopus"
CONFIGURE_FLAGS+=" --enable-libmp3lame --enable-libfdk-aac"
CONFIGURE_FLAGS+=" --enable-libtheora --enable-libvorbis"

# 高级功能支持
CONFIGURE_FLAGS+=" --enable-libass --enable-libfreetype"
CONFIGURE_FLAGS+=" --enable-libfontconfig --enable-libwebp"
CONFIGURE_FLAGS+=" --enable-libzvbi --enable-librtmp"
CONFIGURE_FLAGS+=" --enable-libopenjpeg --enable-libbluray"
CONFIGURE_FLAGS+=" --enable-libsnappy --enable-libsoxr"
CONFIGURE_FLAGS+=" --enable-libzimg --enable-libssh"

# 硬件特定优化
CONFIGURE_FLAGS+=" --enable-avresample --enable-swresample"
CONFIGURE_FLAGS+=" --enable-postproc --enable-filters"

# 平台特定配置
if [[ "$RUNNER_OS" == "Windows" ]]; then
    CONFIGURE_FLAGS+=" --toolchain=msvc --arch=x86_64"
    CONFIGURE_FLAGS+=" --enable-libopenal --enable-libpulse"
    # Windows 特定库
    CONFIGURE_FLAGS+=" --enable-libmfx"
else
    # Linux 特定配置
    CONFIGURE_FLAGS+=" --enable-libv4l2 --enable-libpulse"
    CONFIGURE_FLAGS+=" --enable-libjack --enable-libopencore-amrnb"
    CONFIGURE_FLAGS+=" --enable-libopencore-amrwb"
    CONFIGURE_FLAGS+=" --enable-libdc1394 --enable-libcaca"
fi

echo "Configuring FFmpeg with options: $CONFIGURE_FLAGS"

# 配置和编译
./configure $CONFIGURE_FLAGS \
    --prefix="$GITHUB_WORKSPACE/ffmpeg-build" \
    --bindir="$GITHUB_WORKSPACE/ffmpeg-build/bin" \
    --datadir="$GITHUB_WORKSPACE/ffmpeg-build/share" \
    --docdir="$GITHUB_WORKSPACE/ffmpeg-build/doc" \
    --libdir="$GITHUB_WORKSPACE/ffmpeg-build/lib" \
    --incdir="$GITHUB_WORKSPACE/ffmpeg-build/include" \
    --pkgconfigdir="$GITHUB_WORKSPACE/ffmpeg-build/lib/pkgconfig" \
    --extra-cflags="-I$GITHUB_WORKSPACE/ffmpeg-build/include -O3" \
    --extra-ldflags="-L$GITHUB_WORKSPACE/ffmpeg-build/lib" \
    --extra-libs="-lpthread -lm"

# 编译并安装
make -j$(nproc)
make install

# 验证构建
echo "=== Build Verification ==="
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -version
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -buildconf
echo "=== Enabled Protocols ==="
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -protocols
echo "=== Enabled Filters ==="  
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -filters

echo "FFmpeg build completed successfully!"