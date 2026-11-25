# OnePlus Ace 6 — Sukisu-Nova GKI Kernel

用于一加 Ace 6 的 LineageOS 24.0 / Sukisu-Nova GKI 内核编译配置、补丁与构建记录。

## 项目目标

- Android / LineageOS 24.0
- Sukisu-Nova GKI 内核方案
- 可复现的构建配置与脚本

## 当前状态

本仓库已初始化为项目入口。开始编译前，请同步与目标设备、Android 版本和内核分支匹配的源码、设备树及工具链，并根据实际设备代号更新配置。

## 快速开始

先阅读 [`BUILDING.md`](BUILDING.md)，然后在 Linux Android 构建环境中运行：

```bash
./scripts/build-lineage-ktm.sh
./scripts/integrate-sukisu-nova.sh
```

上游仓库和版本基线记录在 [`SOURCES.md`](SOURCES.md)。

## GitHub Actions 编译

打开仓库的 **Actions → Build ktm kernel (SukiSU-Nova + SUSFS + AnyKernel3) → Run workflow**。默认会集成 SukiSU-Nova、SUSFS，并生成 `AnyKernel3-ktm-*.zip`。`CONFIG_KPM` 默认关闭；只有明确需要 KPM 时再手动开启。

工作流使用官方 LineageOS `android_kernel_oneplus_sm8750` 的 `lineage-24.0` 分支，编译 `arm64` GKI `Image`，再放入官方 AnyKernel3 模板打包。产物会作为 GitHub Actions artifact 提供下载。

## 免责声明

刷写或启动自定义内核存在数据丢失、无法启动及保修影响等风险。请在操作前备份数据，并确认文件适用于自己的设备。

请同时遵守 LineageOS、Linux、Sukisu-Nova 及相关组件的许可证要求。
