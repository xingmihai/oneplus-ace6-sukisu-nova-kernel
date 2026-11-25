# 构建基线

本项目以官方 LineageOS 24.0 的 OnePlus Ace 6（设备代号 `ktm`）构建配置为基线。

- Android / ROM：`https://github.com/LineageOS/android.git`，分支 `lineage-24.0`
- 设备树：`https://github.com/LineageOS/android_device_oneplus_ktm.git`，分支 `lineage-24.0`
- 公共设备树：`https://github.com/LineageOS/android_device_oneplus_sm8750-common.git`，分支 `lineage-24.0`
- 内核：`https://github.com/LineageOS/android_kernel_oneplus_sm8750.git`，分支 `lineage-24.0`
- Root/KPM：`https://github.com/SukiSU-Nova/SukiSU-Nova.git`，集成脚本使用官方 `main` 分支
- SUSFS：`https://gitlab.com/simonpunk/susfs4ksu.git`，使用 `gki-android15-6.6` 分支的 `50_add_susfs_in_gki-android15-6.6.patch`

官方最新 `ktm` 构建页面和构建清单应作为版本核对依据。不要把官方 Android 源码、内核完整历史或构建产物复制进本仓库；使用脚本在本地同步。

## 版本核对

截至本项目初始化时，官方页面列出的最新构建为 `lineage-24.0-20261113-nightly-ktm-signed.zip`，设备内核版本为 6.6，目标架构为 arm64。

## 注意

SukiSU Nova 官方文档将 GKI 设备的 `main` 分支列为推荐集成路径。集成后应先检查生成的 kernel config，再进行实际编译和刷写。公开仓库中不要提交私钥、签名材料、专有 blobs 或本地构建输出。

本项目启用 SUSFS 时使用 SukiSU-Nova 的 `builtin` 集成路径，并额外应用 SUSFS 官方 Android 15 / 6.6 内核补丁。SUSFS 官方的旧版 KernelSU 专用启用补丁不直接应用到 SukiSU-Nova，因此工作流不会使用该补丁。
