#!/bin/bash
# File name: diy-part2.sh

echo "🚀 执行 ZN-M2 传统 U-Boot 兼容流..."

# 1. 直接强写基础底座，在这里锁死打包规则，干掉 ITB
cat <<EOF > .config
CONFIG_TARGET_qualcommax=y
CONFIG_TARGET_qualcommax_ipq60xx=y
CONFIG_TARGET_qualcommax_ipq60xx_DEVICE_zn_m2=y

# 💥 逼迫系统放弃打包 ITB，强制要求产出传统的 squashfs 结构
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_TARGET_FITIMAGE_ARCH_TYPE=""
# CONFIG_TARGET_UBIFS is not set

# 🚫 彻底剔除导致 Rust 报错的 SmartDNS 和大体积组件
CONFIG_PACKAGE_smartdns=n
CONFIG_PACKAGE_luci-app-smartdns=n
CONFIG_PACKAGE_adguardhome=n
CONFIG_PACKAGE_luci-app-adguardhome=n

# 📡 纯有线瘦身：屏蔽一切无线宏
CONFIG_PACKAGE_kmod-ath11k=n
CONFIG_PACKAGE_kmod-ath11k-ahb=n
CONFIG_PACKAGE_kmod-ath11k-pci=n
CONFIG_PACKAGE_ath11k-firmware-ipq6018=n

# 🎨 核心外观与必备有线满血插件
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-lucky=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-wol=y
CONFIG_PACKAGE_luci-app-cpufreq=y

# 本地化支持
CONFIG_PACKAGE_luci=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
EOF

# 2. 从源码目录树里物理切除可能引发冲突的第三方 smartdns
rm -rf package/feeds/packages/smartdns
rm -rf package/feeds/small8/smartdns
rm -rf package/feeds/small8/luci-app-smartdns

# 3. 修改主机名为 ZN-M2
sed -i 's/ImmortalWrt/ZN-M2/g' package/base-files/files/bin/config_generate
