# 构建准备说明

## 环境

1. 准备与 LineageOS 24.0 匹配的 Linux Android 构建环境。
2. 安装官方 LineageOS 构建依赖、`repo`、Git LFS、Python 和 `ccache`。
3. 预留足够的磁盘空间、内存和网络带宽。完整 Android 源码不放在本仓库中。

## 自动准备源码

在本仓库目录执行：

```bash
./scripts/build-lineage-ktm.sh
```

也可以用 `LINEAGE_TOP` 指定源码目录：

```bash
LINEAGE_TOP="$HOME/android/lineage" ./scripts/build-lineage-ktm.sh
```

脚本会初始化并同步 `lineage-24.0`，执行 `breakfast ktm`，然后提示提取专有文件和启动构建。

## 集成 SukiSU Nova

完成 `breakfast ktm` 后，在本仓库目录执行：

```bash
./scripts/integrate-sukisu-nova.sh
```

脚本默认处理 `kernel/oneplus/sm8750`，使用 SukiSU Nova 官方 `main` 集成路径。集成后请检查内核配置，再运行：

```bash
cd "$HOME/android/lineage"
source build/envsetup.sh
brunch ktm
```

## 专有文件

官方设备指南要求从正在运行相同 LineageOS 分支的设备提取专有文件：

```bash
cd device/oneplus/ktm
./extract-files.py
```

如果设备目录中使用的是 shell 脚本，则改用 `./extract-files.sh`。也可以按照 LineageOS 官方文档从可安装 ZIP 提取。

## 安全提醒

刷写或启动自定义内核存在数据丢失、无法启动及保修影响等风险。操作前备份数据，并确认文件适用于自己的设备。不要把私钥、签名材料、专有 blobs 或构建产物提交到公开仓库。

## 刷写方式

AnyKernel3 ZIP 包含官方 `magiskboot` 和 ARM64 BusyBox。若 SukiSU-Nova Manager 显示 `Busybox setup failed`，这是刷写器环境兼容问题，不代表内核编译失败。此时优先使用 TWRP/LineageOS Recovery 的 Install 功能，或使用 Horizon Kernel Flasher 刷写 ZIP；不要在没有备份原始 `boot.img` 的情况下继续尝试。

刷写前确认设备已解锁 Bootloader，并保留当前槽位的原始 `boot` 镜像。OnePlus Ace 6 是 A/B 设备，刷写后若无法启动，应从另一槽位或 Fastboot 恢复原始 boot 镜像。
