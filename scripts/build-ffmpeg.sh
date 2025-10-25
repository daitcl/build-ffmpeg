#!/bin/bash

set -e

cd ffmpeg-src

echo "Configuring FFmpeg with full codec support..."

# 基础配置选项
CONFIGURE_FLAGS="--enable-gpl --enable-version3 --enable-nonfree"
CONFIGURE_FLAGS+=" --enable-shared --enable-static"

# 硬件加速支持
CONFIGURE_FLAGS+=" --enable-vdpau --enable-vaapi"
CONFIGURE_FLAGS+=" --enable-opencl --enable-libdrm"

# 主要视频编码器支持 
CONFIGURE_FLAGS+=" --enable-libx264 --enable-libx265"
CONFIGURE_FLAGS+=" --enable-libvpx --enable-libvpx-vp9"
CONFIGURE_FLAGS+=" --enable-libaom --enable-libaom-av1"
CONFIGURE_FLAGS+=" --enable-libsvtav1 --enable-libdav1d"

# 专业视频编码格式
CONFIGURE_FLAGS+=" --enable-libkvazaar"    # HEVC编码器
CONFIGURE_FLAGS+=" --enable-librav1e"      # AV1编码器（Rust实现）
CONFIGURE_FLAGS+=" --enable-libtheora"     # Theora编码器

# 尝试启用可选的视频编码器
CONFIGURE_FLAGS+=" $(pkg-config --exists libxavs2 && echo '--enable-libxavs2' || echo '')"      # AVS2编码器
CONFIGURE_FLAGS+=" $(pkg-config --exists libopenh264 && echo '--enable-libopenh264' || echo '')"   # OpenH264编码器

# 主要音频编码器支持
CONFIGURE_FLAGS+=" --enable-libopus --enable-libvorbis"
CONFIGURE_FLAGS+=" --enable-libmp3lame --enable-libfdk-aac"

# 专业音频编码格式
CONFIGURE_FLAGS+=" --enable-libtwolame"    # MP2编码器
CONFIGURE_FLAGS+=" --enable-libspeex"      # Speex编码器
CONFIGURE_FLAGS+=" --enable-libwavpack"    # WavPack无损编码

# 容器和协议支持
CONFIGURE_FLAGS+=" --enable-libwebp --enable-libass"
CONFIGURE_FLAGS+=" --enable-libfreetype --enable-libfontconfig"
CONFIGURE_FLAGS+=" --enable-libzimg --enable-librtmp"
CONFIGURE_FLAGS+=" --enable-libssh --enable-libsmbclient"

# 高级功能支持
CONFIGURE_FLAGS+=" --enable-libbluray --enable-libcaca"
CONFIGURE_FLAGS+=" --enable-libcdio --enable-libchromaprint"
CONFIGURE_FLAGS+=" --enable-libdc1394 --enable-libflite"
CONFIGURE_FLAGS+=" --enable-libgme --enable-libgsm"
CONFIGURE_FLAGS+=" --enable-libmodplug --enable-libopencore-amrnb"
CONFIGURE_FLAGS+=" --enable-libopencore-amrwb --enable-libopenjpeg"
CONFIGURE_FLAGS+=" --enable-libpulse --enable-librubberband"
CONFIGURE_FLAGS+=" --enable-libshine --enable-libsnappy"
CONFIGURE_FLAGS+=" --enable-libsoxr --enable-libsrt"
CONFIGURE_FLAGS+=" --enable-libtesseract --enable-libv4l2"
CONFIGURE_FLAGS+=" --enable-libxcb --enable-libxvid"
CONFIGURE_FLAGS+=" --enable-libzmq --enable-libzvbi"

# 硬件特定优化
CONFIGURE_FLAGS+=" --enable-avresample --enable-swresample"
CONFIGURE_FLAGS+=" --enable-postproc --enable-filters"
CONFIGURE_FLAGS+=" --enable-pthreads"

# 平台特定配置
if [[ "$RUNNER_OS" == "Windows" ]]; then
    CONFIGURE_FLAGS+=" --toolchain=msvc --arch=x86_64"
    CONFIGURE_FLAGS+=" --enable-libopenal --enable-libmfx"
    CONFIGURE_FLAGS+=" --enable-cuda --enable-cuda-llvm --enable-cuvid --enable-nvdec --enable-nvenc"
    # Windows 特定库
    CONFIGURE_FLAGS+=" --extra-cflags=-I/usr/include"
    CONFIGURE_FLAGS+=" --extra-ldflags=-L/usr/lib"
else
    # Linux 特定配置
    CONFIGURE_FLAGS+=" --enable-libpulse --enable-libjack"
    CONFIGURE_FLAGS+=" --enable-libopencore-amrnb --enable-libopencore-amrwb"
    CONFIGURE_FLAGS+=" --enable-libdc1394 --enable-libcaca"
    CONFIGURE_FLAGS+=" --enable-omx --enable-omx-rpi"
    CONFIGURE_FLAGS+=" --extra-cflags=-I/usr/local/include"
    CONFIGURE_FLAGS+=" --extra-ldflags=-L/usr/local/lib"
fi

echo "Configure flags: $CONFIGURE_FLAGS"

# 配置FFmpeg
./configure $CONFIGURE_FLAGS \
    --prefix="$GITHUB_WORKSPACE/ffmpeg-build" \
    --bindir="$GITHUB_WORKSPACE/ffmpeg-build/bin" \
    --datadir="$GITHUB_WORKSPACE/ffmpeg-build/share" \
    --docdir="$GITHUB_WORKSPACE/ffmpeg-build/doc" \
    --libdir="$GITHUB_WORKSPACE/ffmpeg-build/lib" \
    --incdir="$GITHUB_WORKSPACE/ffmpeg-build/include" \
    --pkgconfigdir="$GITHUB_WORKSPACE/ffmpeg-build/lib/pkgconfig" \
    --extra-cflags="-I$GITHUB_WORKSPACE/ffmpeg-build/include -O3 -fPIC" \
    --extra-ldflags="-L$GITHUB_WORKSPACE/ffmpeg-build/lib" \
    --extra-libs="-lpthread -lm -ldl"

# 编译并安装
echo "Building FFmpeg..."
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
make install

# 验证构建
echo "=== Build Verification ==="
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -version
echo "=== Enabled Codecs ==="
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -codecs
echo "=== Enabled Formats ==="
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -formats
echo "=== Enabled Protocols ==="
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -protocols
echo "=== Enabled Filters ==="  
"$GITHUB_WORKSPACE/ffmpeg-build/bin/ffmpeg" -filters

echo "FFmpeg build with all codecs completed successfully!"