# FFmpeg Complete Build Action

This repository provides GitHub Actions workflows to build fully-featured FFmpeg binaries for Ubuntu 24.04.3 LTS and Windows 11.

## Features

- **Complete Codec Support**: x264, x265, VPX, AAC, MP3, Opus, etc.
- **Hardware Acceleration**: VAAPI, VDPAU, OpenCL, MFX (Windows)
- **Advanced Features**: Filters, post-processing, resampling, etc.
- **Cross-platform**: Ubuntu Linux and Windows support

## Usage

### Automatic Builds
Push a tag starting with 'v' to trigger automatic builds:
```bash
git tag v1.0.0
git push origin v1.0.0

## 🚀 使用说明

1. **创建 GitHub 仓库**
   - 使用上面的结构创建新仓库
   - 确保所有脚本具有执行权限

2. **触发编译**
   ```bash
   # 创建标签触发编译
   git tag v1.0.0
   git push origin v1.0.0