#!/bin/bash
# File name: diy-part2.sh
# Description: OpenWrt DIY script - Part 2 (Ultimate ZN-M2 Lock)

echo "🚀 [阶段一] 开始物理改造高通底层代码..."

# 1. 物理移除第三方冲突包，杜绝 Rust 等环境报错
rm -rf package/feeds/packages/smartdns
rm -rf package/feeds/small8/smartdns
rm -rf package/feeds/small8/luci-app-smartdns

# 2. 基础系统参数修改
sed -i 's/ImmortalWrt/ZN-M2/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# 3. 💥 【断其后路】强行修改高通 IPQ60xx 平台的默认机型指向
# 把 Makefile 里的默认设备从 mango 强行替换为 zn_m2
TARGET_MK="target/linux/qualcommax/image/ipq60xx.mk"
if [ -f "$TARGET_MK" ]; then
    echo "🎯 发现 IPQ60xx 构建配置，正在强行篡位默认机型..."
    sed -i 's/TARGET_DEVICES += 8devices_mango-dvk/TARGET_DEVICES += zn_m2/g' $TARGET_MK
    sed -i 's/DEFAULT_MACHINE := 8devices_mango-dvk/DEFAULT_MACHINE := zn_m2/g' $TARGET_MK
fi

echo "🚀 [阶段二] 开始注入纯正 ZN-M2 配置宏..."

# 4. 生成强制配置文件（直接写入 .config 尾部）
cat <<EOF >> .config
# ==========================================
# 🎯 核心架构锁死 (ZN-M2)
# ==========================================
CONFIG_TARGET_qualcommax=y
CONFIG_TARGET_qualcommax_ipq60xx=y
CONFIG_TARGET_qualcommax_ipq60xx_DEVICE_zn_m2=y

# ==========================================
# 💥 斩断 FIT (ITB) 镜像，强制生成传统 Squashfs
# ==========================================
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_TARGET_ROOTFS_INITRAMFS=n
CONFIG_TARGET_FITIMAGE=n
CONFIG_TARGET_FITIMAGE_ARCH_TYPE=""

# ==========================================
# 🚫 强力干掉容易炸机的组件
# ==========================================
CONFIG_PACKAGE_smartdns=n
CONFIG_PACKAGE_luci-app-smartdns=n
CONFIG_PACKAGE_adguardhome=n
CONFIG_PACKAGE_luci-app-adguardhome=n

# ==========================================
# 📡 纯有线主路由：抛弃多余无线驱动
# ==========================================
CONFIG_PACKAGE_kmod-ath11k=n
CONFIG_PACKAGE_kmod-ath11k-ahb=n
CONFIG_PACKAGE_kmod-ath11k-pci=n
CONFIG_PACKAGE_ath11k-firmware-ipq6018=n

# ==========================================
# 🚀 极致性能有线全功能插件配置
# ==========================================
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-lucky=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-wol=y
CONFIG_PACKAGE_luci-app-cpufreq=y
CONFIG_PACKAGE_luci-app-turboacc=y

# ==========================================
# 🎨 简体中文本地化
# ==========================================
CONFIG_PACKAGE_luci=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
EOF

echo "✅ ZN-M2 底层锁定完毕，禁止系统滑坡！"
