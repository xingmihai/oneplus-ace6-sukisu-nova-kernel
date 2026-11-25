# 源码、版本与构建基线

本项目面向一加 Ace 6（设备代号 `ktm`，型号 `PLQ110`），目标 ROM 为官方 LineageOS 24.0 `ktm` nightly。GitHub Actions 只同步内核相关源码，不将完整 Android 源码或大型构建产物提交到仓库。

## 设备与 ROM

- 设备：OnePlus Ace 6
- 设备代号：`ktm`
- 型号：`PLQ110`
- ROM：LineageOS 24.0 / Android 15
- 已验证 ROM：`lineage-24.0-20261120-nightly-ktm-signed.zip`
- 官方构建页面：<https://download.lineageos.org/devices/ktm/builds>
- 架构：`arm64`
- Boot header：v4
- 设备分区布局：A/B
- 内核刷写目标：`boot`

## 官方 LineageOS 源码

公共 Android、设备树和内核仓库均使用 `lineage-24.0` 分支：

- Android manifest：<https://github.com/LineageOS/android.git>
- ktm 设备树：<https://github.com/LineageOS/android_device_oneplus_ktm.git>
- SM8750 公共设备树：<https://github.com/LineageOS/android_device_oneplus_sm8750-common.git>
- SM8750 内核：<https://github.com/LineageOS/android_kernel_oneplus_sm8750.git>
- SM8750 modules：<https://github.com/LineageOS/android_kernel_oneplus_sm8750-modules.git>
- SM8750 device trees：<https://github.com/LineageOS/android_kernel_oneplus_sm8750-devicetrees.git>

GitHub Actions 的内核构建以 `android_kernel_oneplus_sm8750` 为主源码树，并将 modules 和 device trees 放置到官方 Kbuild 期望的位置。

已核对的官方内核基线版本为：

```text
6.6.144-4k-g01ee97578159
```

官方 LineageOS ktm 配置包含：

```make
BOARD_BOOT_HEADER_VERSION := 4
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
TARGET_NEEDS_DTBOIMAGE := true
TARGET_KERNEL_SOURCE := kernel/oneplus/sm8750
TARGET_KERNEL_CONFIG := gki_defconfig vendor/sun_perf.config vendor/oplus/sun_perf.config
TARGET_KERNEL_ADDITIONAL_FLAGS += CONFIG_OPLUS_DEVICE_DTBS=y CONFIG_KTM_DTB=y
```

工作流同时传入以下设备树相关配置：

```text
CONFIG_OPLUS_DEVICE_DTBS=y
CONFIG_KTM_DTB=y
```

## 编译工具链

使用与官方 LineageOS ktm `boot.img` 编译器字符串匹配的 Android Clang：

- 工具链：Android Clang
- 版本：22.0.2
- 目录：`clang-r596125`
- 架构：ARM64

此前使用 Ubuntu Clang 编译的包无法正常启动；改用官方 Android Clang 22.0.2 后，生成的内核与官方基线匹配并完成启动验证。

## SukiSU-Nova

- 上游仓库：<https://github.com/SukiSU-Nova/SukiSU-Nova.git>
- GKI/Kprobes 集成路径：`main`
- SUSFS 集成路径：`builtin`
- 官方集成文档：<https://sukisu.org/zh/guide/how-to-integrate>

工作流逻辑如下：

- `susfs=true`：使用 SukiSU `builtin` 分支，并应用 SUSFS Android 15 / 6.6 补丁；
- `susfs=false`：使用适用于 GKI 的 SukiSU `main` 分支，并启用 Kprobes；
- `CONFIG_KPM` 默认关闭。

`builtin-new` 不是当前工作流的默认路径；在本设备和当前基线下，曾使用该路径导致 Manager 获取 Root 失败，因此不应随意替换。

## SUSFS

- 上游仓库：<https://gitlab.com/simonpunk/susfs4ksu.git>
- 分支：`gki-android15-6.6`
- 使用补丁：`50_add_susfs_in_gki-android15-6.6.patch`

最终验证配置包含：

```text
CONFIG_KSU=y
CONFIG_KSU_SUSFS=y
CONFIG_KPROBES=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
CONFIG_SECURITY_SELINUX=y
```

`CONFIG_KPM` 未启用。已验证最终 AnyKernel3 包可以正常启动、获取 Root，并使用 SUSFS 功能。

## AnyKernel3

- 打包方式：AnyKernel3
- 目标设备：`ktm` / `PLQ110`
- 目标分区：`boot`
- 分区布局：A/B
- 产物格式：`AnyKernel3-ktm-*.zip`

AnyKernel3 模板和刷写脚本位于仓库的 `anykernel/` 目录。仓库不提交大型构建产物；ZIP 和 Image 仅作为 GitHub Actions artifact 生成和下载。

## 版本与许可证说明

源码分支、提交和补丁版本以 GitHub Actions 运行时的工作流配置为准。上游仓库可能随时间更新，因此刷写前应重新确认目标 ROM、设备代号和构建产物来源。

请遵守 LineageOS、Linux、SukiSU-Nova、SUSFS、AnyKernel3 以及所有其他上游组件的许可证和使用要求。不要向公开仓库提交私钥、签名材料、专有 blobs、完整 Android 源码或本地构建输出。
