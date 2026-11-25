# OnePlus Ace 6 — LineageOS 24.0 SukiSU-Nova Kernel

用于一加 Ace 6（设备代号 `ktm`，型号 `PLQ110`）的 LineageOS 24.0 / Android 15 GKI 6.6 内核构建项目。

本项目通过 GitHub Actions 同步官方 SM8750 内核源码、模块和设备树，使用官方 Android Clang 工具链编译，并将内核打包为可通过 AnyKernel3 刷写的 ZIP。

## 已验证状态

当前默认目标配置已经在一加 Ace 6 + 官方 LineageOS 24.0 nightly 上完成验证：

- 可以正常启动，不会卡在第一屏；
- SukiSU-Nova Root 获取正常；
- SUSFS 功能可用；
- 普通系统进程的 Seccomp 过滤正常；
- `CONFIG_KPM` 默认关闭；
- 目标设备为 A/B 分区布局，刷写目标为 `boot` 分区。

## 默认组件

- 设备：OnePlus Ace 6 / `ktm` / `PLQ110`
- ROM：LineageOS 24.0
- 内核基线：`LineageOS/android_kernel_oneplus_sm8750`
- 内核分支：`lineage-24.0`
- 内核版本基线：6.6.x
- 架构：ARM64 GKI
- Root：SukiSU-Nova
- SUSFS：`gki-android15-6.6`
- 打包方式：AnyKernel3
- 编译工具链：官方 Android Clang 22.0.2

## GitHub Actions 编译

进入仓库的 **Actions → Build ktm kernel (SukiSU-Nova + SUSFS + AnyKernel3)**，点击 **Run workflow**。

默认工作流会：

1. 同步官方 SM8750 内核、模块和设备树源码；
2. 配置 `ktm` 所需的设备树选项；
3. 集成 SukiSU-Nova；
4. 应用 SUSFS 6.6 内核补丁并启用 SUSFS；
5. 使用官方 Android Clang 编译 ARM64 `Image`；
6. 打包 `AnyKernel3-ktm-*.zip`；
7. 上传 AnyKernel3 ZIP 和内核 Image artifact。

工作流支持关闭 SUSFS 的构建选项。关闭 SUSFS 时会切换到适用于 GKI/Kprobes 的 SukiSU 分支；默认情况下建议保持 SUSFS 开启。

## 下载构建产物

构建完成后，在对应的 GitHub Actions run 页面底部下载：

- `AnyKernel3-ktm-*.zip`：推荐刷写的内核包；
- `Image-*`：仅供调试或二次打包使用的内核镜像。

不要把 Actions artifact 当作 Magisk 模块安装。AnyKernel3 ZIP 应通过支持该设备的自定义 Recovery 或内核刷写工具刷入。

## 刷写前注意事项

刷写前请确认：

- 当前系统是与构建目标匹配的 LineageOS 24.0 `ktm` ROM；
- 已备份原始 boot 镜像或准备好官方 ROM 回滚包；
- 已解锁 Bootloader；
- ZIP 文件来自可信的 GitHub Actions 构建；
- 设备电量充足，并且知道如何进入 Recovery / Fastboot 进行恢复。

刷写自定义内核可能导致无法启动、数据丢失或影响保修。首次刷写建议保留官方 boot 镜像，以便出现问题时及时恢复。

## 本地文件

- [`BUILDING.md`](BUILDING.md)：构建、刷写和回滚说明；
- [`SOURCES.md`](SOURCES.md)：源码、分支、工具链和补丁来源记录；
- [`.github/workflows/build-kernel.yml`](.github/workflows/build-kernel.yml)：GitHub Actions 主工作流；
- [`anykernel/anykernel.sh`](anykernel/anykernel.sh)：AnyKernel3 刷写脚本。

本仓库不提交完整 Android 源码、Clang 工具链或大型构建产物；所有构建产物均由 GitHub Actions artifact 提供。

## 免责声明

刷写或使用自定义内核存在无法启动、数据丢失、安全策略变化及保修影响等风险。请自行确认设备型号、ROM 版本和刷写方式，并在操作前做好备份。

请遵守 LineageOS、Linux、SukiSU-Nova、SUSFS、AnyKernel3 及其他上游项目的许可证和使用要求。
