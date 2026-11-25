# 构建、刷写与回滚说明

本项目的主要用途是通过 GitHub Actions 编译一加 Ace 6（`ktm` / `PLQ110`）的 LineageOS 24.0 GKI 6.6 内核，并生成 AnyKernel3 ZIP。仓库不包含完整 Android 源码或大型工具链。

## 推荐方式：GitHub Actions

1. 打开仓库的 **Actions** 页面。
2. 选择 **Build ktm kernel (SukiSU-Nova + SUSFS + AnyKernel3)**。
3. 点击 **Run workflow**。
4. 默认保持 SukiSU-Nova 和 SUSFS 开启，`CONFIG_KPM` 保持关闭。
5. 等待工作流完成，在 run 页面底部下载 AnyKernel3 artifact。

工作流会自动完成以下步骤：

- 同步 `android_kernel_oneplus_sm8750`、`sm8750-modules` 和 `sm8750-devicetrees`；
- 使用 `lineage-24.0` 分支；
- 传入 `CONFIG_OPLUS_DEVICE_DTBS=y CONFIG_KTM_DTB=y`；
- 使用官方 Android Clang 22.0.2（`clang-r596125`）；
- 集成 SukiSU-Nova；
- 应用 SUSFS `gki-android15-6.6` 补丁；
- 编译 ARM64 GKI `Image`；
- 打包 `AnyKernel3-ktm-*.zip` 并上传 artifact。

### 构建选项

默认配置适用于已经验证的 SUSFS 方案：

```text
SukiSU-Nova: enabled
SUSFS:       enabled
KPM:         disabled
```

如果仅需要不带 SUSFS 的 SukiSU-Nova GKI 内核，可以在手动运行工作流时关闭 SUSFS。关闭 SUSFS 时，工作流使用适用于 GKI/Kprobes 的 SukiSU `main` 集成路径；启用 SUSFS 时使用 `builtin` 路径并应用 SUSFS 6.6 补丁。

## 构建产物

每次成功运行会上传：

- `AnyKernel3-ktm-*.zip`：推荐使用的刷写包；
- `Image-*`：原始内核镜像，仅供调试或二次打包。

不要将 AnyKernel3 ZIP 当作 Magisk 模块安装，也不要将原始 `Image` 直接刷入未经确认的分区。

## 本地辅助脚本

仓库中的脚本主要用于需要完整 LineageOS 源码树的本地开发场景，不是 GitHub Actions 的必要步骤。

初始化或同步本地 LineageOS 源码：

```bash
./scripts/build-lineage-ktm.sh
```

也可以指定源码目录：

```bash
LINEAGE_TOP="$HOME/android/lineage" ./scripts/build-lineage-ktm.sh
```

完成 `breakfast ktm` 后，可执行 SukiSU-Nova 集成辅助脚本：

```bash
./scripts/integrate-sukisu-nova.sh
```

本地完整 LineageOS 构建还需要按照 LineageOS 官方设备指南准备专有文件和构建依赖。本仓库只负责内核相关配置，不提供完整 ROM 构建环境。

## 刷写前检查

刷写前请确认：

- 设备是 OnePlus Ace 6，代号为 `ktm`，型号为 `PLQ110`；
- 当前 ROM 与目标匹配，即 LineageOS 24.0 `ktm` 构建；
- Bootloader 已解锁；
- 已备份当前 boot 镜像，或已准备好官方 ROM 和回滚方案；
- ZIP 来自可信的 GitHub Actions 构建；
- 电量充足，并且知道如何进入 Recovery / Fastboot。

首次刷写建议保留官方 `boot.img`。如果设备无法启动，应立即恢复原始 boot，而不是反复刷写未经验证的包。

## 刷写 AnyKernel3 ZIP

AnyKernel3 ZIP 的目标是设备的 `boot` 分区，设备采用 A/B 分区布局。推荐使用支持 AnyKernel3 的自定义 Recovery 或内核刷写工具：

1. 进入 Recovery 或系统中的可信内核刷写工具；
2. 选择 `AnyKernel3-ktm-*.zip`；
3. 确认设备型号和目标分区；
4. 完成刷写后重启；
5. 使用 SukiSU-Nova Manager 检查 Root 和 SUSFS 状态。

如果 Manager 或其他刷写器提示 `Busybox setup failed`，通常是刷写器环境兼容问题，不等同于内核编译失败。可以改用 Recovery 的 Install 功能或其他支持 AnyKernel3 的刷写工具。

## 刷写后检查

启动系统后，可检查 Root：

```bash
su -c id
```

也可以检查普通系统进程的 Seccomp 状态：

```bash
su -c '
PID=$(pidof com.android.systemui | awk "{print \$1}")
grep -E "Uid|Seccomp|Seccomp_filters" /proc/$PID/status
'
```

普通系统进程通常应看到 `Seccomp: 2` 和至少一个过滤器。Root shell 可能显示 `Seccomp: 0`，这是 SukiSU 为避免 Root 操作被过滤而清除当前 Root 进程过滤器的预期行为，不代表内核全局关闭 Seccomp。

## 回滚

如果刷写后卡开机或无法进入系统：

1. 不要清除数据；
2. 进入 Recovery 或 Fastboot；
3. 恢复刷写前备份的原始 `boot.img`，或恢复匹配的官方 ROM；
4. 确认设备重新启动后，再分析构建日志和设备日志。

刷写自定义内核可能造成无法启动、数据丢失、安全策略变化或保修影响。所有操作请自行承担风险。
